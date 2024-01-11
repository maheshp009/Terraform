provider "databricks" {
  host              = "https://adb-2494790443069613.13.azuredatabricks.net/?o=2494790443069613#"
  azure_client_id   = "97d1480b-0ccd-4cf1-93e2-40ea5b0f8869"
  azure_tenant_id   = "8ac76c91-e7f1-41ff-a89c-3553b2da2c17"
  azure_client_secret = "m.28Q~6eEw-1OhzQrTAjasTtWDBsBIQ-eRr3Cceq"
}

terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.25.1"
    }
  }
}

# resource "databricks_catalog" "catalog" {
#   metastore_id = "d8365bce-aee0-4a53-9f94-df7f3582ebf0"
#   name         = "autoloader_sample_catalog"
# }

# resource "databricks_storage_credential" "external_mi" {
#   name =  "autoloader"
#   owner = "DEV-EDL"
#   azure_managed_identity {
#     access_connector_id = "/subscriptions/7820fba7-bfe0-4c5c-89a3-e37f6aef4703/resourceGroups/ZUSE2-TAA-RGP-DEV-EDL/providers/Microsoft.Databricks/accessConnectors/zuse2devedlacdb01"
#   }
# }

# resource "databricks_grants" "storage_credential" {
#   depends_on = [databricks_storage_credential.external_mi]
#   storage_credential = databricks_storage_credential.external_mi.id
#   grant {
#     principal  = "DEV-EDL"
#     privileges = ["ALL_PRIVILEGES"]
#   }
# }



# resource "databricks_external_location" "edldev_storage_location" {
#   depends_on          = [databricks_storage_credential.external_mi]
#   name            = "test"
#   url             = "abfss://lakehouse@zuse2devedlstr01.dfs.core.windows.net/"
#   credential_name = databricks_storage_credential.external_mi.id
# }

# resource "databricks_grants" "external_location" {
#   depends_on          = [databricks_external_location.edldev_storage_location]
#   external_location   = databricks_external_location.edldev_storage_location.id
#   grant {
#     principal  = "DEV-EDL"
#     privileges = ["ALL_PRIVILEGES"]
#   }
# }
#----------------------------------------------------------------------------------------------
# resource "databricks_catalog" "sandbox" {
#   metastore_id = "d8365bce-aee0-4a53-9f94-df7f3582ebf0"
#   name         = "catalog1"
#   comment      = "this catalog is managed by terraform"
#   properties = {
#     purpose = "testing"
#   }

# }


resource "databricks_schema" "things" {
  catalog_name = "autoloader_sample_catalog"
  name         = "taxformsource"
  comment      = "this schema is managed by terraform"
  properties = {
    kind = "various"
  }
}

resource "databricks_schema" "second_schema" {
  catalog_name = "autoloader_sample_catalog"
  name         = "taxformraw"
  comment      = "this schema is managed by terraform"
  properties = {
    kind = "various"
  }
}


resource "databricks_volume" "volume" {
  name             = "taxformsource_vol"
  catalog_name     = databricks_schema.things.catalog_name
  schema_name      = databricks_schema.things.name
  volume_type      = "EXTERNAL"
  storage_location = "abfss://taxformmasterdata@use2d002b139stbdevgedl02.dfs.core.windows.net/"   
  comment          = "this volume is managed by terraform"
}

resource "databricks_volume" "volume1" {
  name             = "taxformsource_volume"
  catalog_name     = databricks_schema.things.catalog_name
  schema_name      = databricks_schema.second_schema.name
  volume_type      = "EXTERNAL"
  storage_location = "abfss://lakehouse2@zuse2devedlstr01.dfs.core.windows.net/"
  comment          = "this volume is managed by terraform"
}

resource "databricks_volume" "volume2" {
  name             = "taxforms_sourace_sample"
  catalog_name     = databricks_schema.things.catalog_name
  schema_name      = databricks_schema.second_schema.name
  volume_type      = "EXTERNAL"
  storage_location = "abfss://edlunitycatalog4@zuse2devedlstr01.dfs.core.windows.net/"
  comment          = "this volume is managed by terraform"
}

