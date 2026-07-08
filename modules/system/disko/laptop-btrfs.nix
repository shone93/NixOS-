# modules/system/disko/laptop-btrfs.nix
#
# btrfs + impermanence disko raspored za LAPTOPOVE (Evangelion sada;
# Stardew kasnije AKO/kada se reinstalira). Jedan NVMe disk se pretpostavlja.
#
# VAZNO: `device` je PLACEHOLDER. Pre `terraform apply` / nixos-anywhere
# potvrdi stvarni put diska na ciljnoj masini (`lsblk -dno NAME,SIZE,MODEL`).
# nixos-anywhere svakako regenerise hardware-configuration.nix posle instalacije.
{ inputs, lib, ... }:

{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices.disk.main = {
    type = "disk";
    device = lib.mkDefault "/dev/nvme0n1"; # PLACEHOLDER — proveri sa `lsblk`
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ]; # prepisi postojeci fs (fresh install)
            subvolumes = {
              # @ = root; rola se nazad na prazno pri svakom butu (impermanence).
              "@" = {
                mountpoint = "/";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              # @persist = sve sto mora da prezivi wipe (vidi impermanence.nix).
              "@persist" = {
                mountpoint = "/persist";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              # @nix = nix store; NIKAD se ne brise.
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              # @log = /var/log kao zaseban subvolume da logovi prezive wipe.
              "@log" = {
                mountpoint = "/var/log";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
            };
          };
        };
      };
    };
  };
}
