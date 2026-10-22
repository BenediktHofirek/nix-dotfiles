{ pkgs, ... }:

{
  # Not disponible as a module
  home.packages = with pkgs; [ tuicr ];
  
  xdg.configFile."tuicr/config.toml".text = ''
    theme = "github-light"
    leader = " "
  '';
}
