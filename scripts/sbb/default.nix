{ pkgs, ... }:

{
  home.packages = with pkgs;
    [
      (writeShellApplication {
        name = "sbb";
        runtimeInputs = [ curl jq ];
        text = builtins.readFile ./sbb.sh;
      })
    ];
}
