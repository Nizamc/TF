module "resource_group_name" {
  source                = "./modules/resource-group"
  create_resource_group = true
  resource_group_name   = "nizam-net-rg"
  location              = "eastus"

  tags = {
    ProjectName  = "demo-internal"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }
}

resource "azurerm_user_assigned_identity" "example" {
  for_each            = toset(["user-identity3", "user-identity4"])
  resource_group_name = module.resource_group_name.name
  location            = module.resource_group_name.location
  name                = each.key
}

module "log_analytics_workspace" {
  source                     = "./modules/log-analytic-ws"
  resource_group_name        = module.resource_group_name.name
  location                   = module.resource_group_name.location
  retention_in_days          = 30
  workspace_name             = "law-shared-0012"
  daily_quota_gb             = 0.5
  internet_ingestion_enabled = false
  internet_query_enabled     = true
  sku                        = "PerGB2018"
  depends_on                 = [module.resource_group_name]

  tags = {
    ProjectName  = "demo-internal"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }
}

module "storage" {
  source = "./modules/storageaccount"

  # By default, this module will not create a resource group
  # proivde a name to use an existing resource group, specify the existing resource group name, 
  # and set the argument to `create_resource_group = false`. Location will be same as existing RG. 
  create_resource_group = false
  resource_group_name   = module.resource_group_name.name
  location              = module.resource_group_name.location
  storage_account_name  = "mystorage"

  # To enable advanced threat protection set argument to `true`
  enable_advanced_threat_protection = true

  # Container lists with access_type to create
  containers_list = [
    { name = "mystore250", access_type = "private" },
    { name = "blobstore251", access_type = "blob" },
    { name = "containter252", access_type = "container" }
  ]

  # SMB file share with quota (GB) to create
  file_shares = [
    { name = "smbfileshare1", quota = 50 },
    { name = "smbfileshare2", quota = 50 }
  ]

  # Storage tables
  tables = ["table1", "table2", "table3"]

  # Storage queues
  queues = ["queue1", "queue2"]

  # Configure managed identities to access Azure Storage (Optional)
  # Possible types are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned`.
  managed_identity_type = "UserAssigned"
  managed_identity_ids  = [for k in azurerm_user_assigned_identity.example : k.id]

  # Lifecycle management for storage account.
  # Must specify the value to each argument and default is `0` 
  lifecycles = [
    {
      prefix_match               = ["mystore250/folder_path"]
      tier_to_cool_after_days    = 0
      tier_to_archive_after_days = 50
      delete_after_days          = 100
      snapshot_delete_after_days = 30
    },
    {
      prefix_match               = ["blobstore251/another_path"]
      tier_to_cool_after_days    = 0
      tier_to_archive_after_days = 30
      delete_after_days          = 75
      snapshot_delete_after_days = 30
    }
  ]

  # Adding TAG's to your Azure resources (Required)
  # ProjectName and Env are already declared above, to use them here, create a varible. 
  tags = {
    ProjectName  = "demo-internal"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }
}

module "vnet" {
  source = "./modules/network"

  # By default, this module will not create a resource group, proivde the name here
  # to use an existing resource group, specify the existing resource group name,
  # and set the argument to `create_resource_group = true`. Location will be same as existing RG.
  create_resource_group          = false
  resource_group_name            = module.resource_group_name.name
  vnetwork_name                  = var.vnetwork_name
  location                       = module.resource_group_name.location
  vnet_address_space             = ["10.1.0.0/16"]
  firewall_subnet_address_prefix = ["10.1.0.0/26"]
  gateway_subnet_address_prefix  = ["10.1.1.0/27"]
  create_network_watcher         = false
  dns_servers                    = ["8.8.8.8", "4.4.4.4"]

  # Adding Standard DDoS Plan, and custom DNS servers (Optional)
  create_ddos_plan = false
  ddos_plan_name   = "azureddosplan01"

