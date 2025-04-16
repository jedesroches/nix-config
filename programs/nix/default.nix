{ config, ... }:

{
  home-manager.users.${config.me.username}.nix = {
    extraOptions = ''
      !include ${config.sops.secrets.nix_access_token.path}
    '';
    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
