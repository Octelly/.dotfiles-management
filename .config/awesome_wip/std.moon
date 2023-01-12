--- An opinionated "standard library" for LUA/MoonScript
-- Coming from Python to other languages is hard,
-- I'm used to Python's massive, absolutely enormous
-- standard libraries.

{
    table: {
        merge: (t1, t2) ->
            x = {table.unpack(t1)}

            for k, v in pairs t2
                x[k] = v

            return x
    },
    os: {
        path: ->
            -- https://stackoverflow.com/a/35072122
            debug.getinfo(2).source\match("@?(.*/)")
    }
}
