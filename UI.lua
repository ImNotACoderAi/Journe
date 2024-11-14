local Utilities = {}

local Services = {
	UserInputService = game:GetService("UserInputService"),
	TweenService = game:GetService("TweenService"),
	HttpService = game:GetService("HttpService"),
	RunService = game:GetService("RunService"),
	CoreGui = game:GetService("CoreGui"),
	ReplicatedStorage = game:GetService("ReplicatedStorage"),
	Players = game:GetService("Players")
}

local Variables = {
	LocalPlayer = Services.Players.LocalPlayer,
	Mouse = Services.Players.LocalPlayer:GetMouse(),
	ViewPort = workspace.CurrentCamera.ViewportSize,
	Camera = workspace.CurrentCamera,
	DisableDragging = false,
	SettingsFileName = "UserSettings.json",
	ShouldReverse = true,
	Transitioning = false
}

local Saved = {}

function Utilities.Settings(defaults, options)
	options = options or {}

	local function deepCopy(orig)
		local copy
		if type(orig) == "table" then
			copy = {}
			for k, v in pairs(orig) do
				copy[k] = deepCopy(v)
			end
		else
			copy = orig
		end
		return copy
	end

	local mergedSettings = deepCopy(defaults)
	for k, v in pairs(options) do
		if defaults[k] ~= nil then  
			mergedSettings[k] = v
		end
	end
	return mergedSettings
end

function Utilities.Tween(object, Settings)
	Settings = Utilities.Settings({
		Goal = {},
		Duration = 0.15,
		Callback = function() end,
		EasingStyle = Enum.EasingStyle.Sine,
		EasingDirection = Enum.EasingDirection.Out
	}, Settings or {})
	assert(object and Settings.Goal, "Object and goal properties are required for tweening")

	local tweenInfo = TweenInfo.new(
		Settings.Duration,
		Settings.EasingStyle,
		Settings.EasingDirection
	)

	local tween = Services.TweenService:Create(object, tweenInfo, Settings.Goal)
	tween:Play()

	tween.Completed:Once(Settings.Callback)

	return tween
end

function Utilities.SaveSettings(settings)
	assert(type(settings) == "table", "Settings must be a table")

	local success, result = pcall(function()

		for k, v in pairs(settings) do
			Saved[k] = v
		end

		local jsonSettings = Services.HttpService:JSONEncode(Saved)

		if Services.RunService:IsStudio() then
			local settingsFolder = Services.ReplicatedStorage:FindFirstChild("UserSettings") 
				or Instance.new("Folder")
			settingsFolder.Name = "UserSettings"
			settingsFolder.Parent = Services.ReplicatedStorage

			local settingsValue = settingsFolder:FindFirstChild(Variables.LocalPlayer.UserId)
				or Instance.new("StringValue")
			settingsValue.Name = Variables.LocalPlayer.UserId
			settingsValue.Parent = settingsFolder
			settingsValue.Value = jsonSettings
		else
			if writefile then
				writefile(Variables.SettingsFileName, jsonSettings)
			else
				warn("File writing is not supported in this environment.")
			end
		end
	end)

	if not success then
		warn("Failed to save settings:", result)
	end
end

function Utilities.LoadSettings(settings)
	local success, result = pcall(function()
		local loadedSettings

		if Services.RunService:IsStudio() then
			local settingsFolder = Services.ReplicatedStorage:FindFirstChild("UserSettings")
			if settingsFolder then
				local settingsValue = settingsFolder:FindFirstChild(Variables.LocalPlayer.UserId)
				if settingsValue then
					loadedSettings = Services.HttpService:JSONDecode(settingsValue.Value)
				end
			end
		else
			if isfile and isfile(Variables.SettingsFileName) then
				local fileContent = readfile(Variables.SettingsFileName)
				loadedSettings = Services.HttpService:JSONDecode(fileContent)
			end
		end

		if loadedSettings then
			for k, v in pairs(loadedSettings) do
				Saved[k] = v
				settings[k] = v
			end
		end
	end)

	if not success then
		warn("Failed to load settings:", result)
	end
end

function Utilities.Dragify(frame, Visible)
	assert(frame:IsA("GuiObject"), "Frame must be a GuiObject")

	local dragging, dragInput, mousePosition, framePosition

	local function updateDrag(input)
		local delta = input.Position - mousePosition
		local newPosition = UDim2.new(
			framePosition.X.Scale,
			framePosition.X.Offset + delta.X,
			framePosition.Y.Scale,
			framePosition.Y.Offset + delta.Y
		)

		Utilities.Tween(frame, {
			Goal = {Position = newPosition},
			Duration = 0.05,
			EasingStyle = Enum.EasingStyle.Exponential,
			EasingDirection = Enum.EasingDirection.Out
		})
	end

	frame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 
			or input.UserInputType == Enum.UserInputType.Touch)
			and not Variables.DisableDragging and Visible.Visible == true then

			dragging = true
			mousePosition = input.Position
			framePosition = frame.Position

			if Services.UserInputService.TouchEnabled  and Visible.Visible == true then
				Services.UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
				Services.UserInputService.ModalEnabled = true
				Variables.Camera.CameraType = Enum.CameraType.Scriptable
			end

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End  and Visible.Visible == true then
					dragging = false
					if Services.UserInputService.TouchEnabled then
						Services.UserInputService.MouseBehavior = Enum.MouseBehavior.Default
						Services.UserInputService.ModalEnabled = false
						Variables.Camera.CameraType = Enum.CameraType.Custom
					end
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch 
			or input.UserInputType == Enum.UserInputType.MouseMovement and Visible.Visible == true then
			dragInput = input
		end
	end)

	Services.UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging and not Variables.DisableDragging and Visible.Visible == true then
			updateDrag(input)
		end
	end)
