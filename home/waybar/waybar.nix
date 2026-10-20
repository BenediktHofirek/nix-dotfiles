{ config,  ... }:

{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      targets = [ "graphical-session.target" ];
    };
  };

  xdg.configFile = {
    "waybar".source =
      config.lib.file.mkOutOfStoreSymlink ./config;
  };

}

