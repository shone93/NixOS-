{ pkgs, ... }:

{
  # ─────────────────────────────────────────────
  # KDE Plasma 6 + SDDM (minimalan crni login)
  # ─────────────────────────────────────────────
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "breeze";
  };
  services.desktopManager.plasma6.enable = true;

  # Crna pozadina za SDDM login ekran.
  # Ne zavisi od wallpapera - uvek crna, nikad se ne menja.
  environment.etc."sddm/themes/breeze/theme.conf.user".text = ''
    [General]
    type=color
    color=#000000
    background=
  '';

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
