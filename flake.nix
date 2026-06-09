{
  description = "Moja NixOS konfiguracija";

  inputs = {
    # Koristimo unstable granu za najnovije verzije paketa
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Zvanični Home Manager za unstable granu
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    # Zen Browser
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
      ...
    }@inputs:
    {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/laptop/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.whitewolf = import ./home/whitewolf.nix;
              home-manager.users.lizzywizzy = import ./home/lizzywizzy.nix;
            }
          ];
        };
      };
    };
}
