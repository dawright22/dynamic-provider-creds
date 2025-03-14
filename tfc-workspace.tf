provider "tfe" {
  hostname = var.tfc_hostname
}

# Runs in this workspace will be automatically authenticated
# to Azure with the permissions set in the Azure policy. TODO: che k if wording right
#
# https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace
resource "tfe_workspace" "my_workspace" {
  name         = var.tfc_workspace_name
  organization = var.tfc_organization_name
}

# The following variables must be set to allow runs
# to authenticate to Azyre.
#
# https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable
resource "tfe_variable" "enable_azure_provider_auth" {
  workspace_id = tfe_workspace.my_workspace.id

  key      = "TFC_AZURE_PROVIDER_AUTH"
  value    = "true"
  category = "env"

  description = "Enable the Workload Identity integration for Azure."
}

resource "tfe_variable" "tfc_azure_client_id" {
  workspace_id = tfe_workspace.my_workspace.id

  key      = "TFC_AZURE_RUN_CLIENT_ID"
  value    = azuread_application.tfc_application.client_id
  category = "env"

  description = "The Azure Client ID runs will use to authenticate."
}

resource "tfe_variable" "tfc_azure_subscription_id" {
  workspace_id = tfe_workspace.my_workspace.id
  category = "env"
  key = "ARM_SUBSCRIPTION_ID"
  value = data.azurerm_subscription.current.subscription_id

  description = "The Azure subscription ID runs will use to authenticate."
}

resource "tfe_variable" "tfc_azure_tenant_id" {
  workspace_id = tfe_workspace.my_workspace.id
  category = "env"
  key = "ARM_TENANT_ID"
  value = data.azurerm_subscription.current.tenant_id

  description = "The Azure tenant ID runs will use to authenticate."
}
