{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {

    enable = true;

    # Important when using Home Manager with SDDM
    systemd.enable = true;

    settings = {

      "$mod" = "SUPER";

      monitor = [
        ",preferred,auto,1"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
      };


      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
        };
      };


      input = {
        kb_layout = "us";
        follow_mouse = 1;
      };


      "$terminal" = "kitty";


      exec-once = [
        "waybar"
        "dunst"
      ];


      bind = [

        "$mod, RETURN, exec, kitty"

        "$mod, D, exec, rofi -show drun"

        "$mod, Q, killactive"

        "$mod, F, fullscreen"

        "$mod SHIFT, E, exit"

      ];


      bindm = [

        "$mod, mouse:272, movewindow"

        "$mod, mouse:273, resizewindow"

      ];
    };
  };
}
