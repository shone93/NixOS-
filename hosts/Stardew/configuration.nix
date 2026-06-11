{ ... }:

{
  # ─────────────────────────────────────────────
  # Stardew - Laptop (Lenovo IdeaPad Y700)
  # Host-specifična podešavanja idu ovde.
  # Zajednički moduli se importuju preko flake.nix.
  # ─────────────────────────────────────────────

  networking.hostName = "Stardew";

  # Igre disk (1TB) - po UUID-u tako da ne zavisi od sda/sdb
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/e0c6d58c-8316-47fc-83c9-3e767ede2c50";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };
}
