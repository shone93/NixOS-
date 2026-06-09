{ inputs, ... }:

{
  # ─────────────────────────────────────────────
  # Korisnik
  # ─────────────────────────────────────────────
  users.users.whitewolf = {
    isNormalUser = true;
    description = "WhiteWolf";
    extraGroups = [
      "networkmanager"
      "wheel" # 'wheel' omogućava sudo komande
    ];
  };
  users.groups.whitewolf = { };

  users.users.lizzywizzy = {
    isNormalUser = true;
    description = "Lizzy Wizzy";
    extraGroups = [ "networkmanager" ]; # bez wheel - nije admin
  };

  imports = [
    ./hardware-configuration.nix
    ../../modules/system/boot.nix
    ../../modules/system/audio.nix
    ../../modules/system/network.nix
    ../../modules/system/locale.nix
    ../../modules/system/drivers.nix
    ../../modules/system/kde.nix
    ../../modules/system/gaming.nix
    ../../modules/user/apps.nix
    ../../modules/system/power.nix
  ];

  # ─────────────────────────────────────────────
  # Nix podešavanja
  # ─────────────────────────────────────────────
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
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

  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
  };
  nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];

  # Omogućava flakes bez dodatnih flagova

  # ─────────────────────────────────────────────
  # Bootloader
  # ─────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ─────────────────────────────────────────────
  # Grafičko okruženje (KDE Plasma 6 + SDDM)
  # ─────────────────────────────────────────────
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  # NVIDIA vlasnički drajver (neophodno za hardware.nvidia u gaming.nix)
  services.xserver.videoDrivers = [ "nvidia" ];

  # ─────────────────────────────────────────────
  # Audio (Pipewire)
  # ─────────────────────────────────────────────
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # Potrebno za igre i Wine/Proton
    pulse.enable = true;
  };

  # ─────────────────────────────────────────────
  # Mreža i lokalizacija
  # ─────────────────────────────────────────────
  networking.hostName = "NixOS";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Belgrade";
  i18n.defaultLocale = "en_US.UTF-8";

  # ─────────────────────────────────────────────
  # Diskovi
  # ─────────────────────────────────────────────
  fileSystems."/mnt/games" = {
    device = "/dev/sdb1";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  # ─────────────────────────────────────────────
  # Ostalo
  # ─────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true; # Potrebno za NVIDIA drajver, Steam i sl.

  system.autoUpgrade = {
    enable = true;
    flake = "~/Documents/nixos-config#laptop";
    flags = [
      "--update-input"
      "nixpkgs"
    ];
    dates = "weekly";
    allowReboot = false; # Ne restartuje automatski
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "26.05";
}
