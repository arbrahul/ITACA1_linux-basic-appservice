output "app_service_name" {
  value = azurerm_app_service.itaca1.name
}

output "app_service_default_hostname" {
  value = "https://${azurerm_app_service.itaca1.default_site_hostname}"
}

output "app_service_git_cloneurl" {
  value = "itaca1deployer@${azurerm_app_service.itaca1.source_control.0.repo_url}:443/${azurerm_app_service.itaca1.name}.git"
}
