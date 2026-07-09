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

  nodes.Stardew.interfaces.lan = {
    network = "home";
    physicalConnections = [
      {
        node = "router";
        interface = "lan";
      }
    ];
  };
  nodes.SolidSnake.interfaces.lan = {
    network = "home";
    physicalConnections = [
      {
        node = "router";
        interface = "lan";
      }
    ];
  };
  nodes.Evangelion.interfaces.lan = {
    network = "home";
    physicalConnections = [
      {
        node = "router";
        interface = "lan";
      }
    ];
  };
}
