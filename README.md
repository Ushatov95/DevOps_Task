# DevOps Task 1 - Web Application Infrastructure

This repository contains the infrastructure code for a proof-of-concept webapp that displays custom text and an image. The solution is built using Azure services and leverages a connection to a .git repo for a GitOps approach of deployments.

# DevOps Task 2 - Function Application Infrastructure

This repository contains the infrastructure code for a proof-of-concept functionapp that queries data from the current subscription about vnets and subnets and writes it to a table storage. The solution is built using Azure services and leverages a connection to a .git repo for a GitOps approach of deployments.

## Architecture Overview

The solution consists of the following components:

1. **Web Application**
   - A simple Node.js web application that displays custom text and an image
   - Hosted on Azure App Service

2. **Infrastructure**
   - Infrastructure as Code (IaC) using Terraform
   - Azure Storage Account for Terraform state file storage
   - Azure App Service with Linux container support
   - Auto-scaling configuration for handling increased loads

3. **CI/CD Pipeline**
   - Azure DevOps pipeline for automated deployment based on environment and task

4. **Function App**
   - A python function app that is invoked with http requests, where it queries current subscription for vnet and subnets then writes to a Table Storage using azure SDK's.
   [
    PartitionKey
    RowKey
    vnetName
    subnetName
    addressPrefix
    resourceGroup
    location
    timestamp
    vnetId
    subnetId
   ] 

## Prerequisites

Before you begin, ensure you have the following:

1. **Azure Account and Subscription**
   - Active Azure subscription
   - Azure DevOps organization and project

2. **Tools**
   - Git

3. **Azure DevOps Setup**
   - Import github repo https://github.com/Ushatov95/devops_task_infra (Create a new devops repo without a README.md and click on import)
   - Create Service Connection named 'zetta-sp' configured in Azure DevOps with scope over your deployment target subscription
        Go to ADO portal > Project Settings > Service Connections > New service connection > Azure Resource Manager > App registration (automatic), Credentials (Workload identity federation), Scope Subscription (select your subscription), do not select a resource group, input "zetta-sp" for Service Connection Name, Mark with check - Grant access permission to all pipelines > Save.
    - Create our infrastructure deployment pipeline
        Go to Pipelines > Azure Repos Git > Select your repository > Existing Azure Pipelines YAML file > select our /infra_deploy.yml and save

4. **Azure Portal Setup**
   - Create a sample Storage Account with default properties with name "zettatfstatedevopstask"
   - Create a two containers with default properties and names "zettatfstate-task-1" and "zettatfstate-task-2"
   - Assign the Service Principal used in our Service Connection the User Access Administrator over the deployment subscription scope
        Go to your Subscription > IAM > Add role assignment > Privileged administrator roles and select User Access Administrator > Members (you can get the correct SP easily from your DevOps project Service Connection configuration) > Conditions - Allow user to assign all roles except privileged administrator roles Owner, UAA, RBAC.

### 1. Deploy Infrastructure

1. Navigate to ADO portal
2. Start the infra_deploy pipeline with your desired parameters and task to deploy
3. Monitor pipeline, check the produced Terraform plan and if you are satisfied - Validate the Wait for Approval job

### 2. Application deployments

The application deployment is automated through the Deployment center which is hooked with a public repo (just for reviewer convenience) to which when you commit automatically a new deployment is triggered for the web app and function app.

## Scaling Configuration

The solution includes auto-scaling capabilities:

- **Azure App Service Auto-scaling**
  - Default instances: 1
  - Scale based on CPU usage, average for 15m
    - Minimum instances: 1
    - Maximum instances: 3
    - Scale out when CPU > 85%
    - Scale in when CPU < 60%
  - Scale based on Requests, average for 15m
    - Minimum instances: 1
    - Maximum instances: 3
    - Scale out when requests > 150
    - Scale in when CPU < 50

### 3. Application testing

1. Web application for task-1
    After you have successfully deployed task-1-infra via pipeline go to the web app in Azure portal, (check if the Deployment Center is showing the last deployment as Successful) on Overview we can see the Default domain: click the url <app-name.azurewebsites.net> and you should be brought to the sample webapp.

2. Function app for task-2
    After you have successfully deployed task-2-infra via pipeline go to the func app in Azure portal, (check if the Deployment Center is showing the last deployment as Successful) on Overview we can see the Default domain: copy the url <app-name.azurewebsites.net> and add /api/VnetScanner to it, this would then trigger our function app.
    Or you can use a shell to trigger the function <curl app.name.azurewebsites.net/api/VnetScanner>
    The Function app should list all vnets and subnets in our subscription and then write them to a table storage account that we have provisioned with our pipeline.
    In order to test the produced results you can either log to Azure Storage Explorer and navigate to the Table Storage or run the following command in az cli: az storage entity query --account-name <Storage Account Name from Deployment> --table-name functiontable --output jsonc

## Troubleshooting

Common issues and solutions:

1. **Pipeline Failures**
   - Check Service Connection permissions
   - Verify variable group configuration
   - Review pipeline logs

2. **Infrastructure Deployment Issues**
   - Check Terraform logs
   - Verify Azure credentials
   - Review resource provider registration

3. **Application Deployment Issues**
   - It takes a while for the web/func app to load the deployment (especially the function app ~10min after deployment)
   - Wait a while before accessing after initial deploy
   - Restart the web/function app