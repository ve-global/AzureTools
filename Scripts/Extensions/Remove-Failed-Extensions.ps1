workflow RemoveFailedExtension
{
    param(
    [string] $SubscriptionId,
    [PSCredential] $cred,
    [string] $TennantId,
    [int] $parallelLimit = 7,
    [string] $extensionName = 'dscExtension')

        Write-Output ("[Verbose - LogIn] Subscription {0} Credential {1}" -f $SubscriptionId,$cred)
        Add-AzureRmAccount -Credential $cred -SubscriptionId $SubscriptionId -ServicePrincipal -TenantId $TennantId
        $resourceGroups = Get-AzureRmResourceGroup
        ForEach -Parallel -ThrottleLimit $parallelLimit ($rg in $resourceGroups)
        {
            sequence{
                Write-Output ("[Verbose - Starting] {0}" -f $rg.ResourceGroupName)

                $result = Add-AzureRmAccount -Credential $cred -SubscriptionId $SubscriptionId -OutVariable $null -ServicePrincipal -TenantId $TennantId
                $machines = Get-AzureRmVM -ResourceGroupName $rg.ResourceGroupName
                foreach -Parallel -ThrottleLimit $parallelLimit ($machine in $machines)
                {
                    $resultInternal = Add-AzureRmAccount -Credential $cred -SubscriptionId $SubscriptionId -OutVariable $null -ServicePrincipal -TenantId $TennantId
                    $extension = Get-AzureRmVMDscExtensionStatus -ResourceGroupName $rg.ResourceGroupName -VMName $machine.Name -Name $extensionName -ErrorAction SilentlyContinue
                    if($extension)
                    {
                        if($extension.StatusCode -match 'failed')
                        {

                            $removeStatus = Remove-AzureRmVMDscExtension $extension.ResourceGroupName -VMName $extension.VmName -Name $extensionName
                            Write-Output ("[Info - Removed] Name:{0} Status: {1} Code {2}" -f $extension.VmName, $extension.Status, $extension.StatusCode)
                        }else
                        {
                            Write-Output ("[Verbose - Status] Name:{0} Status: {1} Code {2}" -f $extension.VmName, $extension.Status, $extension.StatusCode)
                        }
                    }
                }
                Write-Output ("[Verbose - Finishing] {0}" -f $rg.ResourceGroupName)
            }
        }
 }
