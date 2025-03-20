{}: [
  {
    key = "shift+cmd+[Backslash]";
    command = "workbench.action.terminal.toggleTerminal";
  }
  {
    key = "ctrl+shift+[Equal]";
    command = "-workbench.action.terminal.toggleTerminal";
  }
  {
    key = "shift+alt+h";
    command = "psi-header.insertFileHeader";
  }
  {
    key = "ctrl+alt+h ctrl+alt+h";
    command = "-psi-header.insertFileHeader";
  }
  {
    key = "ctrl+n";
    command = "-workbench.action.files.newUntitledFile";
  }
  {
    key = "ctrl+n";
    command = "explorer.newFile";
  }
  {
    key = "alt+ctrl+n";
    command = "explorer.newFolder";
  }
  {
    key = "ctrl+shift+p";
    command = "workbench.action.showCommands";
  }
  {
    key = "ctrl+shift+p";
    command = "-workbench.action.showCommands";
  }
  {
    key = "ctrl+p";
    command = "workbench.action.quickOpen";
  }
  {
    key = "ctrl+p";
    command = "-workbench.action.quickOpen";
  }
  {
    key = "shift+alt+up";
    command = "editor.action.copyLinesUpAction";
    when = "editorTextFocus && !editorReadonly";
  }
  {
    key = "ctrl+shift+alt+up";
    command = "-editor.action.copyLinesUpAction";
    when = "editorTextFocus && !editorReadonly";
  }
  {
    key = "shift+alt+down";
    command = "editor.action.copyLinesDownAction";
    when = "editorTextFocus && !editorReadonly";
  }
  {
    key = "ctrl+shift+alt+down";
    command = "-editor.action.copyLinesDownAction";
    when = "editorTextFocus && !editorReadonly";
  }
  {
    key = "ctrl+shift+[BracketRight]";
    command = "workbench.action.zoomIn";
  }
  {
    key = "ctrl+[BracketRight]";
    command = "-workbench.action.zoomIn";
  }
  {
    key = "ctrl+shift+-";
    command = "workbench.action.zoomOut";
  }
  {
    key = "ctrl+-";
    command = "-workbench.action.zoomOut";
  }
  {
    key = "ctrl+/";
    command = "terminal.focus";
  }
  {
    key = "ctrl+shift+7";
    command = "-coverage-gutters.displayCoverage";
  }
  {
    key = "alt+o";
    command = "-C_Cpp.SwitchHeaderSource";
    when = "editorTextFocus && editorLangId =~ /^(c|(cuda-)?cpp)$/ && !(config.C_Cpp.intelliSenseEngine =~ /^[dD]isabled$/)";
  }
  {
    key = "alt+o";
    command = "workbench.action.splitEditor";
  }
  {
    key = "alt+p";
    command = "workbench.action.splitEditorDown";
  }
  {
    key = "ctrl+alt+j";
    command = "-latex-workshop.synctex";
    when = "editorTextFocus && !config.latex-workshop.bind.altKeymap.enabled && !virtualWorkspace && editorLangId =~ /^latex$|^latex-expl3$|^doctex$/";
  }
  {
    key = "ctrl+alt+j";
    command = "workbench.action.toggleMaximizedPanel";
  }
  {
    key = "ctrl+enter";
    command = "-github.copilot.generate";
  }
  {
    key = "ctrl+shift+7";
    command = "editor.action.commentLine";
    when = "editorTextFocus && !editorReadonly";
  }
  {
    key = "ctrl+/";
    command = "-editor.action.commentLine";
    when = "editorTextFocus && !editorReadonly";
  }
]
