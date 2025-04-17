{ config, pkgs, ... }:

{
  home-manager.users.${config.me.username} = {
    home.packages = [ pkgs.qrcp ];
    xdg.configFile = {
      "qrcp/config.yml" = {
        text = builtins.toJSON {
          port = 4242;
        };
      };
    };
  };
}