end

function Utilities.NewObject(className, properties)
	assert(type(className) == "string", "ClassName must be a string")
	assert(type(properties) == "table", "Properties must be a table")

	local success, result = pcall(function()
		local object = Instance.new(className)
		for property, value in pairs(properties) do
			object[property] = value
		end
		return object
	end)

	if success then
		return result
	else
		warn("Failed to create object:", result)
		return nil
	end
end

function Utilities.CreateCursor(frame, cursorId)
	assert(frame and cursorId, "Frame and cursorId are required")
	assert(frame:IsA("GuiObject"), "Frame must be a GuiObject")
	assert(type(cursorId) == "string" or type(cursorId) == "number", "CursorId must be a string or number")

	local cursor = Utilities.NewObject("ImageLabel", {
		Name = "CustomCursor-" .. cursorId,
		Size = UDim2.new(0, 20, 0, 20),
		BackgroundTransparency = 1,
		Image = "rbxassetid://" .. cursorId,
		Parent = frame.Parent,
		ZIndex = 2147483647
	})

	Services.RunService.RenderStepped:Connect(function()
		local mouse = Variables.Mouse
		local framePos = frame.AbsolutePosition
		local frameSize = frame.AbsoluteSize

		local isInFrame = mouse.X >= framePos.X 
			and mouse.X <= framePos.X + frameSize.X
			and mouse.Y >= framePos.Y 
			and mouse.Y <= framePos.Y + frameSize.Y
			and frame.Visible

		cursor.Visible = isInFrame
		Services.UserInputService.MouseIconEnabled = not isInFrame

		if isInFrame then
			cursor.Position = UDim2.new(
				0, mouse.X - framePos.X - 2,
				0, mouse.Y - framePos.Y - 2
			)
		end
	end)

	return cursor
end

