import { bash, dependencies, sh } from "lib/utils";

interface Device {
  dev: String;
  dev_class: "backlight" | "leds";
}

const screen: Device = {
  dev: await bash`ls -w1 /sys/class/backlight | head -1`,
  dev_class: "backlight",
};
const kbd: Device = {
  dev: await bash`ls -w1 /sys/class/leds | head -1`,
  dev_class: "leds",
};

const getSync = (dev: Device, entitiy: "brightness" | "max_brightness") =>
  Number(Utils.readFile(`/sys/class/${dev.dev_class}/${dev.dev}/${entitiy}`));

const get = async (dev: Device, entitiy: "brightness" | "max_brightness") =>
  Utils.readFileAsync(`/sys/class/${dev.dev_class}/${dev.dev}/${entitiy}`);

const set = async (dev: Device, value: Number) =>
  bash`echo ${value} > /sys/class/${dev.dev_class}/${dev.dev}/brightness`; // FIXME: Using echo is a workaround.

class Brightness extends Service {
  static {
    Service.register(
      this,
      {},
      {
        screen: ["int", "rw"],
        kbd: ["int", "rw"],
      }
    );
  }

  #kbdMax = getSync(kbd, "max_brightness");
  #kbd = Math.round((getSync(kbd, "brightness") / this.#kbdMax) * 100);
  #screenMax = getSync(screen, "max_brightness");
  #screen = Math.round((getSync(screen, "brightness") / this.#screenMax) * 100);

  get kbd() {
    return this.#kbd;
  }
  get screen() {
    return this.#screen;
  }

  set kbd(percent) {
    if (percent < 0) percent = 0;
    if (percent > 100) percent = 100;

    const value = Math.round((percent / 100) * this.#kbdMax);

    set(kbd, value).then(() => {
      this.#kbd = percent;
      this.changed("kbd");
    });
  }

  set screen(percent) {
    if (percent < 0) percent = 0;
    if (percent > 100) percent = 100;

    const value = Math.round((percent / 100) * this.#screenMax);

    set(screen, value).then(() => {
      this.#screen = percent;
      this.changed("screen");
    });
  }

  constructor() {
    super();

    const screenPath = `/sys/class/${screen.dev_class}/${screen.dev}/brightness`;
    const kbdPath = `/sys/class/${kbd.dev_class}/${kbd.dev}/brightness`;

    Utils.monitorFile(screenPath, async (f) => {
      this.#screen = Math.round(
        (Number(await get(screen, "brightness")) / this.#screenMax) * 100
      );
      this.changed("screen");
    });

    Utils.monitorFile(kbdPath, async (f) => {
      this.#kbd = Math.round(
        (Number(await get(kbd, "brightness")) / this.#kbdMax) * 100
      );
      this.changed("kbd");
    });
  }
}

export default new Brightness();
