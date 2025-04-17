{ config, ... }:

{
  home-manager.users.${config.me.username} = {
    programs.ssh = {
      enable = true;
      matchBlocks = {
        "synokleis" = {
          hostname = "192.168.1.6";
          user = "jde";
        };
        "kleisap" = {
          hostname = "192.168.1.2";
          user = "root";
        };
      };
    };
  };
}
