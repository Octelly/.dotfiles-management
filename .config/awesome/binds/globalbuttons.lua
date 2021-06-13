-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
    local globalbuttons = gears.table.join(
        -- show main menu
        awful.button({ }, 3, function () mymainmenu:toggle() end),

        -- change tag
        -- -> modkey + scroll
        awful.button({ modkey }, 4, awful.tag.viewprev),
        awful.button({ modkey }, 5, awful.tag.viewnext)
    )

    return globalbuttons
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
