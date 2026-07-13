{ ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 12;
      background-opacity = 0.85;
      # matugen boje: generisu se na rebuild-u (iz wallpapera) i preko set-wallpaper-mood.
      # ? = opcioni include; ako fajl ne postoji, ghostty koristi svoj default.
      "config-file" = "?~/.cache/matugen/ghostty-colors";
    };
  };
}
