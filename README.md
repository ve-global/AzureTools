# AzureTools
Azure Tools to help you administer your azure account in an more reliable and automated way

#Extensions

##Remove Failed Extensions

This is the tools to remove failed extensions especially important since when you have a failing powershell extension it will not try to run again even if you have made changes on the machine istself but not on the parameters of the porwershell template. Usefull if you are in the WMF 5 hell

To run it simple use

```PowerShell
$serverPrincipal = '<Your Server Principal GUID>'
$accountPassword = ConvertTo-SecureString -AsPlainText "<Your Server Principal password>" -Force
$cred = New-Object System.Management.Automation.PSCredential($serverPrincipal,$accountPassword)
$SubscriptionId = '<Your Subscription Id>'
$TennantId = '<Your Tennant Id>'

RemoveFailedExtension -SubscriptionId $SubscriptionId -cred  $cred -TennantId $TennantId
```
