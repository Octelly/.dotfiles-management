-- Sub-process handling library
local aspawn = require("awful.spawn")

-- Filesystem library
local gfs = require("gears.filesystem")


-- Apps that should be run at startup
local autostart_apps = {
    "xset -b", -- Disable bell

    -- Polkit agent
    "/usr/lib/policykit-1-pantheon/io.elementary.desktop.agent-polkit",

    -- System tray
    "blueberry-tray",       -- Bluetooth
    "pasystray",            -- Audio
    "nm-applet",            -- Network
    "clight-gui --tray",    -- Backlight
    "caffeine start",       -- Keep awake

    -- Compositor
    "picom --experimental-backends --config " ..
        gfs.get_configuration_dir() .. "configuration/picom.conf",

    -- Mouse cursor hider
    "unclutter --timeout 5 --hide-on-touch"
}

for app = 1, #autostart_apps do aspawn.once(autostart_apps[app]) end
