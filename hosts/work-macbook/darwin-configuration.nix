{ pkgs, ... }:

{
  # Scaffold: NE ide kroz mkHost; Homebrew namerno iskljucen dok se ne potvrdi MDM situacija.

  system.stateVersion = 5;
  system.primaryUser = "whitewolf";

  users.users.whitewolf.home = "/Users/whitewolf";

  environment.systemPackages = with pkgs; [
    git
    gh
  ];
}
