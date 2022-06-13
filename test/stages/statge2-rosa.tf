module "cluster" {
  source = "./module"
  region = var.region
  name_prefix         = var.name_prefix
  rosa_token          = var.rosa_token
  cluster_name        = var.cluster_name
  ocp_version         = var.ocp_version
  no_of_compute_nodes = var.no_of_compute_nodes
  machine-cidr        = var.machine-cidr
  public_subnet_ids  = module.dev_pub_subnet.subnet_ids
  private_subnet_ids = module.dev_priv_subnet.subnet_ids
#   #dry_run            = var.dry_run
  multi-zone-cluster = var.multi-zone-cluster
  private-link       = var.private-link
  # service-cidr        = var.service-cidr
  # pod-cidr            = var.pod-cidr
  # host-prefix         = var.host-prefix

}

resource "local_file" "cluster_creds" {
  filename = ".cluster_creds"
  content = jsonencode({
    server_url = module.cluster.server_url
    username = module.cluster.username
    password = module.cluster.password
    token = module.cluster.token
  })
}




