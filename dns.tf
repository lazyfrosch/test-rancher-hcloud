variable "hetznerdns_token" {}

provider "hetznerdns" {
  apitoken = var.hetznerdns_token
}

data "hetznerdns_zone" "lazyfrosch" {
  name = "lazyfrosch.de"
}
