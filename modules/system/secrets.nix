{ inputs, lib, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  config = lib.mkIf (builtins.pathExists ../../secrets.yaml) {
    sops.defaultSopsFile = ../../secrets.yaml;

    sops.age.keyFile = "/var/lib/sops-nix/key.txt";

    sops.secrets.example_secret = { };
  };
}
