# nixos-config

Flake-based NixOS config. 3 hosts, 2 users, per-user-per-host home-manager.

## Hosts

| Host        | Type    | Users                   | GPU driver             | Status                               |
|-------------|---------|--------------------------|-------------------------|----------------------------------------|
| Stardew     | Laptop  | whitewolf ONLY           | nvidia-laptop (960M)    | REAL — only machine that exists. OLD arch (no disko/imperm), intentionally untouched |
| SolidSnake  | Desktop | whitewolf + lizzywizzy   | nvidia-desktop (1080)   | Scaffold (no hw) — NEW arch: disko+impermanence+snapper, Terraform-managed |
| Evangelion  | Laptop  | whitewolf ONLY           | nvidia-placeholder      | Scaffold (no hw) — NEW arch: disko+impermanence+snapper, Terraform-managed |

Don't treat SolidSnake/Evangelion as deployable — no real hardware exists for either.
`nix flake show` and module eval must still pass for them; actual builds won't work
until real `hardware-configuration.nix` replaces the placeholder.

Full status of the disko/impermanence/Terraform/nix-topology/nix-darwin upgrade
lives in **HOSTS.md**. Stardew is deliberately still on the OLD architecture
(no disko/impermanence) until its reinstall is decided.

## Structure

- `flake.nix` — entry point, `mkHost` helper, defines hosts + homeConfigs, commonModules list
- `hosts/<Name>/` — configuration.nix + hardware-configuration.nix, one dir per host
- `modules/system/` — shared NixOS modules: core, boot, kde, gaming, syncthing, system-base,
  secrets, power, apps-common, apps-desktop; see `modules/system/README.md` for per-module details
  - `modules/system/drivers/` — one GPU module per host (nvidia-laptop, nvidia-desktop, nvidia-placeholder)
  - `modules/system/users/` — per-user account definitions (whitewolf.nix, lizzywizzy.nix)
  - `niri.nix` / `apps-niri.nix` exist but are NOT imported anywhere yet — inactive, don't assume active
- `home/<user>/` — home-manager, same pattern for both users:
  - `global.nix` — OS-agnostic (git, aliases, ghostty, yazi, fastfetch)
  - `linux.nix` — KDE/Plasma layer, imports `home/common/plasma-base.nix`
  - `<Host>.nix` — per-host, imports global.nix + linux.nix, sets wallpaper
  - lizzywizzy has NO Evangelion.nix — don't add one unless asked
- `home/common/` — shared fragments: ghostty.nix, plasma-base.nix, shortcuts script, icons/
- `home/wallpapers/` — per-user-per-host jpgs, referenced by `<Host>.nix` files, don't read these

## Infra upgrade (deployment / topology / darwin / tooling)

- `deployment/` — nixos-anywhere + Terraform. `systems/<host>.json` per host
  (SolidSnake, Evangelion; Stardew intentionally excluded). `nix develop .#deploy`.
  `terraform apply` WIPES the target disk — never without confirming the machine
  and the disko `device` path. VM test: `nixos-anywhere ... --vm-test`.
- `topology.nix` + `topology` output — `nix build .#topology.x86_64-linux.config.output`.
- `modules/system/disko/`, `impermanence.nix`, `impermanence-lizzywizzy.nix`,
  `btrfs-snapshots.nix` — NEW btrfs architecture, wired into SolidSnake + Evangelion
  ONLY (not commonModules, not Stardew).
- `hosts/work-macbook/` + `home/whitewolf/darwin.nix` — nix-darwin
  (`darwinConfigurations."work-macbook"`, separate track, NOT via mkHost).
- Tooling: `nh` (nhs/nhb/nhc aliases, alongside rebuild/update), `nix fmt`
  (nixfmt-rfc-style, skips hardware-configuration.nix), `.githooks/pre-commit`
  (`nix flake check`; enable per clone with `git config core.hooksPath .githooks`).
