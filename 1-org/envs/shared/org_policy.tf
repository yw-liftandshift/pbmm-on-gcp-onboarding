locals {
  boolean_type_organization_policies = toset([
    "compute.managed.disableNestedVirtualization",
    "compute.managed.disableSerialPortAccess",
    "compute.skipDefaultNetworkCreation",
    "compute.restrictXpnProjectLienRemoval",
    "compute.managed.requireOsLogin",
    "compute.managed.vmCanIpForward",
    "compute.managed.vmExternalIpAccess",
    "compute.managed.blockPreviewFeatures",
    "compute.disableGuestAttributesAccess",
    "commerceorggovernance.disablePublicMarketplace",
    "cloudbuild.useComputeServiceAccount",
    "cloudbuild.disableCreateDefaultServiceAccount",
    "cloudbuild.useBuildServiceAccount",
    "sql.restrictPublicIp",
    "iam.managed.disableServiceAccountApiKeyCreation",
    "iam.managed.disableServiceAccountKeyUpload",
    "storage.uniformBucketLevelAccess",
    "storage.publicAccessPrevention",
  ])

  list_type_organization_policies = toset([
    "appengine.runtimeDeploymentExemption",
    "compute.sharedReservationsOwnerProjects",
    "commerceorggovernance.marketplaceServices",
    "iam.allowServiceAccountCredentialLifetimeExtension",
    "resourcemanager.allowedExportDestinations",
    "resourcemanager.allowedImportSources",
    "resourcemanager.allowEnabledServicesForExport",
    "vertexai.allowedPartnerModelFeatures",
  ])
}

/******************************************
 Boolean Organization Policies
*******************************************/
module "organization_policies_type_boolean" {
  source   = "./../../modules/org-policy-v2"
  for_each = local.boolean_type_organization_policies

  policy_root      = "folder"            # either of organization, folder or project
  policy_root_id   = local.parent_folder # either of org id, folder id or project id
  constraint       = each.value
  policy_type      = "boolean"
  exclude_folders  = [google_folder.sandbox.id]
  exclude_projects = []

  rules = [
    {
      enforcement = true
    }
  ]
}

/******************************************
 Service Account Key Creation Policy
*******************************************/
module "organization_policies_service_account" {
  source = "./../../modules/org-policy-v2"

  policy_root      = "folder"
  policy_root_id   = local.parent_folder
  constraint       = "iam.managed.disableServiceAccountKeyCreation"
  policy_type      = "boolean"
  exclude_folders  = [google_folder.sandbox.id]
  exclude_projects = []

  rules = [
    {
      enforcement = true
    }
  ]
}

/******************************************
 List Organization Policies
*******************************************/
module "organization_policies_type_list" {
  source   = "./../../modules/org-policy-v2"
  for_each = local.list_type_organization_policies

  policy_root      = "folder"
  policy_root_id   = local.parent_folder
  constraint       = each.value
  policy_type      = "list"
  exclude_folders  = [google_folder.sandbox.id]
  exclude_projects = []

  rules = [
    {
      enforcement = true
    }
  ]
}

/******************************************
 Resource Location Policy
*******************************************/
module "organization_policies_resource_location" {
  source = "./../../modules/org-policy-v2"

  policy_root      = "folder"
  policy_root_id   = local.parent_folder
  constraint       = "gcp.resourceLocations"
  policy_type      = "list"
  exclude_folders  = [google_folder.sandbox.id]
  exclude_projects = []

  rules = [
    {
      enforcement = true
      allow       = var.allowed_gcp_resource_locations
    }
  ]
}

/******************************************
 Service Account Key Expiry Hours Policy
*******************************************/
module "organization_policies_sa_key_expiry" {
  source = "./../../modules/org-policy-v2"

  policy_root      = "folder"
  policy_root_id   = local.parent_folder
  constraint       = "iam.serviceAccountKeyExpiryHours"
  policy_type      = "list"
  exclude_folders  = [google_folder.sandbox.id]
  exclude_projects = []

  rules = [
    {
      enforcement = true
      allow       = ["2160h"]
    }
  ]
}

/******************************************
 Service Account Key Exposure Response Policy
*******************************************/
module "organization_policies_sa_key_exposure" {
  source = "./../../modules/org-policy-v2"

  policy_root      = "folder"
  policy_root_id   = local.parent_folder
  constraint       = "iam.serviceAccountKeyExposureResponse"
  policy_type      = "list"
  exclude_folders  = [google_folder.sandbox.id]
  exclude_projects = []

  rules = [
    {
      enforcement = true
      allow       = ["DISABLE_KEY"]
    }
  ]
}

# /******************************************
#   Essential Contacts
# *******************************************/

# module "domain_restricted_contacts" {
#   source  = "terraform-google-modules/org-policy/google"
#   version = "~> 5.1"
#   folder_id         = local.parent_folder
#   policy_for        = "folder"
#   policy_type       = "list"
#   allow_list_length = length(local.essential_contacts_domains_to_allow)
#   allow             = local.essential_contacts_domains_to_allow
#   constraint        = "constraints/essentialcontacts.allowedContactDomains"
# }

# /******************************************
#   Access Context Manager Policy
# *******************************************/

resource "google_access_context_manager_access_policy" "access_policy" {
  count  = var.create_access_context_manager_access_policy ? 1 : 0
  parent = "organizations/${local.org_id}"
  title  = "default policy"
}