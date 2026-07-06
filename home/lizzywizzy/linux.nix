{ ... }:

{
  # ─────────────────────────────────────────────
  # Lizzy Wizzy - Linux-specifičan sloj (KDE/Plasma)
  # Uvozi se samo na Linux hostovima; global.nix ostaje OS-agnostičan.
  # ─────────────────────────────────────────────
  imports = [
    ../common/plasma-base.nix
  ];
}
