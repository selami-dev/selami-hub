-->> Loadstring
--	local ConfigHandler = loadstring(game:HttpGet('https://gitlab.com/selamists/selamihub/-/raw/main/build/Util/ConfigHandler.lua'))()
local Value = SELAMI_HUB.ModuleLoader:LoadFromPath("Util/Value.lua")
local Signal = SELAMI_HUB.ModuleLoader:LoadFromPath("Util/Signal.lua")
local ElementLink = SELAMI_HUB.ModuleLoader:LoadFromPath("Util/ElementLink.lua")

local ConfigHandler = {}
ConfigHandler.__index = ConfigHandler

function ConfigHandler.new(baseConfig, saveFolder)
    local self = setmetatable({}, ConfigHandler)

    self.config = {}
    self.elementLinks = {} -- New registry to store ElementLink instances for each flag
    self.saveFolder = saveFolder

    for flag, value in baseConfig do
        self:Add(flag, value)
    end

    return self
end

function ConfigHandler:GetChangedSignal()
    if self.ChangedSignal == nil then
        self.ChangedSignal = Signal.new()

        for flag, object in self.config do
            if Value.IsValue(object) then
                object:GetChangedSignal():Connect(function()
                    self.ChangedSignal:Fire(flag, self:GetValue(flag))
                end)
            end
        end
    end
    return self.ChangedSignal
end

function ConfigHandler:Add(flag, baseValue)
    if self.config[flag] then
        self:SetValue(flag, baseValue)
        return self.config[flag]
    end

    local object = Value.new(baseValue)
    self.config[flag] = object

    if self.ChangedSignal then
        object:GetChangedSignal():Connect(function()
            self.ChangedSignal:Fire(flag, object:Get())
        end)
        self.ChangedSignal:Fire(flag, self:GetValue(flag))
    end

    return object
end

function ConfigHandler:AddElement(flag, element)
    -- Check if element has SetValue method
    if not element.SetValue then
        warn("Element does not have SetValue method, cannot be added to registry")
        return element
    end
    
    -- If no value exists for this flag, create one with element's value
    if not self.config[flag] then
        self:Add(flag, element:GetValue())
    else
        -- If value exists, update element to match the value
        element:SetValue(self:GetValue(flag))
    end

    -- Initialize ElementLink for this flag if it doesn't exist
    if not self.elementLinks[flag] then
        self.elementLinks[flag] = ElementLink.new(nil, self.config[flag])
    end

    -- Add element to the ElementLink
    self.elementLinks[flag]:AddElement(element)
    
    return element
end

function ConfigHandler:RemoveElement(flag, element)
    if self.elementLinks[flag] then
        self.elementLinks[flag]:RemoveElement(element)
    end
end

function ConfigHandler:GetValue(flag)
    if not self.config[flag] then
        return nil
    end
    if Value.IsValue(self.config[flag]) then
        return self.config[flag]:Get()
    end
end

function ConfigHandler:SetValue(flag, value)
    if self:GetValue(flag) == value then
        return
    end
    if not self.config[flag] then
        self:Add(flag, value)
    else
        if Value.IsValue(self.config[flag]) then
            self.config[flag]:Set(value)
        end
    end
end

function ConfigHandler:GetSaveData()
    local saveData = {}
    for flag in self.config do
        saveData[flag] = self:GetValue(flag)
    end
    return saveData
end

function ConfigHandler:Save(name)
    return self.saveFolder:save(name, self:GetSaveData())
end

function ConfigHandler:LoadSavedConfig(saveData)
    local failedCount, totalCount = 0, 0
    for flag, value in saveData do
        local success = self.config[flag] ~= nil
        if success then
            self:SetValue(flag, value)
        else
            failedCount = failedCount + 1
        end
        totalCount = totalCount + 1
    end
    return failedCount == 0, "(" .. tostring(failedCount) .. ") out of (" .. tostring(totalCount) .. ") elements failed to load."
end

function ConfigHandler:Load(name)
    local save = self.saveFolder:getSave(name)
    if save then
        local success, message = self:LoadSavedConfig(save)
        return success, success and "loaded successfully!" or message .. " Please save again."
    else
        return false, "Config doesn't exist. Save first."
    end
end

function ConfigHandler:GetSaves()
    return self.saveFolder:getSaves()
end

function ConfigHandler:Delete(name)
    return self.saveFolder:delete(name)
end

return ConfigHandler
