{
  # load esp-idf
  # "load.idf" = ". $HOME/esp/esp-idf/export.sh";

  # Find & Delete all ".DS_Store" files (recursive)
  # "delete.ds" = "find . -name '.DS_Store' -type f -print -delete";

  # mounts
  "mount.florian" = "sudo mount -t cifs  //sagittarius-a.hye.network/florian /mnt/florian -o user=florian,uid=1000,gid=1000,dir_mode=0755,file_mode=0755";
  "mount.win11" = "sudo mount -t cifs  //192.168.122.196/c /mnt/win11_c -o user=florian,uid=1000,gid=1000,dir_mode=0755,file_mode=0755";

  # git
  gap = "git add -p";

  # custom stuff
  "mjölnir" = "~/syncthing/Development/reverse-engineering/Mjölnir/mjölnir.sh";
  # clip = ''if [ "$TERM" = "xterm-kitty" ]; then kitty +kitten clipboard; else wl-copy; fi'';

  #docker
  # "docker.rm-dangling" = "docker rmi \$(docker images --filter 'dangling=true' -q --no-trunc)";

  #exit
  xx = "exit";

  pkgs = "nix-shell --command nu -p";

  # open = "xdg-open";
  cat = "bat";
  # ls = "eza --icons -g";
  # grep = "rg";
  c = "code .";
  z = "zededitor .";
}
