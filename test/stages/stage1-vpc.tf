module "dev_vpc" {
  source    = "github.com/cloud-native-toolkit/terraform-aws-vpc"
  provision = var.provision

  /* Input params required to provision new VPC */
  prefix_name      = var.prefix_name
  internal_cidr    = var.internal_cidr
  instance_tenancy = var.instance_tenancy

  /*
  To retrieve details of existing VPC, set provision flag to false and provide vpc_id
  */
  #vpc_id=var.vpc_id
}
