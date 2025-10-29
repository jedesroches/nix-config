{ pkgs, config, ... }:
{
  home-manager.users.${config.me.username} = {
    programs = {
      gh.enable = true;
      gh-dash = {
        enable = true;
        package = pkgs.unstable.gh-dash;
        settings = {
          smartFilteringAtLaunch = false;
          showAuthorIcons = false;
          prSections = [
            {
              title = "My Pull Requests";
              filters = "is:open author:@me";
            }
            {
              title = "Needs My Review";
              filters = "is:open review-requested:@me draft:false -author:app/dependabot";
            }
            {
              title = "Dependency Upgrades";
              filters = "is:open review-requested:@me draft:false author:app/dependabot";
            }
          ];
          defaults.preview.width = 120;
          theme = {
            ui = {
              sectionsShowCount = true;
              table.compact = false;
            };
            colors = {
              text = {
                primary = "#cdd6f4";
                secondary = "#a6e3a1";
                inverted = "#11111b";
                faint = "#bac2de";
                warning = "#f9e2af";
                success = "#a6e3a1";
                error = "#f38ba8";
              };
              background.selected = "#313244";
              border = {
                primary = "#a6e3a1";
                secondary = "#45475a";
                faint = "#313244";
              };
            };
          };
        };
      };
    };
  };
}
