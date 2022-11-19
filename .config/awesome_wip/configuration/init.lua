-- Theme handling library
local beautiful = require("beautiful")

-- Utilities library
local gears = require("gears")

-- Window management and misc library
local awful = require("awful")

local tags = require("ux.tags")
local prompt = require("ux.prompt")


-- Autostart apps
--require("configuration.autostart")


app = {
    term = "kitty",
    fm = "dolphin --new-window",
    shell = "zsh",
}

awful.util.shell = app.shell


-- Modkeys
super = "Mod4"
alt = "Mod1"
shift = "Shift"
ctrl = "Control"

-- Wallpaper
screen.connect_signal("request::wallpaper", function(s)
    gears.wallpaper.maximized(
        beautiful.wallpaper,
        s
    )
end)

-- KEYBIND NOTES

-- use flamehost for screenshots
-- flameshot -h
-- flameshot gui -h
-- flameshot full -h


-- handle chromium profiles
-- https://superuser.com/a/377195
-- https://askubuntu.com/a/1260508


-- FIXME: tag stuff testing

-- Widget and layout library
local wibox = require("wibox")

screen.connect_signal("request::desktop_decoration", function(s)
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
    }

    s.wibar = awful.wibar {
        position = "top",
        screen   = s,
        widget   = {
            layout = wibox.layout.align.horizontal,
            s.mytaglist,
        }
    }
end)

awful.keyboard.append_global_keybindings{
    awful.key({super}, "t", function()
        tags.new(awful.screen.focused())
    end),
    awful.key({super}, "w", function()
        tags.close(awful.screen.focused().selected_tag)
    end),

    awful.key({super}, "Left", awful.tag.viewprev),
    awful.key({super}, "Right", awful.tag.viewnext),


    awful.key({}, "x", function()
        prompt.string{
            prompt="ඞ as the sussy sussius once said:",
            callback=function(value)
                awful.spawn('notify-send "' .. value .. '"')
            end,
        }
    end),
    awful.key({}, "c", function()
        prompt.string{
            prompt="🎄 What is in just a week?",
            callback=function(value)
                awful.spawn('notify-send "' .. value .. '"')
            end,
        }
    end),
}
