variable "hcloud_token" {
}
# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}
variable "location" {
  default = "nbg1"
}

variable "server_type" {
  default = "cx11"
}

variable "os_type" {
  default = "ubuntu-20.04"
}

variable "disk_size" {
  default = "20"
} 


# Create a server
resource "hcloud_server" "web" {
  location    = var.location
  name        = "qbd-apache-superset"
  image       = var.os_type
  server_type = var.server_type
}

resource "tls_private_key" "generic-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#resource "hcloud_volume" "storage" {
#  name       = "my-volume"
#  size       = 50
#  server_id  = "${hcloud_server.web.id}"
#  automount  = true
#  format     = "ext4"
#}
