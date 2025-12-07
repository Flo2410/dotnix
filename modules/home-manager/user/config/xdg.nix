{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.config.xdg;
in {
  options.user.config.xdg = {
    enable = mkEnableOption "Enable XDG";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xdg-utils
      xdg-user-dirs
    ];

    xdg = {
      enable = true;

      userDirs = {
        enable = true;
        createDirectories = true;
        music = "${config.home.homeDirectory}/Music";
        videos = "${config.home.homeDirectory}/Videos";
        pictures = "${config.home.homeDirectory}/Pictures";
        templates = "${config.home.homeDirectory}/Templates";
        download = "${config.home.homeDirectory}/Downloads";
        documents = "${config.home.homeDirectory}/Documents";
        desktop = "${config.home.homeDirectory}/Desktop";
        publicShare = null;
        extraConfig = {
          XDG_DOTFILES_DIR = "${config.home.homeDirectory}/dotnix";
          XDG_ARCHIVE_DIR = "${config.home.homeDirectory}/Archive";
          XDG_VM_DIR = "${config.home.homeDirectory}/vms";
          XDG_GAME_DIR = "${config.home.homeDirectory}/Games";
          XDG_GAME_SAVE_DIR = "${config.home.homeDirectory}/Game Saves";
        };
      };

      mime.enable = true;
      configFile."mimeapps.list".force = true;
      dataFile."applications/mimeapps.list".force = true;

      mimeApps = {
        enable = true;

        # Note: the .desktop entries need to match the file name in pkg/share/applications
        defaultApplications = {
          "text/plain" = "dev.zed.Zed.desktop";
          "text/markdown" = "dev.zed.Zed.desktop";
          "text/xml" = "dev.zed.Zed.desktop";
          "application/xml" = "dev.zed.Zed.desktop";
          "application/x-text" = "dev.zed.Zed.desktop";
          "inode/directory" = "thunar.desktop";
          "image/png" = "org.nomacs.ImageLounge.desktop";
          "image/jpeg" = "org.nomacs.ImageLounge.desktop";
          "application/pdf" = "okularApplication_pdf.desktop";

          "text/calendar" = "thunderbird.desktop";
          "x-scheme-handler/mailto" = "thunderbird.desktop";

          "application/json" = "dev.zed.Zed.desktop";
        };
      };
    };
  };
}
