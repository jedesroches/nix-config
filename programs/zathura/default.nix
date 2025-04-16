{ config, ... }:

{
  home-manager.users.${config.me.username} = {
    programs.zathura = {
      enable = true;
      options = {
        database = "sqlite";
        show-recent = 0;
      };
    };
  };
}
