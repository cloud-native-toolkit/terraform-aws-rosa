# AWS Cloud ROSA module

Provisions Managed RedHat Openshift service on AWS Cloud
  

### Description

### Software dependencies

The module depends on the following software components:

#### Command-line tools

- terraform >= v0.15

#### Terraform providers

- AWS Cloud provider ~> 3.0

### Module dependencies

This module makes use of the output from other modules:

### Example usage

```hcl-terraform

terraform {
  required_version = ">= 0.15.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "dev_aws_rosa" {
  source = "github.com/cloud-native-toolkit/terraform-aws-rosa/"
  region = var.region
  name_prefix         = var.name_prefix
  rosa_token          = var.rosa_token #sensitive
  cluster_name        = var.cluster_name
  ocp_version         = var.ocp_version
  no_of_compute_nodes = var.no_of_compute_nodes
  machine-cidr        = var.machine-cidr
  service-cidr        = var.service-cidr
  pod-cidr            = var.pod-cidr
  host-prefix         = var.host-prefix

  public_subnet_ids  = module.dev_pub_subnet.subnet_ids
  private_subnet_ids = module.dev_priv_subnet.subnet_ids
  dry_run            = var.dry_run
  multi-zone-cluster = var.multi-zone-cluster
  private-link       = var.private-link
}

```
