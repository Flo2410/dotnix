{ pkgs, ... }:

pkgs.mkShellNoCC {
  nativeBuildInputs = with pkgs;
    [
      ltex-ls
      temurin-bin-20

      (pkgs.texliveFull.withPackages (p: with p; [
        wrapfig
        amsmath
        ulem
        hyperref
        capt-of
        biblatex
        latexmk
        csquotes
        makecell
        acronym
        bigfoot # suffix.sty
        xstring
        relsize
        numprint
        titlesec
        biber
      ]))

    ];

  shellHook = ''
    unset SOURCE_DATE_EPOCH
  '';
}
