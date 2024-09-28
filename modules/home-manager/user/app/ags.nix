{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.app.ags;
in
{
  options.user.app.ags = {
    enable = mkEnableOption "AGS Widgets";
  };

  config = mkIf cfg.enable {

    programs.ags = {
      enable = mkForce true;

      # null or path, leave as null if you don't want hm to manage the config
      configDir = ../../../../ags;

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
        libdbusmenu-gtk3
      ];
    };
  };
}

