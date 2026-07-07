{ inputs, ... }:

{
  # ─────────────────────────────────────────────
  # Nix podešavanja i optimizacije
  # ─────────────────────────────────────────────
  nix.settings = {
    # Neophodno da flake uopšte radi — NE diraj. Ovo NIJE "rizično"
    # eksperimentalno; nix-command i flakes su de facto standard.
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
  #
  # STABILNOST (odluka za čoveka): auto-upgrade sa `--update-input nixpkgs`
  # svake nedelje povlači ono na šta se kanal pomerio (na unstable = svašta).
  # Opcije: (a) isključi autoUpgrade i ažuriraj ručno kad ti odgovara, ILI
  # (b) zadrži ga ALI samo ako je nixpkgs pinovan na stabilan kanal.
  # Preporuka: uz unstable kanal — isključi (enable = false) i radi ručni `update`.
  # (NIJE menjano automatski — promeni sam kad odlučiš.)
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
