{ ... }:

{
  # ─────────────────────────────────────────────
  # Zajednička KDE Plasma podešavanja (oba korisnika)
  # ─────────────────────────────────────────────
  programs.plasma = {
    enable = true;

    workspace = {
      theme = "breeze-dark";
      colorScheme = "BreezeDark";
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    # ─────────────────────────────────────────────
    # Prečice za prozore + čišćenje konflikata
    # ─────────────────────────────────────────────
    shortcuts = {
      kwin = {
        "Window Close" = "Meta+Q";
        "Overview" = "Meta+Tab"; # premešteno sa Meta+W

        # Navigacija između prozora (fokus u pravcu)
        "Switch Window Left" = "Meta+Left";
        "Switch Window Right" = "Meta+Right";
        "Switch Window Up" = "Meta+Up";
        "Switch Window Down" = "Meta+Down";

        # Virtuelni desktopovi na Meta+1..4
        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
      };

      # KRunner na Meta+Space
      "services/org.kde.krunner.desktop"."_launch" = "Meta+Space";

      # Zaključavanje pomereno sa Meta+L (L = Lutris)
      "ksmserver"."Lock Session" = "Meta+Escape";
    };

    # ─────────────────────────────────────────────
    # Pokretanje programa (Meta + slovo)
    # ─────────────────────────────────────────────
    hotkeys.commands = {
      "launch-terminal" = {
        name = "Ghostty";
        key = "Meta+T";
        command = "ghostty";
      };
      "launch-yazi" = {
        name = "Yazi File Manager";
        key = "Meta+E";
        command = "ghostty -e yazi";
      };
      "launch-zed" = {
        name = "Zed";
        key = "Meta+Z";
        command = "zeditor";
      };
      "launch-zen" = {
        name = "Zen Browser";
        key = "Meta+B";
        command = "zen-beta";
      };
      "launch-steam" = {
        name = "Steam";
        key = "Meta+S";
        command = "steam";
      };
      "launch-lutris" = {
        name = "Lutris";
        key = "Meta+L";
        command = "lutris";
      };
      "launch-heroic" = {
        name = "Heroic";
        key = "Meta+G";
        command = "heroic";
      };
      "launch-obsidian" = {
        name = "Obsidian";
        key = "Meta+O";
        command = "obsidian";
      };
      "launch-discord" = {
        name = "Vesktop";
        key = "Meta+D";
        command = "vesktop";
      };
      "launch-libreoffice" = {
        name = "LibreOffice";
        key = "Meta+V";
        command = "libreoffice";
      };
      "launch-blender" = {
        name = "Blender";
        key = "Meta+C";
        command = "blender";
      };
    };
  };
}
