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
      mkHost =
        {
          hostname,
          systemModules,
          whitewolfHome,
          lizzywizzyHome,
        }:
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
              home-manager.users.whitewolf = import whitewolfHome;
              home-manager.users.lizzywizzy = import lizzywizzyHome;
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
            ./modules/system/users.nix
            ./modules/system/gaming.nix
            ./modules/system/apps-common.nix
            ./modules/system/syncthing.nix
            ./modules/system/system-base.nix
            # Host-specifično:
            ./modules/system/power.nix # baterija - samo laptop
            ./modules/system/drivers/nvidia-laptop.nix
          ];
          whitewolfHome = ./home/whitewolf/Stardew.nix;
          lizzywizzyHome = ./home/lizzywizzy/Stardew.nix;
        };

        # ───────────── DESKTOP (GTX 1080, budući PC) ─────────────
        SolidSnake = mkHost {
          hostname = "SolidSnake";
          systemModules = [
            ./modules/system/core.nix
            ./modules/system/boot.nix
            ./modules/system/audio.nix
            ./modules/system/network.nix
            ./modules/system/locale.nix
            ./modules/system/kde.nix
            ./modules/system/users.nix
            ./modules/system/gaming.nix
            ./modules/system/apps-common.nix
            # Host-specifično:
            ./modules/system/apps-desktop.nix # blender, gimp, inkscape
            ./modules/system/drivers/nvidia-desktop.nix
          ];
          whitewolfHome = ./home/whitewolf/SolidSnake.nix;
          lizzywizzyHome = ./home/lizzywizzy/SolidSnake.nix;
        };
      };
    };
}
