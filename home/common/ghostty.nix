{ ... }:

{
  programs.ghostty = {
    enable = true;
    themes.berserk = {
      palette = [
        "0=#1b1b1d"
        "1=#eb3131"
        "2=#c0392b"
        "3=#d4956a"
        "4=#7a7a7e"
        "5=#ab2e2e"
        "6=#a85751"
        "7=#fefefe"
        "8=#3d3d42"
        "9=#ff4949"
        "10=#e74c3c"
        "11=#e5b07b"
        "12=#9a9a9e"
        "13=#c0392b"
        "14=#cd6155"
        "15=#ffffff"
      ];
      background = "1b1b1d";
      foreground = "fefefe";
      cursor-color = "eb3131";
      selection-background = "eb3131";
      selection-foreground = "ffffff";
    };
    settings = {
      theme = "berserk";
      font-size = 12;
      background-opacity = 0.85;
      # wallust boje — prisutne samo ako je run set-wallpaper-mood bio pokrenut
      "config-file" = "?~/.cache/wallust/ghostty-colors";
    };
  };
}
