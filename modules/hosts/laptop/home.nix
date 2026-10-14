{ self, inputs, ... }: {

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
      hello 
    ];

    home.stateVersion = "24.11";
  };

}

