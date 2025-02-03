{ pkgs, ... }:

{
  home.packages = with pkgs; [
    difftastic
  ];
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Joachim Desroches";
        email = "jdesroches@kleis.ch";
      };
      ui = {
        default-command = "status";
        diff = {
          tool = ["difft" "--color=always" "$left" "$right"];
        };
        pager = "less -FRX";
      };
      revsets = {
        log =  "@ | ancestors(remote_bookmarks().., 2) | trunk()";
      };
    };
  };
}
