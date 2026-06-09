{ ... }:

{
  # Verzija Home Manager stanja (mora pratiti sistemsku verziju)
  home.stateVersion = "26.05";

  # ─────────────────────────────────────────────
  # Podrazumevani browser
  # ─────────────────────────────────────────────
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "text/html" = "zen.desktop";
      "application/xhtml+xml" = "zen.desktop";
      "text/plain" = "dev.zed.Zed.desktop";
    };
  };

  # ─────────────────────────────────────────────
  # Terminal
  # ─────────────────────────────────────────────
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 12;
      background-opacity = 0.85;
    };
  };
}
