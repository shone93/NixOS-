{ pkgs, lib, ... }:

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
  '';

  # Zasejava wallust yazi flavor berserk sadrzajem ako jos ne postoji — wallust ce ga potom prepisati
  home.activation."seed-wallust-yazi-flavor" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    _flavor_dir="$HOME/.config/yazi/flavors/wallust.yazi"
    _flavor_file="$_flavor_dir/flavor.toml"
    if [ ! -f "$_flavor_file" ]; then
      ${pkgs.coreutils}/bin/mkdir -p "$_flavor_dir"
      ${pkgs.coreutils}/bin/cat > "$_flavor_file" << 'BERSERK_EOF'
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
    { url = "*", fg = "#fefefe" },
    { url = "*/", fg = "#fefefe" },
    { url = ".*", fg = "#7a7a7e" },
]
BERSERK_EOF
      # tmtheme.xml je neophodan uz flavor.toml u yazi flavor direktorijumu
      ${pkgs.coreutils}/bin/cp ${pkgs.yaziFlavors.vscode-dark-plus}/tmtheme.xml "$_flavor_dir/tmtheme.xml"
    fi
  '';
}
