variable "hcloud_token" {}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

data "hcloud_ssh_key" "markus" {
  name = "Markus Frosch <markus@lazyfrosch.de>"
}
