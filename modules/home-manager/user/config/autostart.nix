{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.config.autostart;
in
{
  options.user.config.autostart = {
    enable = mkEnableOption "Enable autostart";
    autostartItems = mkOption {
      type = types.listOf (types.enum [
        "OneDriveGUI"
        "yakuake"
        "latte-dock"
      ]);
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (mkIf (builtins.elem "OneDriveGUI" cfg.autostartItems) (makeAutostartItem {
        name = "OneDriveGUI";
        package = onedrivegui;
      }))

      (mkIf (builtins.elem "yakuake" cfg.autostartItems) (makeAutostartItem {
        name = "yakuake";
        package = yakuake;
        srcPrefix = "org.kde.";
      }))

      (mkIf (builtins.elem "latte-dock" cfg.autostartItems) (makeAutostartItem {
        name = "latte-dock";
        package = latte-dock;
        srcPrefix = "org.kde.";
      }))
    ];
  };
}
