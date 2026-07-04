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
      };

      # ─────────────────────────────────────────────
      # KROHNKITE - sada kad su KDE konflikti ugašeni
      # ─────────────────────────────────────────────
      kwin_scripts = {
        # Fokus - Meta+strelice
        "Krohnkite: Focus Up" = "Meta+Up";
        "Krohnkite: Focus Down" = "Meta+Down";
        "Krohnkite: Focus Left" = "Meta+Left";
        "Krohnkite: Focus Right" = "Meta+Right";

        # Pomeranje - Meta+Shift+strelice
        "Krohnkite: Move Up/Prev" = "Meta+Shift+Up";
        "Krohnkite: Move Down/Next" = "Meta+Shift+Down";
        "Krohnkite: Move Left" = "Meta+Shift+Left";
        "Krohnkite: Move Right" = "Meta+Shift+Right";

        # Resize - Meta+Ctrl+strelice
        "Krohnkite: Grow Height" = "Meta+Ctrl+Down";
        "Krohnkite: Shrink Height" = "Meta+Ctrl+Up";
        "Krohnkite: Grow Width" = "Meta+Ctrl+Right";
        "Krohnkite: Shrink Width" = "Meta+Ctrl+Left";

        # Layout - Meta+Shift+slovo
        "Krohnkite: Tile Layout" = "Meta+Shift+T";
        "Krohnkite: Monocle Layout" = "Meta+Shift+M";
        "Krohnkite: Toggle Float" = "Meta+Shift+F";
        "Krohnkite: Next Layout" = "Meta+Shift+Space";
        "Krohnkite: Set master" = "Meta+Shift+Return";
        "Krohnkite: Rotate" = "Meta+Shift+R";
      };

      "services/org.kde.krunner.desktop"."_launch" = "Meta+Space";
      "ksmserver"."Lock Session" = "Meta+Escape";
    };

    # ─────────────────────────────────────────────
    # Pokretanje programa (PLAIN Meta + slovo)
    # ─────────────────────────────────────────────
    hotkeys.commands = {
      "launch-terminal" = { name = "Ghostty"; key = "Meta+T"; command = "ghostty"; };
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
