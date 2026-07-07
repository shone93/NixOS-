{ ... }:

{
  # ─────────────────────────────────────────────
  # PLACEHOLDER GPU DRAJVER - Evangelion
  # ⚠️  OVO NIJE VERIFIKOVAN DRAJVER! ⚠️
  # Evangelion je nov laptop; pravi GPU (NVIDIA/AMD/Intel), paket i
  # PRIME BusID-ovi se NE ZNAJU dok se hardver ne instalira.
  #
  # Kad se hardver sazna:
  #   1. Pokreni `nixos-generate-config` i `lspci | grep -E "VGA|3D"`.
  #   2. Zameni ovaj fajl pravim drajver modulom (vidi
  #      modules/system/drivers/nvidia-laptop.nix kao primer) sa
  #      ISPRAVNIM intelBusId/nvidiaBusId i nvidiaPackages verzijom.
  #
  # Do tada: samo generička grafika, bez proprietary drajvera/PRIME,
  # tako da flake može da se evaluira bez pogrešnih BusID-ova.
  # ─────────────────────────────────────────────
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
