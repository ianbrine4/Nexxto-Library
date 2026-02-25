local UILibrary = {}
UILibrary.__index = UILibrary

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function Create(instanceType, properties)
	local instance = Instance.new(instanceType)
	for property, value in pairs(properties) do
		instance[property] = value
	end
	return instance
end

local function Tween(instance, properties, duration, easingStyle, easingDirection)
	local tween = TweenService:Create(instance, TweenInfo.new(duration or 0.3, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out), properties)
	tween:Play()
	return tween
end

local function MakeDraggable(frame, handle)
	local dragging = false
	local dragInput, dragStart, startPos
	
	handle = handle or frame
	
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

local Theme = {
	Background = Color3.fromRGB(25, 25, 25),
	Secondary = Color3.fromRGB(35, 35, 35),
	Tertiary = Color3.fromRGB(45, 45, 45),
	Text = Color3.fromRGB(255, 255, 255),
	TextDark = Color3.fromRGB(175, 175, 175),
	Accent = Color3.fromRGB(255, 255, 255),
	Line = Color3.fromRGB(50, 50, 50),
	Highlight = Color3.fromRGB(255, 255, 255),
	ToggleOn = Color3.fromRGB(0, 255, 128),
	ToggleOff = Color3.fromRGB(60, 60, 60)
}

function UILibrary.new(config)
	local self = setmetatable({}, UILibrary)
	
	config = config or {}
	self.Title = config.name or config.title or "UI Library"
	self.Subtitle = config.subtitle or "v1.0"
	self.Size = config.size or {width = 600, height = 450}
	self.IconText = config.text or "UI"
	self.Tabs = {}
	self.ActiveTab = nil
	self.Components = {}
	self.Notifications = {}
	self.IsOpen = true
	self.LastPosition = UDim2.new(0.5, -(self.Size.width / 2), 0.5, -(self.Size.height / 2))
	
	self:CreateMainWindow()
	self:CreateDraggableIcon()
	self:CreateConfirmationModal()
	self:StartPingUpdater()
	self:StartTimeUpdater()
	
	return self
end

function UILibrary:CreateMainWindow()
	self.ScreenGui = Create("ScreenGui", {
		Name = "UILibrary",
		Parent = game.CoreGui,
		ResetOnSpawn = false,
		Enabled = true
	})
	
	self.MainFrame = Create("Frame", {
		Name = "MainFrame",
		Parent = self.ScreenGui,
		Size = UDim2.new(0, self.Size.width, 0, self.Size.height),
		Position = self.LastPosition,
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		ClipsDescendants = true
	})
	
	Tween(self.MainFrame, {Size = UDim2.new(0, self.Size.width, 0, self.Size.height)}, 0.4, Enum.EasingStyle.Back)
	
	local Corner = Create("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = self.MainFrame
	})
	
	local Shadow = Create("ImageLabel", {
		Name = "Shadow",
		Parent = self.MainFrame,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 4),
		Size = UDim2.new(1, 20, 1, 20),
		BackgroundTransparency = 1,
		Image = "rbxassetid://5554236805",
		ImageColor3 = Color3.fromRGB(0, 0, 0),
		ImageTransparency = 0.6,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(23, 23, 277, 277),
		ZIndex = -1
	})
	
	self:CreateHeader()
	self:CreateSidebar()
	self:CreateContentArea()
	
	MakeDraggable(self.MainFrame)
end

