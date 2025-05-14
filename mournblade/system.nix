_:

{
  imports = [
    ../common/system.nix
  ];
  nix = {
    gc = {
      dates = "weekly";
      persistent = true;
      randomizedDelaySec = "5min";
    };
  };
}
