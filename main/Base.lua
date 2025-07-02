-->> Loadstring
--	local BaseScript = loadstring(game:HttpGet('https://gitlab.com/selamists/selamihub/-/raw/main/build/Util/Base.lua'))()

if not SELAMI_HUB then
	return false, "SELAMI_HUB is not defined."
end

if not SELAMI_HUB.Key or type(SELAMI_HUB.Key) ~= "string" or SELAMI_HUB.Key ~= "LexinKocaMemeleri" then
	return false, "Invalid Key."
end

SELAMI_HUB.Scripts = SELAMI_HUB.Scripts or {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local InsertService = game:GetService("InsertService")
local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
--local CoreGui = cloneref(game:GetService("CoreGui"))

local BaseLoader = {}
BaseLoader.__index = BaseLoader

local ImGui = SELAMI_HUB.ModuleLoader:LoadFromLink(
	"https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua"
)
local Janitor = SELAMI_HUB.ModuleLoader:LoadFromPath("Util/Janitor.lua")
local Signal = SELAMI_HUB.ModuleLoader:LoadFromPath("Util/Signal.lua")
local Serializer = SELAMI_HUB.ModuleLoader:LoadFromLink(
	"https://raw.githubusercontent.com/regginator/LuaEncode/refs/heads/master/src/LuaEncode.lua"
)
local ConfigHandlerLib = SELAMI_HUB.ModuleLoader:LoadFromPath("Util/ConfigHandler.lua")
local fileManagerLib = SELAMI_HUB.ModuleLoader:LoadFromPath("Util/FileManager.lua")

BaseLoader.ImGui = ImGui
BaseLoader.Janitor = Janitor
BaseLoader.Signal = Signal
BaseLoader.ConfigHandlerLib = ConfigHandlerLib

function BaseLoader.new(name)
	local self = setmetatable({}, BaseLoader)
	self.name = name

	if SELAMI_HUB.Scripts[name] then
		SELAMI_HUB.Scripts[name]:Unload()
	end

	SELAMI_HUB.Scripts[name] = self

	self:InitWindow()

	local hooks = Janitor.new()

	self.hooks = hooks
	self.loaded = true
	self.configs = {}

	self:InitConfigHandler()

	return self
end

function BaseLoader:InitWindow()
	local Window = ImGui:TabsWindow({
		Visible = false,
		Title = "✌️⛪ SelamiHub " .. Players.LocalPlayer.Name,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 700, 0, 700),
		AutoSize = false,
	})
	Window:Center()

	self.window = Window
	return Window
end

function BaseLoader:InitConfigHandler()
	local hubFolder = fileManagerLib.new("SelamiHub")
	local scriptFolder = hubFolder:folder(self.name)
	local saveFolder = scriptFolder:folder("Saves")
	local hubSettingsFolder = hubFolder:folder("!HubSettings")

	self.configHandler = ConfigHandlerLib.new({}, saveFolder)
	self.hubSettingsHandler = ConfigHandlerLib.new({}, hubSettingsFolder:folder("Saves"))

	self.scriptFolder = scriptFolder
	self.saveFolder = saveFolder
	self.hubFolder = hubFolder
	self.hubSettingsFolder = hubSettingsFolder

	return self.configHandler, self.hubSettingsHandler
end

function BaseLoader:Serialize(data, config)
	return Serializer(data, config)
end

-- Notification System
local NotificationClass

