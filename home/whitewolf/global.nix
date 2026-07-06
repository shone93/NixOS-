{ pkgs, inputs, ... }:

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
  home.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/Documents/nixos-config#$(hostname) && (cd ~/Documents/nixos-config && git add . && git commit -m rebuild && git push)";
    update = "cd ~/Documents/nixos-config && nix flake update";
  };

  # 'shortcuts' komanda - cheatsheet svih prečica
  home.packages = [
    (pkgs.writeShellScriptBin "shortcuts" (builtins.readFile ../common/shortcuts))
  ];

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
  # Zoxide - pametna navigacija po direktorijumima (frecency)
  # ─────────────────────────────────────────────
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  # ─────────────────────────────────────────────
  # Yazi - terminal file manager (reproducible, sa pluginovima)
  # ─────────────────────────────────────────────
  programs.yazi = {
    enable = true;
    enableBashIntegration = true; # 'y' komanda menja folder na izlazu

    settings = {
      mgr = {
        show_hidden = false;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
        image_filter = "lanczos3";
      };
    };

    # VSCode Dark Plus tema
    flavors = {
      inherit (pkgs.yaziFlavors) vscode-dark-plus;
    };
    theme.flavor = {
      dark = "vscode-dark-plus";
    };

    # Plugins (reproducible preko nix-yazi-plugins)
    plugins = with pkgs.yaziPlugins; {
      inherit
        full-border # čist border oko panela
        git # git status na fajlovima
        smart-enter # enter otvara fajl ili ulazi u folder
        jump-to-char # brza navigacija
        chmod # permisije bez izlaska
        mount # USB/drive mount
        ouch # extract/compress arhiva
        starship # lep prompt u yazi
        ;
    };

    initLua = ''
      require("full-border"):setup()
      require("git"):setup()
      require("starship"):setup()
      require("zoxide"):setup { update_db = true }
    '';

    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "l" ];
          run = "plugin smart-enter";
          desc = "Uđi u folder ili otvori fajl";
        }
        {
          on = [ "<Enter>" ];
          run = "plugin smart-enter";
          desc = "Uđi u folder ili otvori fajl";
        }
        {
          on = [ "f" ];
          run = "plugin jump-to-char";
          desc = "Skoči na karakter";
        }
        {
          on = [ "z" ];
          run = "plugin fzf";
          desc = "Fuzzy find fajl (fzf)";
        }
        {
          on = [ "Z" ];
          run = "plugin zoxide";
          desc = "Skoči na direktorijum (zoxide, frecency)";
        }
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Promeni permisije";
        }
        {
          on = [ "M" ];
          run = "plugin mount";
          desc = "Mount meni";
        }
        {
          on = [ "C" ];
          run = "plugin ouch --args=zip";
          desc = "Kompresuj u arhivu";
        }
      ];
    };
  };

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
