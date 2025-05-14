{
  config,
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
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };
}
