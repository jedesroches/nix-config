{ pkgs, config, ... }:

{
  home-manager.users.${config.me.username} = {
    home = {
      packages = with pkgs; [ starship-jj ];
      file.starship-jj-config = {
        target = "Library/Application Support/starship-jj/starship-jj.toml";
        source = ./starship-jj.toml;
      };
    };
    programs.starship = {
      enable = true;
      settings = {
        format = "$directory\${custom.jj}$all";
        character = {
          format = "$symbol ";
        };
        cmd_duration = {
          min_time = 5000;
          format = "[($duration)]($style) ";
        };
        custom.jj = {
          command = "starship-jj --ignore-working-copy starship prompt";
          format = "$output";
          when = "jj root --ignore-working-copy";
        };
        git_branch.disabled = true;
        git_commit.disabled = true;
        git_state.disabled = true;
        git_metrics.disabled = true;
        git_status.disabled = true;
        golang = {
          format = "[$symbol]($style)";
        };
        nix_shell = {
          format = "[$symbol]($style) ";
          symbol = "❄️";
          impure_msg = "";
          pure_msg = "";
        };
        package.disabled = true;
        python = {
          format = "[$symbol]$(style)";
        };
        ruby = {
          format = "[$symbol]($style)";
        };
        terraform = {
          format = "[$symbol$workspace]($style) ";
        };
      };
    };
  };
}
