{ pkgs, ... }:

  # Verzija Home Manager stanja (mora pratiti sistemsku verziju)
  home.stateVersion = "26.05";

  # ─────────────────────────────────────────────
  # Podrazumevani editor
  # ─────────────────────────────────────────────
  home.sessionVariables = {
    EDITOR = "zeditor";
    VISUAL = "zeditor";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain"            = "dev.zed.Zed.desktop";
      "text/x-nix"            = "dev.zed.Zed.desktop";
      "x-scheme-handler/http"  = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "text/html"              = "zen.desktop";
      "application/xhtml+xml"  = "zen.desktop";
    };
  };

  # ─────────────────────────────────────────────
  # Terminal
  # ─────────────────────────────────────────────
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "tokyonight_night";
      font-size = 12;
      background-opacity = 0.85;
      command = "bash -c 'fastfetch; exec bash'";
    };
  };

  # ─────────────────────────────────────────────
  # Fastfetch
  # ─────────────────────────────────────────────
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "~/.config/fastfetch/logo.txt";
        type = "file";
        padding = {
          right = 4;
        };
      };
      modules = [
        "os"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "display"
        "de"
        "wm"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "disk"
        "battery"
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "shone93";
    userEmail = "nenadcvijanovic93@gmail.com";  # zameni sa tvojim GitHub emailom
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;  # automatski postavlja upstream pri prvom push-u
    };
  };
}
