local ui = loadstring(game:HttpGet("https://pastebin.com/raw/wk7ZrGyr"))()

local win = ui:Create({
    Name = "Celeron's GUI (Azure Latch)",
    ThemeColor = Color3.fromRGB(100, 85, 174),
    StartupSound = "rbxassetid://6958727243",
    ThemeFont = Enum.Font.FredokaOne
})

local maintab = win:Tab("Main (Blatant)")
local maintab2 = win:Tab("Main (Silent)")
local misctab = win:Tab("Others")
local funtab = win:Tab("Movesets")
local helptab = win:Tab("Info")

maintab:Label("Script Made By Celeron + Daffy!")
funtab:Label("Custom Movesets, Not Actual Unlocks!")
helptab:Label("GUI Controls Are Below, Script Credits Are At The Bottom!")
helptab:Label("Show / Hide GUI: Right Alt")

maintab:Button("Metavision", function()
loadstring(game:HttpGet("https://pastebin.com/raw/FVgs7bQw"))()
end)

maintab:Button("Auto-Goal", function()
    _G.AUTO_GOAL = not _G.AUTO_GOAL
    if _G.AUTO_GOAL then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Farm Goals",
            Text = "Activated!",
            Duration = 5
        })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/lnwskibidi/Roblox/main/AzureLatch.lua"))()
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Farm Goals",
            Text = "Deactivated!",
            Duration = 5
        })
    end
end)

maintab:Button("Always Ball", function()
    _G.ALWAYS_BALL_ACTIVE = not _G.ALWAYS_BALL_ACTIVE
    if _G.ALWAYS_BALL_ACTIVE then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Always Ball",
            Text = "Activated!",
            Duration = 5
        })

        workspace.Gravity = 0

        spawn(function()
            while _G.ALWAYS_BALL_ACTIVE do
                local LocalCharacter = game.Players.LocalPlayer.Character
                local LocalHumanoidRootPart = LocalCharacter and LocalCharacter:FindFirstChild("HumanoidRootPart")
                local Football = workspace.Terrain:FindFirstChild("Ball")
                
                if LocalHumanoidRootPart and Football then
                    LocalHumanoidRootPart.CFrame = CFrame.new(Football.Position.X, Football.Position.Y, Football.Position.Z)
                end

                for _, OtherPlayer in pairs(game.Players:GetPlayers()) do
                    if OtherPlayer.Name ~= game.Players.LocalPlayer.Name then
                        local OtherCharacter = OtherPlayer.Character
                        local OtherFootball = OtherCharacter and OtherCharacter:FindFirstChild("Ball")
                        local OtherHumanoidRootPart = OtherCharacter and OtherCharacter:FindFirstChild("HumanoidRootPart")

                        if OtherFootball and OtherHumanoidRootPart and LocalHumanoidRootPart then
                            LocalHumanoidRootPart.CFrame = OtherFootball.CFrame
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                        end
                    end
                end
                
                wait(0.1)
            end
        end)
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Always Ball",
            Text = "Deactivated!",
            Duration = 5
        })

        workspace.Gravity = 196.2
    end
end)

maintab:Button("Obtain Flow (req. Ball)", function()
    local plr = game.Players.LocalPlayer
    local vim = game:GetService("VirtualInputManager")

    for j = 1, 3 do
        if plr.Team == game.Teams:FindFirstChild("A") then
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(-514, 3, 1709) * CFrame.Angles(0, math.rad(180), 0)
            vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            wait(0.1)
            vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            task.wait(0.1)

            for i = 1, 7 do
                plr.Character.HumanoidRootPart.Position = Vector3.new(-536, 3, 1686)
                task.wait(0.1)
            end
        elseif plr.Team == game.Teams:FindFirstChild("B") then
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(-557, 3, 840) 
            vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            wait(0.1)
            vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            task.wait(0.3)

            for i = 1, 7 do
                plr.Character.HumanoidRootPart.Position = Vector3.new(-536, 3, 864)
                task.wait(0.1)
            end
        end
        task.wait(0.65)
    end
end)

maintab2:Button("Auto-Dribble", function()
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local ANIMATION_ID = "rbxassetid://109744655458082"

_G.toggleDetection = not (_G.toggleDetection or false)

StarterGui:SetCore("SendNotification", {
    Title = "Auto-Dribble",
    Text = _G.toggleDetection and "Enabled." or "Disabled.",
    Duration = 3
})

local function checkNearbyPlayers()
    if not _G.toggleDetection then return end

    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= player and target.Character and target.Team ~= player.Team then
            local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = target.Character:FindFirstChild("Humanoid")
            local targetAnimator = targetHumanoid and targetHumanoid:FindFirstChildOfClass("Animator")

            if targetHRP and targetAnimator then
                local distance = (humanoidRootPart.Position - targetHRP.Position).Magnitude

                if distance <= 35 then
                    local playingTracks = targetAnimator:GetPlayingAnimationTracks()
                    for _, track in ipairs(playingTracks) do
                        if track.Animation.AnimationId == ANIMATION_ID then
                            local drib = {
                                buffer.fromstring("\024\001"),
                                {{"dribble", false}}
                            }
                            ReplicatedStorage:WaitForChild("ByteNetReliable"):FireServer(unpack(drib))
                        end
                    end
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(checkNearbyPlayers)
end)

