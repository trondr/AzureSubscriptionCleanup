# AzureSubscriptionCleanup
Azure function running on a schedule to cleanup expired resource groups. Resources groups with an expireOn tag will be processed.

![DocumentationImage](/doc/images/expireOn.png)

# How to install

1. Create Function App

```PowerShell
$TenantId = "<your tenant id here>"
$SubscriptionId = "<your subscrition id here>" 
Connect-AzAccount -TenantId $TenantId -Subscription $SubscriptionId

$ResourceGroupName = "Subscription-Automation-RG"
$StorageAccountName = "subscriptionauto<YourUniqeFiveLetterId>sa"
$Location = "Norway East"
$FunctionAppName = "AzureSubscriptionCleanup<YourUniqeFiveLetterId>"

New-AzResourceGroup -Name $ResourceGroupName -Location $Location
New-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -Location $Location -SkuName "Standard_LRS"
New-AzFunctionApp -Name $FunctionAppName -ResourceGroupName $ResourceGroupName -Location $Location -StorageAccountName $StorageAccountName -Runtime PowerShell -OSType Windows -RuntimeVersion 7.4 -FunctionsVersion 4
```

2.  Deploy function app

Open function project in VSCode. Deploy manually:

![DocumentationImage](/doc/images/Deploy.png)


3.  Enable System Managed Identiy

In Function App Settings select Identity and enable system assigned identity.

![DocumentationImage](/doc/images/Identity.png)

4.  Assign the subscription contribution role

In the subscription settings Access Control (IAM) grant the managed identity for the azure function the contributer role.

![DocumentationImage](/doc/images/Contributor.png)

