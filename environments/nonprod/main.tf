/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


###############################################################################
#                        Non-Production Network                               #
###############################################################################

# Module used to deploy the VPC Service control defined in nonp-vpc-svc-ctl.auto.tfvars
module "vpc-svc-ctl" {
  source                    = "../../modules/vpc-service-controls"
  policy_id                 = data.terraform_remote_state.common.outputs.access_context_manager_policy_id 
  parent_id                 = data.terraform_remote_state.common.outputs.access_context_manager_parent_id 
  regular_service_perimeter = var.nonprod_vpc_svc_ctl.regular_service_perimeter
  bridge_service_perimeter  = var.nonprod_vpc_svc_ctl.bridge_service_perimeter
  department_code           = local.organization_config.department_code
  environment               = local.organization_config.environment
  location                  = local.organization_config.location
  user_defined_string       = data.terraform_remote_state.common.outputs.audit_config.user_defined_string

  depends_on = [
    data.terraform_remote_state.common,
    module.net-host-prj,
    module.firewall
  ]
}

# Module use to deploy a project with a virtual private cloud
module "net-host-prj" {
  source                         = "../../modules/network-host-project"
  services                       = var.nonprod_host_net.services
  billing_account                = local.organization_config.billing_account
  tf_service_account_email       = data.terraform_remote_state.bootstrap.outputs.service_account_email
  parent                         = data.terraform_remote_state.common.outputs.folders_map_2_levels.NonProdNetworking.id 
  networks                       = var.nonprod_host_net.networks
  projectlabels                  = var.nonprod_host_net.labels
  department_code                = local.organization_config.department_code
  environment                    = local.organization_config.environment
  location                       = local.organization_config.location
  owner                          = local.organization_config.owner
  user_defined_string            = var.nonprod_host_net.user_defined_string
  additional_user_defined_string = var.nonprod_host_net.additional_user_defined_string
  depends_on = [
    data.terraform_remote_state.common
  ]
}


# Module is used to deploy firewall rules for the network host project 
module "firewall" {
  source          = "../../modules/firewall"
  project_id      = module.net-host-prj.project_id
  network         = module.net-host-prj.network_name[var.nonprod_host_net.networks[0].network_name] 
  custom_rules    = var.nonprod_firewall.custom_rules
  department_code = local.organization_config.department_code
  environment     = local.organization_config.environment
  location        = local.organization_config.location
  depends_on = [
    module.net-host-prj
  ]
}

# H.A VPN From GCP to On-Prem
module "vpn-prod-internal" {
  source  = "../../network/modules/vpn"
  version = "~> 1.2.0"

  project_id         = var.project_id
  network            = module.net-host-prj
  region             = var.region
  gateway_name       = var.gateway_name
  tunnel_name_prefix = var.tunnel_name_prefix
  shared_secret      = module.secret
  tunnel_count       = 1
  peer_ips           = ["", ""]

  route_priority = 1000
  remote_subnet  = ["", ""]
}

module "external_gateway" {
  source                = "../../network/modules/vpn"
  project  = var.project_id
  name     = module.ext_vpn_name.result
  redundancy_type = var.peer_external_gateway.redundancy_type
  dynamic "interface" {
    for_each = var.peer_external_gateway.interfaces
    content {
      id         = module.interface.value.id
      ip_address = module.interface.value.ip_address
    }
  }
}

module "tunnels" {
  source                          = "../../network/modules/vpn"
  project                         = var.project_id
  for_each                        = { for peer in var.peer_external_gateway.interfaces : peer.id => peer }
  region                          = var.region
  name                            = module.vpn_tunnel_name[each.key].result
  router                          = var.router_name
  peer_external_gateway           = module.external_gateway.self_link
  peer_external_gateway_interface = module.each.value.id
  vpn_gateway_interface           = module.each.value.id
  ike_version                     = var.tunnels.ike_version
  shared_secret                   = module.random_id.secret.b64_url
  vpn_gateway                     = module.ha_gateway.self_link
}

module "interface" {
  source     = "../../network/modules/vpn"
  project    = var.project_id
  for_each   = { for peer in var.peer_external_gateway.interfaces : peer.id => peer }
  name       = "${var.router_name}-interface-${each.value.id}"
  router     = var.router_name
  region     = var.region
  ip_range   = module.each.value.router_ip_range
  vpn_tunnel = module.tunnels[each.value.id].self_link
}

module "router_peer" {
  source     = "../../network/modules/vpn"
  project         = var.project_id
  for_each        = { for peer in var.peer_info : peer.peer_asn => peer}
  name            = "${var.router_name}-peer-${each.value.peer_asn}"
  router          = var.router_name
  region          = var.region
  peer_asn        = module.each.value.peer_asn
  peer_ip_address = module.each.value.peer_ip_address
  interface       = "${var.router_name}-interface-${index(var.peer_info, each.value)}"

  depends_on = [
      google_compute_router_interface.interface
  ]
}

module "secret" {
  source     = "../../network/modules/vpn"
  project         = var.project_id
  byte_length = 8
}
