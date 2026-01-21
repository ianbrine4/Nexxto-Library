local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Library = {}
Library.__index = Library

local function MakeDraggable(gui, dragHandle)
	local dragging, dragInput, dragStart, startPos
	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

function Library:CreateWindow(config)
	local Window = {
		Closed = false,
		Size = config.size or UDim2.fromOffset(480, 340)
	}
	
	Window.Gui = Instance.new("ScreenGui")
	Window.Gui.Name = "NexxtoUI"
	Window.Gui.ResetOnSpawn = false
	Window.Gui.Parent = game:GetService("CoreGui")
	
	Window.Main = Instance.new("Frame")
	Window.Main.ClipsDescendants = true
	Window.Main.Size = Window.Size
	Window.Main.Position = UDim2.new(0.5, -240, 0.5, -170)
	Window.Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
	Window.Main.BorderSizePixel = 0
	Window.Main.Parent = Window.Gui
	
	Instance.new("UICorner", Window.Main).CornerRadius = UDim.new(0, 8)
	local Stroke = Instance.new("UIStroke", Window.Main)
	Stroke.Color = Color3.fromRGB(255, 255, 255)
	Stroke.Transparency = 0.95

	Window.Header = Instance.new("Frame")
	Window.Header.Size = UDim2.new(1, 0, 0, 48)
	Window.Header.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
	Window.Header.BorderSizePixel = 0
	Window.Header.Parent = Window.Main
	Instance.new("UICorner", Window.Header).CornerRadius = UDim.new(0, 8)
	
	local Icon = Instance.new("ImageLabel")
	Icon.Size = UDim2.fromOffset(20, 20)
	Icon.Position = UDim2.fromOffset(15, 14)
	Icon.BackgroundTransparency = 1
	Icon.Image = "rbxassetid://" .. (config.icon or "0")
	Icon.ImageColor3 = Color3.fromRGB(59, 130, 246)
	Icon.Parent = Window.Header

	local Title = Instance.new("TextLabel")
	Title.Text = config.title .. " <font color='#94a3b8'>" .. (config.subtitle or "") .. "</font>"
	Title.RichText = true
	Title.Size = UDim2.new(1, -100, 1, 0)
	Title.Position = UDim2.fromOffset(45, 0)
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 14
	Title.BackgroundTransparency = 1
	Title.Parent = Window.Header

	local ToggleBtn = Instance.new("ImageButton")
	ToggleBtn.Size = UDim2.fromOffset(16, 16)
	ToggleBtn.Position = UDim2.new(1, -35, 0.5, -8)
	ToggleBtn.BackgroundTransparency = 1
	ToggleBtn.Image = "rbxassetid://10734896206" -- Chevron Down
	ToggleBtn.ImageColor3 = Color3.fromRGB(148, 163, 184)
	ToggleBtn.Parent = Window.Header

	Window.Body = Instance.new("Frame")
	Window.Body.Size = UDim2.new(1, 0, 1, -48)
	Window.Body.Position = UDim2.fromOffset(0, 48)
	Window.Body.BackgroundTransparency = 1
	Window.Body.Parent = Window.Main

	ToggleBtn.MouseButton1Click:Connect(function()
		Window.Closed = not Window.Closed
		local TargetSize = Window.Closed and UDim2.fromOffset(Window.Size.X.Offset, 48) or Window.Size
		local TargetRotation = Window.Closed and 180 or 0
		
		TweenService:Create(Window.Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = TargetSize}):Play()
		TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {Rotation = TargetRotation}):Play()
	end)

	Window.Sidebar = Instance.new("Frame")
	Window.Sidebar.Size = UDim2.new(0, 150, 1, 0)
	Window.Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
	Window.Sidebar.BorderSizePixel = 0
	Window.Sidebar.Parent = Window.Body
	
	Instance.new("UIListLayout", Window.Sidebar).Padding = UDim.new(0, 4)
	Instance.new("UIPadding", Window.Sidebar).PaddingTop = UDim.new(0, 12)

	Window.Container = Instance.new("Frame")
	Window.Container.Size = UDim2.new(1, -150, 1, 0)
	Window.Container.Position = UDim2.fromOffset(150, 0)
	Window.Container.BackgroundTransparency = 1
	Window.Container.Parent = Window.Body

	local PlayerPanel = Instance.new("Frame")
	PlayerPanel.Size = UDim2.new(1, 0, 0, 54)
	PlayerPanel.Position = UDim2.new(0, 0, 1, 10)
	PlayerPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
	PlayerPanel.Parent = Window.Main
	Instance.new("UICorner", PlayerPanel).CornerRadius = UDim.new(0, 8)
	Instance.new("UIStroke", PlayerPanel).Transparency = 0.95

	local TimeLabel = Instance.new("TextLabel", PlayerPanel)
	TimeLabel.Size = UDim2.new(1, -20, 1, 0)
	TimeLabel.TextXAlignment = Enum.TextXAlignment.Right
	TimeLabel.TextColor3 = Color3.fromRGB(59, 130, 246)
	TimeLabel.Font = Enum.Font.Code
	TimeLabel.BackgroundTransparency = 1
	
	RunService.RenderStepped:Connect(function()
		TimeLabel.Text = os.date("%H:%M:%S")
	end)

	MakeDraggable(Window.Main, Window.Header)

	function Window:AddTab(tabConfig)
		local Tab = {}
		local TabBtn = Instance.new("TextButton")
		TabBtn.Size = UDim2.new(1, -16, 0, 32)
		TabBtn.BackgroundTransparency = 1
		TabBtn.Text = "  " .. tabConfig.title
		TabBtn.Font = Enum.Font.Gotham
		TabBtn.TextColor3 = Color3.fromRGB(148, 163, 184)
		TabBtn.TextXAlignment = Enum.TextXAlignment.Left
		TabBtn.Parent = Window.Sidebar
		Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

		local Content = Instance.new("ScrollingFrame")
		Content.Size = UDim2.new(1, 0, 1, 0)
		Content.BackgroundTransparency = 1
		Content.Visible = false
		Content.ScrollBarThickness = 0
		Content.Parent = Window.Container
		Instance.new("UIListLayout", Content).Padding = UDim.new(0, 6)
		Instance.new("UIPadding", Content).PaddingTop = UDim.new(0, 15)

		TabBtn.MouseButton1Click:Connect(function()
			for _, v in pairs(Window.Container:GetChildren()) do v.Visible = false end
			Content.Visible = true
		end)

		function Tab:AddButton(text, callback)
			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1, -30, 0, 40)
			Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
			Btn.Text = text
			Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			Btn.Font = Enum.Font.Gotham
			Btn.Parent = Content
			Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
			Btn.MouseButton1Click:Connect(callback)
		end

		return Tab
	end

	return Window
end

return Library
