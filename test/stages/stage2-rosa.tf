module "cluster" {
  source = "./module"
  region = var.region
  name_prefix           = var.name_prefix
  rosa_token            = var.rosa_token
  ocp_version           = var.ocp_version
  no_of_compute_nodes   = var.no_of_compute_nodes
  compute-machine-type  = var.compute-machine-type
  machine-cidr          = module.dev_vpc.vpc_cidr
  public_subnet_ids     = module.dev_pub_subnet.subnet_ids
  private_subnet_ids    = module.dev_priv_subnet.subnet_ids
  multi-zone-cluster    = var.multi-zone-cluster
  private-link          = var.private-link
  resource_group_name   = var.resource_group_name
}

resource "local_file" "cluster_creds" {
  filename = ".cluster_creds"
  content = jsonencode({
    server_url  = module.cluster.server_url
    username    = module.cluster.username
    password    = module.cluster.password
    token       = module.cluster.token
  })
}




