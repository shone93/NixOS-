{ ... }:

{
  # ─────────────────────────────────────────────
  # Zajednička KDE Plasma podešavanja (oba korisnika)
  # Wallpaper se postavlja per-user-per-host.
  # ─────────────────────────────────────────────
  programs.plasma = {
    enable = true;

    workspace = {
      theme = "breeze-dark";
      colorScheme = "BreezeDark";
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    # ─────────────────────────────────────────────
    # Prečice za prozore (KDE stock + izmene)
    # ─────────────────────────────────────────────
    shortcuts = {
      kwin = {
        "Window Close" = "Meta+Q";
        "Overview" = "Meta+W";
        "Window Maximize" = "Meta+Up";
        "Window Minimize" = "Meta+Down";
      };
      # Zaključavanje pomereno sa Meta+L (jer L = Lutris)
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
        command = "zen";
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
