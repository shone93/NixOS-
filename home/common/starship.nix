{ ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      add_newline = true; # prazan red pre svakog prompta radi preglednosti

      palette = "berserk";
      palettes.berserk = {
        red = "#eb3131";
        bg = "#1b1b1d";
        fg = "#fefefe";
        gray = "#7a7a7e";
        accent = "#c0392b";
        yellow = "#e5c07b";
      };

      # dvolinijski prompt: masina + ceo put + git gore, kursor dole
      format = "$hostname$directory$git_branch$git_status$cmd_duration$status$line_break$character";

      hostname = {
        ssh_only = false; # prikazi ime masine i lokalno, ne samo preko SSH
        style = "bold gray";
        format = "[ $hostname]($style) ";
      };

      directory = {
        style = "bold red";
        truncation_length = 0; # 0 = prikazi ceo put
        truncate_to_repo = false; # ne skracuj na repo root
        read_only = " ";
        read_only_style = "yellow";
        format = "[ $path]($style)[$read_only]($read_only_style) ";
      };

      git_branch = {
        symbol = " ";
        style = "bold accent";
        format = "[$symbol$branch]($style) ";
      };

      git_status = {
        style = "yellow";
        format = "([$all_status$ahead_behind]($style) )";
      };

      cmd_duration = {
        min_time = 2000; # prikazi samo ako traje > 2s
        style = "gray";
        format = "[took $duration]($style) ";
      };

      status = {
        disabled = false; # prikaz exit koda kada je != 0
        style = "bold red";
        symbol = "✘ ";
        format = "[$symbol$status]($style) ";
      };

      character = {
        success_symbol = "[❯](bold red)";
        error_symbol = "[❯](bold accent)";
      };
    };
  };
}
