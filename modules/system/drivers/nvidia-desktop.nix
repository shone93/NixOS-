{ config, ... }:

{
  # ─────────────────────────────────────────────
  # NVIDIA - desktop (SolidSnake)
  # GTX 1080 (Pascal) - bez PRIME jer nema Intel iGPU
  # ─────────────────────────────────────────────
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
    nvidiaSettings = true; # GUI alat za podešavanje
  };
}
