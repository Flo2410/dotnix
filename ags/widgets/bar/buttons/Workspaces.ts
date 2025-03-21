import { PanelButton } from "../PanelButton";
import { sh } from "lib/utils";

const hyprland = await Service.import("hyprland");

const dispatch = (arg: string | number) => {
  sh(`hyprctl dispatch workspace ${arg}`);
};

const WorkspacesBox = (monitor: number) =>
  Widget.Box({
    children: hyprland.bind("workspaces").as((workspaces) =>
      workspaces
        .filter(
          (ws) => ws.monitorID === monitor && !ws.name.includes("special")
        )
        .sort((a, b) => a.id - b.id)
        .map((ws) =>
          Widget.Label({
            attribute: ws.id,
            vpack: "center",
            label: `${ws.id}`,
            setup: (self) =>
              self.hook(hyprland, () => {
                self.toggleClassName(
                  "active",
                  hyprland.active.workspace.id === ws.id
                );
                self.toggleClassName(
                  "occupied",
                  (hyprland.getWorkspace(ws.id)?.windows || 0) > 0
                );
                self.toggleClassName(
                  "fullscreen",
                  hyprland.getWorkspace(ws.id)?.hasfullscreen
                );
              }),
          })
        )
    ),
  });

export const Workspaces = (monitor = 0) =>
  PanelButton({
    window: "overview",
    class_name: "workspaces",
    on_scroll_up: () => dispatch("m+1"),
    on_scroll_down: () => dispatch("m-1"),
    child: WorkspacesBox(monitor),
  });
