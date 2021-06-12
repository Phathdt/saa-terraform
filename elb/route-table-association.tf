resource "aws_route_table_association" "app-association" {
  count          = var.number
  subnet_id      = aws_subnet.app-subnet[count.index].id
  route_table_id = aws_route_table.public-rt.id
}
