{ ... }:

{
  # ─────────────────────────────────────────────
  # Power management za laptop
  # ─────────────────────────────────────────────
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never"; # Isključuje turbo na bateriji
      };
      charger = {
        governor = "performance";
        turbo = "auto"; # Uključuje turbo na struju
      };
    };
  };

  # Isključuje bluetooth kada nije u upotrebi
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false; # Ne uključuje BT automatski
}
