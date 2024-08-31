import { Menu, ArrowToggleButton } from "../ToggleButton";
import { icons } from "lib/icons";
import { dependencies, sh } from "lib/utils";
const { vpn } = await Service.import("network");

export const VpnToggle = () =>
  ArrowToggleButton({
    name: "vpn",
    icon: "vpn-connection-symbolic",
    label: vpn
      .bind("activated_connections")
      .as((v) => (v.length > 0 ? "Connected" : "Disconnected")),
    connection: [vpn, () => false],
    deactivate: () =>
      vpn.activated_connections.forEach((con) => con.setConnection(false)),
    activate: () => {},
  });

export const VpnSelection = () =>
  Menu({
    name: "vpn",
    icon: "",
    title: "VPN Selection",
    content: [
      Widget.Box({
        vertical: true,
        setup: (self) =>
          self.hook(
            vpn,
            () =>
              (self.children = vpn.connections.map((conn) =>
                Widget.Button({
                  on_clicked: () => {
                    conn.setConnection(
                      conn.state === "connected" || conn.state === "connecting"
                        ? false
                        : true
                    );
                  },
                  child: Widget.Box({
                    children: [
                      Widget.Icon(conn.icon_name),
                      Widget.Label(conn.id || ""),
                      Widget.Icon({
                        icon: icons.ui.tick,
                        hexpand: true,
                        hpack: "end",
                        visible: vpn
                          .bind("activated_connections")
                          .as(
                            (_) =>
                              conn.state === "connected" ||
                              conn.state === "connecting"
                          ),
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
