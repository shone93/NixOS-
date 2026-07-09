{ pkgs, ... }:

{
  # NIJE uvezen nigde jos — aktivisati u flake.nix kad bude spreman.
  environment.systemPackages = with pkgs; [
    thunar
    yazi
    grim
    slurp
    polkit-kde-agent
    swww
    wlogout
  ];
}