do
	local NotificationRegistry = {}
	NotificationRegistry.Notifications = {}

	NotificationRegistry.__index = NotificationRegistry

	function NotificationRegistry:Update()
		for i, notification in self.Notifications do
			notification:SetIndex(i)
		end
	end

	function NotificationRegistry:ClearNotifications()
		local totalOffset = 0
		for _, notification in pairs(self.Notifications) do
			totalOffset += 10 + notification.notification.WindowFrame.AbsoluteSize.Y
			notification:Destroy()
		end
		self.Notifications = {}
	end

	function NotificationRegistry:RemoveNotification(notification)
		local index = table.find(self.Notifications, notification)
		if index then
			table.remove(self.Notifications, index)
			self:Update()
		end
	end

	function NotificationRegistry:AddNotification(notification)
		table.insert(self.Notifications, 1, notification)
		self:Update()
	end

	NotificationClass = {}
	NotificationClass.__index = NotificationClass

	function NotificationClass.new(title, message, length, hasSound, theme)
		local self = {}
		setmetatable(self, NotificationClass)

		self.title = title
		self.message = message
		self.length = length
		self.hasSound = hasSound
		self.theme = theme

		self.janitor = Janitor.new()
		self:Init()

		NotificationRegistry:AddNotification(self)

		return self
	end

	function NotificationClass:Init()
		if self.initialized then
			return
		end
		self.initialized = true

		local notification = ImGui:PopupModal({
			Title = self.title,
			TabsBar = false,
			NoCollapse = true,
			NoResize = true,
			NoClose = false,
			AutoSize = Enum.AutomaticSize.None,
			NoMove = true,
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1 - 0.05, 0, 1 - 0.05, 0),
			Size = UDim2.fromOffset(0, 0), --// Roblox property ,
			Theme = self.theme,
		})
		local windowUi = notification.WindowFrame

		self.notification = notification
		local label = self.notification:Label({
			Text = self.message,
			TextWrapped = false,
			RichText = true,
		})

		windowUi.AnchorPoint = Vector2.new(1, 1)
		notification.AnchorPoint = Vector2.new(1, 1)

		local tween = TweenService:Create(
			windowUi,
			TweenInfo.new(0.5, Enum.EasingStyle.Circular, Enum.EasingDirection.Out),
			{ Size = UDim2.fromOffset(math.max(label.TextBounds.X + 20, 500), 50) }
		)
		tween:Play()

		tween.Completed:Connect(function(playbackState)
			if playbackState == Enum.PlaybackState.Completed then
				notification.AutomaticSize = Enum.AutomaticSize.X
			end
		end)

		--> Auto Destroy
		if self.length then
			self.janitor:Add(task.delay(self.length + 0.5, function()
				self:Destroy()
			end))
		end

		--> Sound Effect
		if self.hasSound then
			local sound = Instance.new("Sound")

			if not (typeof(self.hasSound) == "string" or typeof(self.hasSound) == "number") then
				self.hasSound = 4590662766
			end

			sound.SoundId = "rbxassetid://" .. self.hasSound

			sound.Volume = 1
			SoundService:PlayLocalSound(sound)

			task.delay(sound.TimeLength, function()
				sound:Destroy()
			end)
		end

		self.janitor:Add(notification.WindowFrame:GetPropertyChangedSignal("Visible"):Connect(function()
			if notification.WindowFrame.Visible then
				return
			end
			self:Destroy(true)
		end))

		return notification
	end

	function NotificationClass:SetIndex(i)
		local offset = (i - 1) * 60
		local windowUi = self.notification.WindowFrame
		local tween = TweenService:Create(
			windowUi,
			TweenInfo.new(0.5, Enum.EasingStyle.Circular),
			{ Position = UDim2.new(1 - 0.05, 0, 1 - 0.05, -offset) }
		)
		tween:Play()
	end

	function NotificationClass:Destroy(noAnimation)
		if self.destroyed then
			return
		end
		self.destroyed = true

		NotificationRegistry:RemoveNotification(self)
		self.janitor:Destroy()

		if noAnimation then
			self.notification:ClosePopup()
			self.notification:Destroy()
			return
		end

		-- Tween the size to 0 before destroying
		local windowUi = self.notification.WindowFrame

		-- Create and play the tween to shrink the notification
		if self.label then
			self.label:Destroy()
		end

		local tween = TweenService:Create(
			windowUi,
			TweenInfo.new(0.5, Enum.EasingStyle.Circular, Enum.EasingDirection.Out),
			{ Size = UDim2.fromOffset(0, 0) }
		)

		tween:Play()

		-- After tween completes, destroy the notification
		tween.Completed:Connect(function()
			self.notification:ClosePopup()
			self.notification:Destroy()
		end)
	end
