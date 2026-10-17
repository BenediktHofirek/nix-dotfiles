{ lib, ... }:
let
  lua = lib.generators.mkLuaInline;

  # keys are built from the Lua `mod` variable defined below
  bind = key: action: {
    _args = [
      (lua ''mod .. " + ${key}"'')
      (lua action)
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

    settings = {
      on = [
        (on "hyprland.start" ''
          ${startExec "wl-gammarelay-rs"}
          ${startExec "kitty"}
          ${startExec "waybar"}
          ${startExec "hyprpaper"}
          ${startExec "mako"}
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

      mod = {
        _var = "SUPER+ALT+CTRL";
      };

      bind = [
        # launch applications
        (bind "0" (exec "fuzzel"))
        (bind "2" (exec "kitty"))
        (bind "3" (exec "google-chrome"))
        (bind "4" (exec "kitty -e superfile"))
        (bind "R" (exec "slack"))
        (bind "S" (exec "firefox"))

        # windows and focus
        (bind "1" "hl.dsp.window.close()")
        (bind "5" (focusdr "l"))
        (bind "6" (focusdr "r"))
        (bind "7" (focusdr "u"))
        (bind "8" (focusdr "d"))

        # NightShift control
        (bind "9" (
          exec "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n -100"
        ))
        (bind "A" (
          exec "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n +100"
        ))
      ];

      config = {

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
