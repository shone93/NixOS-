{ pkgs, ... }:

{
  # ─────────────────────────────────────────────
  # Teške aplikacije - SAMO desktop (SolidSnake)
  # ─────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    blender # 3D modelovanje i animacija
    gimp # Editovanje slika (Photoshop alternativa)
    inkscape # Vektorska grafika (Illustrator alternativa)
    krita
    godot

  ];
}
