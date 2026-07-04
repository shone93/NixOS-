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

  # Generiši crnu sliku i postavi je kao SDDM pozadinu.
  # Breeze SDDM čita 'background=' putanju, pa crna slika radi
  # tamo gde 'type=color' nije.
  environment.etc."sddm-black.png".source =
    pkgs.runCommand "sddm-black.png" { } ''
      ${pkgs.imagemagick}/bin/convert -size 1920x1080 xc:black $out
    '';

  environment.etc."sddm/themes/breeze/theme.conf.user".text = ''
    [General]
    background=/etc/sddm-black.png
    type=image
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
