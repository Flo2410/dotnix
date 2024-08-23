{ config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.system.config.stylix;
  mkIfElse = config.lib.meta.mkIfElse;

in
{
  options.system.config.stylix = {
    enable = mkEnableOption "Enable stylix";
    theme = mkOption {
      type = types.enum [
        "nord"
        "catppuccin-frappe"
        "catppuccin-mocha"
      ];
      default = "nord";
    };
    background = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
  };

  config =
    let
      themePath = "../../../../../themes" + ("/" + cfg.theme + "/" + cfg.theme) + ".yaml";
      themePolarity = removeSuffix "\n" (builtins.readFile (./. + "../../../../../themes" + ("/" + cfg.theme) + "/polarity.txt"));
      backgroundUrl = builtins.readFile (./. + "../../../../../themes" + ("/" + cfg.theme) + "/backgroundurl.txt");
      backgroundSha256 = builtins.readFile (./. + "../../../../../themes/" + ("/" + cfg.theme) + "/backgroundsha256.txt");
    in
    mkIf cfg.enable
      {
        stylix.enable = true;
        stylix.autoEnable = false;
        stylix.polarity = themePolarity;

        stylix.image = mkIfElse (cfg.background != null) cfg.background (
          pkgs.fetchurl {
            url = backgroundUrl;
            sha256 = backgroundSha256;
          }
        );

        stylix.base16Scheme = ./. + themePath;

        stylix.fonts = {
          monospace = {
            name = "Fira Code";
            package = pkgs.fira-code;
          };
          serif = {
            name = "Noto Serif";
            package = pkgs.noto-fonts;
          };
          sansSerif = {
            name = "Noto Sans";
            package = pkgs.noto-fonts;
          };
          emoji = {
            name = "Noto Emoji";
            package = pkgs.noto-fonts-monochrome-emoji;
          };
        };
      };
}



