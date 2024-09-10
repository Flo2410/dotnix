# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    outputs.homeManagerModules.user

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    inputs.plasma-manager.homeManagerModules.plasma-manager
    # inputs.stylix.homeManagerModules.stylix # Not needed here as it is bundeled into the nixos module
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.ags.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # ../../nix/nixpkgs.nix
    ../../nix/lib/functions.nix
  ];

  news.display = "silent"; # disable home-manager news

  services = {
    syncthing = {
      enable = true;
      tray = {
        enable = true;
        package = pkgs.syncthingtray-minimal;
        command = "syncthingtray --wait";
      };
    };
    kdeconnect.enable = true;
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
        autostartItems = [ ];
      };
    };

    app = {
      browser.ungoogled-chromium.enable = true;
      browser.floorp = {
        enable = true;
        defaultBrowser = true;
      };
      virtualization.enable = true;
      barrier.enable = true;
      vscode.enable = true;

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
    matlab # from nix-matlab
    prusa-slicer
    onedrivegui
    libreoffice-qt
    obsidian
    kicad
    pulseview
    vivaldi_qt6
    (signal-desktop.overrideAttrs (old: {
      postFixup = ''
        # add kwallt6 to launch args
        substituteInPlace $out/share/applications/signal-desktop.desktop \
          --replace "%U" "--password-store=\"kdewallet6\" %U"
      '';
    }))
    flare-signal # alterative signal client

    # kde utils
    kdePackages.kcalc
    kdePackages.skanpage
    kdePackages.kwallet
    kdePackages.kwalletmanager
    kdePackages.dolphin
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

    # unstable packages
    (unstable.stm32cubemx.overrideAttrs (old: rec{
      desktopItem = makeDesktopItem {
        name = "STM32CubeMX";
        exec = "stm32cubemx";
        desktopName = "STM32CubeMX";
        categories = [ "Development" ];
        icon = "stm32cubemx";
        comment = old.meta.description;
        terminal = false;
        startupNotify = false;
        mimeTypes = [
          "x-scheme-handler/sgnl"
          "x-scheme-handler/signalcaptcha"
        ];
      };

      buildCommand = old.buildCommand + ''
        mkdir -p $out/share/applications
        cp ${desktopItem}/share/applications/*.desktop $out/share/applications
      '';
    }))
    unstable.naps2
    unstable.saleae-logic-2
    unstable.parsec-bin

    # Remmina v1.4.30 
    remmina

    # Custom Packages
    home-assistant-desktop
    elamx2
    # ente-auth

    inputs.zen-browser.packages."${system}".specific

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
