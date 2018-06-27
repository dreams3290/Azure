Clear 
Add-AzureRmAccount 
#parameters
$subscriptionID="Enter you subscription id" 
$rgName="AutomationRG" 
$location="East US"
$subnet1Name="Subnet-1" 
$subnet2Name="Subnet-2" 
$Subnet1AddressPrefix="10.0.0.0/24" 
$Subnet2AddressPrefix="10.0.1.0/24" 
$vnetAddressSpace="10.0.0.0/16" 
$vnetName="AutomationVnet"  
$stgAccountName="automationstg3290"
$StgSkuName="Standard_LRS"
$avSetName="testavailabilityset"
$pipName="automationvmip"
$nsgName="automationnsg"
$nicName="testnic"
$vmSize="B1s"
$vmName="automationvm"
$cred= Get-Credential
$pubName="MicrosoftWindowsServer"
$offerName="WindowsServer"
$skuName="2016-Datacenter"
$osDiskName="sanjayvm-osdisk"
$osDiskUri= $blobEndpoint+"vhds/"+$osDiskName+".vhd"
#Set the correct subscription 
$subscription= Get-AzureRmSubscription -SubscriptionId $subscriptionID
Select-AzureRmSubscription -Subscription $subscription 
#Create resource group 
$rgName="AutomationTest" 
$location="East US" 
New-AzureRmResourceGroup -Name $rgName -Location $location  
#Create a virtual network 
$vnet= New-AzureRmVirtualNetwork -ResourceGroupName $rgName -Location $location -Name $vnetName -AddressPrefix $vnetAddressSpace   
$subnet1Config= Add-AzureRmVirtualNetworkSubnetConfig -Name $subnet1Name -AddressPrefix $Subnet1AddressPrefix -VirtualNetwork $vnet 
$subnet2Config= Add-AzureRmVirtualNetworkSubnetConfig -Name $subnet2Name -AddressPrefix $Subnet2AddressPrefix -VirtualNetwork $vnet 
$vnet | Set-AzureRmVirtualNetwork 
#create a storage account  
$storageAccount=New-AzureRmStorageAccount -ResourceGroupName $rgName -Location $location -Name $stgAccountName -SkuName $StgSkuName 
$blobEndpoint=$storageAccount.PrimaryEndpoints.Blob.ToString() 
#create an availability set
$avSet= New-AzureRmAvailabilitySet -ResourceGroupName $rgName -Name $avSetName -Location $location
#create public ip address
$pip= New-AzureRmPublicIpAddress -ResourceGroupName $rgName -Location $location -Name $pipName -Sku Basic -AllocationMethod Static
#create a NSG
$nsgRules=@()
$nsgRules+=New-AzureRmNetworkSecurityRuleConfig -Name "RDP" -Description "Allow RDP" -Protocol Tcp -SourcePortRange "*" -DestinationPortRange "3389" -SourceAddressPrefix "*" -DestinationAddressPrefix "*" -Access Allow -Priority "110" -Direction Inbound
$nsg= New-AzureRmNetworkSecurityGroup -ResourceGroupName $rgName -Location $location -Name $nsgName -SecurityRules $nsgRules
#create a NIC
$virtualNetwork= Get-AzureRmVirtualNetwork -ResourceGroupName $rgName -Name $vnetName
$nic =New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location -SubnetId $virtualNetwork.Subnets[0].Id -NetworkSecurityGroupId $nsg.Id
#create vm configuration
$vm= New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize -AvailabilitySetId $avSet.Id
$vm= Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName $vmName -Credential $cred
$vm= Set-AzureRmVMSourceImage -VM $vm -PublisherName $pubName -Offer $offerName -Skus $skuName -Version "latest"
$vm= Set-AzureRmVMOSDisk -VM $vm -Name $osDiskName -VhdUri $osDiskUri -CreateOption FromImage -Caching ReadWrite
#create VM
New-AzureRmVM -ResourceGroupName $rgName -Location $location -Name $vmName -VirtualNetworkName $vnetName -SubnetName $subnet1Name -PublicIpAddressName $pipName -SecurityGroupName $nsgName 







