locals {
  cluster_name = var.cluster_name != "" && var.cluster_name != null ? var.cluster_name : "${var.name_prefix}-cluster"
  #//for local testing 
  #bin_dir       = "/usr/local/bin"
  bin_dir        = module.setup_clis.bin_dir
  cred_dir       = "${path.cwd}/rosa_user_creds"
  cred_file_name = "rosa_admin_cred"

  #join_subnets = var.existing_vpc ? join(",", [var.public_subnet_ids[0], var.private_subnet_ids[0]]) : ""
  join_subnets = var.existing_vpc ? join(",", var.public_subnet_ids, var.private_subnet_ids): ""
  cmd_dry_run = var.dry_run ? " --dry-run" : ""
  multizone = var.multi-zone-cluster ? " --multi-az" : ""
  clsuter_cmd = " --cluster-name ${local.cluster_name} --region ${var.region} --version ${var.ocp_version} --compute-nodes ${var.no_of_compute_nodes} --machine-cidr ${var.machine-cidr} --service-cidr ${var.service-cidr} --pod-cidr ${var.pod-cidr} --host-prefix ${var.host-prefix} --etcd-encryption ${local.multizone} ${local.cmd_dry_run}"

  cluster_vpc_cmd = var.existing_vpc ? join(" ", [local.clsuter_cmd, " --subnet-ids ", local.join_subnets]) : ""

  create_clsuter_cmd = var.existing_vpc ? local.cluster_vpc_cmd : local.clsuter_cmd

}
module "setup_clis" {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
  clis   = ["yq", "jq", "igc", "rosa"]
  # clis   = ["helm", "rosa"]

}

resource "null_resource" "create_dirs" {
  triggers = {
    bin_dir  = local.bin_dir
    cred_dir = local.cred_dir
  }
  provisioner "local-exec" {
    command = "mkdir -p ${self.triggers.cred_dir}"
  }
}

resource "null_resource" "create-rosa-cluster" {
  triggers = {
    bin_dir            = local.bin_dir
    cred_dir           = local.cred_dir
    create_clsuter_cmd = local.create_clsuter_cmd
    cluster_name       = local.cluster_name
  }
  depends_on = [
    module.setup_clis
  ]
  provisioner "local-exec" {
    when    = create
    command = <<-EOF
    ${self.triggers.bin_dir}/rosa login --token=${var.rosa_token}
    ${self.triggers.bin_dir}/rosa verify quota --region=${var.region}
    ${self.triggers.bin_dir}/rosa init
    ${self.triggers.bin_dir}/rosa create cluster ${self.triggers.create_clsuter_cmd}
    EOF
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOF
    ${self.triggers.bin_dir}/rosa delete cluster --cluster='${self.triggers.cluster_name}' --yes 
    echo 'Sleeping for 2m'
    sleep 120
  EOF

  }
}

resource null_resource wait-for-cluster-ready {
  depends_on = [null_resource.create-rosa-cluster]
  
  provisioner "local-exec" {
    when = create  
    command = "${path.module}/scripts/wait-for-cluster-ready.sh ${local.cluster_name}"

    environment = {
      BIN_DIR = module.setup_clis.bin_dir
    }
  }
}


resource "null_resource" "create_rosa_user" {
  depends_on = [
    null_resource.create-rosa-cluster,
    null_resource.create_dirs,
    null_resource.wait-for-cluster-ready
  ]
  triggers = {
    bin_dir      = local.bin_dir
    cred_dir     = local.cred_dir
    cred_file_name    = local.cred_file_name
    cluster_name = local.cluster_name
  }
  provisioner "local-exec" {
    command = <<-EOF
      #echo "Sleeping for 15m"
      #sleep 900
      ${self.triggers.bin_dir}/rosa create admin --cluster=${self.triggers.cluster_name} > ${self.triggers.cred_dir}/${self.triggers.cred_file_name}
      echo "Sleeping for 2m"
      sleep 120
    EOF  
  }
}

data "local_file" "read_creds" {
  depends_on = [
    null_resource.create_rosa_user,
    null_resource.create_dirs
  ]
  filename = "${local.cred_dir}/${local.cred_file_name}"
}

locals {
  ocp_api_server_url = data.local_file.read_creds.content != null ? regex("https://[a-zA-z0-9-.:]+", data.local_file.read_creds.content):""

  ocp_cluster_admin_user = data.local_file.read_creds.content != null ? trimprefix(regex("--username\\s*\\S*", data.local_file.read_creds.content), "--username ") :""

  ocp_cluster_admin_pwd = data.local_file.read_creds.content != "" ? trimprefix(regex("--password\\s*\\S*", data.local_file.read_creds.content), "--password ") :""

}
  