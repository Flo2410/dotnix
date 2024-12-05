{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.dunst;
in {
  options.user.app.dunst = {
    enable = mkEnableOption "dunst";
  };

  config = mkIf cfg.enable {
    services.dunst = {
      enable = cfg.enable;
      settings = {
        global = {
          monitor = 0;
          follow = "mouse";

          origin = "top-right";
          transparency = 10;

          progress_bar = true;

          corner_radius = 8;
          font = "${config.stylix.fonts.sansSerif.name}";
        };
      };
    };
  };
}
