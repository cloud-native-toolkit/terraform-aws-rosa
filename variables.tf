variable "name_prefix" {
  type        = string
  description = "Prefix to be added to the names of resources which are being provisioned"
  default     = "swe"
}

variable "region" {
  type        = string
  default     = ""
  description = "Please set the region where the resouces to be created"
}

variable "resource_group_name" {
  type        = string
  default     = ""
  description = "Please set the default resource group with tags"
}

variable "rosa_token" {
  type        = string
  default     = ""
  sensitive = true
  description = "get an offline access token at https://cloud.redhat.com/openshift/token/rosa "
}

variable "dry_run" {
  type        = bool
  description = "Set to true to dry the command just to verify. Else set to false to actually run the cmd"
  default     = false
}

variable "existing_vpc" {
  type        = bool
  default     = true
  description = "Flag to identify if VPC already exists. Default set to true. Used to identify to pass the subnet ids to create the ROSA cluster"
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
  default     = ""
  description = "Instance type for the compute nodes. Determines the amount of memory and vCPU allocated to each compute node."
}
variable "machine-cidr" {
  type        = string
  default     = ""
  description = "ipNet Block of IP addresses used by OpenShift while installing the cluster, for example 10.0.0.0/16 "
}
variable "service-cidr" {
  type        = string
  default     = "172.30.0.0/16"
  description = "ipNet Block of IP addresses for services, for example 172.30.0.0/16 "
}

variable "pod-cidr" {
  type        = string
  default     = "10.128.0.0/14"
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
variable "subnet_ids" {
  type        = list(string)
  description = "To create cluster in existing VPC, public and private Subnet ids should be given ."
  default     = [""]
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "To create cluster in existing VPC, public and private Subnet ids should be given ."
  default     = []
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "To create cluster in existing VPC, public and private Subnet ids should be given ."
  default     = []
}

variable "multi-zone-cluster" {
  type = bool
  default = false
  description = " Deploy to multiple data centers"
}


variable "private-link" {
  type = bool
  default = false
  description = "Provides private connectivity between VPCs, AWS services, and your on-premises networks, without exposing your traffic to the public internet"
}


