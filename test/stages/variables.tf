variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "Please set the region where the resouces to be created "
}

variable "cloud_provider" {
  type    = string
  default = "aws"
}

variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}
variable "rosa_token" {
  type        = string
  default     = ""
  description = ""
}

variable "resource_group_name" {
  type        = string
  description = "Existing resource group where the IKS cluster will be provisioned."
  default     = "default"
}

variable "name_prefix" {
  type        = string
  description = "Prefix to be added to the names of resources which are being provisioned"
  default     = "swe"
}

variable "provision" {
  type        = bool
  description = "Flag indicating that the instance should be provisioned. If false then an existing instance will be looked up"
  default     = true
}


variable "cluster_name" {
  type        = string
  default     = ""
  description = "Name of the RedHat OpenShift Cluster"
}

variable "ocp_version" {
  type        = string
  default     = "4.9.15"
  description = "Version of OpenShift that will be used to install the cluster"
}

variable "no_of_compute_nodes" {
  type        = number
  default     = 2
  description = "Number of worker nodes to be provisioned"
}

variable "compute-machine-type" {
  type        = string
  default     = "m5.xlarge"
  description = "Instance type for the compute nodes. Determines the amount of memory and vCPU allocated to each compute node."
}
variable "machine-cidr" {
  type        = string
  default     = ""
  description = "ipNet Block of IP addresses used by OpenShift while installing the cluster, for example 10.0.0.0/16 "
}
variable "service-cidr" {
  type        = string
  default     = ""
  description = "ipNet Block of IP addresses for services, for example 172.30.0.0/16 "
}

variable "pod-cidr" {
  type        = string
  default     = ""
  description = "ipNet Block of IP addresses from which Pod IP addresses are allocated, for example 10.128.0.0/14 "
}
variable "host-prefix" {
  type        = number
  default     = 23
  description = "Subnet prefix length to assign to each individual node. For example, if host prefix is set to 23, then each node is assigned a /23 subnet out of the given CIDR."
}
variable "etcd-encryption" {
  type        = string
  default     = ""
  description = "Add etcd encryption. By default etcd data is encrypted at rest. This option configures etcd encryption on top of existing storage encryption."
}

variable "multi-zone-cluster" {
  type        = bool
  default     = false
  description = " Deploy to multiple data centers"
}

variable "gateways_count" {
  type        = number
  default     = 1
  description = "Number of NAT gateways"
}


variable "private-link" {
  type        = bool
  default     = false
  description = "Provides private connectivity between VPCs, AWS services, and your on-premises networks, without exposing your traffic to the public internet"
}

variable "existing_vpc" {
  type        = bool
  default     = true
  description = "Flag to identify if VPC already exists. Default set to true. Used to identify to pass the subnet ids to create the ROSA cluster"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "To create cluster in existing VPC, public and private Subnet ids should be given ."
  default     = [""]
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "To create cluster in existing VPC, public and private Subnet ids should be given ."
  default     = [""]
}

variable "dry_run" {
  type        = bool
  description = "Set to true to dry the command just to verify. Else set to false to actually run the cmd"
  default     = false
}



variable "pub_subnet_cidrs" {
  type        = list(string)
  description = "The cidr range of the Public subnet."
  #default=["10.0.0.0/20"]
}
variable "priv_subnet_cidrs" {
  type        = list(string)
  description = "The cidr range of the Private subnet."
  #default=["10.0.128.0/20"]
}

variable "availability_zones" {
  description = "List of availability zone ids"
  type        = list(string)
  default     = []
}
variable "acl_rules_pub" {
  type    = list(map(string))
  default = []
}
variable "acl_rules_pri" {
  description = "Private subnets inbound network ACLs"
  type        = list(map(string))
  default     = []
}

variable "connectivity_type" {
  type        = string
  description = "(Optional) Connectivity type for the gateway. Valid values are private and public. Defaults to public."
  default     = "public"
}


variable "instance_tenancy" {
  type        = string
  description = "Instance is shared / dedicated, etc. #[default, dedicated, host]"
  default     = "default"
}
variable "internal_cidr" {
  type        = string
  description = "The cidr range of the internal network.Either provide manually or chose from AWS IPAM poolsß"
  default     = "10.0.0.0/16"
}
