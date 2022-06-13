module "dev_pub_subnet" {
  source      = "github.com/cloud-native-toolkit/terraform-aws-vpc-subnets"
  provision   = var.provision
  region = var.region
  name_prefix = var.name_prefix

  label    = "public"
  vpc_name = module.dev_vpc.vpc_name
  #subnet_cidrs              = ["10.0.0.0/20","10.0.125.0/24"]
  #availability_zones              = ["ap-south-1a","ap-south-1b"]
  subnet_cidrs       = var.pub_subnet_cidrs
  availability_zones = var.availability_zones
  gateways           = [module.dev_igw.igw_id]
  #acl_rules          = var.acl_rules_pub
}

module "dev_ngw" {

  source              = "github.com/cloud-native-toolkit/terraform-aws-nat-gateway"
  _count              = length(var.pub_subnet_cidrs) 
  provision           = var.provision
  resource_group_name = var.resource_group_name
  name_prefix         = var.name_prefix
  connectivity_type   = "public"
  subnet_ids          = module.dev_pub_subnet.subnet_ids

}

module "dev_priv_subnet" {
  source = "github.com/cloud-native-toolkit/terraform-aws-vpc-subnets"
  provision   = var.provision
  name_prefix = var.name_prefix
  region=var.region
  label    = "private"
  vpc_name = module.dev_vpc.vpc_name
  #subnet_cidrs = ["10.0.128.0/20","10.0.144.0/20"]
  #availability_zones = ["ap-south-1a","ap-south-1b"]
  subnet_cidrs       = var.priv_subnet_cidrs
  availability_zones = var.availability_zones
  #acl_rules          = var.acl_rules_pri
  gateways           = module.dev_ngw.ngw_id
}



