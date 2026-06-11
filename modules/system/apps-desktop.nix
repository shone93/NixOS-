{ pkgs, ... }:

{
  # ─────────────────────────────────────────────
  # Teške aplikacije - SAMO desktop (SolidSnake)
  # Laptop bi se mučio sa ovima
  # ─────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    blender # 3D modelovanje i animacija
    gimp # Editovanje slika (Photoshop alternativa)
    inkscape # Vektorska grafika (Illustrator alternativa)
  ];
}
