{ ... }:

{
  # ─────────────────────────────────────────────
  # WhiteWolf - primarni admin korisnik (sudo preko 'wheel').
  # Uvozi se na SVIM hostovima.
  # ─────────────────────────────────────────────
  users.users.whitewolf = {
    isNormalUser = true;
    description = "WhiteWolf";
    extraGroups = [
      "networkmanager"
      "wheel" # 'wheel' omogućava sudo komande
    ];
  };
  users.groups.whitewolf = { };
}
