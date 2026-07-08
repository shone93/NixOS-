# modules/system/impermanence.nix
#
# Deljeni impermanence sloj: root (@) se brise pri svakom butu, samo
# eksplicitno perzistirane putanje (ispod) prezive u /persist.
#
# VAZNO — NIJE u commonModules namerno. Stardew (jedina realna masina) se
# NE dira dok korisnik ne odluci; ovaj modul se uvozi SAMO u SolidSnake i
# Evangelion preko njihovih systemModules u flake.nix.
#
# Zavisi od disko rasporeda (disko/*.nix) koji pravi @, @persist, @nix, @log
# subvolume. Root (@) se pri svakom butu brise i pravi iznova prazan.
{ inputs, lib, ... }:

{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  # systemd-based initrd je neophodan za rollback servis ispod.
  boot.initrd.systemd.enable = lib.mkDefault true;

  # Moraju biti montirani rano: impermanence bind-mountuje iz /persist,
  # journald pise u /var/log (zaseban subvolume).
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  # Wipe-on-boot: brise @ i pravi svez prazan @ pre nego sto se root montira.
  # Sve van /persist, /nix, /var/log se gubi pri svakom butu.
  # Best-effort: validiraj u VM-u (nixos-anywhere --vm-test) pre stvarnog hw.
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

  # Perzistencija. Puna /home/whitewolf je namerno perzistirana (najprostiji,
  # najbezbedniji default). Time su pokriveni i Syncthing kljucevi
  # (~/.config/syncthing), KDE stanje (kwallet, plasma*), i ostali dotfajlovi.
  # SSH host kljucevi MORAJU da prezive — sops-nix ih koristi za dekripciju.
  # /home/lizzywizzy se dodaje zasebno (impermanence-lizzywizzy.nix) samo gde
  # lizzywizzy postoji (SolidSnake). Evangelion je single-user.
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      # /var/lib/nixos cuva dodeljene uid/gid — bez perzistiranja bi se
      # korisnicima (whitewolf, lizzywizzy) menjali uid-ovi pri svakom butu
      # i pokvarilo bi vlasnistvo nad perzistiranim /home fajlovima.
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
