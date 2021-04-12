variable "rancher_token" {}

resource "hcloud_server" "rancher" {
  name        = "rancher.lazyfrosch.de"
  image       = "debian-10"
  server_type = "cx21"
  ssh_keys    = [data.hcloud_ssh_key.markus.id]
  user_data   = <<EOT
#!/bin/bash

set -ex

apt-get update
apt-get install -y curl gnupg ca-certificates

curl -sfL https://get.rancher.io | sh -

mkdir -p /etc/rancher/rke2

cat >/etc/rancher/rke2/config.yaml <<EOF
token: ${var.rancher_token}
tls-san:
  - rancher.lazyfrosch.de
EOF

systemctl enable --now rancherd-server.service

echo 'export KUBECONFIG=/etc/rancher/rke2/rke2.yaml PATH="$PATH":/var/lib/rancher/rke2/bin' >> /root/.profile
EOT
}

resource "hetznerdns_record" "rancher_lazyfrosch" {
  zone_id = data.hetznerdns_zone.lazyfrosch.id
  name    = "rancher" # rancher.lazyfrosch.de
  value   = hcloud_server.rancher.ipv4_address
  type    = "A"
  ttl     = 300
}

resource "hcloud_rdns" "rancher" {
  server_id = hcloud_server.rancher.id
  ip_address = hcloud_server.rancher.ipv4_address
  dns_ptr = "rancher.lazyfrosch.de"
}
