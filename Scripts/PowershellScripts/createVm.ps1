Add-AzureRmAccount
#create a resource group
$rgName="test533RG"
$location="East US"
New-AzureRmResourceGroup -Name $rgName -Location $lcoation

#create a virtual network
$subnet=@()
$subnet1Name="Subnet-1"
$subnet2Name="Subnet-2"
$subnet1AddresssPrefix="10.0.0.0/24"
$subnet2AddresssPrefix="10.0.1.0/24"
$vnetAddressSpace="10.0.0.0/16"
$VNETNAME="test533RGVnet"
$subnets += New-AzureRmVirtualNetworkSubnetConfig -Name $subnet1Name -AddressPrefix $subnet1AddresssPrefix
$subnets += New-AzureRmVirtualNetworkSubnetConfig -Name $subnet2Name -AddressPrefix $subnet2AddresssPrefix
$vnet= New-AzureRmVirtualNetwork -Name $VNETNAME -ResourceGroupName $rgName -Location $location -AddressPrefix $vnetAddressSpace -Subnet $subnets

#create a storage Account
$saName="test533stg"
$storageAcc= New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $saName -Location $location -SkuName Standard_LRS
$blobEndoint= $storageAcc.PrimaryEndpoints.Blob.ToString()


#create a availability set
$avSetName="testav"
$avSet= New-AzureRmAvailabilitySet -ResourceGroupName $rgName -Name $avSetName -Location $location

#create a new public address
$ipName ="testip"
$pip= New-AzureRmPublicIpAddress -Name $ipName -ResourceGroupName $rgName -Location $location -AllocationMethod Dynamic 

#create a Network security group

$nsgRules= @()
$nsgRules += New-AzureRmNetworkSecurityRuleConfig -Name "RDP" -Description "Remote Desktop" -Protocol Tcp -SourcePortRange "*" -DestinationPortRange "3389" -SourceAddressPrefix "*" -DestinationAddressPrefix "*" -Access Allow -Priority 110 -Direction Inbound
$nsgName="ExamRefNSG"
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $rgName -Name $nsgName -SecurityRules $nsgRules -Location $lcoation 

$nicName = "testNic"
$nic= New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location -SubnetId $vnet.Subnets[0].Id -NetworkSecurityGroupId $nsg.Id

#vm Configuration
$vmSize="Standard_DS1_V2"
$vm= New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize -AvailabilitySetId $avSet.Id

#set credentials

$cred= Get-Credential
Set-AzureRmVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred -ProvisionVMAgent -VM $vm

#create operating system image

$pubName="MicrosoftWindowsServer"
$offerName="WindowsServer"
$skuName="2016-Datacenter"
Set-AzureRmVMSourceImage -PublisherName $pubName -Offer $offerName -Skus $skuName -Version "latest" -vm $vm
$osDiskName="testRefVm-osDisk"
$osDiskUri= $blobEndoint + "vhds/" + $osDiskName + ".vhd"
Set-AzureRmVMOSDisk -Name $osDiskName -VhdUri $osDiskUri -CreateOption FromImage -VM $vm

#create a VM

New-AzureRmVM -ResourceGroupName $rgName -Location $location -VM $vm



