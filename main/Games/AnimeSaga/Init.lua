-- Skidded btw.
local SELAMI_HUB = getgenv().SELAMI_HUB

if not SELAMI_HUB then
    --error("🛑 SELAMI_HUB is not defined")
    return false, "SELAMI_HUB is not defined"
end

if not SELAMI_HUB.Key or type(SELAMI_HUB.Key) ~= "string" or SELAMI_HUB.Key ~= "LexinKocaMemeleri" then
    --error("🛑 Invalid Key")
    return false, "Invalid Key"
end

local AnimeSagaRaper = SELAMI_HUB.ModuleLoader:LoadFromPath("Base.lua").new("Anime Saga")

local Janitor = AnimeSagaRaper.Janitor
local Signal = AnimeSagaRaper.Signal
local ConfigHandler = AnimeSagaRaper.configHandler

local Window = AnimeSagaRaper.window:CreateTab({
    Name = "💫 Anime Saga",
    Visible = true
})  

local hooks = AnimeSagaRaper.hooks

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local camera = workspace.CurrentCamera

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

hooks:Add( LocalPlayer.CharacterAdded:Connect(function(char)
    character = char
    humanoidRootPart = nil
    humanoidRootPart = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
    camera.CameraSubject = humanoid
    camera.CameraType = Enum.CameraType.Custom
end) )

local function findNearestEnemy()
    local mobsFolder = workspace:FindFirstChild("Enemy")
    if not mobsFolder then return nil end
    local mobs = mobsFolder:FindFirstChild("Mob")
    if not mobs then return nil end

    if not humanoidRootPart then return nil end

    local nearestMob = nil
    local nearestDistance = math.huge
    for _, mob in pairs(mobs:GetChildren()) do
        if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
            local mobHRP = mob.HumanoidRootPart
            local dist = (mobHRP.Position - humanoidRootPart.Position).Magnitude
            if dist < nearestDistance then
                nearestDistance = dist
                nearestMob = mob
            end
        end
    end
    return nearestMob
end

-- Toggle AutoFollowEnemy trong Fluent UI
local autoFollowEnabled = false
local followConnection;

local function AutoFollowEnemy(enabled)
    if autoFollowEnabled == enabled then return end
    autoFollowEnabled = enabled
    if enabled then
        camera.CameraSubject = humanoid
        camera.CameraType = Enum.CameraType.Custom
        followConnection = RunService.Heartbeat:Connect(function()
            if character and humanoidRootPart then
                local nearestEnemy = findNearestEnemy()
                if nearestEnemy and nearestEnemy:FindFirstChild("HumanoidRootPart") then
                    local enemyHRP = nearestEnemy.HumanoidRootPart
                    local targetPos = enemyHRP.Position - Vector3.new(0, 7, 0)
                    local lookDir = Vector3.new(0, 1, 0)
                    character:PivotTo(CFrame.new(targetPos, targetPos + lookDir))
                end
            end
        end)
    else
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
    end
end

hooks:Add(AutoFollowEnemy)

local AutoFollowEnemyTab = Window:TreeNode({
    Title = "Auto Follow Enemy",
    Collapsed = false
})

ConfigHandler:AddElement("AutoFollowEnemy", AutoFollowEnemyTab:Checkbox({
    Label = "Enabled",
    Value = false,
    Callback = function(_, v)
        AutoFollowEnemy(v)
    end,
}))

local autoCombatEnabled = false
local combatThread

local combatFunction;
local function callCombatFunc()
    if combatFunction then
        local testResult = pcall(combatFunction)
        if testResult then
            return 
        end
    else
        -- scan
        local env = getgc(true)
        for _, func in ipairs(env) do
            if typeof(func) == "function" and debug.getinfo(func).name == "Combat" then
                local constants = debug.getconstants(func)
                if table.find(constants, "Humanoid") and table.find(constants, "Slash") then
                    combatFunction = func
                    break
                end
            end
        end
        pcall(combatFunction)
    end
end

local function AutoCombat(enabled)
    if autoCombatEnabled == enabled then return end
    autoCombatEnabled = enabled
    if enabled then
        combatThread = task.spawn(function()
            repeat task.wait() until game:IsLoaded()
            while true do
                callCombatFunc()
                task.wait(0.2)
            end
        end)
    else
        if combatThread then
            task.cancel(combatThread)
        end
    end
end
hooks:Add(AutoCombat)

local AutoCombatTab = Window:TreeNode({
    Title = "Auto Combat",
    Collapsed = false
})

ConfigHandler:AddElement("AutoCombat", AutoCombatTab:Checkbox({
    Label = "Enabled",
    Value = false,
    Callback = function(_, v)
        AutoCombat(v)
    end,
}))

local ReplicatedStorage = game:GetService("ReplicatedStorage")
function getPositionData()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        return hrp.CFrame, hrp.Position
    end
    return nil, nil
end

local SkillSlots = {
    {argName = "Skill1", skillName = "Skill 1", skillDelay = 5},
    {argName = "Skill2", skillName = "Skill 2", skillDelay = 7},
    {argName = "Skill3", skillName = "Skill 3", skillDelay = 10}
}

local function AutoSkill(skillSlot)
    local skillName = skillSlot.skillName 
    local skillDelay = skillSlot.skillDelay
    local skillArgName = skillSlot.argName

    local thread;

    local function autoSkill()
        while true do
            local cf, pos = getPositionData()
            if cf and pos then
                local args = {skillArgName, cf, pos, "OnSkill"}
                ReplicatedStorage.Events.Skill:FireServer(unpack(args))
            end
            task.wait(skillDelay)
        end
    end

    local isEnabled = false;
    local function toggleAutoSkill(enabled)
        if isEnabled == enabled then return end
        isEnabled = enabled
        if enabled then
            thread = task.spawn(autoSkill)
        else
            if thread then
                task.cancel(thread)
            end
        end
    end

    return toggleAutoSkill;
end

local AutoSkillTab = Window:TreeNode({
    Title = "Auto Skill",
    Collapsed = false
})

for _, skillSlot in ipairs(SkillSlots) do
    local toggleAutoSkill = AutoSkill(skillSlot)
    hooks:Add(toggleAutoSkill)
    ConfigHandler:AddElement(skillSlot.argName, AutoSkillTab:Checkbox({
        Label = skillSlot.skillName,
        Value = true,
        Callback = function(_, v)
            toggleAutoSkill(v)
        end,
    }))
end

AnimeSagaRaper:Finalize()
return true