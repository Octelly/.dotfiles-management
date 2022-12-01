-- Window management and misc library
local awful = require("awful")

local prompt = require("ux.prompt")




local tags = {}

tags.new = function(screen)
    awful.tag.add("["..tostring(#screen.tags + 1).."]", {
        --icon               = "/path/to/icon1.png",
        --layout             = awful.layout.suit.tile,
        --master_fill_policy = "master_width_factor",
        --igap_single_client  = true,
        --gap                = 15,
        screen             = screen,
        selected           = #screen.tags < 1,
    }):view_only()
end

tags.close = function(tag)
    s = tag.screen

    awful.tag.viewprev()
    tag:delete()

    if #s.tags < 1 then
        tags.new(s)
    end
end

tags.rename = function(tag)
    prompt.string{
        prompt="Rename",
        default=tag.name,
        callback=function(value)
            tag.name = value
        end,
    }
end

-- FIXME: this gon be painful to do seems like
-- tags.move_left = function(tag)
--     if tag.index == 1 then
--         tag:swap(tag.screen.tags[#tag.screen.tags])
--     end
-- end


tags.populate_screen_with_defaults = function(screen)
    tags.new(screen)
end

return tags
