local constants = require("constants")

-- Monitor layout

-- Asus portable (left)
hl.monitor({
    output = "DP-1",
    mode = "2560x1600@60",
    position = "0x600",
    scale = 1.6,
})

-- Huawei (center)
hl.monitor({
    output = "HDMI-A-1",
    mode = "3840x2560@49.98",
    position = "1600x0",
    scale = 1.6,
})

-- Built-in screen (right)
hl.monitor({
    output = "eDP-2",
    mode = "2560x1600@60",
    position = "4000x400",
    scale = 1.333333,
})

-- Bind workspaces to their respective monitors.
for display_number, display in pairs(constants.displays) do
    for i = 1, 9 do
        hl.workspace_rule({
            workspace = tostring(i + display_number * 10),
            monitor = display.id,
        })
    end
end

-- Workspace switching:
-- Display 1: CTRL + 1..9 -> workspaces 11..19
-- Display 2: ALT  + 1..9 -> workspaces 21..29
-- Display 3: SUPER + 1..9 -> workspaces 31..39
--
-- These bindings are defined in keybinds.lua.

