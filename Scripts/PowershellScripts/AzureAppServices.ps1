import-module AzureRM.Websites -verbose
#Add-AzureRmAccount

#create a resource group
$resourceGroupName="test533rg"
$Location="central US"
New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

#create an App service plan
$appServicePlanName="test533plan"
$tier="Standard"
$workerSize="small"
New-AzureRmAppServicePlan -Location $Location -Name $appServicePlanName -ResourceGroupName $resourceGroupName -Tier $tier -WorkerSize $workerSize

#create a webApp
$webAppName="test533webapp3290"
New-AzureRmWebApp -Name $webAppName -ResourceGroupName $resourceGroupName -Location $Location -AppServicePlan $appServicePlanName

#create a deployment slot
$stagingSlotName="Integration"
New-AzureRmWebAppSlot -ResourceGroupName $resourceGroupName -Name $webAppName -Slot $stagingSlotName

#clone a deployment slot
$stagingSlotName2="Regression"
$productionSlotName="Production"
##get a reference of the production slot
$productionSite= Get-AzureRmWebAppSlot -ResourceGroupName $resourceGroupName -Name $webAppName -Slot $productionSlotName
New-AzureRmWebAppSlot -ResourceGroupName $resourceGroupName -Name $webAppName -Slot $stagingSlotName2 -AppServicePlan $appServicePlanName -SourceWebApp $productionSite

#swap the web app slot
Switch-AzureRmWebAppSlot -ResourceGroupName $resourceGroupName -Name $webAppName -SourceSlotName $stagingSlotName -DestinationSlotName $productionSlotName

#configure Application settings
$webApp= Get-AzureRmWebApp -ResourceGroupName $resourceGroupName -Name $webAppName 
$settings = $webApp.SiteConfig.AppSettings
$newSettings = New-Object Hashtable
$newSettings["setting1"]="value-1"
$newSettings["setting2"]="value-2"
foreach($setting in $settings){
$newSettings.Add($setting.Name,$setting.Value)
}
Set-AzureRmWebApp -ResourceGroupName $resourceGroupName -Name $webAppName -AppSettings $newSettings

#Enabling diagnostic logs
Set-AzureRmWebApp -ResourceGroupName $resourceGroupName -Name $webAppName -HttpLoggingEnabled $true -RequestTracingEnabled $true

#retrieve diagnostic logs
#Save-AzureWebsiteLog -Name $webAppName -Output c:\www\websitelogs.zip

#view streaming logs
#Get-AzureWebsiteLog -Name $webAppName -Tail -Path http

#create a traffic manager profile
##properties of the traffic manager profile
$tmName="test533tmpublic"
$tmDnsName="test533tmpublic-tm"
$ttl=300
$monitorProtocol="TCP"
$monitorPort=8082
New-AzureRmTrafficManagerProfile -ResourceGroupName $resourceGroupName -Name $tmName -RelativeDnsName $tmDnsName -Ttl $ttl -TrafficRoutingMethod Performance -MonitorProtocol $monitorProtocol -MonitorPort $monitorPort

#Add an endpoint to traffic manager
$newTmEndpointName="testtmendpoint"
$newTmEndpointTarget="test533webapp322.azurewebsites.net"
##get traffic manager profile
$tmProfile= Get-AzureRmTrafficManagerProfile -ResourceGroupName $resourceGroupName -Name $tmName
New-AzureRmTrafficManagerEndpoint -ResourceGroupName $resourceGroupName -ProfileName $tmProfile.Name -Name $newTmEndpointName -Type AzureEndpoints -EndpointStatus Enabled -TargetResourceId $webApp.Id 
















