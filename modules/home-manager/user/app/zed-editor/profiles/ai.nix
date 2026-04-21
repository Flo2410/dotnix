{pkgs}: {
  disable_ai = false;
  agent = {
    enabled = false;
    button = false;

    default_model = {
      provider = "copilot_chat";
      model = "gpt-5.2";
    };
  };

  edit_predictions = {
    provider = "copilot";
  };

  agent_servers = {
    "Claude Code" = {
      type = "custom";
      command = pkgs.lib.getExe pkgs.unstable.claude-agent-acp;
      args = [];
      env = {};
    };
  };
}
