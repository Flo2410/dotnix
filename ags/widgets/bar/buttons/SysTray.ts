import Gdk from "gi://Gdk";
import { type TrayItem } from "types/service/systemtray";
import { PanelButton } from "../PanelButton";

const systemtray = await Service.import("systemtray");
const ignore: String[] = ["spotify-client"]; // SysTray items to igonre

const SysTrayItem = (item: TrayItem) =>
  PanelButton({
    class_name: "tray-item",
    child: Widget.Icon({ icon: item.bind("icon") }),
    tooltip_markup: item.bind("tooltip_markup"),
    setup: (self) => {
      const { menu } = item;
      if (!menu) return;

      const id = menu.connect("popped-up", () => {
        self.toggleClassName("active");
        menu.connect("notify::visible", () => {
          self.toggleClassName("active", menu.visible);
        });
        menu.disconnect(id!);
      });

      self.connect("destroy", () => menu.disconnect(id));
    },

    on_primary_click: (btn, event) => {
      if (item.is_menu === false) {
        // only activate if is_menu is false
        item.activate(event);
      } else {
        item.menu?.popup_at_widget(
          btn,
          Gdk.Gravity.SOUTH,
          Gdk.Gravity.NORTH,
          null
        );
      }
    },

    on_secondary_click: (btn) =>
      item.menu?.popup_at_widget(
        btn,
        Gdk.Gravity.SOUTH,
        Gdk.Gravity.NORTH,
        null
      ),
  });

export const SysTray = () =>
  Widget.Box().bind("children", systemtray, "items", (i) =>
    i.filter(({ id }) => !ignore.includes(id)).map(SysTrayItem)
  );
