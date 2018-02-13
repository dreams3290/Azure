#create a container
Login-AzureRmAccount
$storageAccount="devopssr"
$resourceGroup="RSG-NCS-STG-REG"
$storageKey= Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroup -StorageAccountName $storageAccount
$context= New-AzureStorageContext -StorageAccountName $storageAccount -StorageAccountKey $storageKey.Value[0]
#New-AzureStorageContainer -Context $context -Name "testpowershell" -Permission Off

#upoad a blob

$containerName="testpowershell"
$blobName="testpowershellblob.txt"
$localFileDirectory="C:\Users\devopsuser\Downloads\test"
$localFile=Join-Path $localFileDirectory $blobName
Set-AzureStorageBlobContent -File $localFile -Container $containerName -Blob $blobName -Context $context