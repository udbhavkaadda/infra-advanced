resource "azurerm_mssql_database" "db" {
  for_each = var.sql_databases

  name      = each.value.name
  server_id = var.sql_server_ids[each.value.server_key]
  sku_name  = each.value.sku_name
}