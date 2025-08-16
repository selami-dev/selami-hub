local VERSION = "2.0.05"
task.wait(1)

-->> LDSTN
--	loadstring(game:HttpGet('https://gitlab.com/selamists/selamihub/-/raw/main/build/Games/VoleyballLegends.lua'))()

-- AC BYPASS
do
	local old
	old = hookmetamethod(game, "__namecall", function(self, ...)
		local namecall = getnamecallmethod()
		if
			not checkcaller()
			and namecall == "InvokeServer"
			and typeof(self) == "Instance"
			and self.ClassName == "RemoteFunction"
			and self.Name == "Check"
		then
			local args = table.pack(...)
			if typeof(args[3]) == "table" then
				args[3] = {}
				warn("Bypassed")
				return old(self, table.unpack(args))
			end
		end
		return old(self, ...)
	end)
end

--print(SELAMI_HUB)
local SELAMI_HUB = getgenv().SELAMI_HUB

if not SELAMI_HUB then
	--error("🛑 SELAMI_HUB is not defined")
	return false, "SELAMI_HUB is not defined."
end

if not SELAMI_HUB.Key or type(SELAMI_HUB.Key) ~= "string" or SELAMI_HUB.Key ~= "LexinKocaMemeleri" then
	--error("🛑 Invalid Key")
	return false, "Invalid Key."
end

local HaikyuuRaper = SELAMI_HUB.ModuleLoader:LoadFromPath("Base.lua").new("Volleyball Legends")

local Janitor = HaikyuuRaper.Janitor
local Signal = HaikyuuRaper.Signal
local ConfigHandler = HaikyuuRaper.configHandler

local Window = HaikyuuRaper.window:CreateTab({
	Name = "🏐 Volleyball Legends " .. VERSION,
	Visible = true,
})

local hooks = HaikyuuRaper.hooks

local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
if
	LocalPlayer.PlayerGui:WaitForChild("RankedQueueGui", 10)
	and LocalPlayer.PlayerGui:FindFirstChild("RankedQueueGui").Enabled
then
	task.wait(1)
	if LocalPlayer.PlayerGui:FindFirstChild("RankedQueueGui").Enabled then
		HaikyuuRaper:Notify(
			"🏐 Volleyball Legends",
			"⏳ Detected Ranked Queue, Waiting for Game (Re-Execute if not correct)",
			nil,
			true
		)
		return true
	end
end

local notif1 = HaikyuuRaper:Notify("🏐 Volleyball Legends", "🔁 Loading...", nil, true)

require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit")).OnStart():await()

if not LocalPlayer:GetAttribute("DataLoaded") then
	LocalPlayer:GetAttributeChangedSignal("DataLoaded"):Wait()
end

local map = workspace:WaitForChild("Map")

local function getCourtPart()
	for _, v in CollectionService:GetTagged("Court") do
		if v:IsDescendantOf(map) then
			return v
		end
	end
end

local CourtPart
repeat
	task.wait()
	CourtPart = getCourtPart()
until CourtPart

local gameController

gameController = require(ReplicatedFirst:WaitForChild("Controllers"):WaitForChild("GameController"))

local GameModule

local function solveQuadratic(a, b, c)
	if math.abs(a) < 1e-12 then -- linear fallback
		if math.abs(b) < 1e-12 then
			return nil
		end
		local t = -c / b
		return t > 0 and t or nil
	end

	local discriminant = b * b - 4 * a * c
	if discriminant < 0 then
		return nil
	end

	local sqrtDisc = math.sqrt(discriminant)
	local denom = 2 * a

	local t1 = (-b + sqrtDisc) / denom
	local t2 = (-b - sqrtDisc) / denom

	if t1 > 0 and t2 > 0 then
		return (t1 < t2) and t1 or t2
	elseif t1 > 0 then
		return t1
	elseif t2 > 0 then
		return t2
	end
	return nil
end

local function cbrt(x)
	return x >= 0 and x ^ (1 / 3) or -((-x) ^ (1 / 3))
end

local function solveCubic(a, b, c, d)
	if math.abs(a) < 1e-12 then
		return solveQuadratic(b, c, d)
	end

	-- Normalize
	local invA = 1 / a
	b, c, d = b * invA, c * invA, d * invA

	-- Depressed cubic substitution: t = x - b/3
	local bb = b * b
	local p = (3 * c - bb) / 3
	local q = (2 * bb * b - 9 * b * c + 27 * d) / 27
	local discriminant = (q * q) / 4 + (p * p * p) / 27

	if discriminant >= 0 then
		local sqrtDisc = math.sqrt(discriminant)
		local u = cbrt(-q / 2 + sqrtDisc)
		local v = cbrt(-q / 2 - sqrtDisc)
		local t = u + v - b / 3
		return t > 0 and t or nil
	else
		local sqrtP = math.sqrt(-p / 3)
		local phi = math.acos(-q / (2 * sqrtP ^ 3))
		local offset = -b / 3

		local t1 = 2 * sqrtP * math.cos(phi / 3) + offset
		local t2 = 2 * sqrtP * math.cos((phi + 2 * math.pi) / 3) + offset
		local t3 = 2 * sqrtP * math.cos((phi + 4 * math.pi) / 3) + offset

		local minT = math.huge
		for _, t in ipairs({ t1, t2, t3 }) do
			if t > 0 and t < minT then
				minT = t
			end
		end
		return (minT < math.huge) and minT or nil
	end
end

local function zapModule()
	local v1 = game:GetService("ReplicatedStorage")
	local v2 = game:GetService("RunService")
	local u3 = nil
	local u4 = nil
	local u5 = nil
	local u6 = nil
	local _ = nil
	local u7 = nil
	local u8 = nil
	local u9 = nil
	local u10 = nil
	local _ = {
		CFrame.Angles(0, 0, 0),
		CFrame.Angles(1.5707963267948966, 0, 0),
		CFrame.Angles(0, 3.141592653589793, 3.141592653589793),
		CFrame.Angles(-1.5707963267948966, 0, 0),
		CFrame.Angles(0, 3.141592653589793, 1.5707963267948966),
		CFrame.Angles(0, 1.5707963267948966, 1.5707963267948966),
		CFrame.Angles(0, 0, 1.5707963267948966),
		CFrame.Angles(0, -1.5707963267948966, 1.5707963267948966),
		CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0),
		CFrame.Angles(0, -1.5707963267948966, 0),
		CFrame.Angles(1.5707963267948966, -1.5707963267948966, 0),
		CFrame.Angles(0, 1.5707963267948966, 3.141592653589793),
		CFrame.Angles(0, -1.5707963267948966, 3.141592653589793),
		CFrame.Angles(0, 3.141592653589793, 0),
		CFrame.Angles(-1.5707963267948966, -3.141592653589793, 0),
		CFrame.Angles(0, 0, 3.141592653589793),
		CFrame.Angles(1.5707963267948966, 3.141592653589793, 0),
		CFrame.Angles(0, 0, -1.5707963267948966),
		CFrame.Angles(0, -1.5707963267948966, -1.5707963267948966),
		CFrame.Angles(0, -3.141592653589793, -1.5707963267948966),
		CFrame.Angles(0, 1.5707963267948966, -1.5707963267948966),
		CFrame.Angles(1.5707963267948966, 1.5707963267948966, 0),
		CFrame.Angles(0, 1.5707963267948966, 0),
		CFrame.Angles(-1.5707963267948966, 1.5707963267948966, 0),
	}
	u3 = buffer.create(64)
	u4 = 0
	u5 = 64
	u6 = {}
	if not v2:IsRunning() then
		local function v11() --[[Anonymous function at line 106]]
		end
		local v12 = table.freeze
		local v13 = {
			["SendEvents"] = v11,
			["BallStream"] = table.freeze({
				["SetCallback"] = v11,
			}),
		}
		return v12(v13)
	end
	if v2:IsServer() then
		error("Cannot use the client module on the server!")
	end
	local v14 = v1:WaitForChild("ZAP")
	local u15 = v14:WaitForChild("ZAP_RELIABLE")
	local v16 = v14:WaitForChild("ZAP_UNRELIABLE")
	local v17 = u15:IsA("RemoteEvent")
	assert(v17, "Expected ZAP_RELIABLE to be a RemoteEvent")
	local v18 = v16:IsA("UnreliableRemoteEvent")
	assert(v18, "Expected ZAP_UNRELIABLE to be an UnreliableRemoteEvent")
	local function v20() --[[Anonymous function at line 124]]
		--[[
    Upvalues:
        [1] = u4
        [2] = u3
        [3] = u15
        [4] = u6
        [5] = u5
    --]]
		if u4 ~= 0 then
			local v19 = buffer.create(u4)
			buffer.copy(v19, 0, u3, 0, u4)
			u15:FireServer(v19, u6)
			u3 = buffer.create(64)
			u4 = 0
			u5 = 64
			table.clear(u6)
		end
	end
	v2.Heartbeat:Connect(v20)
	local u21 = table.create(1)
	local u22 = table.create(1)
	u22[1] = {}
	u15.OnClientEvent:Connect(function(p23, p24) --[[Anonymous function at line 143]]
		--[[
    Upvalues:
        [1] = u7
        [2] = u9
        [3] = u8
        [4] = u10
        [5] = u21
        [6] = u22
    --]]
		u7 = p23
		u9 = p24
		u8 = 0
		u10 = 0
		local v25 = buffer.len(p23)
		while u8 < v25 do
			local v26 = u8
			u8 = u8 + 1
			if buffer.readu8(p23, v26) == 1 then
				local v27 = {}
				local v28 = u7
				local v29 = u8
				u8 = u8 + 4
				local v30 = buffer.readf32(v28, v29)
				local v31 = u7
				local v32 = u8
				u8 = u8 + 4
				local v33 = buffer.readf32(v31, v32)
				local v34 = u7
				local v35 = u8
				u8 = u8 + 4
				local v36 = buffer.readf32(v34, v35)
				local v37 = Vector3.new(v30, v33, v36)
				local v38 = u7
				local v39 = u8
				u8 = u8 + 4
				local v40 = buffer.readf32(v38, v39)
				local v41 = u7
				local v42 = u8
				u8 = u8 + 4
				local v43 = buffer.readf32(v41, v42)
				local v44 = u7
				local v45 = u8
				u8 = u8 + 4
				local v46 = buffer.readf32(v44, v45)
				local v47 = Vector3.new(v40, v43, v46)
				local v48 = v47.Magnitude
				if v48 == 0 then
					v27.cframe = CFrame.new(v37)
				else
					v27.cframe = CFrame.fromAxisAngle(v47, v48) + v37
				end
				local v49 = u7
				local v50 = u8
				u8 = u8 + 4
				local v51 = buffer.readf32(v49, v50)
				local v52 = u7
				local v53 = u8
				u8 = u8 + 4
				local v54 = buffer.readf32(v52, v53)
				local v55 = u7
				local v56 = u8
				u8 = u8 + 4
				local v57 = buffer.readf32(v55, v56)
				v27.velocity = Vector3.new(v51, v54, v57)
				local v58 = u7
				local v59 = u8
				u8 = u8 + 8
				v27.ID = buffer.readf64(v58, v59)
				local v60 = u7
				local v61 = u8
				u8 = u8 + 1
				if buffer.readu8(v60, v61) == 1 then
					local v62 = u7
					local v63 = u8
					u8 = u8 + 2
					local v64 = buffer.readu16(v62, v63)
					local v65 = buffer.readstring
					local v66 = u7
					local v67 = u8
					u8 = u8 + v64
					v27.Skin = v65(v66, v67, v64)
				else
					v27.Skin = nil
				end
				if u21[1] then
					task.spawn(u21[1], v27)
				else
					local v68 = u22[1]
					table.insert(v68, v27)
					if #u22[1] > 64 then
						warn(
							(
								("[ZAP] %* events in queue for BallStream. Did you forget to attach a listener?"):format(
									#u22[1]
								)
							)
						)
					end
				end
			else
				error("Unknown event id")
			end
		end
	end)
	local v71 = {
		["SendEvents"] = v20,
		["BallStream"] = {
			["SetCallback"] = function(p69) --[[Function name: SetCallback, line 198]]
				--[[
            Upvalues:
                [1] = u21
                [2] = u22
            --]]
				u21[1] = p69
				for _, v70 in u22[1] do
					task.spawn(p69, v70)
				end
				u22[1] = {}
				return function() --[[Anonymous function at line 211]]
					--[[
                Upvalues:
                    [1] = u21
                --]]
					u21[1] = nil
				end
			end,
		},
	}
	return v71
end
local BallStream = zapModule().BallStream

