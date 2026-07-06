{
  description = "Moja NixOS konfiguracija";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi-plugins = {
      url = "github:lordkekz/nix-yazi-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi-flavors = {
      url = "github:aguirre-matteo/nix-yazi-flavors";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      plasma-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # Helper funkcija - smanjuje ponavljanje za svaki host.
      # Svaki host samo prosledi svoje ime, host-specifične module
      # i koje home fajlove dobija svaki korisnik na toj mašini.
      # mkHost: host se opisuje preko podataka (data-driven).
      # homeConfigs je attrset: korisničko-ime -> putanja do home fajla,
      # pa host može imati proizvoljan skup korisnika (npr. samo whitewolf).
      mkHost =
        {
          hostname,
          systemModules,
          homeConfigs,
        }:
        # TODO: darwin — kad se dodaju macOS hostovi, ovde granaj na
        # inputs.nix-darwin.lib.darwinSystem umesto nixpkgs.lib.nixosSystem.
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/${hostname}/configuration.nix
            ./hosts/${hostname}/hardware-configuration.nix
          ]
          ++ systemModules
          ++ [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.backupFileExtension = "hm-backup";
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules = [
                plasma-manager.homeModules.plasma-manager
              ];
              # Svaki korisnik iz homeConfigs dobija svoj home fajl.
              home-manager.users = builtins.mapAttrs (_user: path: import path) homeConfigs;
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        # ───────────── LAPTOP (Lenovo IdeaPad Y700) ─────────────
        Stardew = mkHost {
          hostname = "Stardew";
          systemModules = [
            ./modules/system/core.nix
            ./modules/system/boot.nix
            ./modules/system/kde.nix
            ./modules/system/users/whitewolf.nix
            ./modules/system/users/lizzywizzy.nix
            ./modules/system/gaming.nix
            ./modules/system/apps-common.nix
            ./modules/system/syncthing.nix
            ./modules/system/system-base.nix
            # Host-specifično:
            ./modules/system/power.nix # baterija - samo laptop
            ./modules/system/drivers/nvidia-laptop.nix
          ];
          homeConfigs = {
            whitewolf = ./home/whitewolf/Stardew.nix;
            lizzywizzy = ./home/lizzywizzy/Stardew.nix;
          };
        };

        # ───────────── DESKTOP (GTX 1080, budući PC) ─────────────
        SolidSnake = mkHost {
          hostname = "SolidSnake";
          systemModules = [
            ./modules/system/core.nix
            ./modules/system/boot.nix
            ./modules/system/kde.nix
            ./modules/system/users/whitewolf.nix
            ./modules/system/users/lizzywizzy.nix
            ./modules/system/gaming.nix
            ./modules/system/apps-common.nix
            ./modules/system/syncthing.nix
            ./modules/system/system-base.nix
            # Host-specifično:
            ./modules/system/apps-desktop.nix # blender, gimp, inkscape
            ./modules/system/drivers/nvidia-desktop.nix
          ];
          homeConfigs = {
            whitewolf = ./home/whitewolf/SolidSnake.nix;
            lizzywizzy = ./home/lizzywizzy/SolidSnake.nix;
          };
        };

        # ───────────── LAPTOP (Evangelion, novi glavni) ─────────────
        # Jedan korisnik: SAMO whitewolf. lizzywizzy se NE pravi ovde.
        Evangelion = mkHost {
          hostname = "Evangelion";
          systemModules = [
            ./modules/system/core.nix
            ./modules/system/boot.nix
            ./modules/system/kde.nix
            ./modules/system/users/whitewolf.nix
            ./modules/system/gaming.nix
            ./modules/system/apps-common.nix
            ./modules/system/syncthing.nix
            ./modules/system/system-base.nix
            # Host-specifično:
            ./modules/system/power.nix # baterija - laptop
            ./modules/system/drivers/nvidia-placeholder.nix
          ];
          homeConfigs = {
            whitewolf = ./home/whitewolf/Evangelion.nix;
          };
        };
      };
    };
}
