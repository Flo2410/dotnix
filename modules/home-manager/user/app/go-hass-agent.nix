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

    systemd.user.services.go-hass-agent = {
      # Source: https://github.com/joshuar/go-hass-agent/blob/5269b0c9fb1957c6efaf477c843c0b9e47e312b9/init/go-hass-agent.service
      Unit = {
        Description = "go-hass-agent";
        Wants = ["network-online.target"];
        After = ["network-online.target" "nss-lookup.target"];
        X-Restart-Triggers = [
          "${config.xdg.configFile."go-hass-agent_commands".source}"
        ];
      };

      Service = {
        ExecStart = "${pkgs.go-hass-agent}/bin/go-hass-agent --terminal run";
        Type = "simple";
        Restart = "always";
        RestartSec = 30;
      };

      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };

    xdg.configFile."go-hass-agent_commands" = mkIf (cfg.customCommands != {}) {
      target = "go-hass-agent/commands.toml";
      executable = false;
      source = tomlFormat.generate "commands.toml" cfg.customCommands;
    };
  };
}
