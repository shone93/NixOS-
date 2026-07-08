{ pkgs, ... }:

{
  # ─────────────────────────────────────────────
  # Radni Mac — konzervativan nix-darwin config.
  # POSEBAN track: NE ide kroz mkHost (mkHost pretpostavlja NixOS stvari:
  # hardware-configuration.nix, disko). NE koristi impermanence/disko/
  # nixos-anywhere — to je NixOS/Linux specificno.
  #
  # Homebrew je NAMERNO iskljucen (default je false) dok korisnik ne potvrdi
  # da IT ne upravlja Homebrew-om preko MDM-a. Bez system.defaults.* izmena
  # bez eksplicitne saglasnosti po podesavanju.
  # ─────────────────────────────────────────────

  system.stateVersion = 5;
  system.primaryUser = "whitewolf";

  users.users.whitewolf.home = "/Users/whitewolf";

  environment.systemPackages = with pkgs; [
    git
    gh
  ];
}
