-- LuaRocks packages loading if available
pcall(require, "luarocks.loader")
-- WARNING:
-- required luarocks packages:
--- lcpz/awesome-freedesktop


-- STANDARD AWESOME LIBRARY --


local gears = require("gears")                          -- utilities
local awful = require("awful")                          -- window management
require("awful.autofocus")                              --- automatic focusing on client change etc.
local hotkeys_popup = require("awful.hotkeys_popup")    --- hotkeys cheatsheet
local wibox = require("wibox")                          -- widgets
local beautiful = require("beautiful")                  -- themes
local naughty = require("naughty")                      -- notifications
local ruled = require("ruled")                          -- client rules
local menubar = require("menubar")                      -- XDG (application) menu implementation - FIXME: probably useless


-- Load Debian menu entries - FIXME: probably useless (also not cross-distro compatible)
--local debian = require("debian.menu")
--local freedesktop = require("freedesktop")

local json = require("external/json_lua/json")


local machi = require("external.layout-machi")
local rubato = require("external.rubato")
local color = require("external.color")


-- ADDONS {{{

--local nice = require("nice")  -- Repo: https://github.com/mut-ex/awesome-wm-nice
                              -- An Awesome WM module that add MacOS-like
                              -- window decorations, with seamless titlebars,
                              -- double click to maximize, and window shade
                              -- feature

local keyboard_layout = require("keyboard_layout")  -- Repo: https://github.com/echuraev/keyboard_layout
                                                    -- Keyboard switcher for Awesome WM with additional
                                                    -- layouts

-- }}}

-- ERROR HANDLING {{{

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)

-- OLD {{{

-- -- this should only execute for fallback config (useless here?)
-- if awesome.startup_errors then
--     naughty.notify({ preset = naughty.config.presets.critical,
--                      title = "Oops, there were errors during startup!",
--                      text = awesome.startup_errors })
-- end
-- 
-- -- runtime errors
-- do
--     local in_error = false
--     awesome.connect_signal("debug::error", function (err)
--         -- Make sure we don't go into an endless error loop
--         if in_error then return end
--         in_error = true
-- 
--         naughty.notify({ preset = naughty.config.presets.critical,
--                          title = "Oops, an error happened!",
--                          text = tostring(err) })
--         in_error = false
--     end)
-- end

-- }}}

-- }}}

-- VARIABLES {{{

-- load theme
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/default/theme.lua")
beautiful.layout_machi = machi.get_icon()


-- local bling = require("bling")
--
-- bling.widget.tag_preview.enable {
--     show_client_content = false,  -- Whether or not to show the client content
--     x = 10,                       -- The x-coord of the popup
--     y = 10,                       -- The y-coord of the popup
--     scale = 0.25,                 -- The scale of the previews compared to the screen
--     honor_padding = false,        -- Honor padding when creating widget size
--     honor_workarea = false        -- Honor work area when creating widget size
-- }

-- initialise nice addon
--nice {
--    titlebar_items = {
--        left = {},
--        middle = "title",
--        right = {"minimize", "maximize", "close"},
--    },
--    --titlebar_height = 38,
--    no_titlebar_maximized = true,
--    titlebar_height = 42,
--    titlebar_padding_right = 7,
--    tooltips_enabled = false,
--    button_margin_horizontal = 7,
--    button_size = 14,
--    minimize_color = "#f1fa8c",
--    maximize_color = "#50fa7b",
--    close_color =    "#ff5555",
--}


-- keyboard layouts
local kbdcfg = keyboard_layout.kbdcfg({
    type = "tui",
    tui_wrap_right = "",
    tui_wrap_left = " "
})

kbdcfg.add_primary_layout("English (US)", "EN", "us")
kbdcfg.add_primary_layout("Czech (QWERTY)", "CZ", "cz(qwerty)")

kbdcfg.bind()


-- This is used later as the default terminal and editor to run.
--terminal = "x-terminal-emulator"
terminal = "kitty"
--terminal = "/usr/bin/zsh /home/ocean/Scripts/big_funny.sh"

--editor = os.getenv("EDITOR") or "editor"
editor = "nvim"

editor_cmd = terminal .. " -e " .. editor


-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- }}}

