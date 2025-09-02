{ pkgs, config, ... }:

{
  home-manager.users.${config.me.username} = {
    programs.fish = {
      enable = true;
      shellInit = "fish_vi_key_bindings";
      shellAbbrs = {
        l = "ls";
        ll = "ls -lh";
        mail = "neomutt";
      };
      functions = {
        fish_greeting = "";
      };
      plugins = [
        {
          name = "z";
          src = pkgs.fishPlugins.z.src;
        }
      ];
    };
  };
}
