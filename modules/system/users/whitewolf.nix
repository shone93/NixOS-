{ pkgs, lib, config, ... }:

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
    # Deklarativna lozinka SAMO na impermanence hostovima (mutableUsers=false).
    # Ako secrets.yaml nedostaje -> tajna nije definisana -> nalog ostaje zakljucan (fail-closed).
    hashedPasswordFile = lib.mkIf (
      !config.users.mutableUsers && config.sops.secrets ? whitewolf-password
    ) config.sops.secrets.whitewolf-password.path;
  };
  users.groups.whitewolf = { };
}
