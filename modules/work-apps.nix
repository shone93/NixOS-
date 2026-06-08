{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    blender      # 3D modelovanje i animacija
    gimp         # Uređivanje i editovanje slika (Photoshop alternativa)
    inkscape     # Vektorska grafika i dizajn (Illustrator alternativa)
  ];
}
