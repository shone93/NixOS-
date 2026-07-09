{ ... }:

{
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  services.power-profiles-daemon.enable = false; # Konflikt sa auto-cpufreq

  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  # WiFi powersave isključen (stabilnija veza)
  networking.networkmanager.wifi.powersave = false;
}
