local Value = SELAMI_HUB.ModuleLoader:LoadFromPath("Util/Value.lua")

local ElementLink = {}
ElementLink.__index = ElementLink

function ElementLink.new(elements, valueObject)
	local self = setmetatable({}, ElementLink)

	self.linkedElements = {}
	self.valueObject = valueObject or Value.new()

	self.valueObject:GetChangedSignal():Connect(function()
		for _, linkedElement in ipairs(self.linkedElements) do
			if linkedElement:GetValue() ~= self.valueObject:Get() then
				linkedElement:SetValue(self.valueObject:Get())
			end
		end
	end)

	-- Add initial elements if provided
	if elements then
		for _, element in ipairs(elements) do
			self:AddElement(element)
		end
	end

	return self
end

function ElementLink:_wrapElementValueChange(element, callbackName)
	local originalCallback = element[callbackName]
	element[callbackName] = function(_, ...)
		if table.find(self.linkedElements, element) then
			self.valueObject:Set(element:GetValue())
		end

		originalCallback(_, ...)
	end
end

function ElementLink:AddElement(element)
	-- Check if element has required methods
	if (not element.SetValue) or not element.GetValue then
		warn("Element does not have required methods (OnKeybindSet/SetValue/GetValue), cannot be added")
		return element
	end

	-- Add element to registry
	table.insert(self.linkedElements, element)

	-- If this is the first element, set the value object to its value
	if #self.linkedElements == 1 then
		self.valueObject:Set(element:GetValue())
	else
		-- Otherwise, update the element to match the value object
		element:SetValue(self.valueObject:Get())
	end

	-- Wrap the element's Value change

	if element.OnKeybindSet then
		self:_wrapElementValueChange(element, "OnKeybindSet")
	else
		self:_wrapElementValueChange(element, "Callback")
	end

	return element
end

function ElementLink:RemoveElement(element)
	for i, linkedElement in ipairs(self.linkedElements) do
		if linkedElement == element then
			-- Remove from registry
			table.remove(self.linkedElements, i)
			break
		end
	end
end

function ElementLink:GetValue()
	return self.valueObject:Get()
end

function ElementLink:SetValue(value)
	self.valueObject:Set(value)
end

return ElementLink
