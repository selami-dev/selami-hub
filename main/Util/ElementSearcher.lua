-- THIS DOESNT FUCKING WORK

local ElementLink = SELAMI_HUB.ModuleLoader:LoadFromPath("Util/ElementLink.lua")

local ElementSearcher = {}
ElementSearcher.__index = ElementSearcher

function ElementSearcher.new(canvas)
    local self = setmetatable({}, ElementSearcher)
    
    self.canvas = canvas
    self.searchIndexes = {}  -- Stores tree node class tables
    self.searchInstances = {}  -- Stores tree node instances
    self.allElements = {}
    
    -- Create main search header
    self.searchHeader, self.searchHeaderContainer = self.canvas:CollapsingHeader({
        Title = "🔍 Search"
    })
    
    -- Create search input
    self.searchInput = self.searchHeader:InputText({
        Text = "",
        PlaceHolder = "Search",
        Callback = function()
            self:ProcessSearch()
        end
    })
    
    -- Add separator
    self.searchHeader:Separator()
    
    return self
end

function ElementSearcher:InitSearchIndex(indexName)
    if not indexName or indexName == "" then
        return nil
    end
    
    -- Convert to lowercase for case-insensitive comparison
    local lowerIndex = string.lower(indexName)
    
    -- Check if index already exists
    for existingIndex, _ in pairs(self.searchIndexes) do
        if string.lower(existingIndex) == lowerIndex then
            return self.searchIndexes[existingIndex]
        end
    end
    
    -- Create new tree node for this index
    local treeNodeTable, treeNodeInstance = self.searchHeader:TreeNode({
        Title = indexName
    })
    
    -- Initially hide the tree node instance
    treeNodeInstance.Visible = false
    
    -- Store both the tree node class table and instance
    self.searchIndexes[indexName] = treeNodeTable
    self.searchInstances[indexName] = treeNodeInstance
    
    return treeNodeTable
end

function ElementSearcher:AddElement(params)
    -- Validate inputs
    if not params or type(params) ~= "table" then
        warn("AddElement requires a table parameter")
        return nil
    end
    
    local element = params.Element
    local name = params.Name
    local elementClassName = params.ElementClassName
    local searchIndexes = params.SearchIndexes
    local elementConfig = params.ElementConfig
    
    if not element or not elementClassName or not searchIndexes then
        warn("AddElement requires element, elementClassName, and searchIndexes parameters")
        return element
    end

    -- Initialize only the first search index for this element
    local firstIndex = searchIndexes[1]
    if firstIndex then
        self:InitSearchIndex(firstIndex)
    end
    
    -- Check if element already exists
    for _, data in ipairs(self.allElements) do
        if data.element == element then
            self:RemoveElement(element) -- Remove existing element first
            break
        end
    end
    
    local elementData = {
        element = element,
        cloned = nil,
        searchIndexes = searchIndexes,
        elementLink = nil,
        destroyConnection = nil,
        primaryTreeNodeTable = nil,  -- Store the first search index's tree node table
        primaryTreeNodeInstance = nil  -- Store the first search index's tree node instance
    }
    
    -- Create clone of the element
    local cloneConfig = {}
    
    -- Safely copy config
    if type(element) == "table" then
        for k, v in pairs(element) do
            if type(v) ~= "function" then
                cloneConfig[k] = v
            end
        end
    end

    if elementConfig then
        for k, v in pairs(elementConfig) do
            cloneConfig[k] = v
        end
    end

    if elementClassName == "Button" then
        cloneConfig.Callback = nil
    end
    
    -- Set label if provided
    if name then
        cloneConfig.Label = name
    end
    
    -- Get the tree node table and instance for the first index
    local treeNodeTable
    if firstIndex then
        treeNodeTable = self.searchIndexes[firstIndex]
    end

    local clone
    if treeNodeTable and treeNodeTable[elementClassName] and type(treeNodeTable[elementClassName]) == "function" then
        -- Create element directly on the tree node table
        clone = treeNodeTable[elementClassName](treeNodeTable, cloneConfig)
        
        -- Safety checks for the clone
        if clone then
            -- Link original and clone
            local elementLink
            if elementClassName ~= "Button" then
                elementLink = ElementLink.new({element, clone})
            end
            
            -- Store clone and link
            elementData.cloned = clone
            elementData.elementLink = elementLink
            
            -- Store references to both the tree node table and instance
            if firstIndex then
                elementData.primaryTreeNodeTable = self.searchIndexes[firstIndex]
                elementData.primaryTreeNodeInstance = self.searchInstances[firstIndex]
            end
            
            -- Store element data
            table.insert(self.allElements, elementData)
            
            -- Connect to element's destroying event
            elementData.destroyConnection = element.Destroying:Connect(function()
                self:RemoveElement(element)
            end)
            
            -- Initially hide the element until search is performed
            clone.Visible = false
            
            -- Process search for this element
            self:ProcessSearch()
        else
            warn("Failed to create clone for element using class: " .. elementClassName)
        end
    else
        warn("Element class '" .. elementClassName .. "' not found in tree node")
    end
    
    return element, clone
