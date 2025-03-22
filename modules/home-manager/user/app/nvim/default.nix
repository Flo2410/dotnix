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
            current_line_blame = false;
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
            python = ["ruff"];
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
            ruff_lsp.enable = true; # Python
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
              python = ["isort" "black"];
            };
            format_on_save = {
              lspFallback = true;
              timeoutMs = 2000;
            };
          };
        };
        telescope = {
          enable = true;
          keymaps = {
            "<leader>?" = {
              action = "oldfiles";
              options = {
                desc = "[?] Find recently opened files";
              };
            };
            "<leader><space>" = {
              action = "buffers";
              options = {
                desc = "[ ] Find existing buffers";
              };
            };
            "<leader>b" = {
              action = "current_buffer_fuzzy_find";
              options = {
                desc = "[b] Fuzzily search in current buffer";
              };
            };
            "<leader>sf" = {
              action = "find_files";
              options = {
                desc = "[s]earch [f]iles";
              };
            };
            "<leader>sh" = {
              action = "help_tags";
              options = {
                desc = "[s]earch [h]elp";
              };
            };
            "<leader>sw" = {
              action = "grep_string";
              options = {
                desc = "[s]earch current [w]ord";
              };
            };
            "<leader>sg" = {
              action = "live_grep";
              options = {
                desc = "[s]earch by [g]rep";
              };
            };
            "<leader>sd" = {
              action = "diagnostics";
              options = {
                desc = "[s]earch [d]iagnotics";
              };
            };
            "<leader>sk" = {
              action = "keymaps";
              options = {
                desc = "[s]earch [k]eymaps";
              };
            };
          };
        };
        cmp = {
          enable = true;
          autoEnableSources = false;
          settings = {
            sources = [
              {name = "nvim_lsp";}
              {name = "path";}
              {name = "buffer";}
            ];
            mapping = {
              "<C-d>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<C-e>" = "cmp.mapping.close()";
              "<C-space>" = "cmp.mapping.complete()";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
            };
          };
        };
        cmp-nvim-lsp.enable = true;
        cmp-path.enable = true;
        cmp-buffer.enable = true;
        autoclose.enable = true;
        auto-session.enable = true;
        direnv.enable = true;
        gitblame = {
          enable = true;
          settings = {
            enable = true;
            message_template = "<summary> // <author> (<date>)";
            display_virtual_text = true;
            highlight_group = "CursorLineBlame";
          };
          # https://github.com/f-person/git-blame.nvim/issues/146#issuecomment-2536408614
          luaConfig.pre = ''
            hl_cursor_line = vim.api.nvim_get_hl(0, { name = "CursorLine" })
            hl_comment = vim.api.nvim_get_hl(0, { name = "Comment" })
            hl_combined = vim.tbl_extend("force", hl_comment, { bg = hl_cursor_line.bg })
            vim.api.nvim_set_hl(0, "CursorLineBlame", hl_combined)
          '';
        };
        cursorline = {
          enable = true;
          settings = {
            cursorline = {
              enable = true;
              timeout = 0;
            };
            cursorword.enable = false;
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
        {
          key = "<C-s>";
          action = ":w<CR>";
          options = {
            silent = true;
            noremap = true;
            desc = "Save file";
          };
        }
      ];

      extraPackages = with pkgs; [
        # Formatters
        rustfmt
        alejandra # nix
        black # pyhton
        isort # python

        # Linters
        gitlint
        shellcheck
        clang-tools
        ruff # python
      ];
    };
  };
}
