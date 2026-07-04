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

local Serializer = loadstring(
	game:HttpGet("https://raw.githubusercontent.com/regginator/LuaEncode/refs/heads/master/src/LuaEncode.lua")
)()

local DoMove = require(game:GetService("ReplicatedFirst").Controllers.GameController.Actions.Move.DoMove)

local old
old = hookfunction(DoMove, function(...)
	local args = table.pack(...)
	warn(Serializer(args, { Prettify = true }))
	return old(...)
end)

-->> NO DEBOUNCE 👌

local Orchestrator =
	require(game:GetService("ReplicatedFirst").Controllers.GameController.Actions.Move.DoMove.Orchestrator)
local old

old = hookfunction(
	Orchestrator.handleInteractionAndDebounce,
	newcclosure(function(self, ...)
		if getgenv().NoDebounce then
			self.Debounce = 0
		end
		return old(self, ...)
	end)
)
local GameController = require(game:GetService("ReplicatedFirst").Controllers.GameController)

--->> NO CD (to be done) 🗿
--[[
local val = GameController.IsBusy
local ENABLED = true
local LocalPlayer = game.Players.LocalPlayer
local old
old = hookfunction(
	val.set,
	newcclosure(function(self, ...)
		if ENABLED and not checkcaller() and rawequal(self, val) then
			if not GameController.IsServing.get(GameController.IsServing) then
				return old(self, false)
			end
		end
		return old(self, ...)
	end)
)

]]

-->> HITBOX 👍
local HitboxMove
local ClientHitbox =
	require(game:GetService("ReplicatedFirst").Controllers.GameController.Actions.Move.DoMove.ClientHitbox)
local old
old = hookfunction(
	ClientHitbox.new,
	newcclosure(function(self, ...)
		HitboxMove = self.MovementName
		return old(self, ...)
	end)
)

local HitboxValues = getgenv().HitboxValues or {}
getgenv().HitboxValues = HitboxValues

local Hitboxes = game:GetService("ReplicatedStorage").Assets.HitboxesNew.Default.Assemblies

for _, v: Instance in Hitboxes:GetChildren() do
	HitboxValues[v.Name] = HitboxValues[v.Name] or 1
end

print(Serializer(HitboxValues, { Prettify = true }))

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
		if
			rawequal(args[3], nil)
			and (
				typeof(hitboxPart) == "Instance"
				and hitboxPart.IsA(hitboxPart, "BasePart")
				and typeof(overlapParams) == "OverlapParams"
				and HitboxMove
				and HitboxValues[HitboxMove]
			)
		then
			local testPart = overlapParams.FilterDescendantsInstances[1]
			if testPart and testPart.HasTag(testPart, "Ball") then
				local oldSize = hitboxPart.Size
				hitboxPart.Size = oldSize * HitboxValues[HitboxMove]
				local result = old(self, ...)
				hitboxPart.Size = oldSize
				return result
			end
		end
	end

	return old(self, unpack(args))
end)

-- Modify

--[[
local HitboxValues = getgenv().HitboxValues
for key, val in HitboxValues do
	HitboxValues[key] = 10
end
]]

local zapModule = require(game:GetService("ReplicatedFirst").Controllers.BallController.Network)
local BallStream = zapModule.BallStream

local Serializer = loadstring(
	game:HttpGet("https://raw.githubusercontent.com/regginator/LuaEncode/refs/heads/master/src/LuaEncode.lua")
)()

warn(Serializer({ debug.getupvalues(BallStream.SetCallback) }, { Prettify = true }))
