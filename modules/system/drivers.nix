{ ... }:

{
  # ─────────────────────────────────────────────
  # Grafički drajveri i OpenGL
  # ─────────────────────────────────────────────
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # NVIDIA + Intel PRIME (Optimus) za Lenovo IdeaPad Y700
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
