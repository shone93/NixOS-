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

    # 4 virtuelna desktopa (da Ctrl+F1..F4 imaju gde da idu)
    kwin.virtualDesktops = {
      number = 4;
      rows = 1;
    };

    # NumLock uključen po defaultu (0 = On u KDE logici)
    configFile.kcminputrc."Keyboard"."NumLock".value = 0;

    shortcuts = {
      kwin = {
        "Window Close" = "Meta+Q";
        "Overview" = "Meta+Tab";

        # Virtuelni desktopovi - Ctrl+F1..F4 (KDE standard)
        "Switch to Desktop 1" = "Ctrl+F1";
        "Switch to Desktop 2" = "Ctrl+F2";
        "Switch to Desktop 3" = "Ctrl+F3";
        "Switch to Desktop 4" = "Ctrl+F4";

        # KDE native tiling editor - oslobodi Meta+T
        "Edit Tiles" = "none";
      };

      # ─────────────────────────────────────────────
      # KROHNKITE - remapiranje (oslobađa plain Meta+slovo)
      # ─────────────────────────────────────────────
      kwin_scripts = {
        # Fokus na strelice
        "Krohnkite: Focus Up" = "Meta+Up";
        "Krohnkite: Focus Down" = "Meta+Down";
        "Krohnkite: Focus Left" = "Meta+Left";
        "Krohnkite: Focus Right" = "Meta+Right";

        # Pomeranje prozora - Meta+Shift+strelice
        "Krohnkite: Move Up/Prev" = "Meta+Shift+Up";
        "Krohnkite: Move Down/Next" = "Meta+Shift+Down";
        "Krohnkite: Move Left" = "Meta+Shift+Left";
        "Krohnkite: Move Right" = "Meta+Shift+Right";

        # Resize - Meta+Ctrl+strelice
        "Krohnkite: Grow Height" = "Meta+Ctrl+Down";
        "Krohnkite: Shrink Height" = "Meta+Ctrl+Up";
        "Krohnkite: Grow Width" = "Meta+Ctrl+Right";
        "Krohnkite: Shrink Width" = "Meta+Ctrl+Left";

        # Layout kontrole - Meta+Shift+slovo (ne konfliktuje sa launchers)
        "Krohnkite: Tile Layout" = "Meta+Shift+T";
        "Krohnkite: Monocle Layout" = "Meta+Shift+M";
        "Krohnkite: Toggle Float" = "Meta+Shift+F";
        "Krohnkite: Next Layout" = "Meta+Shift+Space";
        "Krohnkite: Set master" = "Meta+Shift+Return";
        "Krohnkite: Rotate" = "Meta+Shift+R";

        # Oslobodi konfliktne plain Meta+slovo bindove
        "Krohnkite: Decrease" = "none";       # bio Meta+D (= Discord)
        "Krohnkite: Increase" = "none";       # bio Meta+I
        "Krohnkite: Focus Next" = "none";
        "Krohnkite: Focus Previous" = "none";
      };

      # KRunner
      "services/org.kde.krunner.desktop"."_launch" = "Meta+Space";

      # Zaključavanje - Meta+Escape (L = Lutris)
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
