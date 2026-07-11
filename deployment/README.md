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

## Sops — onboarding ključeva i lozinki (copy-paste)

Uradi ovo JEDNOM po hostu, POSLE prve instalacije (host SSH ključ mora da postoji).
Impermanence hostovi (SolidSnake, Evangelion) imaju `users.mutableUsers = false` — lozinka
dolazi ISKLJUČIVO iz sops preko `hashedPasswordFile`. Ako `secrets.yaml` nedostaje ili nema
odgovarajuću tajnu, nalog ostaje ZAKLJUČAN (fail-closed) — nema tihog prelaska na praznu lozinku.

```sh
# 1. Host age ključ (izvedi iz SSH host ključa ciljne mašine):
nix shell nixpkgs#ssh-to-age -c sh -c 'ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub'
#    -> upiši dobijeni age1... u .sops.yaml na mesto age1REPLACE_<HOST>_HOST_KEY

# 2. Tvoj lični (user) age ključ, ako ga još nemaš:
age-keygen -o ~/.config/sops/age/keys.txt
#    javni deo (age1...) -> .sops.yaml na mesto age1REPLACE_<USER>_USER_KEY

# 3. Heš lozinki (NE plaintext) za svakog korisnika na tom hostu:
nix shell nixpkgs#mkpasswd -c mkpasswd -m sha-512
#    -> $6$... za whitewolf; (Stardew/SolidSnake) još jednom za lizzywizzy

# 4. Napravi/izmeni šifrovani secrets.yaml i unesi heševe:
nix shell nixpkgs#sops -c sops secrets.yaml
#    whitewolf-password: "$6$..."
#    lizzywizzy-password: "$6$..."   # samo Stardew/SolidSnake

# 5. Kad dodaš novog recipienta (nov host/user) u .sops.yaml, re-enkriptuj:
nix shell nixpkgs#sops -c sops updatekeys secrets.yaml
```

Provera pre deploy-a: `secrets.yaml` postoji i sadrži `whitewolf-password`
(i `lizzywizzy-password` za Stardew/SolidSnake), inače SolidSnake/Evangelion
build daje zaključan nalog umesto sistema u koji možeš da se prijaviš.
