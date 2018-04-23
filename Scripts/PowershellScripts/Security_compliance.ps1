#Add-AzureRmAccount

#$rg= New-AzureRmResourceGroup -Name "testkeyvaultrg" -Location "central US"
#New-AzureRmKeyVault -VaultName "testkeyvault-0" -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location

#Add-AzureKeyVaultKey -VaultName "testkeyvault-0" -Name "MyFirstKey" -Destination "Software" 

#$mySecret= ConvertTo-SecureString -String 'password123' -Force -AsPlainText
#Set-AzureKeyVaultSecret -VaultName "testkeyvault-0" -Name "myfirstsecret" -SecretValue $mySecret

#$CertPwd = ConvertTo-SecureString -String "test1234" -Force -AsPlainText
#Import-AzureKeyVaultCertificate -VaultName "testkeyvault-0" -Name "mycert" -FilePath 'C:\Users\SRamadugu\Downloads\test1' -Password $CertPwd

#$policy = New-AzureKeyVaultCertificatePolicy -SecretContentType application/x-pkcs12 -SubjectName "CN=sanjayramadugu.com" -IssuerName "Self" -ValidityInMonths 6 -ReuseKeyOnRenewal

#Add-AzureKeyVaultCertificate -VaultName "testkeyvault-0" -Name "testcert01" -CertificatePolicy $policy

#Get-AzureKeyVaultCertificateOperation -VaultName "testkeyvault-0" -Name "testcert01"

#$rg=New-AzureRmResourceGroup -Name "testRG" -Location "West US" 
#New-AzureRmRecoveryServicesVault -Name "testrgvault" -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location

#Get-AzureRmResource |Where-Object {$_.ResourceType -EQ "Microsoft.Storage/storageaccounts"}
Remove-AzureRmResourceGroup -Name "testRG" -Force
#$vault1 =Get-AzureRmRecoveryServicesVault -Name "testrgvault"
#Set-AzureRmRecoveryServicesBackupProperties -Vault $vault1 -BackupStorageRedundancy GeoRedundant

