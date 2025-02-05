{ pkgs, ... }:

{
  home.packages = with pkgs; [ difftastic ];
  programs = {
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Joachim Desroches";
          email = "jdesroches@kleis.ch";
        };
        fix = {
          tools = {
            gofmt = {
              command = [
                "gofmt"
                "-s"
              ];
              patterns = [ "glob:'**/*.go'" ];
            };
            nixfmt = {
              command = [
                "nixfmt"
                "-svf"
                "$path"
              ];
              patterns = [ "glob:'**/*.nix'" ];
            };
            statix = {
              command = [
                "statix"
                "fix"
                "-s"
              ];
              patterns = [ "glob:'**/*.nix'" ];
            };
          };
        };
        git = {
          push-bookmark-prefix = "jde/push-";
        };
        ui = {
          default-command = "status";
          diff = {
            tool = [
              "difft"
              "--color=always"
              "$left"
              "$right"
            ];
          };
          movement = {
            edit = true;
          };
          pager = "less -FRX";
        };
        merge-tools.vimdiff.merge-tool-edits-conflict-markers = true;
        revsets.log = "@ | ancestors(remote_bookmarks().., 2) | trunk()";
      };
    };
    fish = {
      shellAbbrs = {
        jjb = "jj bookmark";
        jjd = "jj diff";
        jje = "jj edit";
        jjf = "jj git fetch";
        jjla = "jj log -r '@ | ancestors(remote_bookmarks()::, 2) | trunk()::'";
        jjl = "jj log";
        jjp = "jj git push";
        jjr = "jj rebase";
        jjrm = "jj rebase -d main";
        jjw = "jj desc -m ";
      };
    };
  };
}
