variable "private_ips_webserver" {
  type    = list(string)
  default = ["10.0.1.10", "10.0.1.11"]
}

variable "private_ips_internal" {
  type    = list(string)
  default = ["10.0.2.10", "10.0.2.11"]
}

variable "private_ips_db" {
  type    = list(string)
  default = ["10.0.3.10", "10.0.3.11"]
}

variable "instance_number" {
  type    = number
  default = 2
}

variable "ami" {
  type    = string
  default = "ami-01581ffba3821cdf3"
}
