{ ... }:

{
  # Scaffold — nema real hardware-configuration.nix; pokreni nixos-generate-config posle instalacije.

  networking.hostName = "SolidSnake";

  # ne menjaj bez migracije
  system.stateVersion = "26.05";
}
