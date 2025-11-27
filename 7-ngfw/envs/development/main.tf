

module "firewall_endpoint_association_1" {

  source = "../../modules/firewall_endpoint_association"

  network_name = local.base_network_name
  associations = [
    {
        name = "base-association-region-1",
        region = local.default_region_1,
        firewall_endpoint_id = local.firewall_endpoint_1.id
    },
    {
        name = "base-association-region-2",
        region = local.default_region_2,
        firewall_endpoint_id = local.firewall_endpoint_2.id
    }        
  ]

  project_id = local.base_host_project_id

}

module "firewall_endpoint_association_2" {

  source = "../../modules/firewall_endpoint_association"

  network_name = local.restricted_network_name
  associations = [
    {
        name = "restricted-association-region-1",
        region = local.default_region_1,
        firewall_endpoint_id = local.firewall_endpoint_1.id
    },
    {
        name = "restricted-association-region-2",
        region = local.default_region_2,
        firewall_endpoint_id = local.firewall_endpoint_2.id
    }        
  ]

  project_id = local.restricted_host_project_id


}
