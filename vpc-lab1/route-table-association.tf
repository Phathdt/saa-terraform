resource "aws_route_table_association" "web-server-association" {
  subnet_id      = aws_subnet.web-server-subnet.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "internal-api-association" {
  subnet_id      = aws_subnet.internal-api-subnet.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "db-association" {
  subnet_id      = aws_subnet.db-subnet.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "saa-nat-association" {
  subnet_id      = aws_subnet.saa-subnet-nat.id
  route_table_id = aws_route_table.nat-rt.id
}

