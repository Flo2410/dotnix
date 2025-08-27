{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.browser.zen;
in {
  options.user.app.browser.zen = {
    enable = mkEnableOption "Enable zen";
    enableUrlHandler = mkEnableOption "Enable URL Handler";
    defaultBrowser = mkEnableOption "Is default browser";
    package = mkOption {
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (mkIf config.user.wm.plasma.enable kdePackages.plasma-browser-integration)

      (mkIf cfg.enableUrlHandler (pkgs.makeDesktopItem {
        name = "zen-url-handler";
        desktopName = "Zen URL Handler";
        exec = "${pkgs.writeShellScript "zen-url-handler" ''
          ${lib.getExe cfg.package} $(${pkgs.coreutils}/bin/echo $1 | ${lib.getExe pkgs.gnused} 's|zen://||')
        ''} %u";
        terminal = false;
        type = "Application";
        icon = "zen";
        comment = "Handles the zen:// URL";
        mimeTypes = ["x-scheme-handler/zen"];
      }))
    ];

    programs.firefox = {
      enable = true;
      package = cfg.package;
      nativeMessagingHosts = with pkgs; [
        (mkIf config.user.wm.plasma.enable kdePackages.plasma-browser-integration)
      ];
      profiles.default.extensions.force = mkForce true;
      # profiles."default".settings = {
      #   "widget.use-xdg-desktop-portal.file-picker" = 1;
      #   "layout.css.has-selector.enabled" = false;
      # };
    };

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultBrowser {
      "text/html" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";
    };

    home.sessionVariables = mkIf cfg.defaultBrowser {
      DEFAULT_BROWSER = "${cfg.package}/bin/zen-beta";
    };
  };
}
