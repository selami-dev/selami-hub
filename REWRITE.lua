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

-- hitbox expander
local multi = 10
ENABLED = true

local old
	old = hookmetamethod(game, "__namecall", function(self, ...)
			local args = { ... }
			if
				ENABLED
				--and not checkcaller()
				and rawequal(self, workspace)
				and getnamecallmethod() == "GetPartsInPart"
			then
				local hitboxPart = args[1]
				local overlapParams = args[2]

				print("now 1.")
				if
					rawequal(args[3], nil)
					and (
						typeof(hitboxPart) == "Instance"
						and hitboxPart.IsA(hitboxPart, "BasePart")
						and typeof(overlapParams) == "OverlapParams"
					)
				then
					local testPart = overlapParams.FilterDescendantsInstances[1]
					if testPart and testPart.HasTag(testPart, "Ball") then
                        print("now.")
						local oldSize = hitboxPart.Size
						hitboxPart.Size = oldSize * multi
						local result = old(self, ...)
						hitboxPart.Size = oldSize
						return result
					end
				end
			end

			return old(self, unpack(args))
end)


--- HİTBOX
local lastHitboxName;
local old; old = hookfunction()

local hitboxMulti = {

}

