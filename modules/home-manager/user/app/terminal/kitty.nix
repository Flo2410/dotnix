{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.app.terminal.kitty;
in
{
  options.user.app.terminal.kitty = {
    enable = mkEnableOption "Enable kitty";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kitty
    ];
    programs.kitty.enable = true;
    programs.kitty.settings = {
      background_opacity = lib.mkForce "0.75";
    };
  };
}
