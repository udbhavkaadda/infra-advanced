variable "sql_db_name" {}
variable "server_id" {}
variable "max_size_gb" {}
variable "tags" {
	type = map(string)
	default = {}
}
variable "sku_name" {
  type = string
  default = "S0"
}