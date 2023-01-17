# Define variables for the virtual machine
param vmName string = "myVM"
param vmSize string = "Standard_DS1_v2"

# Create a virtual machine resource
resource vm 'Microsoft.Compute/virtualMachines@2019-07-01' = {
  name: vmName,
  location: resourceGroup().location,
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    },
    osProfile: {
      computerName: vmName,
      adminUsername: "azureuser",
      adminPassword: "Azure12345!",
      linuxConfiguration: {
        disablePasswordAuthentication: true,
        ssh: {
          publicKeys: [
            {
              path: "/home/azureuser/.ssh/authorized_keys",
              keyData: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9F9uY5y4..."
            }
          ]
        }
      }
    },
    storageProfile: {
      imageReference: {
        publisher: "Canonical",
        offer: "UbuntuServer",
        sku: "20.04-LTS",
        version: "latest"
      },
      osDisk: {
        caching: "ReadWrite",
        managedDisk: {
          storageAccountType: "Standard_LRS"
        }
      }
    },
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface().id
        }
      ]
    }
  }
}
