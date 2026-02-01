{}:
builtins.toJSON {
  online = {
    prefix = "@online";
    body = [
      "@online{web:$1,"
      "  title   = {{$2}},"
      "  author  = {{$3}},"
      "  url     = {$4},"
      "  year    = {$5},"
      "  month   = {$6},"
      "  urldate = {$7}"
      "}$0"
    ];
    "description" = "Cite a website";
  };
}
