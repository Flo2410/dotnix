{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.nvim;
in {
  options.user.app.nvim = {
    enable = mkEnableOption "nvim";
  };

  # Resource: https://github.com/pete3n/nixvim-flake/

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = mkDefault true;
      defaultEditor = mkDefault true;
      clipboard.providers.wl-copy.enable = true;

      colorschemes.catppuccin = {
        enable = true;
        settings.background.dark = "mocha";
      };

      globals = {
        mapleader = " ";
      };

      opts = {
        number = true;
        relativenumber = true;
        wrap = false;
        undofile = true;
        # colorcolumn = "90";
        shiftwidth = 2;
        tabstop = 2;
        swapfile = false; # Undotree
        backup = false; # Undotree
      };

      plugins = {
        gitsigns.enable = true;
        oil.enable = true;
        undotree.enable = true;
        fugitive.enable = true;
        nvim-tree.enable = true;
        web-devicons.enable = true;
        lualine = {
          enable = true;
          iconsEnabled = false;
          globalstatus = true;
          theme = "onedark";
        };
      };
    };
  };
}
