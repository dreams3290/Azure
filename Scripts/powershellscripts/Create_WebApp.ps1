Login-AzureRmAccount 

#Define properties for the app service plan
$resourceGroupName="AZ533RGtest"
$appServicePlanName="az533plan"
$location="West US"
$tier="Premium"
$workerSize="small"

# Create a new resource group

#New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

#create a new app service plan
#New-AzureRmAppServicePlan -ResourceGroupName $resourceGroupName -Name $appServicePlanName -Location $location -Tier $tier -WorkerSize $workerSize

#create a new web app
$webAppName="testwebapp3299"
#New-AzureRmWebApp -ResourceGroupName $resourceGroupName -Location $location -AppServicePlan $appServicePlanName -Name $webAppName

#create a new weba pp deployment slot
$stagingSlotName="Staging"
New-AzureRmWebAppSlot -ResourceGroupName $resourceGroupName -Name $webAppName -Slot $stagingSlotName

#Get Reference to Production Slot
$productionSlotName="Production"
$productionSite= Get-AzureRmWebAppSlot -ResourceGroupName $resourceGroupName -Name $webAppName -Slot $productionSlotName

#create a staging that clones production slot
New-AzureRmWebAppSlot -ResourceGroupName $resourceGroupName -Name $webAppName -Slot $stagingSlotName -AppServicePlan $appServicePlanName -SourceWebApp $productionSite

#swap staging and production deploymetn slots

Swap-AzureRmWebAppSlot -ResourceGroupName $resourceGroupName -Name $webAppName -SourceSlotName $stagingSlotName -DestinationSlotName $productionSlotName