local BallTrajectory = {}
do
	BallTrajectory.OnBallAdded = Signal.new()
	BallTrajectory.OnBallRemoved = Signal.new()
	BallTrajectory.OnBallUpdated = Signal.new()

	GameModule = require(ReplicatedStorage:WaitForChild("Configuration"):WaitForChild("Game"))

	local Balls = {}

	-- Add and Removed Signals
	hooks:Add(CollectionService:GetInstanceAddedSignal("Ball"):Connect(function(ballModel)
		if ballModel:IsA("Model") then
			local self = {
				Model = ballModel,
				Position = ballModel.PrimaryPart.Position,
				Velocity = Vector3.zero,
				ServerVelocity = nil,
				Jerk = Vector3.zero,
				Acceleration = Vector3.yAxis * -GameModule.Physics.Gravity,
				LastUpdateClock = os.clock(),
			}
			Balls[ballModel:GetAttribute("ServerId")] = self
			BallTrajectory.OnBallAdded:Fire(self)
			--predictBallLanding(ballModel)
		end
	end))

	hooks:Add(CollectionService:GetInstanceRemovedSignal("Ball"):Connect(function(ballModel)
		if ballModel:IsA("Model") then
			local self = Balls[ballModel:GetAttribute("ServerId")]
			Balls[ballModel:GetAttribute("ServerId")] = nil
			BallTrajectory.OnBallRemoved:Fire(self)
		end
	end))

	-- Maths
	local function trajectoryResult(Ball)
		local velocity, position, acceleration, jerk =
			Ball.Velocity, Ball.Position, Ball.Acceleration, Ball.Jerk or Vector3.zero
		local floorY = CourtPart.Position.Y + CourtPart.Size.Y * 0.5 + GameModule.Physics.Radius

		-- Main trajectory calculation
		local a = (1 / 6) * jerk.Y
		local b = 0.5 * acceleration.Y
		local c = velocity.Y
		local d = position.Y - floorY

		local timeToHit = solveCubic(a, b, c, d)
		if not timeToHit then
			return nil, nil
		end

		local landingX = position.X
			+ velocity.X * timeToHit
			+ 0.5 * acceleration.X * timeToHit ^ 2
			+ (1 / 6) * jerk.X * timeToHit ^ 3
		local landingZ = position.Z
			+ velocity.Z * timeToHit
			+ 0.5 * acceleration.Z * timeToHit ^ 2
			+ (1 / 6) * jerk.Z * timeToHit ^ 3

		return Vector3.new(landingX, floorY, landingZ), timeToHit
	end

	local function predictBallLanding(ball)
		local resultVector, dT = trajectoryResult(ball)

		BallTrajectory.LastBall = ball
		--BallTrajectory.LastVelocity = ball.Velocity
		BallTrajectory.LastTrajectory = resultVector
		BallTrajectory.LastTime = dT

		BallTrajectory.OnBallUpdated:Fire(ball, resultVector, dT)
	end

	-- Progression function
	local function updateBall(ballData, dt)
		local clock = os.clock()
		dt = dt or clock - ballData.LastUpdateClock

		-- Use Acceleration property instead of gravity
		ballData.Position += ballData.Velocity * dt + 0.5 * ballData.Acceleration * dt * dt
		ballData.Velocity += ballData.Acceleration * dt

		-- Update LastUpdateClock
		ballData.LastUpdateClock = clock

		-->> Calculate Trajectory
		predictBallLanding(ballData)
		--BallTrajectory.OnBallUpdated:Fire(BallData)
	end

	-- Public Functions
	BallTrajectory.CalculateTrajectory = function(Data: { Velocity: Vector3, Position: Vector3, Acceleration: Vector3 })
		local resultVector, dT = trajectoryResult(Data)
		return resultVector, dT
	end

	BallTrajectory.IsInBoundsOfCourt = function(Position: Vector3)
		-- Get court information
		local courtPosition = CourtPart.Position
		local courtSize = CourtPart.Size
		local ballRadius = GameModule.Physics.Radius

		-- Check if landing position is within court boundaries on X axis (with radius)
		local isInXBounds = Position.X > (courtPosition.X - courtSize.X / 2 - ballRadius)
			and Position.X < (courtPosition.X + courtSize.X / 2 + ballRadius)

		-- Check if landing position is within court boundaries on Z axis (with radius)
		local isInZBounds = Position.Z > (courtPosition.Z - courtSize.Z / 2 - ballRadius)
			and Position.Z < (courtPosition.Z + courtSize.Z / 2 + ballRadius)

		-- Determine if ball is in bounds (both X and Z must be within court)
		return isInXBounds and isInZBounds
	end

	BallTrajectory.ClampVectorToCourt = function(origin: Vector3, target: Vector3)
		local courtPosition = CourtPart.Position
		local courtSize = CourtPart.Size
		local ballRadius = GameModule.Physics.Radius

		-- Calculate court bounds
		local minX = courtPosition.X - courtSize.X / 2 - ballRadius
		local maxX = courtPosition.X + courtSize.X / 2 + ballRadius
		local minZ = courtPosition.Z - courtSize.Z / 2 - ballRadius
		local maxZ = courtPosition.Z + courtSize.Z / 2 + ballRadius

		-- If already in bounds, return target
		if target.X >= minX and target.X <= maxX and target.Z >= minZ and target.Z <= maxZ then
			return target
		end

		-- Find intersection with court boundary along direction from origin to target
		local dir = (target - origin)
		local dirXZ = Vector3.new(dir.X, 0, dir.Z)
		if dirXZ.Magnitude == 0 then
			return origin
		end
		local unitDir = dirXZ.Unit

		-- Raycast from origin to court bounds
		local tMax = math.huge

		-- X bounds
		if unitDir.X ~= 0 then
			local tx1 = (minX - origin.X) / unitDir.X
			local tx2 = (maxX - origin.X) / unitDir.X
			local txMax = math.max(tx1, tx2)
			tMax = math.min(tMax, txMax)
		end

		-- Z bounds
		if unitDir.Z ~= 0 then
			local tz1 = (minZ - origin.Z) / unitDir.Z
			local tz2 = (maxZ - origin.Z) / unitDir.Z
			local tzMax = math.max(tz1, tz2)
			tMax = math.min(tMax, tzMax)
		end

		-- Clamp tMax to positive direction only
		tMax = math.max(0, math.min(tMax, dirXZ.Magnitude))

		local clampedXZ = origin + unitDir * tMax
		return Vector3.new(clampedXZ.X, target.Y, clampedXZ.Z)
	end

	BallTrajectory.RunPhysics = function(
		Data: {
			Velocity: Vector3,
			Position: Vector3,
			Acceleration: Vector3,
			Jerk: Vector3,
		},
		DeltaTime: number
	)
		local outputData = {}

		outputData.Position = Data.Position
			+ Data.Velocity * DeltaTime
			+ 0.5 * Data.Acceleration * DeltaTime ^ 2
			+ (1 / 6) * Data.Jerk * DeltaTime ^ 3 -- fixed from 1/3
		outputData.Velocity = Data.Velocity + Data.Acceleration * DeltaTime + 0.5 * Data.Jerk * DeltaTime ^ 2
		outputData.Acceleration = Data.Acceleration + Data.Jerk * DeltaTime
		outputData.Jerk = Data.Jerk -- constant jerk assumption

		return outputData
	end

	hooks:Add(RunService.Heartbeat:Connect(function(dt)
		for ID, BallData in Balls do
			updateBall(BallData)
		end
	end))

	local serverUpdateTime = 1 / 60
	BallStream.SetCallback(function(data)
		--warn(Serializer(data, { Prettify = true }))
		local BallData = Balls[data.ID]
		if BallData then
			--warn(BallData)
			BallData.Position = data.cframe.Position
			BallData.Velocity = data.velocity

			if BallData.ServerVelocity then
				local acceleration: Vector3 = (data.velocity - BallData.ServerVelocity) / serverUpdateTime
				if acceleration.Magnitude > 250 then
					acceleration = Vector3.yAxis * -GameModule.Physics.Gravity
				end

				local calculatedJerk = (acceleration - BallData.Acceleration) / serverUpdateTime

				if calculatedJerk.Magnitude > 250 then
					calculatedJerk = Vector3.zero
				end

				BallData.Acceleration = acceleration
				BallData.Jerk = calculatedJerk
			end

			BallData.ServerVelocity = data.velocity
			--RunService.RenderStepped:Wait()

			local deltaTime = LocalPlayer:GetNetworkPing() * 0.5
			updateBall(BallData, deltaTime)
		end
	end)

	BallTrajectory.GetAllBalls = function()
		return Balls
	end
end

-------
local StylePath = ReplicatedStorage:WaitForChild("Content"):WaitForChild("Style")
local AbilityPath = ReplicatedStorage:WaitForChild("Content"):WaitForChild("Ability")

local StyleModule = require(StylePath)
local StyleController = require(ReplicatedFirst:WaitForChild("Controllers"):WaitForChild("StyleController"))

local AbilityController = require(ReplicatedFirst:WaitForChild("Controllers"):WaitForChild("AbilityController"))
local AbilityModule = require(AbilityPath)

local function styleFromId(id)
	return require(StylePath:FindFirstChild(id))
end

local function abilityFromId(id)
	return require(AbilityPath:FindFirstChild(id))
end

