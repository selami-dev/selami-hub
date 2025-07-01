local fileManager = SELAMI_HUB.ModuleLoader:LoadFromPath("Util/FileManager.lua")
getgenv().TELEPORT_HANDLER = TELEPORT_HANDLER or {}

return function(name, link, ...)
	local args = { ... }
	local folder = fileManager.new("SelamiHubTeleportHandler")

	if not link then
		folder:delete(name)
		return
	end

	local saveData = {
		args = args,
		link = link,
	}

	if not TELEPORT_HANDLER[name] then
		TELEPORT_HANDLER[name] = true
		queue_on_teleport([[
            loadstring(game:HttpGet('https://raw.githubusercontent.com/selami-dev/selami-hub/refs/heads/main/main/Util/TeleportHandler/OnTeleport.lua'))()(]] .. "'" .. name .. "'" .. [[)
        ]])
	end

	folder:save(name, saveData)
end
