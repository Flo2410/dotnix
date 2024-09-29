import { PanelButton } from "../PanelButton";

const battery = await Service.import("battery");

const Indicator = () =>
  Widget.Icon({
    setup: (self) =>
      self.hook(battery, () => {
        self.icon = battery.icon_name;
      }),
  });

const PercentLabel = () =>
  Widget.Revealer({
    transition: "slide_right",
    click_through: true,
    reveal_child: true,
    child: Widget.Label({
      label: battery.bind("percent").as((p) => `${p}%`),
    }),
  });

const LevelBar = () => {
  const blocks = 7;
  const width = 50;

  const level = Widget.LevelBar({
    bar_mode: "discrete",
    max_value: blocks,
    visible: true,
    css: `block { min-width: ${width / blocks}pt; }`,
    vpack: "fill",
    hpack: "fill",
    value: battery.bind("percent").as((p) => (p / 100) * blocks),
  });

  return level;
};

const WholeButton = () =>
  Widget.Overlay({
    vexpand: true,
    child: LevelBar(),
    class_name: "whole",
    pass_through: true,
    overlay: Widget.Box({
      hpack: "center",
      children: [
        Widget.Icon({
          icon: battery.icon_name,
          visible: true,
        }),
        Widget.Box({
          hpack: "center",
          vpack: "center",
          child: PercentLabel(),
        }),
      ],
    }),
  });

const Regular = () =>
  Widget.Box({
    class_name: "regular",
    children: [Indicator(), PercentLabel(), LevelBar()],
  });

export const BatteryBar = () =>
  PanelButton({
    class_name: "battery-bar",
    hexpand: false,
    visible: battery.bind("available"),
    on_clicked: () => App.openWindow("powerctrl"),
    child: Widget.Box({
      expand: true,
      visible: battery.bind("available"),
      child: WholeButton(),
    }),
    setup: (self) =>
      self.hook(battery, (w) => {
        w.toggleClassName("charging", battery.charging || battery.charged);
        w.toggleClassName("low", battery.percent < 10);
      }),
  });
