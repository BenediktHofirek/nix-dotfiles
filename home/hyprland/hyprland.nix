{ config, ... }:

# To allow home-manager to take care of other hyprland utilities like hyprpaper
# we need not to replace whole hypr directory, but just to symlink hyprland.lua
{
  xdg.configFile = {
    "hypr/hyprland.lua".source =
      config.lib.file.mkOutOfStoreSymlink ./hyprland.lua;

    "hypr/config".source =
      config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
