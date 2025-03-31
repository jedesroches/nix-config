{
  nixpkgs,
  pkgs,
  lib,
  ...
}:

{
  options = {
    username = lib.mkOption {
      type = lib.types.string;
    };
  };
  imports = [
    ./services/jankyborders
    ./services/sketchybar
    ./services/skhd
    ./services/yabai
  ];
  config = {
    system = {
      stateVersion = 5; # See changelog before changing.

      activationScripts.postUserActivation.text = ''
        # activateSettings -u will reload the settings from the database and apply
        # them to the current session, so we do not need to logout and login again
        # to make the changes take effect.
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';

      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
        swapLeftCtrlAndFn = true;
      };

      defaults = {
        NSGlobalDomain = {
          AppleICUForce24HourTime = true;
          AppleInterfaceStyle = "Dark";
          AppleMeasurementUnits = "Centimeters";
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          AppleShowScrollBars = "WhenScrolling";
          AppleTemperatureUnit = "Celsius";
          _HIHideMenuBar = true;
          "com.apple.mouse.tapBehavior" = 1;
          "com.apple.swipescrolldirection" = false;
        };
        WindowManager = {
          AutoHide = false;
          EnableTilingByEdgeDrag = false;
          EnableTiledWindowMargins = false;
          GloballyEnabled = false;
        };

        controlcenter = {
          AirDrop = false;
          BatteryShowPercentage = true;
          FocusModes = false;
        };

        dock = {
          autohide = true;
          orientation = "left";
        };
      };
    };

    nixpkgs.hostPlatform = "x86_64-darwin";
    nix = {
      # Make `nix run nixpkgs#...` use the same nixpkgs as this flake's
      registry.nixpkgs.flake = nixpkgs;
      # This allows <nixpkgs> to point to our input
      nixPath = [ "nixpkgs=${nixpkgs.outPath}" ];

      optimise.automatic = true;
      settings = {
        experimental-features = "nix-command flakes";
        trusted-users = [
          "root"
          "jde"
        ];
      };
      gc = {
        automatic = true;
        options = "--delete-older-than 30d";
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
  };
}
