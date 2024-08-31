import "style/style"; // Load scss styles
import { PowerCtrl } from "widgets/PowerCtrl";
import { QuickSettings } from "widgets/quicksettings/QuickSettings";

App.config({
  icons: `${App.configDir}/assets`,
  windows: [PowerCtrl(), QuickSettings()],
});