end

function BaseLoader:Notify(title, message, length, hasSound, theme)
	return NotificationClass.new(
		title,
		message,
		length,
		hasSound,
		(theme or (self.window and self.window.Theme)) or "🌙 Dark"
	)
end

function BaseLoader:ConfigHandlerElement(canvas, handler, saveSettingsFolder)
	local saveSettingsHandler = ConfigHandlerLib.new({
		AutoLoadEnabled = true,
		AutoSaveEnabled = true,
		LastSaveName = "AutoSave",
	}, saveSettingsFolder)

	saveSettingsHandler:Load("SaveSettings")

	local function loadConfig(name)
		return handler:Load(name)
	end

	local function loadConfigButton(name)
		local success, message = loadConfig(name)
		if success then
			self:Notify("⚙️ Config", "✅ You loaded the config: (" .. name .. ")", 5)
		else
			self:Notify("⚙️ Config", "‼️ Failed to load config: (" .. name .. "), " .. message, 5)
		end
	end

	local function saveConfig(name)
		local success, message = handler:Save(name)
		if success then
			self:Notify("⚙️ Config", "✅ You saved the config: (" .. name .. ")", 5)
		else
			self:Notify("⚙️ Config", "‼️ Failed to save config: (" .. name .. "), " .. message, 5)
		end
	end

	-->> UI
	local tab = canvas

	tab:Separator({
		Text = "Save/Load configs",
	})

	local row = tab:Row()

	saveSettingsHandler:AddElement(
		"AutoSaveEnabled",
		row:Checkbox({
			Label = "Auto-Save",
			Value = true,
			Callback = function(self, Value) end,
		})
	)

	saveSettingsHandler:AddElement(
		"AutoLoadEnabled",
		row:Checkbox({
			Label = "Auto-Load",
			Value = true,
			Callback = function(self, Value) end,
		})
	)

	tab:Separator({
		Text = "Selected Save",
	})

	--row:Fill()

	local selectedSaveName = saveSettingsHandler:GetValue("LastSaveName")
	--warn(selectedSaveName)

	local inputText = tab:InputText({
		Text = selectedSaveName,
		PlaceHolder = "Type save name here / Select from list",
		Callback = function(self, v)
			selectedSaveName = v
		end,
	})
	saveSettingsHandler:AddElement("LastSaveName", inputText)
	--inputText:SetValue(selectedSaveName)

	local row2 = tab:Row()

	row2:Button({
		Text = "Load",
		Callback = function(self)
			loadConfigButton(selectedSaveName)
		end,
	})

	row2:Button({
		Text = "Save",
		Callback = function(self)
			saveConfig(selectedSaveName)
		end,
	})

	row2:Button({
		Text = "Delete",
		Callback = function(self)
			handler:Delete(selectedSaveName)
		end,
	})

	--row2:Fill()

	tab:Separator({
		Text = "Save List",
	})

	--local row3 = tab:Row()
	local previousCombo

	local function getSaves()
		local saves = handler:GetSaves()
		local result = {}
		for i, v in saves do
			table.insert(result, i)
		end
		return result
	end

	local function refreshConfigList()
		if previousCombo then
			previousCombo:Destroy()
		end
		previousCombo = tab:Combo({
			Placeholder = "Select a save.",
			Label = "Saves",
			Items = getSaves(),
			Callback = function(self, Value)
				inputText:SetValue(Value)
			end,
		})
	end

	tab:Button({
		Text = "Refresh",
		Callback = function(self)
			refreshConfigList()
		end,
	})

	-- Initialize
	saveSettingsHandler:Load("SaveSettings")
	refreshConfigList()
	--row3:Fill()

	if saveSettingsHandler:GetValue("AutoLoadEnabled") then
		local success, message = loadConfig("AutoSave")
		if success then
			self:Notify("⚙️ Config", "✅ Auto-loaded config: (" .. "AutoSave" .. ")", 5, true)
		elseif handler.saveFolder:exists("AutoSave") then
			self:Notify("⚙️ Config", "‼️ Failed to Auto-Load: (" .. "AutoSave" .. "), " .. message, 5, true)
		end
	end

	local function autoSave()
		saveSettingsHandler:Save("SaveSettings")
		--self.hubSettingsHandler:Save("HubSettings")
		if not saveSettingsHandler:GetValue("AutoSaveEnabled") then
			return
		end
		handler:Save("AutoSave")
	end

	handler:GetChangedSignal():Connect(function(flag, value)
		if saveSettingsHandler:GetValue("AutoSaveEnabled") then
			handler:Save("AutoSave")
		end
	end)

	local localPlayer = Players.LocalPlayer
	self.hooks:Add(Players.PlayerRemoving:Connect(function(child)
		if child == localPlayer then
			autoSave()
		end
	end))

	return saveSettingsHandler