end

function ElementSearcher:RemoveElement(element)
    if not element then return end
    
    -- Find and remove element data
    local found = false
    for i, elementData in ipairs(self.allElements) do
        if elementData.element == element then
            found = true
            
            -- Disconnect destroy event
            if elementData.destroyConnection then
                elementData.destroyConnection:Disconnect()
                elementData.destroyConnection = nil
            end
            
            -- Destroy clone
            if elementData.cloned then
                elementData.cloned:Destroy()
                elementData.cloned = nil
            end
            
            -- Remove from all elements
            table.remove(self.allElements, i)
            break
        end
    end
    
    if found then
        -- Process search to update visibility
        self:ProcessSearch()
    end
end

function ElementSearcher:ProcessSearch()
    local searchText = self.searchInput:GetValue() or ""
    searchText = tostring(searchText)
    
    -- Hide all tree node instances by default
    for indexName, instance in pairs(self.searchInstances) do
        instance.Visible = false
    end
    
    -- If search is empty, hide all clones
    if searchText == "" then
        for _, elementData in ipairs(self.allElements) do
            if elementData.cloned then
                elementData.cloned.Visible = false
            end
        end
        return
    end
    
    -- Split search text by non-alphanumeric characters
    local searchTerms = {}
    for term in string.gmatch(searchText, "[^%s,]+") do
        table.insert(searchTerms, string.lower(term))
    end
    
    if #searchTerms == 0 then return end
    
    -- Process each element
    for _, elementData in ipairs(self.allElements) do
        local matched = false
        
        -- Skip if element data is incomplete
        if not elementData.cloned or not elementData.searchIndexes or #elementData.searchIndexes == 0 then
            continue
        end
        
        -- Check each search term against element's search indexes
        for _, searchTerm in ipairs(searchTerms) do
            for _, elementIndex in ipairs(elementData.searchIndexes) do
                if string.find(string.lower(elementIndex), searchTerm) then
                    matched = true
                    break
                end
            end
            if matched then break end
        end
        
        -- Update visibility based on match
        if matched then
            -- Show the element
            elementData.cloned.Visible = true
            
            -- Only make the primary tree node instance visible (where the element is parented)
            if elementData.primaryTreeNodeInstance then
                elementData.primaryTreeNodeInstance.Visible = true
            end
        else
            -- Hide the element
            elementData.cloned.Visible = false
        end
    end
end

-- Cleanup resources
function ElementSearcher:Destroy()
    for _, elementData in ipairs(table.clone(self.allElements)) do
        self:RemoveElement(elementData.element)
    end
    
    -- Clear tables
    self.allElements = {}
    self.searchIndexes = {}
    self.searchInstances = {}
    
    -- Remove UI elements
    if self.searchHeader then
        self.searchHeader:Destroy()
        self.searchHeader = nil
    end
end

return ElementSearcher
