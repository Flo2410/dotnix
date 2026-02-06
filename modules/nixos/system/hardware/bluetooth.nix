{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.hardware.bluetooth;
in {
  options.system.hardware.bluetooth = {
    enable = mkEnableOption "Bluetooth";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
    };

    services.udev.extraRules = let
      btLatencyScript = pkgs.writeShellScript "set-bluetooth-latency" ''
        # These values determine the desired Bluetooth connection parameters.
        # Adjust them here if needed, then test.

        # Bluetooth connection latency.
        # '0' means the peripheral (mouse/trackpad) should not skip any connection events.
        # This is crucial for minimizing perceived lag.
        # Default: 0
        TARGET_CONN_LATENCY=0

        # Bluetooth minimum connection interval.
        # Value is in units of 1.25ms (e.g., 6 * 1.25ms = 7.5ms).
        # Lower values mean more frequent communication, reducing lag.
        # Default: 6
        TARGET_CONN_MIN_INTERVAL=6

        # Bluetooth maximum connection interval.
        # Value is in units of 1.25ms (e.g., 7 * 1.25ms = 8.75ms).
        # For low latency, this is typically set equal to or slightly larger than TARGET_CONN_MIN_INTERVAL.
        # Default: 7
        TARGET_CONN_MAX_INTERVAL=7

        # Wait briefly for interfaces to initialize and debugfs files to appear.
        sleep 3

        BT_DEBUG_PATH="/sys/kernel/debug/bluetooth/"

        if [ ! -d "$BT_DEBUG_PATH" ]; then
          logger "Bluetooth debugfs path $BT_DEBUG_PATH not found. Kernel may need CONFIG_BT_DBUGFS."
          exit 1
        fi

        for HCI_PATH in $\{BT_DEBUG_PATH}hci*/ ; do
          if [ -d "$HCI_PATH" ]; then
            HCI_DEVICE=$(basename "$HCI_PATH")

            CONN_LATENCY_FILE="$\{HCI_PATH}conn_latency"
            CONN_MIN_INTERVAL_FILE="$\{HCI_PATH}conn_min_interval"
            CONN_MAX_INTERVAL_FILE="$\{HCI_PATH}conn_max_interval"

            logger "Attempting to configure low-latency Bluetooth parameters for $HCI_DEVICE using values: Latency=$\{TARGET_CONN_LATENCY}, MinInterval=$\{TARGET_CONN_MIN_INTERVAL}, MaxInterval=$\{TARGET_CONN_MAX_INTERVAL}"

            # Apply conn_latency setting
            if [ -f "$CONN_LATENCY_FILE" ]; then
              if echo "$\{TARGET_CONN_LATENCY}" > "$CONN_LATENCY_FILE"; then
                logger "Set conn_latency to $\{TARGET_CONN_LATENCY} for $HCI_DEVICE"
              else
                logger "Error setting conn_latency for $HCI_DEVICE"
              fi
            else
              logger "conn_latency file not found for $HCI_DEVICE"
            fi

            # Apply conn_min_interval setting
            if [ -f "$CONN_MIN_INTERVAL_FILE" ]; then
              if echo "$\{TARGET_CONN_MIN_INTERVAL}" > "$CONN_MIN_INTERVAL_FILE"; then
                logger "Set conn_min_interval to $\{TARGET_CONN_MIN_INTERVAL} (raw value) for $HCI_DEVICE"
              else
                logger "Error setting conn_min_interval for $HCI_DEVICE"
              fi
            else
              logger "conn_min_interval file not found for $HCI_DEVICE"
            fi

            # Apply conn_max_interval setting
            if [ -f "$CONN_MAX_INTERVAL_FILE" ]; then
              if echo "$\{TARGET_CONN_MAX_INTERVAL}" > "$CONN_MAX_INTERVAL_FILE"; then
                logger "Set conn_max_interval to $\{TARGET_CONN_MAX_INTERVAL} (raw value) for $HCI_DEVICE"
              else
                logger "Error setting conn_max_interval for $HCI_DEVICE"
              fi
            else
              logger "conn_max_interval file not found for $HCI_DEVICE"
            fi
          fi
        done

        exit 0
      '';
    in ''
      # Run the script whenever a bluetooth hci device is added
      ACTION=="add", SUBSYSTEM=="bluetooth", KERNEL=="hci[0-9]*", RUN+="${btLatencyScript}"
    '';

    # https://github.com/NixOS/nixpkgs/issues/170573
    systemd.services."bluetooth".serviceConfig = {
      StateDirectory = ""; # <<< minimal solution, applied in override.conf

      # Seems unnecessary, but useful to keep in mind if bluetooth
      # defaults get locked down even more:
      # ReadWritePaths="/persist/var/lib/bluetooth/";
    };

    # services.blueman.enable = true;
  };
}
