{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.ags;
in {
  options.user.app.ags = {
    enable = mkEnableOption "AGS Widgets";
  };

  config = mkIf cfg.enable {
    home.packages = let
      binPath = with pkgs;
        makeBinPath [
          bun
          dart-sass
        ];

      start-ags = pkgs.writeShellScriptBin "start-ags" ''
        PATH="$PATH:${binPath}" ags -b hypr
      '';

      stop-ags = pkgs.writeShellScriptBin "stop-ags" ''
        pkill .ags-wrapped
      '';

      restart-ags = pkgs.writeShellScriptBin "restart-ags" ''
        pkill .ags-wrapped
        PATH="$PATH:${binPath}" ags -b hypr
      '';
    in [
      start-ags
      stop-ags
      restart-ags
    ];

    programs.ags = {
      enable = mkForce true;
      package = inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
        nativeBuildInputs = with pkgs; [
          pkg-config
          meson
          ninja
          nodePackages.typescript
          wrapGAppsHook3
          gobject-introspection
        ];

        patches = [
          # Workaround for TypeScript 5.9: https://github.com/Aylur/ags/issues/725#issuecomment-3070009695
          (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/NixOS/nixpkgs/refs/heads/nixos-25.11/pkgs/by-name/ag/ags_1/ts59.patch";
            sha256 = "0dw65i19d3svmq4m0k5m5nqjg9v3yjbcd1w4x4mavvk148h1xj44";
          })
        ];
      });

      # null or path, leave as null if you don't want hm to manage the config
      configDir = ../../../../ags;

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk_4_1
        accountsservice
        libdbusmenu-gtk3
      ];
    };
  };
}