  # Multiple Subnets, Service delegation, Service Endpoints, Network security groups
  # These are default subnets with required configuration, check README.md for more details
  # NSG association to be added automatically for all subnets listed here.
  # First two address ranges from VNet Address space reserved for Gateway And Firewall Subnets.
  # ex.: For 10.1.0.0/16 address space, usable address range start from 10.1.2.0/24 for all subnets.
  # subnet name will be set as per Azure naming convention by defaut. expected value here is: <App or project name>
  subnets = {
    mgnt_subnet = {
      subnet_name           = "snet-management"
      subnet_address_prefix = ["10.1.2.0/24"]

      delegation = {
        name = "testdelegation"
        service_delegation = {
          name    = "Microsoft.ContainerInstance/containerGroups"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
        }
      }

      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["weballow", "100", "Inbound", "Allow", "Tcp", "80", "*", "0.0.0.0/0"],
        ["weballow1", "101", "Inbound", "Allow", "", "443", "*", ""],
        ["weballow2", "102", "Inbound", "Allow", "Tcp", "8080-8090", "*", ""],
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["ntp_out", "103", "Outbound", "Allow", "Udp", "123", "", "0.0.0.0/0"],
      ]
    }

    app_subnet = {
      subnet_name           = "snet-app"
      subnet_address_prefix = ["10.1.5.0/24"]

      delegation = {
        name = "testdelegation"
        service_delegation = {
          name    = "Microsoft.ContainerInstance/containerGroups"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
        }
      }

      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["weballow", "100", "Inbound", "Allow", "Tcp", "80", "*", "0.0.0.0/0"],
        ["weballow1", "101", "Inbound", "Allow", "", "443", "*", ""],
        ["weballow2", "102", "Inbound", "Allow", "Tcp", "8080-8090", "*", ""],
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["ntp_out", "103", "Outbound", "Allow", "Udp", "123", "", "0.0.0.0/0"],
      ]
    }

    db_subnet = {
      subnet_name           = "snet-db"
      subnet_address_prefix = ["10.1.6.0/24"]

      delegation = {
        name = "testdelegation"
        service_delegation = {
          name    = "Microsoft.ContainerInstance/containerGroups"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
        }
      }

      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["weballow", "100", "Inbound", "Allow", "Tcp", "80", "*", "0.0.0.0/0"],
        ["weballow1", "101", "Inbound", "Allow", "", "443", "*", ""],
        ["weballow2", "102", "Inbound", "Allow", "Tcp", "8080-8090", "*", ""],
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["ntp_out", "103", "Outbound", "Allow", "Udp", "123", "", "0.0.0.0/0"],
      ]
    }

    web_subnet = {
      subnet_name           = "snet-web"
      subnet_address_prefix = ["10.1.3.0/24"]
      service_endpoints     = ["Microsoft.Storage"]

      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["weballow", "200", "Inbound", "Allow", "Tcp", "80", "*", ""],
        ["weballow1", "201", "Inbound", "Allow", "Tcp", "443", "AzureLoadBalancer", ""],
        ["weballow2", "202", "Inbound", "Allow", "Tcp", "9090", "VirtualNetwork", ""],
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
      ]
      delegation = {
        name = "testdelegation"
        service_delegation = {
          name    = "Microsoft.ContainerInstance/containerGroups"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
        }
        service_delegation = {
          name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
        }
      }
    }

    pvt_subnet = {
      subnet_name           = "snet-pvt"
      subnet_address_prefix = ["10.1.4.0/24"]
      service_endpoints     = ["Microsoft.Storage"]

    }
  }

  # Adding TAG's to your Azure resources (Required)
  tags = {
    ProjectName  = "demo-internal"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }
}

module "application-insights" {
  source = "./modules/application-insights"

  # By default, this module will not create a resource group. Location will be same as based on variables for lcoation.
  # proivde a name to use an existing resource group, specify the existing resource group name, 
  resource_group_name = module.resource_group_name.name
  location            = module.resource_group_name.location

