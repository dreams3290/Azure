#create StorageAccount
Login-AzureRmAccount 
$resourceGroup="RSG-NCS-STG-REG"
$accountName="testreplication3290"
$location="West US"
#$type="Standard_LRS"
#New-AzureRmStorageAccount -Name $accountName -ResourceGroupName $resourceGroup -Location $location -Type $type
#$type="Standard_RAGRS"
#Set-AzureStorageAccount -StorageAccountName $accountName -Type $type