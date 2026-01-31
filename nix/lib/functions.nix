{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; {
  lib.meta = {
    mkMutableSymlink = path:
      config.lib.file.mkOutOfStoreSymlink
      (config.user.home.dotfilesDirectory + removePrefix (toString inputs.self) (toString path));

    mkIfElse = p: yes: no:
      mkMerge [
        (mkIf p yes)
        (mkIf (!p) no)
      ];

    runOnce = program: "pgrep ${program} || ${program}";

    mkChromePWA = {
      domain,
      version,
      desktopName,
      icon,
      categories,
    }:
      pkgs.stdenvNoCC.mkDerivation {
        inherit version;
        pname = "pwa-${domain}";
        dontUnpack = true;
        desktopItem = let
          chrome-name = "chrome-${domain}__-Default";
        in
          pkgs.makeDesktopItem {
            inherit desktopName icon categories;
            name = chrome-name;
            exec = "chromium --app=https://${domain}";
            terminal = false;
            type = "Application";
            startupWMClass = chrome-name;
          };

        installPhase = ''
          mkdir -p $out/share/applications
          install -Dm644 $desktopItem/share/applications/* -t $out/share/applications
        '';
      };
  };
}
