{ lib, ... }:
{
  options = {
    me.username = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "jde";
      readOnly = true;
      description = ''
        My system username (think /etc/passwd).
      '';
    };
  };
}
