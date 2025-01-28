{ pkgs, ... }:

{
  imports = [
    ./services/skhd
    ./services/yabai
  ];

  system.stateVersion = 5; # See changelog before changing.
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
    swapLeftCtrlAndFn = true;
  };

  nixpkgs.hostPlatform = "x86_64-darwin";
  nix = {
    # This allows <nixpkgs> to point to our input
    nixPath = [ "nixpkgs=${pkgs.path}" ];

    optimise.automatic = true;
    settings.experimental-features = "nix-command flakes";
    gc = {
      automatic = true;
      options = "--delete-older-then 30d";
      interval = {
        Weekday = 7;
        Hour = 1;
        Minute = 0;
      };
    };
  };

  security.pam.enableSudoTouchIdAuth = true;

  users = {
    knownUsers = [ "jde" ];
    users.jde = {
      home = "/Users/jde";
      shell = pkgs.fish;
      uid = 501;
    };
  };
  programs.fish.enable = true;
}
