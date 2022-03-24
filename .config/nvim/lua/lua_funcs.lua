-- note:
-- Using LUA for me has always been quite interesting.
-- I'm used to Python's huge standard lib collection
-- and coming from Python to LUA can be quite jarring
-- in this regard.
--
-- Many of the things that I'm used to being a part of
-- Python by default just don't really exist in standard
-- LUA.
--
-- This always meant that no matter if I was working with
-- SMBX 2.0's LunaLUA, ComputerCraft, Love2D or AwesomeWM
-- (I don't like AwesomeWM very much btw) I've always had
-- to create a module like this for myself, because I
-- always end up missing "basic" functionality.

local lua_funcs = {}

-- https://shanekrolikowski.com/blog/love2d-merge-tables/
-- similiar to:
-- 		https://gist.github.com/qizhihere/cb2a14432d9bf65693ad
function lua_funcs.merge_tables(t1, t2)
        for k, v in pairs(t2) do
                t1[k] = v
        end

        return t1
end

return lua_funcs