-- MENU {{{

myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit 👋❤️", function() awesome.quit() end },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }


--if has_fdo then
--mymainmenu = freedesktop.menu.build({
--    before = { menu_awesome },
--    after =  { menu_terminal }
--})
--else
mymainmenu = awful.menu({
    items = {
              menu_awesome,
              --{ "Debian", debian.menu.Debian_menu.Debian },
              menu_terminal,
              {"", nil},
              {"<3", nil}
            }
})
--end


mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- }}}

-- LAYOUTS {{{

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    machi.default_layout,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    awful.layout.suit.floating,
    --awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
}

-- beautiful.useless_gap = 5

-- }}}

-- WALLPAPER {{{
screen.connect_signal("request::wallpaper", function(s)
    --awful.wallpaper{
    --    screen = s,
    --    widget = {
    --        {
    --            image     = beautiful.wallpaper,
    --            upscale   = true,
    --            downscale = true,
    --            scaling_quality = "best",
    --            widget    = wibox.widget.imagebox,
    --        },
    --        valign = "center",
    --        halign = "center",
    --        tiled  = false,
    --        widget = wibox.container.tile,
    --    }
    --}
    gears.wallpaper.maximized(
        beautiful.wallpaper,
        s
    )  -- DEPRECATED, but the only way to easily do this that I know of
       -- https://github.com/awesomeWM/awesome/issues/3547
end)
-- }}}

