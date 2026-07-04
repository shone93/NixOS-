{ pkgs, ... }:

{
  # ─────────────────────────────────────────────
  # KDE Plasma 6 + SDDM
  # ─────────────────────────────────────────────
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  # ─────────────────────────────────────────────
  # KDE aplikacije
  # ─────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    kdePackages.ark
  ];

  # ─────────────────────────────────────────────
  # Debloat - uklanja KDE aplikacije koje ne koristiš
  # ─────────────────────────────────────────────
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
}
