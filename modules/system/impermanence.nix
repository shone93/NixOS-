# WIPE-ON-BOOT: root (@) se brise pri svakom butu; samo /persist, /nix, /var/log prezive.
# NIJE u commonModules — uvozi se SAMO u SolidSnake i Evangelion.
{ inputs, lib, ... }:

{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  boot.initrd.systemd.enable = lib.mkDefault true;

  # neededForBoot: impermanence i journald zavise od ovih mountova pre root-a.
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  # Wipe-on-boot servis: brise @ i pravi svez prazan @ pre nego sto se root montira.
  boot.initrd.systemd.services.rollback-root = {
    description = "Rollback btrfs root subvolume (@) to a blank snapshot";
    wantedBy = [ "initrd.target" ];
    after = [ "dev-disk-by\\x2dpartlabel-disk\\x2dmain\\x2droot.device" ];
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      set -eu
      MNT=$(mktemp -d)
      mount -t btrfs -o subvol=/ /dev/disk/by-partlabel/disk-main-root "$MNT"

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

  # SSH host kljucevi MORAJU da prezive — sops-nix ih koristi za dekripciju.
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      # /var/lib/nixos: bez ovoga uid/gid se menjaju pri svakom butu i kvare vlasnistvo fajlova.
      "/var/lib/nixos"
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
      "/var/lib/systemd/coredump"
      {
        directory = "/home/whitewolf";
        user = "whitewolf";
        group = "users";
        mode = "0700";
      }
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };
}
