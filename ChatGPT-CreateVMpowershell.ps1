# Connect to Azure
Connect-AzAccount

# Set resource group name, location and virtual machine name
$resourceGroupName = "myResourceGroup"
$location = "West US 2"
$vmName = "myVM"

# Create resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Set virtual machine configuration
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize "Standard_D2_v2"

# Set virtual machine image
$vm = Set-AzVMOSDisk -VM $vmConfig -Name $vmName -DiskSizeInGB 128 -CreateOption FromImage -ImageName "WindowsServer2019Datacenter"

# Create virtual network
$vnet = New-AzVirtualNetwork -Name "myVnet" -ResourceGroupName $resourceGroupName -Location $location -AddressPrefix "10.0.0.0/16"
$subnet = Add-AzVirtualNetworkSubnetConfig -Name "mySubnet" -VirtualNetwork $vnet -AddressPrefix "10.0.1.0/24"

# Create public IP address
$publicIp = New-AzPublicIpAddress -Name "myPublicIp" -ResourceGroupName $resourceGroupName -Location $location -AllocationMethod Dynamic

# Create network interface
$nic = New-AzNetworkInterface -Name "myNic" -ResourceGroupName $resourceGroupName -Location $location -SubnetId $subnet.Id -PublicIpAddressId $publicIp.Id

# Add NIC to virtual machine configuration
$vm = Add-AzVMNetworkInterface -VM $vm -Id $nic.Id

# Create virtual machine
New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $vm