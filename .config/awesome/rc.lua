-- LuaRocks packages loading if available
pcall(require, "luarocks.loader")


-- STANDARD AWESOME LIBRARY --

local gears = require("gears")                        -- utilities
local awful = require("awful")                        -- window management
local wibox = require("wibox")                        -- widgets
local beautiful = require("beautiful")                -- themes
local naughty = require("naughty")                    -- notifications
local menubar = require("menubar")                    -- XDG (application) menu implementation - FIXME: probably useless
local hotkeys_popup = require("awful.hotkeys_popup")  -- hotkeys cheatsheet

require("awful.hotkeys_popup.keys")  -- dynamic hotkeys cheatsheet library
                                     -- (might not be relevant to custom config)
                                     -- (firefox, qutebrowser, termite, tmux, vim)

-- Load Debian menu entries - FIXME: probably useless (also not cross-distro compatible)
--local debian = require("debian.menu")
--local has_fdo, freedesktop = pcall(require, "freedesktop")


-- ADDONS --

local nice = require("nice")  -- Repo: https://github.com/mut-ex/awesome-wm-nice
                              -- An Awesome WM module that add MacOS-like
                              -- window decorations, with seamless titlebars,
                              -- double click to maximize, and window shade
                              -- feature

local keyboard_layout = require("keyboard_layout")  -- Repo: https://github.com/echuraev/keyboard_layout
                                                    -- Keyboard switcher for Awesome WM with additional
                                                    -- layouts

                                                    
-- ERROR HANDLING --

-- this should only execute for fallback config (useless here?)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- runtime errors
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

-- VARIABLES --

-- load theme
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

local bling = require("bling")

bling.widget.tag_preview.enable {
    show_client_content = false,  -- Whether or not to show the client content
    x = 10,                       -- The x-coord of the popup
    y = 10,                       -- The y-coord of the popup
    scale = 0.25,                 -- The scale of the previews compared to the screen
    honor_padding = false,        -- Honor padding when creating widget size
    honor_workarea = false        -- Honor work area when creating widget size
}   

-- initialise nice addon
nice {
    titlebar_items = {
        left = {},
        middle = "title",
        right = {"minimize", "maximize", "close"},
    },
    --titlebar_height = 38,
    no_titlebar_maximized = true,
    titlebar_height = 42,
    titlebar_padding_right = 7,
    tooltips_enabled = false,
    button_margin_horizontal = 7,
    button_size = 14,
    minimize_color = "#f1fa8c",
    maximize_color = "#50fa7b",
    close_color =    "#ff5555",
}


-- keyboard layouts
local kbdcfg = keyboard_layout.kbdcfg({type = "tui"})

kbdcfg.add_primary_layout("English (US)", "EN", "us")
kbdcfg.add_primary_layout("Czech (QWERTY)", "CZ", "cz(qwerty)")

kbdcfg.bind()


-- This is used later as the default terminal and editor to run.
--terminal = "x-terminal-emulator"
terminal = "kitty"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor


-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"


-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

beautiful.useless_gap = 5

-- MENU --

myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit 👋❤️", function() awesome.quit() end },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }


if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
else
    mymainmenu = awful.menu({
        items = {
                  menu_awesome,
                  --{ "Debian", debian.menu.Debian_menu.Debian },
                  menu_terminal,
                }
    })
end


mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}


-- WIBAR (WIDGET BAR) --

-- Create a textclock widget
mytextclock = wibox.widget.textclock()

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

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

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
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            kbdcfg.widget,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)


-- MOUSE BINDINGS --

-- root window
root.buttons(gears.table.join(
    -- show main menu
    awful.button({ }, 3, function () mymainmenu:toggle() end),

    -- change tag
    -- -> modkey + scroll
    awful.button({ modkey }, 4, awful.tag.viewprev),
    awful.button({ modkey }, 5, awful.tag.viewnext)
))

-- client window
clientbuttons = gears.table.join(

    -- focus
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),

    -- move, resize
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end),

    -- change tag
    -- -> modkey + scroll
    awful.button({ modkey }, 4, function (c)
        awful.tag.viewprev(awful.mouse.screen)
    end),
    awful.button({ modkey }, 5, function (c)
        awful.tag.viewnext(awful.mouse.screen)
    end)
)


-- KEY BINDINGS --
globalkeys = gears.table.join(

    -- hotkeys cheatsheet
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    
    -- change tag
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),

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

    -- focus urgent client
    awful.key({ "Mod1", "Control"   }, "Tab", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

    -- screen focus switch
    awful.key({ modkey,           }, "Tab", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Shift"   }, "Tab", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),

    -- show main menu
    -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
    --           {description = "show main menu", group = "awesome"}),

    -- program shortcuts
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey },            "r",     function () awful.util.spawn_with_shell("rofi -modi drun -show drun -font \"FiraCode Nerd Font Mono 14\" -show-icons") end,
              {description = "Rofi - drun", group = "launcher"}),
    awful.key({ "Control", "Shift" },            "Print",     function () awful.util.spawn_with_shell("maim -s | xclip -selection clipboard -t image/png") end,
              {description = "selection screenshot", group = "launcher"}),
    
    -- awesome control
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    -- width change
    awful.key({ modkey, "Control" }, "Right",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "Left",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),

    -- keyboard layouts
    awful.key({ modkey,           }, "space", function () kbdcfg.switch_next()                end,
              {description = "next layout", group = "keyboard"}),
    awful.key({ modkey, "Shift"   }, "space", function () kbdcfg.switch_next()                end,
              {description = "\"previous\" layout", group = "keyboard"}),

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
)


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


-- RULES --
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = 0,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Remove titlebars from windows that have their own ttitlebars
    { rule_any = {
	    requests_no_titlebar = {
		    true
	    },
	    class = {
		    "feh"
	    }
      }, properties = { titlebars_enabled = false }
    },
 
    -- Don't make extension windows floating
    { rule_any = {
	    class = {
		    "Brave-browser"
	    }
      }, properties = { floating = false }
    },

    -- Fix Sonic Generations
    { rule_any = {
	    class = {
		    "steam_app_71340"
	    }
      }, properties = { fullscreen = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}


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

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)


-- AUTORUN --
local run_on_start_up = {
   "picom --experimental-backends --config " .. gears.filesystem.get_configuration_dir() .. "/picom/picom.conf",
   "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
   "/home/ocean/.screenlayout/three.sh",
   --"plank"
   -- "nitrogen --random --set-zoom-fill ~/Wallpapers/32-9-sonokai"
}

-- Run all the apps listed in run_on_start_up
for _, app in ipairs(run_on_start_up) do
   local findme = app
   local firstspace = app:find(" ")
   if firstspace then
      findme = app:sub(0, firstspace - 1)
   end
   -- pipe commands to bash to allow command to be shell agnostic
   awful.spawn.with_shell(string.format("echo 'pgrep -u $USER -x %s > /dev/null || (%s)' | bash -", findme, app), false)
end
