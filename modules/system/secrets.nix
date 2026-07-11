{ inputs, lib, config, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  config = lib.mkIf (builtins.pathExists ../../secrets.yaml) {
    sops.defaultSopsFile = ../../secrets.yaml;

    sops.age.keyFile = "/var/lib/sops-nix/key.txt";

    sops.secrets.example_secret = { };

    # neededForUsers: tajna mora biti dekriptovana PRE kreiranja korisnika (hashedPasswordFile).
    sops.secrets.whitewolf-password.neededForUsers = true;
    # lizzywizzy postoji samo na Stardew/SolidSnake — ne definisi tajnu na hostu bez nje.
    sops.secrets.lizzywizzy-password = lib.mkIf (config.users.users ? lizzywizzy) {
      neededForUsers = true;
    };
  };
}
