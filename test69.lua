do
	local old
	old = hookmetamethod(game, "__namecall", function(self, ...)
		local namecall = getnamecallmethod()
		if
			not checkcaller()
			and namecall == "InvokeServer"
			and typeof(self) == "Instance"
			and self.ClassName == "RemoteFunction"
			and self.Name == "Ping"
		then
			local args = table.pack(...)
			if typeof(args[2]) == "table" then
				args[2] = {}
				warn("Bypassed")
				return old(self, table.unpack(args))
			end
		end
		return old(self, ...)
	end)
end
