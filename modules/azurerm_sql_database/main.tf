resource "azurerm_mssql_database" "sql_db" {
	name         = var.sql_db_name
	server_id    = var.server_id
	collation    = "SQL_Latin1_General_CP1_CI_AS"
	license_type = "LicenseIncluded"
	max_size_gb  = var.max_size_gb
	sku_name     = try(var.sku_name, "S0")
	tags         = try(var.tags, {})
}

output "database_id" {
	value = azurerm_mssql_database.sql_db.id
}
