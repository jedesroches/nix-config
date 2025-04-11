{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "jj-gh-pr";
      runtimeInputs = [
        unstable.jujutsu
        gh
      ];
      text = builtins.readFile ./jj-gh-pr.sh;
    })
  ];
}
