####################################################
## IMPORTANT VARS to think on each new deployment ##
####################################################
variable "vpc_cidr" {
  description = "Two first bytes in the VPC CIDR. This parameter must change among accounts"
  type = "string"
  #default = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC."
  type = "list"
  #default = [ "10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24" ]
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC."
  type = "list"
  #default = [ "10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24" ]
}

variable "private_infra" {
  description = "Create or not PRIVATE subnets / route tables / NAT Gateways, etc."
  default = "true"
}

## Less important vars

variable "region" {
  description = "Region in which infrastructure will be deployed"
  default = "eu-west-1"
}

variable "azs" {
  description = "AZs in the region in which infrastructure will be deployed"
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "enable_dns_hostnames" {
  description = "Should be true if you want to use private DNS within the VPC"
  default     = true
}

variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = "map"
  default     = {
    Name = "Genesis",
    Environment = "dev"
  }
}
