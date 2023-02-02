--- An opinionated "standard library" for LUA/MoonScript
-- Coming from Python to other languages is hard,
-- I'm used to Python's massive, absolutely enormous
-- standard libraries.

{
    os: {
        path: ->
            -- https://stackoverflow.com/a/35072122
            debug.getinfo(2).source\match("@?(.*/)")
    }
}
