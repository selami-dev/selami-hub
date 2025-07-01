-->> loadstrng
--[[
    
    local fileManager = loadstring(game:HttpGet('https://gitlab.com/selamists/selamihub/-/raw/main/build/Util/FileManager.lua'))()
]]

-->> src
local Serializer = (SELAMI_HUB and SELAMI_HUB.ModuleLoader:LoadFromLink('https://raw.githubusercontent.com/regginator/LuaEncode/refs/heads/master/src/LuaEncode.lua')) or loadstring(game:HttpGet('https://raw.githubusercontent.com/regginator/LuaEncode/refs/heads/master/src/LuaEncode.lua'))()
--local HttpService = game:GetService"HttpService"

local function fileNameFromPath(path: string)
    -- Get the last part after the last backslash (or the full string if none)
    local lastPart = path:match(".*\\(.*)") or path

    -- Remove the extension if present
    local nameOnly = lastPart:match("(.+)%..+$") or lastPart
    return nameOnly
end

local function filePathFromName(folderPath: string, name: string)
    return folderPath .. "/" .. name .. ".txt"
end

local fileManager = {}
fileManager.__index = fileManager

function fileManager.new(folderPath: string)
    if not isfolder(folderPath) then
        makefolder(folderPath)
    end
    return setmetatable({folderPath = folderPath}, fileManager)
end

local function decode(filePath: string) 
    local success, result = pcall(function()
        return loadstring('return ' .. readfile(filePath))()
    end)
    
    if not success then
        delfile(filePath)
        return nil
    end
    
    return result
end

function fileManager.getSave(self, fileName: string)
    local filePath = filePathFromName(self.folderPath, fileName)
    if isfile(filePath) then
        return decode(filePath)
    end
end

function fileManager.exists(self, fileName: string)
    local filePath = filePathFromName(self.folderPath, fileName)
    return isfile(filePath)
end

function fileManager.folder(self, folderName: string)
    local folderPath = self.folderPath .. "/" .. folderName
    return fileManager.new(folderPath)
end

function fileManager.getSaves(self)
    local files = listfiles(self.folderPath)
    local saves = {}
    for _, filePath in files do
        if isfolder(filePath) then continue end
        local fileName = fileNameFromPath(filePath)
        local data = decode(filePath)
        if data then
            saves[fileName] = data
        end
    end
    return saves
end

function fileManager.delete(self, fileName: string)
    local filePath = filePathFromName(self.folderPath, fileName)
    if isfile(filePath) then
        delfile(filePath)
    end
end

function fileManager.save(self, fileName: string, configTable: {})
    local filePath = filePathFromName(self.folderPath, fileName)
    local success, message = pcall(function()
        writefile(filePath, Serializer(configTable, {Prettify = true})) 
    end)
    if not success then
        return false, message or "Unknown error"
    end
    return true
end

return fileManager