/* Environment outputs for QA - add any important outputs here */

output "app_fqdn" {
	description = "App FQDN from compute module (if public)"
	value       = try(module.app.fqdn, "")
}
