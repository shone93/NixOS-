{ ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      add_newline = false;

      palette = "berserk";
      palettes.berserk = {
        red = "#eb3131";
        bg = "#1b1b1d";
        fg = "#fefefe";
        gray = "#7a7a7e";
        accent = "#c0392b";
      };

      format = "$directory$git_branch$git_status$cmd_duration$status$character";

      directory = {
        style = "bold red";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      git_branch = {
        symbol = " ";
        style = "bold accent";
        format = "[$symbol$branch]($style) ";
      };

      git_status = {
        style = "gray";
        format = "([$all_status$ahead_behind]($style) )";
      };

      cmd_duration = {
        min_time = 2000; # prikazi samo ako traje > 2s
        style = "gray";
        format = "[ $duration]($style) ";
      };

      status = {
        disabled = false; # prikaz exit koda kada je != 0
        style = "bold red";
        format = "[$status]($style) ";
      };

      character = {
        success_symbol = "[❯](red)";
        error_symbol = "[❯](accent)";
      };
    };
  };
}
