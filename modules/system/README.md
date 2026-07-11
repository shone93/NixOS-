# modules/system/

This file complements [CLAUDE.md](../../CLAUDE.md) (architecture index) and [HOSTS.md](../../HOSTS.md) (per-host status) — do not duplicate them; refer to those files for overall structure and host status.

## Module index

| File | Purpose |
|------|---------|
| `core.nix` | Nix daemon settings, flake experimental features, GC, nixpkgs allowUnfree |
| `boot.nix` | systemd-boot, EFI, quiet boot kernel params |
| `kde.nix` | KDE Plasma 6 + SDDM, ark, debloat exclusions |
| `gaming.nix` | Steam (Proton-GE, gamescope), gamemode, heroic/lutris/mangohud/vesktop |
| `syncthing.nix` | Syncthing service (user: whitewolf, dataDir: /home/whitewolf) |
| `system-base.nix` | Pipewire, NetworkManager, locale (Europe/Belgrade), zram, oomd, fstrim |
| `secrets.nix` | sops-nix import + conditional activation when secrets.yaml exists |
| `power.nix` | auto-cpufreq, bluetooth, wifi powersave off — laptops only |
| `apps-common.nix` | Shared system packages for all hosts: editors, browsers, terminal tools, fonts, NH_FLAKE |
| `apps-desktop.nix` | Creative/rendering app bundle: blender, gimp, inkscape, krita, godot — now used by Evangelion |
| `apps-niri.nix` | Niri-specific packages — **not imported anywhere yet** |
| `niri.nix` | Niri compositor module — **not imported anywhere yet** |
| `impermanence.nix` | Wipe-on-boot rollback service + persistence declarations |
| `impermanence-lizzywizzy.nix` | Adds /home/lizzywizzy to persist — SolidSnake only |
| `btrfs-snapshots.nix` | Snapper timeline snapshots over /persist — SolidSnake and Evangelion |
| `ssh.nix` | OpenSSH service — SolidSnake and Evangelion only (required for nixos-anywhere deploy) |
| `backup.nix` | restic daily backup of `/home/whitewolf` to an off-disk repo — Stardew only. `repository` + sops secrets are `REPLACE` placeholders until a backend is chosen. |

### Subdirectories

| Dir | Purpose |
|-----|---------|
| `drivers/` | One GPU module per host: `nvidia-laptop.nix` (Stardew, GTX 960M + PRIME), `nvidia-desktop.nix` (SolidSnake, GTX 1080), `nvidia-placeholder.nix` (Evangelion, unknown GPU) |
| `disko/` | Declarative disk layout for Terraform-managed hosts: `desktop-btrfs.nix` (SolidSnake), `laptop-btrfs.nix` (Evangelion) |
| `users/` | NixOS user account declarations: `whitewolf.nix` (wheel, all hosts), `lizzywizzy.nix` (no wheel, Stardew + SolidSnake) |

## Persistence & wipe-on-boot

`impermanence.nix` + `disko/*.nix` implement a wipe-on-boot setup:

- The root btrfs subvolume (`@`) is deleted and recreated empty on every boot.
- Only three paths survive: `/persist` (`@persist` subvolume), `/nix` (`@nix`), and `/var/log` (`@log`).
- The entire `/home/whitewolf` directory is persisted under `/persist/home/whitewolf`.
- `/home/lizzywizzy` is persisted separately via `impermanence-lizzywizzy.nix` (SolidSnake only).
- `/var/lib/nixos` must persist so uid/gid assignments remain stable across wipes.
- SSH host keys (`/etc/ssh/ssh_host_ed25519_key` etc.) must persist — sops-nix uses them for secret decryption at activation.
- `impermanence.nix` and `impermanence-lizzywizzy.nix` are **NOT in commonModules** and are **NOT applied to Stardew**. They are wired only into SolidSnake and Evangelion via their `systemModules` in `flake.nix`.

## Disko layout

Both `disko/desktop-btrfs.nix` and `disko/laptop-btrfs.nix` declare a single btrfs disk with four subvolumes:

| Subvolume | Mountpoint | Role |
|-----------|-----------|------|
| `@` | `/` | Root — wiped every boot |
| `@persist` | `/persist` | Surviving data |
| `@nix` | `/nix` | Nix store — never wiped |
| `@log` | `/var/log` | Journal logs — survives wipe |

**The `device` field is a placeholder** (`/dev/nvme0n1` by default). Verify the actual disk path with `lsblk` before running `terraform apply`. Running `terraform apply` / `nixos-anywhere` **WIPES the target disk** — always confirm the machine and disk path first.

## Secrets (sops)

- `secrets.yaml` is sops-encrypted and **safe to commit** to the repository.
- `secrets.yaml.example` in the repo root is the template — it contains no real secrets.
- `secrets.nix` is active on all hosts (via `commonModules`) but the sops config block is guarded by `lib.mkIf (builtins.pathExists ../../secrets.yaml)` so `nix flake check` passes even without a real secrets file.
- User passwords: `whitewolf-password` (all hosts) and `lizzywizzy-password` (Stardew/SolidSnake only) are `neededForUsers` sops secrets holding `mkpasswd -m sha-512` hashes. `users/whitewolf.nix` and `users/lizzywizzy.nix` wire them via `hashedPasswordFile`, but only where `users.mutableUsers = false` (SolidSnake + Evangelion, set per-host) — so Stardew keeps mutable `passwd`. If `secrets.yaml` is missing, the impermanence hosts fail closed (account locked, not passwordless).
- New-machine onboarding steps (age keys, updating `.sops.yaml`, password hashes, re-encrypting) are documented in [CLAUDE.md](../../CLAUDE.md) under **Sops — new machine onboarding** and, copy-paste form, in [deployment/README.md](../../deployment/README.md).
