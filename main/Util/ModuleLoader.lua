local ModuleLoader = {}
ModuleLoader.__index = ModuleLoader

function ModuleLoader.new()
	local self = setmetatable({}, ModuleLoader)
	self.loadedModules = {}
	return self
end

function ModuleLoader:LoadFromLink(link)
	warn("Loading module from link: " .. link)

	if self.loadedModules[link] then
		return unpack(self.loadedModules[link].Result)
	end

	--warn("Loading module from link: " .. link)
	local result = { loadstring(game:HttpGet(link))() }
	self.loadedModules[link] = {
		Result = result,
	}

	return unpack(result)
end

function ModuleLoader:LoadFromPath(path)
	-- Convert path to build link
	local baseUrl = "https://raw.githubusercontent.com/selami-dev/selami-hub/refs/heads/main/main/"
	local link = baseUrl .. path

	-- Load and cache the module
	return self:LoadFromLink(link)
end

return ModuleLoader.new()