-- WIBAR (WIDGET BAR) {{{

-- NOTE:
-- keyboardlayout stuff defined in VARIABLES section

-- Create a textclock widget
mytextclock = wibox.widget.textclock("%H:%M:%S|%A %d.%m.|%b %Y", 1)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),  -- switched it around to the
                    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)   -- more common setting
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

-- local function set_wallpaper(s)
--     -- Wallpaper
--     if beautiful.wallpaper then
--         local wallpaper = beautiful.wallpaper
--         -- If wallpaper is a function, call it with the screen
--         if type(wallpaper) == "function" then
--             wallpaper = wallpaper(s)
--         end
--         gears.wallpaper.maximized(wallpaper, s, true)
--     end
-- end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
-- screen.connect_signal("property::geometry", set_wallpaper)

local function powerline(widget, bg, fg, additional_margin)
    additional_margin = additional_margin or 0
    return {
        {
            {
                widget,
                widget = wibox.container.place  -- (vertical) align
            },
            left  = 12 + additional_margin,
            right = 12 + additional_margin,
            color = bg,
            widget = wibox.container.margin,    -- add margin that will be
                                                -- cut into powerline shape
        },
        fg = fg,
        bg = bg,
        shape = function(cr, width, height)     -- cut
            return gears.shape.parallelogram(cr, width, height, width-12)
        end,
        widget = wibox.container.background     -- NOTE:
                                                -- widgets wrapped like this
                                                -- need to have negative spacing
                                                -- set up
                                                -- setting it to precisely -12 px
                                                -- however leaves thin lines of the
                                                -- bg colour sticking through
                                                -- however, something like -13 does
                                                -- the job better
    }
end

local function emi_powerline(widget, bg, fg, additional_margin)
    additional_margin = additional_margin or 0
    local lmao =  wibox.widget{
        {
            {
                widget,
                widget = wibox.container.place  -- (vertical) align
            },
            left  = 12 + additional_margin,
            right = 12 + additional_margin,
            color = bg,
            id="xd",
            widget = wibox.container.margin,    -- add margin that will be
                                                -- cut into powerline shape
        },
        fg = fg,
        bg = bg,
        shape = function(cr, width, height)     -- cut
            return gears.shape.parallelogram(cr, width, height, width-12)
        end,
        widget = wibox.container.background     -- NOTE:
                                                -- widgets wrapped like this
                                                -- need to have negative spacing
                                                -- set up
                                                -- setting it to precisely -12 px
                                                -- however leaves thin lines of the
                                                -- bg colour sticking through
                                                -- however, something like -13 does
                                                -- the job better
    }

    local hue = 0

    local emi_min = 1
    local emi_max = 10
    local emi

    local lmao_xd = function(the_color_we_want_to_change_the_color_to)
        lmao.bg = the_color_we_want_to_change_the_color_to
        lmao.xd.color = the_color_we_want_to_change_the_color_to
    end

    gears.timer{
        timeout = 1/15,
        autostart = true,
        callback = function()
            hue = hue + emi
            if hue > 359 then hue = hue - 359 end
            lmao_xd(color.color{
                    h=hue,s=0.7,
                    l=0.6
                }.hex)
        end
    }

    local speed_anim = rubato.timed{
        duration = 0.2,
        intro = 0.1,
        pos = emi_min,
        subscribed = function(pos)
            emi = pos
        end
    }

    lmao:connect_signal("mouse::enter", function()
			speed_anim.target = emi_max
		end)
		
		lmao:connect_signal("mouse::leave", function()
			speed_anim.target = emi_min
		end)

    return lmao
end

local function static_text(text)
    return {
        text = text,
        widget = wibox.widget.textbox
    }
end

local function combine(widgets)
    local array = {
        layout = wibox.layout.fixed.horizontal
    }
    for _, widget in ipairs(widgets) do
        table.insert(array, widget)
    end
    return array
end

-- class, program, name, user_icon, is_steam
local dock_programs = {
    { "kitty", "kitty", "Kitty", "/usr/share/icons/hicolor/scalable/apps/kitty.svg" },
    { "chromium", "chromium", "Chromium", "/usr/share/icons/hicolor/256x256/apps/chromium.png" },
    --{ "brave-browser", "brave", "Brave" },
    --{ "crx_agimnkijcaahngcdmfeangaknmldooml", "/usr/lib/brave-bin/brave --profile-directory=Default --app-id=agimnkijcaahngcdmfeangaknmldooml", "YouTube", "/usr/share/icons/WhiteSur-dark/apps/scalable/youtube.svg" },
    { "discord", "discord", "Discord", "/usr/share/pixmaps/discord.png" },
    { "Tauon Music Box", "flatpak run com.github.taiko2k.tauonmb", "Tauon Music Box", "/var/lib/flatpak/exports/share/icons/hicolor/scalable/apps/com.github.taiko2k.tauonmb.svg"},
    { "Spotify", "spotify", "Spotify", "/usr/share/icons/hicolor/512x512/apps/spotify.png" },
    { "easyeffects", "easyeffects", "EasyEffects"},
    { "dolphin", "dolphin", "Dolphin", "/usr/share/icons/WhiteSur-dark/apps/scalable/org.kde.dolphin.svg" },
    { "gimp-2.10", "gimp", "GNU Image Manipulation Program", "/usr/share/icons/hicolor/48x48/apps/gimp.png" },
    { "Thunderbird", "flatpak run org.mozilla.Thunderbird", "Thunderbird", "/var/lib/flatpak/exports/share/icons/hicolor/128x128/apps/org.mozilla.Thunderbird.png" },
    { "barrier", "barrier", "Barrier", "/usr/share/icons/hicolor/scalable/apps/barrier.svg" },
    { "prismlauncher", "prismlauncher", "PrismLauncher", "/usr/share/icons/hicolor/scalable/apps/org.prismlauncher.PrismLauncher.svg" }
}

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    -- set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
                           
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons

    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar{
        position = "top",
        screen   = s,
        widget   = {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                {
                    mylauncher,
                    margins = 1.5,
                    widget = wibox.container.margin
                },
                s.mytaglist,
                s.mypromptbox,
            },
            s.mytasklist, -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                spacing = -13,
                powerline(static_text("ahoj Kati :)"),                 "#78dce8", "#1a181a"),
                --powerline(static_text("emi 🥺"),                       "#f85e84", "#e3e1e4"),
                emi_powerline(static_text("emi 🥺"),                       "#f85e84", "#000000"),
                powerline(kbdcfg.widget, "#e3e1e4", "#1a181a", 3),
                powerline({
                    base_size = 20,
                    widget = wibox.widget.systray()
                },                                                     "#49464e", "#e3e1e4"),
                powerline(combine({
                    awful.widget.watch('cat /sys/class/power_supply/BAT1/capacity'),
                    static_text('% '),
                    awful.widget.watch('cat /sys/class/power_supply/BAT0/capacity'),
                    static_text('%'), -- FIXME: not a widget without this (wtf?)
                }),                                                    "#9ecd6f", "#1a181a", 3),
                powerline(mytextclock,                                 "#e5c463", "#1a181a"),
                {
                    powerline(s.mylayoutbox,                           "#1a181a", "#e3e1e4"),
                    right = -12,
                    widget = wibox.container.margin
                }
            },
        }
    }

    require("external.crylia_dock.dock_modified")(s, dock_programs)
end)

-- }}}

