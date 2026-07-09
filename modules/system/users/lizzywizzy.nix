{ ... }:

{
  users.users.lizzywizzy = {
    isNormalUser = true;
    description = "Lizzy Wizzy";
    extraGroups = [ "networkmanager" ]; # bez wheel - nije admin
  };
}
