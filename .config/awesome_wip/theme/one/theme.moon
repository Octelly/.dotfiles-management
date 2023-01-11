elly = require "elly_standard_lib"
gfs = require "gears.filesystem"


theme = dofile("#{gfs.get_themes_dir()}default/theme.lua")


with theme
    .path = elly.os.path!

    .fonts = require "#{theme.path}fonts"
    .font = theme.fonts.body.medium
