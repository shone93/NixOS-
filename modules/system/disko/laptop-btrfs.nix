# VAZNO: `device` je PLACEHOLDER — potvrdi sa `lsblk` pre `terraform apply`. Disk se BRISE.
# LUKS+btrfs layout je izdvojen u ./btrfs-luks-layout.nix (deljen sa VM testom u tests/).
{ inputs, lib, ... }:

let
  layout = import ./btrfs-luks-layout.nix { inherit lib; };
in
{
  imports = [ inputs.disko.nixosModules.disko ];

  # Lozinka se unosi interaktivno pri svakom butu; nema mehanizma za automatsko
  # otkljucavanje bez korisnicke intervencije.
  disko.devices = lib.recursiveUpdate layout.disko.devices {
    disk.main.device = lib.mkDefault "/dev/nvme0n1"; # PLACEHOLDER — proveri sa `lsblk`
  };
}
