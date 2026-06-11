{ inputs, ... }:

{
  # ─────────────────────────────────────────────
  # Nix podešavanja i optimizacije
  # ─────────────────────────────────────────────
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true; # Deduplikuje identične fajlove u store-u
    max-jobs = "auto";
    cores = 0;
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dde0enMT6hmRhAhFKFfaKE8uokELwzTHA="
    ];
  };

  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];

  # Automatsko čišćenje starih generacija
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Automatski nedeljni update paketa
  system.autoUpgrade = {
    enable = true;
    flake = "~/Documents/nixos-config";
    flags = [
      "--update-input"
      "nixpkgs"
    ];
    dates = "weekly";
    allowReboot = false;
  };

  nixpkgs.config.allowUnfree = true; # Za NVIDIA, Steam i sl.

  system.stateVersion = "26.05";
}
