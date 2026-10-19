{ config, ... }:

{
  xdg.configFile = {
    "hypr/hyprland.lua".source =
      config.lib.file.mkOutOfStoreSymlink ./hyprland.lua;

    "hypr/config".source =
      config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
