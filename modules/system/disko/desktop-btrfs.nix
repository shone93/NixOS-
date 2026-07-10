# VAZNO: `device` je PLACEHOLDER — potvrdi sa `lsblk` pre `terraform apply`. Disk se BRISE.
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
          # Lozinka se unosi interaktivno pri svakom butu; nema mehanizma za
          # automatsko otkljucavanje bez korisnicke intervencije.
          # Desktop: LUKS je opcionalan (masina nije mobilna), ali se cuva
          # identican layout sa laptop-btrfs.nix radi konzistentnosti.
          content = {
            type = "luks";
            name = "crypted";
            settings.allowDiscards = true; # SSD trim kroz LUKS
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "@" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@persist" = {
                  mountpoint = "/persist";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@log" = {
                  mountpoint = "/var/log";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