maintab2:Button("Auto Fake Volley (Nagi)", function()
    local Players = game:GetService("Players")
    local StarterGui = game:GetService("StarterGui")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    local STEAL_DISTANCE = {
        ["rbxassetid://86531017806623"] = 25,
        ["rbxassetid://109744655458082"] = 35
    }

    _G.toggleCounter = not _G.toggleCounter

    StarterGui:SetCore("SendNotification", {
        Title = "Auto-Counter",
        Text = _G.toggleCounter and "Enabled." or "Disabled.",
        Duration = 3
    })

    local function checkNearbyPlayers()
        if not _G.toggleCounter then return end

        local myHRP = character and character:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end

        for _, target in ipairs(Players:GetPlayers()) do
            if target ~= player and target.Character and target.Team ~= player.Team then
                local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = target.Character:FindFirstChild("Humanoid")
                local targetAnimator = targetHumanoid and targetHumanoid:FindFirstChildOfClass("Animator")

                if targetHRP and targetAnimator then
                    local distance = (myHRP.Position - targetHRP.Position).Magnitude

                    for animationId, detectionRange in pairs(STEAL_DISTANCE) do
                        if distance <= detectionRange then
                            for _, track in ipairs(targetAnimator:GetPlayingAnimationTracks()) do
                                if track.Animation.AnimationId == animationId then
                                    local args = {
                                        buffer.fromstring("\024\001"),
                                        {
                                            {
                                                "skill"
                                            }
                                        }
                                    }
                                    ReplicatedStorage:WaitForChild("ByteNetReliable"):FireServer(unpack(args))
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    RunService.RenderStepped:Connect(checkNearbyPlayers)
end)

maintab2:Button("Auto Counter (Kaiser)", function()
    local Players = game:GetService("Players")
    local StarterGui = game:GetService("StarterGui")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    local STEAL_DISTANCE = {
        ["rbxassetid://86531017806623"] = 25,
        ["rbxassetid://109744655458082"] = 35
    }

    _G.toggleCounter = not _G.toggleCounter

    StarterGui:SetCore("SendNotification", {
        Title = "Auto-Counter",
        Text = _G.toggleCounter and "Enabled." or "Disabled.",
        Duration = 3
    })

    local function checkNearbyPlayers()
        if not _G.toggleCounter then return end

        local myHRP = character and character:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end

        for _, target in ipairs(Players:GetPlayers()) do
            if target ~= player and target.Character and target.Team ~= player.Team then
                local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = target.Character:FindFirstChild("Humanoid")
                local targetAnimator = targetHumanoid and targetHumanoid:FindFirstChildOfClass("Animator")

                if targetHRP and targetAnimator then
                    local distance = (myHRP.Position - targetHRP.Position).Magnitude

                    for animationId, detectionRange in pairs(STEAL_DISTANCE) do
                        if distance <= detectionRange then
                            for _, track in ipairs(targetAnimator:GetPlayingAnimationTracks()) do
                                if track.Animation.AnimationId == animationId then
                                    local args = {
                                        buffer.fromstring("\024\001"),
                                        {
                                            {
                                                "skill4"
                                            }
                                        }
                                    }
                                    ReplicatedStorage:WaitForChild("ByteNetReliable"):FireServer(unpack(args))
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    RunService.RenderStepped:Connect(checkNearbyPlayers)
end)

maintab2:Button("Auto Nutmeg (Sae)", function()
    local Players = game:GetService("Players")
    local StarterGui = game:GetService("StarterGui")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    local STEAL_DISTANCE = {
        ["rbxassetid://86531017806623"] = 25,
        ["rbxassetid://109744655458082"] = 35
    }

    _G.toggleNutmeg = not _G.toggleNutmeg

    StarterGui:SetCore("SendNotification", {
        Title = "Auto-Nutmeg",
        Text = _G.toggleNutmeg and "Enabled." or "Disabled.",
        Duration = 3
    })

    local function checkNearbyPlayers()
        if not _G.toggleNutmeg then return end

        local myHRP = character and character:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end

        for _, target in ipairs(Players:GetPlayers()) do
            if target ~= player and target.Character and target.Team ~= player.Team then
                local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = target.Character:FindFirstChild("Humanoid")
                local targetAnimator = targetHumanoid and targetHumanoid:FindFirstChildOfClass("Animator")

                if targetHRP and targetAnimator then
                    local distance = (myHRP.Position - targetHRP.Position).Magnitude

                    for animationId, detectionRange in pairs(STEAL_DISTANCE) do
                        if distance <= detectionRange then
                            for _, track in ipairs(targetAnimator:GetPlayingAnimationTracks()) do
                                if track.Animation.AnimationId == animationId then
                                    local args = {
                                        buffer.fromstring("\024\001"),
                                        {
                                            {
                                                "skill2"
                                            }
                                        }
                                    }
                                    ReplicatedStorage:WaitForChild("ByteNetReliable"):FireServer(unpack(args))
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    RunService.RenderStepped:Connect(checkNearbyPlayers)
end)

