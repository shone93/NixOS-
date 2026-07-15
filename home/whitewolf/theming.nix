{
  pkgs,
  lib,
  config,
  ...
}:

let
  # matugen 4.0.0 image mode je pokvaren — kvantizer uvek vrati fallback boju
  # (#4285f4), pa svaki wallpaper daje istu paletu. Zato source boju vadimo
  # imagemagick-om (kvantizuj → biraj boju sa najviše chroma×učestalost; ako je
  # slika siva, uzmi dominantni ton) i damo je `matugen color hex` sa
  # --contrast 0.5 (gura on_surface ka beloj → čitljiviji UI tekst). Boju NE
  # blendujemo ka crvenoj: pozadine/surface ostaju neutralne (ne tople).
  matugenRun = pkgs.writeShellScript "matugen-run" ''
    set -eu
    img="$1"
    marker="$HOME/.cache/matugen/.forced-color"
    # Prioritet izvora boje: forsirana boja (mood-color marker) > auto-ekstrakcija.
    # Marker drzi npr. "#eb3131" kad auto-pick promasi mood (npr. plava iz Guts slike).
    if [ -s "$marker" ]; then
      src="$(${pkgs.coreutils}/bin/cat "$marker")"
    else
      src=$(${pkgs.imagemagick}/bin/magick "$img" -alpha off -resize 25% -colors 32 -depth 8 -format '%c' histogram:info: 2>/dev/null \
        | ${pkgs.gawk}/bin/gawk 'match($0,/\(([0-9]+),[[:space:]]*([0-9]+),[[:space:]]*([0-9]+)/,m){
            cnt=$1+0;r=m[1];g=m[2];b=m[3];
            mx=r;if(g>mx)mx=g;if(b>mx)mx=b; mn=r;if(g<mn)mn=g;if(b<mn)mn=b;
            sat=(mx==0)?0:(mx-mn)/mx; val=mx/255;
            if(val>0.10&&val<0.98){
              if(cnt>domcnt){domcnt=cnt;dr=r;dg=g;db=b}
              if(sat>0.15){score=(sat^1.5)*(cnt^0.5); if(score>best){best=score;br=r;bg=g;bb=b}}
            }
          }
          END{ if(best>0) printf("#%02x%02x%02x",br,bg,bb); else if(domcnt>0) printf("#%02x%02x%02x",dr,dg,db); else print "#808080" }')
    fi
    [ -z "$src" ] && exit 1
    ${pkgs.matugen}/bin/matugen color hex "$src" --contrast 0.5 -c "$HOME/.config/matugen/config.toml" >/dev/null 2>&1
  '';

  # KDE live-apply: plasma-apply preskače šemu istog imena, pa bounce kroz
  # BreezeDark forsira reload; obriši custom AccentColor da akcenat prati šemu;
  # ghostty je single-instance pa SIGUSR2 osvežava paletu u tekućem procesu.
  matugenApplyKde = pkgs.writeShellScript "matugen-apply-kde" ''
    ${pkgs.procps}/bin/pkill -USR2 ghostty 2>/dev/null || true
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file kdeglobals --group General --key AccentColor --delete 2>/dev/null || true
    ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme BreezeDark >/dev/null 2>&1 || true
    ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme Matugen >/dev/null 2>&1 || true
  '';
