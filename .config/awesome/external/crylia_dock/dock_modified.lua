--------------------------------------------------------------------------------------------------------------
-- This is the statusbar, every widget, module and so on is combined to all the stuff you see on the screen --
--------------------------------------------------------------------------------------------------------------
-- Awesome Libs
local awful = require("awful")
local color = require("external.crylia_dock.colors")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")

-- fixes {{{
require("external.crylia_dock.icon_handler")

-- https://github.com/Crylia/crylia-theme/blob/3084786c002f35647337d2f534abbd379033997d/awesome/src/core/signals.lua#L98-L184 {{{
--- Takes a wibox.container.background and connects four signals to it
---@param widget widget.container.background
---@param bg string
---@param fg string
function Hover_signal(widget, bg, fg)
  local old_wibox, old_cursor, old_bg, old_fg

  local mouse_enter = function()
    if bg then
      old_bg = widget.bg
      if string.len(bg) == 7 then
        widget.bg = bg .. 'dd'
      else
        widget.bg = bg
      end
    end
    if fg then
      old_fg = widget.fg
      widget.fg = fg
    end
    local w = mouse.current_wibox
    if w then
      old_cursor, old_wibox = w.cursor, w
      w.cursor = "hand1"
    end
  end

  local button_press = function()
    if bg then
      if bg then
        if string.len(bg) == 7 then
          widget.bg = bg .. 'bb'
        else
          widget.bg = bg
        end
      end
    end
    if fg then
      widget.fg = fg
    end
  end

  local button_release = function()
    if bg then
      if bg then
        if string.len(bg) == 7 then
          widget.bg = bg .. 'dd'
        else
          widget.bg = bg
        end
      end
    end
    if fg then
      widget.fg = fg
    end
  end

  local mouse_leave = function()
    if bg then
      widget.bg = old_bg
    end
    if fg then
      widget.fg = old_fg
    end
    if old_wibox then
      old_wibox.cursor = old_cursor
      old_wibox = nil
    end
  end

  widget:disconnect_signal("mouse::enter", mouse_enter)

  widget:disconnect_signal("button::press", button_press)

  widget:disconnect_signal("button::release", button_release)

  widget:disconnect_signal("mouse::leave", mouse_leave)

  widget:connect_signal("mouse::enter", mouse_enter)

  widget:connect_signal("button::press", button_press)

  widget:connect_signal("button::release", button_release)

  widget:connect_signal("mouse::leave", mouse_leave)

end
-- }}}

local user_vars = {
  icon_theme = "WhiteSur-dark",
  dock_icon_size = dpi(50)
}
-- }}}

