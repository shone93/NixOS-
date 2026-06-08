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

    # Zen Browser
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      NixOS = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; # Prosleđujemo eksterne alate u sistem
        modules = [
          ./configuration.nix

          # Integracija Home Manager-a direktno u NixOS build sistem
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.whitewolf = import ./home.nix;
          }
        ];
      };
    };
  };
}
