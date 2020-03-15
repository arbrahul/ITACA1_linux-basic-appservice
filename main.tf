provider "azurerm" {
  features {}
}

#Get Key vault and SQL secret
data "azurerm_key_vault" "masterkv" {
  name                = "MasterKVitaca1"
  resource_group_name = "KvResourceGroup"
}

data "azurerm_key_vault_secret" "sqlsecret" {
  name         = data.azurerm_sql_server.nonprodsqlsvr.administrator_login
  key_vault_id = data.azurerm_key_vault.masterkv.id
}

#Get SQL RG and SQL server
data "azurerm_resource_group" "sqlrg" {
  name = "SqlResourceGroup"
}

data "azurerm_sql_server" "nonprodsqlsvr" {
  name                = "itaca1sqlsvrnonprod"
  resource_group_name = data.azurerm_resource_group.sqlrg.name
}


#create RG for the enviroment we are creating
resource "azurerm_resource_group" "itaca1" {
  name     = "${var.prefix}-resources"
  location = var.location
  
  tags = {
    environment = var.prefix
  }
}

#create database
resource "azurerm_sql_database" "itaca1" {
  name                             = "${var.prefix}-db"
  resource_group_name              = data.azurerm_resource_group.sqlrg.name
  location                         = data.azurerm_sql_server.nonprodsqlsvr.location
  server_name                      = data.azurerm_sql_server.nonprodsqlsvr.name
  edition                          = "Basic"
  collation                        = "SQL_Latin1_General_CP1_CI_AS"
  create_mode                      = "Default"
  requested_service_objective_name = "Basic"
}

resource "azurerm_app_service_plan" "itaca1" {
  name                = "${var.prefix}-itaca1asp"
  location            = azurerm_resource_group.itaca1.location
  resource_group_name = azurerm_resource_group.itaca1.name
  kind                = "Linux"
  reserved 			  = "true"

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "itaca1" {
  name                = "${var.prefix}-itaca1as"
  location            = azurerm_resource_group.itaca1.location
  resource_group_name = azurerm_resource_group.itaca1.name
  app_service_plan_id = azurerm_app_service_plan.itaca1.id

  site_config {
    linux_fx_version = "DOTNETCORE|2.2"
	scm_type = "LocalGit"
  }
  
  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = var.prefix
  }

  connection_string {
    name  = "MyDbConnection"
    type  = "SQLServer"
    value = "Server=tcp:${data.azurerm_sql_server.nonprodsqlsvr.fqdn},1433;Database=${azurerm_sql_database.itaca1.name};User ID=${data.azurerm_sql_server.nonprodsqlsvr.administrator_login};Password=${data.azurerm_key_vault_secret.sqlsecret.value};Encrypt=true;Connection Timeout=30;"
  }
}
