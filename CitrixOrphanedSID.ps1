asnp Citrix*
 
$BrokenApps = Get-BrokerApplication | Where {$_.AssociatedUserNames -like "S-1-5-21*"}
Foreach($app in $BrokenApps)
{
Write-Host ” –” $app.Name "is broken"
}
