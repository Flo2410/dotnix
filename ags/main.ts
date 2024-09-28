import "style/style"; // Load scss styles
import { PowerCtrl } from "widgets/PowerCtrl";
import { QuickSettings } from "widgets/quicksettings/QuickSettings";
import { Bar } from "widgets/bar/Bar";
import { forMonitors } from "lib/utils";
import { DateMenu } from "widgets/datemenu/DateMenu";

App.config({
  icons: `${App.configDir}/assets`,
  windows: [...forMonitors(Bar), PowerCtrl(), QuickSettings(), DateMenu()],
});
