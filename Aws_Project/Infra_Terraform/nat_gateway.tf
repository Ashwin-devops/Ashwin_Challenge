# Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
resource "aws_eip" "gateway" {
  count            = var.az_count
  vpc              = true
  depends_on       = [aws_internet_gateway.gateway]
}

resource "aws_nat_gateway" "gateway" {
  count            = var.az_count
  subnet_id        = element(aws_subnet.public_subnets.*.id, count.index)
  allocation_id    = element(aws_eip.gateway.*.id, count.index)
  tags = {
    Name = "ngw-curai-${var.env}"
  }
}

resource "aws_route_table" "private" {
  count            = var.az_count
  vpc_id           = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gateway.*.id, count.index)
  }
  tags = {
    Name = "rt-curai-${var.env}"
  }
}

resource "aws_route_table_association" "private" {
  count            = var.az_count
  subnet_id        = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id   = element(aws_route_table.private.*.id, count.index)
}