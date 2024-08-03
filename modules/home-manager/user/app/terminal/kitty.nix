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
    programs.kitty = {
      enable = true;
      settings = {
        background_opacity = "0.75";
        background_blur = "1";
        cursor = "#9BC1C2";
        cursor_beam_thickness = "1.5";
        scrollback_lines = 10000;
        touch_scroll_multiplier = 8;
      };
      shellIntegration = {
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
      theme = "Solarized Dark Higher Contrast";
    };
  };
}
