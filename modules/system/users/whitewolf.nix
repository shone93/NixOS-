{ pkgs, ... }:

{
  users.users.whitewolf = {
    isNormalUser = true;
    group = "whitewolf";
    description = "WhiteWolf";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      # ZAMENI pravim javnim kljucem pre prvog nixos-anywhere deploy-a.
      "ssh-ed25519 AAAA...REPLACE_ME whitewolf@REPLACE"
    ];
  };
  users.groups.whitewolf = { };
}
