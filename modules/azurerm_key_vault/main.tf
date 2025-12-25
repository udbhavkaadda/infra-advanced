rgs = {
  dev = {
    name     = "rg-dev"
    location = "eastus"
    tags = {
      env = "dev"
    }
  }
}

storage_accounts = {
  appstore = {
    name                     = "appsa12345"
    resource_group_name      = "rg-dev"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    tags = {
      env = "dev"
    }
  }
}

networks = {
  dev = {
    name          = "vnet-dev"
    resource_group_name   = "rg-dev"
    location      = "eastus"
    address_space = ["10.0.0.0/16"]

    subnets = {
      frontend = {
        name             = "frontend-subnet"
        address_prefixes = ["10.0.1.0/24"]
      }

      backend = {
        name             = "backend-subnet"
        address_prefixes = ["10.0.2.0/24"]
      }
    }

    tags = {
      env = "dev"
    }
  }
}

vms = {
  frontend = {
    name  = "vm-frontend"
    rg_key = "dev"
    subnet_key = "frontend"
    admin_username_secret = "vm-frontend-user"
    admin_password_secret = "vm-frontend-pass"
  }

  backend = {
    name  = "vm-backend"
    rg_key = "dev"
    subnet_key = "backend"
    admin_username_secret = "vm-backend-user"
    admin_password_secret = "vm-backend-pass"
  }
}


public_ips = {
  frontend = {
    name   = "pip-frontend"
    rg_key = "dev"
    location = "eastus"
    tags = { env = "dev" }
  }
}

key_vaults = {
  app = {
    name   = "kvdevapp1234"
    rg_key = "dev"
    location = "eastus"
  }
}
sql_servers = {
  dev = {
    name   = "sqlsrv-dev-app"
    rg_key = "dev"
    location = "eastus"
    admin_username_secret = "sql-admin-user"
    admin_password_secret = "sql-admin-pass"
  }
}

sql_databases = {
  appdb = {
    name      = "todoappdb"
    server_key = "dev"
    sku_name  = "Basic"
  }
}