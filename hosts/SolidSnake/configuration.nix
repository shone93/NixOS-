{ ... }:

{
  # Scaffold — nema real hardware-configuration.nix; pokreni nixos-generate-config posle instalacije.

  networking.hostName = "SolidSnake";

  # Impermanence: root se brise pri butu, /etc/shadow ne prezivi. Lozinke iskljucivo iz sops.
  users.mutableUsers = false;

  # ne menjaj bez migracije
  system.stateVersion = "26.05";
}
