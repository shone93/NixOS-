{ inputs, pkgs, ... }:

{
  # Arctis Sound Manager (SteelSeries Nova Pro Omni). Upstream flake modul
  # instalira paket, udev pravila (uaccess) i systemd korisnicke servise.
  imports = [ inputs.arctis-sound-manager.nixosModules.default ];

  # PipeWire je vec ukljucen u system-base.nix (modul asertuje pipewire.enable).
  services.arctis-sound-manager.enable = true;

  # Lokalni stopgap patch: sig_stop pri gasenju vraca prethodni default sink
  # preko `pactl set-default-sink` (timeout=2), ali hvata samo FileNotFoundError.
  # Kad pactl visi tokom pipewire-pulse teardown-a, subprocess.TimeoutExpired
  # iskace nehvaceno i rusi GUI na izlazu. Prosirujemo except da cleanup ostane
  # best-effort. Ukloniti kad upstream (loteran/Arctis-Sound-Manager) primi fix —
  # tada ce --replace-fail glasno pasti pri buildu i podsetiti da se skine.
  services.arctis-sound-manager.package =
    inputs.arctis-sound-manager.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
      (prev: {
        postPatch = (prev.postPatch or "") + ''
          substituteInPlace src/arctis_sound_manager/gui/systray_app.py \
            --replace-fail \
              '            except FileNotFoundError:' \
              '            except (FileNotFoundError, subprocess.TimeoutExpired):'
        '';
      });
}
