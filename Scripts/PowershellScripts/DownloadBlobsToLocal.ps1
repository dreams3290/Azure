#This script is to copy all the files in the container to local


$containerName='containerName'
$destinationPath='destinationPath'
$connectionString='connectionString'
$storageAccount= New-AzureStorageContext -ConnectionString $connectionString
$blobs= Get-AzureStorageBlob -Container $containerName -Context $storageAccount
foreach ($blob in $blobs)
{ 
New-Item -ItemType Directory -Force -Path $destinationPath
 
 Get-AzureStorageBlobContent -Container $containerName -Blob $blob.Name -Destination $destinationPath -Context $storageAccount

}