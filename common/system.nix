{
  config,
  lib,
  pkgs,
  ...
}:

{
  nix = {
    optimise.automatic = true;

    settings = {
      trusted-users = [
        "root"
        config.me.username
      ];

      max-jobs = 4;
      cores = 4;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    extraOptions = ''
      !include ${config.sops.secrets.nix_access_token.path}
    '';

    gc = {
      interval = lib.mkIf pkgs.stdenv.isDarwin {
        Weekday = 7;
        Hour = 1;
        Minute = 0;
      };
      dates = lib.mkIf pkgs.stdenv.isLinux "weekly";

      automatic = true;
      persistent = true; # FIXME: find where it is stored and persist that
      randomizedDelaySec = "5min";
      options = "--delete-older-than 30d";
    };
  };
}
