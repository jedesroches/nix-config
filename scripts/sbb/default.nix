{ pkgs, config, ... }:

{
  home-manager.users.${config.me.username} = {
    home.packages = with pkgs; [
      (writeShellApplication {
        name = "sbb";
        runtimeInputs = [
          curl
          jq
        ];
        text = builtins.readFile ./sbb.sh;
      })
    ];
  };
}
