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

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
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

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      commonModules = [
        ./modules/system/core.nix
        ./modules/system/boot.nix
        ./modules/system/kde.nix
        ./modules/system/users/whitewolf.nix
        ./modules/system/apps-common.nix
        ./modules/system/syncthing.nix
        ./modules/system/system-base.nix
        ./modules/system/secrets.nix
        # nix-topology ekstrakcija (inertna metadata za dijagram mreze).
        inputs.nix-topology.nixosModules.default
      ];

      mkHost =
        {
          hostname,
          systemModules,
          homeConfigs,
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
          systemModules = commonModules ++ [
            ./modules/system/users/lizzywizzy.nix
            ./modules/system/gaming.nix
            # Host-specifično:
            ./modules/system/power.nix # baterija - samo laptop
            ./modules/system/drivers/nvidia-laptop.nix
            # NAPOMENA: Stardew NAMERNO nema disko/impermanence/snapper —
            # jedina realna masina; reinstalacija je odluka za kasnije.
          ];
          homeConfigs = {
            whitewolf = ./home/whitewolf/Stardew.nix;
            lizzywizzy = ./home/lizzywizzy/Stardew.nix;
          };
        };

        # ───────────── DESKTOP (GTX 1080, budući PC) ─────────────
        SolidSnake = mkHost {
          hostname = "SolidSnake";
          systemModules = commonModules ++ [
            ./modules/system/users/lizzywizzy.nix
            ./modules/system/gaming.nix
            # Host-specifično:
            ./modules/system/apps-desktop.nix # blender, gimp, inkscape
            ./modules/system/drivers/nvidia-desktop.nix
            ./modules/system/disko/desktop-btrfs.nix
            ./modules/system/impermanence.nix
            ./modules/system/impermanence-lizzywizzy.nix
            ./modules/system/btrfs-snapshots.nix
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
          systemModules = commonModules ++ [
            ./modules/system/gaming.nix
            # Host-specifično:
            ./modules/system/power.nix # baterija - laptop
            ./modules/system/drivers/nvidia-placeholder.nix
            ./modules/system/disko/laptop-btrfs.nix
            ./modules/system/impermanence.nix
            ./modules/system/btrfs-snapshots.nix
          ];
          homeConfigs = {
            whitewolf = ./home/whitewolf/Evangelion.nix;
          };
        };
      };

      devShells.${system}.deploy = pkgs.mkShell {
        packages = [
          pkgs.terraform
          pkgs.nixos-anywhere
          pkgs.jq
        ];
        shellHook = ''
          echo "deploy shell — terraform + nixos-anywhere"
          echo "  cd deployment/ && terraform init && terraform plan"
          echo "  NE pokreci 'terraform apply' bez potvrde ciljne masine."
        '';
      };

      topology.${system} = import inputs.nix-topology {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ inputs.nix-topology.overlays.default ];
        };
        modules = [
          { inherit (self) nixosConfigurations; }
          ./topology.nix
        ];
      };

      # Scaffold: gradi se na realnom Mac-u; evaluira ali se ne deployuje ovde.
      darwinConfigurations."work-macbook" = inputs.nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/work-macbook/darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.whitewolf = import ./home/whitewolf/darwin.nix;
          }
        ];
      };

      formatter.${system} =
        let
          p = nixpkgs.legacyPackages.${system};
        in
        p.writeShellScriptBin "fmt" ''
          set -euo pipefail
          if [ "$#" -eq 0 ]; then set -- .; fi
          ${p.findutils}/bin/find "$@" -name '*.nix' -type f \
            -not -name 'hardware-configuration.nix' -print0 \
            | xargs -0 ${p.nixfmt-rfc-style}/bin/nixfmt
        '';
    };
}
