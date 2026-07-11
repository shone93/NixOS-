{ ... }:

{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  networking.networkmanager.enable = true;
  # Napomena: networking.hostName se postavlja u hosts/<ime>/configuration.nix

  time.timeZone = "Europe/Belgrade";
  i18n.defaultLocale = "en_US.UTF-8";

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
  };

  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableUserSlices = true;
  };

  services.journald.extraConfig = ''
    SystemMaxUse=200M
    MaxRetentionSec=1week
  '';

  services.fstrim.enable = true;

  # SSD/NVMe SMART monitoring — jeftino, hvata otkaz diska rano.
  services.smartd.enable = true;

  # Firmware update daemon (fwupdmgr).
  services.fwupd.enable = true;

  # Eksplicitno — podrazumevano je vec true, ali dokumentujemo nameru.
  networking.firewall.enable = true;

  # Registruje fish u /etc/shells da bi mogao biti login shell (ne namece ga nikome).
  programs.fish.enable = true;
}