function Utilities.Transition(frames, positionOffsetY, transparencyGoal, duration, transparencyDuration, delay, reverse)

	assert(frames and #frames > 0, "frames must be a non-empty array")

	duration = duration or 1
	transparencyDuration = transparencyDuration or 0.5
	delay = delay or 0.1

	local startIndex, endIndex, step
	if reverse then
		startIndex, endIndex, step = #frames, 1, -1
	else
		startIndex, endIndex, step = 1, #frames, 1
	end

	local animationComplete = Instance.new("BindableEvent")
	local framesCompleted = 0

	for i = startIndex, endIndex, step do
		task.spawn(function()
			local frame = frames[i]
			task.wait(delay * math.abs(i - startIndex))

			Utilities.Tween(frame, {
				Goal = {
					Position = UDim2.new(
						frame.Position.X.Scale, 
						frame.Position.X.Offset, 
						positionOffsetY, 
						frame.Position.Y.Offset
					)
				},
				Duration = duration,
				EasingStyle = Enum.EasingStyle.Exponential,
				EasingDirection = Enum.EasingDirection.Out
			})

			Utilities.Tween(frame, {
				Goal = { BackgroundTransparency = transparencyGoal },
				Duration = transparencyDuration,
				EasingStyle = Enum.EasingStyle.Linear,
				EasingDirection = Enum.EasingDirection.Out,
				Callback = function()
					framesCompleted = framesCompleted + 1
					if framesCompleted >= #frames then
						animationComplete:Fire()
					end
				end
			})
		end)
	end

	return animationComplete.Event
end

Journe = {
	Main = Utilities.NewObject("ScreenGui", {
		Parent = Services.RunService:IsStudio() and Variables.LocalPlayer:WaitForChild("PlayerGui") or Services.CoreGui,
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
		Name = "Journe",
		ResetOnSpawn = false,
		DisplayOrder = 2147483647,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	})
}

function Journe:CreateWindow(Settings)
	Settings = Utilities.Settings({
		Title = "Journe Demo",
		Description = "Baseplate - Test",
		ToggleBind = "RightShift"
	}, Settings or {})

	Utilities.LoadSettings(Settings)

	local Interface = {
		Activetab = nil,
		InputHandler = {
			Settings = {
				Hover = false
			},

			Bind = {
				Hover = false,
				Binding = false,
			}
		}
	}

	do
		do
			Interface.Core = Utilities.NewObject("Frame", {
				Parent = Journe.Main,
				Name = "Core",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = Services.UserInputService.TouchEnabled and UDim2.new(0, 553, 0, 384) or UDim2.new(0, 679, 0, 526),
				Position = UDim2.new(0.4, 0, 0.5, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.Interface = Utilities.NewObject("Frame", {
				Parent = Interface.Core,
				Name = "Interface",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(16, 16, 16),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.BorderCorner = Utilities.NewObject("UICorner", {
				Parent = Interface.Interface,
				Name = "BorderCorner",
				CornerRadius = UDim.new(0, 6)
			})

			Interface.MainView = Utilities.NewObject("Frame", {
				Parent = Interface.Interface,
				Name = "MainView",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.Main = Utilities.NewObject("Frame", {
				Parent = Interface.MainView,
				Name = "Main",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ClipsDescendants = true,
				Size = UDim2.new(1, -180, 1, -45),
				Position = UDim2.new(0, 180, 0, 45),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.MainPadding = Utilities.NewObject("UIPadding", {
				Parent = Interface.Main,
				Name = "MainPadding",
				PaddingTop = UDim.new(0, 15),
				PaddingRight = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10)
			})

			Interface.Navigation = Utilities.NewObject("Frame", {
				Parent = Interface.MainView,
				Name = "Navigation",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ClipsDescendants = true,
				Size = UDim2.new(0, 180, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.Seperator = Utilities.NewObject("Frame", {
				Parent = Interface.Navigation,
				Name = "Seperator",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				AnchorPoint = Vector2.new(1, 0),
				Size = UDim2.new(0, 2, 1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.Title = Utilities.NewObject("Frame", {
				Parent = Interface.Navigation,
				Name = "Title",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, 0, 0, 45),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.Seperator = Utilities.NewObject("Frame", {
				Parent = Interface.Title,
				Name = "Seperator",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				Size = UDim2.new(1, 0, 0, 2),
				Position = UDim2.new(0, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.Text = Utilities.NewObject("TextLabel", {
				Parent = Interface.Title,
				Name = "Text",
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 15,
				FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 40),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = Settings.Title
			})

			Interface.TextPadding = Utilities.NewObject("UIPadding", {
				Parent = Interface.Text,
				Name = "TextPadding",
				PaddingTop = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 10)
			})

			Interface.Description = Utilities.NewObject("TextLabel", {
				Parent = Interface.Text,
				Name = "Description",
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 10,
				FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				TextColor3 = Color3.fromRGB(45, 45, 45),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 40),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = Settings.Description
			})

			Interface.DescriptionPadding = Utilities.NewObject("UIPadding", {
				Parent = Interface.Description,
				Name = "DescriptionPadding",
				PaddingTop = UDim.new(0, 15),
				PaddingLeft = UDim.new(0, 1)
			})

			Interface.Buttons = Utilities.NewObject("ScrollingFrame", {
				Parent = Interface.Navigation,
				Name = "Buttons",
				Active = true,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, 0, 1, -45),
				ScrollBarImageColor3 = Color3.fromRGB(109, 109, 109),
				Position = UDim2.new(0, 0, 0, 45),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				ScrollBarThickness = 0,
				BackgroundTransparency = 1
			})

			Interface.TopBar = Utilities.NewObject("Frame", {
				Parent = Interface.MainView,
				Name = "TopBar",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, -180, 0, 45),
				Position = UDim2.new(0, 180, 0, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.Seperator = Utilities.NewObject("Frame", {
				Parent = Interface.TopBar,
				Name = "Seperator",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				Size = UDim2.new(1, 0, 0, 2),
				Position = UDim2.new(0, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.SettingsIcon = Utilities.NewObject("ImageLabel", {
				Parent = Interface.TopBar,
				Name = "Settings",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ScaleType = Enum.ScaleType.Fit,
				ImageColor3 = Color3.fromRGB(109, 109, 109),
				AnchorPoint = Vector2.new(1, 0.5),
				Image = "rbxassetid://120427186698913",
				Size = UDim2.new(0, 14, 0, 14),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -15, 0.5, 0)
			})

			Interface.CurrentTab = Utilities.NewObject("TextLabel", {
				Parent = Interface.TopBar,
				Name = "CurrentTab",
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 14,
				FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
				TextColor3 = Color3.fromRGB(109, 109, 109),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = "Preview"
			})

			Interface.CurrentTabPadding = Utilities.NewObject("UIPadding", {
				Parent = Interface.CurrentTab,
				Name = "CurrentTabPadding",
				PaddingTop = UDim.new(0, 1),
				PaddingLeft = UDim.new(0, 15)
			})

			Interface.DropShadowHolder = Utilities.NewObject("Frame", {
				Parent = Interface.Core,
				Name = "DropShadowHolder",
				ZIndex = 0,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BackgroundTransparency = 1
			})

			Interface.DropShadow = Utilities.NewObject("ImageLabel", {
				Parent = Interface.DropShadowHolder,
				Name = "DropShadow",
				ZIndex = 0,
				BorderSizePixel = 0,
				SliceCenter = Rect.new(49, 49, 450, 450),
				ScaleType = Enum.ScaleType.Slice,
				ImageTransparency = 0.5,
				ImageColor3 = Color3.fromRGB(0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = "rbxassetid://6014261993",
				Size = UDim2.new(1.06922, 0, 1.08935, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0.5, 0)
			})
		end

		do
			Interface.SettingsView = Utilities.NewObject("Frame", {
				Parent = Interface.Interface,
				Name = "SettingsView",
				Visible = false,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(16, 16, 16),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.TopBarAlternate = Utilities.NewObject("Frame", {
				Parent = Interface.SettingsView,
				Name = "TopBarAlternate",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, 0, 0, 45),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.SeperatorAlternate = Utilities.NewObject("Frame", {
				Parent = Interface.TopBarAlternate,
				Name = "SeperatorAlternate",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				Size = UDim2.new(1, 0, 0, 2),
				Position = UDim2.new(0, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.SettingsIconAlternate = Utilities.NewObject("ImageLabel", {
				Parent = Interface.TopBarAlternate,
				Name = "SettingsIconAlternate",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ScaleType = Enum.ScaleType.Fit,
				ImageColor3 = Color3.fromRGB(109, 109, 109),
				AnchorPoint = Vector2.new(1, 0.5),
				Image = "rbxassetid://120427186698913",
				Size = UDim2.new(0, 14, 0, 14),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -15, 0.5, 0)
			})

			Interface.CurrentTabAlternate = Utilities.NewObject("TextLabel", {
				Parent = Interface.TopBarAlternate,
				Name = "CurrentTabAlternate",
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 14,
				FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
				TextColor3 = Color3.fromRGB(109, 109, 109),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = "Interface Settings"
			})

			Interface.CurrentTabPaddingAlternate = Utilities.NewObject("UIPadding", {
				Parent = Interface.CurrentTabAlternate,
				Name = "CurrentTabPaddingAlternate",
				PaddingTop = UDim.new(0, 1),
				PaddingLeft = UDim.new(0, 15)
			})

			Interface.MainAlternate = Utilities.NewObject("Frame", {
				Parent = Interface.SettingsView,
				Name = "MainAlternate",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, 0, 1, -45),
				Position = UDim2.new(0, 0, 0, 45),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.GeneralAlternate = Utilities.NewObject("Frame", {
				Parent = Interface.MainAlternate,
				Name = "GeneralAlternate",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(21, 21, 21),
				Size = UDim2.new(0, 240, 0, 116),
				Position = UDim2.new(0, 20, 0, 30),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.GroupCornerAlternate = Utilities.NewObject("UICorner", {
				Parent = Interface.GeneralAlternate,
				Name = "GroupCornerAlternate",

			})

			Interface.GroupStrokeAlternate = Utilities.NewObject("UIStroke", {
				Parent = Interface.GeneralAlternate,
				Name = "GroupStrokeAlternate",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(25, 25, 25)
			})

			Interface.TitleAlternate = Utilities.NewObject("TextLabel", {
				Parent = Interface.GeneralAlternate,
				Name = "TitleAlternate",
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 14,
				FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
				TextColor3 = Color3.fromRGB(201, 201, 201),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 25),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = "General Settings",
				Position = UDim2.new(0, 0, 0, 5)
			})

			Interface.TitlePaddingAlternate = Utilities.NewObject("UIPadding", {
				Parent = Interface.TitleAlternate,
				Name = "TitlePaddingAlternate",
				PaddingLeft = UDim.new(0, 10)
			})

			Interface.ItemsAlternate = Utilities.NewObject("Frame", {
				Parent = Interface.GeneralAlternate,
				Name = "ItemsAlternate",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, -20, 1, -45),
				Position = UDim2.new(0, 10, 0, 35),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.ToggleAlternate = Utilities.NewObject("TextLabel", {
				Parent = Interface.ItemsAlternate,
				Name = "ToggleAlternate",
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 12,
				FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
				TextColor3 = Color3.fromRGB(81, 81, 81),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 30),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = "Translucent"
			})

			Interface.TogglePaddingAlternate = Utilities.NewObject("UIPadding", {
				Parent = Interface.ToggleAlternate,
				Name = "TogglePaddingAlternate",
				PaddingRight = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 10)
			})

			Interface.StateAlternate = Utilities.NewObject("Frame", {
				Parent = Interface.ToggleAlternate,
				Name = "StateAlternate",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(32, 32, 32),
				AnchorPoint = Vector2.new(1, 0.5),
				ClipsDescendants = true,
				Size = UDim2.new(0, 30, 0, 16),
				Position = UDim2.new(1, 0, 0.5, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.StateCornerAlternate = Utilities.NewObject("UICorner", {
				Parent = Interface.StateAlternate,
				Name = "StateCornerAlternate",
				CornerRadius = UDim.new(0, 10)
			})

			Interface.ToggleAlternate = Utilities.NewObject("Frame", {
				Parent = Interface.StateAlternate,
				Name = "ToggleAlternate",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(62, 62, 62),
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(0, 10, 0, 10),
				Position = UDim2.new(0, 3, 0.5, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.ToggleCornerAlternate = Utilities.NewObject("UICorner", {
				Parent = Interface.ToggleAlternate,
				Name = "ToggleCornerAlternate",
				CornerRadius = UDim.new(0, 10)
			})

			Interface.KeyBindAlternate = Utilities.NewObject("TextLabel", {
				Parent = Interface.ItemsAlternate,
				Name = "KeyBindAlternate",
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 12,
				FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
				TextColor3 = Color3.fromRGB(127, 127, 127),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 30),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = "Open / Close",
				Position = UDim2.new(-0.02797, 0, 0.7, 0)
			})

			Interface.KeybindPaddingAlternate = Utilities.NewObject("UIPadding", {
				Parent = Interface.KeyBindAlternate,
				Name = "KeybindPaddingAlternate",
				PaddingRight = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 10)
			})

			Interface.BindAlternate = Utilities.NewObject("Frame", {
				Parent = Interface.KeyBindAlternate,
				Name = "BindAlternate",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(32, 32, 32),
				AnchorPoint = Vector2.new(1, 0.5),
				Size = UDim2.new(0, 50, 0, 15),
				Position = UDim2.new(1, 0, 0.5, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.BindCornerAlternate = Utilities.NewObject("UICorner", {
				Parent = Interface.BindAlternate,
				Name = "BindCornerAlternate",
				CornerRadius = UDim.new(0, 4)
			})

			Interface.BindStrokeAlternate = Utilities.NewObject("UIStroke", {
				Parent = Interface.BindAlternate,
				Name = "BindStrokeAlternate",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(36, 36, 36)
			})

			Interface.ValueAlternate = Utilities.NewObject("TextLabel", {
				Parent = Interface.BindAlternate,
				Name = "ValueAlternate",
				TextWrapped = true,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 10,
				FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				TextColor3 = Color3.fromRGB(136, 136, 136),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = Settings.ToggleBind
			})

			Interface.ItemsLayoutAlternate = Utilities.NewObject("UIListLayout", {
				Parent = Interface.ItemsAlternate,
				Name = "ItemsLayoutAlternate",
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			Interface.ButtonsPadding = Utilities.NewObject("UIPadding", {
				Parent = Interface.Buttons,
				Name = "ButtonsPadding",
				PaddingTop = UDim.new(0, 15),
				PaddingLeft = UDim.new(0, 10)
			})

			Interface.ButtonsLayout = Utilities.NewObject("UIListLayout", {
				Parent = Interface.Buttons,
				Name = "ButtonsPadding",
				Padding = UDim.new(0, 10),
			})
		end
		
		do
			Interface.Transition = Utilities.NewObject("CanvasGroup", {
				Parent = Interface.Core,
				Name = "Transition",
				ZIndex = 59,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.TransitionCorner = Utilities.NewObject("UICorner", {
				Parent = Interface.Transition,
				Name = "TransitionCorner",
				CornerRadius = UDim.new(0, 6)
			})

			-- Create transition groups 1-12 in order
			for i = 1, 12 do
				local position = i == 1 and 0 or (i - 1) * 60

				Interface["TransitionGroup" .. i] = Utilities.NewObject("Frame", {
					Parent = Interface.Transition,
					Name = "TransitionGroup" .. i,
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(18, 18, 18),
					Size = UDim2.new(0, 60, 1, 0),
					Position = UDim2.new(0, position, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					LayoutOrder = 1,
					BackgroundTransparency = 1
				})

				Interface["FrameTop" .. i] = Utilities.NewObject("Frame", {
					Parent = Interface["TransitionGroup" .. i],
					Name = "FrameTop" .. i,
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(18, 18, 18),
					Size = UDim2.new(0, 60, 0.5, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0)
				})

				Interface["FrameBottom" .. i] = Utilities.NewObject("Frame", {
					Parent = Interface["TransitionGroup" .. i],
					Name = "FrameBottom" .. i,
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(18, 18, 18),
					Size = UDim2.new(0, 60, 0.5, 0),
					Position = UDim2.new(0, 0, 0.5, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0)
				})
			end
			
			Interface.framesTop = {}
			Interface.framesBottom = {}

			for i = 1, 12 do
				table.insert(Interface.framesTop, Interface["FrameTop" .. i])
				table.insert(Interface.framesBottom, Interface["FrameBottom" .. i])
			end
		end

		do

			do

				do
					boundKey = Settings.ToggleBind

					Interface.BindAlternate.MouseEnter:Connect(function()
						Interface.InputHandler.Bind.Hover = true
					end)

					Interface.BindAlternate.MouseLeave:Connect(function()
						Interface.InputHandler.Bind.Hover = false
					end)

					Services.UserInputService.InputBegan:Connect(function(Input)
						if Interface.InputHandler.Bind.Binding then
							return
						end

						if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and Interface.InputHandler.Bind.Hover then
							Interface.InputHandler.Bind.Binding = true

							-- Handle the loading dots animation
							coroutine.wrap(function()
								local dots = ""
								while Interface.InputHandler.Bind.Binding do
									Interface.ValueAlternate.Text = dots
									dots = dots == "..." and "." or dots .. "."
									wait(0.5)
								end
							end)()

							Services.UserInputService.InputBegan:Wait()

							local keyConnection
							keyConnection = Services.UserInputService.InputBegan:Connect(function(input)
								if Interface.InputHandler.Bind.Binding == true and input.UserInputType == Enum.UserInputType.Keyboard then
									local keyName = input.KeyCode.Name

									Interface.InputHandler.Bind.Binding = false
									Interface.ValueAlternate.Text = keyName
									boundKey = keyName

									Services.RunService.RenderStepped:Connect(function()
										Interface.BindAlternate.Size = UDim2.new(0, Interface.ValueAlternate.TextBounds.X + 10, 0, 15)
									end)

									keyConnection:Disconnect()
								end
							end)
						end
					end)

					Services.UserInputService.InputBegan:Connect(function(input)
						if Interface.InputHandler.Bind.Binding then
							return
						end

						if input.UserInputType == Enum.UserInputType.Keyboard then
							if boundKey and input.KeyCode.Name == boundKey then
								if Variables.Transitioning == true then
									return
								end
								
								task.spawn(function()
									if Variables.Transitioning == true then
										return
									end
									
									Variables.Transitioning = true

									local showTop = Utilities.Transition(Interface.framesTop, 0, 0, 1, 0.5, 0.1, Variables.ShouldReverse)
									local showBottom = Utilities.Transition(Interface.framesBottom, 0.5, 0, 1, 0.5, 0.1, Variables.ShouldReverse)

									local connections = {}
									local completed = 0
									for _, event in ipairs({showTop, showBottom}) do
										table.insert(connections, event:Connect(function()
											completed = completed + 1
											if completed >= 2 then

												Interface.Interface.Visible = not Interface.Interface.Visible
												Interface.DropShadowHolder.Visible = not Interface.DropShadowHolder.Visible

												for _, connection in ipairs(connections) do
													connection:Disconnect()
												end

												task.wait(0.05)

												Utilities.Transition(Interface.framesTop, -0.5, 0, 1, 0.5, 0.1, not Variables.ShouldReverse)
												Utilities.Transition(Interface.framesBottom, 1, 0, 1, 0.5, 0.1, not Variables.ShouldReverse)
											end
										end))
									end
									
									Variables.ShouldReverse = not Variables.ShouldReverse
									
									task.wait(3)
									Variables.Transitioning = false
								end)
							end
						end
					end)
				end

				do
					Interface.SettingsIconAlternate.MouseEnter:Connect(function()
						Interface.InputHandler.Settings.Hover = true
						Utilities.Tween(Interface.SettingsIconAlternate, {
							Goal = {ImageColor3 = Color3.fromRGB(209, 209, 209)},
							Duration = 0.12
						})
					end)

					Interface.SettingsIconAlternate.MouseLeave:Connect(function()
						Interface.InputHandler.Settings.Hover = false
						Utilities.Tween(Interface.SettingsIconAlternate, {
							Goal = {ImageColor3 = Color3.fromRGB(109, 109, 109)},
							Duration = 0.12
						})
					end)

					Interface.SettingsIcon.MouseEnter:Connect(function()
						Interface.InputHandler.Settings.Hover = true
						Utilities.Tween(Interface.SettingsIcon, {
							Goal = {ImageColor3 = Color3.fromRGB(209, 209, 209)},
							Duration = 0.12
						})
					end)

					Interface.SettingsIcon.MouseLeave:Connect(function()
						Interface.InputHandler.Settings.Hover = false
						Utilities.Tween(Interface.SettingsIcon, {
							Goal = {ImageColor3 = Color3.fromRGB(109, 109, 109)},
							Duration = 0.12
						})
					end)
					
					task.spawn(function()
						Variables.Transitioning = true
						
						task.spawn(function()
							Utilities.Transition(Interface.framesTop, -0.5, 1, 1, 0.5, 0.1, true)
						end)
						task.spawn(function()
							Utilities.Transition(Interface.framesBottom, 1, 1, 1, 0.5, 0.1, true)
						end)
						
						Variables.ShouldReverse = not Variables.ShouldReverse
						task.wait(3)
						Variables.Transitioning = false
					end)

					Services.UserInputService.InputBegan:Connect(function(Input)
						if (Input.UserInputType == Enum.UserInputType.MouseButton1 or 
							Input.UserInputType == Enum.UserInputType.Touch) and 
							Interface.InputHandler.Settings.Hover then
							
							if Variables.Transitioning == true then
								return
							end
							
							task.spawn(function()
								if Variables.Transitioning == true then
									return
								end
								
								Variables.Transitioning = true
								
								local showTop = Utilities.Transition(Interface.framesTop, 0, 0, 1, 0.5, 0.1, Variables.ShouldReverse)
								local showBottom = Utilities.Transition(Interface.framesBottom, 0.5, 0, 1, 0.5, 0.1, Variables.ShouldReverse)

								local connections = {}
								local completed = 0
								for _, event in ipairs({showTop, showBottom}) do
									table.insert(connections, event:Connect(function()
										completed = completed + 1
										if completed >= 2 then

											Interface.SettingsView.Visible = not Interface.SettingsView.Visible
											Interface.MainView.Visible = not Interface.MainView.Visible

											for _, connection in ipairs(connections) do
												connection:Disconnect()
											end

											task.wait(0.05)

											Utilities.Transition(Interface.framesTop, -0.5, 0, 1, 0.5, 0.1, not Variables.ShouldReverse)
											Utilities.Transition(Interface.framesBottom, 1, 0, 1, 0.5, 0.1, not Variables.ShouldReverse)
										end
									end))
								end
								
								Variables.ShouldReverse = not Variables.ShouldReverse
								task.wait(3)
								Variables.Transitioning = false
							end)
						end
					end)
				end
			end

			Utilities.Dragify(Interface.Core, Interface.Interface)
			Utilities.CreateCursor(Interface.Interface, 128944823463663)
		end
	end

	function Interface:CreateTab(Settings)
		Settings = Utilities.Settings({
			Title = "Demo",
			Callback = function() end
		}, Settings or {})

		local Tab = {
			Hover = false,
			Active = false,
			GroupIndex = 0
		}

		local index

		do
			Tab.TabBtn = Utilities.NewObject("Frame", {
				Parent = Interface.Buttons,
				Name = "TabBtn",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(21, 21, 21),
				Size = UDim2.new(1, -10, 0, 30),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Tab.TabBtnStroke = Utilities.NewObject("UIStroke", {
				Parent = Tab.TabBtn,
				Name = "TabBtnStroke",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(25, 25, 25)
			})

			Tab.TabBtnCorner = Utilities.NewObject("UICorner", {
				Parent = Tab.TabBtn,
				Name = "TabBtnCorner",

			})

			Tab.Textx = Utilities.NewObject("TextLabel", {
				Parent = Tab.TabBtn,
				Name = "Text",
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 14,
				FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
				TextColor3 = Color3.fromRGB(150, 150, 150),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = Settings.Title
			})

			Tab.TextPadding = Utilities.NewObject("UIPadding", {
				Parent = Tab.Textx,
				Name = "TextPadding",
				PaddingTop = UDim.new(0, 1),
				PaddingLeft = UDim.new(0, 10)
			})

			Tab.Tab = Utilities.NewObject("Frame", {
				Parent = Interface.Main,
				Name = "Tab",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				Visible = false
			})

			Tab.Groups = Utilities.NewObject("ScrollingFrame", {
				Parent = Tab.Tab,
				Name = "Groups",
				Active = true,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ClipsDescendants = false,
				Size = UDim2.new(1, 0, 1, 0),
				ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				ScrollBarThickness = 0,
				BackgroundTransparency = 1
			})

			do
				function Tab:DeactivateTab()
					if Tab.Active then
						Tab.Active = false
						Utilities.Tween(Tab.TabBtnStroke, {
							Goal = {Color = Color3.fromRGB(24, 24, 24)},
							Duration = 0.1,
							EasingSyle = Enum.EasingStyle.Exponential,
							EasingDirection = Enum.EasingDirection.In
						})
						Utilities.Tween(Tab.TabBtn, {
							Goal = {BackgroundColor3 = Color3.fromRGB(20, 20, 20)},
							Duration = 0.1,
							EasingSyle = Enum.EasingStyle.Exponential,
							EasingDirection = Enum.EasingDirection.In
						})
						Tab.Tab.Visible = false
					end
				end

				function Tab:ActivateTab()
					if not Tab.Active then
						if Interface.ActiveTab then
							Interface.ActiveTab:DeactivateTab()
						end

						Interface.CurrentTab.Text = Tab.Textx.Text
						Tab.Active = true
						Utilities.Tween(Tab.TabBtnStroke, {
							Goal = {Color = Color3.fromRGB(29, 29, 29)},
							Duration = 0.1,
							EasingSyle = Enum.EasingStyle.Exponential,
							EasingDirection = Enum.EasingDirection.In
						})
						Utilities.Tween(Tab.TabBtn, {
							Goal = {BackgroundColor3 = Color3.fromRGB(25, 25, 25)},
							Duration = 0.1,
							EasingSyle = Enum.EasingStyle.Exponential,
							EasingDirection = Enum.EasingDirection.In
						})
						Tab.Tab.Visible = true
						Interface.ActiveTab = Tab
					end
				end

				Tab.TabBtn.MouseEnter:Connect(function()
					Tab.Hover = true
					if not Tab.Active then
						Utilities.Tween(Tab.TabBtnStroke, {
							Goal = {Color = Color3.fromRGB(29, 29, 29)},
							Duration = 0.1,
							EasingSyle = Enum.EasingStyle.Exponential,
							EasingDirection = Enum.EasingDirection.In
						})
					end
				end)

				Tab.TabBtn.MouseLeave:Connect(function()
					Tab.Hover = false
					if not Tab.Active then
						Utilities.Tween(Tab.TabBtnStroke, {
							Goal = {Color = Color3.fromRGB(24, 24, 24)},
							Duration = 0.1,
							EasingSyle = Enum.EasingStyle.Exponential,
							EasingDirection = Enum.EasingDirection.In
						})
					end
				end)

				Services.UserInputService.InputBegan:Connect(function(Input)
					if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and Tab.Hover then
						Tab:ActivateTab()
						Settings.Callback()
						Utilities.Tween(Tab.TabBtnStroke, {
							Goal = {Color = Color3.fromRGB(29, 29, 29)},
							Duration = 0.1,
							EasingSyle = Enum.EasingStyle.Exponential,
							EasingDirection = Enum.EasingDirection.In
						})
					end
				end)

				if Interface.ActiveTab == nil then
					Tab:ActivateTab()
				end
			end
		end

		function Tab:AddGroup(Settings)
			Settings = Utilities.Settings({
				Title = "Demo"
			}, Settings or {})
			
			local Group = {
				SpacingX = 10,
				SpacingY = 10,
				MaxColumns = 2
			}

			Tab.GroupIndex = (Tab.GroupIndex or 0) + 1

			do
				Group.Group = Utilities.NewObject("Frame", {
					Parent = Tab.Groups,
					Name = "Group",
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(21, 21, 21),
					Size = UDim2.new(0.5, -5, 0, 455),
					Position = UDim2.new(0.5, 5, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0)
				})

				Group.GroupCorner = Utilities.NewObject("UICorner", {
					Parent = Group.Group,
					Name = "GroupCorner",
				})

				Group.GroupStroke = Utilities.NewObject("UIStroke", {
					Parent = Group.Group,
					Name = "GroupStroke",
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(25, 25, 25)
				})

				Group.Title = Utilities.NewObject("TextLabel", {
					Parent = Group.Group,
					Name = "Title",
					BorderSizePixel = 0,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 14,
					FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
					TextColor3 = Color3.fromRGB(201, 201, 201),
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 25),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = Settings.Title,
					Position = UDim2.new(0, 0, 0, 5)
				})

				Group.TitlePadding = Utilities.NewObject("UIPadding", {
					Parent = Group.Title,
					Name = "TitlePadding",
					PaddingLeft = UDim.new(0, 10)
				})

				Group.Items = Utilities.NewObject("Frame", {
					Parent = Group.Group,
					Name = "Items",
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Size = UDim2.new(1, -20, 1, -45),
					Position = UDim2.new(0, 10, 0, 35),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1
				})

				Group.ItemsLayout = Utilities.NewObject("UIListLayout", {
					Parent = Group.Items,
					Name = "ItemsLayout",
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder
				})

				do
					function Group:UpdatePosition()
						if Tab.GroupIndex % 2 == 0 then
							Group.Group.Position = UDim2.new(0, 234 + Group.SpacingX, 0, 0)
						else
							Group.Group.Position = UDim2.new(0, 0, 0, 0)
						end

						if Tab.GroupIndex > 2 then
							local prevGroupsInColumn = {}

							for i = 1, Tab.GroupIndex - 1 do
								if Tab.Groups:FindFirstChild("Group" .. i) and (i - 1) % 2 == (Tab.GroupIndex - 1) % 2 then
									table.insert(prevGroupsInColumn, Tab.Groups:FindFirstChild("Group" .. i))
								end
							end

							local posY = 0
							for _, prevGroup in ipairs(prevGroupsInColumn) do
								posY = posY + prevGroup.Size.Y.Offset
							end

							if #prevGroupsInColumn > 0 then
								posY = posY + (Group.SpacingY * #prevGroupsInColumn)
							end

							Group.Group.Position = UDim2.new(0, Group.Group.Position.X.Offset, 0, posY)
						end

						Group.Group.Name = "Group" .. Tab.GroupIndex
					end

					function Group:UpdateSize()
						local Height = 45
						local Elements = 0

						for _, v in pairs(Group.Items:GetChildren()) do
							if v.Name == "Button" then
								Height += 35
								Elements += 1
							elseif v.Name == "Slider" then
								Height += 35
								Elements += 1
							elseif v.Name == "ColorPicker" then
								Height += 35
								Elements += 1
							end
						end

						Group.Group.Size = UDim2.new(0, 234, 0, Elements == 1 and Height - 5 or Height)

						for i = 1, Tab.GroupIndex do
							if Tab.Groups:FindFirstChild("Group" .. i) then
								if i % 2 == 0 then
									Tab.Groups:FindFirstChild("Group" .. i).Position = UDim2.new(0, 234 + Group.SpacingX, 0, 0)
								else
									Tab.Groups:FindFirstChild("Group" .. i).Position = UDim2.new(0, 0, 0, 0)
								end

								if i > 2 then
									local prevGroupsInColumn = {}
									for j = 1, i - 1 do
										if Tab.Groups:FindFirstChild("Group" .. j) and (j - 1) % 2 == (i - 1) % 2 then
											table.insert(prevGroupsInColumn, Tab.Groups:FindFirstChild("Group" .. j))
										end
									end

									local posY = 0
									for _, prevGroup in ipairs(prevGroupsInColumn) do
										posY = posY + prevGroup.Size.Y.Offset
									end

									if #prevGroupsInColumn > 0 then
										posY = posY + (Group.SpacingY * #prevGroupsInColumn)
									end

									Tab.Groups:FindFirstChild("Group" .. i).Position = UDim2.new(0, Tab.Groups:FindFirstChild("Group" .. i).Position.X.Offset, 0, posY)
								end
							end
						end
					end
					
					Group:UpdateSize()
					Group:UpdatePosition()
				end
			end
			
			function Group:AddButton(Settings)
				Settings = Utilities.Settings({
					Title = "Button",
					Callback = function() end
				}, Settings or {})
				
				local Button = {
					Hover = false,
					MouseDown = false
				}
				
				do
					Button.Button = Utilities.NewObject("TextLabel", {
						Parent = Group.Items,
						Name = "Button",
						BorderSizePixel = 0,
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 12,
						FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
						TextColor3 = Color3.fromRGB(127, 127, 127),
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 30),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Text = "Button"
					})

					Button.ButtonPadding = Utilities.NewObject("UIPadding", {
						Parent = Button.Button,
						Name = "ButtonPadding",
						PaddingRight = UDim.new(0, 10),
						PaddingLeft = UDim.new(0, 10)
					})

					Button.Icon = Utilities.NewObject("ImageLabel", {
						Parent = Button.Button,
						Name = "Icon",
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						ImageColor3 = Color3.fromRGB(127, 127, 127),
						AnchorPoint = Vector2.new(1, 0.5),
						Image = "rbxassetid://125293628617993",
						Size = UDim2.new(0, 12, 0, 12),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, 0, 0.5, 0)
					})
					
					do
						
						
						Group:UpdateSize()
					end
				end
				
				return Button
			end
			function Group:AddInput(Settings)
				Settings = Utilities.Settings({
					Title = "Demo",
					Callback = function() end
				}, Settings or {})
			end
			function Group:AddSlider(Settings)
				Settings = Utilities.Settings({
					Title = "Demo",
					Callback = function() end
				}, Settings or {})
			end
			function Group:AddToggle(Settings)
				Settings = Utilities.Settings({
					Title = "Demo",
					Callback = function() end
				}, Settings or {})
			end
			function Group:AddKeybind(Settings)
				Settings = Utilities.Settings({
					Title = "Demo",
					Callback = function() end
				}, Settings or {})
			end
			return Group
		end
		return Tab	
	end
	return Interface
end

local ss = Journe:CreateWindow()
local n2nd = ss:CreateTab()
ss:CreateTab({
	Title = "UnDemo"
})
local pp = n2nd:AddGroup()
n2nd:AddGroup()
n2nd:AddGroup()
pp:AddButton()

return Journe, Utilities
