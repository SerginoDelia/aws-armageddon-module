resource "aws_vpc" "vpcs" {
  for_each = var.network.vpcs

  cidr_block = each.value.cidr
  tags = {
    Name = "${each.key}-vpc"
  }
}

resource "aws_subnet" "subnets" {
  for_each = var.network.subnets

  vpc_id            = aws_vpc.vpcs[each.value.vpc].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}

resource "aws_internet_gateway" "igw" {
  for_each = var.network.vpcs
  vpc_id   = aws_vpc.vpcs[each.key].id
  tags = {
    Name = "${each.key}-igw"
  }
}

resource "aws_eip" "eip" {
  for_each = var.network.subnets
  domain   = "vpc"
  tags = {
    Name = "${each.key}-eip"
    private = endswith(each.key, "private") ? true : false
  }
}

resource "aws_nat_gateway" "nat" {
  for_each = merge(
    # Create public NAT gateways
    { for k, v in var.network.subnets : k => {
        subnet = k
        is_public = true
      } if endswith(k, "public")
    },
    # Create private NAT gateways
    { for k, v in var.network.subnets : k => {
        subnet = k
        is_public = false
      } if endswith(k, "private")
    }
  )

  allocation_id = aws_eip.eip[each.value.subnet].id
  subnet_id     = aws_subnet.subnets[each.value.subnet].id

  tags = {
    Name = "${each.key}-nat"
    Type = each.value.is_public ? "public" : "private"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Security Groups

resource "aws_security_group" "sg" {
  for_each    = var.network.vpcs
  vpc_id      = aws_vpc.vpcs[each.key].id
  name        = each.key
  description = "${each.key}-sg"

  # http ingress
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

#   # dynamic ssh ingress
#   dynamic "ingress" {
#     for_each = endswith(each.key, "server") ? [1] : []
#     content {
#       from_port   = 22
#       to_port     = 22
#       protocol    = "TCP"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = each.key
  }
}

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# Generate rsa key pair on your system
# ssh-keygen -t rsa -b 4096 -f ~/.ssh/aws.pem

resource "aws_key_pair" "key-pair" {
  for_each = var.network.vpcs
  key_name = "${each.key}-key-pair"
  # file reference the location of the public key
  public_key = file("~/.ssh/aws.pem.pub")
}

