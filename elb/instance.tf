resource "aws_instance" "app-server" {
  count                  = var.number
  ami                    = var.nginx-ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app-public-sg.id]
  key_name               = "phathdt973"
  availability_zone      = var.zones[count.index]
  private_ip             = var.private_ips_webserver[count.index]
  subnet_id              = aws_subnet.app-subnet[count.index].id


  tags = {
    Name = "app-server-${count.index}"
  }
}