  application_insights_config = {
    mydemoappinsightworkspace = {
      application_type = var.application_insights_config.default_app.application_type
    }
  }

  # Adding TAG's to your Azure resources (Required)
  tags = {
    ProjectName  = "demo-internal"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }
}

module "key-vault" {
  source = "./modules/keyvault"

  # By default, this module will not create a resource group and expect to provide 
  # a existing RG name to use an existing resource group. Location will be same as existing RG. 
  # set the argument to `create_resource_group = true` to create new resrouce.
  resource_group_name        = module.resource_group_name.name
  key_vault_name             = "demo-project-shard"
  key_vault_sku_pricing_tier = "premium"

  # Once `Purge Protection` has been Enabled it's not possible to Disable it
  # Deleting the Key Vault with `Purge Protection` enabled will schedule the Key Vault to be deleted
  # The default retention period is 90 days, possible values are from 7 to 90 days
  # use `soft_delete_retention_days` to set the retention period
  enable_purge_protection = false
  # soft_delete_retention_days = 90

  # Access policies for users, you can provide list of Azure AD users and set permissions.
  # Make sure to use list of user principal names of Azure AD users.
  /*
  access_policies = [
    {
      azure_ad_user_principal_names = ["user1@example.com", "user2@example.com"]
      key_permissions               = ["get", "list"]
      secret_permissions            = ["get", "list"]
      certificate_permissions       = ["get", "import", "list"]
      storage_permissions           = ["backup", "get", "list", "recover"]
    },

    # Access policies for AD Groups
    # to enable this feature, provide a list of Azure AD groups and set permissions as required.
    {
      azure_ad_group_names    = ["ADGroupName1", "ADGroupName2"]
      key_permissions         = ["get", "list"]
      secret_permissions      = ["get", "list"]
      certificate_permissions = ["get", "import", "list"]
      storage_permissions     = ["backup", "get", "list", "recover"]
    },

    # Access policies for Azure AD Service Principlas
    # To enable this feature, provide a list of Azure AD SPN and set permissions as required.
    {
      azure_ad_service_principal_names = ["azure-ad-dev-sp1", "azure-ad-dev-sp2"]
      key_permissions                  = ["get", "list"]
      secret_permissions               = ["get", "list"]
      certificate_permissions          = ["get", "import", "list"]
      storage_permissions              = ["backup", "get", "list", "recover"]
    }
  ]
  */

  # Create a required Secrets as per your need.
  # When you Add `usernames` with empty password this module creates a strong random password
  # use .tfvars file to manage the secrets as variables to avoid security issues.
  secrets = {
    "message" = "Hello, world!"
    "vmpass"  = ""
  }

  # Creating Private Endpoint requires, VNet name and address prefix to create a subnet
  # By default this will create a `privatelink.vaultcore.azure.net` DNS zone. 
  # To use existing private DNS zone specify `existing_private_dns_zone` with valid zone name
  enable_private_endpoint = true
  existing_vnet_id        = module.vnet.virtual_network_id
  existing_subnet_id      = module.vnet.subnet_ids[3]

  # existing_private_dns_zone     = "demo.example.com"

  # (Optional) To enable Azure Monitoring for Azure Application Gateway 
  # (Optional) Specify `storage_account_id` to save monitoring logs to storage. 
  #log_analytics_workspace_id = var.log_analytics_workspace_id
  #storage_account_id         = var.storage_account_id
  log_analytics_workspace_id = module.log_analytics_workspace.id

