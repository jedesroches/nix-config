{
  pkgs,
  config,
  ...
}:

{

  imports = [
    ../common/system.nix
    ../services/jankyborders
    ../services/sketchybar
    ../services/skhd
    ../services/yabai
  ];

  config = {
    system = {
      stateVersion = 5; # See changelog before changing.

      primaryUser = config.me.username;

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

    security.pam.services.sudo_local.touchIdAuth = true;
    nix = {
      # play around with linux VM builders.
      # should this go in the corresponding flake ?
      linux-builder.enable = true;
      gc.interval = {
        Weekday = 7;
        Hour = 1;
        Minute = 0;
      };
    };

    users = {
      knownUsers = [ config.me.username ];
      users.jde = {
        home = "/Users/" + config.me.username;
        shell = pkgs.fish;
        uid = 501;
      };
    };
    programs.fish.enable = true;
  };
}
