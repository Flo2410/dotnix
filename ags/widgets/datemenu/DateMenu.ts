// import NotificationColumn from "./NotificationColumn";
import PopupWindow from "widgets/PopupWindow";
import DateColumn from "./DateColumn";

const Settings = () =>
  Widget.Box({
    class_name: "datemenu horizontal",
    vexpand: false,
    children: [
      // NotificationColumn(),
      // Widget.Separator({ orientation: 1 }),
      DateColumn(),
    ],
  });

export const DateMenu = () =>
  PopupWindow({
    name: "datemenu",
    exclusivity: "exclusive",
    transition: "slide_down",
    layout: "top",
    child: Settings(),
  });