function UILibrary:CreateHeader()
	local Header = Create("Frame", {
		Name = "Header",
		Parent = self.MainFrame,
		Size = UDim2.new(1, 0, 0, 110),
		BackgroundColor3 = Theme.Secondary,
		BorderSizePixel = 0
	})
	
	local TopBar = Create("Frame", {
		Name = "TopBar",
		Parent = Header,
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundTransparency = 1
	})
	
	local TitleLabel = Create("TextLabel", {
		Name = "Title",
		Parent = TopBar,
		Size = UDim2.new(1, -120, 0, 25),
		Position = UDim2.new(0, 15, 0, 12),
		BackgroundTransparency = 1,
		Text = self.Title,
		TextColor3 = Theme.Text,
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	local SubtitleLabel = Create("TextLabel", {
		Name = "Subtitle",
		Parent = TopBar,
		Size = UDim2.new(1, -120, 0, 18),
		Position = UDim2.new(0, 15, 0, 32),
		BackgroundTransparency = 1,
		Text = self.Subtitle,
		TextColor3 = Theme.TextDark,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	self.PingLabel = Create("TextLabel", {
		Name = "Ping",
		Parent = TopBar,
		Size = UDim2.new(0, 60, 0, 20),
		Position = UDim2.new(1, -180, 0, 15),
		BackgroundTransparency = 1,
		Text = "0 ms",
		TextColor3 = Theme.TextDark,
		TextSize = 12,
		Font = Enum.Font.Gotham
	})
	
	local PingDot = Create("Frame", {
		Name = "PingDot",
		Parent = self.PingLabel,
		Size = UDim2.new(0, 6, 0, 6),
		Position = UDim2.new(0, -12, 0.5, -3),
		BackgroundColor3 = Color3.fromRGB(0, 255, 100),
		BorderSizePixel = 0
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = PingDot
	})
	
	local HideButton = Create("TextButton", {
		Name = "HideButton",
		Parent = TopBar,
		Size = UDim2.new(0, 28, 0, 28),
		Position = UDim2.new(1, -70, 0, 11),
		BackgroundColor3 = Theme.Tertiary,
		Text = "-",
		TextColor3 = Theme.Text,
		TextSize = 18,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = HideButton
	})
	
	HideButton.MouseEnter:Connect(function()
		Tween(HideButton, {BackgroundColor3 = Theme.Line}, 0.2)
	end)
	
	HideButton.MouseLeave:Connect(function()
		Tween(HideButton, {BackgroundColor3 = Theme.Tertiary}, 0.2)
	end)
	
	HideButton.MouseButton1Click:Connect(function()
		self:Minimize()
	end)
	
	local CloseButton = Create("TextButton", {
		Name = "CloseButton",
		Parent = TopBar,
		Size = UDim2.new(0, 28, 0, 28),
		Position = UDim2.new(1, -38, 0, 11),
		BackgroundColor3 = Theme.Tertiary,
		Text = "X",
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = CloseButton
	})
	
	CloseButton.MouseEnter:Connect(function()
		Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.2)
	end)
	
	CloseButton.MouseLeave:Connect(function()
		Tween(CloseButton, {BackgroundColor3 = Theme.Tertiary}, 0.2)
	end)
	
	CloseButton.MouseButton1Click:Connect(function()
		self:ShowConfirmation()
	end)
	
	local InfoBar = Create("Frame", {
		Name = "InfoBar",
		Parent = Header,
		Size = UDim2.new(1, 0, 0, 60),
		Position = UDim2.new(0, 0, 0, 50),
		BackgroundTransparency = 1
	})
	
	local AvatarImage = Create("ImageLabel", {
		Name = "Avatar",
		Parent = InfoBar,
		Size = UDim2.new(0, 40, 0, 40),
		Position = UDim2.new(0, 15, 0, 10),
		BackgroundColor3 = Theme.Tertiary,
		Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48),
		BorderSizePixel = 0
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = AvatarImage
	})
	
	local UsernameLabel = Create("TextLabel", {
		Name = "Username",
		Parent = InfoBar,
		Size = UDim2.new(0, 200, 0, 20),
		Position = UDim2.new(0, 65, 0, 10),
		BackgroundTransparency = 1,
		Text = LocalPlayer.DisplayName,
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	self.DateTimeLabel = Create("TextLabel", {
		Name = "DateTime",
		Parent = InfoBar,
		Size = UDim2.new(0, 200, 0, 15),
		Position = UDim2.new(0, 65, 0, 32),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = Theme.TextDark,
		TextSize = 11,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left
	})
end

function UILibrary:CreateSidebar()
	self.Sidebar = Create("Frame", {
		Name = "Sidebar",
		Parent = self.MainFrame,
		Size = UDim2.new(0, 140, 1, -110),
		Position = UDim2.new(0, 0, 0, 110),
		BackgroundColor3 = Theme.Secondary,
		BorderSizePixel = 0
	})
	
	local Separator = Create("Frame", {
		Name = "Separator",
		Parent = self.Sidebar,
		Size = UDim2.new(0, 1, 1, 0),
		Position = UDim2.new(1, -1, 0, 0),
		BackgroundColor3 = Theme.Line,
		BorderSizePixel = 0
	})
	
	self.TabContainer = Create("ScrollingFrame", {
		Name = "TabContainer",
		Parent = self.Sidebar,
		Size = UDim2.new(1, -1, 1, 0),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		AutomaticCanvasSize = Enum.AutomaticSize.Y
	})
	
	Create("UIListLayout", {
		Parent = self.TabContainer,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 1)
	})
	
	Create("UIPadding", {
		Parent = self.TabContainer,
		PaddingTop = UDim.new(0, 5),
		PaddingBottom = UDim.new(0, 5)
	})
end

function UILibrary:CreateContentArea()
	self.ContentFrame = Create("Frame", {
		Name = "Content",
		Parent = self.MainFrame,
		Size = UDim2.new(1, -140, 1, -110),
		Position = UDim2.new(0, 140, 0, 110),
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		ClipsDescendants = true
	})
end

function UILibrary:CreateDraggableIcon()
	self.IconGui = Create("ScreenGui", {
		Name = "UILibraryIcon",
		Parent = game.CoreGui,
		ResetOnSpawn = false,
		Enabled = false
	})
	
	self.IconButton = Create("TextButton", {
		Name = "Icon",
		Parent = self.IconGui,
		Size = UDim2.new(0, 50, 0, 50),
		Position = UDim2.new(0.5, -25, 0.5, -25),
		BackgroundColor3 = Theme.Secondary,
		Text = self.IconText,
		TextColor3 = Theme.Text,
		TextSize = 18,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		Active = true,
		Draggable = true
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = self.IconButton
	})
	
	local Shadow = Create("ImageLabel", {
		Name = "Shadow",
		Parent = self.IconButton,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 2),
		Size = UDim2.new(1, 10, 1, 10),
		BackgroundTransparency = 1,
		Image = "rbxassetid://5554236805",
		ImageColor3 = Color3.fromRGB(0, 0, 0),
		ImageTransparency = 0.7,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(23, 23, 277, 277),
		ZIndex = -1
	})
	
	self.IconButton.MouseEnter:Connect(function()
		Tween(self.IconButton, {Size = UDim2.new(0, 55, 0, 55), BackgroundColor3 = Theme.Tertiary}, 0.2)
	end)
	
	self.IconButton.MouseLeave:Connect(function()
		Tween(self.IconButton, {Size = UDim2.new(0, 50, 0, 50), BackgroundColor3 = Theme.Secondary}, 0.2)
	end)
	
	self.IconButton.MouseButton1Click:Connect(function()
		self:Open()
	end)
	
	MakeDraggable(self.IconButton)
end

function UILibrary:CreateConfirmationModal()
	self.ModalGui = Create("ScreenGui", {
		Name = "ConfirmationModal",
		Parent = game.CoreGui,
		ResetOnSpawn = false,
		Enabled = false
	})
	
	local Overlay = Create("Frame", {
		Name = "Overlay",
		Parent = self.ModalGui,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0
	})
	
	local ModalFrame = Create("Frame", {
		Name = "Modal",
		Parent = Overlay,
		Size = UDim2.new(0, 300, 0, 150),
		Position = UDim2.new(0.5, -150, 0.5, -75),
		BackgroundColor3 = Theme.Secondary,
		BorderSizePixel = 0
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = ModalFrame
	})
	
	local Title = Create("TextLabel", {
		Name = "Title",
		Parent = ModalFrame,
		Size = UDim2.new(1, 0, 0, 40),
		Position = UDim2.new(0, 0, 0, 10),
		BackgroundTransparency = 1,
		Text = "Confirm Close",
		TextColor3 = Theme.Text,
		TextSize = 18,
		Font = Enum.Font.GothamBold
	})
	
	local Message = Create("TextLabel", {
		Name = "Message",
		Parent = ModalFrame,
		Size = UDim2.new(1, -40, 0, 40),
		Position = UDim2.new(0, 20, 0, 50),
		BackgroundTransparency = 1,
		Text = "Are you sure you want to close the UI?",
		TextColor3 = Theme.TextDark,
		TextSize = 14,
		Font = Enum.Font.Gotham,
		TextWrapped = true
	})
	
	local ConfirmButton = Create("TextButton", {
		Name = "Confirm",
		Parent = ModalFrame,
		Size = UDim2.new(0, 120, 0, 35),
		Position = UDim2.new(0, 20, 1, -55),
		BackgroundColor3 = Color3.fromRGB(200, 50, 50),
		Text = "Confirm",
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = ConfirmButton
	})
	
	local DeclineButton = Create("TextButton", {
		Name = "Decline",
		Parent = ModalFrame,
		Size = UDim2.new(0, 120, 0, 35),
		Position = UDim2.new(1, -140, 1, -55),
		BackgroundColor3 = Theme.Tertiary,
		Text = "Decline",
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = DeclineButton
	})
	
	ConfirmButton.MouseEnter:Connect(function()
		Tween(ConfirmButton, {BackgroundColor3 = Color3.fromRGB(220, 70, 70)}, 0.2)
	end)
	
	ConfirmButton.MouseLeave:Connect(function()
		Tween(ConfirmButton, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.2)
	end)
	
	DeclineButton.MouseEnter:Connect(function()
		Tween(DeclineButton, {BackgroundColor3 = Theme.Line}, 0.2)
	end)
	
	DeclineButton.MouseLeave:Connect(function()
		Tween(DeclineButton, {BackgroundColor3 = Theme.Tertiary}, 0.2)
	end)
	
	ConfirmButton.MouseButton1Click:Connect(function()
		self:Close()
	end)
	
	DeclineButton.MouseButton1Click:Connect(function()
		self:HideConfirmation()
	end)
	
	Overlay.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and input.Target == Overlay then
			self:HideConfirmation()
		end
	end)
end

function UILibrary:ShowConfirmation()
	self.ModalGui.Enabled = true
	Tween(self.ModalGui.Overlay, {BackgroundTransparency = 0.5}, 0.2)
	Tween(self.ModalGui.Overlay.Modal, {Size = UDim2.new(0, 300, 0, 150)}, 0.3, Enum.EasingStyle.Back)
end

function UILibrary:HideConfirmation()
	Tween(self.ModalGui.Overlay.Modal, {Size = UDim2.new(0, 280, 0, 140)}, 0.2)
	Tween(self.ModalGui.Overlay, {BackgroundTransparency = 1}, 0.2).Completed:Connect(function()
		self.ModalGui.Enabled = false
	end)
end

function UILibrary:Minimize()
	self.LastPosition = self.MainFrame.Position
	local centerOffsetX = self.Size.width / 2
	local centerOffsetY = self.Size.height / 2
	Tween(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(self.LastPosition.X.Scale, self.LastPosition.X.Offset + centerOffsetX, self.LastPosition.Y.Scale, self.LastPosition.Y.Offset + centerOffsetY)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In).Completed:Connect(function()
		self.ScreenGui.Enabled = false
		self.IconGui.Enabled = true
		Tween(self.IconButton, {Size = UDim2.new(0, 50, 0, 50)}, 0.3, Enum.EasingStyle.Back)
	end)
	self.IsOpen = false
end

function UILibrary:Open()
	self.IconGui.Enabled = false
	self.ScreenGui.Enabled = true
	Tween(self.MainFrame, {Size = UDim2.new(0, self.Size.width, 0, self.Size.height), Position = self.LastPosition}, 0.4, Enum.EasingStyle.Back)
	self.IsOpen = true
end

function UILibrary:Close()
	self.ScreenGui:Destroy()
	self.IconGui:Destroy()
	self.ModalGui:Destroy()
end

function UILibrary:StartPingUpdater()
	task.spawn(function()
		while self.ScreenGui and self.ScreenGui.Parent do
			local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
			self.PingLabel.Text = ping .. " ms"
			
			local color = Color3.fromRGB(0, 255, 100)
			if ping > 100 then
				color = Color3.fromRGB(255, 255, 0)
			elseif ping > 200 then
				color = Color3.fromRGB(255, 100, 0)
			elseif ping > 300 then
				color = Color3.fromRGB(255, 0, 0)
			end
			
			self.PingLabel.PingDot.BackgroundColor3 = color
			task.wait(1)
		end
	end)
end

function UILibrary:StartTimeUpdater()
	task.spawn(function()
		while self.ScreenGui and self.ScreenGui.Parent do
			local dateStr = os.date("%B %d, %Y")
			local timeStr = os.date("%I:%M %p")
			self.DateTimeLabel.Text = dateStr .. " | " .. timeStr
			task.wait(1)
		end
	end)
end

function UILibrary:AddTab(name)
	local tab = {}
	tab.Name = name
	tab.Components = {}
	tab.Content = nil
	
	local TabButton = Create("TextButton", {
		Name = name .. "Tab",
		Parent = self.TabContainer,
		Size = UDim2.new(1, -5, 0, 32),
		BackgroundColor3 = Theme.Secondary,
		Text = name,
		TextColor3 = Theme.TextDark,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		AutoButtonColor = false,
		LayoutOrder = #self.Tabs
	})
	
	Create("UIPadding", {
		Parent = TabButton,
		PaddingLeft = UDim.new(0, 12)
	})
	
	local Indicator = Create("Frame", {
		Name = "Indicator",
		Parent = TabButton,
		Size = UDim2.new(0, 3, 0, 0),
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Theme.Highlight,
		BorderSizePixel = 0
	})
	
	tab.Button = TabButton
	tab.Indicator = Indicator
	
	local Content = Create("ScrollingFrame", {
		Name = name .. "Content",
		Parent = self.ContentFrame,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Theme.Line,
		Visible = false,
		AutomaticCanvasSize = Enum.AutomaticSize.Y
	})
	
	Create("UIPadding", {
		Parent = Content,
		PaddingLeft = UDim.new(0, 12),
		PaddingRight = UDim.new(0, 12),
		PaddingTop = UDim.new(0, 10),
		PaddingBottom = UDim.new(0, 10)
	})
	
	Create("UIListLayout", {
		Parent = Content,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 0)
	})
	
	tab.Content = Content
	
	TabButton.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)
	
	TabButton.MouseEnter:Connect(function()
		if self.ActiveTab ~= tab then
			Tween(TabButton, {TextColor3 = Theme.Text}, 0.2)
		end
	end)
	
	TabButton.MouseLeave:Connect(function()
		if self.ActiveTab ~= tab then
			Tween(TabButton, {TextColor3 = Theme.TextDark}, 0.2)
		end
	end)
	
	table.insert(self.Tabs, tab)
	
	if #self.Tabs == 1 then
		self:SelectTab(tab)
	end
	
	return tab
