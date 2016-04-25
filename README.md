# AzureTools
Azure Tools to help you administer your azure account in an more reliable and automated way

#Extensions

##Remove Failed Extensions

This is the tools to remove failed DSC extensions especially important since when you have a failing powershell extension it will not try to run again even if you have made changes on the machine istself but not on the parameters of the porwershell template. Usefull if you are in the WMF 5 hell

To run it simple use

```PowerShell
$serverPrincipal = '<Your Server Principal GUID>'
$accountPassword = ConvertTo-SecureString -AsPlainText "<Your Server Principal password>" -Force
$cred = New-Object System.Management.Automation.PSCredential($serverPrincipal,$accountPassword)
$SubscriptionId = '<Your Subscription Id>'
$TennantId = '<Your Tennant Id>'

RemoveFailedExtension -SubscriptionId $SubscriptionId -cred  $cred -TennantId $TennantId
```

This tool make sure that you are going to remove this extensions in parallel that way avoiding the need to wait for each one individually.

There are some optional parameters.
`$parallelLimit` To specify the limit of parallel connections
`$extensionName` To specify the name of the DSC extension
