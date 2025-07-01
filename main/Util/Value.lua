local Signal = SELAMI_HUB.ModuleLoader:LoadFromPath("Util/Signal.lua")

local Value = {}
Value.__index = Value

function Value.new(value)
    local self = setmetatable({}, Value)
    self.value = value
    return self
end

function Value.IsValue(value)
    return type(value) == "table" and getmetatable(value) == Value
end

function Value:Set(value)
    if self.value == value then
        return
    end
    self.value = value
    if self.changedSignal then
        self.changedSignal:Fire(value)
    end
end 

function Value:Get()
    return self.value
end

function Value:GetChangedSignal()
    if self.changedSignal == nil then
        self.changedSignal = Signal.new()
    end
    return self.changedSignal
end

-- Allow Value() to call SetValue
function Value:__call(...)
    local args = {...}
    self:Set(args[1])
    return self
end

return Value
