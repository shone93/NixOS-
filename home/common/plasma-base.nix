{ pkgs, ... }:

{
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

        # UGASI "Switch Window" (kradu plain Meta+strelice = Krohnkite fokus)
        "Switch Window Up" = "none";
        "Switch Window Down" = "none";
        "Switch Window Left" = "none";
        "Switch Window Right" = "none";

        # UGASI Maximize/Minimize (kradu Meta+Up / Meta+Down)
        "Window Maximize" = "none";
        "Window Minimize" = "none";

        # Virtuelni desktopovi ostaju na Ctrl+F1..F4
        "Switch to Desktop 1" = "Ctrl+F1";
        "Switch to Desktop 2" = "Ctrl+F2";
        "Switch to Desktop 3" = "Ctrl+F3";
        "Switch to Desktop 4" = "Ctrl+F4";

        # ─────────────────────────────────────────────
        # KROHNKITE - baseline u [kwin] komponenti (action ID-jevi).
        # NAPOMENA: Krohnkite pri svakom učitavanju imperativno registruje
        # SVOJE defaulte i ignoriše ove vrednosti; stvarno vezivanje radi
        # systemd servis "krohnkite-shortcuts" dole (setForeignShortcut).
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

    hotkeys.commands = {
      "launch-terminal" = {
        name = "Ghostty";
        key = "Meta+Return";
        command = "ghostty";
      };
      "launch-yazi" = {
        name = "Yazi";
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
      "set-wallpaper-mood" = {
        name = "Wallpaper mood (wallust)";
        key = "Meta+Shift+W";
        command = "set-wallpaper-mood";
      };
    };
  };

  # ─────────────────────────────────────────────
  # Krohnkite prečice se NE mogu pouzdano postaviti preko kglobalshortcutsrc —
  # skripta ih pri svakom učitavanju imperativno vrati na svoje defaulte.
  # Zato ih posle prijave nameštamo preko KGlobalAccel.setForeignShortcut
  # (isti mehanizam koji koristi System Settings) — to KWin poštuje i pamti.
  # ─────────────────────────────────────────────
  systemd.user.services.krohnkite-shortcuts = {
    Unit = {
      Description = "Primeni Krohnkite tiling prečice (setForeignShortcut)";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      Type = "oneshot";
      ExecStart =
        let
          dbus = "${pkgs.dbus}/bin/dbus-send";
        in
        "${pkgs.writeShellScript "krohnkite-shortcuts" ''
          # sačekaj da KWin scripting bude spreman i Krohnkite učitan
          for i in $(seq 1 60); do
            if ${dbus} --session --print-reply --dest=org.kde.KWin /Scripting \
                 org.kde.kwin.Scripting.isScriptLoaded string:krohnkite 2>/dev/null \
                 | grep -q "boolean true"; then
              break
            fi
            sleep 1
          done
          sleep 2
          sc() {
            ${dbus} --session --type=method_call --dest=org.kde.kglobalaccel /kglobalaccel \
              org.kde.KGlobalAccel.setForeignShortcut \
              array:string:"kwin","$1","KWin","$2" array:int32:$3
          }
          sc KrohnkiteFocusUp       "Krohnkite: Focus Up"       285212691
          sc KrohnkiteFocusDown     "Krohnkite: Focus Down"     285212693
          sc KrohnkiteFocusLeft     "Krohnkite: Focus Left"     285212690
          sc KrohnkiteFocusRight    "Krohnkite: Focus Right"    285212692
          sc KrohnkiteShiftUp       "Krohnkite: Move Up/Prev"   318767123
          sc KrohnkiteShiftDown     "Krohnkite: Move Down/Next" 318767125
          sc KrohnkiteShiftLeft     "Krohnkite: Move Left"      318767122
          sc KrohnkiteShiftRight    "Krohnkite: Move Right"     318767124
          sc KrohnkiteGrowHeight    "Krohnkite: Grow Height"    352321557
          sc KrohnkiteShrinkHeight  "Krohnkite: Shrink Height"  352321555
          sc KrohnkitegrowWidth     "Krohnkite: Grow Width"     352321556
          sc KrohnkiteShrinkWidth   "Krohnkite: Shrink Width"   352321554
          sc KrohnkiteTileLayout    "Krohnkite: Tile Layout"    301989972
          sc KrohnkiteMonocleLayout "Krohnkite: Monocle Layout" 301989965
          sc KrohnkiteToggleFloat   "Krohnkite: Toggle Float"   301989958
          sc KrohnkiteNextLayout    "Krohnkite: Next Layout"    301989920
          sc KrohnkiteSetMaster     "Krohnkite: Set master"     318767108
          sc KrohnkiteRotate        "Krohnkite: Rotate"         301989970
        ''}";
    };
  };
}
