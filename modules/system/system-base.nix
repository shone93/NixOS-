{ ... }:

{
  # ─────────────────────────────────────────────
  # Osnovna sistemska podešavanja (uvek uključeno, svi hostovi)
  # Spaja: audio, network, locale, performance
  # ─────────────────────────────────────────────

  # ---------- Audio (Pipewire) ----------
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # Potrebno za igre i Wine/Proton
    pulse.enable = true;
  };

  # ---------- Mreža ----------
  networking.networkmanager.enable = true;
  # Napomena: networking.hostName se postavlja u hosts/<ime>/configuration.nix

  # ---------- Lokalizacija ----------
  time.timeZone = "Europe/Belgrade";
  i18n.defaultLocale = "en_US.UTF-8";

  # ---------- Performanse ----------
  # Zram - komprimovani swap u RAM-u
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
  };

  # Pametno ubijanje procesa pre zamrzavanja sistema
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableUserSlices = true;
  };

  services.journald.extraConfig = ''
    SystemMaxUse=200M
    MaxRetentionSec=1week
  '';

  services.fstrim.enable = true; # Održava SSD brzinu
}
