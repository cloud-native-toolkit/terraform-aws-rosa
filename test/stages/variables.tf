variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "Please set the region where the resouces to be created "
}

variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}

variable "prefix_name" {
  type        = string
  description = "Prefix to be added to the names of resources which are being provisioned"
  default     = "swe"
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

variable "provision" {
  type        = bool
  description = "Flag indicating that the instance should be provisioned. If false then an existing instance will be looked up"
  default     = true
}
variable "vpc_id" {
  type        = string
  description = "The id of the existing VPC instance"
  default     = ""
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "(Required) The CIDR block for the private subnet."
  default     = ["10.0.125.0/24"]
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "(Required) The CIDR block for the public subnet."
  default     = ["10.0.0.0/20"]
}


variable "tags" {
  type = map(string)
  default = {
    project = "swe"
  }
  description = "(Optional) A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
}

variable "public_subnet_tags" {
  description = "Tags for public subnets"
  type        = map(string)
  default = {
    tier = "public"
  }
}

variable "private_subnet_tags" {
  description = "Tags for private subnets"
  type        = map(string)
  default = {
    tier = "private"
  }
}

variable "availability_zones" {
  description = "List of availability zone ids"
  type        = list(string)
  default     = [""]
}

variable "acl_rules_pub_in" {
  type        = list(map(string))
  default = []
}

variable "acl_rules_pub_out" {
  type        = list(map(string))
  default = []
}

variable "acl_rules_pri_in" {
  description = "Private subnets inbound network ACLs"
  type        = list(map(string))
  default = []
}

variable "acl_rules_pri_out" {
  type        = list(map(string))
  default = []
}
