# HOSTS — pregled mašina i kako dodati novu

## Hostovi

| Host        | Tip      | Korisnici              | GPU drajver               | Napomene                     |
|-------------|----------|------------------------|---------------------------|------------------------------|
| Stardew     | Laptop   | whitewolf + lizzywizzy | nvidia-laptop (GTX 960M)  | Jedini sa PRAVIM hardverom   |
| SolidSnake  | Desktop  | whitewolf + lizzywizzy | nvidia-desktop (GTX 1080) | Placeholder hardver          |
| Evangelion  | Laptop   | SAMO whitewolf         | nvidia-placeholder        | Placeholder hardver + GPU    |

## Struktura modula

Svi hostovi dele `commonModules` (definisano u `flake.nix`):
`core, boot, kde, users/whitewolf, apps-common, syncthing, system-base, secrets`.

Svaki host onda dodaje svoje preko `commonModules ++ [ ... ]`:

- **Stardew**: `users/lizzywizzy, gaming, power, drivers/nvidia-laptop`
- **SolidSnake**: `users/lizzywizzy, gaming, apps-desktop, drivers/nvidia-desktop`
- **Evangelion**: `gaming, power, drivers/nvidia-placeholder` (bez lizzywizzy!)

Home konfiguracije (per-user-per-host) idu preko `homeConfigs` attrseta:

- `home/<user>/global.nix` — OS-agnostično (git, aliases, ghostty, yazi, fastfetch…)
- `home/<user>/linux.nix` — KDE/Plasma sloj (uvozi `plasma-base.nix`)
- `home/<user>/<Host>.nix` — per-host (wallpaper); uvozi `global.nix` + `linux.nix`

## Kako dodati NOV host

1. `hosts/<Ime>/configuration.nix` — `networking.hostName = "<Ime>";` + host-specifično.
2. `hosts/<Ime>/hardware-configuration.nix`:
   - Na mašini: `sudo nixos-generate-config` pa kopiraj generisani fajl.
   - Privremeni placeholder: samo `nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";`
3. Home fajl(ovi): `home/<user>/<Ime>.nix` (uvozi `./global.nix` + `./linux.nix`).
4. U `flake.nix` dodaj ~10 linija:

   ```nix
   <Ime> = mkHost {
     hostname = "<Ime>";
     systemModules = commonModules ++ [
       ./modules/system/gaming.nix
       ./modules/system/drivers/<drajver>.nix
       # …po potrebi: power, apps-desktop, users/lizzywizzy…
     ];
     homeConfigs = {
       whitewolf = ./home/whitewolf/<Ime>.nix;
       # lizzywizzy = ./home/lizzywizzy/<Ime>.nix;  # samo ako host ima lizzy
     };
   };
   ```

5. Proveri: `nix flake show`; za pravi hardver `nixos-rebuild build --flake .#<Ime>`.
   (Placeholder hostovi se NEĆE build-ovati do pravog hardware-configuration.nix —
   to je očekivano; `nix flake show` i eval modula i dalje prolaze.)

## Sops — onboarding ključeva za novu mašinu

1. Host age ključ (izveden iz SSH host ključa):

   ```
   nix shell nixpkgs#ssh-to-age -c sh -c 'ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub'
   ```

   Dobijeni `age1…` upiši u `.sops.yaml` (zameni odgovarajući `age1REPLACE_*`).
   Privatni host ključ ide u `/var/lib/sops-nix/key.txt` na toj mašini.
2. (Po korisniku) `age-keygen -o ~/.config/sops/age/keys.txt` — javni deo u `.sops.yaml`.
3. Re-enkriptuj postojeće tajne za nove recipiente:

   ```
   nix shell nixpkgs#sops -c sops updatekeys secrets.yaml
   ```

4. Prvi put: `nix shell nixpkgs#sops -c sops secrets.yaml` (otvara editor).
   ŠIFROVANI `secrets.yaml` je BEZBEDAN za commit; `secrets.yaml.example` je samo šablon.

## Stabilnost

Vidi komentare u `flake.nix` (izbor nixpkgs kanala) i `modules/system/core.nix`
(`system.autoUpgrade`). Ništa nije menjano automatski — to su odluke za čoveka.
