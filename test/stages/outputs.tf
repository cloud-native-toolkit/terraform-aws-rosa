output "cluster_admin_creds" {
  value = ""
}

output "ocp_api_server_url" {
  value = module.dev_aws_rosa.ocp_api_server_url

}

output "ocp_cluster_admin_user" {
  value = module.dev_aws_rosa.ocp_cluster_admin_user

}
output "ocp_cluster_admin_pwd" {
  value = module.dev_aws_rosa.ocp_cluster_admin_pwd

}