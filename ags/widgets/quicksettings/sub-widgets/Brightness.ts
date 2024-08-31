import { icons } from "lib/icons";
import brightness from "services/brightness";

const ScreenBrightnessSlider = () =>
  Widget.Slider({
    draw_value: false,
    hexpand: true,
    max: 100,
    value: brightness.bind("screen"),
    on_change: ({ value }) => (brightness.screen = value),
  });

export const ScreenBrightness = () =>
  Widget.Box({
    class_name: "brightness",
    children: [
      Widget.Button({
        vpack: "center",
        child: Widget.Icon(icons.brightness.indicator),
        on_clicked: () => (brightness.screen = 0),
        tooltip_text: brightness
          .bind("screen")
          .as((v) => `Screen Brightness: ${v}%`),
      }),
      ScreenBrightnessSlider(),
    ],
  });

const KeyboardBrightnessSlider = () =>
  Widget.Slider({
    draw_value: false,
    hexpand: true,
    max: 100,
    value: brightness.bind("kbd"),
    on_change: ({ value }) => (brightness.kbd = value),
  });

export const KeyboardBrightness = () =>
  Widget.Box({
    class_name: "brightness",
    children: [
      Widget.Button({
        vpack: "center",
        child: Widget.Icon(icons.brightness.keyboard),
        on_clicked: () => (brightness.kbd = 0),
        tooltip_text: brightness
          .bind("kbd")
          .as((v) => `Keyboard Brightness: ${v}%`),
      }),
      KeyboardBrightnessSlider(),
    ],
  });
