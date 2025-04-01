# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: rec {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    outputs.homeManagerModules.user

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    inputs.plasma-manager.homeManagerModules.plasma-manager
    inputs.stylix.homeManagerModules.stylix
    inputs.catppuccin.homeModules.catppuccin
    inputs.ags.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ../../nix/nixpkgs.nix
    ../../nix/lib/functions.nix
  ];

  news.display = "silent"; # disable home-manager news

  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
    nixPath = ["nixpkgs=flake:nixpkgs"];
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
  };

  home.activation = {
    linkDesktopApplications = {
      after = ["writeBoundary" "createXdgUserDirectories"];
      before = [];
      data = ''
        rm -rf ${user.home.homeDirectory}/.nix-desktop-files
        rm -rf ${user.home.homeDirectory}/.local/share/applications/home-manager
        rm -rf ${user.home.homeDirectory}/.icons/nix-icons
        mkdir -p ${user.home.homeDirectory}/.nix-desktop-files
        mkdir -p ${user.home.homeDirectory}/.icons
        ln -sf ${user.home.homeDirectory}/.nix-profile/share/icons ${user.home.homeDirectory}/.icons/nix-icons
        /usr/bin/desktop-file-install ${user.home.homeDirectory}/.nix-profile/share/applications/*.desktop --dir ${user.home.homeDirectory}/.local/share/applications/home-manager
        sed -i 's/Exec=/Exec=\/home\/${user.home.username}\/.nix-profile\/bin\//g' ${user.home.homeDirectory}/.local/share/applications/home-manager/*.desktop
        /usr/bin/update-desktop-database ${user.home.homeDirectory}/.local/share/applications
      '';
    };
  };

  targets.genericLinux.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;

  services = {
    gnome-keyring = {
      enable = true;
      components = ["secrets" "ssh"];
    };

    ssh-agent.enable = lib.mkForce false; # Disable ssh-agent, I use the one from gnome-keyring
  };

  user = {
    home = rec {
      enable = true;
      username = "florian";
      homeDirectory = "/home/${username}";
      dotfilesDirectory = "${homeDirectory}/dotnix";
    };

    shell.enable = true;

    config = {
      ssh.enable = true;
      git.enable = true;
      stylix = {
        enable = true;
        theme = "catppuccin-mocha";
        wallpaper = ../../assets/wallpapers/moon.jpg;
      };
    };

    app = {
      browser.ungoogled-chromium.enable = true;
      vscode.enable = true;
      nvim.enable = true;

      terminal = {
        kitty.enable = true;
      };
    };
  };

  home.packages = with pkgs; [
    # programms
    libreoffice-qt
    obsidian
    seahorse

    # utils
    gh
    ookla-speedtest
    nixpkgs-fmt
    pre-commit
    file
    sshpass
    nixd
    font-manager
    pavucontrol
    alejandra # nix fmt

    # Media
    gimp
    inkscape
    darktable
    vlc
    ffmpeg
    nomacs

    # PWAs
    (pkgs.makeDesktopItem {
      name = "whatsapp-web";
      desktopName = "WhatsApp";
      exec = "chromium --app=https://web.whatsapp.com";
      terminal = false;
      type = "Application";
      icon = "whatsapp";
    })
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
