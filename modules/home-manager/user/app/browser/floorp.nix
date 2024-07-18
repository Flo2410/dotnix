{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.app.browser.floorp;
in
{
  options.user.app.browser.floorp = {
    enable = mkEnableOption "Enable Floorp";
    defaultBrowser = mkEnableOption "Is default browser";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kdePackages.plasma-browser-integration
    ];

    programs.firefox = {
      enable = true;
      package = pkgs.unstable.floorp;
      nativeMessagingHosts = with pkgs; [
        kdePackages.plasma-browser-integration
      ];
    };

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultBrowser {
      "text/html" = "floorp.desktop";
      "x-scheme-handler/http" = "floorp.desktop";
      "x-scheme-handler/https" = "floorp.desktop";
      "x-scheme-handler/about" = "floorp.desktop";
      "x-scheme-handler/unknown" = "floorp.desktop";
    };

    home.sessionVariables = mkIf cfg.defaultBrowser {
      DEFAULT_BROWSER = "${pkgs.floorp}/bin/floorp";
    };
  };
}

