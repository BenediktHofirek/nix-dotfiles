{ lib, ... }:
let
  lua = lib.generators.mkLuaInline;

  display2Bus = 2;
  display3Bus = 1;
  display4Bus = 15;

  # Free: C, W, X, Y
  commandMod = "SUPER+ALT+CTRL";
  bindCommand = key: action: {
    _args = [
      ("${commandMod}" + "+" + "${key}")
      (lua action)
    ];
  };

  bind = key: action: flags: {
    _args = [
      "${key}"
      (lua action)
      (lua (if flags == null then "{ }" else "${flags}"))
    ];
  };

  exec = cmd: ''hl.dsp.exec_cmd("${cmd}")'';
  focusdr = dr: ''hl.dsp.focus({ direction = "${dr}" })'';
in
{
  wayland.windowManager.hyprland = {

    settings = {

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

        # NightShift control
        (bindCommand "9" (
          exec "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n -100"
        ))
        (bindCommand "A" (
          exec "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n +100"
        ))

        # Monitors off 
        (bindCommand "B" (exec "${../../scripts/display-toggle.sh}"))
        (bindCommand "V" (exec "systemctl suspend"))

        # Screenshot
        (bindCommand "D" (exec "hyprshot -m region"))

        # Play / Pause video
        (bindCommand "E" (exec "playerctl play-pause"))

        # Bluetooth
        (bindCommand "Q" (exec "bluetooth toggle"))

        # Reboot
        (bindCommand "B" (exec "systemctl reboot"))

        # Wifi
        (bindCommand "Z" (exec "${../../scripts/toggle-wifi.py}"))

        # Volume
        (bind "XF86AudioRaiseVolume" (exec "${../../scripts/volumecontrol.sh} -o i") "{ repeating = true; locked = true; }")
        (bind "XF86AudioLowerVolume" (exec "${../../scripts/volumecontrol.sh} -o d") "{ repeating = true; locked = true; }")

        # Brightness
        (bind "XF86MonBrightnessUp" (exec "${../../scripts/brightnesscontrol.sh} i $(brightnessctl info | grep -oP '(?<=\()\d+(?=%)' | awk '{n=int(($1+5)/10); print (n<1)?1:n}')") "{ repeating = true; locked = true; }")
        (bind "XF86MonBrightnessDown" (exec "${../../scripts/brightnesscontrol.sh} d $(brightnessctl info | grep -oP '(?<=\()\d+(?=%)' | awk '{n=int(($1+5)/10); print (n<1)?1:n}')") "{ repeating = true; locked = true; }")

        # display 2
        (bindCommand "G" (exec "ddcutil --bus ${toString display2Bus} setvcp 10 + 1")) # increase brightness
        (bindCommand "F" (exec "ddcutil --bus ${toString display2Bus} setvcp 10 - 1")) # decrease brightness

        # display 3
        (bindCommand "I" (exec "ddcutil --bus ${toString display3Bus} setvcp 10 + 1")) # increase brightness
        (bindCommand "H" (exec "ddcutil --bus ${toString display3Bus} setvcp 10 - 1")) # decrease brightness

        # display 4
        (bindCommand "P" (exec "ddcutil --bus ${toString display4Bus} setvcp 10 + 1")) # increase brightness
        (bindCommand "O" (exec "ddcutil --bus ${toString display4Bus} setvcp 10 - 1")) # decrease brightness
      ];

    };
  };
}
