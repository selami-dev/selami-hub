local func

local Serializer = loadstring(
	game:HttpGet("https://raw.githubusercontent.com/regginator/LuaEncode/refs/heads/master/src/LuaEncode.lua")
)()

local old
old = hookfunction(func, function(...)
	local args = table.pack(...)
	warn(Serializer(args, { Prettify = true }))
	return old(...)
end)
