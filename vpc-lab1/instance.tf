resource "aws_instance" "web-server" {
  count                  = var.instance_number
  ami                    = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sa-web-public-sg.id]
  key_name               = "phathdt973"
  availability_zone      = "ap-southeast-1a"
  private_ip             = var.private_ips_webserver[count.index]
  subnet_id              = aws_subnet.web-server-subnet.id


  tags = {
    "Group" = "web-server"
    Name    = "web-server-${count.index}"
  }
}

resource "aws_instance" "internal-server" {
  count                  = var.instance_number
  ami                    = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sa-api-internal-sg.id]
  key_name               = "phathdt973"
  availability_zone      = "ap-southeast-1a"
  private_ip             = var.private_ips_internal[count.index]
  subnet_id              = aws_subnet.internal-api-subnet.id


  tags = {
    "Group" = "internal-server"
    Name    = "internal-${count.index}"
  }
}

resource "aws_instance" "db-server" {
  count                  = var.instance_number
  ami                    = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sa-database-sg.id]
  key_name               = "phathdt973"
  availability_zone      = "ap-southeast-1a"
  private_ip             = var.private_ips_db[count.index]
  subnet_id              = aws_subnet.db-subnet.id


  tags = {
    "Group" = "db-server"
    Name    = "db-${count.index}"
  }
}
