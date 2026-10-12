{ inputs, self, pkgs, ... }: {
  flake.homeConfigurations.hero = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      {
        home = {
          username = "hero";
          homeDirectory = "/home/hero";
          stateVersion = "25.11"; # Match your nixpkgs/home-manager version
        };

        # Let Home Manager manage itself
        programs.home-manager.enable = true;

        # Basic Bash shell setup
        programs.bash = {
          enable = true;
          shellAliases = {
            ll = "ls -l";
            update = "home-manager switch --flake .#hero";
          };
        };

        # Kitty Terminal Configuration
        programs.kitty = {
          enable = true;
          settings = {
            font_size = 12;
            background_opacity = "0.95";
            confirm_os_window_close = 0;
          };
        };

        # Tmux Configuration
        programs.tmux = {
          enable = true;
          prefix = "C-a";
          mouse = true;
          keyMode = "vi";
          extraConfig = ''
            # Additional tmux settings if needed
            set -g base-index 1
          '';
        };
      }
    ];
  };
}
