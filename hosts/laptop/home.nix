{ }
  # let
  #   # --- Variables (Moved out of settings) ---
  #   terminal = "kitty";
  #   browser = "google-chrome-stable";
  #   fileExplorer = "dolphin";
  #
  #   mod = "SUPER";
  #   commandMod = "SUPER+ALT+CTRL";
  #   commandMod2 = "SUPER+CTRL+SHIFT";
  #
  #   display1Mod = "CTRL";
  #   display2Mod = "ALT";
  #   display3Mod = "SUPER";
  #
  #   display2Bus = "2";
  #   display3Bus = "1";
  #   display4Bus = "15";
  #
  #   display1Id = "eDP-2";
  #   display2Id = "HDMI-A-1";
  #   display3Id = "DP-1";
  #   display4Id = "DP-3";
  #
  #   # --- Helper Functions for Bindings ---
  #   # Automatically handles the commandMod .. ', key' pattern
  #   bindCmd = modKey: key: action: {
  #     _args = [
  #       (lib.generators.mkLuaInline "${modKey} .. ', ${key}'")
  #       (lib.generators.mkLuaInline action)
  #     ];
  #   };
  #
  #   # For custom or non-standard keybind expressions
  #   bindCustom = keyExpr: actionExpr: {
  #     _args = [
  #       (lib.generators.mkLuaInline keyExpr)
  #       (lib.generators.mkLuaInline actionExpr)
  #     ];
  #   };
  # in
  # {
  #   wayland.windowManager.hyprland = {
  #     # If you use the Home Manager module, make sure to disable systemd integration, as it conflicts with UWSM.
  #     systemd.enable = false;
  #
  #     settings = {
  #       decoration = {
  #         shadow = {
  #           offset = "0 5";
  #           color = "rgba(00000099)";
  #         };
  #       };
  #
  #       cursor = {
  #         no_hardware_cursors = true;
  #       };
  #
  #       # Monitors
  #       monitor = [
  #         { _args = [ "eDP-2" "2560x1600@60" "auto" "1.33" ]; }
  #         { _args = [ "HDMI-A-1" "3840x2560@49.98" "2560x0" "1.6" ]; } # Huawei
  #         { _args = [ "DP-1" "2560x1600@60" "2560x600" "1.6" ]; }       # Asus portable
  #       ];
  #
  #       # NVIDIA environment
  #       env = [
  #         { _args = [ "LIBVA_DRIVER_NAME" "nvidia" ]; }
  #         { _args = [ "__GLX_VENDOR_LIBRARY_NAME" "nvidia" ]; }
  #         { _args = [ "__GL_VRR_ALLOWED" "1" ]; }
  #         { _args = [ "WLR_DRM_NO_ATOMIC" "1" ]; }
  #       ];
  #
  #       # All windows fully transparent
  #       windowrule = [
  #         { _args = [ "opacity 0" ".*" ]; }
  #       ];
  #
  #       bind = [
  #         # --- Custom & Mouse Binds ---
  #         (bindCustom "mod .. \" + Super_L\"" "hl.dsp.exec_cmd(\"pkill rofi || rofi -show drun\")")
  #         (bindCustom "mod .. \" + F\"" "hl.dsp.exec_cmd(\"librewolf\")")
  #         (bindCustom "\"CONTROL + ALT + T\"" "hl.dsp.exec_cmd(\"wezterm\")")
  #
  #         # Mouse movements
  #         {
  #           _args = [
  #             (lib.generators.mkLuaInline "mod .. \" + mouse:272\"")
  #             (lib.generators.mkLuaInline "hl.dsp.window.drag()")
  #             { mouse = true; }
  #           ];
  #         }
  #         {
  #           _args = [
  #             (lib.generators.mkLuaInline "mod .. \" + mouse:273\"")
  #             (lib.generators.mkLuaInline "hl.dsp.window.resize()")
  #             { mouse = true; }
  #           ];
  #         }
  #         {
  #           _args = [
  #             (lib.generators.mkLuaInline "mod .. \" + ALT + mouse:272\"")
  #             (lib.generators.mkLuaInline "hl.dsp.window.resize()")
  #             { mouse = true; }
  #           ];
  #         }
  #
  #         # --- CommandMod App Launchers & Utilities ---
  #         (bindCmd "commandMod" "0" "hl.dsp.exec_cmd('pkill -x rofi || $scrPath/rofilaunch.sh d')")
  #         (bindCmd "commandMod" "1" "hl.dsp.exec_cmd('$scrPath/dontkillsteam.sh')")
  #         (bindCmd "commandMod" "2" "hl.dsp.exec_cmd('${terminal}')")
  #         (bindCmd "commandMod" "3" "hl.dsp.exec_cmd('${browser}')")
  #         (bindCmd "commandMod" "4" "hl.dsp.exec_cmd('blueman-manager')")
  #         (bindCmd "commandMod" "R" "hl.dsp.exec_cmd('slack')")
  #         (bindCmd "commandMod" "S" "hl.dsp.exec_cmd('firefox')")
  #         (bindCmd "commandMod" "T" "hl.dsp.exec_cmd('~/Applications/Beekeeper-Studio-*.AppImage')")
  #         (bindCmd "commandMod" "U" "hl.dsp.exec_cmd('systemctl --user start docker-desktop')")
  #
  #         # --- Window Focus ---
  #         (bindCmd "commandMod" "5" "hl.dsp.movefocus('l')")
  #         (bindCmd "commandMod" "6" "hl.dsp.movefocus('r')")
  #         (bindCmd "commandMod" "7" "hl.dsp.movefocus('u')")
  #         (bindCmd "commandMod" "8" "hl.dsp.movefocus('d')")
  #
  #         # --- System Controls & Scripts ---
  #         (bindCmd "commandMod" "9" "hl.dsp.exec_cmd('busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n -100')")
  #         (bindCmd "commandMod" "A" "hl.dsp.exec_cmd('busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n +100')")
  #         (bindCmd "commandMod" "B" "hl.dsp.exec_cmd('~/.config/hypr/scripts/display-toggle.sh')")
  #         (bindCmd "commandMod" "V" "hl.dsp.exec_cmd('systemctl suspend')")
  #         (bindCmd "commandMod" "W" "hl.dsp.exec_cmd('~/.config/hypr/scripts/toggle-dp1-monitor.sh')")
  #         (bindCmd "commandMod" "C" "hl.dsp.exec_cmd('~/.config/hypr/scripts/waybar.sh')")
  #         (bindCmd "commandMod" "D" "hl.dsp.exec_cmd('hyprshot -m region')")
  #         (bindCmd "commandMod" "X" "hl.dsp.exec_cmd('~/.config/hypr/scripts/fan-performance.sh')")
  #         (bindCmd "commandMod" "Y" "hl.dsp.exec_cmd('~/.config/hypr/scripts/fan-balanced.sh')")
  #         (bindCmd "commandMod" "M" "hl.dsp.exec_cmd('~/.config/hypr/scripts/kitty-theme.sh')")
  #         (bindCmd "commandMod" "E" "hl.dsp.exec_cmd('playerctl play-pause')")
  #         (bindCmd "commandMod" "Q" "hl.dsp.exec_cmd('bluetooth toggle')")
  #         (bindCmd "commandMod" "Z" "hl.dsp.exec_cmd('~/.config/hypr/scripts/toggle-wifi.py')")
  #
  #         # --- CommandMod2 ---
  #         (bindCmd "commandMod2" "A" "hl.dsp.exec_cmd('timew stop || timew continue')")
  #         (bindCmd "commandMod2" "B" "hl.dsp.exec_cmd('systemctl reboot')")
  #       ];
  #     };
  #   };
  # };
