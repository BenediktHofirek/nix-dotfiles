{ self, inputs, config, ... }: {

  flake.homeConfigurations.hero = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    modules = [
      self.homeModules.heroModule
    ];
  };

  flake.homeModules.heroModule = { pkgs, ... }: {
    programs.bash.enable = true;
    programs.bash.shellAliases.ll = "ls -l";

    home.username = "hero";
    home.homeDirectory = "/home/hero";

    home.packages = with pkgs; [ 
      git
      vim
      nano
      wget
      curl

      waybar
      fuzzel

      kitty 
      superfile

      google-chrome
      firefox
    ];

    programs.waybar.enable = true;
    programs.fuzzel.enable = true;

    xdg.configFile."niri/config.kdl".source =
      pkgs.runCommand "niri-config-checked"
        {
          nativeBuildInputs = [ pkgs.niri ];
        }
        ''
          niri validate --config ${./niri-config.kdl}
          cp ${./niri-config.kdl} $out
        '';

    home.stateVersion = "24.11";
  };

}