end

function UILibrary:SelectTab(tab)
	if self.ActiveTab then
		Tween(self.ActiveTab.Button, {TextColor3 = Theme.TextDark}, 0.2)
		Tween(self.ActiveTab.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.2)
		self.ActiveTab.Content.Visible = false
	end
	
	self.ActiveTab = tab
	Tween(tab.Button, {TextColor3 = Theme.Text}, 0.2)
	Tween(tab.Indicator, {Size = UDim2.new(0, 3, 0, 16)}, 0.2)
	tab.Content.Visible = true
end

function UILibrary:CreateSeparator(parent)
	local Separator = Create("Frame", {
		Name = "Separator",
		Parent = parent,
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = Theme.Line,
		BorderSizePixel = 0,
		LayoutOrder = #parent:GetChildren()
	})
	return Separator
end

function UILibrary:AddButton(tab, text, callback)
	local ButtonFrame = Create("Frame", {
		Name = text .. "Button",
		Parent = tab.Content,
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundTransparency = 1,
		LayoutOrder = #tab.Content:GetChildren()
	})
	
	local Button = Create("TextButton", {
		Name = "Button",
		Parent = ButtonFrame,
		Size = UDim2.new(1, 0, 0, 32),
		Position = UDim2.new(0, 0, 0, 3),
		BackgroundColor3 = Theme.Tertiary,
		Text = text,
		TextColor3 = Theme.Text,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		AutoButtonColor = false
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = Button
	})
	
	Button.MouseEnter:Connect(function()
		Tween(Button, {BackgroundColor3 = Theme.Line}, 0.2)
	end)
	
	Button.MouseLeave:Connect(function()
		Tween(Button, {BackgroundColor3 = Theme.Tertiary}, 0.2)
	end)
	
	Button.MouseButton1Click:Connect(function()
		Tween(Button, {Size = UDim2.new(0.98, 0, 0, 32)}, 0.05).Completed:Connect(function()
			Tween(Button, {Size = UDim2.new(1, 0, 0, 32)}, 0.1)
		end)
		if callback then
			callback()
		end
	end)
	
	self:CreateSeparator(tab.Content)
	return Button