maintab:Button("Hide Ace Eater", function()
local char = game.Players.LocalPlayer.Character
local ogAnim = char.Animate.idle.Animation1.AnimationId

local UserInputService = game:GetService("UserInputService")
local starterGui = game:GetService("StarterGui")

_G.HideAce = not _G.HideAce

local function sendNotification(status)
    starterGui:SetCore("SendNotification", {
        Title = "Hide Ace Toggle",
        Text = status,
        Duration = 3
    })
end

function onKeyPress(inputObject, gameProcessedEvent)
    if not gameProcessedEvent and _G.HideAce then
        if inputObject.KeyCode == Enum.KeyCode.Five and game.Players.LocalPlayer:GetAttribute("style") == "donlorenzo" then 
            task.wait(0.1)
            for _, track in ipairs(char.Humanoid:GetPlayingAnimationTracks()) do
                if track.Animation.AnimationId == "rbxassetid://108103339994438" then
                    track:Stop()
                    break
                end
            end
        end
    end
end

UserInputService.InputBegan:Connect(onKeyPress)

sendNotification(_G.HideAce and "Enabled." or "Disabled.")
end)

maintab:Button("Team Goal (YOUR GOAL)", function()
local plr = game.Players.LocalPlayer
				if plr.Team == game.Teams:FindFirstChild("A") then
					plr.Character.HumanoidRootPart.Position = Vector3.new(-538, 3, 1603)
				elseif plr.Team == game.Teams:FindFirstChild("B") then
					plr.Character.HumanoidRootPart.Position = Vector3.new(-535, 3, 946)
				end
end)

maintab:Button("Auto QuickTimeEvent", function()
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local virtualInputManager = game:GetService("VirtualInputManager")
local starterGui = game:GetService("StarterGui")
local player = players.LocalPlayer

_G.QuickTimeEvent = not _G.QuickTimeEvent

local function sendNotification(status)
    starterGui:SetCore("SendNotification", {
        Title = "QuickTimeEvent",
        Text = status,
        Duration = 3
    })
end

local function getAllTextLabels(parent)
    local textLabels = {}
    for _, descendant in ipairs(parent:GetDescendants()) do
        if descendant:IsA("TextLabel") then
            table.insert(textLabels, descendant)
        end
    end
    return textLabels
end

local function convertNumberToKeyText(text)
    local numberMap = {
        ["1"] = "One",
        ["2"] = "Two",
        ["3"] = "Three",
        ["4"] = "Four",
        ["5"] = "Five",
        ["6"] = "Six",
        ["7"] = "Seven",
        ["8"] = "Eight",
        ["9"] = "Nine",
        ["0"] = "Zero"
    }
    return numberMap[text] or text
end

local function checkQTE()
    if _G.QuickTimeEvent and player and player:FindFirstChild("PlayerGui") then
        local qteGui = player.PlayerGui:FindFirstChild("Qte")

        if qteGui and qteGui:FindFirstChild("QTE") and qteGui.QTE:FindFirstChild("Frame") then
            local qteFrame = qteGui.QTE.Frame

            if qteFrame.Size.X.Scale <= 0.740000169 and qteFrame.Size.X.Scale >= 0.720000019 and
               qteFrame.Size.Y.Scale <= 0.74999999 and qteFrame.Size.Y.Scale >= 0.720000019 then

                local textLabels = getAllTextLabels(qteGui.QTE)
                
                for _, label in ipairs(textLabels) do
                    local keyText = convertNumberToKeyText(label.Text)
                    local keyToPress = Enum.KeyCode[keyText]

                    if keyToPress then
                        virtualInputManager:SendKeyEvent(true, keyToPress, false, game)
                        virtualInputManager:SendKeyEvent(false, keyToPress, false, game)
                    end
                end
            end
        end
    end
end

runService.RenderStepped:Connect(checkQTE)

sendNotification(_G.QuickTimeEvent and "Enabled." or "Disabled.")
end)

maintab:Button("No Rush Cooldown", function()
    local userInputService = game:GetService("UserInputService")
    local runService = game:GetService("RunService")
    local starterGui = game:GetService("StarterGui")
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    _G.ForwardRushEnabled = not _G.ForwardRushEnabled

    starterGui:SetCore("SendNotification", {
        Title = "No Rush CD",
        Text = _G.ForwardRushEnabled and "Enabled." or "Disabled.",
        Duration = 2
    })

    local function forwardRush()
        if humanoid and rootPart and _G.ForwardRushEnabled then
            local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://79394729551302"
            local animationTrack = animator:LoadAnimation(animation)
            animationTrack:Play()

            local rushTime = 0.4
            local rushDistance = 45
            local elapsedTime = 0
            local startPosition = rootPart.Position
            local targetPosition = startPosition + rootPart.CFrame.LookVector * rushDistance

            runService:BindToRenderStep("ForwardRush", Enum.RenderPriority.Character.Value, function(dt)
                elapsedTime = elapsedTime + dt
                local alpha = math.clamp(elapsedTime / rushTime, 0, 1)
                rootPart.CFrame = CFrame.new(startPosition:Lerp(targetPosition, alpha))
                
                if alpha >= 1 then
                    runService:UnbindFromRenderStep("ForwardRush")
                end
            end)
        end
    end

    userInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.F and _G.ForwardRushEnabled then
            forwardRush()
            local SoundService = game:GetService("SoundService")
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://105267293181745"
            sound.Parent = SoundService
            sound.Looped = false
            sound:Play()
        end
    end)
