# topology.nix
#
# Deklarativni opis kucne mreze za nix-topology. Cvorovi za Stardew,
# SolidSnake i Evangelion se auto-ekstraktuju iz nixosConfigurations
# (nix-topology.nixosModules.default je u commonModules); ovde dodajemo
# ruter i povezujemo hostove na LAN.
#
# Build: nix build .#topology.x86_64-linux.config.output
# Napomena: konekcije/interfejsi su best-effort — doteraj posle prvog builda.
{ config, lib, ... }:

{
  networks.home = {
    name = "Kucna LAN";
    cidrv4 = "192.168.1.0/24";
  };

  nodes.router = {
    deviceType = "router";
    hardware.info = "Kucni ruter / gateway";
    interfaces.lan = {
      network = "home";
      addresses = [ "192.168.1.1" ];
    };
  };

  # Povezi svaki host na ruter preko `lan` interfejsa.
  nodes.Stardew.interfaces.lan = {
    network = "home";
    physicalConnections = [ { node = "router"; interface = "lan"; } ];
  };
  nodes.SolidSnake.interfaces.lan = {
    network = "home";
    physicalConnections = [ { node = "router"; interface = "lan"; } ];
  };
  nodes.Evangelion.interfaces.lan = {
    network = "home";
    physicalConnections = [ { node = "router"; interface = "lan"; } ];
  };
}
