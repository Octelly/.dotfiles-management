-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

local _M = {}
local modkey = "Mod4"

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
    local clientbuttons = gears.table.join(

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

    return clientbuttons
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