end

function BaseLoader:ConfigTab()
	local ConfigTab = self.window:CreateTab({
		Name = "🔧 Configs",
	})

	local configSaveSettings = self:ConfigHandlerElement(
		ConfigTab:TreeNode({ Title = self.name, Collapsed = false }),
		self.configHandler,
		self.scriptFolder
	)
	--local hubSaveSettings = self:ConfigHandlerElement(ConfigTab:CollapsingHeader({Title = "⚙️ Hub", Collapsed = true}), self.hubSettingsHandler, self.hubSettingsFolder)

	self.autosave = function()
		self.hubSettingsHandler:Save("AutoSave")
	end

	self.hubSettingsHandler:GetChangedSignal():Connect(function(flag, value)
		self.hubSettingsHandler:Save("AutoSave")
	end)

	self.hubSettingsHandler:Load("AutoSave")

	-- Theme Fix
	self.hooks:Add(Players.PlayerRemoving:Connect(function(child)
		if child == Players.LocalPlayer then
			self.autosave()
		end
	end))

	task.delay(0.25, function()
		local lastTheme = self.window.Theme
		self.window:SetTheme("DarkTheme")
		self.window:SetTheme(lastTheme)
	end)
end

function BaseLoader:UiTab()
	--ui tab
	local UiTab = self.window:CreateTab({
		Name = "🎨 Ui",
	})

	UiTab:Separator({
		Text = "Keybind",
	})

	do
		local toggleUiKeybind = UiTab:Keybind({
			Label = "Toggle UI",
			Value = Enum.KeyCode.RightControl,
			Callback = function()
				self.window:SetVisible(not self.window.Visible)
			end,
		})
		self.hubSettingsHandler:AddElement("ToggleUiKeybind", toggleUiKeybind)

		local wasClosedBefore = false
		self.window.WindowFrame:GetPropertyChangedSignal("Visible"):Connect(function()
			if self.window.Visible then
				return
			end

			if toggleUiKeybind.Value then
				if wasClosedBefore then
					--ImGui:Notify("Press " .. `{toggleUiKeybind.Value}` .. " to re-open the gui." , 1)
					return
				end
				wasClosedBefore = true
				self:Notify("🎨 Ui", "Press " .. toggleUiKeybind.Value.Name .. " to re-open the gui.", 4)
			end
		end)
	end

	UiTab:Separator({
		Text = "Theme",
	})

	local imageController = {}
	imageController.ImageLabel = Instance.new("ImageLabel")
	imageController.ImageLabel.Size = UDim2.fromScale(1, 1)
	imageController.ImageLabel.BackgroundTransparency = 1
	imageController.ImageLabel.Image = ""
	imageController.ImageLabel.ImageTransparency = 0.9
	imageController.ImageLabel.Parent = self.window.WindowFrame

	function imageController:SetImage(image)
		imageController.ImageLabel.Image = "rbxassetid://" .. image
	end

	function imageController:SetEnabled(enabled)
		imageController.ImageLabel.Visible = enabled
	end

	local lastImage = nil
	local customImageEnabled = false
	local customImageId = ""

	local function updateImage(image)
		if image and image ~= "" then
			lastImage = image
		end
		if customImageEnabled and customImageId ~= "" then
			imageController.ImageLabel.Image = "rbxassetid://" .. customImageId
		elseif lastImage then
			imageController.ImageLabel.Image = "rbxassetid://" .. lastImage
		end
		ContentProvider:PreloadAsync({ imageController.ImageLabel })
	end

	--imageController:SetImage(91692116526196)

	local imageVisibleCheckbox = UiTab:Checkbox({
		Label = "Image Visible",
		Value = true,
		Callback = function(self, Value)
			imageController:SetEnabled(Value)
		end,
	})
	self.hubSettingsHandler:AddElement("ImageVisible", imageVisibleCheckbox)

	local customImageCheckbox = UiTab:Checkbox({
		Label = "Custom Image Toggle",
		Value = customImageEnabled,
		Callback = function(_, Value)
			customImageEnabled = Value
			updateImage(lastImage)
		end,
	})
	self.hubSettingsHandler:AddElement("CustomImageEnabled", customImageCheckbox)

	local customImageInput = UiTab:InputText({
		Label = "Custom Image ID",
		Placeholder = "Enter Image ID",
		Value = customImageId,
		Callback = function(_, Value)
			customImageId = Value
			updateImage(lastImage)
		end,
	})
	self.hubSettingsHandler:AddElement("CustomImageId", customImageInput)

	do
		local allThemes = {}

		local function selectTheme(theme)
			for _, v in ImGui.Windows do
				v:SetTheme(theme)
			end
			if self.Themes[theme] and self.Themes[theme].Image then
				updateImage(self.Themes[theme].Image)
			else
				updateImage(91692116526196)
			end
		end

		for i, v in self.Themes do
			table.insert(allThemes, i)
		end

		local themeDropdown = UiTab:Combo({
			Placeholder = "Select Theme",
			Label = "Theme",
			Items = allThemes,
			Value = "🌸 Pink",
			Callback = function(_, Value)
				selectTheme(Value)
			end,
		})

		self.hubSettingsHandler:AddElement("Theme", themeDropdown)
		selectTheme("🌸 Pink")
	end
