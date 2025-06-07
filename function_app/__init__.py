import logging
import os
import datetime
import requests
import azure.functions as func
from azure.identity import DefaultAzureCredential
from azure.mgmt.network import NetworkManagementClient
from azure.data.tables import TableServiceClient, TableEntity


def get_subscription_id():
    """Dynamically get the subscription ID from Azure IMDS."""
    metadata_url = "http://169.254.169.254/metadata/instance?api-version=2021-02-01"
    headers = {"Metadata": "true"}
    response = requests.get(metadata_url, headers=headers)
    response.raise_for_status()
    return response.json()["compute"]["subscriptionId"]


def main(mytimer: func.TimerRequest) -> None:
    utc_timestamp = datetime.datetime.utcnow().isoformat()

    logging.info(f"Python timer trigger function ran at {utc_timestamp}")

    try:
        # Auth & metadata
        credential = DefaultAzureCredential()
        subscription_id = get_subscription_id()
        storage_endpoint = os.environ["TABLE_STORAGE_ENDPOINT"]
        table_name = os.environ.get("TABLE_NAME", "networkinventory")

        # Azure SDK clients
        network_client = NetworkManagementClient(credential, subscription_id)
        table_client = TableServiceClient(endpoint=storage_endpoint, credential=credential)
        table = table_client.get_table_client(table_name=table_name)

        # Gather VNets and subnets
        for vnet in network_client.virtual_networks.list_all():
            for subnet in network_client.subnets.list(vnet.resource_group_name, vnet.name):
                row = TableEntity()
                row["PartitionKey"] = "vnetsubnet"
                row["RowKey"] = f"{vnet.name}-{subnet.name}-{utc_timestamp}"
                row["VNetName"] = vnet.name
                row["SubnetName"] = subnet.name
                row["AddressPrefix"] = ", ".join(subnet.address_prefixes or [subnet.address_prefix])
                row["ResourceGroup"] = vnet.resource_group_name
                row["Location"] = vnet.location
                row["Timestamp"] = utc_timestamp
                table.upsert_entity(row)

        logging.info("Successfully stored output data in table storage.")

    except Exception as e:
        logging.error(f"Failed to store output data: {e}")
