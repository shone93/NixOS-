{ ... }:

{
  imports = [
    ../common/ghostty.nix
  ];

  home.stateVersion = "26.05";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "text/html" = "zen-beta.desktop";
      "application/xhtml+xml" = "zen-beta.desktop";
      "text/plain" = "dev.zed.Zed.desktop";
    };
  };
}
