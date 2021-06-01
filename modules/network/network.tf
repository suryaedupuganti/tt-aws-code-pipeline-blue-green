#VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = merge(
    var.default_tags,
    tomap({
      Name = "${var.default_prefix}-${var.vpc_name}" }
  ))
}

#Public Subnet
resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = var.public_subnet_cidr_blocks[count.index]

  tags = merge(
    var.default_tags,
    tomap({
      Name = "${var.default_prefix}-public-${count.index}" }
  ))

}

#Private Subnet
resource "aws_subnet" "private" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = var.private_subnet_cidr_blocks[count.index]

  tags = merge(
    var.default_tags,
    tomap({
      Name = "${var.default_prefix}-private-${count.index}" }
  ))

}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.default_tags,
    tomap({
      Name = "${var.default_prefix}-Internet-gateway" }
  ))

}

#eip
resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidr_blocks)
  vpc   = true
}

#Nat Gateway
resource "aws_nat_gateway" "ngw" {
  count         = length(var.public_subnet_cidr_blocks)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = merge(
    var.default_tags,
    tomap({
      Name = "${var.default_prefix}-NAT-gateway-${count.index}" }
  ))

}

#Public Route-table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
    var.default_tags,
    tomap({
      Name = "${var.default_prefix}-Public-route-table" }
  ))


}

#Public Route-table Association
resource "aws_route_table_association" "public_association" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id


}


#Private Route-table
resource "aws_route_table" "private_rt" {
  count  = length(var.private_subnet_cidr_blocks)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.ngw.*.id, count.index)
  }
  tags = merge(
    var.default_tags,
    tomap({
      Name = "${var.default_prefix}-Private-route-table" }
  ))
}

#Private Route-table Association
resource "aws_route_table_association" "private_association" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private_rt.*.id, count.index)
}
