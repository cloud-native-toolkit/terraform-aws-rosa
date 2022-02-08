module "dev_aws_rosa" {
  source = "./module"
  region = var.region
  #provision           = true
  #prefix_name         = "swe-rosa"
  rosa_token          = var.rosa_token
  cluster_name        = var.cluster_name
  ocp_version         = var.ocp_version
  no_of_compute_nodes = var.no_of_compute_nodes
  machine-cidr        = var.machine-cidr
  service-cidr        = var.service-cidr
  pod-cidr            = var.pod-cidr
  host-prefix         = var.host-prefix
  public_subnet_ids   = var.public_subnet_ids
  private_subnet_ids  = var.private_subnet_ids
  dry_run             = var.dry_run
}

# resource "null_resource" "write_path" {
#   depends_on = [
#     "module.dev_aws_rosa"
#   ]
#   provisioner "local-exec" {
#     #command = "echo -n '${module.clis.bin_dir}' > .bin_dir"
#     command = "echo ${module.dev_aws_rosa} > .bin_dir"
#   }
# }