end)

maintab:Button("No Side Dash Cooldown", function()
    local userInputService = game:GetService("UserInputService")
    local runService = game:GetService("RunService")
    local starterGui = game:GetService("StarterGui")
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    _G.SideDashEnabled = not _G.SideDashEnabled

    starterGui:SetCore("SendNotification", {
        Title = "No Side Dash CD",
        Text = _G.SideDashEnabled and "Enabled." or "Disabled.",
        Duration = 2
    })

    local function playDashSound()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://71212694698006"
        sound.Parent = rootPart
        sound.Looped = false
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
    end

    local function sideDash(direction)
        if humanoid and rootPart and _G.SideDashEnabled then
            local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
            local animation = Instance.new("Animation")
            animation.AnimationId = direction == "right" and "rbxassetid://114016332539655" or "rbxassetid://100207093237932"

            local animationTrack = animator:LoadAnimation(animation)
            animationTrack:Play()
            playDashSound()

            local sideOffset = rootPart.CFrame.RightVector * (direction == "right" and 19 or -19)
            local targetPosition = rootPart.Position + sideOffset
            local duration = 0.4
            local elapsed = 0

            runService:BindToRenderStep("SideDash", Enum.RenderPriority.Character.Value, function(dt)
                elapsed = elapsed + dt
                local alpha = math.clamp(elapsed / duration, 0, 1)
                rootPart.CFrame = CFrame.new(rootPart.Position:Lerp(targetPosition, alpha))
                
                if alpha >= 1 then
                    runService:UnbindFromRenderStep("SideDash")
                end
            end)
        end
    end

    userInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.Q then
            local isAHeld = userInputService:IsKeyDown(Enum.KeyCode.A)
            local isDHeld = userInputService:IsKeyDown(Enum.KeyCode.D)

            if isDHeld then
                sideDash("right")
            elseif isAHeld then
                sideDash("left")
            end
        end
    end)
end)

local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")

local isClicking = false
local isEnabled = false

local function preloadAssets()
    local assetsToPreload = {}
    ContentProvider:PreloadAsync(assetsToPreload)
end

local function emulateClickAtMousePosition()
    local mouseLocation = UserInputService:GetMouseLocation()
    local x, y = mouseLocation.X, mouseLocation.Y
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
end

local function teleportToBall()
    local player = Players.LocalPlayer
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    local football = workspace.Terrain:FindFirstChild("Ball")

    if humanoidRootPart and football then
        humanoidRootPart.CFrame = CFrame.new(football.Position)
    end

    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer.Name ~= player.Name then
            local otherCharacter = otherPlayer.Character
            local otherFootball = otherCharacter and otherCharacter:FindFirstChild("Ball")
            local otherHumanoidRootPart = otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart")

            if otherFootball and otherHumanoidRootPart and humanoidRootPart then
                humanoidRootPart.CFrame = otherFootball.CFrame
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
            end
        end
    end
end

maintab2:Button("Get Center-Field", function()
local args = {
    buffer.fromstring("\013\001\001\000B")
}
game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(unpack(args))

local args = {
    buffer.fromstring("\013\001\001\000B")
}
game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(unpack(args)) 
end)

maintab2:Button("Get Goalie", function()
local args = {
    buffer.fromstring("\013\005\001\000B")
}
game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(unpack(args))

local args = {
    buffer.fromstring("\013\005\001\000A")
}
game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(unpack(args)) 
end)

maintab:Button("Steal Ball", function()
    local Players = game:GetService("Players")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local LocalPlayer = Players.LocalPlayer

    local function HasBall()
        local LocalCharacter = LocalPlayer.Character
        local Football = LocalCharacter and LocalCharacter:FindFirstChild("Ball")
        return Football ~= nil
    end

    local function StealBall()
        while not HasBall() do
            local LocalCharacter = LocalPlayer.Character
            local LocalHumanoidRootPart = LocalCharacter and LocalCharacter:FindFirstChild("HumanoidRootPart")
            local Football = workspace.Terrain:FindFirstChild("Ball")

            if LocalHumanoidRootPart and Football then
                LocalHumanoidRootPart.CFrame = CFrame.new(Football.Position.X, Football.Position.Y, Football.Position.Z)
            end

            for _, OtherPlayer in pairs(Players:GetPlayers()) do
                if OtherPlayer.Name ~= LocalPlayer.Name then
                    local OtherCharacter = OtherPlayer.Character
                    local OtherFootball = OtherCharacter and OtherCharacter:FindFirstChild("Ball")
                    local OtherHumanoidRootPart = OtherCharacter and OtherCharacter:FindFirstChild("HumanoidRootPart")

                    if OtherFootball and OtherHumanoidRootPart and LocalHumanoidRootPart then
                        LocalHumanoidRootPart.CFrame = OtherFootball.CFrame
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                    end
                end
            end
            wait(0.2)
        end
    end

    StealBall()
end)

