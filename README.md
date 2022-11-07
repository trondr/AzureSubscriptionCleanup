# AzureSubscriptionCleanup
Azure function running on a schedule to cleanup expired resource groups.


# Create Function App

´´´PowerShell
$ResourceGroupName = "Subscription-Automation-RG"
$StorageAccountName = "subscriptionautomationsa"
$Location = "Norway East"
$FunctionAppName = "AzureSubscriptionCleanup"

New-AzResourceGroup -Name $ResourceGroupName -Location $Location
New-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -Location $Location -SkuName "Standard_LRS"
New-AzFunctionApp -Name $FunctionAppName -ResourceGroupName $ResourceGroupName -Location $Location -StorageAccountName $StorageAccountName -Runtime PowerShell
´´´

# Deploy function app

Open function project in VSCode. Deploy manually:

![DocumentationImage](/doc/images/Deploy.png)


# Enable System Managed Identiy

In Function App Settings select Identity and enable system assigned identity.

![DocumentationImage](/doc/images/Identity.png)

# Assign the subscription contribution role

In the subscription settings Access Control (IAM) grant the managed identity for the azure function the contributer role.

![DocumentationImage](/doc/images/Contributor.png)

