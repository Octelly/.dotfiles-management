-- Window management and misc library
local awful = require("awful")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")


local popup = awful.popup{
    widget = {
        {   
            {
                {
                    id = "textbox",
                    font = "Sans 15",
                    widget = wibox.widget.textbox,
                },
                id = "b",
                bg = beautiful.bg_focus,
                fg = beautiful.fg_focus,
                widget = wibox.container.background,
            },
            id = "prompt",
            margins = 5,
            color = beautiful.bg_focus,
            widget = wibox.container.margin,
        },
        {
            {
                {
                    id = "textbox",
                    font = "Sans 15",
                    widget = wibox.widget.textbox,
                },
                id = "b",
                bg = beautiful.bg_normal,
                fg = beautiful.fg_normal,
                widget = wibox.container.background,
            },
            id = "text",
            margins = 5,
            color = beautiful.bg_normal,
            widget = wibox.container.margin,
        },
        layout = wibox.layout.fixed.horizontal,
    },
    placement = awful.placement.centered,
    hide_on_right_click = false,
}


local prompt = {}

prompt.string = function(dict)
    if dict.prompt == nil then dict.prompt = "" end

    local value = ""

    keygrabber = awful.keygrabber{
        stop_key = { "Return", "Escape" },

        keypressed_callback = function(self, mod, key, event)

            -- parse key input
            if #key == 1 then
                value = value .. key
            elseif key == "space" then
                value = value .. " "
            elseif key == "BackSpace" then

                -- cancel the prompt if backspace on empty
                if #value == 0 then self:stop() end

                value = string.sub(value, 1, -2)
            end

            -- update popup text
            popup.widget.text.b.textbox.text = value
        end,

        stop_callback = function(self, stop_key, stop_mods, sequence)
            popup.visible = false

            -- enter (return) confirms the prompt
            if stop_key == "Return" then
                dict.callback(value)
            end
        end,
    }

    popup.widget.prompt.b.textbox.text = dict.prompt
    popup.widget.text.b.textbox.text = value
    popup.visible = true
    keygrabber:start()
end

return prompt
