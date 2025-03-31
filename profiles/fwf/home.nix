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
    # inputs.stylix.homeManagerModules.stylix # Not needed here as it is bundeled into the nixos module
    inputs.catppuccin.homeModules.catppuccin
    inputs.ags.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # ../../nix/nixpkgs.nix
    ../../nix/lib/functions.nix
  ];

  news.display = "silent"; # disable home-manager news

  home.sessionVariables = {
    SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
  };

  services = {
    syncthing = {
      enable = true;
      tray = {
        enable = true;
        package = pkgs.syncthingtray-minimal;
        command = "syncthingtray --wait";
      };
    };
    gnome-keyring = {
      enable = true;
      components = ["secrets" "ssh"];
    };
    kdeconnect.enable = true;

    ssh-agent.enable = lib.mkForce false; # Disable ssh-agent, I use the one from gnome-keyring
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  user = {
    home = rec {
      enable = true;
      username = "florian";
      homeDirectory = "/home/${username}";
      dotfilesDirectory = "${homeDirectory}/dotnix";
    };

    # WM
    wm.hyprland.enable = lib.mkDefault true;

    shell.enable = true;

    config = {
      xdg.enable = true;
      ssh.enable = true;
      git.enable = true;

      autostart = {
        enable = true;
        autostartItems = [];
      };
    };

    app = {
      browser.ungoogled-chromium.enable = true;
      virtualization.enable = true;
      barrier.enable = true;
      vscode.enable = true;
      matlab.enable = true;
      xilinx-vivado.enable = true;
      thunar.enable = true;
      nvim.enable = true;

      terminal = {
        kitty.enable = true;
      };
    };
  };

  home.packages = with pkgs; [
    # programms
    thunderbird
    discord
    spotify
    prusa-slicer
    onedrivegui
    libreoffice-qt
    obsidian
    pulseview
    (signal-desktop.overrideAttrs (old: {
      postFixup = ''
        # add gnome-keyring to launch args
        substituteInPlace $out/share/applications/signal-desktop.desktop \
          --replace "%U" "--password-store=\"gnome-libsecret\" %U"
      '';
    }))
    remmina
    insomnia
    wireshark
    bitwarden-desktop
    freecad-wayland
    blender

    # kde utils
    kdePackages.kcalc
    kdePackages.skanpage
    kdePackages.systemsettings
    kdePackages.print-manager
    kdePackages.ark
    kdePackages.okular

    # Media
    gimp
    inkscape
    darktable
    vlc
    ffmpeg
    nomacs

    # utils
    syncthing
    gh
    ookla-speedtest
    xorg.xhost
    nixpkgs-fmt
    pre-commit
    file
    sshpass
    nixd
    font-manager
    pavucontrol
    yubikey-manager
    alejandra # nix fmt

    # unstable packages
    (stm32cubemx.overrideAttrs (old: rec {
      desktopItem = makeDesktopItem {
        name = "STM32CubeMX";
        exec = "stm32cubemx";
        desktopName = "STM32CubeMX";
        categories = ["Development"];
        icon = ../../assets/icons/STM32CubeMX.png;
        comment = old.meta.description;
        terminal = false;
        startupNotify = false;
        mimeTypes = [
          "x-scheme-handler/sgnl"
          "x-scheme-handler/signalcaptcha"
        ];
      };

      buildCommand =
        old.buildCommand
        + ''
          mkdir -p $out/share/applications
          cp ${desktopItem}/share/applications/*.desktop $out/share/applications
        '';
    }))
    unstable.naps2
    unstable.saleae-logic-2
    unstable.parsec-bin
    unstable.ente-auth

    # Custom Packages
    home-assistant-desktop
    elamx2

    inputs.zen-browser.packages."${system}".default

    # PWAs
    (pkgs.makeDesktopItem {
      name = "whatsapp-web";
      desktopName = "WhatsApp";
      exec = "chromium --app=https://web.whatsapp.com";
      terminal = false;
      type = "Application";
      icon = "whatsapp";
    })

    (pkgs.makeDesktopItem {
      name = "microsoft-teams";
      desktopName = "Microsoft Teams";
      exec = "chromium --app=https://teams.microsoft.com/go";
      terminal = false;
      type = "Application";
      icon = "teams";
    })

    # Bottles
    (pkgs.makeDesktopItem {
      name = "catia-v5";
      desktopName = "CATIA V5";
      exec = ''bottles-cli run -p "CATIA V5" -b "CATIA" -- %u'';
      terminal = false;
      type = "Application";
      icon = ../../assets/icons/catia_icon.png;
      comment = "Launch CATIA V5 using Bottles.";
      startupWMClass = "CATIA V5";
    })

    # Shell scrips
    (pkgs.writeShellScriptBin "mkshell" ''
      set -e

      # Check if name is provided
      if [ -z "$1" ]; then
        printf "Usage: mkshell <shell>\n"
        printf "  Available shells: latex, rust\n"
        exit 1
      fi

      # Check if shell.nix or .envrc already exist
      if [ -f shell.nix ] || [ -f .envrc ]; then
        printf "\e[31mshell.nix or .envrc already exist\n"
        exit 1
      fi

      if [ "$1" = "latex" ]; then
        cp ${user.home.dotfilesDirectory}/nix/shells/latex.nix shell.nix
      elif [ "$1" = "rust" ]; then
        cp ${user.home.dotfilesDirectory}/nix/shells/rust.nix shell.nix
      elif [ "$1" = "cpp" ]; then
        cp ${user.home.dotfilesDirectory}/nix/shells/cpp.nix shell.nix
      elif [ "$1" = "python" ]; then
        cp ${user.home.dotfilesDirectory}/nix/shells/python.nix shell.nix
      else
        printf "\e[31mNo shell available for: $1\n"
        exit 1
      fi

      # Create .envrc
      printf "use nix\n" > .envrc

      # Check if .gitignore does not exist
      if [ ! -f .gitignore ]; then
        printf "Downloading .gitignore for $1\n"

        if [ "$1" = "latex" ]; then
          ${pkgs.curl}/bin/curl https://raw.githubusercontent.com/github/gitignore/refs/heads/main/TeX.gitignore --output .gitignore --silent
        elif [ "$1" = "rust" ]; then
          ${pkgs.curl}/bin/curl https://raw.githubusercontent.com/github/gitignore/refs/heads/main/Rust.gitignore --output .gitignore --silent
        elif [ "$1" = "cpp" ]; then
          ${pkgs.curl}/bin/curl https://raw.githubusercontent.com/github/gitignore/refs/heads/main/C%2B%2B.gitignore --output .gitignore --silent
        elif [ "$1" = "python" ]; then
          ${pkgs.curl}/bin/curl https://raw.githubusercontent.com/github/gitignore/refs/heads/main/Python.gitignore --output .gitignore --silent
        else
          printf "\e[31mNo .gitignore for: $1\n"
          exit 1
        fi

        printf "\n# direnv\n.direnv/\n" >> .gitignore
      else
        printf "\e[33m.gitignore already exists\n"
      fi
    '')
  ];

  # specialisation = {
  #   plasma.configuration = {
  #     stylix.enable = lib.mkForce false;
  #     user.wm.hyprland.enable = lib.mkForce false;
  #     user.wm.plasma.enable = lib.mkForce true;
  #   };
  # };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
