{}: [
  {
    context = "Workspace";
    bindings = {
      "alt-l" = "terminal_panel::Toggle";
    };
  }
  {
    context = "Editor";
    bindings = {
      "ctrl-w" = "pane::CloseActiveItem";
    };
  }
  {
    context = "vim_mode == insert";
    bindings = {
      # "j k"= "vim::NormalBefore" // In insert mode, make jk escape to normal mode.
    };
  }

  # Retore some keybinds in vim mode https=//zed.dev/docs/vim#restoring-common-text-editing-and-zed-keybindings
  {
    context = "Editor && !menu";
    bindings = {
      "ctrl-c" = "editor::Copy"; # vim default: return to normal mode
      "ctrl-x" = "editor::Cut"; # vim default: decrement
      "ctrl-v" = "editor::Paste"; # vim default: visual block mode
      "ctrl-y" = "editor::Undo"; # vim default: line up
      "ctrl-f" = "buffer_search::Deploy"; # vim default: page down
      "ctrl-o" = "workspace::Open"; # vim default: go back
      "ctrl-s" = "workspace::Save"; # vim default: show signature
      "ctrl-a" = "editor::SelectAll"; # vim default: increment
      "ctrl-b" = "workspace::ToggleLeftDock"; # vim default: down
    };
  }
]
