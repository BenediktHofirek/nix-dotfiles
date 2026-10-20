local constants = require("constants")

-- Bind workspaces to their respective monitors.
for display_number, display in pairs(constants.displays) do
    hl.monitor({
        output = display.output,
        mode = display.mode,
        position =display.position,
        scale = display.scale,
    })

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

