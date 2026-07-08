# modules/system/disko/desktop-btrfs.nix
#
# btrfs + impermanence disko raspored za DESKTOP (SolidSnake, GTX 1080).
# Jedan glavni disk za OS. Ako kasnije dodas zaseban "games" disk, dodaj
# ga kao poseban disko uredjaj ovde (drugi device path).
#
# VAZNO: `device` je PLACEHOLDER. Desktop moze imati SATA SSD (/dev/sda)
# ili NVMe (/dev/nvme0n1) — potvrdi sa `lsblk` pre `terraform apply`.
# nixos-anywhere regenerise hardware-configuration.nix posle.
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
            extraArgs = [ "-f" ];
            subvolumes = {
              "@" = {
                mountpoint = "/";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              "@persist" = {
                mountpoint = "/persist";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
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
