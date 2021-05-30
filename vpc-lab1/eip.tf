resource "aws_eip" "nat-gw" {
  depends_on = [
    aws_internet_gateway.main
  ]

  tags = {
    Name = "eip-nat-gw"
  }
}

resource "aws_eip" "web-server" {
  count = var.instance_number

  instance = aws_instance.web-server[count.index].id
  vpc      = true
  depends_on = [
    aws_instance.web-server
  ]

  tags = {
    Name = "eip-web-server-${count.index}"
  }
}
