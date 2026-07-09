# SAMO SolidSnake: dodaje /home/lizzywizzy u /persist. Evangelion je single-user.
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
