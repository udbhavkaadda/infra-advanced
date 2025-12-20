/* Environment outputs - add any important resource outputs here */

output "app_fqdn" {
	description = "App FQDN from compute module (if public)"
	value       = try(module.app.fqdn, "")
}
