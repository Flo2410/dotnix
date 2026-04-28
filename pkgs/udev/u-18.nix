{
  pkgs,
  stdenvNoCC,
  ...
}:
stdenvNoCC.mkDerivation {
  name = "OSS TEAM U-18";
  version = "1.0";

  src = pkgs.writeTextFile {
    name = "99-u18.rules";

    text = ''
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2e88", ATTRS{idProduct}=="4607", MODE="0660", GROUP="plugdev", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2e88", ATTRS{idProduct}=="4607", MODE="0660", GROUP="plugdev", TAG+="uaccess"
    '';
  };

  # do not unpack the source
  dontUnpack = true;

  installPhase = ''
    install -D $src $out/lib/udev/rules.d/99-u18.rules
  '';
}
