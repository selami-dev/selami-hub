
if getgenv().SELAMI_ENVIRONMENT then
    return getgenv().SELAMI_ENVIRONMENT
end

local enviromentHandler = {
        __loadstrings = {},
        __branch = "Build",
        __key = "",
}

getgenv().SELAMI_ENVIRONMENT = enviromentHandler

enviromentHandler.__index = enviromentHandler
function enviromentHandler:Load(url: string)
    if self.__loadstrings[url] then
        return self.__loadstrings[url]
    end

    self.__loadstrings[url] = loadstring(game:HttpGet(url))()
    return self.__loadstrings[url]
end

function enviromentHandler:LoadFromHub(path: string)
    local baseUrl = "https://gitlab.com/selamists/selamihub/-/raw/" .. self.__branch .. "/" .. "build" .. "/"
    local url = baseUrl .. path
    return self:Load(url)
end

function enviromentHandler:SetParams(branch: string, key: string)
    self.__branch = branch or self.__branch
    self.__key = key or self.__key
end

return enviromentHandler

