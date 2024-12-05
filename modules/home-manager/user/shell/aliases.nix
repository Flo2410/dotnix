{
  # go into the programming folder
  "go.dev" = "cd ~/syncthing/Development";
  "go.node" = "cd ~/syncthing/Development/node";
  "go.react" = "cd ~/syncthing/Development/react";
  "go.dpl" = "cd ~/syncthing/Development/node/dpl_v4";
  "go.esp" = "cd ~/syncthing/Development/esp";
  "go.rust" = "cd ~/syncthing/Development/rust";

  # go into fhwn folders
  "go.fhwn" = "cd ~/syncthing/FHWN/";
  "go.bac" = "cd ~/syncthing/FHWN/BRO/6_Semester_S2023/BAC";
  "go.aero" = "go.fhwn && cd AERO/2_Semester_SS24/";

  # load esp-idf
  "load.idf" = ". $HOME/esp/esp-idf/export.sh";

  # settings
  "settings.conda.show_env" = "conda config --set changeps1 true";
  "settings.conda.hide_env" = "conda config --set changeps1 false";

  # Find & Delete all ".DS_Store" files (recursive)
  "delete.ds" = "find . -name '.DS_Store' -type f -print -delete";

  # mounts
  "mount.florian" = "sudo mount -t cifs  //sagittarius-a.hye.network/florian /mnt/florian -o user=florian,uid=1000,gid=1000,dir_mode=0755,file_mode=0755";
  "mount.win11" = "sudo mount -t cifs  //192.168.122.196/c /mnt/win11_c -o user=florian,uid=1000,gid=1000,dir_mode=0755,file_mode=0755";

  "zsh.reload" = ". ~/.zshrc";

  # git
  gap = "git add -p";

  # custom stuff
  "mjölnir" = "~/syncthing/Development/reverse-engineering/Mjölnir/mjölnir.sh";
  ros2-docker = "~/syncthing/Development/ros/ros2-docker/ros2-docker.sh";
  clip = ''if [ "$TERM" = "xterm-kitty" ]; then kitty +kitten clipboard; else wl-copy; fi'';

  #docker
  "docker.rm-dangling" = "docker rmi \$(docker images --filter 'dangling=true' -q --no-trunc)";

  #exit
  xx = "exit";

  pkgs = "nix-shell --command zsh -p";

  open = "xdg-open";
  cat = "bat";
  ls = "eza --icons -g";
  grep = "rg";
}
