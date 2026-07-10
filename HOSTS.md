# HOSTS.md

Status hostova, skupovi modula, i nova (disko/impermanence) arhitektura.
Za strukturu repo-a i pravila vidi CLAUDE.md.

## Hostovi

| Host        | Tip     | Korisnici              | Arhitektura                                  | Status |
|-------------|---------|------------------------|----------------------------------------------|--------|
| Stardew     | Laptop  | whitewolf + lizzywizzy | STARA (postojeca), BEZ disko/impermanence    | REALNA masina; jedina koja fizicki postoji. NAMERNO netaknuta — reinstalacija je odluka za kasnije. |
| SolidSnake  | Desktop | whitewolf + lizzywizzy | NOVA: btrfs + disko + impermanence + snapper | Scaffold — nema hardvera. Evaluira u toplevel; instalira se preko deployment/ kad bude masine. |
| Evangelion  | Laptop  | whitewolf ONLY         | NOVA: btrfs + disko + impermanence + snapper | Scaffold — nema hardvera. Single-user. |

## Nova arhitektura (SolidSnake, Evangelion)

- **disko** (`modules/system/disko/{laptop,desktop}-btrfs.nix`): GPT + btrfs.
  Subvolumi: `@` (root, brise se pri butu), `@persist`, `@nix`, `@log`.
  `device` je PLACEHOLDER (`/dev/nvme0n1`) — potvrdi sa `lsblk` pre instalacije.
- **impermanence** (`modules/system/impermanence.nix`): root se rola na prazno
  pri svakom butu; prezivi samo `/persist`. `/home/whitewolf` se cuva ceo;
  `/home/lizzywizzy` preko `impermanence-lizzywizzy.nix` (samo SolidSnake).
  SSH host kljucevi + `/var/lib/nixos` (stabilni uid/gid) se perzistiraju.
- **snapper** (`modules/system/btrfs-snapshots.nix`): auto snapshotovi nad `/persist`
  (6h / 7d / 2w). Rollback safety-net NA VRHU NixOS generacija — **NIJE backup**.

Stardew NEMA nijedan od ova tri modula (namerno).

## Deploy (nixos-anywhere + Terraform)

- `deployment/` — `main.tf` (for_each nad `systems/*.json`) + per-host JSON.
- SolidSnake i Evangelion imaju `systems/<host>.json` (placeholder IP).
  Stardew NAMERNO izostavljen.
- `nix develop .#deploy` -> terraform + nixos-anywhere u PATH.
- **VM test (bez hardvera, najbezbednije):**
  `nix run github:nix-community/nixos-anywhere -- --flake .#SolidSnake --vm-test`
- `terraform apply` BRISE ciljni disk — nikad bez potvrde masine i `device` puta.

## nix-topology

- `topology.nix` (repo root) + `topology` flake output.
- Build: `nix build .#topology.x86_64-linux.config.output` -> `main.svg`, `network.svg`.
- Prikazuje sve 3 NixOS masine + ruter.

## nix-darwin (radni Mac)

- `darwinConfigurations."work-macbook"` (sibling od nixosConfigurations, van mkHost).
- `hosts/work-macbook/darwin-configuration.nix` + `home/whitewolf/darwin.nix`.
- Konzervativno: Homebrew off, bez system.defaults.*. Gradi se tek na realnom Mac-u
  (`darwin-rebuild build`); ovde samo evaluira.

## Tooling

- **nh** (nix-helper): `nhs`/`nhb`/`nhc` aliasi UZ postojece `rebuild`/`update`
  (nije zamena). `NH_FLAKE` je postavljen pa `nh os switch` radi bez flagova.
  Napomena: nh / nix fmt / pre-commit su repo/tooling-tier — na Stardew se
  primenjuju tek pri sledecem svesnom `rebuild`-u.
- **nix fmt**: `formatter` output (nixfmt-rfc-style). Formatira sve `.nix` osim
  `hardware-configuration.nix`.
- **pre-commit hook**: `.githooks/pre-commit` pokrece `nix flake check` pre commita.
  Lokalno PO KLONU — omoguci sa `git config core.hooksPath .githooks`. NE postoji
  automatski na svezem klonu ili posle reinstalacije dok se ne omoguci.

## Skupovi modula

commonModules (svi hostovi): core, boot, kde, users/whitewolf, apps-common,
syncthing, system-base, secrets, nix-topology ekstrakcija.

- Stardew: + users/lizzywizzy, gaming, power, drivers/nvidia-laptop
- SolidSnake: + users/lizzywizzy, gaming, drivers/nvidia-desktop,
  disko/desktop-btrfs, impermanence, impermanence-lizzywizzy, btrfs-snapshots
- Evangelion: + gaming, power, apps-desktop, drivers/nvidia-placeholder,
  disko/laptop-btrfs, impermanence, btrfs-snapshots

SolidSnake je sada gaming-fokusiran (lizzywizzy primarni korisnik); Evangelion je
primarna masina za rendering/kreativni rad (apps-desktop + blender).
