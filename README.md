# Terraform VPC Generator
---

This is a basic terraform module which creates an VPC with public and private subnets, NAT Gateways for each pribate subnet, with the proper route tables associated.

## Usage
---

	module "vpc" {
	
	  source = "github.com/rherranzg/terraform_vpc_generator/"
	
	  vpc_cidr = "10.0.0.0/16"
	  public_subnets = [ "10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24" ]
	  private_subnets = [ "10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24" ]
	
	  private_infra = "true"
	}

## Outputs
---

- `vpc_id` - VPC ID of the generated VPC
- `public_subnets` - List of the public subnets generated