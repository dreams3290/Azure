#parameters
$resourceGroupName='testRG'
$resourceGroupLocation='North Central US'
$appservicePlanName='testAppServicePlan'
$webAppName='testwebapp320'
#create a new Resource group
New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation -Force
#create a new Resource plan
$appServicePlan = New-AzureRmAppServicePlan -Name $appservicePlanName -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation -Tier Standard -WorkerSize Small
#create a new Web app
New-AzureRmWebApp -ResourceGroupName $resourceGroupName  -Location $resourceGroupLocation -AppServicePlan $appServicePlan.ServerFarmWithRichSkuName -Name $webAppName 



