{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.user.app.zed-editor;
in {
  options.user.app.zed-editor = {
    enable = lib.mkEnableOption "Enable Zed";
  };

  config = lib.mkIf cfg.enable {
    catppuccin = {
      enable = lib.mkDefault true;

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
      package = pkgs.unstable.zed-editor;
      # mutableUserSettings = false;
      # mutableUserKeymaps = false;

      userKeymaps = import ./keymap.nix {};
      userSettings = import ./settings.nix {inherit pkgs config;};
      extensions = import ./extensions.nix {};
    };
  };
}
