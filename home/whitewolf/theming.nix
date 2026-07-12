{ pkgs, lib, config, ... }:

{
  home.packages = [
    pkgs.wallust
    pkgs.kdePackages.kdialog

    # set-wallpaper-mood: bira pozadinu, generise paletu wallust-om, primenjuje KDE shemu
    (pkgs.writeShellScriptBin "set-wallpaper-mood" ''
      set -e

      if [ $# -eq 0 ]; then
        img=$(${pkgs.kdePackages.kdialog}/bin/kdialog --getopenfilename "$HOME/Documents/nixos-config/home/wallpapers" "Images (*.jpg *.jpeg *.png *.webp)" 2>/dev/null || true)
        [ -z "$img" ] && exit 0
      else
        img="$1"
      fi

      img=$(realpath "$img")
      plasma-apply-wallpaperimage "$img"
      ${pkgs.wallust}/bin/wallust run "$img"
      plasma-apply-colorscheme Wallust 2>/dev/null || true
      echo "Boje primenjene. Otvori novi Ghostty/Yazi prozor za boje terminala."
    '')
  ];

  # wallust config i sabloni — wallust cita ovo iz nix store-a (read-only je OK)
  xdg.configFile."wallust/wallust.toml".text = ''
    # wallust config — ne edituj rucno, managed by home-manager
    backend = "resized"
    color_space = "lch"
    palette = "dark16"
    check_contrast = true

    [templates]
    ghostty.template = "ghostty-colors"
    ghostty.target = "~/.cache/wallust/ghostty-colors"

    kde.template = "wallust.colors"
    kde.target = "~/.local/share/color-schemes/Wallust.colors"

    yazi.template = "yazi-flavor.toml"
    yazi.target = "~/.config/yazi/flavors/wallust.yazi/flavor.toml"

    gtk3.template = "gtk-colors.css"
    gtk3.target = "~/.config/gtk-3.0/gtk.css"

    gtk4.template = "gtk-colors.css"
    gtk4.target = "~/.config/gtk-4.0/gtk.css"

    btop.template = "btop.theme"
    btop.target = "~/.config/btop/themes/wallust.theme"
  '';

  # Ghostty sablon — background/foreground bez #, palette sa #
  xdg.configFile."wallust/templates/ghostty-colors".text = ''
    # wallust generisane boje — ne edituj rucno
    background = {{background | strip}}
    foreground = {{foreground | strip}}
    cursor-color = {{cursor | strip}}
    palette = 0={{color0}}
    palette = 1={{color1}}
    palette = 2={{color2}}
    palette = 3={{color3}}
    palette = 4={{color4}}
    palette = 5={{color5}}
    palette = 6={{color6}}
    palette = 7={{color7}}
    palette = 8={{color8}}
    palette = 9={{color9}}
    palette = 10={{color10}}
    palette = 11={{color11}}
    palette = 12={{color12}}
    palette = 13={{color13}}
    palette = 14={{color14}}
    palette = 15={{color15}}
  '';

  # KDE color scheme sablon — R,G,B format, wallust red/green/blue filteri
  xdg.configFile."wallust/templates/wallust.colors".text = ''
    [ColorEffects:Disabled]
    Color=56,56,56
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0.65
    ContrastEffect=1
    IntensityAmount=0.1
    IntensityEffect=0

    [ColorEffects:Inactive]
    ChangeSelectionColor=false
    Color=112,111,110
    ColorAmount=-0.9500000000000001
    ColorEffect=0
    ContrastAmount=0.1
    ContrastEffect=0
    Enable=true
    IntensityAmount=0
    IntensityEffect=0

    [Colors:Button]
    BackgroundAlternate={{background | red}},{{background | green}},{{background | blue}}
    BackgroundNormal={{color0 | red}},{{color0 | green}},{{color0 | blue}}
    DecorationFocus={{color1 | red}},{{color1 | green}},{{color1 | blue}}
    DecorationHover={{color2 | red}},{{color2 | green}},{{color2 | blue}}
    ForegroundActive={{color4 | red}},{{color4 | green}},{{color4 | blue}}
    ForegroundInactive={{color8 | red}},{{color8 | green}},{{color8 | blue}}
    ForegroundLink={{color6 | red}},{{color6 | green}},{{color6 | blue}}
    ForegroundNegative={{color9 | red}},{{color9 | green}},{{color9 | blue}}
    ForegroundNeutral={{color3 | red}},{{color3 | green}},{{color3 | blue}}
    ForegroundNormal={{foreground | red}},{{foreground | green}},{{foreground | blue}}
    ForegroundPositive={{color5 | red}},{{color5 | green}},{{color5 | blue}}
    ForegroundVisited={{color7 | red}},{{color7 | green}},{{color7 | blue}}

    [Colors:Complementary]
    BackgroundAlternate={{background | red}},{{background | green}},{{background | blue}}
    BackgroundNormal={{background | red}},{{background | green}},{{background | blue}}
    DecorationFocus={{color1 | red}},{{color1 | green}},{{color1 | blue}}
    DecorationHover={{color2 | red}},{{color2 | green}},{{color2 | blue}}

    [Colors:Selection]
    BackgroundAlternate={{color2 | red}},{{color2 | green}},{{color2 | blue}}
    BackgroundNormal={{color1 | red}},{{color1 | green}},{{color1 | blue}}
    DecorationFocus={{color1 | red}},{{color1 | green}},{{color1 | blue}}
    DecorationHover={{color2 | red}},{{color2 | green}},{{color2 | blue}}
    ForegroundActive={{foreground | red}},{{foreground | green}},{{foreground | blue}}
    ForegroundInactive={{foreground | red}},{{foreground | green}},{{foreground | blue}}
    ForegroundLink={{color3 | red}},{{color3 | green}},{{color3 | blue}}
    ForegroundNegative={{color9 | red}},{{color9 | green}},{{color9 | blue}}
    ForegroundNeutral={{color5 | red}},{{color5 | green}},{{color5 | blue}}
    ForegroundNormal={{foreground | red}},{{foreground | green}},{{foreground | blue}}
    ForegroundPositive={{color6 | red}},{{color6 | green}},{{color6 | blue}}
    ForegroundVisited={{color7 | red}},{{color7 | green}},{{color7 | blue}}

    [Colors:Tooltip]
    BackgroundAlternate={{color0 | red}},{{color0 | green}},{{color0 | blue}}
    BackgroundNormal={{color0 | red}},{{color0 | green}},{{color0 | blue}}
    DecorationFocus={{color1 | red}},{{color1 | green}},{{color1 | blue}}
    DecorationHover={{color2 | red}},{{color2 | green}},{{color2 | blue}}
    ForegroundActive={{color4 | red}},{{color4 | green}},{{color4 | blue}}
    ForegroundInactive={{color8 | red}},{{color8 | green}},{{color8 | blue}}
    ForegroundLink={{color6 | red}},{{color6 | green}},{{color6 | blue}}
    ForegroundNegative={{color9 | red}},{{color9 | green}},{{color9 | blue}}
    ForegroundNeutral={{color3 | red}},{{color3 | green}},{{color3 | blue}}
    ForegroundNormal={{foreground | red}},{{foreground | green}},{{foreground | blue}}
    ForegroundPositive={{color5 | red}},{{color5 | green}},{{color5 | blue}}
    ForegroundVisited={{color7 | red}},{{color7 | green}},{{color7 | blue}}

    [Colors:View]
    BackgroundAlternate={{background | red}},{{background | green}},{{background | blue}}
    BackgroundNormal={{background | red}},{{background | green}},{{background | blue}}
    DecorationFocus={{color1 | red}},{{color1 | green}},{{color1 | blue}}
    DecorationHover={{color2 | red}},{{color2 | green}},{{color2 | blue}}
    ForegroundActive={{color4 | red}},{{color4 | green}},{{color4 | blue}}
    ForegroundInactive={{color8 | red}},{{color8 | green}},{{color8 | blue}}
    ForegroundLink={{color6 | red}},{{color6 | green}},{{color6 | blue}}
    ForegroundNegative={{color9 | red}},{{color9 | green}},{{color9 | blue}}
    ForegroundNeutral={{color3 | red}},{{color3 | green}},{{color3 | blue}}
    ForegroundNormal={{foreground | red}},{{foreground | green}},{{foreground | blue}}
    ForegroundPositive={{color5 | red}},{{color5 | green}},{{color5 | blue}}
    ForegroundVisited={{color7 | red}},{{color7 | green}},{{color7 | blue}}

    [Colors:Window]
    BackgroundAlternate={{background | red}},{{background | green}},{{background | blue}}
    BackgroundNormal={{background | red}},{{background | green}},{{background | blue}},200
    DecorationFocus={{color1 | red}},{{color1 | green}},{{color1 | blue}}
    DecorationHover={{color2 | red}},{{color2 | green}},{{color2 | blue}}
    ForegroundActive={{color4 | red}},{{color4 | green}},{{color4 | blue}}
    ForegroundInactive={{color8 | red}},{{color8 | green}},{{color8 | blue}}
    ForegroundLink={{color6 | red}},{{color6 | green}},{{color6 | blue}}
    ForegroundNegative={{color9 | red}},{{color9 | green}},{{color9 | blue}}
    ForegroundNeutral={{color3 | red}},{{color3 | green}},{{color3 | blue}}
    ForegroundNormal={{foreground | red}},{{foreground | green}},{{foreground | blue}}
    ForegroundPositive={{color5 | red}},{{color5 | green}},{{color5 | blue}}
    ForegroundVisited={{color7 | red}},{{color7 | green}},{{color7 | blue}}

    [General]
    ColorScheme=Wallust
    Name=Wallust
    shadeSortColumn=true

    [KDE]
    contrast=4

    [WM]
    activeBackground={{color1 | red}},{{color1 | green}},{{color1 | blue}}
    activeBlend={{color1 | red}},{{color1 | green}},{{color1 | blue}}
    activeForeground={{foreground | red}},{{foreground | green}},{{foreground | blue}}
    inactiveBackground={{background | red}},{{background | green}},{{background | blue}}
    inactiveBlend={{background | red}},{{background | green}},{{background | blue}}
    inactiveForeground={{color8 | red}},{{color8 | green}},{{color8 | blue}}
  '';

  # Yazi wallust flavor sablon — ista struktura kao berserk, wallust boje
  xdg.configFile."wallust/templates/yazi-flavor.toml".text = ''
    [mgr]
    cwd = { fg = "{{color1}}" }
    hovered         = { fg = "{{foreground}}", bg = "{{color0}}" }
    preview_hovered = { underline = true }
    find_keyword  = { fg = "{{color1}}", bold = true, italic = true, underline = true }
    find_position = { fg = "{{foreground}}", bg = "{{color0}}", bold = true }
    marker_copied   = { fg = "{{color2}}", bg = "{{color2}}" }
    marker_cut      = { fg = "{{color9}}", bg = "{{color9}}" }
    marker_marked   = { fg = "{{color1}}", bg = "{{color1}}" }
    marker_selected = { fg = "{{color5}}", bg = "{{color5}}" }
    tab_active   = { fg = "{{foreground}}", bg = "{{color2}}" }
    tab_inactive = { fg = "{{color8}}", bg = "{{color0}}" }
    tab_width    = 1
    count_copied   = { fg = "{{background}}", bg = "{{color2}}" }
    count_cut      = { fg = "{{background}}", bg = "{{color9}}" }
    count_selected = { fg = "{{background}}", bg = "{{color1}}" }
    border_symbol = "│"
    border_style  = { fg = "{{color8}}" }
    syntect_theme = "./tmtheme.xml"
    cursor_symbol = "█"
    cursor = { fg = "{{background}}", bg = "{{color1}}" }
    exe_symbol = ""
    exe = { fg = "{{color1}}", bg = "{{background}}" }
    file_symbol = ""
    file = { }
    folder_symbol = ""
    folder = { fg = "{{color2}}", bg = "{{background}}" }
    hidden_symbol = ""
    hidden = { fg = "{{color8}}" }
    link_symbol = ""
    link = { fg = "{{color1}}", bg = "{{background}}" }
    broken_symbol = ""
    broken = { fg = "{{color9}}", bg = "{{background}}" }
    selected = { fg = "{{foreground}}", bg = "{{color0}}" }

    [status]
    separator_open  = ""
    separator_close = ""
    separator_style = { fg = "{{color0}}", bg = "{{color0}}" }
    mode_normal = { fg = "{{background}}", bg = "{{color1}}", bold = true }
    mode_select = { fg = "{{background}}", bg = "{{color3}}", bold = true }
    mode_unset  = { fg = "{{background}}", bg = "{{color9}}", bold = true }
    progress_label  = { bold = true }
    progress_normal = { fg = "{{color1}}", bg = "{{background}}" }
    progress_error  = { fg = "{{color9}}", bg = "{{background}}" }
    permissions_t = { fg = "{{color8}}" }
    permissions_r = { fg = "{{color3}}" }
    permissions_w = { fg = "{{color1}}" }
    permissions_x = { fg = "{{color2}}" }
    permissions_s = { fg = "{{color8}}" }

    [select]
    border   = { fg = "{{color1}}" }
    active   = { fg = "{{color1}}", bold = true }
    inactive = {}

    [input]
    border   = { fg = "{{color1}}" }
    title    = {}
    value    = {}
    selected = { reversed = true }

    [completion]
    border   = { fg = "{{color1}}" }
    active   = { fg = "{{foreground}}", bg = "{{color2}}" }
    inactive = {}
    icon_file    = ""
    icon_folder  = ""
    icon_command = ""

    [tasks]
    border  = { fg = "{{color1}}" }
    title   = {}
    hovered = { underline = true }

    [which]
    mask            = { bg = "{{background}}" }
    cand            = { fg = "{{color1}}" }
    rest            = { fg = "{{color8}}" }
    desc            = { fg = "{{foreground}}" }
    separator       = "  "
    separator_style = { fg = "{{color8}}" }

    [help]
    on      = { fg = "{{color1}}" }
    run     = { fg = "{{color2}}" }
    desc    = { fg = "{{foreground}}" }
    hovered = { bg = "{{color0}}", bold = true }
    footer  = { fg = "{{foreground}}", bg = "{{color0}}" }

    [filetype]
    rules = [
        { url = "*", fg = "{{foreground}}" },
        { url = "*/", fg = "{{foreground}}" },
        { url = ".*", fg = "{{color8}}" },
    ]

    [icon]
    globs = []
    dirs  = []
    files = []
    exts  = []
    conds = [
        { if = "orphan", text = "", fg = "{{color9}}" },
        { if = "link",   text = "", fg = "{{color6}}" },
        { if = "dir",    text = "", fg = "{{color4}}" },
        { if = "exec",   text = "", fg = "{{color2}}" },
        { if = "!dir",   text = "", fg = "{{foreground}}" },
    ]
  '';

  # GTK sablon — libadwaita (GTK4) + legacy GTK3 imena boja, isti fajl za oba
  xdg.configFile."wallust/templates/gtk-colors.css".text = ''
    /* wallust GTK boje — ne edituj rucno */
    @define-color accent_color {{color4}};
    @define-color accent_bg_color {{color4}};
    @define-color accent_fg_color {{foreground}};
    @define-color window_bg_color {{background}};
    @define-color window_fg_color {{foreground}};
    @define-color view_bg_color {{background}};
    @define-color view_fg_color {{foreground}};
    @define-color headerbar_bg_color {{color0}};
    @define-color headerbar_fg_color {{foreground}};
    @define-color card_bg_color {{color0}};
    @define-color card_fg_color {{foreground}};
    @define-color dialog_bg_color {{color0}};
    @define-color dialog_fg_color {{foreground}};
    @define-color popover_bg_color {{color0}};
    @define-color popover_fg_color {{foreground}};
    @define-color sidebar_bg_color {{color0}};
    @define-color sidebar_fg_color {{foreground}};
    @define-color destructive_color {{color1}};
    @define-color success_color {{color2}};
    @define-color warning_color {{color3}};
    @define-color error_color {{color9}};
    /* GTK3 legacy imena */
    @define-color theme_bg_color {{background}};
    @define-color theme_fg_color {{foreground}};
    @define-color theme_base_color {{background}};
    @define-color theme_text_color {{foreground}};
    @define-color theme_selected_bg_color {{color4}};
    @define-color theme_selected_fg_color {{foreground}};
  '';

  # btop tema sablon — kompletna tema, gradijenti mapirani na paletu
  xdg.configFile."wallust/templates/btop.theme".text = ''
    # wallust btop tema — ne edituj rucno
    theme[main_bg]="{{background}}"
    theme[main_fg]="{{foreground}}"
    theme[title]="{{foreground}}"
    theme[hi_fg]="{{color4}}"
    theme[selected_bg]="{{color4}}"
    theme[selected_fg]="{{background}}"
    theme[inactive_fg]="{{color8}}"
    theme[graph_text]="{{color7}}"
    theme[meter_bg]="{{color0}}"
    theme[proc_misc]="{{color6}}"
    theme[cpu_box]="{{color8}}"
    theme[mem_box]="{{color8}}"
    theme[net_box]="{{color8}}"
    theme[proc_box]="{{color8}}"
    theme[div_line]="{{color8}}"
    theme[temp_start]="{{color2}}"
    theme[temp_mid]="{{color3}}"
    theme[temp_end]="{{color1}}"
    theme[cpu_start]="{{color2}}"
    theme[cpu_mid]="{{color6}}"
    theme[cpu_end]="{{color4}}"
    theme[free_start]="{{color2}}"
    theme[free_mid]=""
    theme[free_end]="{{color2}}"
    theme[cached_start]="{{color6}}"
    theme[cached_mid]=""
    theme[cached_end]="{{color6}}"
    theme[available_start]="{{color3}}"
    theme[available_mid]=""
    theme[available_end]="{{color3}}"
    theme[used_start]="{{color1}}"
    theme[used_mid]=""
    theme[used_end]="{{color1}}"
    theme[download_start]="{{color4}}"
    theme[download_mid]=""
    theme[download_end]="{{color4}}"
    theme[upload_start]="{{color5}}"
    theme[upload_mid]=""
    theme[upload_end]="{{color5}}"
    theme[process_start]="{{color2}}"
    theme[process_mid]="{{color3}}"
    theme[process_end]="{{color1}}"
  '';

  # btop cita temu "wallust" iz ~/.config/btop/themes/ koju wallust generise
  programs.btop = {
    enable = true;
    settings.color_theme = "wallust";
  };

  # fastfetch vec prati wallust: koristi ANSI imena boja koja terminal (wallust paleta) renderuje.
  # starship: sopstvena ANSI paleta da prati iste terminal boje — bez regeneracije po wallpaperu.
  # (starship.nix je zajednicki sa lizzywizzy; ovde samo za whitewolf menjamo aktivnu paletu)
  programs.starship.settings = {
    palette = lib.mkForce "wallust-ansi";
    palettes.wallust-ansi = {
      red = "red";
      bg = "black";
      fg = "white";
      gray = "bright-black";
      accent = "bright-red";
      yellow = "yellow";
    };
  };

  # bat: ugradjena "ansi" tema koristi 16 ANSI boja terminala (wallust) — bez bat cache build-a.
  home.sessionVariables.BAT_THEME = "ansi";

  # Build-time: generise paletu iz nix-konfigurisanog wallpapera pri svakom rebuild-u.
  # Zamenjuje raniji staticki berserk fallback — wallpaper je jedini izvor boja.
  home.activation."wallust-generate" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    _wp="${toString config.programs.plasma.workspace.wallpaper}"
    if [ -n "$_wp" ]; then
      _flavor_dir="$HOME/.config/yazi/flavors/wallust.yazi"
      _marker="$HOME/.cache/wallust/.built-from"
      ${pkgs.coreutils}/bin/mkdir -p "$_flavor_dir" "$HOME/.cache/wallust" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0" "$HOME/.config/btop/themes"
      # tmtheme.xml mora stajati uz flavor.toml u yazi flavor direktorijumu
      if [ ! -f "$_flavor_dir/tmtheme.xml" ]; then
        ${pkgs.coreutils}/bin/cp ${pkgs.yaziFlavors.vscode-dark-plus}/tmtheme.xml "$_flavor_dir/tmtheme.xml"
      fi
      # regenerisi samo ako se wallpaper promenio (izbegava spor resize na svakom switch-u)
      if [ "$(${pkgs.coreutils}/bin/cat "$_marker" 2>/dev/null || true)" != "$_wp" ]; then
        ${pkgs.wallust}/bin/wallust run "$_wp" && ${pkgs.coreutils}/bin/printf '%s' "$_wp" > "$_marker"
      fi
    fi
  '';

  # Watcher: kad se KDE wallpaper promeni kroz sam Plasma UI (a ne preko set-wallpaper-mood),
  # regenerise paletu. Fragilno po prirodi: Plasma cesto prepisuje ovaj config i iz drugih
  # razloga, pa debounce + marker preskacu nepotrebne regene. Uzima poslednji Image= (jedan monitor),
  # slideshow (direktorijum) preskace.
  systemd.user.services.wallust-wallpaper-watch = {
    Unit = {
      Description = "Regenerise wallust palette on KDE wallpaper change";
      After = [ "plasma-plasmashell.service" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Restart = "on-failure";
      RestartSec = 5;
      ExecStart = "${pkgs.writeShellScript "wallust-wallpaper-watch" ''
        CFG="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
        MARK="$HOME/.cache/wallust/.watched-wp"
        DIR="$(${pkgs.coreutils}/bin/dirname "$CFG")"
        BASE="$(${pkgs.coreutils}/bin/basename "$CFG")"

        apply() {
          img=$(${pkgs.gnugrep}/bin/grep -aE '^Image=' "$CFG" 2>/dev/null | ${pkgs.coreutils}/bin/tail -n1 | ${pkgs.gnused}/bin/sed 's/^Image=//; s#^file://##')
          [ -z "$img" ] && return 0
          [ -d "$img" ] && return 0
          [ ! -f "$img" ] && return 0
          [ "$(${pkgs.coreutils}/bin/cat "$MARK" 2>/dev/null || true)" = "$img" ] && return 0
          ${pkgs.wallust}/bin/wallust run "$img" && ${pkgs.coreutils}/bin/printf '%s' "$img" > "$MARK"
          ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme Wallust 2>/dev/null || true
        }

        ${pkgs.coreutils}/bin/mkdir -p "$HOME/.cache/wallust"
        apply
        ${pkgs.inotify-tools}/bin/inotifywait -m -e close_write -e moved_to "$DIR" 2>/dev/null | while read -r _d _e _f; do
          case "$_f" in
            "$BASE"*) ${pkgs.coreutils}/bin/sleep 2; apply ;;
          esac
        done
      ''}";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
