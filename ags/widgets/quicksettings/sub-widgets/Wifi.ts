import { Menu, ArrowToggleButton } from "../ToggleButton";
import { icons } from "lib/icons";
import { dependencies, sh } from "lib/utils";
const { wifi } = await Service.import("network");

export const WifiToggle = () =>
  ArrowToggleButton({
    name: "network",
    icon: wifi.bind("icon_name"),
    label: Utils.watch("Disabled", wifi, () => {
      if (!wifi.enabled) return "Disabled";
      else if (wifi.state === "activated" && wifi.ssid) return wifi.ssid;
      else return "Disconnected";
    }),
    connection: [wifi, () => wifi.enabled],
    deactivate: () => (wifi.enabled = false),
    activate: () => {
      wifi.enabled = true;
      wifi.scan();
    },
  });

export const WifiSelection = () =>
  Menu({
    name: "network",
    icon: "",
    title: "Wifi Selection",
    content: [
      Widget.Box({
        vertical: true,
        setup: (self) =>
          self.hook(
            wifi,
            () =>
              (self.children = wifi.access_points
                .filter(
                  (value, idx, self) =>
                    self.findIndex((item) => item.ssid === value.ssid) === idx
                )
                .sort((a, b) => b.strength - a.strength)
                .slice(0, 10)
                .map((ap) =>
                  Widget.Button({
                    on_clicked: () => {
                      if (!dependencies("nmcli")) return;
                      if (wifi.ssid == ap.ssid) {
                        Utils.execAsync(`nmcli connection down ${wifi.ssid}`);
                      } else {
                        Utils.execAsync(
                          `nmcli device wifi connect ${ap.bssid}`
                        );
                      }
                    },
                    child: Widget.Box({
                      children: [
                        Widget.Icon(ap.iconName),
                        Widget.Label(ap.ssid || ""),
                        Widget.Icon({
                          icon: icons.ui.tick,
                          hexpand: true,
                          hpack: "end",
                          visible: wifi.bind("ssid").as((_) => ap.active),
                        }),
                      ],
                    }),
                  })
                ))
          ),
      }),
      Widget.Separator(),
      Widget.Button({
        on_clicked: () => {
          sh("nm-connection-editor");
          App.closeWindow("quicksettings");
        },
        child: Widget.Box({
          children: [Widget.Icon(icons.ui.settings), Widget.Label("Network")],
        }),
      }),
    ],
  });
