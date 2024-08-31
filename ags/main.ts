import "style/style"; // Load scss styles
import { PowerCtrl } from "widgets/PowerCtrl";

App.config({
  icons: `${App.configDir}/assets`,
  windows: [PowerCtrl()],
});
