{ ... }:

{
  # Scaffold — hardver nije poznat; host-specifična podesavanja idu ovde.

  networking.hostName = "Evangelion";

  # Impermanence: root se brise pri butu, /etc/shadow ne prezivi. Lozinke iskljucivo iz sops.
  users.mutableUsers = false;

  # ne menjaj bez migracije
  system.stateVersion = "26.05";
}
