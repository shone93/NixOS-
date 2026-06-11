{ pkgs, ... }:

{
  # ─────────────────────────────────────────────
  # Steam
  # ─────────────────────────────────────────────
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Strimovanje igara sa drugog kompa
    dedicatedServer.openFirewall = true; # Lokalni serveri
    gamescopeSession.enable = true; # Valve-ov micro compositor
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # GameMode - boost performansi tokom igranja
  programs.gamemode.enable = true;

  # ─────────────────────────────────────────────
  # Gaming aplikacije
  # ─────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    heroic # Pokretač za Epic Games i GOG
    lutris # Menadžer za igre i emulatore
    mangohud # FPS, temperatura, overlay
    protonup-qt # GUI za Proton verzije
    vesktop # Discord optimizovan za Linux
    winetricks # Wine pomoćni alat
  ];

  environment.sessionVariables = {
    STEAM_DISABLE_BROWSER_HARDWARE_ACCELERATION = "1";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
  };
}
