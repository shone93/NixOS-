{ ... }:

{
  # ─────────────────────────────────────────────
  # Evangelion - novi glavni laptop
  # Host-specifična podešavanja idu ovde.
  # Zajednički moduli se importuju preko flake.nix.
  # ─────────────────────────────────────────────

  networking.hostName = "Evangelion";

  # Ovde dodaj diskove specifične za Evangelion kada se hardver sazna
  # (drugačiji UUID nego ostali hostovi), npr.:
  # fileSystems."/mnt/games" = {
  #   device = "/dev/disk/by-uuid/ZAMENI-ME";
  #   fsType = "ext4";
  #   options = [ "defaults" "nofail" ];
  # };
}