end

function UILibrary:AddToggle(tab, text, default, callback)
	local ToggleFrame = Create("Frame", {
		Name = text .. "Toggle",
		Parent = tab.Content,
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundTransparency = 1,
		LayoutOrder = #tab.Content:GetChildren()
	})
	
	local Label = Create("TextLabel", {
		Name = "Label",
		Parent = ToggleFrame,
		Size = UDim2.new(1, -50, 1, 0),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Theme.Text,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	local ToggleButton = Create("TextButton", {
		Name = "Toggle",
		Parent = ToggleFrame,
		Size = UDim2.new(0, 40, 0, 20),
		Position = UDim2.new(1, -45, 0.5, -10),
		BackgroundColor3 = default and Theme.ToggleOn or Theme.ToggleOff,
		Text = "",
		AutoButtonColor = false
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = ToggleButton
	})
	
	local Circle = Create("Frame", {
		Name = "Circle",
		Parent = ToggleButton,
		Size = UDim2.new(0, 16, 0, 16),
		Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = Circle
	})
	
	local enabled = default
	
	ToggleButton.MouseButton1Click:Connect(function()
		enabled = not enabled
		Tween(ToggleButton, {BackgroundColor3 = enabled and Theme.ToggleOn or Theme.ToggleOff}, 0.2)
		Tween(Circle, {Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
		if callback then
			callback(enabled)
		end
	end)
	
	self:CreateSeparator(tab.Content)
	return ToggleFrame
end

function UILibrary:AddSlider(tab, text, min, max, default, callback)
	local SliderFrame = Create("Frame", {
		Name = text .. "Slider",
		Parent = tab.Content,
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundTransparency = 1,
		LayoutOrder = #tab.Content:GetChildren()
	})
	
	local Label = Create("TextLabel", {
		Name = "Label",
		Parent = SliderFrame,
		Size = UDim2.new(1, -50, 0, 18),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Theme.Text,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	local ValueLabel = Create("TextLabel", {
		Name = "Value",
		Parent = SliderFrame,
		Size = UDim2.new(0, 50, 0, 18),
		Position = UDim2.new(1, -50, 0, 0),
		BackgroundTransparency = 1,
		Text = tostring(default),
		TextColor3 = Theme.TextDark,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Right
	})
	
	local SliderBg = Create("Frame", {
		Name = "SliderBg",
		Parent = SliderFrame,
		Size = UDim2.new(1, 0, 0, 6),
		Position = UDim2.new(0, 0, 0, 30),
		BackgroundColor3 = Theme.Tertiary,
		BorderSizePixel = 0
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = SliderBg
	})
	
	local SliderFill = Create("Frame", {
		Name = "SliderFill",
		Parent = SliderBg,
		Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
		BackgroundColor3 = Theme.Highlight,
		BorderSizePixel = 0
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = SliderFill
	})
	
	local SliderKnob = Create("Frame", {
		Name = "Knob",
		Parent = SliderBg,
		Size = UDim2.new(0, 12, 0, 12),
		Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 2
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = SliderKnob
	})
	
	local SliderButton = Create("TextButton", {
		Name = "SliderButton",
		Parent = SliderBg,
		Size = UDim2.new(1, 0, 1, 20),
		Position = UDim2.new(0, 0, 0, -10),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = 3
	})
	
	local dragging = false
	
	local function UpdateSlider(input)
		local relativeX = input.Position.X - SliderBg.AbsolutePosition.X
		local pos = math.clamp(relativeX / SliderBg.AbsoluteSize.X, 0, 1)
		local value = math.floor(min + (max - min) * pos)
		
		SliderFill.Size = UDim2.new(pos, 0, 1, 0)
		SliderKnob.Position = UDim2.new(pos, -6, 0.5, -6)
		ValueLabel.Text = tostring(value)
		
		if callback then
			callback(value)
		end
	end
	
	SliderButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			UpdateSlider(input)
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			UpdateSlider(input)
		end
	end)
	
	self:CreateSeparator(tab.Content)
	return SliderFrame
end

function UILibrary:AddDropdown(tab, text, options, callback)
	local DropdownFrame = Create("Frame", {
		Name = text .. "Dropdown",
		Parent = tab.Content,
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundTransparency = 1,
		LayoutOrder = #tab.Content:GetChildren(),
		ClipsDescendants = true
	})
	
	local Button = Create("TextButton", {
		Name = "Button",
		Parent = DropdownFrame,
		Size = UDim2.new(1, 0, 0, 32),
		Position = UDim2.new(0, 0, 0, 3),
		BackgroundColor3 = Theme.Tertiary,
		Text = text,
		TextColor3 = Theme.Text,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		AutoButtonColor = false
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = Button
	})
	
	local Arrow = Create("TextLabel", {
		Name = "Arrow",
		Parent = Button,
		Size = UDim2.new(0, 30, 1, 0),
		Position = UDim2.new(1, -30, 0, 0),
		BackgroundTransparency = 1,
		Text = "v",
		TextColor3 = Theme.TextDark,
		TextSize = 12,
		Font = Enum.Font.Gotham
	})
	
	local OptionContainer = Create("Frame", {
		Name = "Options",
		Parent = DropdownFrame,
		Size = UDim2.new(1, 0, 0, #options * 28),
		Position = UDim2.new(0, 0, 0, 38),
		BackgroundColor3 = Theme.Tertiary,
		BorderSizePixel = 0,
		Visible = false
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = OptionContainer
	})
	
	local expanded = false
	
	for i, option in ipairs(options) do
		local OptionBtn = Create("TextButton", {
			Name = option,
			Parent = OptionContainer,
			Size = UDim2.new(1, 0, 0, 28),
			Position = UDim2.new(0, 0, 0, (i - 1) * 28),
			BackgroundColor3 = Theme.Tertiary,
			Text = option,
			TextColor3 = Theme.Text,
			TextSize = 12,
			Font = Enum.Font.Gotham,
			AutoButtonColor = false
		})
		
		OptionBtn.MouseEnter:Connect(function()
			Tween(OptionBtn, {BackgroundColor3 = Theme.Line}, 0.2)
		end)
		
		OptionBtn.MouseLeave:Connect(function()
			Tween(OptionBtn, {BackgroundColor3 = Theme.Tertiary}, 0.2)
		end)
		
		OptionBtn.MouseButton1Click:Connect(function()
			Button.Text = option
			ToggleDropdown()
			if callback then
				callback(option)
			end
		end)
	end
	
	local function ToggleDropdown()
		expanded = not expanded
		Tween(Arrow, {Rotation = expanded and 180 or 0}, 0.2)
		if expanded then
			OptionContainer.Visible = true
			Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 38 + #options * 28)}, 0.2)
		else
			Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 38)}, 0.2).Completed:Connect(function()
				OptionContainer.Visible = false
			end)
		end
	end
	
	Button.MouseButton1Click:Connect(ToggleDropdown)
	
	Button.MouseEnter:Connect(function()
		Tween(Button, {BackgroundColor3 = Theme.Line}, 0.2)
	end)
	
	Button.MouseLeave:Connect(function()
		if not expanded then
			Tween(Button, {BackgroundColor3 = Theme.Tertiary}, 0.2)
		end
	end)
	
	self:CreateSeparator(tab.Content)
	return DropdownFrame
end

function UILibrary:AddInput(tab, text, placeholder, callback)
	local InputFrame = Create("Frame", {
		Name = text .. "Input",
		Parent = tab.Content,
		Size = UDim2.new(1, 0, 0, 60),
		BackgroundTransparency = 1,
		LayoutOrder = #tab.Content:GetChildren()
	})
	
	local Label = Create("TextLabel", {
		Name = "Label",
		Parent = InputFrame,
		Size = UDim2.new(1, 0, 0, 18),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Theme.Text,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	local InputBox = Create("TextBox", {
		Name = "InputBox",
		Parent = InputFrame,
		Size = UDim2.new(1, 0, 0, 32),
		Position = UDim2.new(0, 0, 0, 22),
		BackgroundColor3 = Theme.Tertiary,
		Text = "",
		PlaceholderText = placeholder or "Enter text...",
		TextColor3 = Theme.Text,
		PlaceholderColor3 = Theme.TextDark,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		ClearTextOnFocus = false
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = InputBox
	})
	
	Create("UIPadding", {
		Parent = InputBox,
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10)
	})
	
	InputBox.Focused:Connect(function()
		Tween(InputBox, {BackgroundColor3 = Theme.Line}, 0.2)
	end)
	
	InputBox.FocusLost:Connect(function(enterPressed)
		Tween(InputBox, {BackgroundColor3 = Theme.Tertiary}, 0.2)
		if callback then
			callback(InputBox.Text, enterPressed)
		end
	end)
	
	self:CreateSeparator(tab.Content)
	return InputFrame
end

function UILibrary:AddKeybind(tab, text, defaultKey, callback)
	local KeybindFrame = Create("Frame", {
		Name = text .. "Keybind",
		Parent = tab.Content,
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundTransparency = 1,
		LayoutOrder = #tab.Content:GetChildren()
	})
	
	local Label = Create("TextLabel", {
		Name = "Label",
		Parent = KeybindFrame,
		Size = UDim2.new(1, -70, 1, 0),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Theme.Text,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	local KeyButton = Create("TextButton", {
		Name = "KeyButton",
		Parent = KeybindFrame,
		Size = UDim2.new(0, 60, 0, 26),
		Position = UDim2.new(1, -65, 0.5, -13),
		BackgroundColor3 = Theme.Tertiary,
		Text = defaultKey and defaultKey.Name or "None",
		TextColor3 = Theme.Text,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		AutoButtonColor = false
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = KeyButton
	})
	
	local listening = false
	
	KeyButton.MouseButton1Click:Connect(function()
		if listening then return end
		listening = true
		KeyButton.Text = "..."
		Tween(KeyButton, {BackgroundColor3 = Theme.Line}, 0.2)
	end)
	
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if listening and input.UserInputType == Enum.UserInputType.Keyboard then
			listening = false
			KeyButton.Text = input.KeyCode.Name
			Tween(KeyButton, {BackgroundColor3 = Theme.Tertiary}, 0.2)
			if callback then
				callback(input.KeyCode)
			end
		end
	end)
	
	KeyButton.MouseEnter:Connect(function()
		if not listening then
			Tween(KeyButton, {BackgroundColor3 = Theme.Line}, 0.2)
		end
	end)
	
	KeyButton.MouseLeave:Connect(function()
		if not listening then
			Tween(KeyButton, {BackgroundColor3 = Theme.Tertiary}, 0.2)
		end
	end)
	
	self:CreateSeparator(tab.Content)
	return KeybindFrame
end

function UILibrary:AddLabel(tab, text)
	local LabelFrame = Create("Frame", {
		Name = text .. "Label",
		Parent = tab.Content,
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
		LayoutOrder = #tab.Content:GetChildren()
	})
	
	local Label = Create("TextLabel", {
		Name = "Label",
		Parent = LabelFrame,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Theme.Text,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	self:CreateSeparator(tab.Content)
	return Label
end

function UILibrary:AddSection(tab, text)
	local SectionFrame = Create("Frame", {
		Name = text .. "Section",
		Parent = tab.Content,
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		LayoutOrder = #tab.Content:GetChildren()
	})
	
	local Label = Create("TextLabel", {
		Name = "Label",
		Parent = SectionFrame,
		Size = UDim2.new(1, 0, 0, 20),
		Position = UDim2.new(0, 0, 0, 5),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Theme.TextDark,
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	Create("Frame", {
		Name = "Line",
		Parent = SectionFrame,
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, -2),
		BackgroundColor3 = Theme.Line,
		BorderSizePixel = 0
	})
	
	return SectionFrame
end

function UILibrary:AddParagraph(tab, text)
	local ParagraphFrame = Create("Frame", {
		Name = "Paragraph",
		Parent = tab.Content,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = #tab.Content:GetChildren(),
		AutomaticSize = Enum.AutomaticSize.Y
	})
	
	local Label = Create("TextLabel", {
		Name = "Label",
		Parent = ParagraphFrame,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Theme.TextDark,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		AutomaticSize = Enum.AutomaticSize.Y
	})
	
	self:CreateSeparator(tab.Content)
	return ParagraphFrame
end

function UILibrary:AddColorPicker(tab, text, defaultColor, callback)
	local ColorFrame = Create("Frame", {
		Name = text .. "ColorPicker",
		Parent = tab.Content,
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundTransparency = 1,
		LayoutOrder = #tab.Content:GetChildren()
	})
	
	local Label = Create("TextLabel", {
		Name = "Label",
		Parent = ColorFrame,
		Size = UDim2.new(1, -50, 1, 0),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Theme.Text,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	local ColorButton = Create("TextButton", {
		Name = "ColorButton",
		Parent = ColorFrame,
		Size = UDim2.new(0, 36, 0, 26),
		Position = UDim2.new(1, -41, 0.5, -13),
		BackgroundColor3 = defaultColor or Color3.fromRGB(255, 255, 255),
		Text = "",
		AutoButtonColor = false
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = ColorButton
	})
	
	local PickerFrame = Create("Frame", {
		Name = "Picker",
		Parent = ColorFrame,
		Size = UDim2.new(1, 0, 0, 140),
		Position = UDim2.new(0, 0, 0, 42),
		BackgroundColor3 = Theme.Tertiary,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 10
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = PickerFrame
	})
	
	local HueSlider = Create("Frame", {
		Name = "Hue",
		Parent = PickerFrame,
		Size = UDim2.new(1, -20, 0, 18),
		Position = UDim2.new(0, 10, 0, 10),
		BackgroundColor3 = Color3.fromRGB(255, 0, 0),
		BorderSizePixel = 0
	})
	
	Create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
			ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
		}),
		Parent = HueSlider
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = HueSlider
	})
	
	local SaturationFrame = Create("Frame", {
		Name = "Saturation",
		Parent = PickerFrame,
		Size = UDim2.new(1, -20, 0, 90),
		Position = UDim2.new(0, 10, 0, 36),
		BackgroundColor3 = defaultColor or Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = SaturationFrame
	})
	
	local BlackGradient = Create("Frame", {
		Name = "BlackGradient",
		Parent = SaturationFrame,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0
	})
	
	Create("UIGradient", {
		Transparency = NumberSequence.new(0, 1),
		Rotation = 90,
		Parent = BlackGradient
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = BlackGradient
	})
	
	local WhiteGradient = Create("Frame", {
		Name = "WhiteGradient",
		Parent = SaturationFrame,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0
	})
	
	Create("UIGradient", {
		Transparency = NumberSequence.new(0, 1),
		Parent = WhiteGradient
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = WhiteGradient
	})
	
	local open = false
	
	ColorButton.MouseButton1Click:Connect(function()
		open = not open
		PickerFrame.Visible = open
		if open then
			Tween(ColorFrame, {Size = UDim2.new(1, 0, 0, 190)}, 0.2)
		else
			Tween(ColorFrame, {Size = UDim2.new(1, 0, 0, 38)}, 0.2)
		end
	end)
	
	local hue, sat, val = 0, 1, 1
	
	local function UpdateColor()
		local color = Color3.fromHSV(hue, sat, val)
		ColorButton.BackgroundColor3 = color
		SaturationFrame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
		if callback then
			callback(color)
		end
	end
	
	local hueDragging = false
	local satDragging = false
	
	HueSlider.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			hueDragging = true
			local pos = math.clamp((input.Position.X - HueSlider.AbsolutePosition.X) / HueSlider.AbsoluteSize.X, 0, 1)
			hue = 1 - pos
			UpdateColor()
		end
	end)
	
	SaturationFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			satDragging = true
			sat = math.clamp((input.Position.X - SaturationFrame.AbsolutePosition.X) / SaturationFrame.AbsoluteSize.X, 0, 1)
			val = 1 - math.clamp((input.Position.Y - SaturationFrame.AbsolutePosition.Y) / SaturationFrame.AbsoluteSize.Y, 0, 1)
			UpdateColor()
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			hueDragging = false
			satDragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if hueDragging then
				local pos = math.clamp((input.Position.X - HueSlider.AbsolutePosition.X) / HueSlider.AbsoluteSize.X, 0, 1)
				hue = 1 - pos
				UpdateColor()
			elseif satDragging then
				sat = math.clamp((input.Position.X - SaturationFrame.AbsolutePosition.X) / SaturationFrame.AbsoluteSize.X, 0, 1)
				val = 1 - math.clamp((input.Position.Y - SaturationFrame.AbsolutePosition.Y) / SaturationFrame.AbsoluteSize.Y, 0, 1)
				UpdateColor()
			end
		end
	end)
	
	self:CreateSeparator(tab.Content)
	return ColorFrame
end

function UILibrary:Notify(title, message, duration)
	duration = duration or 3
	
	local NotifGui = Create("ScreenGui", {
		Name = "Notification",
		Parent = game.CoreGui,
		ResetOnSpawn = false
	})
	
	local NotifFrame = Create("Frame", {
		Name = "Frame",
		Parent = NotifGui,
		Size = UDim2.new(0, 280, 0, 70),
		Position = UDim2.new(1, 20, 1, -90 - (#self.Notifications * 80)),
		BackgroundColor3 = Theme.Secondary,
		BorderSizePixel = 0
	})
	
	Create("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = NotifFrame
	})
	
	local Shadow = Create("ImageLabel", {
		Name = "Shadow",
		Parent = NotifFrame,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 4),
		Size = UDim2.new(1, 20, 1, 20),
		BackgroundTransparency = 1,
		Image = "rbxassetid://5554236805",
		ImageColor3 = Color3.fromRGB(0, 0, 0),
		ImageTransparency = 0.6,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(23, 23, 277, 277),
		ZIndex = -1
	})
	
	local TitleLabel = Create("TextLabel", {
		Name = "Title",
		Parent = NotifFrame,
		Size = UDim2.new(1, -20, 0, 22),
		Position = UDim2.new(0, 15, 0, 8),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	local MessageLabel = Create("TextLabel", {
		Name = "Message",
		Parent = NotifFrame,
		Size = UDim2.new(1, -20, 0, 35),
		Position = UDim2.new(0, 15, 0, 30),
		BackgroundTransparency = 1,
		Text = message,
		TextColor3 = Theme.TextDark,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true
	})
	
	table.insert(self.Notifications, NotifGui)
	
	Tween(NotifFrame, {Position = UDim2.new(1, -300, 1, -90 - ((#self.Notifications - 1) * 80))}, 0.4, Enum.EasingStyle.Back)
	
	task.delay(duration, function()
		Tween(NotifFrame, {Position = UDim2.new(1, 20, 1, -90 - ((#self.Notifications - 1) * 80))}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In).Completed:Connect(function()
			NotifGui:Destroy()
			for i, notif in ipairs(self.Notifications) do
				if notif == NotifGui then
					table.remove(self.Notifications, i)
					break
				end
			end
			for i, notif in ipairs(self.Notifications) do
				local frame = notif:FindFirstChild("Frame")
				if frame then
					Tween(frame, {Position = UDim2.new(1, -300, 1, -90 - ((i - 1) * 80))}, 0.2)
				end
			end
		end)
	end)
	
	return NotifGui
end

return UILibrary
