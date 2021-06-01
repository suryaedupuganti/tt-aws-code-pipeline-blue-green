terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
  }
}


locals {
  default_tags = {
    owner        = "surya",
    organization = "Takt-Time",
    project      = "AWS-code-pipeline"
  }
  default_prefix = "SVP"
}

module "network" {
  source = "./modules/network"

  cidr_block                 = "10.0.0.0/16"
  vpc_name                   = "vpc_eu-west-1"
  availability_zones         = ["eu-west-1a", "eu-west-1b"]
  private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_cidr_blocks  = ["10.0.3.0/24", "10.0.4.0/24"]
  default_prefix             = local.default_prefix
  default_tags               = local.default_tags
}

module "nlb" {
  source = "./modules/nlb"

  public_subnet_ids = module.network.public_subnet_ids
  default_tags      = local.default_tags
  default_prefix    = local.default_prefix
}