do
	local RAY_LENGTH = 120
	local ANGLE = 10
	local AIR_CHECK = true
	local TEAM_CHECK = true

	local playerData = {}
	local BrightColors = {
		Color3.fromRGB(255, 99, 71),
		Color3.fromRGB(255, 165, 0),
		Color3.fromRGB(255, 255, 0),
		Color3.fromRGB(0, 255, 0),
		Color3.fromRGB(0, 255, 255),
		Color3.fromRGB(30, 144, 255),
		Color3.fromRGB(138, 43, 226),
		Color3.fromRGB(255, 20, 147),
		Color3.fromRGB(255, 105, 180),
	}

	local function getPlayerColor(player)
		if not playerData[player] then
			playerData[player] = { Color = BrightColors[math.random(#BrightColors)], Ray = nil }
		end
		return playerData[player].Color
	end

	local function updateRay(player)
		local character = player.Character
		if not character then
			return
		end

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid or humanoid:GetState() == Enum.HumanoidStateType.Seated then
			return
		end

		local state = humanoid:GetState()
		local inAir = state == Enum.HumanoidStateType.Freefall
			or state == Enum.HumanoidStateType.Jumping
			or humanoid.FloorMaterial == Enum.Material.Air
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if not rootPart then
			return
		end

		if (not TEAM_CHECK or player.Team ~= LocalPlayer.Team) and (not AIR_CHECK or inAir) then
			local tiltAngle = math.rad(ANGLE)
			local tiltedCFrame = rootPart.CFrame * CFrame.Angles(-tiltAngle, 0, 0)
			local direction = tiltedCFrame.LookVector * RAY_LENGTH

			local rayPart = playerData[player].Ray
			if not rayPart then
				rayPart = Instance.new("Part")
				rayPart.Anchored = true
				rayPart.CanCollide = false
				rayPart.Material = Enum.Material.Neon
				rayPart.Color = getPlayerColor(player)
				rayPart.Parent = workspace
				playerData[player].Ray = rayPart
			end

			rayPart.Size = Vector3.new(0.2, 0.2, RAY_LENGTH)
			rayPart.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + direction)
				* CFrame.new(0, 0, -RAY_LENGTH * 0.5)
			rayPart.Transparency = 0.6
		else
			if playerData[player].Ray then
				playerData[player].Ray.Transparency = 1
			end
		end
	end

	local connection
	local function setEnabled(v)
		if v then
			if not connection then
				connection = RunService.RenderStepped:Connect(function()
					for _, v in Players:GetPlayers() do
						updateRay(v)
					end
				end)
			end
		else
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end

	local function loadPlayer(player)
		getPlayerColor(player)
	end

	local function unloadPlayer(player)
		if playerData[player] and playerData[player].Ray then
			playerData[player].Ray:Destroy()
		end
		playerData[player] = nil
	end

	hooks:Add(function()
		setEnabled(false)

		for _, v in Players:GetPlayers() do
			unloadPlayer(v)
		end
	end)

	hooks:Add(Players.PlayerAdded:Connect(loadPlayer))
	hooks:Add(Players.PlayerRemoving:Connect(unloadPlayer))

	for _, v in Players:GetPlayers() do
		loadPlayer(v)
	end

	local RayTab = Window:CollapsingHeader({
		Title = "📡 Ray",
		Collapsed = true,
	})

	local RayMainNode = RayTab:TreeNode({
		Title = "Main",
		Collapsed = false,
	})

	ConfigHandler:AddElement(
		"RayEnabledToggle",
		RayMainNode:Checkbox({
			Label = "Enabled",
			Value = true,
			Callback = function(_, v)
				setEnabled(v)
			end,
		})
	)

	local RayConfigNode = RayTab:TreeNode({
		Title = "Config",
		Collapsed = false,
	})

	ConfigHandler:AddElement(
		"RayJumpCheckToggle",
		RayConfigNode:Checkbox({
			Label = "Jump Check",
			Value = AIR_CHECK,
			Callback = function(_, v)
				AIR_CHECK = v
			end,
		})
	)

	ConfigHandler:AddElement(
		"RayTeamCheckToggle",
		RayConfigNode:Checkbox({
			Label = "Team Check",
			Value = TEAM_CHECK,
			Callback = function(_, v)
				TEAM_CHECK = v
			end,
		})
	)

	ConfigHandler:AddElement(
		"RayLengthSlider",
		RayConfigNode:SliderInt({
			Label = "Length",
			Value = RAY_LENGTH,
			Minimum = 0,
			Maximum = 120,

			Callback = function(self, Value)
				RAY_LENGTH = Value
			end,
		})
	)

	ConfigHandler:AddElement(
		"RayAngleSlider",
		RayConfigNode:SliderInt({
			Label = "Angle",
			Value = ANGLE,
			Minimum = 0,
			Maximum = 50,
			Callback = function(self, Value)
				ANGLE = Value
			end,
		})
	)
end

do
	local CharacterTab = Window:CollapsingHeader({
		Title = "🧍 Character",
		Collapsed = true,
	})

	do
		local thread
		local connections = Janitor.new()

		local DLY_SLIDER = 0.33

		local function charAdded(char)
			connections:Add(
				char:GetAttributeChangedSignal("Jumping"):Connect(function()
					if char:GetAttribute("Jumping") then
						local hum = char:FindFirstChildOfClass("Humanoid")
						if not hum then
							return
						end
						thread = task.spawn(function()
							hum.AutoRotate = true
							task.wait(DLY_SLIDER)
							hum.AutoRotate = false
						end)
					else
						if thread then
							task.cancel(thread)
							thread = nil
						end
					end
				end),
				nil,
				"jumpCon"
			)
		end

		local function setEnabled(v)
			if v then
				connections:Add(LocalPlayer.CharacterAdded:Connect(charAdded))
				if LocalPlayer.Character then
					charAdded(LocalPlayer.Character)
				end
			else
				connections:Cleanup()
			end
		end

		hooks:Add(function()
			setEnabled(false)
		end)

		local AirRotateNode = CharacterTab:TreeNode({
			Title = "Air Rotate",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"CharacterRotateToggle",
			AirRotateNode:Checkbox({
				Label = "Enabled",
				Value = true,
				Callback = function(_, v)
					setEnabled(v)
				end,
			})
		)

		ConfigHandler:AddElement(
			"RotateOffDelaySlider",
			AirRotateNode:SliderFloat({
				Label = "Max Time",
				Format = "%.2f",
				Value = DLY_SLIDER,
				Minimum = 0,
				Maximum = 4,
				Callback = function(self, Value)
					DLY_SLIDER = Value
				end,
			})
		)
	end

	--[[
	do
		local WALKSPEED_VALUE = 26
		local ENABLED = true

		local connections = Janitor.new()

		local defaultWalkspeed = nil
		local currentHum = nil
		local function WalkSpeedChange()
			if LocalPlayer:GetAttribute("IsServing") then
				return
			end
			if currentHum then
				currentHum.WalkSpeed = WALKSPEED_VALUE
			end
		end

		local function charAdded(char)
			currentHum = char:WaitForChild("Humanoid", 2)
			if not currentHum then
				return
			end

			connections:Add(
				currentHum:GetPropertyChangedSignal("WalkSpeed"):Connect(WalkSpeedChange),
				nil,
				"WalkSpeedChange"
			)
			WalkSpeedChange()
		end

		local function setEnabled(v)
			ENABLED = v
			if v then
				connections:Add(LocalPlayer.CharacterAdded:Connect(charAdded))
				if LocalPlayer.Character then
					charAdded(LocalPlayer.Character)
				end
			else
				if currentHum and defaultWalkspeed then
					currentHum.WalkSpeed = defaultWalkspeed
				end
				connections:Cleanup()
			end
		end

		hooks:Add(function()
			setEnabled(false)
		end)

		local WalkspeedNode = CharacterTab:TreeNode({
			Title = "Walkspeed",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"WalkspeedEnabled",
			WalkspeedNode:Checkbox({
				Label = "Enabled",
				Value = ENABLED,
				Callback = function(_, v)
					setEnabled(v)
				end,
			})
		)

		ConfigHandler:AddElement(
			"WalkspeedValueSlider",
			WalkspeedNode:SliderInt({
				Label = "Speed",
				Value = WALKSPEED_VALUE,
				Minimum = 0,
				Maximum = 40,
				Callback = function(self, Value)
					WALKSPEED_VALUE = math.round(Value)
					if ENABLED then
						WalkSpeedChange()
					end
				end,
			})
		)
	end
	]]

	local AttributesNode = CharacterTab:TreeNode({
		Title = "Attributes",
		Collapsed = false,
	})

	local attributeModifiers = {}

	local old
	old = hookmetamethod(
		game,
		"__namecall",
		newcclosure(function(self, ...)
			local args = { ... }
			if rawequal(self, LocalPlayer) and getnamecallmethod() == "GetAttribute" then
				local attributeName = args[1]
				if attributeModifiers[attributeName] and attributeModifiers[attributeName].enabled then
					return attributeModifiers[attributeName].currentValue
				end
			end
			return old(self, ...)
		end)
	)

	local function attributeModifier(name, attributeName, baseVal, min, max)
		local defaultText

		local data = {
			enabled = false,
			currentValue = baseVal,
		}
		attributeModifiers[attributeName] = data

		local AttributeNode = AttributesNode:TreeNode({
			Title = name,
			Collapsed = false,
		})

		local row = AttributeNode:Row()

		local gameValue = LocalPlayer:GetAttribute(attributeName)
		hooks:Add(LocalPlayer:GetAttributeChangedSignal(name):Connect(function()
			gameValue = LocalPlayer:GetAttribute(name)
			--		warn("Aight?")
			defaultText:Destroy()
			defaultText = row:Label({
				Text = "default: " .. gameValue,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				RichText = false,
			})
		end))

		local slider = AttributeNode:SliderFloat({
			Label = name,
			Format = "%.2f",
			Value = baseVal,
			Minimum = min,
			Maximum = max,
			Callback = function(self, Value)
				data.currentValue = Value
			end,
		})
		ConfigHandler:AddElement(name .. "sliderAttribute", slider)

		local checkbox = row:Checkbox({
			Label = "Enabled",
			Value = data.enabled,
			Callback = function(_, value)
				data.enabled = value
			end,
		})
		ConfigHandler:AddElement(name .. "EnabledAttribute", checkbox)

		row:Button({
			Text = "Reset",
			Callback = function(self)
				slider:SetValue(gameValue)
			end,
		})

		defaultText = row:Label({
			Text = "default: " .. gameValue,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			RichText = false,
		})

		hooks:Add(function()
			table.clear(attributeModifiers)
		end)
	end

	attributeModifier("Dive Speed Mult.", "GameDiveSpeedMultiplier", 1.5, 0, 5)

	attributeModifier("Jump Power Mult.", "GameJumpPowerMultiplier", 1.15, 0, 5)

	attributeModifier("Speed Mult.", "GameSpeedMultiplier", 0.85, 0, 5)
end

local rarityModule = require(ReplicatedStorage.Content.Rarity)
local function colorFromRarity(rarity)
	return rarityModule.Data[rarity].Color
end
--[[
do
	local CosmeticsTab = Window:CollapsingHeader({
		Title = "✨ Cosmetics",
		Collapsed = true,
	})

	-- Custom Nametag Section
	do
		local ENABLED = false
		local CUSTOM_NAME = "OROSPU"
		local CUSTOM_COLOR = Color3.fromRGB(255, 0, 200) -- #1a00b3 (Sanu color)
		local janitor = Janitor.new()

		local function updateNametag()
			local character = LocalPlayer.Character
			if not character then
				return
			end

			local nametag = character:FindFirstChild("Nametag")
			if not nametag then
				return
			end

			local playerName = nametag:FindFirstChild("PlayerName")
			if playerName and playerName:IsA("TextLabel") then
				playerName.RichText = true
				if not ENABLED then
					playerName.Text = LocalPlayer.Name
					playerName.TextColor3 = Color3.fromRGB(255, 255, 255)
					return
				end
				playerName.Text = CUSTOM_NAME
				playerName.TextColor3 = CUSTOM_COLOR
			end
		end

		local function charUpdate()
			local nametag = LocalPlayer.Character:FindFirstChild("Nametag")
			if nametag then
				local playerName = nametag:FindFirstChild("PlayerName")
				if playerName then
					updateNametag()

					-- Monitor text changes to keep our custom name
					janitor:Add(playerName:GetPropertyChangedSignal("Text"):Connect(function()
						if playerName.Text ~= CUSTOM_NAME then
							playerName.Text = CUSTOM_NAME
						end
					end))

					-- Monitor color changes to keep our custom color
					janitor:Add(playerName:GetPropertyChangedSignal("TextColor3"):Connect(function()
						if playerName.TextColor3 ~= CUSTOM_COLOR then
							playerName.TextColor3 = CUSTOM_COLOR
						end
					end))
				end

				-- Monitor if nametag gets recreated
				janitor:Add(nametag.ChildAdded:Connect(function(child)
					if child.Name == "PlayerName" then
						task.wait()
						updateNametag()

						-- Monitor text changes to keep our custom name
						janitor:Add(child:GetPropertyChangedSignal("Text"):Connect(function()
							if child.Text ~= CUSTOM_NAME then
								child.Text = CUSTOM_NAME
							end
						end))

						-- Monitor color changes to keep our custom color
						janitor:Add(child:GetPropertyChangedSignal("TextColor3"):Connect(function()
							if child.TextColor3 ~= CUSTOM_COLOR then
								child.TextColor3 = CUSTOM_COLOR
							end
						end))
					end
				end))
			end

			-- Watch for nametag being added later
			janitor:Add(LocalPlayer.Character.ChildAdded:Connect(function(child)
				if child.Name == "Nametag" then
					task.wait()
					updateNametag()

					-- Watch for PlayerName being added to nametag
					janitor:Add(child.ChildAdded:Connect(function(nameChild)
						if nameChild.Name == "PlayerName" then
							task.wait()
							updateNametag()

							-- Monitor text changes to keep our custom name
							janitor:Add(nameChild:GetPropertyChangedSignal("Text"):Connect(function()
								if nameChild.Text ~= CUSTOM_NAME then
									nameChild.Text = CUSTOM_NAME
								end
							end))

							-- Monitor color changes to keep our custom color
							janitor:Add(nameChild:GetPropertyChangedSignal("TextColor3"):Connect(function()
								if nameChild.TextColor3 ~= CUSTOM_COLOR then
									nameChild.TextColor3 = CUSTOM_COLOR
								end
							end))
						end
					end))
				end
			end))
		end

		local function setEnabled(value)
			ENABLED = value

			janitor:Cleanup()
			updateNametag()

			if ENABLED then
				-- Monitor character changes
				janitor:Add(LocalPlayer.CharacterAdded:Connect(function(char)
					charUpdate()
				end))

				-- Check for existing character
				if LocalPlayer.Character then
					charUpdate()
				end
			end
		end

		hooks:Add(function()
			setEnabled(false)
			janitor:Cleanup()
		end)

		local CustomNametagNode = CosmeticsTab:TreeNode({
			Title = "Custom Nametag",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"CustomNameEnabled",
			CustomNametagNode:Checkbox({
				Label = "Enable Custom Name",
				Value = ENABLED,
				Callback = function(_, value)
					setEnabled(value)
				end,
			})
		)

		ConfigHandler:AddElement(
			"CustomNameValue",
			CustomNametagNode:InputText({
				Label = "Custom Name",
				Value = CUSTOM_NAME,
				Callback = function(_, value)
					CUSTOM_NAME = value
					if ENABLED then
						updateNametag()
					end
				end,
			})
		)

		ConfigHandler:AddElement(
			"CustomNameColor",
			CustomNametagNode:SliderColor3({
				Value = CUSTOM_COLOR,
				Label = "Name Color",
				Callback = function(_, color)
					CUSTOM_COLOR = color
					if ENABLED then
						updateNametag()
					end
				end,
			})
		)
	end

	local function itemSelector(name, items, callback, node)
		local displayNamed = {}
		local itemList = {}
		for _, item in items do
			local thing = ReplicatedStorage.Content.Item:FindFirstChild(item)
			if thing then
				local itemInfo = require(thing)
				local display = itemInfo.DisplayName
				local rarityColor = colorFromRarity(itemInfo.Rarity)
				local coloredDisplay = string.format(
					'<font color="rgb(%d,%d,%d)">%s</font>',
					math.floor(rarityColor.R * 255),
					math.floor(rarityColor.G * 255),
					math.floor(rarityColor.B * 255),
					display
				)
				table.insert(itemList, coloredDisplay)
				displayNamed[coloredDisplay] = item
			end
		end
		local combo = node:Combo({
			Label = name,
			Items = itemList,
			Callback = function(_, item)
				callback(displayNamed[item])
			end,
		})
		ConfigHandler:AddElement(name .. "Combo", combo)
		return combo
	end
	-- Custom Ball Section

	if hookfunction and newcclosure and debug.getupvalue then
		local BALL_ENABLED = false
		local SELECTED_BALL = nil
		local BALL_ENABLED_FOR_OTHERS = false

		local ballNames = {}
		for _, ball in ReplicatedStorage.Assets.Ball:GetChildren() do
			table.insert(ballNames, ball.Name)
		end

		local CustomBallNode = CosmeticsTab:TreeNode({
			Title = "Custom Ball",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"CustomBallEnabled",
			CustomBallNode:Checkbox({
				Label = "Enable Custom Ball",
				Value = BALL_ENABLED,
				Callback = function(_, value)
					BALL_ENABLED = value
				end,
			})
		)

		ConfigHandler:AddElement(
			"CustomBallForOthers",
			CustomBallNode:Checkbox({
				Label = "Apply To Others",
				Value = BALL_ENABLED_FOR_OTHERS,
				Callback = function(_, value)
					BALL_ENABLED_FOR_OTHERS = value
				end,
			})
		)

		itemSelector("Ball Skin", ballNames, function(ball)
			SELECTED_BALL = ball
		end, CustomBallNode)

		local networkModule = require(ReplicatedStorage:WaitForChild("network"))
		local callbackTable = debug.getupvalue(networkModule.BallStream.SetCallback, 1)

		if callbackTable[1] then
			local old
			old = hookfunction(
				callbackTable[1],
				newcclosure(function(...)
					local args = { ... }
					local ballData = args[1]

					if
						BALL_ENABLED
						and SELECTED_BALL
						and ballData.Skin
						and (
							ReplicatedStorage:GetAttribute("ServedByPlayer") == LocalPlayer.Name
							or BALL_ENABLED_FOR_OTHERS
						)
					then
						ballData.Skin = SELECTED_BALL
					end

					return old(...)
				end)
			)
		end

		hooks:Add(function()
			BALL_ENABLED = false
			BALL_ENABLED_FOR_OTHERS = false
			SELECTED_BALL = nil
		end)
	end

	-- Custom Score Section
	if getconnections and hookfunction and newcclosure then
		local ENABLED = false
		local ENABLED_FOR_OTHERS = false
		local SELECTED_EFFECT = nil

		local effectNames = {}
		for _, effect in ReplicatedStorage.Assets.ScoreEffect:GetChildren() do
			table.insert(effectNames, effect.Name)
		end

		local CustomScoreNode = CosmeticsTab:TreeNode({
			Title = "Custom Score Effect",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"CustomScoreEnabled",
			CustomScoreNode:Checkbox({
				Label = "Enable",
				Value = ENABLED,
				Callback = function(_, value)
					ENABLED = value
				end,
			})
		)

		ConfigHandler:AddElement(
			"CustomScoreForOthers",
			CustomScoreNode:Checkbox({
				Label = "Apply To Others",
				Value = ENABLED_FOR_OTHERS,
				Callback = function(_, value)
					ENABLED_FOR_OTHERS = value
				end,
			})
		)

		itemSelector("Score Effect", effectNames, function(effect)
			SELECTED_EFFECT = effect
		end, CustomScoreNode)

		local found = false
		local clc = os.clock()
		while not found and os.clock() - clc < 2 do
			local protos = debug.getprotos(gameController.BindToEffects)

			for i, proto in protos do
				if iscclosure(proto) then
					continue
				end
				local constants = debug.getconstants(proto)
				if table.find(constants, "GroundHit1") then
					local miniFound = false
					while not miniFound and os.clock() - clc < 2 do
						local realProtos = debug.getproto(gameController.BindToEffects, i, true)
						if #realProtos > 0 then
							miniFound = true
							for _, realProto in realProtos do
								local old
								old = hookfunction(
									realProto,
									newcclosure(function(...)
										--print("IDFC IDFC")
										local args = { ... }
										--warn(HaikyuuRaper:Serialize(args))

										if ENABLED and not args[3] then
											if args[6] == LocalPlayer.Character or ENABLED_FOR_OTHERS then
												if SELECTED_EFFECT then
													args[5] = SELECTED_EFFECT
												end
											end
										end

										return old(unpack(args))
									end)
								)
							end
						else
							task.wait()
						end
					end
					found = true
					break
				end
			end

			if not found then
				task.wait()
			end
		end

		hooks:Add(function()
			ENABLED = false
			ENABLED_FOR_OTHERS = false
			SELECTED_EFFECT = nil
		end)
	end
end
]]

local currentCam = workspace.CurrentCamera
if currentCam then
	local CameraTab = Window:CollapsingHeader({
		Title = "🎥 Camera",
		Collapsed = true,
	})

	do
		local DEFAULT_FOV = currentCam.FieldOfView
		local FOV_VALUE = 65
		local ENABLED = false

		local connections = Janitor.new()

		local function fovUpdated()
			currentCam.FieldOfView = FOV_VALUE
		end

		local function setEnabled(v)
			ENABLED = v
			if v then
				fovUpdated()
				connections:Add(currentCam:GetPropertyChangedSignal("FieldOfView"):Connect(fovUpdated))
			else
				connections:Cleanup()
				currentCam.FieldOfView = DEFAULT_FOV
			end
		end

		hooks:Add(function()
			setEnabled(false)
		end)

		local FOVNode = CameraTab:TreeNode({
			Title = "FOV",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"FovEnabled",
			FOVNode:Checkbox({
				Label = "Enabled",
				Value = ENABLED,
				Callback = function(_, v)
					setEnabled(v)
				end,
			})
		)

		ConfigHandler:AddElement(
			"FovValueSlider",
			FOVNode:SliderInt({
				Label = "FOV Value",
				Value = FOV_VALUE,
				Minimum = 1,
				Maximum = 120,
				Callback = function(self, Value)
					FOV_VALUE = math.round(Value)
					if ENABLED then
						fovUpdated()
					end
				end,
			})
		)
	end

	local HIDDEN_SHIFTLOCK = true

	do
		hooks:Add(RunService.RenderStepped:Connect(function(a0: number)
			local Character = LocalPlayer.Character
			if not Character then
				return
			end

			local Humanoid = Character:FindFirstChildOfClass("Humanoid")
			if not Humanoid then
				return
			end

			if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
				local zoomDistance = (currentCam.CFrame.Position - currentCam.Focus.Position).Magnitude
				if zoomDistance < 0.5 then -- close enough to be first person
					-- First Person Detected
					return
				end
				if HIDDEN_SHIFTLOCK then
					if Character:GetAttribute("Jumping") then
						UserGameSettings.RotationType = Enum.RotationType.CameraRelative
						Humanoid.CameraOffset = Vector3.new(1.75, 0, 0)
					else
						UserGameSettings.RotationType = Enum.RotationType.MovementRelative
						Humanoid.CameraOffset = Vector3.new(0, 0, 0)
					end
				else
					UserGameSettings.RotationType = Enum.RotationType.CameraRelative
					Humanoid.CameraOffset = Vector3.new(1.75, 0, 0)
				end
			end
		end))

		hooks:Add(function()
			HIDDEN_SHIFTLOCK = false
		end)

		local HiddenShiftlockNode = CameraTab:TreeNode({
			Title = "Hidden Shiftlock",
			Collapsed = false,
		})

		local checkBox = HiddenShiftlockNode:Checkbox({
			Label = "Enabled",
			Value = true,
			Callback = function(_, v)
				HIDDEN_SHIFTLOCK = v
			end,
		})
		ConfigHandler:AddElement("AirShiftlockToggle", checkBox)

		local kb = HiddenShiftlockNode:Keybind({
			Label = "Keybind",
			Value = Enum.KeyCode.R,
			Callback = function()
				checkBox:Toggle()
			end,
		})
		ConfigHandler:AddElement("AirShiftlockKeybind", kb)
	end

	if hookmetamethod and newcclosure then
		local ENABLED = false
		local CUSTOM_OFFSET = Vector3.new(0, 0, 0)

		local old
		old = hookmetamethod(
			game,
			"__index",
			newcclosure(function(self, index, ...)
				if
					rawequal(index, "CameraOffset")
					and old(LocalPlayer, "Character")
					and LocalPlayer.Character:FindFirstChild("Humanoid")
					and rawequal(self, old(old(LocalPlayer, "Character"), "Humanoid"))
				then
					if ENABLED then
						return CUSTOM_OFFSET
					end
				end
				return old(self, index, ...)
			end)
		)

		--[[
                        local foundFunc = false
            while not foundFunc do
                task.wait()

                local funcs = filtergc("function", {
                    Name = "GetMouseLockOffset", 
                })

                for _, func in funcs do
                    local fenv = getfenv(func)
                    if fenv.script and fenv.script.Name == "BaseCamera" then
                        foundFunc = true

                        local old; old = hookfunction(func, newcclosure(function(...)
                            if ENABLED then
                                return CUSTOM_OFFSET
                            elseif not IN_AIR and HIDDEN_SHIFTLOCK then
                                return Vector3.new(0, 0, 0)
                            end
                            return old(...)
                        end))

                        break
                    end
                end
            end
            ]]

		local CameraOffsetNode = CameraTab:TreeNode({
			Title = "Custom Mouse Lock Offset",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"CameraOffsetToggle",
			CameraOffsetNode:Checkbox({
				Label = "Enabled",
				Value = ENABLED,
				Callback = function(_, v)
					ENABLED = v
				end,
			})
		)

		local offsetRow = CameraOffsetNode:TreeNode({
			Title = "Offset Vector",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"CameraOffsetXSlider",
			offsetRow:SliderFloat({
				Label = "X",
				Format = "%.1f",
				Value = CUSTOM_OFFSET.X,
				Minimum = -10,
				Maximum = 10,
				Callback = function(self, Value)
					CUSTOM_OFFSET = Vector3.new(Value, CUSTOM_OFFSET.Y, CUSTOM_OFFSET.Z)
				end,
			})
		)

		ConfigHandler:AddElement(
			"CameraOffsetYSlider",
			offsetRow:SliderFloat({
				Label = "Y",
				Format = "%.1f",
				Value = CUSTOM_OFFSET.Y,
				Minimum = -10,
				Maximum = 10,
				Callback = function(self, Value)
					CUSTOM_OFFSET = Vector3.new(CUSTOM_OFFSET.X, Value, CUSTOM_OFFSET.Z)
				end,
			})
		)

		ConfigHandler:AddElement(
			"CameraOffsetZSlider",
			offsetRow:SliderFloat({
				Label = "Z",
				Format = "%.1f",
				Value = CUSTOM_OFFSET.Z,
				Minimum = -10,
				Maximum = 10,
				Callback = function(self, Value)
					CUSTOM_OFFSET = Vector3.new(CUSTOM_OFFSET.X, CUSTOM_OFFSET.Y, Value)
				end,
			})
		)

		hooks:Add(function()
			ENABLED = false
		end)
	end
end

local HITBOX_MULTIPLIERS = {}
local HITBOX_MULTIPLIER_ENABLED = false

do
	local InternalTab = Window:CollapsingHeader({
		Title = "⚙️ Internals",
		Collapsed = true,
	})

	if hookmetamethod then
		local enabled = true
		local value = 0

		local function setEnabled(v)
			enabled = v
		end

		hooks:Add(function()
			setEnabled(false)
		end)

		local old
		old = hookmetamethod(game, "__namecall", function(self, ...)
			local args = { ... }
			if enabled and not checkcaller() then
				if
					getnamecallmethod() == "InvokeServer"
					and typeof(self) == "Instance"
					and self.ClassName == "RemoteFunction"
					and self.Name == "Serve"
				then
					args[2] = value
				end
			end
			return old(self, table.unpack(args))
		end)

		local ServeNode = InternalTab:TreeNode({
			Title = "Serve",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"ServeFixedPowerSlider",
			ServeNode:SliderInt({
				Label = "Power",
				Value = 100,
				Minimum = 0,
				Maximum = 100,
				Callback = function(self, Value)
					value = Value / 100
					--print(value)
				end,
			})
		)

		ConfigHandler:AddElement(
			"ServePowerToggle",
			ServeNode:Checkbox({
				Label = "Enabled",
				Value = true,
				Callback = function(_, v)
					setEnabled(v)
				end,
			})
		)
	end

	if hookmetamethod and hookfunction and newcclosure then
		local TimeskipHinataNode = InternalTab:TreeNode({
			Title = "Timeskip Hinata",
			Collapsed = false,
		})

		local specialController
		local moveController

		specialController = require(ReplicatedFirst:WaitForChild("Controllers"):WaitForChild("SpecialController"))
		moveController =
			require(ReplicatedFirst:WaitForChild("Controllers"):WaitForChild("SpecialController"):WaitForChild("Move"))

		if specialController and gameController and moveController then
			--->> CONFIG
			local CHARGE_SPEED_ENABLED = false
			local DECHARGE_SPEED_ENABLED = false
			local CHARGE_SPEED = 1
			local DECHARGE_SPEED = 1
			local ALWAYS_PURPLE_ON = false
			local NO_DIRECTION_CHANGE = false

			-->>  HOOKS

			do
				local old
				old = hookfunction(
					specialController.ChargeSpringSpeed.get,
					newcclosure(function(self, ...)
						if checkcaller() then
							return old(self, ...)
						end

						local result = old(self, ...)
						if typeof(result) ~= "number" then
							return result
						end

						if rawequal(self, specialController.ChargeSpringSpeed) then
							if old(gameController.IsJumping) then
								return 0
							else
								--print(old(specialController.Charge))
								if old(specialController.Charge) < 0.1 then
									--print("Ayoo")
									if DECHARGE_SPEED_ENABLED then
										return result * DECHARGE_SPEED
									end
								else
									if CHARGE_SPEED_ENABLED then
										return result * CHARGE_SPEED
									end
								end
							end
						end

						return result
					end)
				)
			end

			do
				local old
				old = hookmetamethod(game, "__namecall", function(self, ...)
					local args = { ... }
					if ALWAYS_PURPLE_ON and not checkcaller() then
						if
							getnamecallmethod() == "InvokeServer"
							and typeof(self) == "Instance"
							and self.ClassName == "RemoteFunction"
							and self.Name == "Interact"
						then
							local t = args[1]
							if typeof(t) == "table" and rawget(t, "SpecialCharge") ~= nil then
								rawset(t, "SpecialCharge", 1)
							end
						end
					end
					return old(self, table.unpack(args))
				end)
			end

			do
				local old
				old = hookfunction(
					moveController.angleBetween,
					newcclosure(function(...)
						if checkcaller() or not NO_DIRECTION_CHANGE then
							return old(...)
						end
						return 0
					end)
				)
			end

			do
				local old
				old = hookfunction(
					moveController.getDirection,
					newcclosure(function(...)
						local result = old(...)
						if checkcaller() or not NO_DIRECTION_CHANGE then
							return result
						end
						specialController.Direction:set(result)
						return result
					end)
				)
			end

			-->> UI
			TimeskipHinataNode:Label({
				Text = "* Always Purple",
			})
			ConfigHandler:AddElement(
				"HinataMaxToggle",
				TimeskipHinataNode:Checkbox({
					Label = "Enabled",
					Value = ALWAYS_PURPLE_ON,
					Callback = function(_, v)
						ALWAYS_PURPLE_ON = v
					end,
				})
			)
			hooks:Add(function()
				ALWAYS_PURPLE_ON = false
			end)

			TimeskipHinataNode:Label({
				Text = "* No Direction Change",
			})
			ConfigHandler:AddElement(
				"HinataNoDirChangeToggle",
				TimeskipHinataNode:Checkbox({
					Label = "Enabled",
					Value = NO_DIRECTION_CHANGE,
					Callback = function(_, v)
						NO_DIRECTION_CHANGE = v
					end,
				})
			)
			hooks:Add(function()
				NO_DIRECTION_CHANGE = false
			end)

			TimeskipHinataNode:Label({
				Text = "* Charge Speed",
			})

			ConfigHandler:AddElement(
				"HinataChargeSpeedToggle",
				TimeskipHinataNode:Checkbox({
					Label = "Enabled",
					Value = CHARGE_SPEED_ENABLED,
					Callback = function(_, v)
						CHARGE_SPEED_ENABLED = v
					end,
				})
			)

			ConfigHandler:AddElement(
				"HinataChargeSpeedValueSlider",
				TimeskipHinataNode:SliderFloat({
					Label = "Multiplier",
					Value = 1,
					Minimum = 0,
					Maximum = 5,
					Callback = function(self, Value)
						CHARGE_SPEED = Value
					end,
				})
			)

			hooks:Add(function()
				CHARGE_SPEED = 1
				CHARGE_SPEED_ENABLED = false
			end)

			TimeskipHinataNode:Label({
				Text = "* DeCharge Speed",
			})

			ConfigHandler:AddElement(
				"HinataDeChargeSpeedToggle",
				TimeskipHinataNode:Checkbox({
					Label = "Enabled",
					Value = DECHARGE_SPEED_ENABLED,
					Callback = function(_, v)
						DECHARGE_SPEED_ENABLED = v
					end,
				})
			)

			ConfigHandler:AddElement(
				"HinataDeChargeValueSlider",
				TimeskipHinataNode:SliderFloat({
					Label = "Multiplier",
					Value = 1,
					Minimum = 0,
					Maximum = 1,
					Callback = function(self, Value)
						DECHARGE_SPEED = Value
					end,
				})
			)

			hooks:Add(function()
				DECHARGE_SPEED = 1
				DECHARGE_SPEED_ENABLED = false
			end)
		end
	end

	local SPIKE_LAG_ENABLED = false
	local SPIKE_LAG_RANDOM_ENABLED = true
	local DELAY_MOUSE_RELEASE = false
	local SPIKE_LAG_TIME = 0.45

	if hookmetamethod and newcclosure then
		SPIKE_LAG_ENABLED = false
		SPIKE_LAG_RANDOM_ENABLED = true
		DELAY_MOUSE_RELEASE = false
		SPIKE_LAG_TIME = 0.45

		local SpikeLagNode = InternalTab:TreeNode({
			Title = "Spike Lag",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"SpikeLagToggle",
			SpikeLagNode:Checkbox({
				Label = "Enabled",
				Value = SPIKE_LAG_ENABLED,
				Callback = function(_, v)
					SPIKE_LAG_ENABLED = v
				end,
			})
		)

		ConfigHandler:AddElement(
			"DelayMouseReleaseToggle",
			SpikeLagNode:Checkbox({
				Label = "Wait M1 Release",
				Value = DELAY_MOUSE_RELEASE,
				Callback = function(_, v)
					DELAY_MOUSE_RELEASE = v
				end,
			})
		)

		ConfigHandler:AddElement(
			"SpikeLagRandomToggle",
			SpikeLagNode:Checkbox({
				Label = "Random Lag",
				Value = SPIKE_LAG_RANDOM_ENABLED,
				Callback = function(_, v)
					SPIKE_LAG_RANDOM_ENABLED = v
				end,
			})
		)

		ConfigHandler:AddElement(
			"SpikeLagTimeSlider",
			SpikeLagNode:SliderFloat({
				Label = "Lag Time (s)",
				Value = SPIKE_LAG_TIME,
				Minimum = 0,
				Maximum = 1,
				Callback = function(self, Value)
					SPIKE_LAG_TIME = Value
				end,
			})
		)

		hooks:Add(function()
			SPIKE_LAG_ENABLED = false
			SPIKE_LAG_RANDOM_ENABLED = true
			SPIKE_LAG_TIME = 0.45
		end)

		-- Sanu Tilt
		local ENABLED = true
		local MAX_ANGLE = 10

		local function rotateTowardsXZ(lookVector, tiltVector, maxAngleDegrees)
			local lookXZ = Vector2.new(lookVector.X, lookVector.Z)
			local tiltXZ = Vector2.new(tiltVector.X, tiltVector.Z)

			if lookXZ.Magnitude == 0 or tiltXZ.Magnitude == 0 then
				return lookVector
			end

			lookXZ = lookXZ.Unit
			tiltXZ = tiltXZ.Unit

			local dot = lookXZ.Dot(lookXZ, tiltXZ)

			-- if tilt is more than 160° off, negate the tilt vector so we rotate toward its opposite
			if dot < -0.9396926207859084 then -- cos(160°) ≈ -0.940
				tiltXZ = tiltXZ * -1
				dot = lookXZ.Dot(lookXZ, tiltXZ)
			end

			-- now rotate toward (possibly negated) tiltXZ, clamped to maxAngleDegrees
			local angle = math.acos(math.clamp(dot, -1, 1))
			local cross = lookXZ.X * tiltXZ.Y - lookXZ.Y * tiltXZ.X
			local direction = math.sign(cross)

			local maxAngle = math.rad(maxAngleDegrees)
			local rotationAngle = math.min(angle, maxAngle)

			local c = math.cos(rotationAngle)
			local s = math.sin(rotationAngle) * direction

			local rotated = Vector2.new(lookXZ.X * c - lookXZ.Y * s, lookXZ.X * s + lookXZ.Y * c)

			return Vector3.new(rotated.X, lookVector.Y, rotated.Y).Unit
		end

		local old
		old = hookmetamethod(
			game,
			"__namecall",
			newcclosure(function(self, ...)
				local args = { ... }
				if not checkcaller() then
					if
						getnamecallmethod() == "InvokeServer"
						and typeof(self) == "Instance"
						and self.ClassName == "RemoteFunction"
						and self.Name == "Interact"
					then
						local t = args[1]
						if typeof(t) == "table" then
							local action = rawget(t, "Action")
							if action == "Spike" or action == "Block" then
								if ENABLED then
									local lookVector, tiltDirection =
										rawget(t, "LookVector"), rawget(t, "TiltDirection")
									if lookVector and tiltDirection then
										local rotatedVector = rotateTowardsXZ(lookVector, tiltDirection, MAX_ANGLE)
										rawset(t, "LookVector", rotatedVector)
									end
								end
								if SPIKE_LAG_ENABLED and action == "Spike" then
									if DELAY_MOUSE_RELEASE then
										local c = os.clock()
										while
											UserInputService.IsMouseButtonPressed(
												UserInputService,
												Enum.UserInputType.MouseButton1
											) and os.clock() - c < SPIKE_LAG_TIME
										do
											task.wait()
										end
									else
										local lagTime = SPIKE_LAG_TIME
										if SPIKE_LAG_RANDOM_ENABLED then
											lagTime = lagTime * (math.random())
										end
										task.wait(lagTime)
										--task.delay(lagTime, old, self, table.unpack(args))
										--return
									end
								end
							end
						end
					end
				end
				return old(self, table.unpack(args))
			end)
		)

		hooks:Add(function()
			ENABLED = false
		end)

		local SanuTiltNode = InternalTab:TreeNode({
			Title = "Sanu Tilt",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"SanuTiltMaxAngle",
			SanuTiltNode:SliderInt({
				Label = "Max Angle",
				Value = MAX_ANGLE,
				Minimum = 0,
				Maximum = 90,
				Callback = function(self, Value)
					MAX_ANGLE = Value
				end,
			})
		)

		ConfigHandler:AddElement(
			"SanuTiltToggle",
			SanuTiltNode:Checkbox({
				Label = "Enabled",
				Value = ENABLED,
				Callback = function(_, v)
					ENABLED = v
				end,
			})
		)
	end

	local isBusyState = false
	if hookfunction and newcclosure and gameController then
		local val = gameController.IsBusy

		local ENABLED = false
		local NO_DEBOUNCE_ENABLED = false

		local NoCooldownsNode = InternalTab:TreeNode({
			Title = "No Cooldowns",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"NoCooldownsToggle",
			NoCooldownsNode:Checkbox({
				Label = "No Cooldown",
				Value = ENABLED,
				Callback = function(_, v)
					ENABLED = v
				end,
			})
		)

		ConfigHandler:AddElement(
			"NoDebounceToggle",
			NoCooldownsNode:Checkbox({
				Label = "No Debounce",
				Value = NO_DEBOUNCE_ENABLED,
				Callback = function(_, v)
					NO_DEBOUNCE_ENABLED = v
				end,
			})
		)

		hooks:Add(function()
			ENABLED = false
			NO_DEBOUNCE_ENABLED = false
		end)

		if ENABLED then
			val:set(false)
		end

		local old
		old = hookfunction(
			val.set,
			newcclosure(function(self, ...)
				if ENABLED and not checkcaller() and rawequal(self, val) then
					isBusyState = ({ ... })[1]
					if not LocalPlayer:GetAttribute("IsServing") then
						return old(self, false)
					end
				end
				return old(self, ...)
			end)
		)

		local oldMove
		oldMove = hookfunction(
			gameController.DoMove,
			newcclosure(function(_, name, one, two, three, four, five, six, ...)
				if NO_DEBOUNCE_ENABLED then
					two = false
					six = 0
					return oldMove(_, name, one, two, three, four, five, six, ...)
				end
				return oldMove(_, name, one, two, three, four, five, six, ...)
			end)
		)
	end

	local HitboxNode = InternalTab:TreeNode({
		Title = "Hitbox Expander",
		Collapsed = false,
	})

	local multipliersNode = HitboxNode:TreeNode({
		Title = "Multipliers",
		Collapsed = false,
	})

	local function addToMultipliers(name)
		HITBOX_MULTIPLIERS[name] = 1
		ConfigHandler:AddElement(
			name .. "HitboxMultiplier",
			multipliersNode:SliderFloat({
				Label = name,
				Format = "%.2f",
				Value = 1,
				Minimum = 0,
				Maximum = 10,
				Callback = function(self, Value)
					HITBOX_MULTIPLIERS[name] = Value
				end,
			})
		)
	end

	local hitboxes = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Hitboxes")

	for _, hitbox in hitboxes:GetChildren() do
		addToMultipliers(hitbox.Name)
	end

	hooks:Add(hitboxes.ChildAdded:Connect(function(hitbox)
		addToMultipliers(hitbox.Name)
	end))

	if hookmetamethod and hookfunction then
		local ENABLED = false
		local lastHitboxName = nil

		do
			local old
			old = hookfunction(
				Instance.fromExisting,
				newcclosure(function(self, ...)
					local args = { ... }
					if
						ENABLED
						and not checkcaller()
						and typeof(self) == "Instance"
						and self.Parent
						and self.Parent.Parent
						and self.Parent.Parent == hitboxes
					then
						local newName = self.Parent.Name
						if HITBOX_MULTIPLIERS[newName] then
							lastHitboxName = newName
						end
					end
					return old(self, ...)
				end)
			)
		end

		-- might need to add check for caller function name (eg. debug.info(3).Name == DoMove)
		local old
		old = hookmetamethod(game, "__namecall", function(self, ...)
			local args = { ... }
			if
				ENABLED
				--and not checkcaller()
				and rawequal(self, workspace)
				and getnamecallmethod() == "GetPartsInPart"
				and lastHitboxName
				and HITBOX_MULTIPLIERS[lastHitboxName]
			then
				local hitboxPart = args[1]
				local overlapParams = args[2]

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
						local oldSize = hitboxPart.Size
						hitboxPart.Size = oldSize * HITBOX_MULTIPLIERS[lastHitboxName]
						local result = old(self, ...)
						hitboxPart.Size = oldSize
						return result
					end
				end
			end

			return old(self, unpack(args))
		end)

		ConfigHandler:AddElement(
			"HitboxToggle",
			HitboxNode:Checkbox({
				Label = "Enabled",
				Value = true,
				Callback = function(_, v)
					ENABLED = v
				end,
			})
		)

		hooks:Add(function()
			ENABLED = false
		end)
	end

	local function isBallInBox(ballPosition, ballRadius, boxCFrame, boxSize)
		-- Convert ball position to box's local space
		local localBallPos = boxCFrame:PointToObjectSpace(ballPosition)

		-- Get half extents of the box
		local halfSize = boxSize * 0.5

		-- Find the closest point on the box to the ball center
		local closestX = math.clamp(localBallPos.X, -halfSize.X, halfSize.X)
		local closestY = math.clamp(localBallPos.Y, -halfSize.Y, halfSize.Y)
		local closestZ = math.clamp(localBallPos.Z, -halfSize.Z, halfSize.Z)

		local closestPoint = Vector3.new(closestX, closestY, closestZ)

		-- Calculate distance from ball center to closest point
		local distance = (localBallPos - closestPoint).Magnitude

		-- Ball is inside/intersecting if distance is less than or equal to radius
		return distance <= ballRadius
	end

	local hitboxFolder = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Hitboxes")
	local function getHitboxCFrame(hitboxName, CFrame)
		local folder = hitboxFolder:WaitForChild(hitboxName)
		local hitboxPart = folder:WaitForChild("Part")
		local dummy = folder:WaitForChild("Dummy") :: Model

		local offset = dummy:GetPivot():ToObjectSpace(hitboxPart:GetPivot())

		if CFrame then
			return CFrame:ToWorldSpace(offset),
				hitboxPart.Size * (HITBOX_MULTIPLIER_ENABLED and HITBOX_MULTIPLIERS[hitboxName] or 1)
		else
			local character = LocalPlayer.Character
			if not character then
				return
			end

			return character:GetPivot():ToWorldSpace(offset),
				hitboxPart.Size * (HITBOX_MULTIPLIER_ENABLED and HITBOX_MULTIPLIERS[hitboxName] or 1)
		end
	end

	if gameController and hookmetamethod and BallTrajectory and GameModule then
		local ENABLED = true
		local DIVE_ENABLED = true
		local SET_ENABLED = true
		local PERFECT_DIVE_ENABLED = true
		local GameConfig = GameModule

		local REACTION_TIME = 0
		local USER_REACTION_TIME = 0.5
		local USER_REACTION_TIME_ENABLED = true
		local REACTION_TIME_ENABLED = true

		local DIVE_ANGLE_ENABLED = true
		local DIVE_ANGLE = 0

		local function getMoveDirectionToLanding(landingPosition)
			if not landingPosition then
				return nil
			end

			local character = LocalPlayer.Character
			if not character then
				return nil
			end

			local rootPart = character:FindFirstChild("HumanoidRootPart")
			if not rootPart then
				return nil
			end

			local diffVector = ((landingPosition - character:GetPivot().Position) * Vector3.new(1, 0, 1))
			return diffVector.Unit
		end

		local moveDirectionOverride = nil
		local latestDiveDir = nil

		local lastHitter = ReplicatedStorage:GetAttribute("LastHitter")
		local hitClock = 0

		hooks:Add(ReplicatedStorage:GetAttributeChangedSignal("LastHitter"):Connect(function()
			if lastHitter then
				hitClock = os.clock()
			end
			lastHitter = ReplicatedStorage:GetAttribute("LastHitter")
		end))

		local oldIndex
		oldIndex = hookmetamethod(
			game,
			"__index",
			newcclosure(function(self, index, ...)
				if
					ENABLED
					and (not checkcaller() or moveDirectionOverride)
					and typeof(self) == "Instance"
					and oldIndex(self, "ClassName") == "Humanoid"
					and rawequal(index, "MoveDirection")
					and #{ ... } == 0
					and rawequal(debug.info(3, "n"), "Dive")
				then
					--warn("overriding")
					if moveDirectionOverride then
						return moveDirectionOverride
					elseif PERFECT_DIVE_ENABLED and lastHitter and lastHitter ~= LocalPlayer.Name then
						return latestDiveDir
					end
				end
				return oldIndex(self, index, ...)
			end)
		)

		local oldDive
		oldDive = hookfunction(
			gameController.Dive,
			newcclosure(function(self, ...)
				if ENABLED and not checkcaller() and PERFECT_DIVE_ENABLED then
					local args = { ... }
					if args[1] and typeof(args[1]) == "table" and args[1].Target and latestDiveDir then
						args[1].Target = latestDiveDir * args[1].Target.Magnitude
					end
				end
				return oldDive(self, ...)
			end)
		)

		hooks:Add(RunService.Heartbeat:Connect(function()
			if not LocalPlayer.Team then
				return
			end

			local ball, landingPosition, timeToLand =
				BallTrajectory.LastBall, BallTrajectory.LastTrajectory, BallTrajectory.LastTime
			latestDiveDir = getMoveDirectionToLanding(landingPosition)

			if latestDiveDir and DIVE_ANGLE_ENABLED then
				local randomAngle = math.random(-DIVE_ANGLE, DIVE_ANGLE)
				-- Use cos and sin to rotate latestDiveDir by randomAngle (in degrees) around the Y axis
				local angleRad = math.rad(randomAngle)
				local cosA = math.cos(angleRad)
				local sinA = math.sin(angleRad)
				local x = latestDiveDir.X * cosA - latestDiveDir.Z * sinA
				local z = latestDiveDir.X * sinA + latestDiveDir.Z * cosA
				local newDir = Vector3.new(x, latestDiveDir.Y, z).Unit
				latestDiveDir = newDir
			end

			if not ENABLED or not (SET_ENABLED or DIVE_ENABLED) then
				return
			end
			if not landingPosition or not timeToLand then
				return
			end

			local character = LocalPlayer.Character
			if not character then
				return
			end

			-- Check if player is already diving
			if LocalPlayer:GetAttribute("Diving") or isBusyState then
				return
			end

			if
				character:GetAttribute("Jumping")
				or not character:FindFirstChild("Humanoid")
				or character.Humanoid.FloorMaterial == Enum.Material.Air
			then
				return
			end

			local deltaClock = os.clock() - hitClock
			if
				(REACTION_TIME_ENABLED and deltaClock < REACTION_TIME)
				or (USER_REACTION_TIME_ENABLED and deltaClock > USER_REACTION_TIME + LocalPlayer:GetNetworkPing())
			then
				return
			end

			-- Get court informatio

			local playerPosition = character:GetPivot().Position
			if ReplicatedStorage:GetAttribute("Gamemode") ~= "Training" then
				if
					not ReplicatedStorage:GetAttribute("IsBallInPlay")
					or not ReplicatedStorage:GetAttribute("LastHitType")
					or not ReplicatedStorage:GetAttribute("TeamHitStreak")
				then
					return
				end

				local courtPosition = CourtPart.Position
				local courtSize = CourtPart.Size
				local ballRadius = GameModule.Physics.Radius

				-- Check if the last hitter is not on the same team as the player
				local lastHitterPlayer = lastHitter and Players:FindFirstChild(lastHitter) or nil

				if lastHitterPlayer and lastHitterPlayer.Team == LocalPlayer.Team then
					return
				end

				if
					landingPosition.X < (courtPosition.X - courtSize.X / 2 - ballRadius)
					or landingPosition.X > (courtPosition.X + courtSize.X / 2 + ballRadius)
				then
					return
				end
				-- Check if landing position is within court boundaries on Z axis (with radius)
				if
					landingPosition.Z < (courtPosition.Z - courtSize.Z / 2 - ballRadius)
					or landingPosition.Z > (courtPosition.Z + courtSize.Z / 2 + ballRadius)
				then
					return
				end

				-- Determine which side of the court the player is on (using Z axis)
				local isPlayerOnPositiveZSide = tonumber(LocalPlayer.Team:GetAttribute("Index")) == 2

				-- Check if landing position is on the same side as the player
				local isLandingOnPlayersSide = (isPlayerOnPositiveZSide and landingPosition.Z > courtPosition.Z)
					or (not isPlayerOnPositiveZSide and landingPosition.Z < courtPosition.Z)

				if not isLandingOnPlayersSide then
					return
				end
			end

			local playerPing = LocalPlayer:GetNetworkPing()
			local ballAcceleration = ball.Acceleration
			local velocity = ball.Velocity
			local position = ball.Position

			-- Calculate where the ball will be after the time of player's ping has passed
			local t = playerPing
			local ballPosition = BallTrajectory.RunPhysics({
				Velocity = velocity,
				Position = position,
				Acceleration = ballAcceleration,
				Jerk = ball.Jerk or Vector3.zero,
			}, t).Position

			--local posToPlayerDist = (position - playerPosition).Magnitude
			local setHitboxCFrame, setHitboxSize = getHitboxCFrame("Set")

			if
				SET_ENABLED
				and (
					(isBallInBox(ballPosition, GameModule.Physics.Radius, setHitboxCFrame, setHitboxSize))
					or (isBallInBox(position, GameModule.Physics.Radius, setHitboxCFrame, setHitboxSize))
					or (
						timeToLand < 0.25 + 0.5 * LocalPlayer:GetNetworkPing()
						and isBallInBox(landingPosition, GameModule.Physics.Radius, setHitboxCFrame, setHitboxSize)
					)
				)
			then
				-- Ball or landing position is close enough to set
				setthreadidentity(2)
				gameController:DoMove("Set")
				setthreadidentity(8)
				return
			end

			if not DIVE_ENABLED then
				return
			end

			-- Calculate dive parameters
			local diveSpeedMultiplier = LocalPlayer:GetAttribute("GameDiveSpeedMultiplier") or 1
			local initialVelocity = 36 * diveSpeedMultiplier
			local acceleration = -initialVelocity / (GameConfig.Ball.Dive.Duration * 0.9)

			-- Calculate horizontal distance to landing point
			local diffVector = (landingPosition - playerPosition) * Vector3.new(1, 0, 1)

			--{{ NEW LOGIC }}
			-- Simulate possible dive timings up to 1 second ahead, at most 60 steps per second
			local found = false
			local maxSimTime = math.max(0, timeToLand) -- don't simulate past the ball's landing

			if USER_REACTION_TIME_ENABLED then
				maxSimTime = math.min(USER_REACTION_TIME - deltaClock, maxSimTime)
			end

			maxSimTime = math.min(maxSimTime, GameConfig.Ball.Dive.Duration)

			local steps = 60 * maxSimTime
			local dt = maxSimTime / steps

			for i = 0, steps - 1 do
				local t = i * dt

				-- Player's simulated position after simTime seconds of diving
				local diveDir = diffVector.Unit
				local simPlayerPos = playerPosition

				-- Only move if t > 0
				if t > 0 then
					-- s = v0*t + 0.5*a*t^2
					local moveDist = initialVelocity * t + 0.5 * acceleration * t * t
					moveDist = math.max(0, moveDist)
					simPlayerPos = playerPosition + diveDir * moveDist
				end

				local simBallPosition = BallTrajectory.RunPhysics({
					Velocity = velocity,
					Position = position,
					Acceleration = ballAcceleration,
					Jerk = ball.Jerk or Vector3.zero,
				}, t).Position

				-- Get simulated hitbox for Dive at simPlayerPos
				local hitboxCFrame, hitboxSize =
					getHitboxCFrame("Dive", CFrame.new(simPlayerPos) * character:GetPivot().Rotation)
				if hitboxCFrame and hitboxSize then
					if isBallInBox(simBallPosition, GameModule.Physics.Radius, hitboxCFrame, hitboxSize) then
						-- Ball will be in hitbox if we dive at t seconds from now
						setthreadidentity(2)
						moveDirectionOverride = diveDir
						gameController:Dive()
						setthreadidentity(8)
						moveDirectionOverride = nil
						found = true
						break
					end
				end
			end

			if found then
				return
			end

			--[[
						-- Adjust distance based on hitbox multiplier
			local hitboxDistance = distance - (1.5 * (HITBOX_MULTIPLIER_ENABLED and HITBOX_MULTIPLIERS["Dive"] or 1))
			hitboxDistance = math.max(0, hitboxDistance)

			-- Calculate time needed to reach the ball
			local timeToHit = solveQuadratic(0.5 * acceleration, initialVelocity, -hitboxDistance)
			if not timeToHit then
				return
			end

			local pingEstimate = (LocalPlayer:GetNetworkPing())

			if timeToLand < timeToHit then
				return
			end
			if timeToHit > GameConfig.Ball.Dive.Duration then
				return
			end
			if timeToLand - timeToHit > pingEstimate + 0.1 then
				return
			end

			moveDirectionOverride = latestDiveDir
			--setthreadidentity(2)
			gameController:Dive()
			setthreadidentity(8)
			moveDirectionOverride = nil
			]]
		end))

		local AutoReceiveNode = InternalTab:TreeNode({
			Title = "Auto Receive",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"AutoReceiveToggle",
			AutoReceiveNode:Checkbox({
				Label = "Enabled",
				Value = ENABLED,
				Callback = function(_, v)
					ENABLED = v
				end,
			})
		)

		ConfigHandler:AddElement(
			"AutoReceiveSetToggle",
			AutoReceiveNode:Checkbox({
				Label = "Set",
				Value = SET_ENABLED,
				Callback = function(_, v)
					SET_ENABLED = v
				end,
			})
		)

		ConfigHandler:AddElement(
			"AutoReceiveDiveToggle",
			AutoReceiveNode:Checkbox({
				Label = "Dive",
				Value = DIVE_ENABLED,
				Callback = function(_, v)
					DIVE_ENABLED = v
				end,
			})
		)

		AutoReceiveNode:Label({
			Text = "* Reaction Time - Minimum time to receive the ball",
		})

		local row2 = AutoReceiveNode:Row()

		ConfigHandler:AddElement(
			"AutoReceiveReactionTimeEnabled",
			row2:Checkbox({
				Label = "",
				Value = REACTION_TIME_ENABLED,
				Callback = function(_, v)
					REACTION_TIME_ENABLED = v
				end,
			})
		)

		ConfigHandler:AddElement(
			"AutoReceiveReactionTime",
			row2:SliderFloat({
				Label = "(seconds)",
				Value = REACTION_TIME,
				Minimum = 0,
				Maximum = 0.5,
				Callback = function(_, v)
					REACTION_TIME = v
				end,
			})
		)

		AutoReceiveNode:Label({
			Text = "* User Reaction Time - Maximum time to receive the ball",
		})

		local row1 = AutoReceiveNode:Row()

		ConfigHandler:AddElement(
			"AutoReceiveUserReactionTimeEnabled",
			row1:Checkbox({
				Label = "",
				Value = USER_REACTION_TIME_ENABLED,
				Callback = function(_, v)
					USER_REACTION_TIME_ENABLED = v
				end,
			})
		)

		ConfigHandler:AddElement(
			"AutoReceiveUserReactionTime",
			row1:SliderFloat({
				Label = "(seconds)",
				Value = USER_REACTION_TIME,
				Minimum = 0,
				Maximum = 1,
				Callback = function(_, v)
					USER_REACTION_TIME = v
				end,
			})
		)

		ConfigHandler:AddElement(
			"AutoReceiveDiveAngleEnabled",
			AutoReceiveNode:Checkbox({
				Label = "Dive Angle",
				Value = DIVE_ANGLE_ENABLED,
				Callback = function(_, v)
					DIVE_ANGLE_ENABLED = v
				end,
			})
		)

		ConfigHandler:AddElement(
			"AutoReceiveDiveAngle",
			AutoReceiveNode:SliderInt({
				Label = "(degrees)",
				Value = DIVE_ANGLE,
				Minimum = 0,
				Maximum = 30,
				Callback = function(_, v)
					DIVE_ANGLE = v
				end,
			})
		)

		ConfigHandler:AddElement(
			"PerfectDiveToggle",
			AutoReceiveNode:Checkbox({
				Label = "Perfect Dive",
				Value = PERFECT_DIVE_ENABLED,
				Callback = function(_, v)
					PERFECT_DIVE_ENABLED = v
				end,
			})
		)

		hooks:Add(function()
			ENABLED = false
		end)
	end
end

-->> Spin
do
	local header = Window:CollapsingHeader({
		Title = "🔁 Spins (Inf. Spins & Rollback)",
	})

	local TeleportService = game:GetService("TeleportService")

	local PlaceId = game.PlaceId
	local JobId = game.JobId

	local function rollback()
		local args = {
			"Q",
			true,
			"Q\255",
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("Packages")
			:WaitForChild("_Index")
			:WaitForChild("sleitnick_knit@1.7.0")
			:WaitForChild("knit")
			:WaitForChild("Services")
			:WaitForChild("SettingsService")
			:WaitForChild("RF")
			:WaitForChild("UpdateKeybind")
			:InvokeServer(unpack(args))
	end

	local function unRollback()
		local args = {
			nil,
			true,
			"Q\255",
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("Packages")
			:WaitForChild("_Index")
			:WaitForChild("sleitnick_knit@1.7.0")
			:WaitForChild("knit")
			:WaitForChild("Services")
			:WaitForChild("SettingsService")
			:WaitForChild("RF")
			:WaitForChild("UpdateKeybind")
			:InvokeServer(unpack(args))
	end

	local function rejoin()
		if #Players:GetPlayers() <= 1 then
			Players.LocalPlayer:Kick("\nRejoining...")
			wait()
			TeleportService:Teleport(PlaceId, Players.LocalPlayer)
		else
			--[[
			while true do
				TeleportService:Teleport(PlaceId, Players.LocalPlayer)
				task.wait(5)
			end
			]]
			TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
		end
	end

	local function rollbackAndRejoin()
		rollback()
		task.wait(0.5 + LocalPlayer:GetNetworkPing())
		rejoin()
	end

	local spinRemote = game:GetService("ReplicatedStorage")
		:WaitForChild("Packages")
		:WaitForChild("_Index")
		:WaitForChild("sleitnick_knit@1.7.0")
		:WaitForChild("knit")
		:WaitForChild("Services")
		:WaitForChild("StyleService")
		:WaitForChild("RF")
		:WaitForChild("Roll")
	local slotRemote = game:GetService("ReplicatedStorage")
		:WaitForChild("Packages")
		:WaitForChild("_Index")
		:WaitForChild("sleitnick_knit@1.7.0")
		:WaitForChild("knit")
		:WaitForChild("Services")
		:WaitForChild("StyleService")
		:WaitForChild("RF")
		:WaitForChild("SelectSlot")
	local flagRemote = game:GetService("ReplicatedStorage")
		:WaitForChild("Packages")
		:WaitForChild("_Index")
		:WaitForChild("sleitnick_knit@1.7.0")
		:WaitForChild("knit")
		:WaitForChild("Services")
		:WaitForChild("GameService")
		:WaitForChild("RF")
		:WaitForChild("SetFlag")

	local spinRemoteAbility = game:GetService("ReplicatedStorage")
		:WaitForChild("Packages")
		:WaitForChild("_Index")
		:WaitForChild("sleitnick_knit@1.7.0")
		:WaitForChild("knit")
		:WaitForChild("Services")
		:WaitForChild("AbilityService")
		:WaitForChild("RF")
		:WaitForChild("Roll")
	local slotRemoteAbility = game:GetService("ReplicatedStorage")
		:WaitForChild("Packages")
		:WaitForChild("_Index")
		:WaitForChild("sleitnick_knit@1.7.0")
		:WaitForChild("knit")
		:WaitForChild("Services")
		:WaitForChild("AbilityService")
		:WaitForChild("RF")
		:WaitForChild("SelectSlot")

	local manualSpinType = "Regular"
	local manualSlot = 1

	local function spinStyle()
		flagRemote:InvokeServer("Style1")

		if manualSpinType == "Lucky" then
			if StyleController.LuckySpins:get() <= 0 then
				return false, "Not enough lucky spins."
			end
		end

		local success = slotRemote:InvokeServer(manualSlot)
		if not success then
			return false, "Slot failed to select."
			-->> slot unexistent
		end

		local success, result = spinRemote:InvokeServer(manualSpinType == "Lucky")
		if not success or not result then
			return false, "Not enough spins."
		end

		-->> Success!!
		return true, "Success!! Obtained style: " .. styleFromId(result).DisplayName or result
	end

	local function spinAbility()
		flagRemote:InvokeServer("Ability1")

		if manualSpinType == "Lucky" then
			if AbilityController.LuckySpins:get() <= 0 then
				return false, "Not enough lucky spins."
			end
		end

		local success = slotRemoteAbility:InvokeServer(manualSlot)
		if not success then
			return false, "Slot failed to select."
			-->> slot unexistent
		end

		local success, result = spinRemoteAbility:InvokeServer(manualSpinType == "Lucky")
		if not success or not result then
			return false, "Not enough spins."
		end

		-->> Success!!
		return true, "Success!! Obtained style: " .. abilityFromId(result).DisplayName or result
	end

	local manualHeader = header:TreeNode({
		Title = "Manual",
	})

	manualHeader:Label({
		Text = "Rollback: Your data won't be saved, and when you rejoin you will get your stuff back",
	})

	manualHeader:Button({
		Text = "Rollback",
		Callback = rollback,
	})

	manualHeader:Button({
		Text = "Un-Rollback",
		Callback = unRollback,
	})

	manualHeader:Button({
		Text = "Rejoin",
		Callback = rejoin,
	})

	manualHeader:Button({
		Text = "Rollback & Rejoin",
		Callback = rollbackAndRejoin,
	})

	local asdfdgdfbdf = manualHeader:Combo({
		Label = "Slot",
		Items = { 1, 2, 3, 4, 5, 6 },
		Callback = function(_, item)
			manualSlot = item
		end,
	})
	ConfigHandler:AddElement("ManualSpinSlot", asdfdgdfbdf)

	local fdjnfdhjbndfbdf = manualHeader:Combo({
		Label = "Spin Type",
		Items = { "Lucky", "Regular" },
		Callback = function(_, item)
			manualSpinType = item
		end,
	})
	ConfigHandler:AddElement("AutoSpinType", fdjnfdhjbndfbdf)

	manualHeader:Button({
		Text = "Spin Style",
		Callback = function()
			local success, result = spinStyle()
			if not success then
				return
			end
		end,
	})

	manualHeader:Button({
		Text = "Spin Ability",
		Callback = function()
			local success, result = spinAbility()
			if not success then
				return
			end
		end,
	})

	-->> Auto Spin Style
	--
	do
		local SELECTED_STYLES = {}
		local SPIN_TYPE = "Lucky"
		local MAX_SPINS = 10
		local SELECTED_SLOT = 1
		local AUTO_SPIN = false
		local AUTO_SPIN_JAN = Janitor.new()

		local function disableAutoSpin()
			AUTO_SPIN_JAN:Cleanup()
			return true
		end

		local spinCount = 0

		-->> AUTO SPIN FUN
		local function autoSpinFunc()
			flagRemote:InvokeServer("Style1")

			if not AUTO_SPIN then
				return
			end

			if spinCount > MAX_SPINS then
				rollbackAndRejoin()
				return false, "Max spins reached."
				-->> Failed!!
			end

			if SPIN_TYPE == "Lucky" then
				if StyleController.LuckySpins:get() <= 0 then
					rollbackAndRejoin()
					return false, "Not enough lucky spins, Rejoining.."
				end
			end

			local success = slotRemote:InvokeServer(SELECTED_SLOT)
			if not success then
				return true, "Slot failed to select."
				-->> slot unexistent
			end

			if SELECTED_STYLES[LocalPlayer:GetAttribute("Style")] then
				return true, "Style already selected."
			end

			local success, result = spinRemote:InvokeServer(SPIN_TYPE == "Lucky")
			if not success or not result then
				rollbackAndRejoin()
				return false, "Not enough spins, Rejoining..."
			end

			result = result[#result]

			spinCount += 1
			if not SELECTED_STYLES[result] then
				HaikyuuRaper:Notify(
					"Auto Style",
					"Obtained style: " .. styleFromId(result).DisplayName or result,
					2,
					false
				)
				return autoSpinFunc()
			end

			-->> Success!!
			rejoin()
			return true, "Success!! Obtained style: " .. styleFromId(result).DisplayName or result
		end

		local function enableAutoSpin()
			if SPIN_TYPE == "Lucky" then
				if StyleController.LuckySpins:get() <= 0 then
					return false, "Not enough spins."
				end
			end

			local success = slotRemote:InvokeServer(SELECTED_SLOT)
			if not success then
				return false, "Invalid Slot."
			end

			if SELECTED_STYLES[LocalPlayer:GetAttribute("Style")] then
				return false, "Already have style."
			end

			local ended, result = autoSpinFunc()
			if ended then
				toggleAutoSpin(false)
			end

			return ended, result
			-->> Success!!
		end

		local autoStyleHeader = header:TreeNode({
			Title = "Auto Style (Inf Spins)",
			Collapsed = true,
		})

		local toggleCheckbox
		function toggleAutoSpin(enabled)
			if enabled == AUTO_SPIN then
				return
			end
			AUTO_SPIN = enabled

			local func = enabled and enableAutoSpin or disableAutoSpin
			local result, notif = func()

			toggleCheckbox:SetValue(AUTO_SPIN)
			if notif then
				HaikyuuRaper:Notify("Auto Style", notif, 3, true)
			end
		end

		toggleCheckbox = autoStyleHeader:Checkbox({
			Label = "Enabled",
			Value = AUTO_SPIN,
			Callback = function(_, v)
				toggleAutoSpin(v)
			end,
		})

		local combo = autoStyleHeader:Combo({
			Label = "Slot",
			Items = { 1, 2, 3, 4, 5, 6 },
			Callback = function(_, item)
				SELECTED_SLOT = item
			end,
		})
		ConfigHandler:AddElement("AutoSpinSlot", combo)

		ConfigHandler:AddElement(
			"AutoSpinMaxSpins",
			autoStyleHeader:SliderInt({
				Label = "Max Spins",
				Value = MAX_SPINS,
				Minimum = 1,
				Maximum = 20,
				Callback = function(_, v)
					MAX_SPINS = v
				end,
			})
		)

		local spinTypeCombo = autoStyleHeader:Combo({
			Label = "Spin Type",
			Items = { "Lucky", "Regular" },
			Callback = function(_, item)
				SPIN_TYPE = item
			end,
		})
		ConfigHandler:AddElement("AutoSpinType", spinTypeCombo)

		local styleHeader = autoStyleHeader:TreeNode({
			Title = "Target Styles",
			Collapsed = true,
		})

		local activeStyles = StyleModule:GetActive()

		for _, style in activeStyles do
			local id = style.Id
			local display = style.DisplayName or id

			local rarityColor = colorFromRarity(style.Rarity)

			local coloredDisplay = string.format(
				'<font color="rgb(%d,%d,%d)">%s</font>',
				math.floor(rarityColor.R * 255),
				math.floor(rarityColor.G * 255),
				math.floor(rarityColor.B * 255),
				display
			)

			local checkbox = styleHeader:Checkbox({
				Label = coloredDisplay,
				Value = SELECTED_STYLES[id],
				Callback = function(_, v)
					SELECTED_STYLES[id] = v
				end,
			})
			ConfigHandler:AddElement("AutoSpinStyle" .. id, checkbox)
		end

		ConfigHandler:AddElement("AutoSpinToggle", toggleCheckbox)
	end

	-- Auto Spin Ability
	--[[]
        do
            local SELECTED_STYLES = {}
            local SPIN_TYPE = "Lucky"
            local MAX_SPINS = 10
            local SELECTED_SLOT = 1
            local AUTO_SPIN = false
            local AUTO_SPIN_JAN = Janitor.new()
    
            local function disableAutoSpin()
                AUTO_SPIN_JAN:Cleanup()
                return true
            end
    
            local spinCount = 0
    
            -->> AUTO SPIN FUN
            local function autoSpinFunc()
                flagRemote:InvokeServer("Ability1")
            
                if not AUTO_SPIN then return end
    
                if spinCount > MAX_SPINS then
                    rollbackAndRejoin()
                    return false, "Max spins reached."
                    -->> Failed!!
                end
    
                if SPIN_TYPE == "Lucky" then
                    if AbilityController.LuckySpins:get() <= 0 then
                        rollbackAndRejoin()
                        return false, "Not enough lucky spins, Rejoining.."
                    end
                end
    
                local success = slotRemoteAbility:InvokeServer(SELECTED_SLOT)
                if not success then
                    return true, "Slot failed to select."
                    -->> slot unexistent
                end
    
                if SELECTED_STYLES[LocalPlayer:GetAttribute("Ability")] then
                    return true, "Style already selected."
                end
    
                local success, result = spinRemoteAbility:InvokeServer(SPIN_TYPE == "Lucky")
                if not success or not result then
                    rollbackAndRejoin()
                    return false, "Not enough spins, Rejoining..."
                end
    
                result = result[#result]
    
                spinCount += 1
                if not SELECTED_STYLES[result] then
                    HaikyuuRaper:Notify("Auto Style", "Obtained style: ".. abilityFromId(result).DisplayName or result, 2, false)
                    return autoSpinFunc()
                end
    
                -->> Success!!
                rejoin()
                return true, "Success!! Obtained style: ".. abilityFromId(result).DisplayName or result
            end
    
            local function enableAutoSpin()
                if SPIN_TYPE == "Lucky" then
                    if AbilityController.LuckySpins:get() <= 0 then
                        return false, "Not enough spins."
                    end
                end
    
                local success = slotRemoteAbility:InvokeServer(SELECTED_SLOT)
                if not success then
                    return false, "Invalid Slot."
                end
    
                if SELECTED_STYLES[LocalPlayer:GetAttribute("Ability")] then
                    return false, "Already have style."
                end
    
                local ended, result = autoSpinFunc()
                if ended then
                    toggleAutoSpin(false)
                end
    
                return ended, result
                -->> Success!!
            end
    
            local autoStyleHeader = header:TreeNode({
                Title = "Auto Ability (Inf Spins)",
                Collapsed = true,
            })
    
            local toggleCheckbox;
            function toggleAutoSpin(enabled)
                if enabled == AUTO_SPIN then return end
                AUTO_SPIN = enabled
    
                local func = enabled and enableAutoSpin or disableAutoSpin
                local result, notif = func()
    
                toggleCheckbox:SetValue(AUTO_SPIN)
                if notif then
                    HaikyuuRaper:Notify("Auto Ability", notif, 3, true)
                end
            end
    
            toggleCheckbox = autoStyleHeader:Checkbox({
                Label = "Enabled",
                Value = AUTO_SPIN,
                Callback = function(_, v)
                    toggleAutoSpin(v)
                end,
            })
    
            local combo = autoStyleHeader:Combo({
                Label = "Slot",
                Items = {1,2,3,4,5,6},
                Callback = function(_, item)
                    SELECTED_SLOT = item
                end,
            })
            ConfigHandler:AddElement("AutoSpinAbilitySlot", combo)
    
            ConfigHandler:AddElement("AutoSpinAbilityMaxSpins", autoStyleHeader:SliderInt({
                Label = "Max Spins",
                Value = MAX_SPINS,
                Minimum = 1,
                Maximum = 10,
                Callback = function(_, v)
                    MAX_SPINS = v
                end,
            }))
    
            local spinTypeCombo = autoStyleHeader:Combo({
                Label = "Spin Type",
                Items = {"Lucky", "Regular"},
                Callback = function(_, item)
                    SPIN_TYPE = item
                end,
            })
            ConfigHandler:AddElement("AutoSpinAbilityType", spinTypeCombo)
    
            local styleHeader = autoStyleHeader:TreeNode({
                Title = "Target Abilities",
                Collapsed = true,
            })
    
            local activeStyles = {}
            for _, v in AbilityPath:GetChildren() do
                table.insert(activeStyles, require(v))
            end
            
            for _, style in activeStyles do
                local id = style.Id
                local display = style.DisplayName or id
    
                local rarityColor = colorFromRarity(style.Rarity)
    
                local coloredDisplay = string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
                    math.floor(rarityColor.R * 255), 
                    math.floor(rarityColor.G * 255), 
                    math.floor(rarityColor.B * 255), 
                    display)
    
                local checkbox = styleHeader:Checkbox({
                    Label = coloredDisplay,
                    Value = SELECTED_STYLES[id],
                    Callback = function(_, v)
                        SELECTED_STYLES[id] = v
                    end,
                })
                ConfigHandler:AddElement("AutoSpinAbility" .. id, checkbox)
            end
    
            ConfigHandler:AddElement("AutoSpinAbilityToggle", toggleCheckbox)
        end
        ]]
end

-->> Autofarm
do
	local AutoFarmTab = Window:CollapsingHeader({
		Title = "🌱 Auto Farm",
	})

	local AutoFarmConfig = {
		Enabled = false,
		Blatant = true,
		AccountFarmingMode = true,
	}

	local jan = Janitor.new()
	local inroundJan = Janitor.new()

	jan:Add(function()
		inroundJan:Cleanup()
	end)

	local joinRemote = ReplicatedStorage:WaitForChild("Packages")
		:WaitForChild("_Index")
		:WaitForChild("sleitnick_knit@1.7.0")
		:WaitForChild("knit")
		:WaitForChild("Services")
		:WaitForChild("GameService")
		:WaitForChild("RF")
		:WaitForChild("RequestJoin")

	local function getInRound()
		if LocalPlayer.Team then
			return true
		end
		for i = 1, 2 do
			for k = 1, 6 do
				local success = joinRemote:InvokeServer(i, k)
				if success then
					return true
				end
			end
		end
	end

	local spikeHitboxSize = ReplicatedStorage.Assets.Hitboxes.Spike.Part.Size
	local interactRemote = ReplicatedStorage:WaitForChild("Packages")
		:WaitForChild("_Index")
		:WaitForChild("sleitnick_knit@1.7.0")
		:WaitForChild("knit")
		:WaitForChild("Services")
		:WaitForChild("BallService")
		:WaitForChild("RF")
		:WaitForChild("Interact")

	local function toggle(enabled)
		if enabled == AutoFarmConfig.Enabled then
			return
		end
		AutoFarmConfig.Enabled = enabled

		if enabled then
			-->> Enable
			jan:Add(task.defer(function()
				while AutoFarmConfig.Enabled do
					-->> wait for round start
					if ReplicatedStorage:GetAttribute("RoundState") == 1 then
						ReplicatedStorage:GetAttributeChangedSignal("RoundState"):Wait()
					end

					if not getInRound() then
						continue
					end

					-->> choose team
					inroundJan:Add(
						LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
							if not LocalPlayer.Team then
								while ReplicatedStorage:GetAttribute("RoundState") ~= 1 do
									if getInRound() then
										return
									end
								end
							end
						end),
						nil,
						"TeamChangeConnection"
					)

					local blatantClock = os.clock()

					-->> autoplay
					inroundJan:Add(task.defer(function()
						while RunService.Heartbeat:Wait() do
							if not LocalPlayer.Team then
								continue
							end

							if LocalPlayer:GetAttribute("IsServing") then
								local args = {
									Vector3.new(0, 0, 0),
									0.5,
								}
								game:GetService("ReplicatedStorage")
									:WaitForChild("Packages")
									:WaitForChild("_Index")
									:WaitForChild("sleitnick_knit@1.7.0")
									:WaitForChild("knit")
									:WaitForChild("Services")
									:WaitForChild("GameService")
									:WaitForChild("RF")
									:WaitForChild("Serve")
									:InvokeServer(unpack(args))
								continue
							end

							if not BallTrajectory.LastTrajectory then
								continue
							end

							local character = LocalPlayer.Character
							if
								not character
								or not character:FindFirstChild("Humanoid")
								or not character:FindFirstChild("HumanoidRootPart")
							then
								continue
							end

							local humanoid = character:FindFirstChild("Humanoid")
							humanoid.AutoRotate = false

							local rootPart = character:FindFirstChild("HumanoidRootPart")

							local playerPosition = rootPart.Position

							local courtPosition = CourtPart.Position
							local courtSize = CourtPart.Size

							-- Determine which side of the court the player is on (using Z axis)
							local isPlayerOnPositiveZSide = tonumber(LocalPlayer.Team:GetAttribute("Index")) == 2

							-- Calculate center position of player's side of court
							local centerX = courtPosition.X
							local centerZ = courtPosition.Z
								+ (isPlayerOnPositiveZSide and courtSize.Z / 4 or -courtSize.Z / 4)
							local centerY = rootPart.Position.Y

							local centerPosition = Vector3.new(centerX, centerY, centerZ)
							humanoid.WalkToPoint = centerPosition * Vector3.new(1, 0, 1)
								+ rootPart.Position * Vector3.new(0, 1, 0)

							local ball = BallTrajectory.LastBall
							if not ball then
								continue
							end

							local playerPing = LocalPlayer:GetNetworkPing()
							local acceleration = ball.Acceleration
							local velocity = ball.Velocity
							local position = ball.Position

							local ballPosition = position
							local landingPosition = BallTrajectory.LastTrajectory
							local timeToLand = BallTrajectory.LastTime

							if ReplicatedStorage:GetAttribute("Gamemode") ~= "Training" then
								if
									ReplicatedStorage:GetAttribute("ServedByPlayer") ~= LocalPlayer.Name
									and ReplicatedStorage:GetAttribute("ServedByPlayer") ~= nil
									--[[
									and (
										not ReplicatedStorage:GetAttribute("LastHitType")
										or not ReplicatedStorage:GetAttribute("TeamHitStreak")
									)
									]]
								then
									continue
								end

								-- Check if landing position is on the same side as the player
								local isLandingOnPlayersSide = (
									isPlayerOnPositiveZSide and landingPosition.Z > courtPosition.Z
								)
									or (not isPlayerOnPositiveZSide and landingPosition.Z < courtPosition.Z)

								if not isLandingOnPlayersSide then
									continue
								end
							end

							local function bump()
								local ballToPlayerDist = (ballPosition - playerPosition).Magnitude
								local landingToPlayerDist = (landingPosition - playerPosition).Magnitude
								local setRange = 7 * (HITBOX_MULTIPLIER_ENABLED and HITBOX_MULTIPLIERS["Bump"] or 1)
								if
									(ballToPlayerDist <= setRange)
									or (
										timeToLand < 0.25 + 0.5 * LocalPlayer:GetNetworkPing()
										and landingToPlayerDist <= setRange
									)
								then
									-- Ball or landing position is close enough to set
									setthreadidentity(2)
									gameController:DoMove("Bump")
									setthreadidentity(8)
								end
							end

							-- Check if current ball position is on player's side
							local isBallOnPlayersSide = (isPlayerOnPositiveZSide and ballPosition.Z > courtPosition.Z)
								or (not isPlayerOnPositiveZSide and ballPosition.Z < courtPosition.Z)

							if AutoFarmConfig.Blatant then
								if isBallOnPlayersSide then
									if ReplicatedStorage:GetAttribute("LastHitter") == LocalPlayer.Name then
										rootPart.CFrame = CFrame.new(centerPosition + Vector3.new(0, 6, 0))
											* CFrame.lookAt(
												centerPosition * Vector3.new(1, 0, 1),
												(
													CourtPart.CFrame.Position
													+ Vector3.new(
														0,
														0,
														isPlayerOnPositiveZSide and -CourtPart.Size.Z / 2
															or CourtPart.Size.Z / 2
													)
												) * Vector3.new(1, 0, 1)
											).Rotation
										continue
									end

									rootPart.CFrame = CFrame.new(ballPosition)
										* CFrame.lookAt(
											ballPosition * Vector3.new(1, 0, 1),
											(
												CourtPart.CFrame.Position
												+ Vector3.new(
													0,
													0,
													isPlayerOnPositiveZSide and -CourtPart.Size.Z / 2
														or CourtPart.Size.Z / 2
												)
											) * Vector3.new(1, 0, 1)
										).Rotation

									if os.clock() - blatantClock > 0.05 then
										blatantClock = os.clock()
										task.spawn(function()
											if ReplicatedStorage:GetAttribute("LastHitType") ~= "Spike" then
												blatantClock = os.clock()
												setthreadidentity(2)
												gameController:DoMove("Spike")
												setthreadidentity(8)
											else
												setthreadidentity(2)
												gameController:DoMove("Bump")
												setthreadidentity(8)
											end
										end)
									end
								else
									-- Teleport player to where the ball would be right after it passed the net
									do
										--warn("STEP 1 TYPE")

										-- Assume the net is at Z = 0 in court local space, adjust as needed
										local ballVel = velocity
										local ballPos = position
										local ballZ = ballPos.Z
										local ballVZ = ballVel.Z

										-- Find the Z position of the net in world space
										local netWorldZ = CourtPart.CFrame.Position.Z

										-- Only proceed if the ball is moving toward the player's side
										if
											(isPlayerOnPositiveZSide and ballVZ > 0)
											or (not isPlayerOnPositiveZSide and ballVZ < 0)
										then
											--warn("STEP 2 TYPE")
											-- Calculate time to reach the net plane (Z = netWorldZ)
											local t = (netWorldZ - ballZ) / ballVZ
											if t > 0 and t < timeToLand then
												--warn("STEP 3 TYPE")
												-- Predict ball position at that time (ignoring gravity for simplicity)
												local predictedPos = Vector3.new(
													position.X + velocity.X * t + 0.5 * acceleration.X * t * t,
													position.Y + velocity.Y * t + 0.5 * acceleration.Y * t * t,
													position.Z + velocity.Z * t + 0.5 * acceleration.Z * t * t
												)
												-- Place player slightly behind the net on their side
												local offset = isPlayerOnPositiveZSide and 4 or -4
												local playerTargetPos =
													Vector3.new(predictedPos.X, predictedPos.Y, netWorldZ + offset)
												rootPart.CFrame = CFrame.new(playerTargetPos)
													* CFrame.lookAt(
														playerTargetPos * Vector3.new(1, 0, 1),
														(
															CourtPart.CFrame.Position
															+ Vector3.new(
																0,
																0,
																isPlayerOnPositiveZSide and -CourtPart.Size.Z / 2
																	or CourtPart.Size.Z / 2
															)
														) * Vector3.new(1, 0, 1)
													).Rotation
											else
												-- Fallback: just go to landingPosition
												rootPart.CFrame = CFrame.new(landingPosition)
													* CFrame.lookAt(
														landingPosition * Vector3.new(1, 0, 1),
														(
															CourtPart.CFrame.Position
															+ Vector3.new(
																0,
																0,
																isPlayerOnPositiveZSide and -CourtPart.Size.Z / 2
																	or CourtPart.Size.Z / 2
															)
														) * Vector3.new(1, 0, 1)
													).Rotation
											end
										else
											rootPart.CFrame = CFrame.new(centerPosition + Vector3.new(0, 2, 0))
												* CFrame.lookAt(
													centerPosition * Vector3.new(1, 0, 1),
													(
														CourtPart.CFrame.Position
														+ Vector3.new(
															0,
															0,
															isPlayerOnPositiveZSide and -CourtPart.Size.Z / 2
																or CourtPart.Size.Z / 2
														)
													) * Vector3.new(1, 0, 1)
												).Rotation
										end
									end
								end
							else
								rootPart.CFrame = CFrame.new(rootPart.Position)
									* CFrame.lookAt(
										rootPart.Position * Vector3.new(1, 0, 1),
										(
											CourtPart.CFrame.Position
											+ Vector3.new(
												0,
												0,
												isPlayerOnPositiveZSide and -CourtPart.Size.Z / 2
													or CourtPart.Size.Z / 2
											)
										) * Vector3.new(1, 0, 1)
									).Rotation

								if ReplicatedStorage:GetAttribute("LastHitter") == LocalPlayer.Name then
									continue
								end

								humanoid.WalkToPoint = BallTrajectory.LastTrajectory * Vector3.new(1, 0, 1)
									+ rootPart.Position * Vector3.new(0, 1, 0)
								bump()
							end
						end
					end))

					-->> wait for round end

					while ReplicatedStorage:GetAttribute("RoundState") ~= 1 do
						ReplicatedStorage:GetAttributeChangedSignal("RoundState"):Wait()
					end

					inroundJan:Cleanup()
				end
			end))
		else
			-->> Disable
			jan:Cleanup()
		end
	end

	--[[
		local old
	old = hookmetamethod(
		game,
		"__namecall",
		newcclosure(function(self, ...)
			local args = { ... }
			if not checkcaller() then
				if
					AutoFarmConfig.Enabled
					and getnamecallmethod() == "InvokeServer"
					and typeof(self) == "Instance"
					and self.ClassName == "RemoteFunction"
					and self.Name == "Interact"
				then
					local t = args[1]
					if typeof(t) == "table" then
						local action = rawget(t, "Action")
						if action == "Spike" then
							rawset(t, "TiltVector", )
						end
					end
				end
			end
			return old(self, table.unpack(args))
		end)
	)
	]]

	local toggleCheckbox = AutoFarmTab:Checkbox({
		Label = "Enabled",
		Value = AutoFarmConfig.Enabled,
		Callback = function(_, v)
			toggle(v)
		end,
	})

	ConfigHandler:AddElement(
		"AutoFarmBlatant",
		AutoFarmTab:Checkbox({
			Label = "Blatant",
			Value = AutoFarmConfig.Blatant,
			Callback = function(_, v)
				AutoFarmConfig.Blatant = v
			end,
		})
	)

	ConfigHandler:AddElement("AutoFarmToggle", toggleCheckbox)
end

-->> Debug
do
	local DebugTab = Window:CollapsingHeader({
		Title = "🧪 Debug",
		Collapsed = true,
	})

	local PreviewContainer = Instance.new("Folder")
	PreviewContainer.Name = "DebugFolder"
	PreviewContainer.Parent = workspace

	if BallTrajectory then
		do
			local PreviewConfig = {
				Enabled = false,
				PreviewBallColor = Color3.fromRGB(255, 0, 0),
				PreviewBallTransparency = 0.5,
				BeamColor = Color3.fromRGB(82, 82, 82),
				BeamWidth = 0.2,
				PreviewBallScale = GameModule.Physics.Radius * 2,
			}

			local BallPreviews = {}

			local function removeBallPreview(ball)
				if not BallPreviews[ball] then
					return
				end
				for _, obj in pairs(BallPreviews[ball]) do
					if obj and obj.Parent then
						obj:Destroy()
					end
				end
				BallPreviews[ball] = nil
			end

			local function createBallPreview(ball)
				if not PreviewConfig.Enabled then
					return
				end
				removeBallPreview(ball)

				local originalBall = ball.Model
				local originalPart = originalBall.PrimaryPart
				local ballSize = Vector3.one * PreviewConfig.PreviewBallScale

				local previewBall = Instance.new("Part")
				previewBall.Shape = Enum.PartType.Ball
				previewBall.Size = ballSize
				previewBall.Color = PreviewConfig.PreviewBallColor
				previewBall.Transparency = PreviewConfig.PreviewBallTransparency
				previewBall.CanCollide = false
				previewBall.Anchored = true
				previewBall.CanQuery = false
				previewBall.CanTouch = false
				previewBall.Parent = PreviewContainer

				local sourceAttachment, targetAttachment = Instance.new("Attachment"), Instance.new("Attachment")
				sourceAttachment.Parent, sourceAttachment.Name = originalPart, "TrajectoryBeamSource"
				targetAttachment.Parent, targetAttachment.Name = previewBall, "TrajectoryBeamTarget"

				local beam = Instance.new("Beam")
				beam.Name, beam.Color = "TrajectoryBeam", ColorSequence.new(PreviewConfig.BeamColor)
				beam.Width0, beam.Width1, beam.FaceCamera = PreviewConfig.BeamWidth, PreviewConfig.BeamWidth, true
				beam.Attachment0, beam.Attachment1, beam.Parent = sourceAttachment, targetAttachment, previewBall

				local text = Instance.new("BillboardGui")
				text.Size = UDim2.new(2, 0, 1, 0)
				text.AlwaysOnTop = true
				text.Parent = previewBall
				text.Name = "RemainingTimeText"

				local timeLabel = Instance.new("TextLabel")
				timeLabel.Size = UDim2.new(1, 0, 1, 0)
				timeLabel.Font = Enum.Font.SourceSans
				timeLabel.TextStrokeTransparency = 0
				timeLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
				timeLabel.FontSize = Enum.FontSize.Size48
				timeLabel.BackgroundTransparency = 1
				timeLabel.TextColor3 = Color3.new(1, 1, 1)
				timeLabel.Text = "0.00"
				timeLabel.Parent = text

				BallPreviews[ball] = {
					PreviewBall = previewBall,
					Beam = beam,
					SourceAttachment = sourceAttachment,
					TargetAttachment = targetAttachment,
					RemainingTimeText = text,
					RemainingTimeLabel = timeLabel,
				}
			end

			local function updateBallPreview(ball, landingPosition, remainingTime)
				if landingPosition and PreviewConfig.Enabled and BallPreviews[ball] then
					BallPreviews[ball].PreviewBall.Position = landingPosition
					if remainingTime then
						BallPreviews[ball].RemainingTimeLabel.Text = string.format("%.2f", remainingTime)
					end

					-- Get court information
					local courtPosition = CourtPart.Position
					local courtSize = CourtPart.Size
					local ballRadius = GameModule.Physics.Radius

					-- Check if landing position is within court boundaries on X axis (with radius)
					local isInXBounds = landingPosition.X > (courtPosition.X - courtSize.X / 2 - ballRadius)
						and landingPosition.X < (courtPosition.X + courtSize.X / 2 + ballRadius)

					-- Check if landing position is within court boundaries on Z axis (with radius)
					local isInZBounds = landingPosition.Z > (courtPosition.Z - courtSize.Z / 2 - ballRadius)
						and landingPosition.Z < (courtPosition.Z + courtSize.Z / 2 + ballRadius)

					-- Determine if ball is in bounds (both X and Z must be within court)
					local isInBounds = isInXBounds and isInZBounds

					if isInBounds then
						BallPreviews[ball].PreviewBall.Color = Color3.new(1, 0, 0) -- Red for in bounds
						BallPreviews[ball].RemainingTimeLabel.TextColor3 = Color3.new(1, 0, 0)
					else
						BallPreviews[ball].PreviewBall.Color = Color3.new(0, 1, 0) -- Green for out of bounds
						BallPreviews[ball].RemainingTimeLabel.TextColor3 = Color3.new(0, 1, 0)
					end
				end
			end

			local function cleanupAllPreviews()
				for ball in pairs(BallPreviews) do
					removeBallPreview(ball)
				end
				BallPreviews = {}
			end

			function ToggleBallTrajectoryPreviews(enabled)
				if PreviewConfig.Enabled == enabled then
					return
				end
				PreviewConfig.Enabled = enabled
				if not enabled then
					cleanupAllPreviews()
				else
					for _, ball in BallTrajectory.GetAllBalls() do
						createBallPreview(ball)
					end
				end
				return PreviewConfig.Enabled
			end

			BallTrajectory.OnBallAdded:Connect(createBallPreview)
			BallTrajectory.OnBallUpdated:Connect(function(ball, landingPosition, remainingTime)
				if landingPosition then
					if BallPreviews[ball] then
						updateBallPreview(ball, landingPosition, remainingTime)
					else
						createBallPreview(ball)
					end
				else
					removeBallPreview(ball)
				end
			end)
			BallTrajectory.OnBallRemoved:Connect(removeBallPreview)

			hooks:Add(function()
				ToggleBallTrajectoryPreviews(false)
			end)

			local BallTrajectoryNode = DebugTab:TreeNode({
				Title = "Ball Trajectory",
				Collapsed = false,
			})

			ConfigHandler:AddElement(
				"TrajectoryPreviewToggle",
				BallTrajectoryNode:Checkbox({
					Label = "Enabled",
					Value = true,
					Callback = function(_, v)
						ToggleBallTrajectoryPreviews(v)
					end,
				})
			)
		end
	end
	do
		local toggleEnabled = false
		local enemyCylinders = {}
		local courtHighlight = nil
		local enemyHighlightModel = nil

		local janitor = Janitor.new()

		local function createHighlightModel()
			enemyHighlightModel = Instance.new("Model")
			enemyHighlightModel.Name = "EnemyHighlights"
			enemyHighlightModel.Parent = PreviewContainer

			janitor:Add(enemyHighlightModel)
		end

		local function updateCourtHighlight()
			if not courtHighlight then
				return
			end

			if not LocalPlayer.Team or not LocalPlayer.Team:GetAttribute("Index") then
				courtHighlight.Parent = nil
				return
			else
				courtHighlight.Parent = PreviewContainer
			end

			local courtPos = CourtPart.Position
			local halfZ = CourtPart.Size.Z / 2
			local newPos = courtPos

			if LocalPlayer.Team and LocalPlayer.Team:GetAttribute("Index") == 1 then
				newPos = Vector3.new(courtPos.X, courtPos.Y + 0.1, courtPos.Z + (halfZ / 2))
			elseif LocalPlayer.Team and LocalPlayer.Team:GetAttribute("Index") == 2 then
				newPos = Vector3.new(courtPos.X, courtPos.Y + 0.1, courtPos.Z - (halfZ / 2))
			end

			courtHighlight.Size = Vector3.new(CourtPart.Size.X, CourtPart.Size.Y, halfZ)
			courtHighlight.CFrame = CFrame.new(newPos) * CourtPart.CFrame.Rotation
		end

		local function createCourtHighlight()
			local highlightPart = Instance.new("Part")
			highlightPart.Name = "CourtHighlightPart"
			highlightPart.Anchored = true
			highlightPart.CanCollide = false
			highlightPart.Color = Color3.fromRGB(165, 255, 165)
			highlightPart.Material = Enum.Material.ForceField
			highlightPart.Transparency = 0.5
			highlightPart.Parent = PreviewContainer

			courtHighlight = highlightPart
			updateCourtHighlight()

			janitor:Add(highlightPart)
		end

		local function createEnemyCylinder(player)
			if player == LocalPlayer then
				return
			end
			if not player.Team or (LocalPlayer.Team and player.Team and player.Team == LocalPlayer.Team) then
				return
			end

			local multiplier = player:GetAttribute("GameDiveSpeedMultiplier") or 1
			local radius = 10 * multiplier

			local cylinder = Instance.new("Part")
			cylinder.Shape = Enum.PartType.Cylinder
			cylinder.Name = player.Name .. "_HighlightCylinder"
			cylinder.Anchored = true
			cylinder.CanCollide = false
			cylinder.Color = Color3.new(1, 0, 0)
			cylinder.Material = Enum.Material.Neon
			cylinder.Transparency = 0.75
			cylinder.Size = Vector3.new(0.2, radius * 2, radius * 2)
			cylinder.Parent = enemyHighlightModel

			enemyCylinders[player] = cylinder
			janitor:Add(cylinder, nil, player)

			return cylinder
		end

		local function updateEnemyCylinder(player)
			if not enemyCylinders[player] then
				createEnemyCylinder(player)
			end

			local cyl = enemyCylinders[player]
			if cyl and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				cyl.Parent = enemyHighlightModel
				local hrp = player.Character.HumanoidRootPart
				cyl.CFrame = CFrame.new(hrp.Position.X, CourtPart.Position.Y + CourtPart.Size.Y + 0.2, hrp.Position.Z)
					* CFrame.Angles(0, 0, math.rad(90))
			else
				if cyl then
					cyl.Parent = nil
				end
			end
		end

		local function removeEnemyCylinder(player)
			local cyl = enemyCylinders[player]
			if cyl then
				janitor:Remove(player)
				enemyCylinders[player] = nil
			end
		end

		local function setup()
			createHighlightModel()
			createCourtHighlight()

			janitor:Add(RunService.Heartbeat:Connect(function()
				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= LocalPlayer and player then
						if LocalPlayer.Team and player.Team and player.Team ~= LocalPlayer.Team then
							updateEnemyCylinder(player)
						else
							removeEnemyCylinder(player)
						end
					end
				end
			end))

			janitor:Add(Players.PlayerRemoving:Connect(removeEnemyCylinder))
			janitor:Add(LocalPlayer:GetPropertyChangedSignal("Team"):Connect(updateCourtHighlight))
		end

		local function toggle(on)
			if on then
				setup()
			else
				janitor:Cleanup()
				table.clear(enemyCylinders)
				courtHighlight = nil
				enemyHighlightModel = nil
			end
		end

		local DiveRangeNode = DebugTab:TreeNode({
			Title = "Dive Range",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"HitZoneToggle",
			DiveRangeNode:Checkbox({
				Label = "Enabled",
				Value = toggleEnabled,
				Callback = function(_, v)
					toggle(v)
				end,
			})
		)

		hooks:Add(function()
			toggle(false)
		end)
	end
end

notif1:Destroy()
HaikyuuRaper:Finalize()
return true
