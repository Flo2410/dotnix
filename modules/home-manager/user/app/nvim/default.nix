{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.nvim;
in {
  options.user.app.nvim = {
    enable = mkEnableOption "nvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = mkDefault true;

      colorschemes.catppuccin = {
        enable = true;
        settings.background.dark = "mocha";
      };
    };
  };
}
