{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
with lib; let
  cfg = config.user.app.thunar;
in {
  options.user.app.thunar = {
    enable = mkEnableOption "Thunar";
  };

  config = mkIf cfg.enable {
    xdg.configFile."thunar_uca.xml" = {
      target = "Thunar/uca.xml";
      executable = false;
      text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <actions>
          <action>
            <icon>utilities-terminal</icon>
            <name>Open Terminal Here</name>
            <submenu></submenu>
            <unique-id>1724415373173873-1</unique-id>
            <command>kitty %f</command>
            <description>Open Terminal Here</description>
            <range></range>
            <patterns>*</patterns>
            <startup-notify/>
            <directories/>
          </action>
          <action>
            <icon>vscode</icon>
            <name>Open Code Here</name>
            <submenu></submenu>
            <unique-id>1740573750720834-1</unique-id>
            <command>code %f</command>
            <description>Open Code Here</description>
            <range>*</range>
            <patterns>*</patterns>
            <directories/>
          </action>
        </actions>
      '';
    };
  };
}
