{ ... }:

{
  # ─────────────────────────────────────────────
  # WhiteWolf - zajednička podešavanja za sve mašine
  # ─────────────────────────────────────────────
  imports = [
    ../common/plasma-base.nix
    ../common/ghostty.nix
  ];

  home.stateVersion = "26.05";

  # Podrazumevani editor
  home.sessionVariables = {
    EDITOR = "zeditor";
    VISUAL = "zeditor";
  };

  # Rebuild skripta - auto-detektuje hostname (#$(hostname))
  # tako da ista komanda radi i na Stardew i na SolidSnake.
  home.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/Documents/nixos-config#$(hostname) && (cd ~/Documents/nixos-config && git add . && git commit -m rebuild && git push)";
    update = "cd ~/Documents/nixos-config && nix flake update";
  };

  # Default aplikacije
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = "dev.zed.Zed.desktop";
      "text/x-nix" = "dev.zed.Zed.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "text/html" = "zen-beta.desktop";
      "application/xhtml+xml" = "zen-beta.desktop";
    };
  };

  # Ghostty - whitewolf dodaje fastfetch na startup (preko zajedničke baze)
  programs.ghostty.settings.command = "bash -c 'fastfetch; exec bash'";

  # ─────────────────────────────────────────────
  # Fastfetch - riced
  # ─────────────────────────────────────────────
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "~/.config/fastfetch/logo.txt";
        type = "file";
        color = {
          "1" = "red";
        };
        padding = {
          top = 1;
          right = 4;
          left = 2;
        };
      };

      display = {
        separator = "  ";
        color = {
          keys = "blue";
          title = "magenta";
        };
      };

      modules = [
        "break"
        {
          type = "title";
          color = {
            user = "magenta";
            at = "white";
            host = "blue";
          };
        }
        "break"
        {
          type = "os";
          key = "  󰣛 OS";
          keyColor = "blue";
        }
        {
          type = "kernel";
          key = "  󰌽 Kernel";
          keyColor = "blue";
        }
        {
          type = "uptime";
          key = "  󰅐 Uptime";
          keyColor = "cyan";
        }
        {
          type = "packages";
          key = "  󰏖 Packages";
          keyColor = "cyan";
        }
        {
          type = "shell";
          key = "   Shell";
          keyColor = "green";
        }
        {
          type = "de";
          key = "  󰍹 DE";
          keyColor = "green";
        }
        {
          type = "wm";
          key = "  󱂬 WM";
          keyColor = "yellow";
        }
        {
          type = "terminal";
          key = "   Terminal";
          keyColor = "yellow";
        }
        "break"
        {
          type = "cpu";
          key = "  󰻠 CPU";
          keyColor = "red";
        }
        {
          type = "gpu";
          key = "  󰢮 GPU";
          keyColor = "red";
        }
        {
          type = "memory";
          key = "  󰍛 Memory";
          keyColor = "magenta";
        }
        {
          type = "disk";
          key = "  󰋊 Disk";
          keyColor = "magenta";
        }
        {
          type = "battery";
          key = "  󰂄 Battery";
          keyColor = "green";
        }
        "break"
        {
          type = "colors";
          paddingLeft = 2;
          symbol = "circle";
        }
        "break"
      ];
    };
  };

  # Git
  programs.git = {
    enable = true;
    settings = {
      user.name = "shone93";
      user.email = "nenadcvijanovic93@gmail.com";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  programs.bash.enable = true;
}
