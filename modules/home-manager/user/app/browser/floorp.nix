{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.browser.floorp;
in {
  options.user.app.browser.floorp = {
    enable = mkEnableOption "Enable Floorp";
    defaultBrowser = mkEnableOption "Is default browser";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (mkIf config.user.wm.plasma.enable kdePackages.plasma-browser-integration)
    ];

    programs.firefox = {
      enable = true;
      package = pkgs.unstable.floorp;
      nativeMessagingHosts = with pkgs; [
        (mkIf config.user.wm.plasma.enable kdePackages.plasma-browser-integration)
      ];
      # profiles."default".settings = {
      #   "widget.use-xdg-desktop-portal.file-picker" = 1;
      #   "layout.css.has-selector.enabled" = false;
      # };
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
