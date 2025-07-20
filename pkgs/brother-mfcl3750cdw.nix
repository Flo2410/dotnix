{
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  coreutils,
  ghostscript,
  gnugrep,
  gnused,
  which,
  perl,
  cups,
  autoPatchelfHook,
  libredirect,
  lib,
}: let
  model = "mfcl3740cdw";
  version = "3.5.1-1";
  src = fetchurl {
    # https://download.brother.com/welcome/dlf105760/mfcl3740cdwpdrv-3.5.1-1.i386.deb
    url = "https://download.brother.com/welcome/dlf105760/${model}pdrv-${version}.i386.deb";
    sha256 = "sha256-3weoQ4jJJ9h2fIm0LCyW9yY8dvuGESI26/isdmhzBZY=";
  };
  reldir = "opt/brother/Printers/${model}/";
in rec {
  driver = stdenv.mkDerivation rec {
    inherit src version;
    name = "${model}drv-${version}";

    nativeBuildInputs = [
      dpkg
      makeWrapper
      autoPatchelfHook
    ];

    buildInputs = [
      cups
      ghostscript
      stdenv.cc.cc.lib
      libredirect
    ];

    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
        dir="$out/${reldir}"
        substituteInPlace $dir/lpd/filter_${model} \
          --replace /usr/bin/perl ${perl}/bin/perl \
          --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$dir\"; #" \
          --replace "PRINTER =~" "PRINTER = \"${model}\"; #"
        wrapProgram $dir/lpd/filter_${model} \
          --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          ghostscript
          gnugrep
          gnused
          which
        ]
      }

      ln -s $dir/lpd/x86_64/* $dir/lpd/

      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $dir/lpd/br${model}filter

      wrapProgram $dir/lpd/br${model}filter \
        --set PATH ${
        lib.makeBinPath [
          coreutils
          gnugrep
          gnused
          ghostscript
        ]
      } \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set NIX_REDIRECTS /opt=$out/opt
    '';

    meta = {
      description = "Brother ${lib.strings.toUpper model} driver";
      homepage = "http://www.brother.com/";
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      license = lib.licenses.unfree;
      platforms = [
        "x86_64-linux"
      ];
      maintainers = [lib.maintainers.steveej];
    };
  };

  cupswrapper = stdenv.mkDerivation rec {
    inherit version src;
    name = "${model}cupswrapper-${version}";

    nativeBuildInputs = [
      dpkg
      makeWrapper
    ];

    buildInputs = [
      cups
      ghostscript
    ];

    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      basedir=${driver}/${reldir}
      dir=$out/${reldir}
      substituteInPlace $dir/cupswrapper/brother_lpdwrapper_${model} \
        --replace /usr/bin/perl ${perl}/bin/perl \
        --replace "basedir =~" "basedir = \"$basedir\"; #" \
        --replace "PRINTER =~" "PRINTER = \"${model}\"; #"
      wrapProgram $dir/cupswrapper/brother_lpdwrapper_${model} \
        --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          ghostscript
          gnugrep
          gnused
        ]
      }
      mkdir -p $out/lib/cups/filter
      mkdir -p $out/share/cups/model
      ln $dir/cupswrapper/brother_lpdwrapper_${model} $out/lib/cups/filter
      ln $dir/cupswrapper/brother_${model}_printer_en.ppd $out/share/cups/model
    '';

    meta = {
      description = "Brother ${lib.strings.toUpper model} CUPS wrapper driver";
      homepage = "http://www.brother.com/";
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      license = lib.licenses.gpl2Plus;
      platforms = [
        "x86_64-linux"
      ];
    };
  };
}
