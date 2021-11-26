variable "rancher_token" {}

resource "hcloud_server" "rancher" {
  name        = "rancher.lazyfrosch.de"
  image       = "debian-11"
  location    = "fsn1"
  server_type = "cx21"
  ssh_keys    = [data.hcloud_ssh_key.markus.id]

  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }

  user_data = templatefile("rancher.user-data.yml", {
    rancher_token     = var.rancher_token,
    cluster_fqdn      = "rancher.lazyfrosch.de",
    letsencrypt_email = "info@lazyfrosch.de",
  })
}

resource "hetznerdns_record" "rancher_lazyfrosch" {
  zone_id = data.hetznerdns_zone.lazyfrosch.id
  name    = "rancher" # rancher.lazyfrosch.de
  value   = hcloud_server.rancher.ipv4_address
  type    = "A"
  ttl     = 300
}

resource "hetznerdns_record" "rancher_lazyfrosch6" {
  zone_id = data.hetznerdns_zone.lazyfrosch.id
  name    = "rancher" # rancher.lazyfrosch.de
  value   = hcloud_server.rancher.ipv6_address
  type    = "AAAA"
  ttl     = 300
}

resource "hcloud_rdns" "rancher" {
  server_id  = hcloud_server.rancher.id
  ip_address = hcloud_server.rancher.ipv4_address
  dns_ptr    = "rancher.lazyfrosch.de"
}
