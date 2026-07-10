{ config, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable; # RTX 3080 Mobile (Ampere)
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false; # konzistentno sa Stardew — stabilnost umesto eksperimentisanja

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # Dodaje `nvidia-offload` komandu
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
