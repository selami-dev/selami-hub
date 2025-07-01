--[[
    Selami Hub - Universal Script
    Only for selamists.. ⛺
]]

--print("Selami Hub Universal script loaded!")

-- Your universal script features will go here

    if not SELAMI_HUB then
        return false, "Wtf"
    end

    if not SELAMI_HUB.Key or type(SELAMI_HUB.Key) ~= "string" or SELAMI_HUB.Key ~= "LexinKocaMemeleri" then
        return false, "Invalid Key"
    end

    local BaseScript = SELAMI_HUB.ModuleLoader:LoadFromPath("Base.lua").new("Universal")
    
    local UniversalTab = BaseScript.window:CreateTab({
        Name = "🌐 Universal",
        Visible = true
    })

    local DebugHeader = UniversalTab:CollapsingHeader({
        Title = "🐍 Debug",
        Collapsed = true,
    })

    DebugHeader:Button({
        Text = "Hydroxide",
        Callback = function()
            local owner = "Upbolt"
            local branch = "revision"

            local function webImport(file)
                return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
            end

            webImport("init")
            webImport("ui/main")
            BaseScript:Notify("🐍 Debug", "Hydroxide loaded successfully!", 3, true)
        end,
    })

    local CommandBarsHeader = UniversalTab:CollapsingHeader({
        Title = "💻 Command Bars",
        Collapsed = true,
    })

    CommandBarsHeader:Button({
        Text = "Infinite Yield",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
            BaseScript:Notify("💻 Command Bars", "Infinite Yield loaded successfully!", 3, true)
        end,
    })

    BaseScript:Finalize()
    return true