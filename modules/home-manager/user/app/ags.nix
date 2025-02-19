{
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