  # Adding additional TAG's to your Azure resources
  tags = {
    ProjectName  = "demo-project"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }
}
/*
module "vpn-gateway" {
  source = "./modules/vpn"

  # Resource Group, location, VNet and Subnet details
  resource_group_name  = module.resource_group_name.name
  virtual_network_name = var.vnetwork_name
  vpn_gateway_name     = "shared-vpn-gw01"
  gateway_subnet_id    = module.vnet.gateway_subnet_id
  location             = module.resource_group_name.location
  # client configuration for Point-to-Site VPN Gateway connections
  # this key here for example only. Use your own key pairs for security. 
  vpn_client_configuration = {
    address_space        = "10.10.10.0/24"
    vpn_client_protocols = ["SSTP", "IkeV2"]
    certificate          = <<EOF
  MIIDnjCCAoagAwIBAgIhAKB7fd2/hLLoXJHF57TGm7ACkjrWrtgb+KnO+mMsvCw/
  MA0GCSqGSIb3DQEBBQUAMGUxCTAHBgNVBAYTADEQMA4GA1UECgwHZXhhbXBsZTEJ
  MAcGA1UECwwAMRQwEgYDVQQDDAtleGFtcGxlLmNvbTEPMA0GCSqGSIb3DQEJARYA
  MRQwEgYDVQQDDAtleGFtcGxlLmNvbTAeFw0yMDA5MjQyMDAxMDBaFw0yMTA5MjUy
  MDAxMDBaME8xCTAHBgNVBAYTADEQMA4GA1UECgwHZXhhbXBsZTEJMAcGA1UECwwA
  MRQwEgYDVQQDDAtleGFtcGxlLmNvbTEPMA0GCSqGSIb3DQEJARYAMIIBIjANBgkq
  hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAudme3h7l52ZrCX9uMYtsaJQikuPFCPFw
  mZFNCkILDoox03Ag4u+qPcS/Z3pT3QJQrM4Vy/I6K2ZnTWCTUhdh4QD69YPotcvC
  /0UBDkaZXO0XHMdqoWJFeqDF0WXvI+Suo2nxmx1lRNc5jZi36VW4SwzDdm31LfWI
  7FCDFyBQc3aBgc2SFxWkU0IKsLUnmfXIyWbBYioKcAUj7OuD9MY3TGrKB1xwjHxa
  abFQzuPFKTkLMmlXCBWweSS8XJXlnY6gvc1jAz6Vq3KET7V83ZCDVaikKeIstG+y
  DFp/Bs+CxMLi0k4nv0fHyXo9dCDkXQlYPgyENi+jo6KLxFdlxa3rmQIDAQABo08w
  TTAdBgNVHQ4EFgQUwMSixpf56/TXQNUvGwr/S4dpOlkwHwYDVR0jBBgwFoAUwMSi
  xpf56/TXQNUvGwr/S4dpOlkwCwYDVR0RBAQwAoIAMA0GCSqGSIb3DQEBBQUAA4IB
  AQCB3UGnJb3k2Sx1m47TQgPnQI3T16XIFsGHMivvwGuxIYz1hZrDhQ/2EepnLicK
  oPalygS0ko/1r3xGHcn1Ei/0N4SQTrRMfn4pjvXRGx+Rs2Nl9E3PUAMMcEuqW1Pa
  cUQrkEdlGg0t0fBtTpUHqyUFh0xU6Qlk2CIZdo2NaDoI6xpYYJtXqJWtTvOTe5op
  MOyajCaVrAXxY4Kk53Yrl1+yhbL+x4JNMrdO4wAn0bR0Teawm1y1WFsu9OHMoZzX
  Dgos8H06PH6rPvvvI1IFv3l5flPei3+YaO8m67nINbicW4BkBFwoxqjRnkCjZ+y0
  38xRFiD0G8J0rE6wPB/9sAwP
  EOF
  }
  # Adding TAG's to your Azure resources (Required)
  tags = {
    ProjectName  = "demo-internal"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }
}
/*
module "naming" {
  source = "./modules/naming"
  # The naming convention to be used for the resources
  prefix = ["demo"]
  suffix = ["internal"]
  unique-include-numbers = 16
}
*/