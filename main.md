```tf
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

variable "string" {
    type = string
    default = "Hello, World!"
}

variable "number" {
    type = number
    default = 10
}

variable "map" {
    type = map(string)
    default = {
        "key1" = "value1"
        "key2" = "value2"
    }
}

output "map" {
    value = var.map
}

# dot notation
output "map2" {
    value = var.map.key1
}

# bracket notation
output "map3" {
    value = var.map["key2"]
}

variable "map_of_maps" {
    type = map(map(string))
    default = {
        subnet_1 = {
            cidr_block = "10.0.1.0/24"
            name = "subnet_1"
        }
        subnet_2 = {
            cidr_block = "10.0.2.0/24"
            name = "subnet_2"
        }
        subnet_3 = {
            cidr_block = "10.0.3.0/24"
            name = "subnet_3"
        }

    }
}

output "map_of_maps" {
    value = var.map_of_maps
}

output "map_of_maps2" {
    value = var.map_of_maps.subnet_1
}

output "map_of_maps3" {
    value = var.map_of_maps.subnet_1.cidr_block
}

variable "three_map_string" {
    type = map(map(map(string)))
    default = {
        vpcs = {
            vpc_1 = {
                cidr_block = "10.0.0.0/16"
                name = "vpc_1"
            }
        }
        subnets = {
            subnet_1 = {
                cidr_block = "10.0.1.0/24"
                name = "subnet_1"
            }
        }
    }
} 

output "three_map_string" {
    value = var.three_map_string.vpcs.vpc_1.cidr_block
}


variable "virgina-network" {
    type = map(map(map(string)))
    default = {
        vpcs = {
            vpc-1 = {
                cidr_block = "10.40.0.0/16"
            }
            # vpc-2 = {
            #     cidr_block = "10.41.0.0/16"
            # }
        }
        subnets = {
            subnet-1 = {
                cidr_block = "10.40.1.0/24"
                name = "subnet-1"
                vpc = "vpc-1"
            }
            subnet-2 = {
                cidr_block = "10.40.2.0/24"
                name = "subnet-2"
                vpc = "vpc-1"
            }
            subnet-3 = {
                cidr_block = "10.40.3.0/24"
                name = "subnet-3"
                vpc = "vpc-1"
            }
        }
    }
}

# for_each 2. values each.value.[key_name], and each.key
# aws_vpc.main["vpc-1"]
resource "aws_vpc" "main" {
  for_each = var.virgina-network.vpcs
  cidr_block       = each.value.cidr_block

  tags = {
    # Name = each.key
    Name = "${each.key}-vpc"
  }
}

resource "aws_subnet" "main" {
  for_each = var.virgina-network.subnets
  # aws_vpc.main["vpc-1"]
  vpc_id     = aws_vpc.main[each.value.vpc].id
  cidr_block = each.value.cidr_block

  tags = {
    Name = each.key
  }
}
```