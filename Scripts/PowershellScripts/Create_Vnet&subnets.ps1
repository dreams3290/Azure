$rgName = "test533"
$location = "Central US"
New-AzureRmResourceGroup -Name $rgName -Location $location
$subnets = @()
$subnet1Name = "Apps"
$subnet2Name = "Data"
$subnet1AddressPrefix = "10.0.0.0/24"
$subnet2AddressPrefix = "10.0.1.0/24"
$vnetAddresssSpace = "10.0.0.0/16"
$VNETName = "test533vnet"
$rgName = "test533"
$location = "Central US"
$subnets = New-AzureRmVirtualNetworkSubnetConfig -Name $subnet1Name -AddressPrefix $subnet1AddressPrefix
#$subnets = New-AzureRmVirtualNetworkSubnetConfig -Name $subnet2Name -AddressPrefix $subnet2AddressPrefix
$vnet = New-AzureRmVirtualNetwork -Name $VNETName -ResourceGroupName $rgName -Location $location -AddressPrefix $vnetAddresssSpace -Subnet $subnets