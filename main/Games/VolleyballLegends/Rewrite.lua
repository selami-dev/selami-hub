
-->> Startup
SELAMI_HUB = getgenv().SELAMI_HUB

if not SELAMI_HUB then
    --error("🛑 SELAMI_HUB is not defined")
    return false, "SELAMI_HUB is not defined."
end

if not SELAMI_HUB.Key or type(SELAMI_HUB.Key) ~= "string" or SELAMI_HUB.Key ~= "LexinKocaMemeleri" then
    --error("🛑 Invalid Key")
    return false, "Invalid Key."
end

-->> Initialize
ModuleLoader = SELAMI_HUB.ModuleLoader
BaseModule = ModuleLoader:LoadFromPath("Base.lua")
BaseScript = BaseModule.new("Volleyball Legends")

-->> Enviroment
Janitor = BaseScript.Janitor
Signal = BaseScript.Signal
ConfigHandler = BaseScript.configHandler

-->> Roblox Services
Players = game:GetService("Players")
ReplicatedFirst = game:GetService("ReplicatedFirst")
RunService = game:GetService("RunService")
CollectionService = game:GetService("CollectionService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
UserGameSettings = UserSettings():GetService("UserGameSettings")
UserInputService = game:GetService("UserInputService")

function Notify(title, message, length, hasSound, theme)
    local title = title and "🏐 Volleyball Legends [" .. title .. "]" or "🏐 Volleyball Legends"
    return BaseScript:Notify(title, message, length, hasSound, theme)
end

-->> Place Check (GAMEMODE)
local PlaceConfig = require(ReplicatedStorage.Configuration.Place)()
if  PlaceConfig.Current == PlaceConfig.IsMatchmakingServer then
    Notify("🔁 Loading", "⏳ Detected Ranked Queue, Waiting for Game (Re-Execute if not correct)", nil, true)
    return true
end

if PlaceConfig.Current == PlaceConfig.Idle then
    Notify("🔁 Loading", "⏳ Detected AFK Server, Waiting for Game (Re-Execute if not correct)", nil, true)
    return true
end

-->> Loading
local LoadingNotif = Notify("🔁 Loading", "Waiting for Round / Game to start.", nil, true)

Knit = require(ReplicatedStorage.Packages.Knit)
Knit.OnStart():await()
    
LocalPlayer = Players.LocalPlayer
if not LocalPlayer:GetAttribute("DataLoaded") then
    LocalPlayer:GetAttributeChangedSignal("DataLoaded"):Wait()
end

Map = workspace:WaitForChild("Map")
CourtPart = Map:WaitForChild("Court")

task.wait()

LoadingNotif:Destroy()

-->> Setup
StylePath = ReplicatedStorage.Content.Style

GameController = require(ReplicatedFirst.Controllers.GameController)
StyleModule = require(StylePath)
StyleController = require(ReplicatedFirst.Controllers.StyleController)
SpecialController = require(ReplicatedFirst.Controllers.SpecialController)
MoveController = require(ReplicatedFirst.Controllers.SpecialController.Move)
NetworkModule = require(ReplicatedStorage.network)
RarityModule = require(ReplicatedStorage.Content.Rarity)
BallModule = require(ReplicatedFirst.Controllers.BallController.Ball)
GameModule = require(ReplicatedStorage.Configuration.Game)

-->> Backend
UTILITY = {}
UTILITY.FUNCTIONS = {}

function UTILITY:Check(functionName)
    if getgenv().functionName then
        return true
    else
        
    end
end

BACKEND = {}
BACKEND.UTILS = {}
BACKEND.RAY = {}
BACKEND.ATTRIBUTE_MODIFIER = {}
BACKEND.BALL_TRAJECTORY = {}

-- ball trajectory
function BACKEND.BALL_TRAJECTORY:Init()
    
end

local newBallSignal, ballDestroySignal, trajectoryUpdatedSignal = Signal.new(), Signal.new(), Signal.new()

BallTrajectory.newBallSignal, BallTrajectory.ballDestroySignal, BallTrajectory.trajectoryUpdatedSignal = newBallSignal, ballDestroySignal, trajectoryUpdatedSignal

local function trajectoryResult(ball, velocity)
    local gravityMultiplier = ball.GravityMultiplier or 1
    local acceleration = ball.Acceleration or Vector3.new(0, 0, 0)
    local ballPart = ball.Ball.PrimaryPart
    local velocity, position = velocity or ballPart.AssemblyLinearVelocity, ballPart.Position
    local floorY = CourtPart.Position.Y + GameModule.Physics.Radius
    local GRAVITY = -GameModule.Physics.Gravity * gravityMultiplier

    local a, b, c = 0.5 * GRAVITY, velocity.Y, position.Y - floorY
    local timeToHit = solveQuadratic(a, b, c)

    if not timeToHit then return nil, nil end

    local landingX = position.X + velocity.X * timeToHit + 0.5 * acceleration.X * timeToHit * timeToHit
    local landingZ = position.Z + velocity.Z * timeToHit + 0.5 * acceleration.Z * timeToHit * timeToHit

    return Vector3.new(landingX, floorY, landingZ), timeToHit
end

local function predictBallLanding(ball, velocity)
    local resultVector, dT = trajectoryResult(ball, velocity)

    BallTrajectory.LastTrajectory = resultVector
    BallTrajectory.LastTime = dT

    trajectoryUpdatedSignal:Fire(ball, resultVector, dT, velocity)
end

local function getAllBalls()
    return BallModule.All
end
BallTrajectory.getAllBalls = getAllBalls

local UNHOOKED = false

local oldNew; oldNew = hookfunction(BallModule.new, newcclosure(function(...)
    if UNHOOKED then return oldNew(...) end
    local newBall = oldNew(...)
    newBallSignal:Fire(newBall)
    predictBallLanding(newBall)
    return newBall
end))

local oldUpdate; oldUpdate = hookfunction(BallModule.Update, newcclosure(function(self, ...)
    if UNHOOKED then return oldUpdate(self, ...) end
    oldUpdate(self, ...)
    predictBallLanding(self, ({...})[2])
    --local data = HaikyuuRaper:Serialize({self, ...}, {Prettify = true})
    --print(data)
end))

local oldDestroy; oldDestroy = hookfunction(BallModule.Destroy, newcclosure(function(self, ...)
    if UNHOOKED then return oldDestroy(self, ...) end
    ballDestroySignal:Fire(self)
    oldDestroy(self, ...)
end))

hooks:Add(function()
    UNHOOKED = true
end)

-- backend finalize
for _, backendModule in BACKEND do
    local success, message = backendModule:Init()
    backendModule.Success = success
end

-->> Hooks

-->> Frontend

-->> Finalize

