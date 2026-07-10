{ inputs, ... }:

{
  # Arctis Sound Manager (SteelSeries Nova Pro Omni). Upstream flake modul
  # instalira paket, udev pravila (uaccess) i systemd korisnicke servise.
  imports = [ inputs.arctis-sound-manager.nixosModules.default ];

  # PipeWire je vec ukljucen u system-base.nix (modul asertuje pipewire.enable).
  services.arctis-sound-manager.enable = true;
}