-- BINDINGS {{{

-- MOUSE BINDINGS --

-- root window
root.buttons(require("binds.globalbuttons")())

-- client window
--clientbuttons = require('binds.clientbuttons')()

-- KEY BINDINGS --
-- globalkeys = gears.table.join(
awful.keyboard.append_global_keybindings({

    -- hotkeys cheatsheet
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    -- debug
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),

    -- change tag
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),

    awful.key({ modkey }, "h", function ()
        mouse.screen.mywibox.visible = not mouse.screen.mywibox.visible
    end,
    {description = "hide top bar", group = "awesome"}),

    -- client focus switch
    awful.key({ "Mod1",           }, "Tab",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ "Mod1", "Shift"   }, "Tab",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

   awful.key({ modkey,           }, "/",
        function ()
            machi.default_editor.start_interactive()
        end,
        {description = "edit the current layout if it is a machi layout", group = "layout"}
    ),

    -- focus urgent client
    -- awful.key({ "Mod1", "Control"   }, "Tab", awful.client.urgent.jumpto,
    --           {description = "jump to urgent client", group = "client"}),

    -- screen focus switch
    -- awful.key({ modkey,           }, "Tab", function () awful.screen.focus_relative( 1) end,
    --           {description = "focus the next screen", group = "screen"}),
    -- awful.key({ modkey, "Shift"   }, "Tab", function () awful.screen.focus_relative(-1) end,
    --           {description = "focus the previous screen", group = "screen"}),
     awful.key({ modkey,           }, "#34", function () awful.screen.focus_relative(-1) end,
               {description = "focus the previous screen", group = "screen"}),
     awful.key({ modkey,           }, "#35", function () awful.screen.focus_relative( 1) end,
               {description = "focus the next screen", group = "screen"}),

    -- show main menu
    -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
    --           {description = "show main menu", group = "awesome"}),

    -- program shortcuts
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    -- awful.key({ modkey },            "f",     function () awful.util.spawn_with_shell("nautilus -w") end,
    --           {description = "open a file manager", group = "launcher"}),
    awful.key({ modkey },            "f",     function () awful.util.spawn_with_shell("dolphin --new-window") end,
              {description = "open a file manager", group = "launcher"}),
    awful.key({ modkey },            "r",     function () awful.util.spawn_with_shell("rofi -no-default-config -config " .. gears.filesystem.get_configuration_dir() .. "/rofi/config.rasi -switchers combi,drun,calc -show combi") end,
              {description = "Rofi", group = "launcher"}),
    awful.key({  },             "XF86Search", function () awful.util.spawn_with_shell("rofi -no-default-config -config " .. gears.filesystem.get_configuration_dir() .. "/rofi/config.rasi -switchers combi,drun,calc -show combi") end,
              {description = "Rofi", group = "launcher"}),
    awful.key({ modkey },           "period", function () awful.util.spawn_with_shell("rofimoji -f emoji ~/.config/rofimoji/custom.csv") end,
              {description = "Emoji picker", group = "launcher"}),

    -- awful.key({ "Control", "Shift" },            "Print",     function () awful.util.spawn_with_shell("i3-maim-clpimg -s") end,
    --           {description = "selection screenshot", group = "launcher"}),
    -- awful.key({ "Control" },            "Print",     function () awful.util.spawn_with_shell("i3-maim-clpimg -f") end,
    --           {description = "fullscreen screenshot", group = "launcher"}),
    awful.key({ "Control", "Shift" },            "Print",     function () awful.util.spawn_with_shell("flameshot gui -c -p \"$HOME/Pictures/$(date +%s).png\"") end,
              {description = "selection screenshot", group = "launcher"}),
    awful.key({ "Control", "Shift" },            "Insert",     function () awful.util.spawn_with_shell("flameshot gui -c -p \"$HOME/Pictures/$(date +%s).png\"") end,
              {description = "selection screenshot", group = "launcher"}),
    awful.key({ "Control" },            "Print",     function () awful.util.spawn_with_shell("flameshot full -c -p \"$HOME/Pictures/$(date +%s).png\"") end,
              {description = "fullscreen screenshot", group = "launcher"}),
    awful.key({ "Control" },            "Insert",     function () awful.util.spawn_with_shell("flameshot full -c -p \"$HOME/Pictures/$(date +%s).png\"") end,
              {description = "fullscreen screenshot", group = "launcher"}),

    -- awful.key({ modkey },            "l",     function () awful.util.spawn_with_shell("i3lock -i ~/Documents/sesks.png -t") end,
    --           {description = "lock", group = "awesome"}),
    awful.key({ modkey },            "l",     function () awful.util.spawn_with_shell("~/.config/qtile/lock.zsh") end,
              {description = "lock", group = "awesome"}),
    --awful.key({ "Control", "Shift" },            "Print",     function () awful.util.spawn_with_shell("maim -s | xclip -selection clipboard -t image/png") end,
    --          {description = "selection screenshot", group = "launcher"}),

    -- HW control
    awful.key({ }, "XF86MonBrightnessUp", function () awful.util.spawn("busctl call org.clightd.clightd /org/clightd/clightd/Backlight org.clightd.clightd.Backlight RaiseAll \"d(bdu)s\" 0.025 0 0 0 \"\"") end,
              {description = "brightness up", group = "HW control"}),
    awful.key({ }, "XF86MonBrightnessDown", function () awful.util.spawn("busctl call org.clightd.clightd /org/clightd/clightd/Backlight org.clightd.clightd.Backlight LowerAll \"d(bdu)s\" 0.025 0 0 0 \"\"") end,
              {description = "brightness down", group = "HW control"}),
    awful.key({ }, "XF86AudioMute", function () awful.util.spawn("pamixer -t") end,
              {description = "toggle out mute", group = "HW control"}),
    awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("pamixer -i 5") end,
              {description = "raise volume", group = "HW control"}),
    awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("pamixer -d 5") end,
              {description = "lower volume", group = "HW control"}),
    awful.key({ }, "XF86AudioMicMute", function () awful.util.spawn("pamixer --default-source -t") end,
              {description = "toggle in mute", group = "HW control"}),

    -- awesome control
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ "Mod1", "Control" },            "r",     function () awful.util.spawn_with_shell("~/.config/qtile/restart_picom.zsh") end,
              {description = "restart picom", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    -- width change
    -- awful.key({ modkey, "Control" }, "Right",     function () awful.tag.incmwfact( 0.05)          end,
    --           {description = "increase master width factor", group = "layout"}),
    -- awful.key({ modkey, "Control" }, "Left",     function () awful.tag.incmwfact(-0.05)          end,
    --           {description = "decrease master width factor", group = "layout"}),

    -- keyboard layouts
    awful.key({ modkey,           }, "space", function () kbdcfg.switch_next()                end,
              {description = "next layout", group = "keyboard"}),
    awful.key({ modkey, "Shift"   }, "space", function () kbdcfg.switch_next()                end,
              {description = "\"previous\" layout", group = "keyboard"}),

    awful.key({ modkey,        }, "Tab", function() awful.layout.inc(1) end,
              {description = "kuakuhfalifhu", group = "awesome"}),
    awful.key({ modkey, "Shift"}, "Tab", function() awful.layout.inc(-1) end,
              {description = "kuakuhfalifhu", group = "awesome"}),

    -- unminimise client
    awful.key({ modkey, "Control" }, "e",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- media keys
    awful.key({ }, "XF86AudioPlay", function () awful.util.spawn("playerctl play-pause") end,
              {description = "toggle media playback", group = "mpris media"}),
    awful.key({ }, "XF86AudioPause", function () awful.util.spawn("playerctl play-pause") end,
              {description = "toggle media playback", group = "mpris media"}),
    awful.key({ }, "XF86AudioNext", function () awful.util.spawn("playerctl next") end,
              {description = "next media", group = "mpris media"}),
    awful.key({ }, "XF86AudioPrev", function () awful.util.spawn("playerctl previous") end,
              {description = "previous media", group = "mpris media"}),
    awful.key({ }, "XF86AudioForward", function () awful.util.spawn("playerctl position 1+") end,
              {description = "forward media", group = "mpris media"}),
    awful.key({ }, "XF86AudioRewind", function () awful.util.spawn("playerctl position 1-") end,
              {description = "rewind media", group = "mpris media"})
})


