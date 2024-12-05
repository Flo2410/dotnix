{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.waybar;
in {
  options.user.app.waybar = {
    enable = mkEnableOption "waybar";
  };

  config = mkIf cfg.enable {
    programs.waybar = let
      waybar_modules = import ./modules.nix {};
    in {
      enable = cfg.enable;

      style = builtins.readFile ./style.css;

      settings.mainBar =
        {
          layer = "bottom";
          position = "top";
          height = 30;
          margin-top = 8;
          margin-left = 8;
          margin-right = 8;

          modules-left = ["hyprland/workspaces"];
          modules-center = ["clock"];
          modules-right = ["backlight" "battery" "tray"];
        }
        // waybar_modules;
    };
  };
}
