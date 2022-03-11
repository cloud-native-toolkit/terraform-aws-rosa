terraform {
  required_version = ">= 0.15.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

module "setup_clis" {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
  clis   = ["yq", "jq", "rosa"]
  # clis   = ["helm", "rosa"]

}

resource "null_resource" "setup_clis" {
  depends_on = [
    module.setup_clis
  ]
  provisioner "local-exec" {
    #command = "echo -n '${module.clis.bin_dir}' > .bin_dir"
    command = "echo ${module.setup_clis.bin_dir} > .bin_dir"
  }
}