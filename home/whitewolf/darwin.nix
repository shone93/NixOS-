{ ... }:

{
  # Minimalni home-manager za whitewolf na radnom Mac-u.
  # NAMERNO ne importuje global.nix jos — global.nix povlaci ghostty/yazi
  # overlay-e ciju darwin kompatibilnost ne mozemo da testiramo bez Mac-a.
  # Prebaci OS-agnosticne delove (git config, aliasi) inkrementalno kad
  # bude realnog Mac-a za test.
  home.stateVersion = "26.05";

  programs.git.enable = true;

  home.shellAliases = {
    ll = "ls -la";
  };
}
