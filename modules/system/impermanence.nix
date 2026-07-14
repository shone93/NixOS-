# WIPE-ON-BOOT: root (@) se brise pri svakom butu; samo /persist, /nix, /var/log prezive.
# NIJE u commonModules — uvozi se SAMO u SolidSnake i Evangelion.
{ inputs, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    # rollback servis je izdvojen (bez inputs) da ga VM test moze uvesti direktno.
    ./impermanence-rollback.nix
  ];

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
