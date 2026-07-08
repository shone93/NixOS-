# deployment/ — nixos-anywhere + Terraform

Deklarativna (re)instalacija NixOS hostova preko nixos-anywhere, vodjena Terraform-om.

## Kako radi

- `systems/<host>.json` — jedan fajl po hostu: `hostname` + `ipv4`.
- `main.tf` — `for_each` nad `systems/*.json`, jedan nixos-anywhere modul po hostu.
  Gradi `nixosConfigurations.<host>.config.system.build.toplevel` i disko
  particioner (`diskoScript`) iz flake-a u repo root-u (jedan nivo iznad).

## Hostovi

- `SolidSnake` — desktop (scaffold, nema jos hardvera). Zameni `ipv4` pravom IP adresom.
- `Evangelion` — laptop (scaffold, nema jos hardvera). Zameni `ipv4` pravom IP adresom.
- `Stardew` — NAMERNO izostavljen. To je jedina realna masina; reinstalacija je
  zasebna odluka. Dodaj `systems/Stardew.json` tek kad svesno hoces da je reinstaliras.

## Preduslovi pre `terraform apply`

1. Ciljna masina bootovana u NixOS installer (ili Linux sa root SSH-om), dostupna
   preko IP-a iz `systems/<host>.json`.
2. Potvrdi stvarni put diska u `modules/system/disko/<layout>.nix` (`device`) —
   trenutno je PLACEHOLDER (`/dev/nvme0n1`). Proveri sa `lsblk` na ciljnoj masini.
3. SSH kljuc kojim se root prijavljuje na installer.

## Upotreba

```sh
nix develop .#deploy          # terraform + nixos-anywhere u PATH
cd deployment
terraform init
terraform plan
# Instaliraj SAMO jedan host (npr. SolidSnake):
terraform apply -target='module.deploy["SolidSnake"]'
```

## Bezbednosna napomena

`terraform apply` BRISE i reinstalira ciljni disk. Nikad ne ciljaj masinu bez
potvrde. VM test (bez hardvera) je najbezbedniji nacin da se proveri
reproducibilnost:

```sh
nix run github:nix-community/nixos-anywhere -- --flake .#SolidSnake --vm-test
```
