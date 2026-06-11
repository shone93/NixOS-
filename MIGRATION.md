# Migracija na novu strukturu

## Šta se promenilo
- `configuration.nix` razbijen: zajedničko → moduli, host-specifično → hosts/<ime>/
- Hostovi: **Stardew** (laptop), **SolidSnake** (desktop)
- NVIDIA konsolidovan (bio dupliran u drivers.nix + gaming.nix)
- Svaki korisnik ima global + per-host fajl
- Wallpaper je per-user-per-host
- flake koristi `mkHost` helper (manje ponavljanja)
- Niri moduli sačuvani ali se NE importuju još

## Koraci za migraciju (na laptopu/Stardew)

1. Napravi backup trenutnog configa:
   cp -r ~/Documents/nixos-config ~/nixos-config-backup

2. Iskopiraj SVE iz nove strukture preko starog (osim hardware-configuration.nix):
   (uradi to iz foldera gde si raspakovao novu strukturu)

3. KRITIČNO - iskopiraj svoj postojeći hardware-configuration.nix:
   cp ~/nixos-config-backup/hosts/laptop/hardware-configuration.nix \
      ~/Documents/nixos-config/hosts/Stardew/hardware-configuration.nix

4. Obriši stari hosts/laptop folder ako je ostao:
   rm -rf ~/Documents/nixos-config/hosts/laptop
   rm -rf ~/Documents/nixos-config/modules/user   # staro

5. Git mora da vidi nove fajlove:
   cd ~/Documents/nixos-config && git add .

6. Promeni hostname privremeno NIJE potrebno - rebuild sa novim imenom:
   sudo nixos-rebuild switch --flake ~/Documents/nixos-config#Stardew

7. Posle uspešnog rebuilda, novi hostname je "Stardew".
   Tvoj `rebuild` alias sada koristi $(hostname) pa radi automatski.

## Desktop (SolidSnake) - kasnije
Kada instaliraš NixOS na desktop:
   sudo nixos-generate-config
   cp /etc/nixos/hardware-configuration.nix \
      ~/Documents/nixos-config/hosts/SolidSnake/hardware-configuration.nix
   sudo nixos-rebuild switch --flake ~/Documents/nixos-config#SolidSnake
