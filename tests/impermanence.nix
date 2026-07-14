# NixOS VM test: dokazuje wipe-on-boot (root @ se brise), da /persist prezive
# reboot, i da whitewolf lozinka prezivi wipe /etc/shadow (deklarativno ponovo
# upisana pri svakom butu). Koristi PRAVI layout (btrfs-luks-layout.nix) i PRAVI
# rollback servis (impermanence-rollback.nix), ne kopije.
#
# POKRETANJE: treba masina sa /dev/kvm (Stardew ga nema -> TCG, jako sporo):
#   nix build .#checks.x86_64-linux.impermanence-test -L
{
  inputs,
  system,
  pkgs,
}:

let
  lib = pkgs.lib;
  # sha-512 hes za lozinku "test" (mkpasswd -m sha-512) — SAMO za VM test.
  testPasswordHash = "$6$teGKUpBThR9QE1R2$oiHjNVITAVQeyXLpcDZOXbPOQmpmPyFVPSwfku8gBt1u8v8ppoQpPybmYzm85GZKEsHYSpk94syNaksUNcaHJ0";
in
inputs.disko.lib.testLib.makeDiskoTest {
  inherit pkgs;
  name = "impermanence-wipe-on-boot";
  efi = true;
  enableOCR = true;

  # Isti LUKS+btrfs layout kao Evangelion; passwordFile daje format-time lozinku.
  disko-config = import ../modules/system/disko/btrfs-luks-layout.nix {
    inherit lib;
    passwordFile = "/tmp/secret.key"; # test okvir upisuje "secretsecret"
  };

  # Sistem koji se instalira u VM: pravi rollback servis + stub korisnik.
  extraSystemConfig = {
    imports = [
      inputs.impermanence.nixosModules.impermanence
      ../modules/system/impermanence-rollback.nix
    ];

    # Minimalni persist — dovoljno da modul radi; test pise direktno u /persist.
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [ "/var/lib/nixos" ];
    };

    # Stub korisnik: deklarativna lozinka (bez sops u VM). Testira da /etc/shadow
    # (na obrisanom @) biva ponovo upisan iz deklaracije pri svakom butu.
    users.mutableUsers = false;
    users.users.whitewolf = {
      isNormalUser = true;
      hashedPassword = testPasswordHash;
    };
  };

  # Prvi but: odgovori na LUKS passphrase prompt.
  bootCommands = ''
    machine.wait_for_text("[Pp]assphrase for")
    machine.send_chars("secretsecret\n")
  '';

  extraTestScript = ''
    machine.wait_for_unit("multi-user.target")

    # Markeri: jedan na obrisivom root (@), jedan na trajnom /persist.
    machine.succeed("touch /marker-on-root")
    machine.succeed("test -d /persist")
    machine.succeed("touch /persist/should-survive")
    machine.succeed("sync")

    # Reboot (nov qemu proces; ponovo unesi LUKS lozinku).
    machine.shutdown()
    machine = create_test_machine(oldmachine=machine, name="rebooted")
    machine.start()
    machine.wait_for_text("[Pp]assphrase for")
    machine.send_chars("secretsecret\n")
    machine.wait_for_unit("multi-user.target")

    # Rollback dokaz: @ marker nestao, /persist preziveo.
    machine.fail("test -e /marker-on-root")
    machine.succeed("test -e /persist/should-survive")

    # Auth dokaz: whitewolf i dalje ima sha-512 hes u /etc/shadow posle wipe-a
    # (deklarativna lozinka ponovo upisana pri butu, nije izgubljena sa @).
    machine.succeed("getent shadow whitewolf | grep -Eq '[$]6[$]'")
  '';
}
