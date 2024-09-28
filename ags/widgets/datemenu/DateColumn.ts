const time = Variable("", {
  poll: [1000, 'date "+%H:%M:%S"'],
});

export default () =>
  Widget.Box({
    vertical: true,
    class_name: "date-column vertical",
    children: [
      Widget.Box({
        class_name: "clock-box",
        vertical: true,
        children: [
          Widget.Label({
            class_name: "clock",
            label: time.bind(),
          }),
        ],
      }),
      Widget.Box({
        class_name: "calendar",
        children: [
          Widget.Calendar({
            hexpand: true,
            hpack: "center",
          }),
        ],
      }),
    ],
  });
