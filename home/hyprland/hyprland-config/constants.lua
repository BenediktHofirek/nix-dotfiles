local M = {
    displays = {
        [1] = {
            id = "eDP-2",
            mod = "CTRL",
        },
        [2] = {
            id = "HDMI-A-1",
            mod = "ALT",
            bus = 16,
        },
        [3] = {
            id = "DP-1",
            mod = "SUPER",
            bus = 15,
        },
        [4] = {
            id = "DP-3",
            bus = 0,
        },
    },

    -- Free: C, W, X, Y
    command_mod = "SUPER + ALT + CTRL",
}

return M

