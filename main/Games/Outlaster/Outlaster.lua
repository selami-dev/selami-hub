local SELAMI_HUB = getgenv().SELAMI_HUB

if not SELAMI_HUB then
    --error("🛑 SELAMI_HUB is not defined")
    return false, "SELAMI_HUB is not defined"
end

if not SELAMI_HUB.Key or type(SELAMI_HUB.Key) ~= "string" or SELAMI_HUB.Key ~= "LexinKocaMemeleri" then
    --error("🛑 Invalid Key")
    return false, "Invalid Key"
end

local OutlasterRaper = SELAMI_HUB.ModuleLoader:LoadFromPath("Base.lua").new("Outlaster")

local Janitor = OutlasterRaper.Janitor
local Signal = OutlasterRaper.Signal
local ConfigHandler = OutlasterRaper.configHandler

local Window = OutlasterRaper.window:CreateTab({
    Name = "💥 Outlaster",
    Visible = true
})

local hooks = OutlasterRaper.hooks

local function isHint(v)
    return typeof(v) == "Instance" and v.ClassName == "MeshPart" and v.MeshId == "rbxassetid://5163733008"
end

local guis = {}
local ENABLED = true

local function renderHints()
    for _, v in pairs(workspace:GetDescendants()) do
        if isHint(v) then
            if guis[v] then
                continue
            end

            local esp = Instance.new("BillboardGui")
            esp.Name = "HintESP"
            esp.Size = UDim2.new(0, 100, 0, 50)
            esp.StudsOffset = Vector3.new(0, 3, 0)
            esp.AlwaysOnTop = true
            esp.Adornee = v
            esp.Parent = v

            local text = Instance.new("TextLabel")
            text.Name = "HintText"
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.Text = "Hint"
            text.TextColor3 = Color3.new(1, 1, 1)
            text.TextStrokeTransparency = 0
            text.TextStrokeColor3 = Color3.new(0, 0, 0)
            text.TextSize = 18
            text.Font = Enum.Font.GothamBold
            text.Parent = esp

            esp.Enabled = ENABLED

            v.AncestryChanged:Connect(function()
                if not v:IsDescendantOf(game) then
                    esp:Destroy()
                    guis[v] = nil
                end
            end)

            guis[v] = esp
        end
    end
end

local HintTab = Window:TreeNode({
    Title = "Hint ESP",
    Collapsed = false
})

ConfigHandler:AddElement("HintESPEnabled", HintTab:Checkbox({
    Label = "Enabled",
    Value = true,
    Callback = function(_, v)
        ENABLED = v
        for _, gui in pairs(guis) do
            gui.Enabled = v
        end
    end,
}))

HintTab:Button({
    Text = "Refresh ESP",
    Callback = function()
        renderHints()
    end,
})

local autoRefresh = false
local refreshThread

ConfigHandler:AddElement("HintESPAutoRefresh", HintTab:Checkbox({
    Label = "Auto Refresh (5s)",
    Value = false,
    Callback = function(_, v)
        autoRefresh = v
        if v then
            refreshThread = task.spawn(function()
                while autoRefresh do
                    task.wait(5)
                    renderHints()
                end
            end)
        else
            if refreshThread then
                task.cancel(refreshThread)
                refreshThread = nil
            end
        end
    end,
}))

hooks:Add(function()
    if refreshThread then
        task.cancel(refreshThread)
        refreshThread = nil
    end
end)


hooks:Add(function()
    for _, gui in pairs(guis) do
        gui:Destroy()
    end
    table.clear(guis)
end)

local advantageEsp = true

local advantageEsps = {}

local function advantageEspFunc(v, pos)
    if not advantageEsps[v] then
        local esp = Instance.new("Part")

        esp.Name = "AdvantageESP"
        esp.Anchored = true
        esp.Size = Vector3.new(1, 1, 1)
        esp.Transparency = 1
        esp.CanCollide = false
        esp.CFrame = CFrame.new(pos)
        esp.Parent = workspace    
        
        local gui = Instance.new("BillboardGui")
        gui.Name = "AdvantageGui"
        gui.Size = UDim2.new(0, 100, 0, 50)
        gui.StudsOffset = Vector3.new(0, 3, 0)
        gui.AlwaysOnTop = true
        gui.Adornee = esp
        gui.Parent = esp
        
        local text = Instance.new("TextLabel")
        text.Name = "AdvantageText"
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = "Advantage"
        text.TextColor3 = Color3.new(0.082352, 1, 0)
        text.TextStrokeTransparency = 0
        text.TextStrokeColor3 = Color3.new(0, 0, 0)
        text.TextSize = 18
        text.Font = Enum.Font.GothamBold
        text.Parent = gui

        gui.Enabled = advantageEsp
        
        advantageEsps[v] = {esp, gui}

        v.AncestryChanged:Connect(function()
            if not v:IsDescendantOf(game) then
                if advantageEsps[v] then
                    advantageEsps[v][1]:Destroy()
                    advantageEsps[v][2]:Destroy()
                    advantageEsps[v] = nil
                end
            end
        end)
    end
end

local old; old = hookmetamethod(game, "__newindex", newcclosure(function(self, i, v, ...)
    if not checkcaller() and advantageEsp and typeof(self) == "Instance" and self.Name == "Arrow" and self.Parent and self.Parent.Name == "Compass" then
        local func = debug.info(3, "f")
        local upvalues = debug.getupvalues(func)
        for _, v in upvalues do
            if typeof(v) == "Vector3" then
                advantageEspFunc(self, v)
            end
        end
    end
    return old(self, i, v, ...)
end))

local AdvantageTab = Window:TreeNode({
    Title = "Advantage ESP",
    Collapsed = false
})

ConfigHandler:AddElement("AdvantageESPEnabled", AdvantageTab:Checkbox({
    Label = "Enabled",
    Value = true,
    Callback = function(_, v)
        advantageEsp = v
        for _, gui in pairs(advantageEsps) do
            gui[2].Enabled = v
        end
    end,
}))

hooks:Add(function()
    for _, gui in pairs(advantageEsps) do
        gui[1]:Destroy()
        gui[2]:Destroy()
    end
    table.clear(advantageEsps)
end)


OutlasterRaper:Finalize()
return true