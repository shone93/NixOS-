{ pkgs, ... }:

{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    khelpcenter
    kate
    kmail
    korganizer
    kontact
    kaddressbook
    elisa
    gwenview
    okular
    kmousetool
    kmouth
  ];

  environment.systemPackages = with pkgs; [
    kdePackages.ark
  ];
}
