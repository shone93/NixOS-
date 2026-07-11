{ lib, config, ... }:

{
  users.users.lizzywizzy = {
    isNormalUser = true;
    description = "Lizzy Wizzy";
    extraGroups = [ "networkmanager" ]; # bez wheel - nije admin
    # Deklarativna lozinka SAMO na impermanence hostovima (mutableUsers=false); fail-closed ako tajne nema.
    hashedPasswordFile = lib.mkIf (
      !config.users.mutableUsers && config.sops.secrets ? lizzywizzy-password
    ) config.sops.secrets.lizzywizzy-password.path;
  };
}
