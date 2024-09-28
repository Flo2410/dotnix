import Gtk from "gi://Gtk?version=3.0";
import { Date } from "./buttons/Date";

export const Bar = (monitor = 0) =>
  Widget.Window<Gtk.Widget>({
    monitor,
    class_name: "bar",
    name: `bar-${monitor}`,
    exclusivity: "exclusive",
    anchor: ["top", "left", "right"],
    child: Widget.CenterBox({
      css: "min-width: 2px; min-height: 2px;",
      startWidget: Widget.Box({
        hexpand: true,
        children: [],
      }),
      centerWidget: Widget.Box({
        hpack: "center",
        children: [Date()],
      }),
      endWidget: Widget.Box({
        hexpand: true,
        children: [],
      }),
    }),
  });
