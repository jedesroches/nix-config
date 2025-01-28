{ pkgs, ... }:

{
  home.packages = with pkgs;
    [
      (writeShellApplication {
        name = "jj-gh-pr";
        runtimeInputs = [ jujutsu gh ];
        text = builtins.readFile ./jj-gh-pr.sh;
      })
    ];
}