maintab:Button("Bring Ball", function()
    local LocalPlayer = game.Players.LocalPlayer
    local function HasBall()
        local LocalCharacter = LocalPlayer.Character
        local Football = LocalCharacter and LocalCharacter:FindFirstChild("Ball")
        return Football ~= nil
    end

    local function StealBall()
        while not HasBall() do
            local LocalCharacter = LocalPlayer.Character
            local LocalHumanoidRootPart = LocalCharacter and LocalCharacter:FindFirstChild("HumanoidRootPart")
            local Football = workspace.Terrain:FindFirstChild("Ball")

            if LocalHumanoidRootPart and Football then
                LocalHumanoidRootPart.CFrame = CFrame.new(Football.Position.X, Football.Position.Y, Football.Position.Z)
            end

            for _, OtherPlayer in pairs(game.Players:GetPlayers()) do
                if OtherPlayer.Name ~= LocalPlayer.Name then
                    local OtherCharacter = OtherPlayer.Character
                    local OtherFootball = OtherCharacter and OtherCharacter:FindFirstChild("Ball")
                    local OtherHumanoidRootPart = OtherCharacter and OtherCharacter:FindFirstChild("HumanoidRootPart")

                    if OtherFootball and OtherHumanoidRootPart and LocalHumanoidRootPart then
                        LocalHumanoidRootPart.CFrame = OtherFootball.CFrame
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                    end
                end
            end
            wait(0.2)
        end
    end

    spawn(function()
        local LocalCharacter = LocalPlayer.Character
        local LocalHumanoidRootPart = LocalCharacter and LocalCharacter:FindFirstChild("HumanoidRootPart")
        local Football = workspace.Terrain:FindFirstChild("Ball")

        if LocalHumanoidRootPart and Football then
            local originalPosition = LocalHumanoidRootPart.CFrame
            LocalHumanoidRootPart.CFrame = CFrame.new(Football.Position)
            StealBall()
            wait(0.3)
            LocalHumanoidRootPart.CFrame = originalPosition
        end
    end)
end)

maintab:Button("Manual Score", function()
    local coordinateA = Vector3.new(-552, 3, 1730)
    local coordinateB = Vector3.new(-549, 3, 818)

    local function teleportToPosition(position)
        local LocalCharacter = game.Players.LocalPlayer.Character
        local LocalHumanoidRootPart = LocalCharacter and LocalCharacter:FindFirstChild("HumanoidRootPart")

        if LocalHumanoidRootPart then
            LocalHumanoidRootPart.CFrame = CFrame.new(position)
        end
    end

    local function checkTeamAndTeleport()
        local teamName = game.Players.LocalPlayer.Team and game.Players.LocalPlayer.Team.Name

        if teamName == "A" then
            teleportToPosition(coordinateB)
        elseif teamName == "B" then
            teleportToPosition(coordinateA)
        end
    end

    checkTeamAndTeleport()
end)

maintab:Button("Break Ball (Req. Ball)", function()
    local baseplatePosition = Vector3.new(-190, 14864566, 492)
    local partSize = Vector3.new(10, 1, 10)
    local gap = 0

    for x = 0, 2 do
        for z = 0, 2 do
            local part = Instance.new("Part")
            part.Size = partSize
            part.Anchored = true
            part.Position = baseplatePosition + Vector3.new(x * (partSize.X + gap), 0, z * (partSize.Z + gap))
            part.Parent = workspace
        end
    end

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    character:WaitForChild("HumanoidRootPart").CFrame =
        CFrame.new(baseplatePosition + Vector3.new(0, 100000000000000, 0))
end)

maintab:Button("Barou Devour Goal", function()
local plr = game.Players.LocalPlayer

			local function countEnimTeamMembers()
				local op = game.Teams:FindFirstChild("A")
				if plr.Team == game.Teams:FindFirstChild("A") then
					op = game.Teams:FindFirstChild("B")
				end
				local count = 0
				for _, player in ipairs(game.Players:GetPlayers()) do
					if player.Team == op then
						count += 1
					end
				end
				return count
			end
			
			local function getTwoRandomEnemies()
				local enemies = {}
				local op = game.Teams:FindFirstChild("A")
				if plr.Team == game.Teams:FindFirstChild("A") then
					op = game.Teams:FindFirstChild("B")
				end
				
				for _, player in ipairs(game.Players:GetPlayers()) do
					if player ~= plr and player.Team == op then
						table.insert(enemies, player)
					end
				end
				
				for i = #enemies, 2, -1 do
					local j = math.random(1, i)
					enemies[i], enemies[j] = enemies[j], enemies[i]
				end

				return enemies[1], enemies[2]
			end
			
			if countEnimTeamMembers() >= 2 then
				local p1, p2 = getTwoRandomEnemies()
				if not p1 or not p2 then return end
				
				local op = game.Teams:FindFirstChild("A")
				if plr.Team == game.Teams:FindFirstChild("A") then
					op = game.Teams:FindFirstChild("B")
				end

				local function tpToPlayer(targetPlayer)
					local char = plr.Character or plr.CharacterAdded:Wait()
					local root = char:WaitForChild("HumanoidRootPart")
					local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")

					if root and targetRoot then
						root.CFrame = targetRoot.CFrame
					end
				end

				tpToPlayer(p1)
				task.wait(0.3)
				tpToPlayer(p2)
				
				wait(0.3)
				
				if plr.Team == game.Teams:FindFirstChild("A") then
					plr.Character.HumanoidRootPart.Position = Vector3.new(-625, 3, 925)
				elseif plr.Team == game.Teams:FindFirstChild("B") then
					plr.Character.HumanoidRootPart.Position = Vector3.new(-588, 3, 1643)
				end
			end
end)

