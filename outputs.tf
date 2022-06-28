output "id" {
  value       = data.external.getClusterAdmin.result.clusterID
  description = "ID of the cluster."
  depends_on  = [
    data.external.getClusterAdmin
  ]
}

output "name" {
  value       = local.cluster_name   
  description = "Name of the cluster."
}

output "resource_group_name" {
  value       = var.resource_group_name
  description = "Name of the resource group containing the cluster."
  
}

output "region" {
  value       = var.region
  description = "Region containing the cluster."
  
}


output "server_url" {
  description = "The url used to connect to the api server. If the cluster has public endpoints enabled this will be the public api server, otherwise this will be the private api server url"
  value = data.external.getClusterAdmin.result.serverURL
  depends_on  = [
    data.external.getClusterAdmin
  ]
}

output "console_url" {
  description = "The url of the OCP console. "
  value = data.external.getClusterAdmin.result.consoleUrl
  depends_on  = [
    data.external.getClusterAdmin
  ]
}

output "platform" {
  value = {
    id         = data.external.getClusterAdmin.result.clusterID
    kubeconfig=   data.external.oc_login.result.kube_config 
    
    server_url = data.external.getClusterAdmin.result.serverURL
    type       = local.cluster_type
    type_code  = local.cluster_type_code
    version    = local.cluster_version
    ingress    = data.external.getClusterAdmin.result.clusterDNS
    tls_secret = ""
  }
  depends_on  = [
    data.external.getClusterAdmin,
    data.external.oc_login
   

  ]
}


output "config_file_path" {
  value =  data.external.oc_login.result.kube_config 


  description = "Path to the config file for the cluster."
  depends_on  = [
    data.external.getClusterAdmin,
    data.external.oc_login
  ]
  
}
output "token" {
  description = "The admin user token used to generate the cluster"
  value = data.external.oc_login.result.token 
  
  #sensitive = true
  depends_on  = [
    data.external.getClusterAdmin,
   data.external.oc_login
  ]
}

output "username" {
  description = "The username of the admin user for the cluster"
  value = data.external.getClusterAdmin.result.adminUser
  #sensitive = true
  depends_on  = [
    data.external.getClusterAdmin
  ]
}

output "password" {
  description = "The password of the admin user for the cluster"
  value = data.external.getClusterAdmin.result.adminPwd
  #sensitive = true
  depends_on  = [
    data.external.getClusterAdmin
  ]
}




output "domainname" {
  description = "The domain name  for the cluster"
  value = data.external.getClusterAdmin.result.clusterDNS
  depends_on  = [
    data.external.getClusterAdmin
  ]
}