return function(screen, programs)

  local function create_dock_element(class, program, name, user_icon, is_steam, size)
    if program == nil or class == nil then
      return
    end
    is_steam = is_steam or false
    user_icon = user_icon or nil
    local dock_element = wibox.widget {
      {
        {
          {
            resize = true,
            forced_width = size,
            forced_height = size,
            image = user_icon or Get_icon(user_vars.icon_theme, nil, program, class, is_steam),
            widget = wibox.widget.imagebox,
            id = "icon",
          },
          margins = dpi(5),
          widget = wibox.container.margin,
          id = "margin"
        },
        shape = function(cr, width, height)
          gears.shape.rounded_rect(cr, width, height, 10)
        end,
        bg = color["Grey900"],
        widget = wibox.container.background,
        id = "background"
      },
      top = dpi(5),
      left = dpi(5),
      right = dpi(5),
      widget = wibox.container.margin
    }

    for _, c in ipairs(client.get()) do
      if string.lower(c.class):match(program) and c == client.focus then
        dock_element.background.bg = color["Grey800"]
      end
    end

    Hover_signal(dock_element.background, color["Grey800"], color["White"])

    dock_element:connect_signal(
      "button::press",
      function()
        if is_steam then
          awful.spawn("steam steam://rungameid/" .. program)
        else
          awful.spawn(program)
        end
      end
    )

    awful.tooltip {
      objects = { dock_element },
      text = name,
      mode = "outside",
      preferred_alignments = "middle",
      margins = dpi(10)
    }

    return dock_element
  end

  local dock = awful.popup {
    widget = wibox.container.background,
    ontop = true,
    bg = color["Grey900"],
    visible = true,
    screen = screen,
    type = "dock",
    height = user_vars.dock_icon_size + 10,
    placement = function(c) awful.placement.bottom(c, { margins = dpi(10) }) end,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 15)
    end
  }

  local fakedock = awful.popup {
    widget = wibox.container.background,
    ontop = true,
    bg = '#00000000',
    visible = true,
    screen = screen,
    type = "dock",
    id = "fakedock",
    height = 2.5,
    placement = function(c) awful.placement.bottom(c, { margins = dpi(0) }) end,
  }

  local function get_dock_elements(pr)
    local dock_elements = { layout = wibox.layout.fixed.horizontal }

    for i, p in ipairs(pr) do
      dock_elements[i] = create_dock_element(p[1], p[2], p[3], p[4], p[5], user_vars.dock_icon_size)
    end

    return dock_elements
  end

  local dock_elements = get_dock_elements(programs)

  local function get_fake_elements(amount)
    local fake_elements = { layout = wibox.layout.fixed.horizontal }

    for i = 0, amount, 1 do
      fake_elements[i] = wibox.widget {
        bg = '00000000',
        forced_width = user_vars.dock_icon_size + dpi(20),
        forced_height = dpi(10),
        id = "fake",
        widget = wibox.container.background
      }
    end
    return fake_elements
  end

  local function create_incicator_widget(prog)
    local container = { layout = wibox.layout.flex.horizontal }
    local clients = client.get()
    for index, pr in ipairs(prog) do
      local indicators = { layout = wibox.layout.flex.horizontal, spacing = dpi(5) }
      local col = color["Grey600"]
      for i, c in ipairs(clients) do
        if string.lower(c.class or c.name):match(string.lower(pr[1]) or string.lower(pr[2])) then
          if c == client.focus then
            col = color["YellowA200"]
          elseif c.urgent then
            col = color["RedA200"]
          elseif c.maximized then
            col = color["GreenA200"]
          elseif c.minimized then
            col = color["BlueA200"]
          elseif c.fullscreen then
            col = color["PinkA200"]
          else
            col = color["Grey600"]
          end
          indicators[i] = wibox.widget {
            widget = wibox.container.background,
            shape = gears.shape.rounded_rect,
            forced_height = dpi(3),
            bg = col,
            forced_width = dpi(5),
          }
        end
      end
      container[index] = wibox.widget {
        indicators,
        forced_height = dpi(5),
        forced_width = dpi(50),
        left = dpi(5),
        right = dpi(5),
        widget = wibox.container.margin,
      }
    end

    return wibox.widget {
      container,
      bottom = dpi(5),
      widget = wibox.container.margin,
    }
  end

  fakedock:setup {
    get_fake_elements(#programs),
    type = 'dock',
    layout = wibox.layout.fixed.vertical
  }

  local function check_for_dock_hide(s)
    for _, client in ipairs(s.selected_tag:clients()) do
      if client.fullscreen then
        dock.visible = false
        fakedock.visible = false
      else
        fakedock.visible = true
      end
    end
    if #s.selected_tag:clients() < 1 then
      dock.visible = true
      return
    end
    if s == mouse.screen then
      local minimized
      for _, c in ipairs(s.selected_tag:clients()) do
        if c.minimized then
          minimized = true
        end
        if c.maximized or c.fullscreen then
          dock.visible = false
          return
        end
        if not c.minimized then
          local y = c:geometry().y
          local h = c.height
          if (y + h) >= s.geometry.height - user_vars.dock_icon_size - 35 then
            dock.visible = false
            return
          else
            dock.visible = true
          end
        end
      end
      if minimized then
        dock.visible = true
      end
    else
      dock.visible = false
    end
  end

  local dock_intelligent_hide = gears.timer {
    timeout = 1,
    autostart = true,
    call_now = true,
    callback = function()
      check_for_dock_hide(screen)
    end
  }

  fakedock:connect_signal(
    "mouse::enter",
    function()
      for _, c in ipairs(screen.clients) do
        if not c.fullscreen then
          dock_intelligent_hide:stop()
          dock.visible = true
        end
      end
    end
  )

  client.connect_signal(
    "manage",
    function()
      check_for_dock_hide(screen)
      dock:setup {
        dock_elements,
        create_incicator_widget(programs),
        layout = wibox.layout.fixed.vertical
      }
    end
  )

  client.connect_signal(
    "property::minimized",
    function()
      check_for_dock_hide(screen)
      dock:setup {
        dock_elements,
        create_incicator_widget(programs),
        layout = wibox.layout.fixed.vertical
      }
    end
  )

  client.connect_signal(
    "unmanage",
    function()
      check_for_dock_hide(screen)
      dock:setup {
        dock_elements,
        create_incicator_widget(programs),
        layout = wibox.layout.fixed.vertical
      }
    end
  )

  client.connect_signal(
    "focus",
    function()
      check_for_dock_hide(screen)
      dock:setup {
        dock_elements,
        create_incicator_widget(programs),
        layout = wibox.layout.fixed.vertical
      }
    end
  )

  dock:connect_signal(
    "mouse::enter",
    function()
      dock_intelligent_hide:stop()
    end
  )

  dock:connect_signal(
    "mouse::leave",
    function()
      dock_intelligent_hide:again()
    end
  )

  dock:setup {
    get_dock_elements(programs),
    create_incicator_widget(programs),
    layout = wibox.layout.fixed.vertical
  }
end
