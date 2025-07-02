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

local BaseScript = SELAMI_HUB.ModuleLoader:LoadFromPath("Base.lua").new("Test")
local ElementSearcher = SELAMI_HUB.ModuleLoader:LoadFromPath("Util/ElementSearcher.lua")

local TestTab = BaseScript.window:CreateTab({
	Name = "❓ Test",
	Visible = true,
})

local ElementSearcher = ElementSearcher.new(TestTab)

local checkbox = TestTab:Checkbox({
	Label = "Test",
	Value = false,
	Callback = function(self, Value)
		print(Value)
	end,
})

ElementSearcher:AddElement({
	Element = checkbox,
	Name = "Test",
	ElementClassName = "Checkbox",
	SearchIndexes = { "Test", "Checkbox", "Toggle" },
})

local button = TestTab:Button({
	Label = "Test",
	Callback = function(self)
		print("Test")
	end,
})

ElementSearcher:AddElement({
	Element = button,
	Name = "Test",
	ElementClassName = "Button",
	SearchIndexes = { "Test", "Button", "Click" },
})

local slider = TestTab:SliderInt({
	Label = "Test",
	Value = 0,
	Min = 0,
	Max = 100,
	Callback = function(self, Value)
		print(Value)
	end,
})

ElementSearcher:AddElement({
	Element = slider,
	Name = "Test",
	ElementClassName = "SliderInt",
	SearchIndexes = { "Test", "Slider", "Int", "Number" },
})

BaseScript:Finalize()
return true
