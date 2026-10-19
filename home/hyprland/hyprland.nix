{ lib, ... }:
let
  lua = lib.generators.mkLuaInline;

  bindCommand = key: action: {
    _args = [
      (lua ''commandMod .. " + ${key}"'')
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

  on = event: body: {
    _args = [
      event
      (lua "function() ${body} end")
    ];
  };

  exec = cmd: ''hl.dsp.exec_cmd("${cmd}")'';
  startExec = cmd: ''hl.exec_cmd("${cmd}")'';
  focusdr = dr: ''hl.dsp.focus({ direction = "${dr}" })'';
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = ''
      env = HYPRCURSOR_THEME,"rose-pine-hyprcursor"
      env = HYPRCURSOR_SIZE,24
    '';

    settings = {

      commandMod = {
        # Free: C, W, X, Y
        _var = "SUPER+ALT+CTRL";
      };

      on = [
        (on "hyprland.start" ''
          ${startExec "wl-gammarelay-rs && sleep 0.1 && busctl --user -- set-property rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature q 5000"}
          ${startExec "kitty"}
          ${startExec "dunst"}
        '')
      ];

      monitor = [
        {
          output = "eDP-2";
          mode = "2560x1600@60";
          position = "auto";
          scale = 1.33;
        }
        {
          output = "HDMI-A-1";
          mode = "3840x2560@49.98";
          position = "2560x0";
          scale = 1.6;
        }
        {
          output = "DP-1";
          mode = "2560x1600@60";
          position = "2960x1600";
          scale = 1.6;
        }
      ];

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
        (bindCommand "B" (exec "${../scripts/display-toggle.sh}"))
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
        (bindCommand "Z" (exec "../scripts/toggle-wifi.py"))

        (bind "XF86MonBrightnessUp" (exec "${../scripts/brightnesscontrol.sh} i $(brightnessctl info | grep -oP '(?<=\()\d+(?=%)' | awk '{n=int(($1+5)/10); print (n<1)?1:n}')") "{ repeating = true; locked = true; }")
        (bind "XF86MonBrightnessDown" (exec "${../scripts/brightnesscontrol.sh} d $(brightnessctl info | grep -oP '(?<=\()\d+(?=%)' | awk '{n=int(($1+5)/10); print (n<1)?1:n}')") "{ repeating = true; locked = true; }")

        (bind "XF86AudioRaiseVolume" (exec "${../scripts/volumecontrol.sh} -o i") "{ repeating = true; locked = true; }")
        (bind "XF86AudioLowerVolume" (exec "${../scripts/volumecontrol.sh} -o d") "{ repeating = true; locked = true; }")
      ];

      config = {

        animations = {
          enabled = false;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          force_default_wallpaper = 0;
        };

        general = {
          layout = "dwindle";
        };

        dwindle = {
          force_split = 0;
          preserve_split = true;
          smart_split = false;
          smart_resizing = true;
          permanent_direction_override = false;
          special_scale_factor = 1.0;
          split_width_multiplier = 1.0;
          use_active_for_splits = true;
          default_split_ratio = 1.0;
          split_bias = 0;
          precise_mouse_move = false;
        };

        cursor = {
          enable_hyprcursor = true;
          no_hardware_cursors = 0;
        };

        decoration = {
          rounding = 0;
          blur = {
            enabled = false;
          };
          shadow = {
            enabled = false;
          };
          active_opacity = 1.0;
          inactive_opacity = 1.0;
        };
      };

    };
  };
}
