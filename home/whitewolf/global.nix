{ pkgs, inputs, ... }:

{
  # ─────────────────────────────────────────────
  # WhiteWolf - zajednička podešavanja za sve mašine
  # ─────────────────────────────────────────────
  imports = [
    ../common/ghostty.nix
    ../common/starship.nix
  ];

  home.stateVersion = "26.05";

  home.sessionVariables = {
    EDITOR = "zeditor";
    VISUAL = "zeditor";
  };

  # --no-verify preskace pre-commit hook; push uvek ide.
  home.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/Documents/nixos-config#$(hostname) && (cd ~/Documents/nixos-config && git add -A && (git diff --cached --quiet || git commit -m rebuild --no-verify) && git push)";
    update = "cd ~/Documents/nixos-config && nix flake update";

    nhs = "nh os switch";
    nhb = "nh os boot";
    nhc = "nh clean all";

    ls = "eza --icons --group-directories-first";
    ll = "eza -l --icons --group-directories-first --git";
    la = "eza -la --icons --group-directories-first --git";
  };

  home.packages = [
    (pkgs.writeShellScriptBin "shortcuts" (builtins.readFile ../common/shortcuts))
  ];

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

  programs.ghostty.settings.command = "bash -c 'fastfetch; exec bash'";

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

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
    flavors = {
      # Berserk — rucno pisan flavor, isti hex kao ghostty berserk tema.
      berserk =
        let
          flavorToml = pkgs.writeText "flavor.toml" ''
            [mgr]
            cwd = { fg = "#eb3131" }
            hovered         = { fg = "#fefefe", bg = "#3d3d42" }
            preview_hovered = { underline = true }
            find_keyword  = { fg = "#eb3131", bold = true, italic = true, underline = true }
            find_position = { fg = "#fefefe", bg = "#3d3d42", bold = true }
            marker_copied   = { fg = "#c0392b", bg = "#c0392b" }
            marker_cut      = { fg = "#ff4949", bg = "#ff4949" }
            marker_marked   = { fg = "#eb3131", bg = "#eb3131" }
            marker_selected = { fg = "#ab2e2e", bg = "#ab2e2e" }
            tab_active   = { fg = "#fefefe", bg = "#c0392b" }
            tab_inactive = { fg = "#7a7a7e", bg = "#3d3d42" }
            tab_width    = 1
            count_copied   = { fg = "#1b1b1d", bg = "#c0392b" }
            count_cut      = { fg = "#1b1b1d", bg = "#ff4949" }
            count_selected = { fg = "#1b1b1d", bg = "#eb3131" }
            border_symbol = "│"
            border_style  = { fg = "#7a7a7e" }
            syntect_theme = "./tmtheme.xml"
            cursor_symbol = "█"
            cursor = { fg = "#1b1b1d", bg = "#eb3131" }
            exe_symbol = ""
            exe = { fg = "#eb3131", bg = "#1b1b1d" }
            file_symbol = ""
            file = { }
            folder_symbol = ""
            folder = { fg = "#c0392b", bg = "#1b1b1d" }
            hidden_symbol = ""
            hidden = { fg = "#7a7a7e" }
            link_symbol = ""
            link = { fg = "#eb3131", bg = "#1b1b1d" }
            broken_symbol = ""
            broken = { fg = "#ff4949", bg = "#1b1b1d" }
            selected = { fg = "#fefefe", bg = "#3d3d42" }

            [status]
            separator_open  = ""
            separator_close = ""
            separator_style = { fg = "#3d3d42", bg = "#3d3d42" }
            mode_normal = { fg = "#1b1b1d", bg = "#eb3131", bold = true }
            mode_select = { fg = "#1b1b1d", bg = "#d4956a", bold = true }
            mode_unset  = { fg = "#1b1b1d", bg = "#ff4949", bold = true }
            progress_label  = { bold = true }
            progress_normal = { fg = "#eb3131", bg = "#1b1b1d" }
            progress_error  = { fg = "#ff4949", bg = "#1b1b1d" }
            permissions_t = { fg = "#7a7a7e" }
            permissions_r = { fg = "#d4956a" }
            permissions_w = { fg = "#eb3131" }
            permissions_x = { fg = "#c0392b" }
            permissions_s = { fg = "#7a7a7e" }

            [select]
            border   = { fg = "#eb3131" }
            active   = { fg = "#eb3131", bold = true }
            inactive = {}

            [input]
            border   = { fg = "#eb3131" }
            title    = {}
            value    = {}
            selected = { reversed = true }

            [completion]
            border   = { fg = "#eb3131" }
            active   = { fg = "#fefefe", bg = "#c0392b" }
            inactive = {}
            icon_file    = ""
            icon_folder  = ""
            icon_command = ""

            [tasks]
            border  = { fg = "#eb3131" }
            title   = {}
            hovered = { underline = true }

            [which]
            mask            = { bg = "#1b1b1d" }
            cand            = { fg = "#eb3131" }
            rest            = { fg = "#7a7a7e" }
            desc            = { fg = "#fefefe" }
            separator       = "  "
            separator_style = { fg = "#7a7a7e" }

            [help]
            on      = { fg = "#eb3131" }
            run     = { fg = "#c0392b" }
            desc    = { fg = "#fefefe" }
            hovered = { bg = "#3d3d42", bold = true }
            footer  = { fg = "#fefefe", bg = "#3d3d42" }

            [filetype]
            rules = [
                { mime = "image/*", fg = "#d4956a" },
                { mime = "video/*", fg = "#d4956a" },
                { mime = "audio/*", fg = "#d4956a" },
                { mime = "application/zip", fg = "#ff4949" },
                { mime = "application/gzip", fg = "#ff4949" },
                { mime = "application/x-tar", fg = "#ff4949" },
                { mime = "application/x-bzip", fg = "#ff4949" },
                { mime = "application/x-bzip2", fg = "#ff4949" },
                { mime = "application/x-7z-compressed", fg = "#ff4949" },
                { mime = "application/x-rar", fg = "#ff4949" },
                { mime = "application/pdf", fg = "#eb3131" },
                { mime = "application/msword", fg = "#eb3131" },
                { mime = "application/vnd.openxmlformats-officedocument.*", fg = "#eb3131" },
                { url = "*", fg = "#fefefe" },
                { url = "*/", fg = "#c0392b" },
                { url = "*", category = "executable", fg = "#eb3131", bg = "#1b1b1d" },
                { url = "*/", fg = "#c0392b", bg = "#1b1b1d" },
                { url = ".*", fg = "#7a7a7e" },
                { url = "*", category = "link", fg = "#eb3131", bg = "#1b1b1d" },
                { url = "*", category = "broken", fg = "#ff4949", bg = "#1b1b1d" },
            ]
          '';
        in
        pkgs.runCommandLocal "yazi-flavor-berserk" { } ''
          mkdir -p $out
          cp ${flavorToml} $out/flavor.toml
          cp ${pkgs.yaziFlavors.vscode-dark-plus}/tmtheme.xml $out/tmtheme.xml
        '';
    };
    theme.flavor = {
      dark = "berserk";
    };

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

  # tmux: allow-passthrough je neophodan za yazi image preview u tmux-u.
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g allow-passthrough all
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM
    '';
  };

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