maintab:Button("Nagi Dream Goal", function()
local plr = game.Players.LocalPlayer
if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
    local hrp = plr.Character.HumanoidRootPart
    
    if plr.Team == game.Teams:FindFirstChild("A") then
        hrp.CFrame = CFrame.new(-459, 3, 862)
    elseif plr.Team == game.Teams:FindFirstChild("B") then
        hrp.CFrame = CFrame.new(-611, 3, 1682) * CFrame.Angles(0, math.rad(180), 0)
    end
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
    plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
    wait(0.2)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
end
end)

maintab:Button("Isagi U-20 Goal", function()
local plr = game.Players.LocalPlayer
				if plr.Team == game.Teams:FindFirstChild("A") then
					plr.Character.HumanoidRootPart.Position = Vector3.new(-539, 3, 996)
				elseif plr.Team == game.Teams:FindFirstChild("B") then
					plr.Character.HumanoidRootPart.Position = Vector3.new(-537, 3, 1557)
				end
				wait(0.5)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Three, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Three, false, game)
end)

maintab:Button("Shidou Back-Heel Goal", function()
local plr = game.Players.LocalPlayer
				if plr.Team == game.Teams:FindFirstChild("A") then
					plr.Character.HumanoidRootPart.Position = Vector3.new(-625, 3, 925)
				elseif plr.Team == game.Teams:FindFirstChild("B") then
					plr.Character.HumanoidRootPart.Position = Vector3.new(-588, 3, 1643)
				end
				wait(0.25)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
			end)

maintab2:Textbox("Character Picker", function(v)

local validNames = {
    ["rin"] = "\019\003\000rin",
    ["aiku"] = "\019\004\000aiku",
    ["barou"] = "\019\005\000barou",
    ["sae"] = "\019\003\000sae",
    ["kaiser"] = "\019\006\000kaiser",
    ["don"] = "\019\010\000donlorenzo",
    ["nagi"] = "\019\004\000nagi",
    ["shidou"] = "\019\006\000shidou",
    ["isagi"] = "\019\005\000isagi"
}

local function checkAndFire(v)
    local match = validNames[v]
    if match then
        local args = { buffer.fromstring(match) }
        game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(unpack(args))
        print("Fired event for:", v)
    else
        print("No match found for:", v)
    end
end

checkAndFire(v)
end)

funtab:Button("Don Lorenzo (Nagi)", function()
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Credits",
    Text = "brought to you by celeron!",
    Duration = 5,
    Button1 = "OK",
})
local plr = game.Players.LocalPlayer
local char = plr.Character
local hum = char.Humanoid
local root = char.HumanoidRootPart
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")


local skill1Anim = Instance.new("Animation")
skill1Anim.AnimationId = "rbxassetid://102294508090597"
local s1db = false
local dribble = hum:LoadAnimation(skill1Anim)
dribble.Priority = Enum.AnimationPriority.Action2


local skill2Anim = Instance.new("Animation")
skill2Anim.AnimationId = "rbxassetid://90734196141468"
local s2db = false
local controlJump = hum:LoadAnimation(skill2Anim)
controlJump.Priority = Enum.AnimationPriority.Action2

local skill2AnimVAR = Instance.new("Animation")
skill2AnimVAR.AnimationId = "rbxassetid://82371642989185"
local s2dbVar = false
local controlLand = hum:LoadAnimation(skill2AnimVAR)
controlLand.Priority = Enum.AnimationPriority.Action3

local skill3Anim = Instance.new("Animation")
skill3Anim.AnimationId = "rbxassetid://85862104307480"
local s3db = false
local pass = hum:LoadAnimation(skill3Anim)
pass.Priority = Enum.AnimationPriority.Action2


local function haveBall()
	local Football = char and char:FindFirstChild("Ball")
	return Football ~= nil
end

