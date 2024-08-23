{ config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.user.config.stylix;
  mkIfElse = config.lib.meta.mkIfElse;

in
{
  options.user.config.stylix = {
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
    font = {
      name = mkOption {
        type = types.str;
        default = "Fira Code";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.fira-code;
      };
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

        home.packages = with pkgs; [
          kdePackages.breeze
          kdePackages.breeze-icons

          noto-fonts-monochrome-emoji
        ];

        catppuccin = {
          enable = true;
          flavor = "mocha";
          accent = "sapphire";
        };

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

          sizes = {
            terminal = 18;
            applications = 12;
            popups = 12;
            desktop = 12;
          };
        };

        stylix.cursor = {
          name = "breeze_cursors";
          package = pkgs.kdePackages.breeze;
          size = 28;
        };

        stylix.opacity.terminal = 0.75;

        stylix.targets.kde.enable = true;
        # stylix.targets.kitty.enable = true; # from catppuccin
        stylix.targets.gtk.enable = true;
        # stylix.targets.rofi.enable = true; # from catppuccin
        stylix.targets.hyprpaper.enable = mkForce true;
        stylix.targets.hyprland.enable = true; # from catppuccin
        # stylix.targets.waybar.enable = true; # from catppuccin
        stylix.targets.vscode.enable = false;
        # stylix.targets.btop.enable = true; # from catppuccin
        stylix.targets.gnome.enable = true;

        qt = {
          enable = true;
          style.name = "kvantum";
          platformTheme.name = "kvantum";
        };

        fonts.fontconfig.defaultFonts = {
          monospace = [ config.stylix.fonts.monospace.name ];
          sansSerif = [ config.stylix.fonts.sansSerif.name ];
          serif = [ config.stylix.fonts.serif.name ];
        };
      };
}


