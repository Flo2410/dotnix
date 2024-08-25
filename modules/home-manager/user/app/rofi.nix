{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.app.rofi;

in
{
  options.user.app.rofi = {
    enable = mkEnableOption "rofi";
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = cfg.enable;
      package = pkgs.rofi-wayland;
      plugins = with pkgs; [
        (rofi-calc.override {
          rofi-unwrapped = pkgs.rofi-wayland-unwrapped;
        })
      ];
      extraConfig = {
        # "modes" = "drun,calc,window,clipboard:${cliphist-rofi-img}";
        "show-icons" = true;
      };

      theme = {
        # Appearance customization for list
        listview = {
          columns = 1; # Display items in a single column (list format)
          cycle = true; # Cycle through the list
          dynamic = true; # Dynamically load items
        };
      };
    };
  };
}
