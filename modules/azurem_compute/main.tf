resource "azurerm_network_interface" "nic" {
  for_each            = var.vms
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = try(data.azurerm_public_ip.pip[each.key].id, null)
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = var.vms
  name                            = each.value.vm_name
  resource_group_name             = each.value.rg_name
  location                        = each.value.location
  size                            = each.value.size
  admin_username                  = data.azurerm_key_vault_secret.vm_username[each.key].value
  admin_password                  = data.azurerm_key_vault_secret.vm_password[each.key].value
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }

  tags = { environment = "prod" }
}

output "vm_ids" {
  value = { for k, v in azurerm_linux_virtual_machine.vm : k => v.id }
}
resource "azurerm_container_group" "this" {
	name                = var.name
	location            = var.location
	resource_group_name = var.resource_group_name
	os_type             = "Linux"

	container {
		name   = "app"
		image  = var.container_image
		cpu    = var.cpu
		memory = var.memory

		ports {
			port     = var.container_port
			protocol = "TCP"
		}
	}

	ip_address_type = var.ip_address_type
	exposed_port {
		port     = var.container_port
		protocol = "TCP"
	}
	subnet_ids = length(var.subnet_ids) > 0 ? var.subnet_ids : null
}
