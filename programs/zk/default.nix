{ config, ... }:

{
  home-manager.users.${config.me.username} = {
    programs.zk = {
      enable = true;
      settings = {
        # Configures the default notebook location.
        notebook = {
          dir = "~/notes";
        };
      };
    };
    programs.fzf = {
      enable = true;
    };
  };
}
