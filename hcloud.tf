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
  firewall_ids = [hcloud_firewall.myfirewall.id, hcloud_firewall.default-egress.id]

}

resource "hcloud_ssh_key" "primary-ssh-key" {
  name = "primary-ssh-key"
  public_key = tls_private_key.generic-ssh-key.public_key_openssh
}

resource "tls_private_key" "generic-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096

  provisioner "local-exec" {
    command = <<EOF
    echo "${tls_private_key.generic-ssh-key.private_key_openssh} >> ~/src/apache/.envrc"
    EOF
  }
}


resource "hcloud_firewall" "myfirewall" {
  name = "my-firewall"
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction       = "in"
    port            = "443"
    protocol        = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

}

resource "hcloud_firewall" "default-egress" {
  labels = {}
  name   = "default-egress"

  rule {
    direction       = "out"
    port            = "443"
    protocol        = "tcp"
    destination_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    direction       = "out"
    port            = "80"
    protocol        = "tcp"
    destination_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }
}
