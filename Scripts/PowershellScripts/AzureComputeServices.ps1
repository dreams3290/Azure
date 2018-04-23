$rgName="testvmrg"
$location="Central US"
#create a resource group
New-AzureRmResourceGroup -Name $rgName -Location $location -Force

#create subnets and NIC's
$subnets=@()
$subnet1Name="Subnet-1"
$subnet2Name="Subnet-2"
$subnet1AddressPrefix="10.0.0.0/24"
$subnet2AddressPrefix="10.0.1.0/24"
$vnetAddressPrefix="10.0.0.0/16"
$vnetName="testvmvnet"
$subnets+= New-AzureRmVirtualNetworkSubnetConfig -Name $subnet1Name -AddressPrefix $subnet1AddressPrefix
$subnets+= New-AzureRmVirtualNetworkSubnetConfig -Name $subnet2Name -AddressPrefix $subnet2AddressPrefix 
$vnet= New-AzureRmVirtualNetwork -ResourceGroupName $rgName -Location $location -Name $vnetName -AddressPrefix $vnetAddressPrefix -Subnet $subnets

#create a storage account

$saName="testvmrgstg"
$storageAccount= New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $saName -Location $location -SkuName Standard_LRS 
$blobEndPoint= $storageAccount.PrimaryEndpoints.Blob.ToString()

#create an availability set
$avSetname="testavset"
$avSet= New-AzureRmAvailabilitySet -ResourceGroupName $rgName -Name $avSetName -Location $location

#create a public ip address
$ipName="tesvmip"
$dnsName="testvm-publicip"
$pip= New-AzureRmPublicIpAddress -Name $ipName -ResourceGroupName $rgName -Location $location -AllocationMethod Dynamic -DomainNameLabel $dnsName

#create a network security group rules
$nsgRules=@()
$nsgRules+= New-AzureRmNetworkSecurityRuleConfig -Name "RDP" -Description "Allow RDP" -Protocol Tcp -SourcePortRange "*" -DestinationPortRange "3389" -SourceAddressPrefix "*" -DestinationAddressPrefix "*" -Access Allow -Priority 110 -Direction Inbound

#create a network security group
$nsgName="testnsgvm"
$nsg= New-AzureRmNetworkSecurityGroup -Name $nsgName -ResourceGroupName $rgName -Location $location -SecurityRules $nsgRules

#create  netwrok interface
$nicName="testvmnic"
$nic= New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

#create azure vm configs
$vmSize="Standard_DS1_V2"
$vmName="testpsvm"
$vm= New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize -AvailabilitySetId $avSet.Id

#setup credentials
$cred= Get-Credential
Set-AzureRmVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred -ProvisionVMAgent -Vm $vm

#create sku config

$pubName="MicrosfotWindowsServer"
$offerName="WindowsServer"
$skuName="2016-Datacenter"
Set-AzureRmVMSourceImage -PublisherName $pubName -Offer $offerName -Skus $skuName -Version "latest" -VM $vm

$osDiskName="testvmdisk"
$osDiskUri= $blobEndPoint + "vhds/"+$osDiskName+".vhd"
Set-AzureRmVMOSDisk -Name $osDiskName -VhdUri $osDiskUri -CreateOption FromImage -VM $vm

#create a virtual machine

New-AzureRmVM -ResourceGroupName $rgName -Location $location -VM $vm








