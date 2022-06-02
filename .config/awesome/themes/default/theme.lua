---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local gsh = require("gears.shape")
local themes_path = gfs.get_configuration_dir() .. "themes/default/"

local theme = {}

local clr_red = "#f85e84"
local clr_green = "#9ecd6f"
local clr_yellow = "#e5c463"
local clr_blue = "#7accd7"
local clr_magenta = "#ab9df2"
local clr_cyan = "#78dce8"

local clr_black = "#1a181a"
local clr_dgray = "#2d2a2e"
local clr_bgray = "#49464e"
local clr_white = "#e3e1e4"

local font = "FiraCode Nerd Font Mono"

theme.font          = font.." 9"

theme.bg_normal     = clr_dgray .. "e6" -- e6 (e5.8) = 90%
theme.bg_focus      = clr_bgray
theme.bg_urgent     = clr_red
theme.bg_minimize   = clr_black
theme.bg_systray    = clr_bgray

theme.fg_normal     = clr_white
theme.fg_focus      = clr_white
theme.fg_urgent     = clr_white
theme.fg_minimize   = clr_bgray

theme.useless_gap         = 2.5
--theme.border_width        = 2
theme.border_color_normal = clr_dgray
--theme.border_color_active = clr_red
theme.border_color_marked = clr_yellow

theme.fullscreen_hide_border = true
theme.maximized_hide_border = true
theme.border_color = clr_dgray
theme.border_color_active = clr_red
theme.border_width = 2

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- FIXME:
-- most of this notification stuff doesn't work

theme.notification_width = 300
theme.notification_position = "bottom_right"
theme.notification_spacing = 5
theme.notification_margin = 10
theme.notification_font = font.." 14"
theme.notification_bg = theme.bg_normal
theme.notification_fg = theme.fg_normal
theme.notification_border_width = 4
theme.notification_border_color = clr_white
theme.notification_icon_size_normal = 20

rnotification.connect_signal("request::rules", function()
    rnotification.append_rule {
        except     = {},
        properties = {
            border_width = 2,
            position = "bottom_right",
            spacing = 5,
            margin = 10
        }
    }

    rnotification.append_rule {
        rule       = { urgency = "critical" },
        properties = { border_color = clr_red, timeout = 20 }
    }

    rnotification.append_rule {
        rule       = { urgency = "normal" },
        properties = { timeout = 10 }
    }

    rnotification.append_rule {
        rule       = { urgency = "low" },
        properties = { border_color = clr_bgray, timeout = 5 }
    }
end)

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = 20
theme.menu_width  = 150
theme.menu_font = theme.font
theme.menu_bg_normal = theme.bg_normal
theme.menu_fg_normal = theme.fg_normal
theme.menu_bg_focus = theme.bg_normal
theme.menu_fg_focus = clr_red
theme.menu_border_width = 5
theme.menu_border_color = theme.menu_bg_normal


theme.tooltip_font = theme.font
theme.tooltip_bg = theme.bg_normal
theme.tooltip_fg = theme.fg_normal
theme.tooltip_border_width = 5
theme.tooltip_shape = gsh.rounded_bar


--theme.wibar_shape   = gsh.rounded_bar
theme.wibar_margins = {
    top   = 5,
    left  = 5,
    right = 5,

    bottom = 0
}

theme.hotkeys_bg = theme.bg_normal
theme.hotkeys_fg = clr_white
theme.hotkeys_border_color = clr_red
theme.hotkeys_modifiers_fg = clr_red
theme.hotkeys_label_bg = clr_red
theme.hotkeys_label_fg = clr_white
theme.hotkeys_font = theme.font
theme.hotkeys_description_font = theme.font

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."titlebar/maximized_focus_active.png"

--theme.wallpaper = themes_path.."wallpaper.png"
--theme.wallpaper = themes_path.."wallpaper2.jpg"
theme.wallpaper = themes_path.."wallpaper3.jpg"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."layouts/fairhw.png"
theme.layout_fairv = themes_path.."layouts/fairvw.png"
theme.layout_floating  = themes_path.."layouts/floatingw.png"
theme.layout_magnifier = themes_path.."layouts/magnifierw.png"
theme.layout_max = themes_path.."layouts/maxw.png"
theme.layout_fullscreen = themes_path.."layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."layouts/tileleftw.png"
theme.layout_tile = themes_path.."layouts/tilew.png"
theme.layout_tiletop = themes_path.."layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."layouts/spiralw.png"
theme.layout_dwindle = themes_path.."layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."layouts/cornernww.png"
theme.layout_cornerne = themes_path.."layouts/cornernew.png"
theme.layout_cornersw = themes_path.."layouts/cornersww.png"
theme.layout_cornerse = themes_path.."layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, "#f85e84", "#2d2a2e"
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Set different colors for urgent notifications.
rnotification.connect_signal('request::rules', function()
    rnotification.append_rule {
        rule       = { urgency = 'critical' },
        properties = { bg = '#ff0000', fg = '#ffffff' }
    }
end)

return theme
