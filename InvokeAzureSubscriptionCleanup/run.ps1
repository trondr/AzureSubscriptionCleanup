# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format
$currentUTCtime = (Get-Date).ToUniversalTime()

# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}

Write-Host "Cleaning up any expired resource groups."
$expiredResourceGroups = Get-AzResourceGroup | Where-Object {
        $($null -ne $($_.Tags.expireOn)) #ExpireOn tag exists
    } | Where-Object {
        $expireOn = $([DateTime]$_.Tags.expireOn)
        $null -ne $expireOn #ExpireOn is a valid date time
    } | Where-Object {
        $expireOn = $([DateTime]$_.Tags.expireOn)
        $now = $(Get-Date)
        ($expireOn -lt $now) #ExpireOn datetime is in the past => resource group has expired.
    }
$expiredResourceGroups | ForEach-Object {
    $resourceGroupName = $_.ResourceGroupName
    Write-Host "Removing expired resource group '$resourceGroupName'..."
    $isSucceful = Remove-AzResourceGroup -Name $resourceGroupName -Force
    Write-Host "Resource group '$resourceGroupName' was removed: $isSucceful"
}
Write-Host "Subscription cleanup ran at : $((Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss")) (UTC)"