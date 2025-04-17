{
  config,
  lib,
  pkgs,
  ...
}:

let
  onlyLinux = lib.mkIf pkgs.stdenv.isLinux;
  onlyDarwin = lib.mkIf pkgs.stdenv.isDarwin;
in
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
      interval = onlyDarwin {
        Weekday = 7;
        Hour = 1;
        Minute = 0;
      };
      dates = onlyLinux "weekly";

      automatic = true;
      persistent = onlyLinux true; # FIXME: find where it is stored and persist that
      randomizedDelaySec = onlyLinux "5min";
      options = "--delete-older-than 30d";
    };
  };
}
