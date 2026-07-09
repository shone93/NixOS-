{ ... }:

{
  users.users.whitewolf = {
    isNormalUser = true;
    description = "WhiteWolf";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  users.groups.whitewolf = { };
}
