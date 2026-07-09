{ ... }:

{
  # Scaffold: ne importuje global.nix — darwin kompatibilnost overlay-a nije testirana.
  home.stateVersion = "26.05";

  programs.git.enable = true;

  home.shellAliases = {
    ll = "ls -la";
  };
}
