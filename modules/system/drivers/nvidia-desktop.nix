{ config, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable; # Pascal radi sa stable
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false; # Pascal - vlasnički drajver je stabilniji
    nvidiaSettings = true;
  };
}
