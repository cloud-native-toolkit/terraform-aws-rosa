
locals {
  tmp_dir = "${path.cwd}/.tmp"
  kube_config    = "${local.tmp_dir}/cluster/.kube"  
  cred_file_name = "rosa_admin_cred.json"
  cluster_info_file_name="cluster_info.json"    
}
data external dirs {
  program = ["bash", "${path.module}/scripts/create-dirs.sh"]

  query = {
    tmp_dir = "${local.tmp_dir}"
    kube_config = "${local.tmp_dir}/.kube"    
  }
}
resource "null_resource" "create_rosa_user" {
  depends_on = [
    module.setup_clis,    
    null_resource.create-rosa-cluster,
    null_resource.wait-for-cluster-ready,
    data.external.dirs
  ]
   
  triggers = {
    #bin_dir      = local.bin_dir
    tmp_dir  = data.external.dirs.result.tmp_dir
    cred_file_name    = local.cred_file_name
    cluster_info_file_name=local.cluster_info_file_name
    cluster_name = local.cluster_name    
    region          = var.region
    
  }
  provisioner "local-exec" {
    when = create  
      command = "${path.module}/scripts/create-rosa-user.sh ${self.triggers.cluster_name} ${self.triggers.region} ${self.triggers.tmp_dir} ${self.triggers.cred_file_name} ${self.triggers.cluster_info_file_name}  "
    environment = {
        BIN_DIR=module.setup_clis.bin_dir
        ROSA_TOKEN=nonsensitive(var.rosa_token)      
    }
  }

}

data external getClusterAdmin {
    depends_on = [
    module.setup_clis,      
    null_resource.create-rosa-cluster,
    null_resource.wait-for-cluster-ready,
    null_resource.create_rosa_user,
    data.external.dirs
  ]
  program = ["bash", "${path.module}/scripts/get-cluster-admin.sh"]       
  query = {
    bin_dir=local.bin_dir
    tmp_dir  = data.external.dirs.result.tmp_dir
    cred_file_name=local.cred_file_name
    cluster_info_file_name=local.cluster_info_file_name
  }
}

data external oc_login {
    depends_on = [
        module.setup_clis,      
        null_resource.create-rosa-cluster,
        null_resource.wait-for-cluster-ready,
        data.external.dirs,
        null_resource.create_rosa_user,
        data.external.getClusterAdmin
    ]
    program = ["bash", "${path.module}/scripts/oc-login.sh"]       
    query ={
        bin_dir=local.bin_dir
        serverUrl = data.external.getClusterAdmin.result.serverURL
        username = data.external.getClusterAdmin.result.adminUser
        password = data.external.getClusterAdmin.result.adminPwd
        clusterStatus=data.external.getClusterAdmin.result.clusterStatus        
        tmp_dir = data.external.dirs.result.tmp_dir
        kube_config = data.external.dirs.result.kube_config

    }    
 }
 
 resource null_resource print_oc_login_status {
  
  depends_on = [
    data.external.oc_login
  ]
  provisioner "local-exec" {
    command = "echo 'oc login message : ${data.external.oc_login.result.status}, clusterStatus: ${data.external.getClusterAdmin.result.clusterStatus}, loginStatus: ${data.external.oc_login.result.message}'"
  }
} 

