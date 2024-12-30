{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.hyprlock;
in {
  options.user.app.hyprlock = {
    enable = mkEnableOption "Hyprlock";
    wallpaper = mkOption {
      type = types.path;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = cfg.enable;
      package = pkgs.unstable.hyprlock;

      settings = {
        source = mkForce "${config.catppuccin.sources.hyprland}/${config.catppuccin.flavor}.conf";

        "$alpha" = "$sapphireAlpha";
        "$accent" = "$sapphire";
        "$font" = "${config.stylix.fonts.sansSerif.name}";

        general = {
          disable_loading_bar = mkDefault true;
          hide_cursor = mkDefault false;
          no_fade_in = mkDefault false;
        };

        background = [
          {
            monitor = " ";
            path = "${cfg.wallpaper}";
          }
        ];

        auth = {
          pam.enabled = mkDefault true;
          fingerprint = {
            enabled = mkDefault true;
            ready_message = mkDefault "Place your finger on the sensor";
            present_message = mkDefault "Scanning fingerprint";
          };
        };

        label = [
          # LAYOUT
          # {
          #   monitor = "";
          #   text = "Layout: $LAYOUT";
          #   color = "$text";
          #   font_size = 25;
          #   font_family = "$font";
          #   position = "30, -30";
          #   halign = "left";
          #   valign = "top";
          # }

          # TIME
          {
            monitor = "";
            text = "$TIME";
            color = "$text";
            font_size = 90;
            font_family = "$font";
            position = "-30, 0";
            halign = "right";
            valign = "top";
          }

          # DATE
          {
            monitor = "";
            text = "cmd[update:43200000] date +\"%A, %d %B %Y\"";
            color = "$text";
            font_size = 25;
            font_family = "$font";
            position = "-30, -150";
            halign = "right";
            valign = "top";
          }
        ];

        # USER AVATAR
        image = {
          monitor = "";
          path = "${../../../../../assets/framework/framework_logo.png}";
          size = 100;
          border_color = "$accent";
          position = "0, 75";
          halign = "center";
          valign = "center";
        };

        # INPUT FIELD
        input-field = {
          monitor = "";
          size = "300, 60";
          outline_thickness = 4;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "$accent";
          inner_color = "$surface0";
          font_color = "$text";
          fade_on_empty = false;
          placeholder_text = "<span foreground='##$textAlpha'><i>Logged in as </i><span foreground='##$alpha'>$USER</span></span>";
          hide_input = false;
          check_color = "$accent";
          fail_color = "$red";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          capslock_color = "$yellow";
          position = "0, -47";
          halign = "center";
          valign = "center";
        };
      };
    };
  };
}
