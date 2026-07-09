{ pkgs, ... }:

{
  # NIJE uvezen nigde jos — aktivisati u flake.nix kad bude spreman.
  programs.niri.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
    config.common.default = "*";
  };

  environment.systemPackages = with pkgs; [
    xdg-utils
    xdg-user-dirs
  ];
}
