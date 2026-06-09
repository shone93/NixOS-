{ ... }:

{
  # ─────────────────────────────────────────────
  # Korisnici
  # ─────────────────────────────────────────────
  users.users.whitewolf = {
    isNormalUser = true;
    description = "WhiteWolf";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  users.groups.whitewolf = { };

  users.users.lizzywizzy = {
    isNormalUser = true;
    description = "Lizzy Wizzy";
    extraGroups = [ "networkmanager" ];
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
  ];

  # ─────────────────────────────────────────────
  # Diskovi
  # ─────────────────────────────────────────────
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/e0c6d58c-8316-47fc-83c9-3e767ede2c50";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };
  # ─────────────────────────────────────────────
  # Nix podešavanja
  # ─────────────────────────────────────────────
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  system.autoUpgrade = {
    enable = true;
    flake = "~/Documents/nixos-config#laptop";
    flags = [
      "--update-input"
      "nixpkgs"
    ];
    dates = "weekly";
    allowReboot = false;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "26.05";
}
