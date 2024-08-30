import "style/style"; // Load scss styles
import { PowerCtrl } from "widgets/powerctrl";

App.config({
  icons: `${App.configDir}/assets`,
  windows: [PowerCtrl()],
});
