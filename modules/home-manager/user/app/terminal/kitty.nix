{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.terminal.kitty;
in {
  options.user.app.terminal.kitty = {
    enable = mkEnableOption "Enable kitty";
    package = mkOption {
      type = types.package;
      default = pkgs.kitty;
    };
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      package = cfg.package;
      settings = {
        background_opacity = lib.strings.floatToString config.stylix.opacity.terminal;
        background_blur = "1";
        cursor = "#74c7ec";
        cursor_beam_thickness = "1.5";
        scrollback_lines = 10000;
        touch_scroll_multiplier = 8;
      };
      shellIntegration = {
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
      # theme = "Solarized Dark Higher Contrast";
    };
  };
}
