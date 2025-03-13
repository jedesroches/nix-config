{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    shellInit = "fish_vi_key_bindings";
    shellAbbrs = {
      mail = "neomutt";
    };
    functions = {
      fish_greeting = "";
      fish_jj_prompt = {
        description = "Write out the jj prompt";
        body = builtins.readFile ./fish_jj_prompt.fish;
      };
      fish_vcs_prompt = {
        description = "Print all vcs prompts";
        body = builtins.readFile ./fish_vcs_prompt.fish;
      };
      fish_prompt = {
        description = "Print CLI prompt";
        body = builtins.readFile ./fish_prompt.fish;
      };
    };
    plugins = [
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
    ];
  };
}