- See HOSTS.md for detailed per-host module sets.

## Rules

- Never hand-edit hardware-configuration.nix — only via `nixos-generate-config`
- secrets.yaml is sops-encrypted, safe to commit; secrets.yaml.example is the template only
- Nothing auto-upgrades or auto-changes running systems — intentional (autoUpgrade block removed from core.nix)
- Comment style: keep inline `.nix` comments minimal — only short safety/footgun warnings (destructive ops, placeholders, ordering, non-obvious gotchas), written in Serbian to match the code. Architectural/"why" prose lives in Markdown (this file, HOSTS.md, `modules/system/README.md`, `deployment/README.md`) in English — not in inline comments.
- Skip `flake.lock` unless specifically debugging input versions

## Wallust dynamic theming (Stardew / whitewolf)

Opt-in wallpaper-driven color theming, scoped to Stardew + whitewolf only.
Trigger: `set-wallpaper-mood [path]` (or `Meta+Shift+W` to pick via file dialog).
It sets the wallpaper, runs `wallust run <image>` to regenerate palettes, and
applies the KDE colorscheme live via `plasma-apply-colorscheme Wallust` — no
session restart needed (confirmed working). New Ghostty/Yazi windows pick up the
new colors; already-open ones must be restarted.

Config lives in `home/whitewolf/theming.nix` (wallust.toml + templates, managed by
home-manager as read-only store symlinks — that's fine, only the *generated output*
files must be mutable).

Include-stub pattern (avoids the read-only-symlink problem): home-manager writes a
stub that includes a writable file wallust owns.
- Ghostty: `config-file = ?~/.cache/wallust/ghostty-colors` (the `?` = optional; when
  the file is absent the static berserk theme stays the default).
- Yazi: flavor switched to `wallust`; `home.activation` seeds
  `~/.config/yazi/flavors/wallust.yazi/flavor.toml` (+ tmtheme.xml) from the berserk
  colors if absent, and wallust overwrites it on trigger.
- KDE: wallust writes `~/.local/share/color-schemes/Wallust.colors` (not managed by
  home-manager, so writable).

Rollback: delete `~/.cache/wallust/ghostty-colors` and
`~/.config/yazi/flavors/wallust.yazi/flavor.toml`, restart the apps. The static
berserk theme remains the default until `set-wallpaper-mood` is explicitly run.

## Adding a new host

1. `hosts/<Name>/configuration.nix` + `hardware-configuration.nix` (real or placeholder)
2. `home/<user>/<Name>.nix` importing `./global.nix` + `./linux.nix`
3. `flake.nix`: add `<Name> = mkHost { ... }` following existing host entries
4. Verify: `nix flake show`, then `nixos-rebuild build --flake .#<Name>` only if real hardware exists

## Sops — new machine onboarding

1. `nix shell nixpkgs#ssh-to-age -c sh -c 'ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub'`
   → add `age1…` to `.sops.yaml`
2. Per-user: `age-keygen -o ~/.config/sops/age/keys.txt`, public part → `.sops.yaml`
3. Re-encrypt for new recipients: `nix shell nixpkgs#sops -c sops updatekeys secrets.yaml`

## Token efficiency — how to work in this repo

- Don't read flake.lock, wallpapers/, icons/, or hardware-configuration.nix files unless the
  task specifically concerns them
- Use the Explore subagent for any "find/understand/where is X" question — don't read multiple
  files directly in the main thread to answer it
- Default to Sonnet for edits; only escalate to Opus for actual cross-module architecture
  decisions (e.g. redesigning mkHost)
- For single-file changes, reference the file directly rather than exploring the tree first —
  the Structure section above tells you where things live
- Skip confirmations and step-by-step preambles for routine edits — just make the change and
  report what changed
- Batch related edits into one request rather than one-file-at-a-time follow-ups in the same session
- Don't re-read a file you already have in context this session unless it may have changed
