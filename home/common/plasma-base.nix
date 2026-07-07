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

    kwin.virtualDesktops = {
      number = 4;
      rows = 1;
    };

    # NumLock uključen po defaultu (ispravan način - preko kcminputrc)
    configFile.kcminputrc.Keyboard.NumLock = 0;

    shortcuts = {
      # ─────────────────────────────────────────────
      # KDE NATIVE - gasimo sve što krade tiling tastere
      # ─────────────────────────────────────────────
      kwin = {
        "Window Close" = "Meta+Q";
        "Overview" = "Meta+Tab";

        # UGASI KDE Quick Tile (kradu Meta+strelice)
        "Window Quick Tile Left" = "none";
        "Window Quick Tile Right" = "none";
        "Window Quick Tile Top" = "none";
        "Window Quick Tile Bottom" = "none";

        # UGASI "Switch One Desktop" (kradu Meta+Ctrl+strelice = resize)
        "Switch One Desktop Down" = "none";
        "Switch One Desktop Up" = "none";
        "Switch One Desktop to the Left" = "none";
        "Switch One Desktop to the Right" = "none";

        # UGASI "Window to Next/Previous Screen" (kradu Meta+Shift+strelice = move)
        "Window to Next Screen" = "none";
        "Window to Previous Screen" = "none";

        # UGASI KDE native tiling editor (krade Meta+T)
        "Edit Tiles" = "none";

        # MinimizeAll krade Meta+Shift+D
        "MinimizeAll" = "none";

        # Virtuelni desktopovi ostaju na Ctrl+F1..F4
        "Switch to Desktop 1" = "Ctrl+F1";
        "Switch to Desktop 2" = "Ctrl+F2";
        "Switch to Desktop 3" = "Ctrl+F3";
        "Switch to Desktop 4" = "Ctrl+F4";

        # ─────────────────────────────────────────────
        # KROHNKITE - vezuje se na [kwin] komponentu preko action ID-jeva
        # (NE preko "Krohnkite: ..." imena - to ide u mrtvu kwin_scripts sekciju)
        # ─────────────────────────────────────────────
        # Fokus - Meta+strelice
        "KrohnkiteFocusUp" = "Meta+Up";
        "KrohnkiteFocusDown" = "Meta+Down";
        "KrohnkiteFocusLeft" = "Meta+Left";
        "KrohnkiteFocusRight" = "Meta+Right";

        # Pomeranje - Meta+Shift+strelice
        "KrohnkiteShiftUp" = "Meta+Shift+Up";
        "KrohnkiteShiftDown" = "Meta+Shift+Down";
        "KrohnkiteShiftLeft" = "Meta+Shift+Left";
        "KrohnkiteShiftRight" = "Meta+Shift+Right";

        # Resize - Meta+Ctrl+strelice
        "KrohnkiteGrowHeight" = "Meta+Ctrl+Down";
        "KrohnkiteShrinkHeight" = "Meta+Ctrl+Up";
        "KrohnkitegrowWidth" = "Meta+Ctrl+Right";
        "KrohnkiteShrinkWidth" = "Meta+Ctrl+Left";

        # Layout - Meta+Shift+slovo/strelica
        "KrohnkiteTileLayout" = "Meta+Shift+T";
        "KrohnkiteMonocleLayout" = "Meta+Shift+M";
        "KrohnkiteToggleFloat" = "Meta+Shift+F";
        "KrohnkiteNextLayout" = "Meta+Shift+Space";
        "KrohnkiteSetMaster" = "Meta+Shift+Return";
        "KrohnkiteRotate" = "Meta+Shift+R";
      };

      "services/org.kde.krunner.desktop"."_launch" = "Meta+Space";
      "ksmserver"."Lock Session" = "Meta+Escape";
    };

    # ─────────────────────────────────────────────
    # Pokretanje programa (PLAIN Meta + slovo)
    # ─────────────────────────────────────────────
    hotkeys.commands = {
      "launch-terminal" = { name = "Ghostty"; key = "Meta+Return"; command = "ghostty"; };
      "launch-yazi" = { name = "Yazi"; key = "Meta+E"; command = "ghostty -e yazi"; };
      "launch-zed" = { name = "Zed"; key = "Meta+Z"; command = "zeditor"; };
      "launch-zen" = { name = "Zen Browser"; key = "Meta+B"; command = "zen-beta"; };
      "launch-steam" = { name = "Steam"; key = "Meta+S"; command = "steam"; };
      "launch-lutris" = { name = "Lutris"; key = "Meta+L"; command = "lutris"; };
      "launch-heroic" = { name = "Heroic"; key = "Meta+G"; command = "heroic"; };
      "launch-obsidian" = { name = "Obsidian"; key = "Meta+O"; command = "obsidian"; };
      "launch-discord" = { name = "Vesktop"; key = "Meta+D"; command = "vesktop"; };
      "launch-libreoffice" = { name = "LibreOffice"; key = "Meta+V"; command = "libreoffice"; };
      "launch-blender" = { name = "Blender"; key = "Meta+C"; command = "blender"; };
    };
  };
}
