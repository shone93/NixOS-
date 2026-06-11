{ ... }:

{
  users.users.whitewolf = {
    isNormalUser = true;
    description = "WhiteWolf";
    extraGroups = [
      "networkmanager"
      "wheel" # 'wheel' omogućava sudo komande
    ];
  };
  users.groups.whitewolf = { };

  users.users.lizzywizzy = {
    isNormalUser = true;
    description = "Lizzy Wizzy";
    extraGroups = [ "networkmanager" ]; # bez wheel - nije admin
  };
}
