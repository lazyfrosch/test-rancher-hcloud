terraform {
  required_providers {
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = ">= 1.1.1"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.31.0"
    }
  }
  required_version = ">= 0.13"
}
