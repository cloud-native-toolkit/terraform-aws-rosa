module "dev_vpc" {
  source               = "github.com/cloud-native-toolkit/terraform-aws-vpc"
  provision            = var.provision && var.cloud_provider == "aws" ? true : false
  name_prefix          = var.name_prefix
  internal_cidr        = var.internal_cidr
  resource_group_name  = var.resource_group_name
  #enable_dns_hostnames = true
  #instance_tenancy     = var.instance_tenancy

}
