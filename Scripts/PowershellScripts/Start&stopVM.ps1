Add-AzureRmAccount
$subscriptionID="Enter your subscription ID"
$subscription=Get-AzureRmSubscription -SubscriptionId $subscriptionID
Select-AzureRmSubscription -Subscription $subscription
$resourceGroupName="Enter your resource Group name"
$vmName="Enter the name of your Vm"
#Start the VM
Start-AzureRmVM -ResourceGroupName $resourceGroupName -Name $vmName
#Stop the VM
Stop-AzureRmVM -ResourceGroupName $resourceGroupName -Name $vmName
