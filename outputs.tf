output "ocp_api_server_url" {
  #value      = local.ocp_api_server_url
  #depends_on = [null_resource.create_rosa_user]
  value = ""
}

output "ocp_cluster_name" {
  
  value = local.cluster_name
}