async function resetCss() {
  try {
    const scss = `${App.configDir}/style/main.scss`;
    const css = `/tmp/ags/main.css`;

    // compile, reset, apply
    await Utils.execAsync(`sass ${scss} ${css}`);

    App.applyCss(css, true);
  } catch (error) {
    error instanceof Error ? logError(error) : console.error(error);
  }
}

Utils.monitorFile(
  // directory that contains the scss files
  `${App.configDir}/style`,
  resetCss
);

await resetCss();

export {};
