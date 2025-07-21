{ pkgs, config, ... }:

{
  home-manager.users.${config.me.username} = {
    home.packages = with pkgs; [
      (writeShellApplication {
        name = "jjm";
        runtimeInputs = [
          unstable.jujutsu
        ];
        text = builtins.readFile ./jjm.sh;
      })
    ];
  };
}
