--[[
    Selami Hub Loader
    Only for selamists.. ⛺

    local Args = {
        Key = "LexinKocaMemeleri",
        ForceUniversal = false,
    }
    
    local SelamiHub = loadstring(game:HttpGet('https://gitlab.com/selamists/selamihub/-/raw/main/build/Loader.lua'))()(Args)
]]

local function start(LAUNCH_ARGS)

    local MODULE_LOADER = loadstring(game:HttpGet("https://gitlab.com/selamists/selamihub/-/raw/main/build/Util/ModuleLoader.lua"))()

    local SELAMI_HUB = getgenv().SELAMI_HUB or {}
    getgenv().SELAMI_HUB = SELAMI_HUB
    
    SELAMI_HUB.ModuleLoader = MODULE_LOADER
    SELAMI_HUB.Key = LAUNCH_ARGS.Key

    local BaseScript, message = SELAMI_HUB.ModuleLoader:LoadFromPath("Base.lua")
    if not BaseScript then
        return game:GetService("Players").LocalPlayer:Kick(message)
    end

    local loadingNotif = BaseScript:Notify("⛪ Selami Hub Loader", "⌛ Loading (May take a while...)", nil, 7383525713)

    local TeleportHandler = SELAMI_HUB.ModuleLoader:LoadFromPath("Util/TeleportHandler/Queue.lua")
    
    local supportedGames = {
        -- [gameId] = "ScriptName",
        -- Example: [1234567890] = "AdoptMe",
    }
    
    local function addToSupportedGames(scriptName, ...)
        for _, gameId in {...} do
            supportedGames[gameId] = scriptName
        end
    end
    
    --https://apis.roblox.com/universes/v1/places/94647229517154/universe [API]
    addToSupportedGames("VolleyballLegends", 6931042565)
    addToSupportedGames("AnimeSaga", 6115988515)
    addToSupportedGames("AzureLatch", 6945584306)
    addToSupportedGames("Outlaster", 1871908106)

    -- Loading
    local function handleOutput(Success, Result)
        if not Success and Result then
            loadingNotif:Destroy()
            BaseScript:Notify("⛪ Selami Hub Loader", "⚠️❌ Failed to load script: " .. (Result), 5, 9066167010)
            --error("🛑 Failed to load script: " .. (Result or "Unknown"))
            return
        end
        return Result
    end

    -- Load Base Script
    local gameId = game.GameId
    local scriptName = supportedGames[gameId]

    if scriptName and not LAUNCH_ARGS.NoTeleportHandler then
        TeleportHandler(scriptName, "https://gitlab.com/selamists/selamihub/-/raw/main/build/Loader.lua", LAUNCH_ARGS)
    end

    local function loadScript(path)
        local Success, Result = SELAMI_HUB.ModuleLoader:LoadFromPath(path)
        handleOutput(Success, Result)
        return Success, Result
    end

    if not game:IsLoaded() then
        --print("Waiting for game to load")
        game.Loaded:Wait()
    end

    if LAUNCH_ARGS.TestMode then
        loadScript("Test.lua")
        return
    end

    if scriptName then
        --print("Loading specific game script")
        -- Load specific game script
        local success = loadScript("Games/" .. scriptName .. "/Init.lua")
        if not success then
            return
        end
    end

    if not scriptName or LAUNCH_ARGS.ForceUniversal then
        --print("Loading universal script")
        -- Load Universal Script
        loadScript("Universal.lua")
    end

    loadingNotif:Destroy()
    BaseScript:Notify("⛪ Selami Hub Loader", "✅ Successfully loaded Selami Hub 🤑💸", 5, 8400923343)
end

return start