-- A client keybinding is a shortcut that will get the currently focused client as its first callback argument.
clientkeys = gears.table.join(
    
    -- window controls
    --
    -- modkey + q  -  close
    -- modkey + w  -  un/maximise
    -- modkey + e  -  minimise
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey,           }, "w",
              function (c)
                  c.maximized = not c.maximized
                  c:raise()
              end ,
              {description = "(un)maximize", group = "client"}),
    awful.key({ modkey,           }, "e",
              function (c)
                  -- The client currently has the input focus, so it cannot be
                  -- minimized, since minimized clients can't have the focus.
                  c.minimized = true
              end ,
              {description = "minimize", group = "client"}),

    -- fullscreen (modkey + e)
    awful.key({ modkey,           }, "d",
        function (c)
            c.fullscreen = not c.fullscreen
	    --local cur_tag = client.focus and client.focus.first_tag or nil
            --for _, cls in ipairs(cur_tag:clients()) do
            --    -- minimize all windows except the focused one
            --    if c.window ~= cls.window then
            --        cls.hidden = not cls.hidden
            --    end
            --end
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),

    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

-- Set keys
root.keys(globalkeys)

-- }}}


-- RULES --
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = require('main.rules')(
    clientkeys,
    require('binds.clientbuttons')()
)


