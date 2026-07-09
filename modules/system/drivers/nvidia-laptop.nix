{ config, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580; # GTX 960M (Maxwell)
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false; # Maxwell zahteva vlasnički drajver

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
