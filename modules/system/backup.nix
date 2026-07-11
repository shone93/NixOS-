# restic: off-disk backup /home/whitewolf. SAMO Stardew (jedina masina sa realnim podacima).
# Backend (repository) i secrets moraju da se popune pre nego sto backup postane aktivan.
{ config, lib, ... }:

{
  config = lib.mkIf (builtins.pathExists ../../secrets.yaml) {
    sops.secrets.restic-repo-password = { };
    sops.secrets.restic-b2-credentials = { };

    services.restic.backups.stardew-home = {
      paths = [ "/home/whitewolf" ];
      exclude = [
        "*/.cache"
        "*/node_modules"
      ];
      # ZAMENI pravim backend-om pre aktivacije (B2 / Hetzner Storage Box / eksterni disk).
      repository = "REPLACE — npr. b2:bucket-name:path ili sftp:user@host:/putanja";
      passwordFile = config.sops.secrets.restic-repo-password.path;
      environmentFile = config.sops.secrets.restic-b2-credentials.path;
      initialize = true;
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
      ];
    };
  };
}
