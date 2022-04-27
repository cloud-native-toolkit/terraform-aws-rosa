output "ocp_api_server_url" {
  value = module.dev_aws_rosa.ocp_api_server_url

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


output "ocp_cluster_name" {
  depends_on = [
    module.dev_aws_rosa
  ]
  value = module.dev_aws_rosa.ocp_cluster_name
}