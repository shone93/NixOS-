{ pkgs, ... }:

{
  # ─────────────────────────────────────────────
  # KDE Plasma 6 + SDDM (minimalan tamni login)
  # ─────────────────────────────────────────────
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "breeze"; # Čist, minimalan, tamni login ekran
  };
  services.desktopManager.plasma6.enable = true;

  # Tamna SDDM pozadina (siva/crna) umesto default plave
  # Breeze SDDM prati sistemsku temu; za čistu boju koristimo običnu pozadinu.

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
