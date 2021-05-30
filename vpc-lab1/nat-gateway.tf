

resource "aws_nat_gateway" "saa-nat-gw" {
  allocation_id = aws_eip.nat-gw.id
  subnet_id     = aws_subnet.saa-subnet-nat.id

  tags = {
    Name = "saa-nat-gw"
  }
}

