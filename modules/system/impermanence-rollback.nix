# Wipe-on-boot rollback za btrfs root (@) — izdvojeno iz impermanence.nix da bi
# VM test (tests/impermanence.nix) mogao da uveze PRAVI servis, ne kopiju.
# Namerno BEZ `inputs` — mora biti uvozivo iz disko test okvira.
{ lib, ... }:

{
  boot.initrd.systemd.enable = lib.mkDefault true;

  # neededForBoot: impermanence i journald zavise od ovih mountova pre root-a.
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  # Wipe-on-boot servis: brise @ i pravi svez prazan @ pre nego sto se root montira.
  # VAZNO: btrfs zivi na /dev/mapper/crypted (root je u LUKS-u), pa servis MORA da
  # ide POSLE otkljucavanja (systemd-cryptsetup@crypted.service), ne posle sirove
  # particije — inace SolidSnake/Evangelion ne bootuju na realnom hardveru.
  boot.initrd.systemd.services.rollback-root = {
    description = "Rollback btrfs root subvolume (@) to a blank snapshot";
    wantedBy = [ "initrd.target" ];
    after = [ "systemd-cryptsetup@crypted.service" ];
    requires = [ "systemd-cryptsetup@crypted.service" ];
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      set -eu
      MNT=$(mktemp -d)
      mount -t btrfs -o subvol=/ /dev/mapper/crypted "$MNT"

      # Obrisi stari @ i sve ugnjezdene subvolume ispod njega.
      if [ -e "$MNT/@" ]; then
        btrfs subvolume list -o "$MNT/@" | cut -f9 -d' ' | while read -r sub; do
          btrfs subvolume delete "$MNT/$sub" || true
        done
        btrfs subvolume delete "$MNT/@"
      fi

      # Napravi svez, prazan @ (root pocinje prazan pri svakom butu).
      btrfs subvolume create "$MNT/@"

      umount "$MNT"
      rmdir "$MNT"
    '';
  };
}
