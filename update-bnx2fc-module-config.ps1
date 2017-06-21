## This script was created from article http://bakingclouds.com/2017/06/21/qlogic-fcoe-adapter-disappeared-after-reboot/ by article author.
#change below variables
$myvc =  'this-is-my-vc'

#Connect vcenter
Connect-VIServer $myvc

#Get hosts with device 57840
$my57840 = Get-VMHostPciDevice -DeviceClass NetworkController -Name *'QLogic 57840'*|Select VMHost -Unique
foreach ($my57840s in $my57840){
	If( (Get-VMHostModule -Name bnx2fc -VMHost $my57840s.VMHost )|Where-Object {$_.Options -eq "bnx2fc_autodiscovery=1"} ) {
Write-Host $my57840s.VMHost 'module configuration not needed' -BackgroundColor Magenta
}
Else{
$esxcli = Get-EsxCli -VMHost $my57840s.VMHost
$esxcli.system.module.parameters.set($false,"bnx2fc","bnx2fc_autodiscovery=1")
Write-Host $my57840s.VMHost 'Configured'
}
	}

#Disconnect vcenter
DisConnect-VIServer $myvc -Confirm:$false
Clear-Variable my* -Scope Global
