# modules/system/impermanence-lizzywizzy.nix
#
# Dodaje /home/lizzywizzy u /persist listu. Uvozi se SAMO na hostovima gde
# lizzywizzy postoji (SolidSnake). Evangelion je single-user (samo whitewolf).
{ ... }:

{
  environment.persistence."/persist".directories = [
    {
      directory = "/home/lizzywizzy";
      user = "lizzywizzy";
      group = "users";
      mode = "0700";
    }
  ];
}
