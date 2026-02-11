{}:
builtins.toJSON {
  tit = {
    prefix = "\\tit";
    body = ["\\textit{$0}"];
    description = "Text italic";
  };

  ttt = {
    prefix = "\\ttt";
    body = ["\\texttt{$0}"];
    description = "Text Typewriter";
  };

  volt = {
    prefix = "\\volt";
    body = ["\\SI{$1}{\\volt}$0"];
    description = "SI Volt";
  };

  acronym = {
    prefix = "\\a";
    body = ["\\ac{$1}$0"];
    description = "Acronym";
  };

  fig = {
    prefix = "\\fig";
    description = "Create a Figure with label and caption";
    body = [
      "\\begin{figure}[H]"
      "  \\centering"
      "  \\includegraphics[width=\\linewidth]{\${1:sections}}"
      "  \\caption{$2}"
      "  \\label{fig:$3}"
      "\\end{figure}$0"
    ];
  };

  autoref = {
    prefix = "\\ar";
    body = ["\\autoref{$1}$0"];
    description = "Autoref";
  };

  autoreffig = {
    prefix = "\\arfig";
    body = ["\\autoref{fig:$1}$0"];
    description = "Autoref a figure";
  };

  declare_acronym = {
    prefix = "\\da";
    description = "Declare an acronym";
    body = ["\\DeclareAcronym{$1}{short = $2, long = $3}$0"];
  };

  cite = {
    prefix = "\\c";
    description = "Cite a source";
    body = ["\\cite{$1}$0"];
  };

  itemize = {
    prefix = "\\itemize";
    description = "Create a itemize list";
    body = [
      "\\begin{itemize}"
      "  \\item $0"
      "\\end{itemize}"
    ];
  };
}
