-- Filesystem library
local gfs = require("gears.filesystem")


-- inherit default theme
local theme = dofile(gfs.get_themes_dir() .. "default/theme.lua")

-- get this theme's dir
-- https://stackoverflow.com/a/35072122
theme.path = debug.getinfo(1).source:match("@?(.*/)")


theme.fonts = require( theme.path .. "fonts")
theme.font = theme.fonts.body.medium

return theme
