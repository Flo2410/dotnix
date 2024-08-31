import type Gtk from "gi://Gtk?version=3.0";
import PopupWindow from "widgets/PopupWindow";
import { WifiToggle, WifiSelection } from "./sub-widgets/Wifi";
import { BluetoothToggle, BluetoothDevices } from "./sub-widgets/Bluetooth";
import { Media } from "./sub-widgets/Media";
import {
  Volume,
  AppMixer,
  SinkSelector,
  Microphone,
} from "./sub-widgets/Volume";
import { VpnSelection, VpnToggle } from "./sub-widgets/Vpn";

const media = (await Service.import("mpris")).bind("players");

const Row = (
  toggles: Array<() => Gtk.Widget> = [],
  menus: Array<() => Gtk.Widget> = []
) =>
  Widget.Box({
    vertical: true,
    children: [
      Widget.Box({
        homogeneous: true,
        class_name: "row horizontal",
        children: toggles.map((w) => w()),
      }),
      ...menus.map((w) => w()),
    ],
  });

const Settings = () =>
  Widget.Box({
    vertical: true,
    class_name: "quicksettings vertical",
    // css: quicksettings.width.bind().as((w) => `min-width: ${w}px;`),
    children: [
      // Header(),
      Widget.Box({
        class_name: "sliders-box vertical",
        vertical: true,
        children: [
          Row([Volume], [SinkSelector, AppMixer]),
          Microphone(),
          // Brightness(),
        ],
      }),
      Row([WifiToggle, VpnToggle], [WifiSelection, VpnSelection]),
      Row([BluetoothToggle], [BluetoothDevices]),
      // Row([ProfileToggle, DarkModeToggle], [ProfileSelector]),
      // Row([MicMute, DND]),
      Widget.Box({
        visible: media.as((l) => l.length > 0),
        child: Media(),
      }),
    ],
  });

export const QuickSettings = () =>
  PopupWindow({
    name: "quicksettings",
    exclusivity: "exclusive",
    transition: "slide_down",
    layout: "top-right",
    child: Settings(),
  });
