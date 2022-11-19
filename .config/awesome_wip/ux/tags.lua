-- Window management and misc library
local awful = require("awful")





local tags = {}

tags.new = function(screen)
    awful.tag.add("Tag " .. tostring(#screen.tags + 1), {
        --icon               = "/path/to/icon1.png",
        --layout             = awful.layout.suit.tile,
        --master_fill_policy = "master_width_factor",
        --igap_single_client  = true,
        --gap                = 15,
        screen             = screen,
        selected           = #screen.tags < 1,
    })
end

tags.close = function(tag)
    s = tag.screen

    tag:delete()

    if #s.tags < 1 then
        tags.new(s)
    end
end


tags.populate_screen_with_defaults = function(screen)
    tags.new(screen)
end

return tags
