# resource "aws_eip" "app-server-eip" {
#   count = var.number

#   instance = aws_instance.app-server[count.index].id
#   vpc      = true
#   depends_on = [
#     aws_instance.app-server
#   ]

#   tags = {
#     Name = "eip-app-server-${count.index}"
#   }
# }
