{ config, ... }:

{
  home-manager.users.${config.me.username} = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        hide_env_diff = true;
      };
    };
  };
}
