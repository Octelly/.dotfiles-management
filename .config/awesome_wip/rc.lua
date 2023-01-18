local essential = function(module_name)
    status, err = pcall(require, module_name)

    if not status then
        print('[FATAL] Couldn\'t load essential module "' .. module_name .. '"!\nDetails:\n' .. err)
        error('Couldn\'t load essential module "' .. module_name .. '"!\nDetails:\n' .. err, 2)
    else
        print('"' .. module_name .. '" loaded successfully')
    end
end

-- Importing required packages
essential("luarocks.loader")
essential("moonscript")


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
beautiful.init(require(gfs.get_configuration_dir() .. "theme/" .. theme .. "/theme"))


-- Import Configuration
require("configuration")


-- Tag logic
local tags = require("ux.tags")

screen.connect_signal(
    "request::desktop_decoration",
    tags.populate_screen_with_defaults
)
