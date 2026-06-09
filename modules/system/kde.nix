{ pkgs, ... }:

{
  # KDE Plasma 6 + SDDM
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  # KDE specifične aplikacije
  environment.systemPackages = with pkgs; [
    kdePackages.ark
  ];
}
