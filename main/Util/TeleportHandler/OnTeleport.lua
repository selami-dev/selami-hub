local fileManager = loadstring(
	game:HttpGet("https://raw.githubusercontent.com/selami-dev/selami-hub/refs/heads/main/main/Util/FileManager.lua")
)()

return function(name)
	local folder = fileManager.new("SelamiHubTeleportHandler")

	if not folder:exists(name) then
		return
	end

	local saveData = folder:getSave(name)
	folder:delete(name)

	loadstring(game:HttpGet(saveData.link))()(unpack(saveData.args))
end
