import Gtk from "gi://Gtk?version=3.0";
import PopupWindow from "./PopupWindow";

const power_profiles = await Service.import("powerprofiles");
const battery = await Service.import("battery");

const PowerProfiles = Widget.Box({
  vertical: false,
  class_name: "power-profiles",
  children: ["power-saver", "balanced", "performance"].map((profile) =>
    Widget.Button({
      child: Widget.Label(
        profile
          .split("-")
          .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
          .join(" ")
      ),
      class_name: power_profiles
        .bind("active_profile")
        .as((active_profile) => (active_profile === profile ? "active" : "")),
      on_clicked: () => {
        power_profiles.active_profile = profile;
      },
      cursor: "pointer",
    })
  ),
});

const Battery = Widget.Box({
  class_name: "battery",
  vertical: true,
  children: [
    Widget.Box({
      class_name: "internal",
      vertical: true,
      children: [
        Widget.Box({
          class_name: "label",
          children: [
            Widget.Box({ child: Widget.Label("Internal"), hexpand: true }),
            Widget.Icon({
              icon: "battery-full-charging-symbolic",
              visible: Utils.merge(
                [battery.bind("charging"), battery.bind("charged")],
                (ing, ed) => ing || ed
              ),
            }),
          ],
        }),
        Widget.LevelBar({
          value: battery.bind("percent"),
          widthRequest: 100,
          bar_mode: "continuous",
          max_value: 100,
        }),
      ],
    }),
  ],
});

export const PowerCtrl = () =>
  PopupWindow({
    name: "powerctrl",
    exclusivity: "normal",
    layout: "top-right",
    child: Widget.Box<Gtk.Widget>({
      class_names: ["powerctrl"],
      vertical: true,
      children: [PowerProfiles, Battery],
    }),
  });
