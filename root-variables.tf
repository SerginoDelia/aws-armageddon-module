variable "tokyo-network" {
    type = map(any) # same as map(map(map(string)))
    default = {
        vpcs = {
            tokyo = {
                cidr = "10.40.0.0/16"
                region = "ap-northeast-1"
            }
        }
        subnets = {
            tokyo-a-public = {
                cidr = "10.40.1.0/24"
                az = "ap-northeast-1a"
                vpc = "tokyo"
            }
            tokyo-c-public = {
                cidr = "10.40.3.0/24"
                az = "ap-northeast-1c"
                vpc = "tokyo"
            }
            tokyo-c-private = {
                cidr = "10.40.13.0/24"
                az = "ap-northeast-1c"
                vpc = "tokyo"
            }
            tokyo-d-private = {
                cidr = "10.40.14.0/24"
                az = "ap-northeast-1d"
                vpc = "tokyo"
            } 
        }
    }
}

variable "virginia-network" {
    type = map(any) # same as map(map(map(string)))
    default = {
        vpcs = {
            virginia = {
                cidr = "10.41.0.0/16"
                region = "us-east-1"
            }
        }
        subnets = {
            virginia-a-public = {
                cidr = "10.41.1.0/24"
                az = "us-east-1a"
                vpc = "virginia"
            }
            virginia-b-public = {
                cidr = "10.41.2.0/24"
                az = "us-east-1b"
                vpc = "virginia"
            }
            # virginia-c-private = {
            #     cidr = "10.41.13.0/24"
            #     az = "us-east-1c"
            #     vpc = "virginia"
            # }
        }
    }  
}

# variable "australia-network" {
#     type = map(any) # same as map(map(map(string)))
#     default = {
#         vpcs = {
#             australia = {
#                 cidr = "10.42.0.0/16"
#                 region = "ap-southeast-2"
#             }
#         }
#         subnets = {
#             australia-a-public = {
#                 cidr = "10.42.1.0/24"
#                 az = "ap-southeast-2a"
#                 vpc = "australia"
#             }
#             australia-b-public = {
#                 cidr = "10.42.2.0/24"
#                 az = "ap-southeast-2b"
#                 vpc = "australia"
#             }
#         }
#     }  
# }

# variable "california-network" {
#     type = map(any) # same as map(map(map(string)))
#     default = {
#         vpcs = {
#             california = {
#                 cidr = "10.43.0.0/16"
#                 region = "us-west-1"
#             }
#         }
#         subnets = {
#             california-a-public = {
#                 cidr = "10.43.1.0/24"
#                 az = "us-west-1a"
#                 vpc = "california"
#             }
#             california-b-public = {
#                 cidr = "10.43.2.0/24"
#                 az = "us-west-1b"
#                 vpc = "california"
#             }
#         }
#     }  
# }

# variable "hong-kong-network" {
#     type = map(any) # same as map(map(map(string)))
#     default = {
#         vpcs = {
#             hong-kong = {
#                 cidr = "10.44.0.0/16"
#                 region = "ap-east-1"
#             }
#         }
#         subnets = {
#             hong-kong-a-public = {
#                 cidr = "10.44.1.0/24"
#                 az = "ap-east-1a"
#                 vpc = "hong-kong"
#             }
#             hong-kong-b-public = {
#                 cidr = "10.44.2.0/24"
#                 az = "ap-east-1b"
#                 vpc = "hong-kong"
#             }
#         }
#     }  
# }

# variable "london-network" {
#     type = map(any) # same as map(map(map(string)))
#     default = {
#         vpcs = {
#             london = {
#                 cidr = "10.45.0.0/16"
#                 region = "eu-west-2"
#             }
#         }
#         subnets = {
#             london-a-public = {
#                 cidr = "10.45.1.0/24"
#                 az = "eu-west-2a"
#                 vpc = "london"
#             }
#             london-b-public = {
#                 cidr = "10.45.2.0/24"
#                 az = "eu-west-2b"
#                 vpc = "london"
#             }
#         }
#     }  
# }

# variable "sao-paulo-network" {
#     type = map(any) # same as map(map(map(string)))
#     default = {
#         vpcs = {
#                 sao-paulo = {
#                 cidr = "10.47.0.0/16"
#                 region = "sa-east-1"
#             }
#         }
#         subnets = {
#             sao-paulo-a-public = {
#                 cidr = "10.47.1.0/24"
#                 az = "sa-east-1a"
#                 vpc = "sao-paulo"
#             }
#             sao-paulo-b-public = {
#                 cidr = "10.47.2.0/24"
#                 az = "sa-east-1b"
#                 vpc = "sao-paulo"
#             }
#         }
#     }  
# }

# variable "tokyo-test-network" {
#     type = map(any) # same as map(map(map(string)))
#     default = {
#         vpcs = {
#             tokyo-test = {
#                 cidr = "10.48.0.0/16"
#                 region = "ap-northeast-1"
#             }
#         }
#         subnets = {
#             tokyo-test-a-public = {
#                 cidr = "10.48.1.0/24"
#                 az = "ap-northeast-1a"
#                 vpc = "tokyo-test"
#             }
#             tokyo-test-b-public = {
#                 cidr = "10.48.2.0/24"
#                 az = "ap-northeast-1b"
#                 vpc = "tokyo-test"
#             }
#         }
#     }  
# }


locals {
    rt-tables = {for k,v in var.virginia-network.vpcs : k => {
        private = {}
        public = {}
    }}
    subnets = {for k,v in var.virginia-network.subnets: k => v}
    tgw = {for k,v in var.tokyo-network.vpcs : k => v if k != "tokyo"}
    tgw-v = {for k,v in var.virginia-network.vpcs : k => v}
}

output "rt-tables" {
    value = local.rt-tables
}

output "subnets" {
    value = local.subnets
}

output "tgw" {
    value = local.tgw
}

output "tgw-v" {
    value = local.tgw-v
}

