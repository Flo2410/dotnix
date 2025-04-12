{
  pkgs,
  stdenv,
}:
stdenv.mkDerivation rec {
  name = "mkShell";
  pname = "mkshell";

  shells = ../nix/shells;

  src = pkgs.writeShellScript pname ''
    set -e

    # Check if name is provided
    if [ -z "$1" ]; then
      printf "Usage: mkshell <shell>\n"
      printf "  Available shells: latex, rust\n"
      exit 1
    fi

    # Check if shell.nix or .envrc already exist
    if [ -f shell.nix ] || [ -f .envrc ]; then
      printf "\e[31mshell.nix or .envrc already exist\n"
      exit 1
    fi

    if [ "$1" = "latex" ]; then
      cp ${shells}/latex.nix shell.nix
    elif [ "$1" = "rust" ]; then
      cp ${shells}/rust.nix shell.nix
    elif [ "$1" = "cpp" ]; then
      cp ${shells}/cpp.nix shell.nix
    elif [ "$1" = "python" ]; then
      cp ${shells}/python.nix shell.nix
    else
      printf "\e[31mNo shell available for: $1\n"
      exit 1
    fi

    # Create .envrc
    printf "use nix\n" > .envrc

    # Check if .gitignore does not exist
    if [ ! -f .gitignore ]; then
      printf "Downloading .gitignore for $1\n"

      if [ "$1" = "latex" ]; then
        ${pkgs.curl}/bin/curl https://raw.githubusercontent.com/github/gitignore/refs/heads/main/TeX.gitignore --output .gitignore --silent
      elif [ "$1" = "rust" ]; then
        ${pkgs.curl}/bin/curl https://raw.githubusercontent.com/github/gitignore/refs/heads/main/Rust.gitignore --output .gitignore --silent
      elif [ "$1" = "cpp" ]; then
        ${pkgs.curl}/bin/curl https://raw.githubusercontent.com/github/gitignore/refs/heads/main/C%2B%2B.gitignore --output .gitignore --silent
      elif [ "$1" = "python" ]; then
        ${pkgs.curl}/bin/curl https://raw.githubusercontent.com/github/gitignore/refs/heads/main/Python.gitignore --output .gitignore --silent
      else
        printf "\e[31mNo .gitignore for: $1\n"
        exit 1
      fi

      printf "\n# direnv\n.direnv/\n" >> .gitignore
    else
      printf "\e[33m.gitignore already exists\n"
    fi
  '';

  dontUnpack = true;

  installPhase = ''
    install -D ${src} $out/bin/${pname}
  '';
}
