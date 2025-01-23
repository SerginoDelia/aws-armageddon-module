resource "aws_ec2_transit_gateway" "tgw" {
  for_each = var.network.vpcs
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"

  default_route_table_propagation = "enable"
  transit_gateway_cidr_blocks     = ["10.0.0.0/8"]

  tags = {
    Name = "${each.key}-tgw"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-attachment" {
  for_each = var.network.vpcs
  subnet_ids         = [for k,v in var.network.subnets : aws_subnet.subnets[k].id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw[each.key].id
  vpc_id             = aws_vpc.vpcs[each.key].id
}

resource "aws_ec2_transit_gateway_route_table" "tgw-rt" {
  for_each = var.network.vpcs
  transit_gateway_id = aws_ec2_transit_gateway.tgw[each.key].id

  tags = {
    Name = "${each.key}-tgw-rt"
  }
}

resource "aws_ec2_transit_gateway_route" "tgw-route" {
  for_each = var.network.vpcs   
  destination_cidr_block         = each.value.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-attachment[each.key].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rt[each.key].id
}

# TGW Peering

data "aws_caller_identity" "account" {
}

resource "aws_ec2_transit_gateway_peering_attachment" "tokyo-to" {
  for_each = {
    for k, v in var.network.vpcs : k => v 
    if k != "tokyo" && contains(keys(var.network.vpcs), "tokyo")
  }
  peer_account_id         = data.aws_caller_identity.account.account_id
  peer_region             = each.value.region
  peer_transit_gateway_id = aws_ec2_transit_gateway.tgw[each.key].id
  transit_gateway_id      = aws_ec2_transit_gateway.tgw["tokyo"].id
  tags = {
    Name = "tokyo-to-${each.key}"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tgw-peering-acceptor" {
  for_each = {
    for k, v in var.network.vpcs : k => v 
    if k != "tokyo" && contains(keys(var.network.vpcs), "tokyo")
  }
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tokyo-to[each.key].id
  tags = {
    Name = "${each.key}-peering-acceptor"
  }
}