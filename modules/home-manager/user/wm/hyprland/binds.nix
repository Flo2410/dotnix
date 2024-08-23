{ config }:

{
  "$mod" = "SUPER";
  bind =
    let
      # Sources:
      # https://github.com/fufexan/dotfiles/blob/a0bebadeb029ef50f2fa99ad3e7751a98b835610/home/programs/wayland/hyprland/binds.nix

      # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      workspaces = builtins.concatLists (builtins.genList
        (x:
          let
            ws = let c = (x + 1) / 10; in
              builtins.toString (x + 1 - (c * 10));
          in
          [
            "$mod, ${ws}, workspace, ${toString (x + 1)}"
            "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]
        ) 10);

      toggle = program:
        let
          prog = builtins.substring 0 14 program;
        in
        "pkill ${prog} || ${program}";

      runOnce = config.lib.meta.runOnce;
    in
    [
      # --------------------------------
      # compositor commands
      # --------------------------------

      "$mod SHIFT, E, exec, pkill Hyprland"
      "$mod, Q, killactive,"
      "$mod, F, togglefloating,"
      "$mod ALT, ,resizeactive,"

      # --------------------------------
      # move focus
      # --------------------------------

      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"

      "$mod SHIFT, left, layoutmsg, addmaster"
      "$mod SHIFT, right, layoutmsg, removemaster"
      "$mod SHIFT, up, layoutmsg, swapprev"
      "$mod SHIFT, down, layoutmsg, swapnext"

      # --------------------------------
      # utility
      # --------------------------------

      # logout menu
      "$mod, Escape, exec, ${toggle "wlogout"} -p layer-shell"
      # lock screen
      "$mod, L, exec, ${runOnce "hyprlock"}"
      # open settings
      "$mod, U, exec, XDG_CURRENT_DESKTOP=gnome gnome-control-center"
      # open app launcher
      "ALT, SPACE, exec, ${toggle "rofi"} -show drun"

      # --------------------------------
      # programs
      # --------------------------------

      "$mod, RETURN, exec, kitty"
      "$mod, C, exec, code --new-window" # open a new vscode window

    ] ++ workspaces;


  bindl = [
    # media controls
    ", XF86AudioPlay, exec, playerctl play-pause"
    ", XF86AudioPrev, exec, playerctl previous"
    ", XF86AudioNext, exec, playerctl next"

    # volume
    ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

    # lid
    ",switch:on:Lid Switch, exec, systemctl suspend-then-hibernate"
  ];

  bindle = [
    # volume
    ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
    ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"

    # backlight
    ", XF86MonBrightnessUp, exec, brillo -p -u 1000000 -A 5"
    ", XF86MonBrightnessDown, exec, brillo -p -u 1000000 -U 5"
  ];

  # mouse movements
  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
    "$mod ALT, mouse:272, resizewindow"
  ];
}
