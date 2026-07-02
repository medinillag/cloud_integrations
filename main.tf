provider "azurerm" {
    features {}
}

data "azurerm_resource_group" "rg" {
    name = "RG-medinillag"
}

resource "azurerm_kubernetes_cluster" "aks" {
    name = "cluster-medinillag"
    location = data.azurerm_resource_group.rg.location
    resource_group_name = data.azurerm_resource_group.rg.name
    dns_prefix = "cluster-medinillag"

    default_node_pool {
        name = "default"
        node_count = 1
        vm_size = "Standard_D2ads_v7"
    }

    identity {
        type = "SystemAssigned"
    }

    linux_profile {
        admin_username = "azureuser"
        ssh_key {
            key_data = file("~/.ssh/id_rsa.pub")
        }
    }
}

output "kube_config" {
    value = azurerm_kubernetes_cluster.aks.kube_config_raw
    sensitive = true
}