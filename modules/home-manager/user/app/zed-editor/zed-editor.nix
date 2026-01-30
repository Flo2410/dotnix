{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.user.app.zed-editor;

  mkSnippetFile = name: {
    "zed_snippets_${name}" = {
      target = "zed/snippets/${name}.json";
      executable = false;
      text = import ./snippets/${name}.nix {};
    };
  };
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
      mutableUserSettings = false;
      mutableUserKeymaps = false;

      userKeymaps = import ./keymap.nix {};
      userSettings = import ./settings.nix {inherit pkgs config;};
      extensions = import ./extensions.nix {};

      extraPackages = with pkgs; [
        clang-tools # clang-format required by protols for formating used as a protobuf lsp server
      ];
    };

    xdg.configFile = mkSnippetFile "bibtex" // mkSnippetFile "latex";
  };
}
