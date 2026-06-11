{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;

  # Tiho podizanje sistema
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
    "8250.nr_uarts=0" # Isključuje legacy serial portove (brži boot)
  ];
}
