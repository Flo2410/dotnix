import { icon, MonitorIdIdx } from "lib/utils";
import { icons } from "lib/icons";
import { Progress } from "./Progress";
import brightness from "services/brightness";

const audio = await Service.import("audio");

const DELAY = 2500;

function OnScreenProgress(vertical: boolean) {
  const indicator = Widget.Icon({
    size: 20,
    vpack: "start",
  });
  const progress = Progress({
    vertical: vertical,
    width: vertical ? 20 : 200,
    height: vertical ? 200 : 20,
    child: Widget.Box({
      children: [Widget.Box({ expand: true }), indicator],
    }),
  });

  const revealer = Widget.Revealer({
    transition: "slide_down",
    child: progress,
  });

  let count = 0;
  function show(value: number, icon: string) {
    revealer.reveal_child = true;
    indicator.icon = icon;
    progress.setValue(value);
    count++;
    Utils.timeout(DELAY, () => {
      count--;

      if (count === 0) revealer.reveal_child = false;
    });
  }

  return revealer
    .hook(
      brightness,
      () => show(brightness.screen / 100, icons.brightness.screen),
      "notify::screen"
    )
    .hook(audio.speaker, () => {
      const vol = audio.speaker.is_muted ? 0 : audio.speaker.volume;
      const { muted, low, medium, high, overamplified } = icons.audio.volume;
      const cons = [
        [101, overamplified],
        [67, high],
        [34, medium],
        [1, low],
        [0, muted],
      ] as const;

      return show(
        audio.speaker.volume,
        icon(
          cons.find(([n]) => n <= vol * 100)?.[1] || "",
          icons.audio.type.speaker
        )
      );
    });
}

export const OSD = (monitor: MonitorIdIdx) =>
  Widget.Window({
    monitor: monitor.index,
    name: `indicator-${monitor.id}`,
    class_name: "indicator",
    layer: "overlay",
    click_through: true,
    anchor: ["right", "left", "top", "bottom"],
    child: Widget.Box({
      css: "padding: 2px;",
      expand: true,
      child: Widget.Overlay({
        child: Widget.Box({ expand: true }),
        overlay: Widget.Box({
          hpack: "center",
          vpack: "start",
          child: OnScreenProgress(false),
        }),
      }),
    }),
  });
