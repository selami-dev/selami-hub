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

local button = game:GetService("Players").LocalPlayer.PlayerGui.Interface.Game.InGameActionsBar.Actions.Dive

local buttonPos = button.AbsolutePosition

local VirtualInputManager = game:GetService("VirtualInputManager")
VirtualInputManager:SendMouseButtonEvent(buttonPos.X, buttonPos.Y, 0, true, game, 0)
task.wait()
VirtualInputManager:SendMouseButtonEvent(buttonPos.X, buttonPos.Y, 0, false, game, 0)
