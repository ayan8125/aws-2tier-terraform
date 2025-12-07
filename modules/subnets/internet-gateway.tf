#######################################
# INTERNET GATEWAY
#######################################
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

#######################################
# PUBLIC ROUTE TABLE
#######################################
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

#######################################
# ROUTE: INTERNET GATEWAY
#######################################
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

#######################################
# ASSOCIATE ROUTE TABLE WITH PUBLIC SUBNETS
#######################################
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public[*].id)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


output "interner_gateway_id" {
  value = aws_internet_gateway.igw.id
}
