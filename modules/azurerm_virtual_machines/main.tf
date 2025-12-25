resource "azurerm_network_interface" "nic" {
  for_each = var.vms

  name                = "${each.value.name}-nic"
  location            = "eastus"
  resource_group_name = var.rg_names[each.value.rg_key]

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_ids[each.value.subnet_key]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  for_each = var.vms

  name                = each.value.name
  resource_group_name = var.rg_names[each.value.rg_key]
  location            = "eastus"
  size                = "Standard_B2s"
  admin_username      = data.azurerm_key_vault_secret.vm_user[each.key].value
  admin_password      = data.azurerm_key_vault_secret.vm_pass[each.key].value
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}


data "azurerm_key_vault_secret" "vm_user" {
  for_each     = var.vms
  name         = each.value.admin_username_secret
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "vm_pass" {
  for_each     = var.vms
  name         = each.value.admin_password_secret
  key_vault_id = var.key_vault_id
}
