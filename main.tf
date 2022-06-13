locals {
  cluster_name = var.cluster_name != "" && var.cluster_name != null ? var.cluster_name : "${var.name_prefix}-cluster"
  bin_dir        = module.setup_clis.bin_dir
  compute_nodes = var.multi-zone-cluster ? (var.no_of_compute_nodes * 3) : var.no_of_compute_nodes
  #join_subnets = var.existing_vpc ? join(",", var.public_subnet_ids, var.private_subnet_ids): ""
  join_subnets = var.existing_vpc ? (var.private-link ?  join(",",  var.private_subnet_ids ): join(",", var.public_subnet_ids, var.private_subnet_ids)) :  ""
  cmd_dry_run = var.dry_run ? " --dry-run" : ""
  multizone = var.multi-zone-cluster ? " --multi-az" : ""
  privatelink = var.private-link ? " --private-link" : ""
  clsuter_cmd = " --cluster-name ${local.cluster_name} --region ${var.region} --version ${var.ocp_version} --compute-nodes ${local.compute_nodes} --machine-cidr ${var.machine-cidr} --service-cidr ${var.service-cidr} --pod-cidr ${var.pod-cidr} --host-prefix ${var.host-prefix} --etcd-encryption ${local.multizone} ${local.privatelink} ${local.cmd_dry_run} --yes"
  cluster_vpc_cmd = var.existing_vpc ? join(" ", [local.clsuter_cmd, " --subnet-ids ", local.join_subnets]) : ""
  create_clsuter_cmd = var.existing_vpc ? local.cluster_vpc_cmd : local.clsuter_cmd

  cluster_type          = "openshift"
  # value should be ocp4, ocp3, or kubernetes
  cluster_type_code     = "ocp4"
  cluster_type_tag      = "ocp"
  cluster_version       = "${var.ocp_version}_openshift"


}
module "setup_clis" {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"

  clis   = ["jq", "igc", "rosa", "oc"]
}
resource null_resource print_names {
  provisioner "local-exec" {
    when    = create
    command = <<-EOF
      echo Cluster command : ${local.create_clsuter_cmd}
    EOF
  }
}

resource "null_resource" "create-rosa-cluster" {
  triggers = {
    bin_dir            = local.bin_dir
    create_clsuter_cmd = local.create_clsuter_cmd
    cluster_name       = local.cluster_name
    rosa_token        = var.rosa_token
    region          = var.region
  }
  depends_on = [
    module.setup_clis,
    null_resource.print_names
  ]


  provisioner "local-exec" {
    when    = create
    command = <<-EOF
    ${self.triggers.bin_dir}/rosa login --token=${var.rosa_token}
    ${self.triggers.bin_dir}/rosa verify quota --region=${self.triggers.region}
    ${self.triggers.bin_dir}/rosa init --region=${self.triggers.region}
    ${self.triggers.bin_dir}/rosa create cluster ${self.triggers.create_clsuter_cmd}
    EOF
  }

 provisioner "local-exec" {
    when    = destroy
    command = <<-EOF
      
      ${path.module}/scripts/delete_cluster.sh ${self.triggers.cluster_name}  ${self.triggers.region} ${self.triggers.rosa_token} ${self.triggers.bin_dir} 
      
    EOF
    
  } 
}

resource null_resource wait-for-cluster-ready {
 depends_on = [null_resource.create-rosa-cluster]
  
   triggers = {
    bin_dir            = local.bin_dir
    cluster_name       = local.cluster_name
    rosa_token         = var.rosa_token    
  }
  provisioner "local-exec" {
    when = create  
    command = "${path.module}/scripts/wait-for-cluster-ready.sh ${local.cluster_name} ${var.region}"

    environment = {
      BIN_DIR=module.setup_clis.bin_dir
      ROSA_TOKEN=nonsensitive(var.rosa_token)
      
    }
  }

}
