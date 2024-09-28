import Gtk from "gi://Gtk?version=3.0";
import { Date } from "./buttons/Date";
import { Workspaces } from "./buttons/Workspaces";
import { SystemIndicator } from "./buttons/SystemIndicators";
import { BatteryBar } from "./buttons/BatteryBar";

export const Bar = (monitor = 0) =>
  Widget.Window<Gtk.Widget>({
    monitor,
    name: `bar-${monitor}`,
    exclusivity: "exclusive",
    anchor: ["top", "left", "right"],
    child: Widget.CenterBox({
      class_name: "bar",
      css: "min-width: 2px; min-height: 2px;",
      startWidget: Widget.Box({
        hexpand: true,
        children: [Workspaces(monitor)],
      }),
      centerWidget: Widget.Box({
        hpack: "center",
        children: [Date()],
      }),
      endWidget: Widget.Box({
        hexpand: true,
        children: [
          Widget.Box({ expand: true }),
          SystemIndicator(),
          BatteryBar(),
        ],
      }),
    }),
  });
