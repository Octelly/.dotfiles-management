-- Attempt importing luarocks packages
pcall(require, "luarocks.loader")

-- Notification library
local naughty = require("naughty")

-- Theme handling library
local beautiful = require("beautiful")

-- Filesystem library
local gfs = require("gears.filesystem")

-- Window management and misc library
local awful = require("awful")


-- Check if AwesomeWM encountered an error and send a notification
-- (should realistically only be useful in a fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title = "Oops, an error happened" ..
            (startup and " during startup!" or "!"),
        message = message
    }
end)


-- Initialize Theme
local theme = "one"
beautiful.init(gfs.get_configuration_dir() .. "theme/" .. theme .. "/theme.lua")


-- Import Configuration
require("configuration")


-- Screen Tags
screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, awful.layout.layouts[1])
end)