function onKeyPress(inputObject, gameProcessedEvent)
	if not gameProcessedEvent then
		if inputObject.KeyCode == Enum.KeyCode.One then
			
			if not haveBall() then return end
			if s1db == false then
				s1db = true
				
				dribble:Play()
				local vel = Instance.new("BodyVelocity")
				vel.MaxForce = Vector3.new(1,0,1) * 30000
				vel.Name = "BodyVelocity" .. math.random(1,99999)
				vel.Velocity = root.CFrame.LookVector * 40
				vel.Parent = root
				game.Debris:AddItem(vel, 2.4)
				local sfx = game.ReplicatedStorage.Resources.donlorenzo.dribbletest:Clone()
				sfx.Parent = root
				sfx:Play()
				game.Debris:AddItem(sfx, 2.5)
				for _, v in pairs (game.ReplicatedStorage.Resources.donlorenzo.skill1movingpart:GetDescendants()) do
					if v.Name == "b" or v.Name == "p" then
						local new = v:Clone()
						new.Parent = root
						new.Enabled = true
						game.Debris:AddItem(new, 2.5)
					end
				end
				for _, v in pairs (char:GetChildren()) do
					if v.Name == "Torso" or v.Name == "Right Leg" or v.Name == "Right Arm" or v.Name == "Left Leg" or v.Name == "Left Arm" or v.Name == "Head" then
						for _, g in pairs (game.ReplicatedStorage.Resources.donlorenzo.ult4aura:GetChildren()) do
							if g.Name == "Fire" or g.Name == "Fog" or g.Name == "R. C. Fire" or g.Name == "mainfire" then
								local new = g:Clone()
								new.Parent = v
								new.Enabled = true
								new.LockedToPart = true
								game.Debris:AddItem(new, 2.5)
							end
						end
					end
				end
				
				repeat
					wait()
					VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
					vel.Velocity = root.CFrame.LookVector * 40
				until not root:FindFirstChild(vel.Name)
				
				wait(21.6)
				for _, v in pairs (root:GetDescendants()) do
					if v.Name == "b" or v.Name == "p" then
						v:Destroy()
					end
				end
				s1db = false
			end
			
			
		elseif inputObject.KeyCode == Enum.KeyCode.Two then
			
			if haveBall() then return end
			if s2db == false then
				s2db = true
				controlJump:Play()
				
				local did = false
				
				for i = 1, 2, 0.1 do
					if game.Workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable then
						did = true
						break
					end
					wait(0.1)
				end
				
				if did then
					controlJump:Stop()
					controlLand:Play()
					
					local sfx = game.ReplicatedStorage.Resources.donlorenzo.ult4:Clone()
					sfx.Parent = root
					sfx:Play()
					
					for _, v in pairs (game.ReplicatedStorage.Resources.donlorenzo.ult4vfx.rootlocation.skill4ballpartflashsteps:GetChildren()) do
						local new = v:Clone()
						new.Parent = char:FindFirstChild("Ball")
						new.Enabled = true
						new.LockedToPart = true
						game.Debris:AddItem(new, 0.85)
					end
					
					for _, v in pairs (char:GetChildren()) do
						if v.Name == "Torso" or v.Name == "Right Leg" or v.Name == "Right Arm" or v.Name == "Left Leg" or v.Name == "Left Arm" or v.Name == "Head" then
							for _, g in pairs (game.ReplicatedStorage.Resources.donlorenzo.ult4aura:GetChildren()) do
								if g.Name == "Fire" or g.Name == "Fog" or g.Name == "R. C. Fire" or g.Name == "mainfire" then
									local new = g:Clone()
									new.Parent = v
									new.Enabled = true
									new.LockedToPart = true
									game.Debris:AddItem(new, 1)
								end
							end
						end
					end
					wait(0.85)
					controlLand:Stop()
				end
				
				wait(20)
				s2db = false
			end
			
		elseif inputObject.KeyCode == Enum.KeyCode.Three then
			
			if not haveBall() then return end
			if s3db == false then
				s3db = true
				pass:Play()
				local sfx = game.ReplicatedStorage.Resources.donlorenzo.skill2:Clone()
				sfx.Parent = root
				sfx:Play()
				
				for _, v in pairs (char:GetChildren()) do
					if v.Name == "Torso" or v.Name == "Right Leg" or v.Name == "Right Arm" or v.Name == "Left Leg" or v.Name == "Left Arm" or v.Name == "Head" then
						for _, g in pairs (game.ReplicatedStorage.Resources.donlorenzo.ult4aura:GetChildren()) do
							if g.Name == "Fire" or g.Name == "Fog" or g.Name == "R. C. Fire" or g.Name == "mainfire" then
								local new = g:Clone()
								new.Parent = v
								new.Enabled = true
								new.LockedToPart = true
								game.Debris:AddItem(new, 1)
							end
						end
					end
				end
				
				wait(25)
				s3db = false
			end
		
		end
	end
end
wait(1)
print("loaded don lorenzo script")
UserInputService.InputBegan:connect(onKeyPress)
end)

funtab:Button("Ronaldo (Shidou)", function()

local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Credits",
    Text = "brought to you by celeron!",
    Duration = 5,
    Button1 = "OK",
})
wait(1)
local plr = game.Players.LocalPlayer
local char = plr.Character
local hum = char.Humanoid
local root = char.HumanoidRootPart
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")


local bicycle1 = Instance.new("Animation")
bicycle1.AnimationId = "rbxassetid://126734456236034"
local bicycleDB = false
local bicycle = hum:LoadAnimation(bicycle1)
bicycle.Priority = Enum.AnimationPriority.Action2

local dribble1 = Instance.new("Animation")
dribble1.AnimationId = "rbxassetid://95054281301535"
local dribbleDB = false
local dribble = hum:LoadAnimation(dribble1)
dribble.Priority = Enum.AnimationPriority.Action2

local assets = game:GetService("ReplicatedStorage").Resources.ronaldo.bicyclekick

local function haveBall()
	local Football = char and char:FindFirstChild("Ball")
	return Football ~= nil
end

function onKeyPress(inputObject, gameProcessedEvent)
	if not gameProcessedEvent then
		if inputObject.KeyCode == Enum.KeyCode.Two then
			
			if not haveBall() then return end
			if bicycleDB == false then
				bicycleDB = true
				
				bicycle:Play()
				
				wait(0.7)
				
				local boom = assets.vfx2:Clone()
				boom.Parent = root
				boom.vfx2:FindFirstChild("RONALDO!!!!"):Emit(1)
				game.Debris:AddItem(boom, 3)
				
				wait(19)
				bicycleDB = false
			end
		end
	end
end

