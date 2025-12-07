#######################################
# ELASTIC IPs FOR NAT GATEWAYS
#######################################
resource "aws_eip" "nat" {
  count = length(aws_subnet.public[*].id)

  vpc = true

  tags = {
    Name = "${var.project_name}-nat-eip-${count.index}"
  }
}

#######################################
# NAT GATEWAYS
#######################################
resource "aws_nat_gateway" "nat" {
  count = length(aws_subnet.public[*].id)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.project_name}-nat-${count.index}"
  }
}


#######################################
# PRIVATE ROUTE TABLES
#######################################
resource "aws_route_table" "private" {
  count = length(aws_subnet.private[*].id)

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-private-rt-${count.index}"
  }
}

#######################################
# ROUTES THROUGH NAT
#######################################
resource "aws_route" "private_nat" {
  count = length(aws_nat_gateway.nat[*].id)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}



#######################################
# ASSOCIATE PRIVATE SUBNETS WITH PRIVATE RT
#######################################
resource "aws_route_table_association" "private" {
  count             = length(aws_subnet.private[*].id)
  subnet_id         = aws_subnet.private[count.index].id
  route_table_id    = aws_route_table.private[count.index].id
}



output "aws_nat_gateway_ids" {
    value = aws_nat_gateway.nat[*].id
}

output "aws_eip_ids" {
    value = aws_eip.nat[*].id
}

output "private_route_table_ids" {
  value = aws_route_table.private[*].id
}