end

function BaseLoader:UnloadTab()
	-- unloading gui
	local closeTab = self.window:CreateTab({
		Name = "🔌 Unload",
	})

	closeTab:Button({
		Text = "Unload the script",
		Callback = function()
			self:Unload()
			self:Notify("Unload", "Unloaded (Everything disabled, re-execute to enable)", 3)
		end,
	})
end

function BaseLoader:Unload()
	if not self.loaded then
		return
	end
	self.loaded = false
	if self.autosave then
		self:autosave()
	end
	task.wait()
	self.hooks:Cleanup()
	self.window:Close()
	self.window.WindowFrame:Destroy()
	self.window:Destroy()
end

function BaseLoader:Finalize()
	self:UiTab()
	self:ConfigTab()
	self:UnloadTab()

	self.window:SetVisible(true)
end

-- Initialize Module
function BaseLoader:_InitThemes()
	if self.Themes then
		return
	end
	self.Themes = {}

	local function addTheme(name, theme, image)
		ImGui:DefineTheme(name, theme)
		local data = {
			Name = name,
			Image = image,
			Config = ImGui.ThemeConfigs[name],
		}
		self.Themes[name] = data
	end

	addTheme("🌸 Pink", {
		TextDisabled = Color3.fromRGB(200, 150, 200),
		Text = Color3.fromRGB(255, 220, 255),

		FrameBg = Color3.fromRGB(60, 40, 60),
		FrameBgTransparency = 0.3,
		FrameBgActive = Color3.fromRGB(220, 140, 220),
		FrameBgTransparencyActive = 0.3,

		CheckMark = Color3.fromRGB(255, 150, 255),
		SliderGrab = Color3.fromRGB(255, 150, 255),
		ButtonsBg = Color3.fromRGB(255, 150, 255),
		CollapsingHeaderBg = Color3.fromRGB(255, 150, 255),
		CollapsingHeaderText = Color3.fromRGB(255, 220, 255),
		RadioButtonHoveredBg = Color3.fromRGB(255, 150, 255),

		WindowBg = Color3.fromRGB(70, 50, 70),
		TitleBarBg = Color3.fromRGB(70, 50, 70),
		TitleBarBgActive = Color3.fromRGB(100, 75, 100),

		Border = Color3.fromRGB(100, 75, 100),
		ResizeGrab = Color3.fromRGB(100, 75, 100),
		RegionBgTransparency = 1,

		TabText = Color3.fromRGB(30, 30, 30),
		TabBg = Color3.fromRGB(255, 170, 255),
		TabTextActive = Color3.fromRGB(255, 255, 255),
		TabBgActive = Color3.fromRGB(120, 60, 120),
	}, 15088062142)

	-- Green Theme
	addTheme("🍀 Green", {
		TextDisabled = Color3.fromRGB(150, 200, 150),
		Text = Color3.fromRGB(220, 255, 220),

		FrameBg = Color3.fromRGB(40, 60, 40),
		FrameBgTransparency = 0.3,
		FrameBgActive = Color3.fromRGB(130, 180, 130),
		FrameBgTransparencyActive = 0.3,

		CheckMark = Color3.fromRGB(130, 220, 130),
		SliderGrab = Color3.fromRGB(130, 220, 130),
		ButtonsBg = Color3.fromRGB(130, 220, 130),
		CollapsingHeaderBg = Color3.fromRGB(130, 220, 130),
		CollapsingHeaderText = Color3.fromRGB(220, 255, 220),
		RadioButtonHoveredBg = Color3.fromRGB(130, 220, 130),

		WindowBg = Color3.fromRGB(50, 70, 50),
		TitleBarBg = Color3.fromRGB(50, 70, 50),
		TitleBarBgActive = Color3.fromRGB(70, 90, 70),

		Border = Color3.fromRGB(70, 90, 70),
		ResizeGrab = Color3.fromRGB(70, 90, 70),
		RegionBgTransparency = 1,

		TabText = Color3.fromRGB(30, 30, 30),
		TabBg = Color3.fromRGB(160, 230, 160),
		TabTextActive = Color3.fromRGB(255, 255, 255),
		TabBgActive = Color3.fromRGB(40, 80, 40),
	}, 17291005664)

	-- Red Theme
	addTheme("🍒 Red", {
		TextDisabled = Color3.fromRGB(200, 150, 150),
		Text = Color3.fromRGB(255, 220, 220),

		FrameBg = Color3.fromRGB(60, 40, 40),
		FrameBgTransparency = 0.3,
		FrameBgActive = Color3.fromRGB(180, 130, 130),
		FrameBgTransparencyActive = 0.3,

		CheckMark = Color3.fromRGB(220, 130, 130),
		SliderGrab = Color3.fromRGB(220, 130, 130),
		ButtonsBg = Color3.fromRGB(220, 130, 130),
		CollapsingHeaderBg = Color3.fromRGB(220, 130, 130),
		CollapsingHeaderText = Color3.fromRGB(255, 220, 220),
		RadioButtonHoveredBg = Color3.fromRGB(220, 130, 130),

		WindowBg = Color3.fromRGB(70, 50, 50),
		TitleBarBg = Color3.fromRGB(70, 50, 50),
		TitleBarBgActive = Color3.fromRGB(100, 75, 75),

		Border = Color3.fromRGB(100, 75, 75),
		ResizeGrab = Color3.fromRGB(100, 75, 75),
		RegionBgTransparency = 1,

		TabText = Color3.fromRGB(30, 30, 30),
		TabBg = Color3.fromRGB(230, 160, 160),
		TabTextActive = Color3.fromRGB(255, 255, 255),
		TabBgActive = Color3.fromRGB(80, 40, 40),
	}, 91692116526196)

	-- Yellow Theme
	addTheme("🍋 Yellow", {
		TextDisabled = Color3.fromRGB(200, 200, 150),
		Text = Color3.fromRGB(255, 255, 220),

		FrameBg = Color3.fromRGB(60, 60, 40),
		FrameBgTransparency = 0.3,
		FrameBgActive = Color3.fromRGB(180, 180, 130),
		FrameBgTransparencyActive = 0.3,

		CheckMark = Color3.fromRGB(220, 220, 130),
		SliderGrab = Color3.fromRGB(220, 220, 130),
		ButtonsBg = Color3.fromRGB(220, 220, 130),
		CollapsingHeaderBg = Color3.fromRGB(220, 220, 130),
		CollapsingHeaderText = Color3.fromRGB(255, 255, 220),
		RadioButtonHoveredBg = Color3.fromRGB(220, 220, 130),

		WindowBg = Color3.fromRGB(70, 70, 50),
		TitleBarBg = Color3.fromRGB(70, 70, 50),
		TitleBarBgActive = Color3.fromRGB(100, 100, 75),

		Border = Color3.fromRGB(100, 100, 75),
		ResizeGrab = Color3.fromRGB(100, 100, 75),
		RegionBgTransparency = 1,

		TabText = Color3.fromRGB(30, 30, 30),
		TabBg = Color3.fromRGB(230, 230, 160),
		TabTextActive = Color3.fromRGB(255, 255, 255),
		TabBgActive = Color3.fromRGB(80, 80, 40),
	}, 91692116526196)

	-- Blue Theme
	addTheme("🌊 Blue", {
		TextDisabled = Color3.fromRGB(150, 150, 200),
		Text = Color3.fromRGB(220, 220, 255),

		FrameBg = Color3.fromRGB(40, 40, 60),
		FrameBgTransparency = 0.3,
		FrameBgActive = Color3.fromRGB(130, 130, 180),
		FrameBgTransparencyActive = 0.3,

		CheckMark = Color3.fromRGB(130, 130, 220),
		SliderGrab = Color3.fromRGB(130, 130, 220),
		ButtonsBg = Color3.fromRGB(130, 130, 220),
		CollapsingHeaderBg = Color3.fromRGB(130, 130, 220),
		CollapsingHeaderText = Color3.fromRGB(220, 220, 255),
		RadioButtonHoveredBg = Color3.fromRGB(130, 130, 220),

		WindowBg = Color3.fromRGB(50, 50, 70),
		TitleBarBg = Color3.fromRGB(50, 50, 70),
		TitleBarBgActive = Color3.fromRGB(75, 75, 100),

		Border = Color3.fromRGB(75, 75, 100),
		ResizeGrab = Color3.fromRGB(75, 75, 100),
		RegionBgTransparency = 1,

		TabText = Color3.fromRGB(30, 30, 30),
		TabBg = Color3.fromRGB(160, 160, 230),
		TabTextActive = Color3.fromRGB(255, 255, 255),
		TabBgActive = Color3.fromRGB(40, 40, 80),
	}, 96889841779557)

	-- Purple Theme
	addTheme("🍇 Purple", {
		TextDisabled = Color3.fromRGB(180, 150, 200),
		Text = Color3.fromRGB(240, 220, 255),

		FrameBg = Color3.fromRGB(50, 40, 60),
		FrameBgTransparency = 0.3,
		FrameBgActive = Color3.fromRGB(150, 130, 180),
		FrameBgTransparencyActive = 0.3,

		CheckMark = Color3.fromRGB(190, 130, 220),
		SliderGrab = Color3.fromRGB(190, 130, 220),
		ButtonsBg = Color3.fromRGB(190, 130, 220),
		CollapsingHeaderBg = Color3.fromRGB(190, 130, 220),
		CollapsingHeaderText = Color3.fromRGB(240, 220, 255),
		RadioButtonHoveredBg = Color3.fromRGB(190, 130, 220),

		WindowBg = Color3.fromRGB(60, 50, 70),
		TitleBarBg = Color3.fromRGB(60, 50, 70),
		TitleBarBgActive = Color3.fromRGB(85, 70, 95),

		Border = Color3.fromRGB(85, 70, 95),
		ResizeGrab = Color3.fromRGB(85, 70, 95),
		RegionBgTransparency = 1,

		TabText = Color3.fromRGB(30, 30, 30),
		TabBg = Color3.fromRGB(200, 160, 230),
		TabTextActive = Color3.fromRGB(255, 255, 255),
		TabBgActive = Color3.fromRGB(60, 40, 80),
	}, 91692116526196)

	-- Tung Tung Sahur Theme (Brownish)
	addTheme("🏏 Tung Tung Sahur", {
		TextDisabled = Color3.fromRGB(200, 180, 160),
		Text = Color3.fromRGB(255, 240, 220),

		FrameBg = Color3.fromRGB(70, 50, 40),
		FrameBgTransparency = 0.3,
		FrameBgActive = Color3.fromRGB(180, 150, 120),
		FrameBgTransparencyActive = 0.3,

		CheckMark = Color3.fromRGB(220, 180, 140),
		SliderGrab = Color3.fromRGB(220, 180, 140),
		ButtonsBg = Color3.fromRGB(220, 180, 140),
		CollapsingHeaderBg = Color3.fromRGB(220, 180, 140),
		CollapsingHeaderText = Color3.fromRGB(255, 240, 220),
		RadioButtonHoveredBg = Color3.fromRGB(220, 180, 140),

		WindowBg = Color3.fromRGB(80, 60, 45),
		TitleBarBg = Color3.fromRGB(80, 60, 45),
		TitleBarBgActive = Color3.fromRGB(110, 85, 65),

		Border = Color3.fromRGB(110, 85, 65),
		ResizeGrab = Color3.fromRGB(110, 85, 65),
		RegionBgTransparency = 1,

		TabText = Color3.fromRGB(30, 25, 20),
		TabBg = Color3.fromRGB(220, 190, 160),
		TabTextActive = Color3.fromRGB(255, 255, 255),
		TabBgActive = Color3.fromRGB(90, 65, 45),
	}, 85462826391722)

	-- Dark Theme
	addTheme("🌙 Dark", {
		TextDisabled = Color3.fromRGB(150, 150, 150),
		Text = Color3.fromRGB(255, 255, 255),

		FrameBg = Color3.fromRGB(40, 40, 40),
		FrameBgTransparency = 0.3,
		FrameBgActive = Color3.fromRGB(60, 60, 60),
		FrameBgTransparencyActive = 0.3,

		CheckMark = Color3.fromRGB(200, 200, 200),
		SliderGrab = Color3.fromRGB(200, 200, 200),
		ButtonsBg = Color3.fromRGB(200, 200, 200),
		CollapsingHeaderBg = Color3.fromRGB(200, 200, 200),
		CollapsingHeaderText = Color3.fromRGB(255, 255, 255),
		RadioButtonHoveredBg = Color3.fromRGB(200, 200, 200),

		WindowBg = Color3.fromRGB(30, 30, 30),
		TitleBarBg = Color3.fromRGB(30, 30, 30),
		TitleBarBgActive = Color3.fromRGB(45, 45, 45),

		Border = Color3.fromRGB(45, 45, 45),
		ResizeGrab = Color3.fromRGB(45, 45, 45),
		RegionBgTransparency = 1,

		TabText = Color3.fromRGB(255, 255, 255),
		TabBg = Color3.fromRGB(60, 60, 60),
		TabTextActive = Color3.fromRGB(255, 255, 255),
		TabBgActive = Color3.fromRGB(80, 80, 80),
	}, 18194506759)
end

function BaseLoader:_InitImGui()
	--warn("This is certainly interesting")

	local PrefabsId = "rbxassetid://" .. ImGui.PrefabsId
	local Prefabs = InsertService:LoadLocalAsset(PrefabsId)

	for _, v in Prefabs:GetDescendants() do
		if v:IsA("TextLabel") or v:IsA("TextButton") then
			v.RichText = true
		end
	end

	ImGui:Init({
		Prefabs = Prefabs,
	})
end

BaseLoader:_InitImGui()
BaseLoader:_InitThemes()

return BaseLoader