UserInputService.InputBegan:connect(onKeyPress)

print("loaded RONALDO SUIII script")
end)

funtab:Button("Trolling Moveset", function()
local char = game.Players.LocalPlayer.Character
local plr = game.Players.LocalPlayer
local hotbar = plr.PlayerGui.Hotbar

char.Animate.run.RunAnim.AnimationId = "rbxassetid://117921992582675"
char.Animate.walk.WalkAnim.AnimationId = "rbxassetid://117921992582675"

local flowTexts = {
    ["nagi"] = "mcdonalds application",
    ["isagi"] = "2 loving parents",
    ["sae"] = "aura farmer",
    ["rin"] = "luke warm",
    ["donlorenzo"] = "gimme... dih...",
    ["kaiser"] = "clown of isagi's story",
    ["shidou"] = "faggot",
    ["aiku"] = "dih snake",
    ["barou"] = "barou barou kun",
}

if flowTexts[plr:GetAttribute("style")] then
    hotbar.MagicHealth.TextLabel.Text = flowTexts[plr:GetAttribute("style")]
else
    hotbar.MagicHealth.TextLabel.Text = "you dont exist"
end

hotbar.MagicHealth.ModeText.Text = ""
hotbar.MagicHealth.Health.Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0) 
end)

misctab:Button("Mute Crowd (REJOIN TO FIX)", function()
while true do
wait(0.05)
game:GetService("SoundService")["football-crowd-3-69245"].Volume = 0
end
end)


misctab:Button("Middle Field", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-540, 3, 1274)
end)

misctab:Button("Gallery Area (secret)", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(109, 66, 3337)
end)

misctab:Button("Overtime Cinematics", function()
local vals = game.ReplicatedStorage.workspace
local timer = vals.timer
local ingame = vals.roundstart

local music1Isagi = game:GetService("ReplicatedStorage").Resources.isagi["isagi themeover"]
local music2Sae = game:GetService("ReplicatedStorage").Resources.sae["sae one shot match theme"]

local gui = Instance.new("ScreenGui")
gui.ScreenInsets = Enum.ScreenInsets.None
gui.Name = "overtimethang"
gui.Parent = game.Players.LocalPlayer.PlayerGui

local image = Instance.new("ImageLabel")
image.AnchorPoint = Vector2.new(0.5, 0.5)
image.Position = UDim2.new(0.5, 0,0.5, 0)
image.Size = UDim2.new(1.2, 0,1.2, 0)
image.Image = "rbxassetid://11030033771"
image.ImageTransparency = 0.8
image.BackgroundTransparency = 1
image.Parent = gui

local overtime = false

task.spawn(function()
    while wait(0.05) do
        image.Visible = overtime
        
        if overtime == true then
            if game.Workspace.CurrentCamera.CameraType == Enum.CameraType.Custom then
                game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.2), {FieldOfView = 100}):Play()
            end
            
            if image.Rotation == 0 then
                image.Rotation = 180
            else
                image.Rotation = 0
            end
        end
    end
end)

timer.Changed:Connect(function()
    if timer.Value == 0 and ingame.Value == true then
        overtime = true
        
        repeat
            music1Isagi:Play()
            for i = 1, 50 do
                task.wait(1)
                if ingame.Value == false then
                    break
                end
            end
            music2Sae:Play()
            for i = 1, 58 do
                task.wait(1)
                if ingame.Value == false then
                    break
                end
            end
        until ingame.Value == false
        
    elseif ingame.Value == false then
        
        overtime = false
        music1Isagi:Stop()
        music2Sae:Stop()
        game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.2), {FieldOfView = 70}):Play()
        
    end
end)
end)

local bgmusicdb = false
misctab:Button("Background Music", function()
    if bgmusicdb == false then
        bgmusicdb = true
        local plr = game.Players.LocalPlayer
        local char = plr.Character
        local hum = char.Humanoid

        local music = {
            "rbxassetid://126478006472705",
            "rbxassetid://138210588552041",
            "rbxassetid://137856744878500",
            "rbxassetid://97581213878614",
            "rbxassetid://71371939631022",
            "rbxassetid://119592773299545",
            "rbxassetid://134456641764445",
            "rbxassetid://100509882059819",
            "rbxassetid://128623853689708",
            "rbxassetid://70979311703713",
            "rbxassetid://92420662159372",
            "rbxassetid://97837345641106",
            "rbxassetid://102469310336986",
            "rbxassetid://101851803743361",
        }


        if game.SoundService:FindFirstChild("BGMusic") then
            game.SoundService.BGMusic:Destroy()
        end
        local sfx = Instance.new("Sound")
        sfx.Name = "BGMusic"
        sfx.Parent = game.SoundService
        sfx.SoundId = music[math.random(1, #music)]

        task.spawn(function()
            while hum do
                sfx:Play()
                wait(sfx.TimeLength)
                sfx.SoundId = music[math.random(1, #music)]
            end
        end)

        task.spawn(function()
            while hum do
                task.wait()

                if game:GetService("ReplicatedStorage").workspace.awaken.Value ~= nil then
                    sfx:Pause()
                else
                    sfx:Resume()
                end
            end
        end)

        hum.Died:Connect(function()
            sfx:Destroy()
        end)
    end
end)

misctab:Button("Infinite Yield", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

return true