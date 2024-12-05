{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.fusuma;
in {
  options.user.app.fusuma = {
    enable = mkEnableOption "Enabel Fusuma";
  };

  config = mkIf cfg.enable {
    services.fusuma = {
      package = pkgs.unstable.fusuma;
      enable = true;
      extraPackages = with pkgs; [
        xdotool
        coreutils
        xorg.xprop
        wmctrl
      ];

      settings = {
        swipe = {
          "3" = {
            left.command = "xdotool click 9";
            right.command = "xdotool click 8";
          };

          "4" = {
            left.workspace = "next";
            right.workspace = "prev";
            up.command = "xdotool key super+w";
            down.command = "xdotool key super+w";
          };
        };

        pinch = {
          "2" = {
            out.command = "xdotool keydown ctrl click 4 keyup ctrl";
            "in".command = "xdotool keydown ctrl click 5 keyup ctrl";
          };
        };

        threshold = {
          swipte = 0.5;
          pinch = 0.5;
        };

        interval = {
          swipe = 0.75;
          pinch = 0.5;
        };

        plugin = {
          executors.wmctrl_executor.wrap-navigation = true;
        };
      };
    };
  };
}
