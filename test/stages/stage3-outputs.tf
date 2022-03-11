# output "cluster_admin_creds" {
#   value = ""
# }

output "ocp_api_server_url" {
  value = module.dev_aws_rosa.ocp_api_server_url

}

output "ocp_cluster_admin_user" {
  value = module.dev_aws_rosa.ocp_cluster_admin_user

}
output "ocp_cluster_admin_pwd" {
  value = module.dev_aws_rosa.ocp_cluster_admin_pwd

}

output "vpc_id" {
  depends_on = [
    module.dev_vpc
  ]
  value = module.dev_vpc.vpc_id

}
output "vpc_name" {
  depends_on = [
    module.dev_vpc
  ]
  value = module.dev_vpc.vpc_name
}

output "public_subnet_ids" {
  depends_on = [
    module.dev_pub_subnet
  ]
  value = module.dev_pub_subnet.subnet_ids

}


output "private_subnet_ids" {
  depends_on = [
    module.dev_priv_subnet
  ]
  value = module.dev_priv_subnet.subnet_ids
}
