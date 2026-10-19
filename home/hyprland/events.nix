{ lib, ... }:
let
  lua = lib.generators.mkLuaInline;
  on = event: body: {
    _args = [
      event
      (lua "function() ${body} end")
    ];
  };
  startExec = cmd: ''hl.exec_cmd("${cmd}")'';
in
{
  wayland.windowManager.hyprland = {

    settings = {

      on = [
        (on "hyprland.start" ''
          ${startExec "wl-gammarelay-rs && sleep 1 && busctl --user -- set-property rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature q 5000"}
          ${startExec "dunst"}
        '')
      ];

    };

  };
}

