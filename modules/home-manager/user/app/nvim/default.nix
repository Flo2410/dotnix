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
        gitsigns = {
          enable = true;
          settings = {
            current_line_blame = true;
            signcolumn = true;
          };
        };
        oil.enable = true;
        undotree.enable = true;
        fugitive.enable = true;
        nvim-tree.enable = true;
        web-devicons.enable = true;
        lualine = {
          enable = true;
          settings.options = {
            icons_enabled = false;
            globalstatus = true;
            theme = "onedark";
          };
        };
        lint = {
          enable = true;
          lintersByFt = {
            c = ["clangtidy"];
            cpp = ["clangtidy"];
            gitcommit = ["gitlint"];
            nix = ["nix"];
            sh = ["shellcheck"];
          };
        };
        lsp = {
          servers = {
            clangd.enable = true;
            nixd.enable = true;
            rust_analyzer = {
              enable = true;
              installCargo = true;
              installRustc = true;
            };
          };
        };
        statuscol = {
          enable = true;
          settings = {
            relculright = true;
          };
        };
        conform-nvim = {
          enable = true;
          settings = {
            formatters_by_ft = {
              c = ["astyle"];
              cpp = ["astyle"];
              nix = ["alejandra"];
              sh = ["shfmt"];
            };
            format_on_save = {
              lspFallback = true;
              timeoutMs = 2000;
            };
          };
        };
      };

      keymaps = [
        {
          key = "<leader>pv";
          mode = "n";
          action = "<cmd>Oil<CR>";
          options = {
            silent = true;
            noremap = true;
            desc = "[p]roject [v]iew";
          };
        }
        {
          key = "<leader>u";
          mode = "n";
          action = "<cmd>UndotreeToggle<CR>";
          options = {
            silent = true;
            noremap = true;
            desc = "[u]ndotree toggle";
          };
        }
        {
          key = "<leader>gs";
          mode = "n";
          action = "<cmd>Git<CR>";
          options = {
            silent = true;
            noremap = true;
            desc = "[g]it [s]tatus";
          };
        }
        {
          key = "J";
          mode = "v";
          action = ":m '>+1<CR>gv=gv";
          options = {
            silent = true;
            noremap = true;
            desc = "Shift line down 1 in visual mode";
          };
        }
        {
          key = "K";
          mode = "v";
          action = ":m '<-2<CR>gv=gv";
          options = {
            silent = true;
            noremap = true;
            desc = "Shift line up 1 in visual mode";
          };
        }
        {
          key = "<leader>p";
          mode = "x";
          action = "\"_dP";
          options = {
            silent = true;
            noremap = true;
            desc = "[p]reserve put";
          };
        }
        {
          key = "<leader>y";
          mode = ["n" "v"];
          action = "\"+y";
          options = {
            silent = true;
            noremap = true;
            desc = "[y]ank to system clipboard";
          };
        }
        {
          key = "<leader>Y";
          mode = "n";
          action = "\"+Y";
          options = {
            silent = true;
            noremap = true;
            desc = "[Y]ank line to system clipboard";
          };
        }
        {
          key = "<leader>da";
          mode = "n";
          action = ":lua vim.lsp.buf.code_action()<CR>";
          options = {
            silent = true;
            noremap = true;
            desc = "[d]iagnostic changes [a]ccepted";
          };
        }
        {
          key = "<leader>t";
          mode = "n";
          action = "<cmd>NvimTreeToggle<CR>";
          options = {
            silent = true;
            noremap = true;
            desc = "Toggle nvim [t]ree";
          };
        }
      ];

      extraPackages = with pkgs; [
        # Formatters
        rustfmt
        alejandra

        # Linters
        gitlint
        shellcheck
        clang-tools
      ];
    };
  };
}
