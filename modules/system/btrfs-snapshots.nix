# NIJE backup — snapper rollback safety-net nad /persist. SAMO SolidSnake i Evangelion.
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
