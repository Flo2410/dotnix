import { PanelButton } from "../PanelButton";

const time = Variable("", {
  poll: [1000, 'date "+%d.%m.%Y | %H:%M:%S"'],
});

export const Date = () =>
  PanelButton({
    window: "datemenu",
    on_clicked: () => App.toggleWindow("datemenu"),
    child: Widget.Label({
      justification: "center",
      label: time.bind(),
    }),
  });
