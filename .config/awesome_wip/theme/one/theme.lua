-- Filesystem library
local gfs = require("gears.filesystem")


-- inherit default theme
local theme = dofile(gfs.get_themes_dir() .. "default/theme.lua")

return theme
