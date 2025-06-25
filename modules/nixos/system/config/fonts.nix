{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.config.fonts;
in {
  options.system.config.fonts = {
    enable = mkEnableOption "Enable Fonts";
  };

  config = mkIf cfg.enable {
    # Fonts are nice to have
    fonts = {
      fontDir.enable = true;
      fontconfig.useEmbeddedBitmaps = true;
      packages = with pkgs; [
        # Fonts
        noto-fonts
        noto-fonts-emoji
        font-awesome
        fira-code
        fira-code-symbols
        corefonts # Microsoft TrueType fonts
        roboto
        material-icons # https://fonts.google.com/icons
        material-design-icons # https://pictogrammers.com/library/mdi/
        bahnschrift-font
        ubuntu-sans
      ];
    };
  };
}
