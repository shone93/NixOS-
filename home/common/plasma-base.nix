{ ... }:

{
  # ─────────────────────────────────────────────
  # Zajednička KDE Plasma podešavanja (oba korisnika)
  # Wallpaper se NE postavlja ovde - to je per-user-per-host.
  # ─────────────────────────────────────────────
  programs.plasma = {
    enable = true;

    workspace = {
      theme = "breeze-dark";
      colorScheme = "BreezeDark";
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    shortcuts = {
      "kwin"."Window Maximize" = "Meta+Up";
      "kwin"."Window Minimize" = "Meta+Down";
    };
  };
}
