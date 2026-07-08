# modules/system/btrfs-snapshots.nix
#
# Automatski btrfs snapshotovi (snapper) nad /persist. Ovo je rollback
# safety-net NA VRHU NixOS generacija — NIJE backup. Za stvarni gubitak
# podataka i dalje vazi eksterni backup (Phase 0 iz spec-a).
#
# Uvozi se samo na hostovima koji su na novoj (btrfs) arhitekturi:
# SolidSnake i Evangelion. Stardew NE, dok se ne reinstalira.
#
# Retencija je konzervativna; prilagodi brojeve realnoj velicini diska.
{ ... }:

{
  services.snapper.configs.persist = {
    SUBVOLUME = "/persist";
    ALLOW_USERS = [ "whitewolf" ];
    TIMELINE_CREATE = true;
    TIMELINE_CLEANUP = true;
    TIMELINE_LIMIT_HOURLY = 6;
    TIMELINE_LIMIT_DAILY = 7;
    TIMELINE_LIMIT_WEEKLY = 2;
    TIMELINE_LIMIT_MONTHLY = 0;
    TIMELINE_LIMIT_YEARLY = 0;
  };
}
