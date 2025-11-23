{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.zed-editor;
in {
  options.user.app.zed-editor = {
    enable = mkEnableOption "Enable Zed";
  };

  config = mkIf cfg.enable {
    catppuccin = {
      enable = mkDefault true;

      zed = {
        enable = true;
        flavor = "mocha";
        accent = "sapphire";
        icons = {
          enable = true;
          flavor = "mocha";
        };
      };
    };

    programs.zed-editor = {
      enable = true;
      # mutableUserSettings = false;
      # mutableUserKeymaps = false;

      userKeymaps = import ./keymap.nix {};
      userSettings = import ./settings.nix {inherit pkgs config;};
      extensions = import ./extensions.nix {};
    };
  };
}
