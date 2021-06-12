
resource "aws_subnet" "app-subnet" {
  count             = var.number
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index * 2 + 1}.0/24"
  availability_zone = var.zones[count.index]

  tags = {
    Name = "app-${count.index}-subnet"
  }
}
