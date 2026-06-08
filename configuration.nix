{ config, pkgs, ... }:

{
  # ─────────────────────────────────────────────
  # Korisnik
  # ─────────────────────────────────────────────
  users.users.whitewolf = {
    isNormalUser = true;
    description = "WhiteWolf";
    extraGroups = [ "networkmanager" "wheel" ]; # 'wheel' omogućava sudo komande
  };
  users.groups.whitewolf = {};

  imports = [
    ./hardware-configuration.nix
    ./modules/apps.nix
    ./modules/gaming.nix
    # ./modules/work-apps.nix # Isključeno za ovaj računar
  ];

  # ─────────────────────────────────────────────
  # Nix podešavanja
  # ─────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # Omogućava flakes bez dodatnih flagova

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
    options = [ "defaults" "nofail" ];
  };

  # ─────────────────────────────────────────────
  # Ostalo
  # ─────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true; # Potrebno za NVIDIA drajver, Steam i sl.

  system.stateVersion = "26.05";
}
