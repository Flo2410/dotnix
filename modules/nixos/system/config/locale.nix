{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.config.locale;
in {
  options.system.config.locale = {
    enable = mkEnableOption "Enable Locale";

    defaultLocale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
    };

    extraLocale = mkOption {
      type = types.str;
      default = "de_AT.UTF-8";
    };
  };

  config = mkIf cfg.enable {
    i18n.defaultLocale = cfg.defaultLocale;
    i18n.extraLocaleSettings = {
      LC_ADDRESS = cfg.extraLocale;
      LC_IDENTIFICATION = cfg.extraLocale;
      LC_MEASUREMENT = cfg.extraLocale;
      LC_MONETARY = cfg.extraLocale;
      LC_NAME = cfg.extraLocale;
      LC_NUMERIC = cfg.extraLocale;
      LC_PAPER = cfg.extraLocale;
      LC_TELEPHONE = cfg.extraLocale;
      LC_TIME = cfg.extraLocale;
    };
  };
}
