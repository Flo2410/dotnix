import "style/style"; // Load scss styles
import { PowerCtrl } from "widgets/PowerCtrl";
import { QuickSettings } from "widgets/quicksettings/QuickSettings";
import { Bar } from "widgets/bar/Bar";
import { forMonitors } from "lib/utils";
import { DateMenu } from "widgets/datemenu/DateMenu";
import { OSD } from "widgets/osd/OSD";

const monitors_changed = () => {
  print("Monitors Changed!");
  print("Windows: ", App.windows.map((w) => w.name).concat(", "));
  App.windows
    .filter((w) => w.name?.includes("bar-"))
    .forEach((w) => App.removeWindow(w));
  forMonitors(Bar).forEach((bar) => App.addWindow(bar));
};

const hyprland = await Service.import("hyprland");
hyprland.connect("monitor-added", monitors_changed);
hyprland.connect("monitor-removed", monitors_changed);

App.config({
  icons: `${App.configDir}/assets`,
  windows: [
    ...forMonitors(Bar),
    ...forMonitors(OSD),
    PowerCtrl(),
    QuickSettings(),
    DateMenu(),
  ],
});