in
{
  home.packages = [
    pkgs.matugen
    pkgs.kdePackages.kdialog

    # set-wallpaper-mood: bira pozadinu, generiše paletu matugen-om, primenjuje KDE šemu
    (pkgs.writeShellScriptBin "set-wallpaper-mood" ''
      set -e
      # Upotreba: set-wallpaper-mood [slika] [#hex]
      #   bez slike -> kdialog; bez #hex -> auto-boja iz slike; sa #hex -> forsiraj boju.
      if [ $# -eq 0 ] || [ -z "$1" ]; then
        img=$(${pkgs.kdePackages.kdialog}/bin/kdialog --getopenfilename "$HOME/Documents/nixos-config/home/wallpapers" "Images (*.jpg *.jpeg *.png *.webp)" 2>/dev/null || true)
        [ -z "$img" ] && exit 0
      else
        img="$1"
      fi

      ${pkgs.coreutils}/bin/mkdir -p "$HOME/.cache/matugen"
      marker="$HOME/.cache/matugen/.forced-color"
      if [ "$#" -ge 2 ] && [ -n "$2" ]; then
        ${pkgs.coreutils}/bin/printf '%s' "$2" > "$marker" # forsiraj boju
      else
        ${pkgs.coreutils}/bin/rm -f "$marker" # nova pozadina => auto-boja
      fi

      img=$(realpath "$img")
      plasma-apply-wallpaperimage "$img"
      ${matugenRun} "$img"
      ${matugenApplyKde}
      echo "Boje primenjene. Ghostty se osvežava automatski; za Yazi otvori novi prozor."
    '')

    # mood-color: forsiraj/oslobodi boju teme za TRENUTNU pozadinu (kad auto-pick promasi mood).
    (pkgs.writeShellScriptBin "mood-color" ''
      set -e
      marker="$HOME/.cache/matugen/.forced-color"
      cfg="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
      ${pkgs.coreutils}/bin/mkdir -p "$HOME/.cache/matugen"
      case "''${1:-}" in
        "" | -h | --help)
          echo "Upotreba:"
          echo "  mood-color '#eb3131'   forsiraj boju teme (ostaje dok ne vratis auto)"
          echo "  mood-color auto        vrati auto-boju iz pozadine"
          exit 0
          ;;
        auto) ${pkgs.coreutils}/bin/rm -f "$marker" ;;
        *) ${pkgs.coreutils}/bin/printf '%s' "$1" > "$marker" ;;
      esac
      img=$(${pkgs.gnugrep}/bin/grep -aE '^Image=' "$cfg" 2>/dev/null | ${pkgs.coreutils}/bin/tail -n1 | ${pkgs.gnused}/bin/sed 's/^Image=//; s#^file://##')
      [ -z "$img" ] && {
        echo "Ne mogu da nadjem trenutnu pozadinu."
        exit 1
      }
      ${matugenRun} "$img"
      ${matugenApplyKde}
      echo "Tema regenerisana."
    '')
  ];

  # matugen config i šabloni — matugen čita ovo iz nix store-a (read-only je OK),
  # a piše u mutable output fajlove. matugen expanduje ~ u input/output putanjama.
  xdg.configFile."matugen/config.toml".text = ''
    # matugen config — ne edituj ručno, managed by home-manager
    [config]

    [templates.ghostty]
    input_path = '~/.config/matugen/templates/ghostty-colors'
    output_path = '~/.cache/matugen/ghostty-colors'

    [templates.kde]
    input_path = '~/.config/matugen/templates/matugen.colors'
    output_path = '~/.local/share/color-schemes/Matugen.colors'

    [templates.yazi]
    input_path = '~/.config/matugen/templates/yazi-flavor.toml'
    output_path = '~/.config/yazi/flavors/matugen.yazi/flavor.toml'

    [templates.gtk3]
    input_path = '~/.config/matugen/templates/gtk-colors.css'
    output_path = '~/.config/gtk-3.0/gtk.css'

    [templates.gtk4]
    input_path = '~/.config/matugen/templates/gtk-colors.css'
    output_path = '~/.config/gtk-4.0/gtk.css'

    [templates.btop]
    input_path = '~/.config/matugen/templates/btop.theme'
    output_path = '~/.config/btop/themes/matugen.theme'
  '';

  # Ghostty šablon — terminal 16 boja iz base16 (koloran preko `color hex`).
  # background/foreground bez #, palette sa #.
  xdg.configFile."matugen/templates/ghostty-colors".text = ''
    # matugen generisane boje — ne edituj ručno
    background = {{base16.base00.default.hex_stripped}}
    foreground = ffffff
    cursor-color = {{base16.base0d.default.hex_stripped}}
    palette = 0={{base16.base00.default.hex}}
    palette = 1={{base16.base08.default.hex}}
    palette = 2={{base16.base0b.default.hex}}
    palette = 3={{base16.base0a.default.hex}}
    palette = 4={{base16.base0d.default.hex}}
    palette = 5={{base16.base0e.default.hex}}
    palette = 6={{base16.base0c.default.hex}}
    palette = 7={{base16.base05.default.hex}}
    palette = 8={{base16.base03.default.hex}}
    palette = 9={{base16.base08.default.hex}}
    palette = 10={{base16.base0b.default.hex}}
    palette = 11={{base16.base0a.default.hex}}
    palette = 12={{base16.base0d.default.hex}}
    palette = 13={{base16.base0e.default.hex}}
    palette = 14={{base16.base0c.default.hex}}
    palette = 15={{base16.base07.default.hex}}
  '';

  # KDE color scheme šablon — Material role-ovi, R,G,B format.
  xdg.configFile."matugen/templates/matugen.colors".text = ''
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
    BackgroundAlternate={{base16.base02.default.red}},{{base16.base02.default.green}},{{base16.base02.default.blue}}
    BackgroundNormal={{base16.base03.default.red}},{{base16.base03.default.green}},{{base16.base03.default.blue}}
    DecorationFocus={{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}
    DecorationHover={{colors.secondary.default.red}},{{colors.secondary.default.green}},{{colors.secondary.default.blue}}
    ForegroundActive={{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}
    ForegroundInactive={{colors.on_surface_variant.default.red}},{{colors.on_surface_variant.default.green}},{{colors.on_surface_variant.default.blue}}
    ForegroundLink={{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}
    ForegroundNegative={{colors.error.default.red}},{{colors.error.default.green}},{{colors.error.default.blue}}
    ForegroundNeutral={{base16.base0a.default.red}},{{base16.base0a.default.green}},{{base16.base0a.default.blue}}
    ForegroundNormal={{colors.on_surface.default.red}},{{colors.on_surface.default.green}},{{colors.on_surface.default.blue}}
    ForegroundPositive={{base16.base0b.default.red}},{{base16.base0b.default.green}},{{base16.base0b.default.blue}}
    ForegroundVisited={{colors.tertiary.default.red}},{{colors.tertiary.default.green}},{{colors.tertiary.default.blue}}

    [Colors:Complementary]
    BackgroundAlternate={{base16.base02.default.red}},{{base16.base02.default.green}},{{base16.base02.default.blue}}
    BackgroundNormal={{base16.base01.default.red}},{{base16.base01.default.green}},{{base16.base01.default.blue}}
    DecorationFocus={{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}
    DecorationHover={{colors.secondary.default.red}},{{colors.secondary.default.green}},{{colors.secondary.default.blue}}
    ForegroundActive={{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}
    ForegroundInactive={{colors.on_surface_variant.default.red}},{{colors.on_surface_variant.default.green}},{{colors.on_surface_variant.default.blue}}
    ForegroundLink={{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}
    ForegroundNegative={{colors.error.default.red}},{{colors.error.default.green}},{{colors.error.default.blue}}
    ForegroundNeutral={{base16.base0a.default.red}},{{base16.base0a.default.green}},{{base16.base0a.default.blue}}
    ForegroundNormal={{colors.on_surface.default.red}},{{colors.on_surface.default.green}},{{colors.on_surface.default.blue}}
    ForegroundPositive={{base16.base0b.default.red}},{{base16.base0b.default.green}},{{base16.base0b.default.blue}}
    ForegroundVisited={{colors.tertiary.default.red}},{{colors.tertiary.default.green}},{{colors.tertiary.default.blue}}

    [Colors:Selection]
    BackgroundAlternate={{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}
    BackgroundNormal={{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}
    DecorationFocus={{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}
    DecorationHover={{colors.secondary.default.red}},{{colors.secondary.default.green}},{{colors.secondary.default.blue}}
    ForegroundActive={{colors.on_primary.default.red}},{{colors.on_primary.default.green}},{{colors.on_primary.default.blue}}
    ForegroundInactive={{colors.on_primary.default.red}},{{colors.on_primary.default.green}},{{colors.on_primary.default.blue}}
    ForegroundLink={{colors.on_primary.default.red}},{{colors.on_primary.default.green}},{{colors.on_primary.default.blue}}
    ForegroundNegative={{colors.error.default.red}},{{colors.error.default.green}},{{colors.error.default.blue}}
    ForegroundNeutral={{base16.base0a.default.red}},{{base16.base0a.default.green}},{{base16.base0a.default.blue}}
    ForegroundNormal={{colors.on_primary.default.red}},{{colors.on_primary.default.green}},{{colors.on_primary.default.blue}}
    ForegroundPositive={{base16.base0b.default.red}},{{base16.base0b.default.green}},{{base16.base0b.default.blue}}
    ForegroundVisited={{colors.on_primary.default.red}},{{colors.on_primary.default.green}},{{colors.on_primary.default.blue}}

    [Colors:Tooltip]
    BackgroundAlternate={{base16.base03.default.red}},{{base16.base03.default.green}},{{base16.base03.default.blue}}
    BackgroundNormal={{base16.base02.default.red}},{{base16.base02.default.green}},{{base16.base02.default.blue}}
    DecorationFocus={{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}
    DecorationHover={{colors.secondary.default.red}},{{colors.secondary.default.green}},{{colors.secondary.default.blue}}
    ForegroundActive={{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}
    ForegroundInactive={{colors.on_surface_variant.default.red}},{{colors.on_surface_variant.default.green}},{{colors.on_surface_variant.default.blue}}
    ForegroundLink={{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}
    ForegroundNegative={{colors.error.default.red}},{{colors.error.default.green}},{{colors.error.default.blue}}
    ForegroundNeutral={{base16.base0a.default.red}},{{base16.base0a.default.green}},{{base16.base0a.default.blue}}
    ForegroundNormal={{colors.on_surface.default.red}},{{colors.on_surface.default.green}},{{colors.on_surface.default.blue}}
    ForegroundPositive={{base16.base0b.default.red}},{{base16.base0b.default.green}},{{base16.base0b.default.blue}}
    ForegroundVisited={{colors.tertiary.default.red}},{{colors.tertiary.default.green}},{{colors.tertiary.default.blue}}

    [Colors:View]
    BackgroundAlternate={{base16.base02.default.red}},{{base16.base02.default.green}},{{base16.base02.default.blue}}
    BackgroundNormal={{base16.base01.default.red}},{{base16.base01.default.green}},{{base16.base01.default.blue}}
    DecorationFocus={{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}
    DecorationHover={{colors.secondary.default.red}},{{colors.secondary.default.green}},{{colors.secondary.default.blue}}
    ForegroundActive={{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}
    ForegroundInactive={{colors.on_surface_variant.default.red}},{{colors.on_surface_variant.default.green}},{{colors.on_surface_variant.default.blue}}
    ForegroundLink={{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}
    ForegroundNegative={{colors.error.default.red}},{{colors.error.default.green}},{{colors.error.default.blue}}
    ForegroundNeutral={{base16.base0a.default.red}},{{base16.base0a.default.green}},{{base16.base0a.default.blue}}
    ForegroundNormal={{colors.on_surface.default.red}},{{colors.on_surface.default.green}},{{colors.on_surface.default.blue}}
    ForegroundPositive={{base16.base0b.default.red}},{{base16.base0b.default.green}},{{base16.base0b.default.blue}}
    ForegroundVisited={{colors.tertiary.default.red}},{{colors.tertiary.default.green}},{{colors.tertiary.default.blue}}

    [Colors:Window]
    BackgroundAlternate={{base16.base02.default.red}},{{base16.base02.default.green}},{{base16.base02.default.blue}}
    BackgroundNormal={{base16.base01.default.red}},{{base16.base01.default.green}},{{base16.base01.default.blue}}
    DecorationFocus={{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}
    DecorationHover={{colors.secondary.default.red}},{{colors.secondary.default.green}},{{colors.secondary.default.blue}}
    ForegroundActive={{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}
    ForegroundInactive={{colors.on_surface_variant.default.red}},{{colors.on_surface_variant.default.green}},{{colors.on_surface_variant.default.blue}}
    ForegroundLink={{colors.primary.default.red}},{{colors.primary.default.green}},{{colors.primary.default.blue}}
    ForegroundNegative={{colors.error.default.red}},{{colors.error.default.green}},{{colors.error.default.blue}}
    ForegroundNeutral={{base16.base0a.default.red}},{{base16.base0a.default.green}},{{base16.base0a.default.blue}}
    ForegroundNormal={{colors.on_surface.default.red}},{{colors.on_surface.default.green}},{{colors.on_surface.default.blue}}
    ForegroundPositive={{base16.base0b.default.red}},{{base16.base0b.default.green}},{{base16.base0b.default.blue}}
    ForegroundVisited={{colors.tertiary.default.red}},{{colors.tertiary.default.green}},{{colors.tertiary.default.blue}}

    [General]
    ColorScheme=Matugen
    Name=Matugen
    shadeSortColumn=true

    [KDE]
    contrast=4

    [WM]
    activeBackground={{base16.base03.default.red}},{{base16.base03.default.green}},{{base16.base03.default.blue}}
    activeBlend={{base16.base03.default.red}},{{base16.base03.default.green}},{{base16.base03.default.blue}}
    activeForeground={{colors.on_surface.default.red}},{{colors.on_surface.default.green}},{{colors.on_surface.default.blue}}
    inactiveBackground={{base16.base01.default.red}},{{base16.base01.default.green}},{{base16.base01.default.blue}}
    inactiveBlend={{base16.base01.default.red}},{{base16.base01.default.green}},{{base16.base01.default.blue}}
    inactiveForeground={{colors.on_surface_variant.default.red}},{{colors.on_surface_variant.default.green}},{{colors.on_surface_variant.default.blue}}
  '';

  # Yazi matugen flavor šablon — ista struktura kao berserk, Material boje.
  xdg.configFile."matugen/templates/yazi-flavor.toml".text = ''
    [mgr]
    cwd = { fg = "{{colors.primary.default.hex}}" }
    hovered         = { fg = "{{colors.on_surface.default.hex}}", bg = "{{colors.surface_container.default.hex}}" }
    preview_hovered = { underline = true }
    find_keyword  = { fg = "{{colors.primary.default.hex}}", bold = true, italic = true, underline = true }
    find_position = { fg = "{{colors.on_surface.default.hex}}", bg = "{{colors.surface_container.default.hex}}", bold = true }
    marker_copied   = { fg = "{{colors.tertiary.default.hex}}", bg = "{{colors.tertiary.default.hex}}" }
    marker_cut      = { fg = "{{colors.error.default.hex}}", bg = "{{colors.error.default.hex}}" }
    marker_marked   = { fg = "{{colors.primary.default.hex}}", bg = "{{colors.primary.default.hex}}" }
    marker_selected = { fg = "{{colors.secondary.default.hex}}", bg = "{{colors.secondary.default.hex}}" }
    tab_active   = { fg = "{{colors.on_surface.default.hex}}", bg = "{{colors.tertiary.default.hex}}" }
    tab_inactive = { fg = "{{colors.on_surface_variant.default.hex}}", bg = "{{colors.surface_container.default.hex}}" }
    tab_width    = 1
    count_copied   = { fg = "{{colors.surface.default.hex}}", bg = "{{colors.tertiary.default.hex}}" }
    count_cut      = { fg = "{{colors.surface.default.hex}}", bg = "{{colors.error.default.hex}}" }
    count_selected = { fg = "{{colors.surface.default.hex}}", bg = "{{colors.primary.default.hex}}" }
    border_symbol = "│"
    border_style  = { fg = "{{colors.on_surface_variant.default.hex}}" }
    syntect_theme = "./tmtheme.xml"
    cursor_symbol = "█"
    cursor = { fg = "{{colors.surface.default.hex}}", bg = "{{colors.primary.default.hex}}" }
    exe_symbol = ""
    exe = { fg = "{{colors.primary.default.hex}}", bg = "{{colors.surface.default.hex}}" }
    file_symbol = ""
    file = { }
    folder_symbol = ""
    folder = { fg = "{{colors.tertiary.default.hex}}", bg = "{{colors.surface.default.hex}}" }
    hidden_symbol = ""
    hidden = { fg = "{{colors.on_surface_variant.default.hex}}" }
    link_symbol = ""
    link = { fg = "{{colors.primary.default.hex}}", bg = "{{colors.surface.default.hex}}" }
    broken_symbol = ""
    broken = { fg = "{{colors.error.default.hex}}", bg = "{{colors.surface.default.hex}}" }
    selected = { fg = "{{colors.on_surface.default.hex}}", bg = "{{colors.surface_container.default.hex}}" }

    [status]
    separator_open  = ""
    separator_close = ""
    separator_style = { fg = "{{colors.surface_container.default.hex}}", bg = "{{colors.surface_container.default.hex}}" }
    mode_normal = { fg = "{{colors.surface.default.hex}}", bg = "{{colors.primary.default.hex}}", bold = true }
    mode_select = { fg = "{{colors.surface.default.hex}}", bg = "{{base16.base0a.default.hex}}", bold = true }
    mode_unset  = { fg = "{{colors.surface.default.hex}}", bg = "{{colors.error.default.hex}}", bold = true }
    progress_label  = { bold = true }
    progress_normal = { fg = "{{colors.primary.default.hex}}", bg = "{{colors.surface.default.hex}}" }
    progress_error  = { fg = "{{colors.error.default.hex}}", bg = "{{colors.surface.default.hex}}" }
    permissions_t = { fg = "{{colors.on_surface_variant.default.hex}}" }
    permissions_r = { fg = "{{base16.base0a.default.hex}}" }
    permissions_w = { fg = "{{colors.primary.default.hex}}" }
    permissions_x = { fg = "{{colors.tertiary.default.hex}}" }
    permissions_s = { fg = "{{colors.on_surface_variant.default.hex}}" }

    [select]
    border   = { fg = "{{colors.primary.default.hex}}" }
    active   = { fg = "{{colors.primary.default.hex}}", bold = true }
    inactive = {}

    [input]
    border   = { fg = "{{colors.primary.default.hex}}" }
    title    = {}
    value    = {}
    selected = { reversed = true }

    [completion]
    border   = { fg = "{{colors.primary.default.hex}}" }
    active   = { fg = "{{colors.on_surface.default.hex}}", bg = "{{colors.tertiary.default.hex}}" }
    inactive = {}
    icon_file    = ""
    icon_folder  = ""
    icon_command = ""

    [tasks]
    border  = { fg = "{{colors.primary.default.hex}}" }
    title   = {}
    hovered = { underline = true }

    [which]
    mask            = { bg = "{{colors.surface.default.hex}}" }
    cand            = { fg = "{{colors.primary.default.hex}}" }
    rest            = { fg = "{{colors.on_surface_variant.default.hex}}" }
    desc            = { fg = "{{colors.on_surface.default.hex}}" }
    separator       = "  "
    separator_style = { fg = "{{colors.on_surface_variant.default.hex}}" }

    [help]
    on      = { fg = "{{colors.primary.default.hex}}" }
    run     = { fg = "{{colors.tertiary.default.hex}}" }
    desc    = { fg = "{{colors.on_surface.default.hex}}" }
    hovered = { bg = "{{colors.surface_container.default.hex}}", bold = true }
    footer  = { fg = "{{colors.on_surface.default.hex}}", bg = "{{colors.surface_container.default.hex}}" }

    [filetype]
    rules = [
        { url = "*", fg = "{{colors.on_surface.default.hex}}" },
        { url = "*/", fg = "{{colors.on_surface.default.hex}}" },
        { url = ".*", fg = "{{colors.on_surface_variant.default.hex}}" },
    ]

  ''
  + builtins.readFile (
    pkgs.runCommandLocal "yazi-icons-accent.toml" { } ''
      sed -E 's/fg = "#[0-9a-fA-F]{3,8}"/fg = "{{colors.primary.default.hex}}"/g' ${../common/yazi-icons.toml} > $out
    ''
  );

  # GTK šablon — libadwaita (GTK4) + legacy GTK3 imena boja, Material role-ovi.
  xdg.configFile."matugen/templates/gtk-colors.css".text = ''
    /* matugen GTK boje — ne edituj ručno */
    @define-color accent_color {{colors.primary.default.hex}};
    @define-color accent_bg_color {{colors.primary.default.hex}};
    @define-color accent_fg_color {{colors.on_primary.default.hex}};
    @define-color window_bg_color {{base16.base01.default.hex}};
    @define-color window_fg_color {{colors.on_surface.default.hex}};
    @define-color view_bg_color {{base16.base01.default.hex}};
    @define-color view_fg_color {{colors.on_surface.default.hex}};
    @define-color headerbar_bg_color {{base16.base02.default.hex}};
    @define-color headerbar_fg_color {{colors.on_surface.default.hex}};
    @define-color card_bg_color {{base16.base02.default.hex}};
    @define-color card_fg_color {{colors.on_surface.default.hex}};
    @define-color dialog_bg_color {{base16.base03.default.hex}};
    @define-color dialog_fg_color {{colors.on_surface.default.hex}};
    @define-color popover_bg_color {{base16.base02.default.hex}};
    @define-color popover_fg_color {{colors.on_surface.default.hex}};
    @define-color sidebar_bg_color {{base16.base01.default.hex}};
    @define-color sidebar_fg_color {{colors.on_surface.default.hex}};
    @define-color destructive_color {{colors.error.default.hex}};
    @define-color success_color {{base16.base0b.default.hex}};
    @define-color warning_color {{base16.base0a.default.hex}};
    @define-color error_color {{colors.error.default.hex}};
    /* GTK3 legacy imena */
    @define-color theme_bg_color {{base16.base01.default.hex}};
    @define-color theme_fg_color {{colors.on_surface.default.hex}};
    @define-color theme_base_color {{base16.base01.default.hex}};
    @define-color theme_text_color {{colors.on_surface.default.hex}};
    @define-color theme_selected_bg_color {{colors.primary.default.hex}};
    @define-color theme_selected_fg_color {{colors.on_primary.default.hex}};
  '';

  # btop tema šablon — Material role-ovi za chrome, base16 akcenti za gradijente.
  xdg.configFile."matugen/templates/btop.theme".text = ''
    # matugen btop tema — ne edituj ručno
    theme[main_bg]="{{base16.base01.default.hex}}"
    theme[main_fg]="{{colors.on_surface.default.hex}}"
    theme[title]="{{colors.on_surface.default.hex}}"
    theme[hi_fg]="{{colors.primary.default.hex}}"
    theme[selected_bg]="{{colors.primary.default.hex}}"
    theme[selected_fg]="{{colors.on_primary.default.hex}}"
    theme[inactive_fg]="{{colors.on_surface_variant.default.hex}}"
    theme[graph_text]="{{colors.on_surface_variant.default.hex}}"
    theme[meter_bg]="{{base16.base02.default.hex}}"
    theme[proc_misc]="{{colors.tertiary.default.hex}}"
    theme[cpu_box]="{{colors.outline.default.hex}}"
    theme[mem_box]="{{colors.outline.default.hex}}"
    theme[net_box]="{{colors.outline.default.hex}}"
    theme[proc_box]="{{colors.outline.default.hex}}"
    theme[div_line]="{{colors.outline_variant.default.hex}}"
    theme[temp_start]="{{base16.base0b.default.hex}}"
    theme[temp_mid]="{{base16.base0a.default.hex}}"
    theme[temp_end]="{{base16.base08.default.hex}}"
    theme[cpu_start]="{{base16.base0b.default.hex}}"
    theme[cpu_mid]="{{base16.base0d.default.hex}}"
    theme[cpu_end]="{{colors.primary.default.hex}}"
    theme[free_start]="{{base16.base0b.default.hex}}"
    theme[free_mid]=""
    theme[free_end]="{{base16.base0b.default.hex}}"
    theme[cached_start]="{{base16.base0c.default.hex}}"
    theme[cached_mid]=""
    theme[cached_end]="{{base16.base0c.default.hex}}"
    theme[available_start]="{{base16.base0a.default.hex}}"
    theme[available_mid]=""
    theme[available_end]="{{base16.base0a.default.hex}}"
    theme[used_start]="{{base16.base08.default.hex}}"
    theme[used_mid]=""
    theme[used_end]="{{base16.base08.default.hex}}"
    theme[download_start]="{{base16.base0d.default.hex}}"
    theme[download_mid]=""
    theme[download_end]="{{base16.base0d.default.hex}}"
    theme[upload_start]="{{base16.base0e.default.hex}}"
    theme[upload_mid]=""
    theme[upload_end]="{{base16.base0e.default.hex}}"
    theme[process_start]="{{base16.base0b.default.hex}}"
    theme[process_mid]="{{base16.base0a.default.hex}}"
    theme[process_end]="{{base16.base08.default.hex}}"
  '';

  # btop čita temu "matugen" iz ~/.config/btop/themes/ koju matugen generiše
  programs.btop = {
    enable = true;
    settings.color_theme = "matugen";
  };

  # fastfetch/starship/bat prate terminal ANSI paletu (koju matugen base16 puni preko ghostty).
  # starship: sopstvena ANSI paleta da prati iste terminal boje — bez regeneracije po wallpaperu.
  # (starship.nix je zajednički sa lizzywizzy; ovde samo za whitewolf menjamo aktivnu paletu)
  programs.starship.settings = {
    palette = lib.mkForce "matugen-ansi";
    palettes.matugen-ansi = {
      red = "red";
      bg = "black";
      fg = "white";
      gray = "bright-black";
      accent = "bright-red";
      yellow = "yellow";
    };
  };

  # bat: ugrađena "ansi" tema koristi 16 ANSI boja terminala (matugen) — bez bat cache build-a.
  home.sessionVariables.BAT_THEME = "ansi";

  # Build-time: generiše paletu iz nix-konfigurisanog wallpapera pri svakom rebuild-u.
  # Wallpaper je jedini izvor boja — nema statičkog fallback-a.
  home.activation."matugen-generate" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    _wp="${toString config.programs.plasma.workspace.wallpaper}"
    if [ -n "$_wp" ]; then
      _flavor_dir="$HOME/.config/yazi/flavors/matugen.yazi"
      _marker="$HOME/.cache/matugen/.built-from"
      ${pkgs.coreutils}/bin/mkdir -p "$_flavor_dir" "$HOME/.cache/matugen" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0" "$HOME/.config/btop/themes"
      # tmtheme.xml mora stajati uz flavor.toml u yazi flavor direktorijumu
      if [ ! -f "$_flavor_dir/tmtheme.xml" ]; then
        ${pkgs.coreutils}/bin/cp ${pkgs.yaziFlavors.vscode-dark-plus}/tmtheme.xml "$_flavor_dir/tmtheme.xml"
      fi
      # regeneriši samo ako se wallpaper promenio (izbegava spor resize na svakom switch-u)
      if [ "$(${pkgs.coreutils}/bin/cat "$_marker" 2>/dev/null || true)" != "$_wp" ]; then
        ${matugenRun} "$_wp" && ${pkgs.coreutils}/bin/printf '%s' "$_wp" > "$_marker"
      fi
    fi
  '';

  # Watcher: kad se KDE wallpaper promeni kroz sam Plasma UI (a ne preko set-wallpaper-mood),
  # regeneriše paletu. Fragilno po prirodi: Plasma često prepisuje ovaj config i iz drugih
  # razloga, pa debounce + marker preskaču nepotrebne regene. Uzima poslednji Image= (jedan monitor),
  # slideshow (direktorijum) preskače.
  systemd.user.services.matugen-wallpaper-watch = {
    Unit = {
      Description = "Regeneriše matugen paletu na promenu KDE wallpapera";
      After = [ "plasma-plasmashell.service" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Restart = "on-failure";
      RestartSec = 5;
      ExecStart = "${pkgs.writeShellScript "matugen-wallpaper-watch" ''
        CFG="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
        MARK="$HOME/.cache/matugen/.watched-wp"
        DIR="$(${pkgs.coreutils}/bin/dirname "$CFG")"
        BASE="$(${pkgs.coreutils}/bin/basename "$CFG")"

        apply() {
          img=$(${pkgs.gnugrep}/bin/grep -aE '^Image=' "$CFG" 2>/dev/null | ${pkgs.coreutils}/bin/tail -n1 | ${pkgs.gnused}/bin/sed 's/^Image=//; s#^file://##')
          [ -z "$img" ] && return 0
          [ -d "$img" ] && return 0
          [ ! -f "$img" ] && return 0
          [ "$(${pkgs.coreutils}/bin/cat "$MARK" 2>/dev/null || true)" = "$img" ] && return 0
          ${matugenRun} "$img" && ${pkgs.coreutils}/bin/printf '%s' "$img" > "$MARK"
          ${matugenApplyKde}
        }

        ${pkgs.coreutils}/bin/mkdir -p "$HOME/.cache/matugen"
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
