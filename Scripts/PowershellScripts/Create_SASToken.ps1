Login-AzureRmAccount
$storageAccount="devops3290"
$rgName="NobleSync"
$container="test1"
$storageKey= Get-AzureRmStorageAccountKey -ResourceGroupName $rgName -Name $storageAccount
$context=New-AzureStorageContext -StorageAccountName $storageAccount -StorageAccountKey $storageKey[0].Value
$startTime= Get-Date
$endTime= $startTime.AddHours(4)
New-AzureStorageBlobSASToken -Container $container -Blob "wahh_fuzz.wav" -Permission "rwd" -StartTime $startTime -ExpiryTime $endTime -Context $context
