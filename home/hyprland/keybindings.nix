{ ... }@inputs:
let
  common = import ./common/_default.nix inputs;
in
{
  wayland.windowManager.hyprland.settings = with common; {
    bind = [
      # launch applications
      (bindCommand "0" (exec "fuzzel"))
      (bindCommand "2" (exec "kitty"))
      (bindCommand "3" (exec "google-chrome"))
      (bindCommand "4" (exec "kitty -e superfile"))
      (bindCommand "R" (exec "slack"))
      (bindCommand "S" (exec "firefox"))
      (bindCommand "T" (exec "beekeeper-studio"))
      (bindCommand "U" (exec "podman-desktop"))

      # windows and focus
      (bindCommand "1" "hl.dsp.window.close()")
      (bindCommand "5" (focusdr "l"))
      (bindCommand "6" (focusdr "r"))
      (bindCommand "7" (focusdr "u"))
      (bindCommand "8" (focusdr "d"))

      # NightShift
      (bindCommand "9" (exec "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n -100"))
      (bindCommand "A" (exec "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n +100"))

      # Monitors off / suspend / reboot
      (bindCommand "B" (exec "${../../scripts/display-toggle.sh}"))
      (bindCommand "V" (exec "systemctl suspend"))
      (bindCommand "N" (exec "systemctl reboot"))

      (bindCommand "D" (exec "hyprshot -m region"))
      (bindCommand "E" (exec "playerctl play-pause"))
      (bindCommand "Q" (exec "bluetooth toggle"))
      (bindCommand "Z" (exec "${../../scripts/toggle-wifi.py}"))

      # Volume
      (repeatBind "XF86AudioRaiseVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
      (repeatBind "XF86AudioLowerVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))

      # Brightness
      (repeatBind "XF86MonBrightnessUp" (exec "${../../scripts/brightness.sh} up"))
      (repeatBind "XF86MonBrightnessDown" (exec "${../../scripts/brightness.sh} down"))

      # display 2
      (repeatCommand "G" (ddcBrightnessUp display2Bus))
      (repeatCommand "F" (ddcBrightnessDown display2Bus))

      # display 3
      (repeatCommand "I" (ddcBrightnessUp display3Bus))
      (repeatCommand "H" (ddcBrightnessDown display3Bus))

      # display 4
      (repeatCommand "P" (ddcBrightnessUp display4Bus))
      (repeatCommand "O" (ddcBrightnessDown display4Bus))

    ];

  };
}
