{ ... }:

{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # Potrebno za igre i Wine/Proton
    pulse.enable = true;
  };
}
