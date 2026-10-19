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
          ${startExec "wl-gammarelay-rs"}
          ${startExec "sh -c 'until busctl --user status rs.wl-gammarelay >/dev/null 2>&1; do sleep 0.1; done; busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 5000'"}
          ${startExec "dunst"}
          ${startExec "kitty"}
        '')
      ];

    };

  };
}
