terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

# Configure AWS Providers for both regions
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
#   call provider: provider = aws.virginia
}

provider "aws" {
  alias  = "tokyo"
  region = "ap-northeast-1"
#   call provider: provider = aws.tokyo
}

provider "aws" {
  # Configuration options
  region = var.setup.australia
  alias  = "australia"
}

provider "aws" {
  # Configuration options
  region = var.setup.california
  alias  = "california"
}
provider "aws" {
  # Configuration options
  region = var.setup.london
  alias  = "london"
}

provider "aws" {
  # Configuration options
  region = var.setup.sao-paulo
  alias  = "sao-paulo"
}

provider "aws" {
  # Configuration options
  region = var.setup.hong-kong
  alias  = "hong-kong"
}

provider "aws" {
  # Configuration options
  region = var.setup.tokyo-test
  alias  = "tokyo-test"
}