-- SIGNALS --
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
-- client.connect_signal("request::titlebars", function(c)
--     -- buttons for the titlebar
--     local buttons = gears.table.join(
--         awful.button({ }, 1, function()
--             c:emit_signal("request::activate", "titlebar", {raise = true})
--             awful.mouse.client.move(c)
--         end),
--         awful.button({ }, 3, function()
--             c:emit_signal("request::activate", "titlebar", {raise = true})
--             awful.mouse.client.resize(c)
--         end)
--     )
-- 
--     awful.titlebar(c) : setup {
--          { -- Left
--              awful.titlebar.widget.iconwidget(c),
--              buttons = buttons,
--              layout  = wibox.layout.fixed.horizontal
--          },
--          { -- Middle
--              { -- Title
--                  align  = "center",
--                  widget = awful.titlebar.widget.titlewidget(c)
--              },
--              buttons = buttons,
--              layout  = wibox.layout.flex.horizontal
--          },
--          { -- Right
--              awful.titlebar.widget.floatingbutton (c),
--              awful.titlebar.widget.maximizedbutton(c),
--              awful.titlebar.widget.stickybutton   (c),
--              awful.titlebar.widget.ontopbutton    (c),
--              awful.titlebar.widget.closebutton    (c),
--              layout = wibox.layout.fixed.horizontal()
--          },
--          layout = wibox.layout.align.horizontal
--      }
--  end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

-- client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
-- client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_color_active end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_color end)


-- AUTORUN --
-- local run_on_start_up = {
--    "picom --experimental-backends --config " .. gears.filesystem.get_configuration_dir() .. "/picom/picom.conf",
--    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
--    "/home/ocean/.screenlayout/three.sh",
--    --"plank"
--    -- "nitrogen --random --set-zoom-fill ~/Wallpapers/32-9-sonokai"
-- }
-- 
-- -- Run all the apps listed in run_on_start_up
-- for _, app in ipairs(run_on_start_up) do
--    local findme = app
--    local firstspace = app:find(" ")
--    if firstspace then
--       findme = app:sub(0, firstspace - 1)
--    end
--    -- pipe commands to bash to allow command to be shell agnostic
--    awful.spawn.with_shell(string.format("echo 'pgrep -u $USER -x %s > /dev/null || (%s)' | bash -", findme, app), false)
-- end

local existence_reminder_messages_file = io.open(gears.filesystem.get_configuration_dir() .."existence_reminder.json")
local existence_reminder_messages = json.decode(
    existence_reminder_messages_file:read("a")
)
existence_reminder_messages_file:close()

local function random_choice(list)
    return list[math.random(#list)]
end

local function existence_reminder()
    local date = os.date("*t")

    if date.sec == 0 and date.min == 0 then
        awful.spawn.with_shell("mpv --no-config --volume=75 --no-video ~/.config/qtile/ac-bell/10spedup.flac > /dev/null")
        --awful.util.spawn_with_shell("notify-send -u low -t 17000 "..tostring(date.hour)..":00 "..random_choice(existence_reminder_messages[tostring(date.hour)]))
        naughty.notification({
            title = tostring(date.hour)..":00",
            message = random_choice(existence_reminder_messages[tostring(date.hour)]),
            urgency = "low",
            timeout = 17
        })
    end
end

gears.timer{
    timeout = 1,
    call_now = true,
    autostart = true,
    callback = existence_reminder
}

-- gears.timer{
--     timeout = 1,
--     call_now = true,
--     autostart = true,
--     callback = function ()
--         awful.util.spawn_with_shell("python3 ~/.config/qtile/existence_reminder.py")
--     end
-- }

awful.util.spawn_with_shell(gears.filesystem.get_configuration_dir().."autostart.zsh")
