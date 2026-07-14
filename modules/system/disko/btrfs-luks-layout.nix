# Cist disko layout (LUKS + btrfs subvolumi) — DELJEN izmedju laptop-btrfs.nix i
# VM testa (tests/impermanence.nix). Namerno bez modula/inputs/mkDefault:
# `disko.lib.testLib.makeDiskoTest` ga uvozi kao obican attrset, a `device` se
# postavlja izvan (host ga mkDefault-uje, test okvir ga preusmeri na /dev/vdX).
# `passwordFile` je null u produkciji (interaktivni unos pri butu); test ga
# postavlja na /tmp/secret.key za format-time bez interakcije.
{
  lib,
  passwordFile ? null,
}:

{
  disko.devices.disk.main = {
    type = "disk";
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
          }
          // lib.optionalAttrs (passwordFile != null) { inherit passwordFile; };
        };
      };
    };
  };
}
