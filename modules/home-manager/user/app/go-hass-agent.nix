{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.go-hass-agent;
  tomlFormat = pkgs.formats.toml {};
in {
  options.user.app.go-hass-agent = {
    enable = mkEnableOption "Enable Go Hass Agent";

    customCommands = mkOption {
      type = tomlFormat.type;
      default = {};

      example = ''
        button = [
          {
            name = "My Command With an Icon";
            exec = "command arg1 arg2';
            icon = "mdi:chat";
          }
        ];
      '';
      description = ''
        Custom Commands

        Written to {file}`$XDG_CONFIG_HOME/go-hass-agent/commands.toml`
        Docs can be found at: <https://github.com/joshuar/go-hass-agent?tab=readme-ov-file#other-custom-commands>
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go-hass-agent
    ];

    xdg.configFile."go-hass-agent_commands" = mkIf (cfg.customCommands != {}) {
      target = "go-hass-agent/commands.toml";
      executable = false;
      source = tomlFormat.generate "commands.toml" cfg.customCommands;
    };
  };
}
