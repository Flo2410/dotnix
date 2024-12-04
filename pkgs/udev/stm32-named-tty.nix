{ pkgs, stdenv, ... }:

stdenv.mkDerivation rec {
  name = "STM32 rename tty udev";
  version = "1.0";

  src = pkgs.writeTextFile {
    name = "10-stm32-named-tty.rules";

    text = ''
      ACTION=="add", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", SUBSYSTEM=="tty", SYMLINK+="stm32usb"
      
      ACTION=="add", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", SUBSYSTEM=="tty", SYMLINK+="stm32stlink"

      ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0666", TAG+="uaccess"
    '';
  };

  # do not unpack the source
  dontUnpack = true;

  installPhase = ''
    install -D $src $out/lib/udev/rules.d/10-stm32-named-tty.rules
  '';
}
