{ ... }:

{
  # ─────────────────────────────────────────────
  # Lizzy Wizzy - običan korisnik (bez 'wheel', nije admin).
  # Uvozi se samo na hostovima gde postoji (Stardew, SolidSnake).
  # ─────────────────────────────────────────────
  users.users.lizzywizzy = {
    isNormalUser = true;
    description = "Lizzy Wizzy";
    extraGroups = [ "networkmanager" ]; # bez wheel - nije admin
  };
}
