{ ... }:

{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Joachim Desroches";
        email = "jdesroches@kleis.ch";
      };
      ui = {
        default-command = "status";
        diff-format = "git";
        pager = "less -FRX";
      };
      revsets = {
        log =  "@ | ancestors(remote_bookmarks().., 2) | trunk()";
      };
    };
  };
}
