{
  pkgs,
  config,
}: {
  "$mod" = "SUPER";
  bind = let
    # Sources:
    # https://github.com/fufexan/dotfiles/blob/a0bebadeb029ef50f2fa99ad3e7751a98b835610/home/programs/wayland/hyprland/binds.nix
    # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
    workspaces = builtins.concatLists (builtins.genList
      (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in [
          "$mod, ${ws}, workspace, ${toString (x + 1)}"
          "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
        ]
      )
      10);

    toggle = program: let
      prog = builtins.substring 0 14 program;
    in "pkill ${prog} || ${program}";

    runOnce = config.lib.meta.runOnce;

    cliphist-rofi-img = pkgs.writeShellScript "cliphist-rofi-img" ''
      tmp_dir="/tmp/cliphist"
      rm -rf "$tmp_dir"

      if [[ -n "$1" ]]; then
          cliphist decode <<<"$1" | wl-copy
          exit
      fi

      mkdir -p "$tmp_dir"

      read -r -d \'\' prog <<EOF
      /^[0-9]+\s<meta http-equiv=/ { next }
      match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
          system("echo " grp[1] "\\\\\t | cliphist decode >$tmp_dir/"grp[1]"."grp[3])
          print \$0"\0icon\x1f$tmp_dir/"grp[1]"."grp[3]
          next
      }
      1
      EOF
      cliphist list | gawk "$prog"
    '';
  in
    [
      # --------------------------------
      # compositor commands
      # --------------------------------

      "$mod SHIFT, E, exec, pkill Hyprland"
      "$mod, Q, killactive,"
      "$mod, F, togglefloating,"
      "$mod ALT, ,resizeactive,"
      "$mod, N, fullscreen, 1"
      "$mod SHIFT, N, fullscreenstate, 2 0"
      "$mod , P, pin,"

      # --------------------------------
      # move focus
      # --------------------------------

      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"

      "$mod, H, movefocus, l"
      "$mod, L, movefocus, r"
      "$mod, K, movefocus, u"
      "$mod, J, movefocus, d"

      # --------------------------------
      # workspaces
      # --------------------------------

      # swap window positions
      "$mod SHIFT, left, layoutmsg, addmaster"
      "$mod SHIFT, right, layoutmsg, removemaster"
      "$mod SHIFT, up, layoutmsg, swapprev"
      "$mod SHIFT, down, layoutmsg, swapnext"

      "$mod SHIFT, H, layoutmsg, addmaster"
      "$mod SHIFT, L, layoutmsg, removemaster"
      "$mod SHIFT, K, layoutmsg, swapprev"
      "$mod SHIFT, J, layoutmsg, swapnext"

      # change window in a group
      "$mod SHIFT, H, changegroupactive, b"
      "$mod SHIFT, L, changegroupactive, f"

      # Swap current window with main window
      "$mod, M, layoutmsg, swapwithmaster"

      # switch workspace on current monitor
      "$mod CTRL, left, workspace, r-1"
      "$mod CTRL, H, workspace, r-1"
      "$mod CTRL, mouse:275, workspace, r-1"
      "$mod CTRL, right, workspace, r+1"
      "$mod CTRL, L, workspace, r+1"
      "$mod CTRL, mouse:276, workspace, r+1"

      # move window to next/prev workspace
      "$mod CTRL SHIFT, left, movetoworkspace, r-1"
      "$mod CTRL SHIFT, right, movetoworkspace, r+1"

      "$mod CTRL SHIFT, H, movetoworkspace, r-1"
      "$mod CTRL SHIFT, L, movetoworkspace, r+1"

      # Change workspace orientation
      "$mod, PLUS, layoutmsg, orientationcycle left top"

      # Set Master window size
      # 33% of screen
      "$mod ALT, H, layoutmsg, focusmaster master"
      "$mod ALT, H, resizeactive, exact 30% 30%"
      # 50% of screen
      "$mod ALT, J, layoutmsg, focusmaster master"
      "$mod ALT, J, resizeactive, exact 50% 50%"
      # 66% of screen
      "$mod ALT, K, layoutmsg, focusmaster master"
      "$mod ALT, K, resizeactive, exact 70% 70%"

      # Open special workspaces
      "$mod, S, togglespecialworkspace, social" # Social special workspace (Thunderbird, Discord, Teams, etc.)

      # --------------------------------
      # utility
      # --------------------------------

      # logout menu
      "$mod, Escape, exec, ${toggle "wlogout"} -p layer-shell -b 6"
      # open settings
      "$mod, U, exec, XDG_CURRENT_DESKTOP=gnome gnome-control-center"
      # open app launcher
      "ALT, SPACE, exec, rofi -show drun -modes drun,calc,window -replace"
      # clipboard history
      "$mod, V, exec, rofi -show clipboard -modes clipboard:${cliphist-rofi-img} -show-icons -replace"
      # screenshot
      ", PRINT, exec, hyprshot -m output"
      "$mod, PRINT, exec, hyprshot -m region"
      "$mod SHIFT, PRINT, exec, hyprshot -m window"

      # --------------------------------
      # programs
      # --------------------------------

      "$mod, RETURN, exec, kitty"
      "$mod, C, exec, code --new-window" # open a new vscode window
      "$mod, D, exec, code ~/dotnix" # open dotnix in vscode
      "$mod, E, exec, thunar"
    ]
    ++ workspaces;

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

  bindle = let
    bctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  in [
    # volume
    ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
    ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"

    # backlight
    ", XF86MonBrightnessUp, exec, ${bctl} set 5%+"
    ", XF86MonBrightnessDown, exec, ${bctl} set 5%-"
  ];

  # mouse movements
  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
    "$mod ALT, mouse:272, resizewindow"
  ];
}
