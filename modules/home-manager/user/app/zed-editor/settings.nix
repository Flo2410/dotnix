{
  pkgs,
  config,
}: let
  globalSettings = import ./profiles/global.nix {inherit pkgs config;};
  defaultProfile =
    import ./profiles/default.nix {inherit pkgs;};
in
  defaultProfile
  // globalSettings
  // {
    profiles = {
      "AI ON" = {
        base = "default";
        settings =
          import ./profiles/ai.nix {inherit pkgs;}
          // globalSettings
          // {
            theme = config.programs.zed-editor.userSettings.theme;
          };
      };
    };
  }
