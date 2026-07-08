# deployment/main.tf
#
# nixos-anywhere + Terraform: deklarativna (re)instalacija NixOS hostova.
# Jedan modul po hostu preko for_each nad systems/*.json.
#
# NE pokretati `terraform apply` bez potvrdjene ciljne masine i stvarnog
# `device` puta u modules/system/disko/*.nix (trenutno PLACEHOLDER).

terraform {
  required_version = ">= 1.5"
  required_providers {
    external = { source = "hashicorp/external" }
    local    = { source = "hashicorp/local" }
    null     = { source = "hashicorp/null" }
    tls      = { source = "hashicorp/tls" }
  }
}

locals {
  # Flake je u repo root-u, jedan nivo iznad deployment/.
  flake = abspath("${path.module}/..")

  # Svaki systems/<host>.json opisuje jedan host: hostname + ipv4.
  systems = {
    for f in fileset("${path.module}/systems", "*.json") :
    trimsuffix(f, ".json") => jsondecode(file("${path.module}/systems/${f}"))
  }
}

# Jedan nixos-anywhere modul po hostu.
module "deploy" {
  for_each = local.systems
  source   = "github.com/nix-community/nixos-anywhere//terraform/all-in-one"

  nixos_system_attr      = "path:${local.flake}#nixosConfigurations.${each.value.hostname}.config.system.build.toplevel"
  nixos_partitioner_attr = "path:${local.flake}#nixosConfigurations.${each.value.hostname}.config.system.build.diskoScript"

  target_host = each.value.ipv4
  instance_id = each.key
  # target_user podrazumevano root (installer). Dodaj u systems/<host>.json po potrebi.
}
