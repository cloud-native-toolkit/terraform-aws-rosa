#output "myoutput" {
#  description = "Description of my output"
#  value       = "value"
#  depends_on  = [<some resource>]
#}
output "ocp_api_server_url" {
  value      = local.ocp_api_server_url
  depends_on = [null_resource.create_rosa_user]
}

output "ocp_cluster_admin_user" {
  value      = local.ocp_cluster_admin_user
  depends_on = [null_resource.create_rosa_user]
}
output "ocp_cluster_admin_pwd" {
  value      = local.ocp_cluster_admin_pwd
  depends_on = [null_resource.create_rosa_user]
}