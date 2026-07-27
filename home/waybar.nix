{ ... }:

{
  programs.waybar = {

    enable = true;


    settings = {

      mainBar = {

        layer = "top";

        position = "top";

        height = 30;


        modules-left = [
          "hyprland/workspaces"
        ];


        modules-center = [
          "hyprland/window"
        ];


        modules-right = [
          "pulseaudio"
          "clock"
        ];


        clock = {
          format = "{:%H:%M}";
        };


        pulseaudio = {
          format = "{volume}%";
        };
      };
    };
  };
}
