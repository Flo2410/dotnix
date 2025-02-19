import Gtk from "gi://Gtk?version=3.0";
import { Date } from "./buttons/Date";
import { Workspaces } from "./buttons/Workspaces";
import { SystemIndicator } from "./buttons/SystemIndicators";
import { BatteryBar } from "./buttons/BatteryBar";
import { SysTray } from "./buttons/SysTray";
import { Media } from "./buttons/Media";
import { MonitorIdIdx } from "lib/utils";

export const Bar = (monitor: MonitorIdIdx) =>
  Widget.Window<Gtk.Widget>({
    monitor: monitor.index,
    name: `bar-${monitor.id}`,
    exclusivity: "exclusive",
    anchor: ["top", "left", "right"],
    child: Widget.CenterBox({
      class_name: "bar",
      css: "min-width: 2px; min-height: 2px;",
      startWidget: Widget.Box({
        hexpand: true,
        children: [Workspaces(monitor.id)],
      }),
      centerWidget: Widget.Box({
        hpack: "center",
        children: [Date()],
      }),
      endWidget: Widget.Box({
        hexpand: true,
        children: [
          Media(),
          Widget.Box({ expand: true }),
          SysTray(),
          SystemIndicator(),
          BatteryBar(),
        ],
      }),
    }),
    setup: (self) => {
      print("Starting: ", self.name);

      self.on("destroy", (window) => {
        print("Distroyed: ", window.name);
        App.removeWindow(window);
      });
    },
  });
