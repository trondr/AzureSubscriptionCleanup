# AzureSubscriptionCleanup
Azure function running on a schedule to cleanup expired resource groups. Resources groups with an expireOn tag will be processed.

![DocumentationImage](/doc/images/expireOn.png)

# Development Environment

From PowerShell admin command prompt

```
Write-Host "Install Chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Write-Host "Install Nuget"
$PowerShellGetDatafolder = "C:\ProgramData\Microsoft\Windows\PowerShell\PowerShellGet"
New-Item -Path $PowerShellGetDatafolder -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
$nugetExe = "$PowerShellGetDatafolder\nuget.exe"
if( (Test-Path -Path $nugetExe) -eq $false)
{
    Invoke-WebRequest -Uri "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" -OutFile "$nugetExe"
	. $nugetExe update -self

} else
{
    . $nugetExe update -self
}
. $nugetExe sources add -source "https://api.nuget.org/v3/index.json" -name "nuget.org"

choco feature enable -n=allowGlobalConfirmation
choco install vscode -y
choco install powershell-core --version=7.4.13 -y
choco install azure-cli -y
choco install azure-functions-core-tools -y
choco install azurite -y
choco install microsoftazurestorageexplorer -y
choco install git -y
choco install git-credential-winstore
choco install sourcetree
choco install googlechrome -y
choco feature disable -n=allowGlobalConfirmation
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name Az -Scope AllUsers -Repository PSGallery -Force -Confirm:$false
Install-Module posh-git -Scope AllUsers -Repository PSGallery -Force -Confirm:$false
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force -ErrorAction SilentlyContinue
Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted
```

From new PowerShell admin command prompt:
```
Write-Host "Enable long paths"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
$gitExe = "C:\Program Files\Git\bin\git.exe"
& $gitExe config --global core.longpaths true
```

From PowerShell standard command prompt:
```
code --install-extension ms-azuretools.vscode-azurefunctions
code --install-extension ms-vscode.powershell
code --install-extension Azurite.azurite
```

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

