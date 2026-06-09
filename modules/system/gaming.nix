{ pkgs, ... }:

{
  # ─────────────────────────────────────────────
  # Grafički drajveri i OpenGL (neophodno za gaming)
  # ─────────────────────────────────────────────
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Potrebno za 32-bitne igre i Wine/Proton
  };

  # NVIDIA + Intel PRIME (Optimus) konfiguracija za Lenovo IdeaPad Y700
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false; # GTX 960M zahtijeva vlasnički drajver

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # Dodaje `nvidia-offload` komandu
      };
      # Provjeri svoje ID-jeve komandom: sudo lshw -c display
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # ─────────────────────────────────────────────
  # Steam
  # ─────────────────────────────────────────────
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Otvara portove ako strimuješ igre sa drugog kompa
    dedicatedServer.openFirewall = true; # Za lokalne servere
    extraCompatPackages = with pkgs; [
      proton-ge-bin # Proton-GE direktno bez protonup-qt
    ];
  };

  # Zaobilaznice za crash steamwebhelper-a na Waylandu s Optimus GPU-om
  environment.sessionVariables = {
    STEAM_DISABLE_BROWSER_HARDWARE_ACCELERATION = "1";
  };

  # ─────────────────────────────────────────────
  # Programi za gejming
  # ─────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    heroic # Pokretač za Epic Games i GOG
    lutris # Menadžer za igre i emulatore
    mangohud # FPS, temperatura i info overlay u igrama
    protonup-qt # GUI za upravljanje Proton verzijama
    vesktop # Discord klijent optimizovan za Linux
    winetricks
  ];
}
