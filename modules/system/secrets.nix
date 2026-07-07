{ inputs, lib, ... }:

{
  # ─────────────────────────────────────────────
  # sops-nix - upravljanje tajnama (secrets)
  # Uvozi se na SVIM hostovima preko commonModules.
  #
  # Ključevi (age):
  #   - Host ključ se izvodi iz SSH host ključa (ssh-to-age) ili se
  #     stavi u /var/lib/sops-nix/key.txt.
  #   - User ključ: `age-keygen -o ~/.config/sops/age/keys.txt`.
  # Recipient-e (javne ključeve) upiši u .sops.yaml (REPLACE markeri).
  # ─────────────────────────────────────────────
  imports = [ inputs.sops-nix.nixosModules.sops ];

  # Aktiviraj sops tek KAD postoji šifrovani secrets.yaml.
  # Tako `nix flake check` prolazi i pre nego što napraviš prave ključeve.
  config = lib.mkIf (builtins.pathExists ../../secrets.yaml) {
    sops.defaultSopsFile = ../../secrets.yaml;

    # Host age ključ. Podrazumevano sops-nix može da izvede ključ iz
    # SSH host ključa; ovde koristimo eksplicitan fajl (napravi ga na hostu).
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";

    # ── PROOF OF LIFE: jedan secret ──
    # Deklariše se ali se (još) ne koristi nigde. Dekriptuje se u
    # /run/secrets/example_secret na aktivaciji.
    sops.secrets.example_secret = { };

    # Da dodaš još tajni, kopiraj šablon:
    #   sops.secrets."syncthing/whitewolf_key" = { owner = "whitewolf"; };
    # pa je referenciraj preko config.sops.secrets."...".path.
  };
}
