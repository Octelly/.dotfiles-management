elly = require "elly_standard_lib"
gfs = require "gears.filesystem"


theme = dofile("#{gfs.get_themes_dir()}default/theme.lua")

theme.path = elly.os.path!

theme.fonts = require "#{theme.path}fonts"
theme.font = theme.fonts.body.medium


return theme
