# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 5.0.0"
#     }
#   }
# }

# # Configure AWS Providers for both regions
# provider "aws" {
#   alias  = "virginia"
#   region = "us-east-1"
# #   call provider: provider = aws.virginia
# }

# provider "aws" {
#   alias  = "tokyo"
#   region = "ap-northeast-1"
# #   call provider: provider = aws.tokyo
# }

module "virginia-network" {
    # source: "./[MODULES]/[NAME]"
    source = "./modules/network"
    providers = {
        aws = aws.virginia
    }
    network = var.virginia-network
}

module "tokyo-network" {
    source = "./modules/network"
    providers = {
        aws = aws.tokyo
    }

    network = var.tokyo-network
}

# module "australia-network" {
#     source = "./modules/network"
#     providers = {
#         aws = aws.australia
#     }

#     network = var.australia-network
# }

# module "california-network" {
#     source = "./modules/network"
#     providers = {
#         aws = aws.california
#     }

#     network = var.california-network
# }

# module "hong-kong-network" {
#     source = "./modules/network"
#     providers = {
#         aws = aws.hong-kong
#     }

#     network = var.hong-kong-network
# }

# module "london-network" {
#     source = "./modules/network"
#     providers = {
#         aws = aws.london
#     }

#     network = var.london-network
# }

# module "sao-paulo-network" {
#     source = "./modules/network"
#     providers = {
#         aws = aws.sao-paulo
#     }

#     network = var.sao-paulo-network
# }

# module "tokyo-test-network" {
#     source = "./modules/network"
#     providers = {
#         aws = aws.tokyo-test
#     }

#     network = var.tokyo-test-network
# }