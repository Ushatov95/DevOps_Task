import azure.functions as func
from azure.identity import DefaultAzureCredential
from azure.mgmt.network import NetworkManagementClient
from azure.data.tables import TableServiceClient
import os
import uuid

def main(req: func.HttpRequest) -> func.HttpResponse:
    try:
        credential = DefaultAzureCredential()
        subscription_id = os.environ["AZURE_SUBSCRIPTION_ID"]
        tenant_id = os.environ["AZURE_TENANT_ID"]
        table_storage_url = os.environ["TABLE_STORAGE_URL"]
        table_name = os.environ["TABLE_STORAGE_NAME"]

        # Set up Azure clients
        net_client = NetworkManagementClient(credential, subscription_id)
        table_service = TableServiceClient(endpoint=table_storage_url, credential=credential)
        table_client = table_service.get_table_client(table_name)

        for vnet in net_client.virtual_networks.list_all():
            for subnet in vnet.subnets:
                entity = {
                    "PartitionKey": "subnet",
                    "RowKey": str(uuid.uuid4()),
                    "vnetName": vnet.name,
                    "subnetName": subnet.name,
                    "addressPrefix": subnet.address_prefix,
                    "location": vnet.location
                }
                table_client.create_entity(entity=entity)

        return func.HttpResponse("VNets and subnets saved to Table Storage!", status_code=200)

    except Exception as e:
        return func.HttpResponse(f"Error: {str(e)}", status_code=500)
