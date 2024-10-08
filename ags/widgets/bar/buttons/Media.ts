import { type MprisPlayer } from "types/service/mpris";
import { PanelButton } from "../PanelButton";
import { icons } from "lib/icons";
import { icon } from "lib/utils";

const mpris = await Service.import("mpris");

const preferred = "spotify";
const direction: "right" | "left" = "right";
const format = "{artists} - {title}";
const length = 40;

const getPlayer = (name = preferred) =>
  mpris.getPlayer(name) || mpris.players[0] || null;

const Content = (player: MprisPlayer) => {
  const revealer = Widget.Revealer({
    click_through: true,
    visible: length > 0,
    transition: `slide_${direction}`,
    setup: (self) => {
      let current = "";
      let play_back_status = "";
      self.hook(player, () => {
        const reveal = () => {
          self.reveal_child = true;
          Utils.timeout(3000, () => {
            !self.is_destroyed && (self.reveal_child = false);
          });
        };

        if (current !== player.track_title) {
          current = player.track_title;
          play_back_status = player.play_back_status;
          reveal();
        } else if (play_back_status !== player.play_back_status) {
          current = player.track_title;
          play_back_status = player.play_back_status;

          if (play_back_status === "Playing") reveal();
        }
      });
    },
    child: Widget.Label({
      truncate: "end",
      max_width_chars: length > 0 ? length : -1,
      label: Utils.merge(
        [player.bind("track_title"), player.bind("track_artists")],
        () =>
          `${format}`
            .replace("{title}", player.track_title)
            .replace("{artists}", player.track_artists.join(", "))
            .replace("{artist}", player.track_artists[0] || "")
            .replace("{album}", player.track_album)
            .replace("{name}", player.name)
            .replace("{identity}", player.identity)
      ),
    }),
  });

  const playericon = Widget.Icon({
    icon: Utils.merge([player.bind("entry")], (e) => {
      return icon(e, icons.fallback.audio);
    }),
  });

  return Widget.Box({
    attribute: { revealer },
    children:
      direction === "right" ? [playericon, revealer] : [revealer, playericon],
  });
};

export const Media = () => {
  let player = getPlayer();

  const btn = PanelButton({
    class_name: "media",
    child: Widget.Icon(icons.fallback.audio),
  });

  const update = () => {
    player = getPlayer();
    btn.visible = !!player;

    if (!player) return;

    const content = Content(player);
    const { revealer } = content.attribute;
    btn.child = content;
    btn.on_primary_click = () => {
      player.playPause();
    };
    btn.on_secondary_click = () => {
      player.playPause();
    };
    btn.on_hover = () => {
      revealer.reveal_child = true;
    };
    btn.on_hover_lost = () => {
      revealer.reveal_child = false;
    };
  };

  return btn.hook(mpris, update, "notify::players");
};
