local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Library = {}
Library.__index = Library

local function Ripple(obj)
	task.spawn(function()
		local Mouse = Players.LocalPlayer:GetMouse()
		local Circle = Instance.new("ImageLabel")
		Circle.Parent = obj
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 0.8
		Circle.ZIndex = 10
		Circle.Image = "rbxassetid://266543268"
		Circle.Size = UDim2.new(0, 0, 0, 0)
		local NewX, NewY = Mouse.X - Circle.AbsolutePosition.X, Mouse.Y - Circle.AbsolutePosition.Y
		Circle.Position = UDim2.new(0, NewX, 0, NewY)
		local Size = obj.AbsoluteSize.X > obj.AbsoluteSize.Y and obj.AbsoluteSize.X or obj.AbsoluteSize.Y
		TweenService:Create(Circle, TweenInfo.new(0.5), {Size = UDim2.new(0, Size*2, 0, Size*2), Position = UDim2.new(0.5, -Size, 0.5, -Size), ImageTransparency = 1}):Play()
		task.wait(0.5)
		Circle:Destroy()
	end)
end

local function MakeDraggable(gui, dragHandle)
	local dragging, dragInput, dragStart, startPos
	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true; dragStart = input.Position; startPos = gui.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
			local delta = input.Position - dragStart
			gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
end

function Library:Notify(config)
	local Screen = game:GetService("CoreGui"):FindFirstChild("Nexxto_Notif") or Instance.new("ScreenGui", game:GetService("CoreGui"))
	Screen.Name = "Nexxto_Notif"
	local Holder = Screen:FindFirstChild("Holder") or Instance.new("Frame", Screen)
	if not Screen:FindFirstChild("Holder") then
		Holder.Name = "Holder"; Holder.Position = UDim2.new(1, -310, 1, -310); Holder.Size = UDim2.new(0, 300, 0, 300); Holder.BackgroundTransparency = 1
		local L = Instance.new("UIListLayout", Holder); L.VerticalAlignment = Enum.VerticalAlignment.Bottom; L.Padding = UDim.new(0, 10)
	end
	local Box = Instance.new("Frame", Holder)
	Box.Size = UDim2.new(1, 0, 0, 0); Box.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Box.ClipsDescendants = true
	Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 8)
	local S = Instance.new("UIStroke", Box); S.Color = Color3.fromRGB(59, 130, 246); S.Transparency = 0.5
	local T = Instance.new("TextLabel", Box); T.Text = config.Title; T.Size = UDim2.new(1, -20, 0, 30); T.Position = UDim2.fromOffset(10, 5); T.TextColor3 = Color3.fromRGB(255, 255, 255); T.Font = Enum.Font.GothamBold; T.BackgroundTransparency = 1; T.TextXAlignment = Enum.TextXAlignment.Left
	local D = Instance.new("TextLabel", Box); D.Text = config.Description; D.Size = UDim2.new(1, -20, 0, 20); D.Position = UDim2.fromOffset(10, 30); D.TextColor3 = Color3.fromRGB(150, 150, 160); D.Font = Enum.Font.Gotham; D.TextSize = 12; D.BackgroundTransparency = 1; D.TextXAlignment = Enum.TextXAlignment.Left
	TweenService:Create(Box, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(1, 0, 0, 60)}):Play()
	task.delay(config.Duration or 4, function()
		TweenService:Create(Box, TweenInfo.new(0.4), {Size = UDim2.new(1, 0, 0, 0), Transparency = 1}):Play()
		task.wait(0.4); Box:Destroy()
	end)
end

function Library:CreateWindow(config)
	local Window = {Size = config.size or UDim2.fromOffset(520, 420), Closed = false}
	Window.Gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
	Window.Main = Instance.new("Frame", Window.Gui)
	Window.Main.Size = Window.Size; Window.Main.Position = UDim2.new(0.5, -Window.Size.X.Offset/2, 0.5, -Window.Size.Y.Offset/2); Window.Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12); Window.Main.ClipsDescendants = true
	Instance.new("UICorner", Window.Main).CornerRadius = UDim.new(0, 10)
	Instance.new("UIStroke", Window.Main).Color = Color3.fromRGB(35, 35, 40)
	local Header = Instance.new("Frame", Window.Main)
	Header.Size = UDim2.new(1, 0, 0, 50); Header.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
	local DragIcon = Instance.new("ImageLabel", Header); DragIcon.Size = UDim2.fromOffset(20, 20); DragIcon.Position = UDim2.fromOffset(15, 15); DragIcon.BackgroundTransparency = 1; DragIcon.Image = "rbxassetid://"..(config.icon or "0"); DragIcon.ImageColor3 = Color3.fromRGB(59, 130, 246)
	local Title = Instance.new("TextLabel", Header); Title.RichText = true; Title.Text = config.title .. " <font color='#606065'>" .. (config.subtitle or "") .. "</font>"; Title.Position = UDim2.fromOffset(45, 0); Title.Size = UDim2.new(1, -150, 1, 0); Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.BackgroundTransparency = 1
	local ToggleBtn = Instance.new("ImageButton", Header); ToggleBtn.Size = UDim2.fromOffset(20, 20); ToggleBtn.Position = UDim2.new(1, -40, 0.5, -10); ToggleBtn.BackgroundTransparency = 1; ToggleBtn.Image = "rbxassetid://6031091000"; ToggleBtn.ImageColor3 = Color3.fromRGB(100, 100, 110)
	local Sidebar = Instance.new("Frame", Window.Main); Sidebar.Size = UDim2.new(0, 160, 1, -50); Sidebar.Position = UDim2.fromOffset(0, 50); Sidebar.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
	Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 4); Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 10)
	local Container = Instance.new("Frame", Window.Main); Container.Size = UDim2.new(1, -170, 1, -120); Container.Position = UDim2.fromOffset(165, 55); Container.BackgroundTransparency = 1
	local PlayerPanel = Instance.new("Frame", Window.Main); PlayerPanel.Size = UDim2.new(1, -20, 0, 50); PlayerPanel.Position = UDim2.new(0, 10, 1, -60); PlayerPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	Instance.new("UICorner", PlayerPanel); Instance.new("UIStroke", PlayerPanel).Color = Color3.fromRGB(30, 30, 35)
	local Av = Instance.new("ImageLabel", PlayerPanel); Av.Size = UDim2.fromOffset(34, 34); Av.Position = UDim2.fromOffset(8, 8); Av.Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48); Instance.new("UICorner", Av).CornerRadius = UDim.new(1, 0)
	local User = Instance.new("TextLabel", PlayerPanel); User.Text = Players.LocalPlayer.DisplayName; User.Position = UDim2.fromOffset(50, 8); User.TextColor3 = Color3.fromRGB(255, 255, 255); User.Font = Enum.Font.GothamBold; User.TextSize = 12; User.BackgroundTransparency = 1; User.TextXAlignment = Enum.TextXAlignment.Left
	local Time = Instance.new("TextLabel", PlayerPanel); Time.Size = UDim2.new(1, -15, 1, 0); Time.TextColor3 = Color3.fromRGB(59, 130, 246); Time.Font = Enum.Font.Code; Time.BackgroundTransparency = 1; Time.TextXAlignment = Enum.TextXAlignment.Right
	task.spawn(function() while task.wait(1) do Time.Text = os.date("%H:%M:%S") end end)
	MakeDraggable(Window.Main, Header)
	ToggleBtn.MouseButton1Click:Connect(function()
		Window.Closed = not Window.Closed
		TweenService:Create(Window.Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = Window.Closed and UDim2.fromOffset(Window.Size.X.Offset, 50) or Window.Size}):Play()
	end)
	function Window:AddTab(name)
		local Tab = {}
		local Page = Instance.new("ScrollingFrame", Container)
		Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0; Page.CanvasSize = UDim2.new(0, 0, 0, 0); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
		local TabBtn = Instance.new("TextButton", Sidebar); TabBtn.Size = UDim2.new(1, -20, 0, 35); TabBtn.BackgroundColor3 = Color3.fromRGB(59, 130, 246); TabBtn.BackgroundTransparency = 1; TabBtn.Text = "  "..name; TabBtn.TextColor3 = Color3.fromRGB(150, 150, 160); TabBtn.Font = Enum.Font.Gotham; TabBtn.TextXAlignment = Enum.TextXAlignment.Left
		Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6); TabBtn.MouseButton1Click:Connect(function()
			for _, v in pairs(Container:GetChildren()) do v.Visible = false end
			for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 160)}):Play() end end
			Page.Visible = true; TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.9, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end)
		local function CreateBase(title, desc)
			local Base = Instance.new("Frame", Page); Base.Size = UDim2.new(1, -10, 0, 55); Base.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
			Instance.new("UICorner", Base).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", Base).Color = Color3.fromRGB(25, 25, 30)
			local T = Instance.new("TextLabel", Base); T.Text = title; T.Position = UDim2.fromOffset(10, 10); T.TextColor3 = Color3.fromRGB(255, 255, 255); T.Font = Enum.Font.GothamBold; T.TextSize = 13; T.BackgroundTransparency = 1; T.TextXAlignment = Enum.TextXAlignment.Left
			local D = Instance.new("TextLabel", Base); D.Text = desc; D.Position = UDim2.fromOffset(10, 28); D.TextColor3 = Color3.fromRGB(100, 100, 110); D.Font = Enum.Font.Gotham; D.TextSize = 11; D.BackgroundTransparency = 1; D.TextXAlignment = Enum.TextXAlignment.Left
			return Base
		end
		function Tab:AddButton(title, desc, callback)
			local Base = CreateBase(title, desc); local B = Instance.new("TextButton", Base); B.Size = UDim2.fromOffset(90, 28); B.Position = UDim2.new(1, -100, 0.5, -14); B.BackgroundColor3 = Color3.fromRGB(30, 30, 35); B.Text = "Execute"; B.TextColor3 = Color3.fromRGB(255, 255, 255); B.Font = Enum.Font.Gotham; Instance.new("UICorner", B).CornerRadius = UDim.new(0, 4); B.MouseButton1Click:Connect(function() Ripple(B); callback() end)
		end
		function Tab:AddToggle(title, desc, default, callback)
			local Base = CreateBase(title, desc); local state = default; local Out = Instance.new("TextButton", Base); Out.Size = UDim2.fromOffset(36, 20); Out.Position = UDim2.new(1, -46, 0.5, -10); Out.BackgroundColor3 = state and Color3.fromRGB(59, 130, 246) or Color3.fromRGB(40, 40, 45); Out.Text = ""
			Instance.new("UICorner", Out).CornerRadius = UDim.new(1, 0); local Dot = Instance.new("Frame", Out); Dot.Size = UDim2.fromOffset(14, 14); Dot.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7); Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
			Out.MouseButton1Click:Connect(function() state = not state; TweenService:Create(Out, TweenInfo.new(0.3), {BackgroundColor3 = state and Color3.fromRGB(59, 130, 246) or Color3.fromRGB(40, 40, 45)}):Play(); TweenService:Create(Dot, TweenInfo.new(0.3), {Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play(); callback(state) end)
		end
		function Tab:AddSlider(title, desc, min, max, def, callback)
			local Base = CreateBase(title, desc); Base.Size = UDim2.new(1, -10, 0, 75); local Bg = Instance.new("Frame", Base); Bg.Size = UDim2.new(1, -20, 0, 6); Bg.Position = UDim2.new(0, 10, 1, -15); Bg.BackgroundColor3 = Color3.fromRGB(35, 35, 40); Instance.new("UICorner", Bg); local Fill = Instance.new("Frame", Bg); Fill.Size = UDim2.fromScale((def-min)/(max-min), 1); Fill.BackgroundColor3 = Color3.fromRGB(59, 130, 246); Instance.new("UICorner", Fill); local Val = Instance.new("TextLabel", Base); Val.Text = tostring(def); Val.Position = UDim2.new(1, -50, 0, 10); Val.TextColor3 = Color3.fromRGB(59, 130, 246); Val.BackgroundTransparency = 1; Val.Font = Enum.Font.Code
			local function UpdateSlider() local percent = math.clamp((UserInputService:GetMouseLocation().X - Bg.AbsolutePosition.X) / Bg.AbsoluteSize.X, 0, 1); local value = math.floor(min + (max - min) * percent); Fill.Size = UDim2.fromScale(percent, 1); Val.Text = tostring(value); callback(value) end
			Bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then local c; c = RunService.RenderStepped:Connect(UpdateSlider); UserInputService.InputEnded:Connect(function(i2) if i2.UserInputType == Enum.UserInputType.MouseButton1 then if c then c:Disconnect() end end) end end)
		end
		function Tab:AddTextbox(title, desc, placeholder, callback)
			local Base = CreateBase(title, desc); local Box = Instance.new("TextBox", Base); Box.Size = UDim2.fromOffset(120, 28); Box.Position = UDim2.new(1, -130, 0.5, -14); Box.BackgroundColor3 = Color3.fromRGB(10, 10, 12); Box.TextColor3 = Color3.fromRGB(255, 255, 255); Box.PlaceholderText = placeholder; Box.Text = ""; Box.Font = Enum.Font.Gotham; Box.TextSize = 12; Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4); Instance.new("UIStroke", Box).Color = Color3.fromRGB(30, 30, 35); Box.FocusLost:Connect(function() callback(Box.Text) end)
		end
		function Tab:AddDropdown(title, desc, options, callback)
			local Base = CreateBase(title, desc); local open = false; local Btn = Instance.new("TextButton", Base); Btn.Size = UDim2.fromOffset(120, 28); Btn.Position = UDim2.new(1, -130, 0.5, -14); Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Btn.Text = "Select..."; Btn.TextColor3 = Color3.fromRGB(200, 200, 210); Instance.new("UICorner", Btn)
			local List = Instance.new("ScrollingFrame", Page); List.Size = UDim2.new(1, -10, 0, 0); List.BackgroundColor3 = Color3.fromRGB(13, 13, 15); List.ClipsDescendants = true; List.Visible = false; List.ScrollBarThickness = 0; Instance.new("UIListLayout", List); Instance.new("UICorner", List)
			for _, opt in pairs(options) do
				local o = Instance.new("TextButton", List); o.Size = UDim2.new(1, 0, 0, 30); o.Text = opt; o.BackgroundColor3 = Color3.fromRGB(20, 20, 25); o.TextColor3 = Color3.fromRGB(255, 255, 255); o.BackgroundTransparency = 1; o.Font = Enum.Font.Gotham; o.MouseButton1Click:Connect(function() Btn.Text = opt; open = false; List.Visible = false; callback(opt) end)
			end
			Btn.MouseButton1Click:Connect(function() open = not open; List.Visible = open; List.Size = open and UDim2.new(1, -10, 0, math.min(#options * 30, 120)) or UDim2.new(1, -10, 0, 0) end)
		end
		if #Sidebar:GetChildren() == 3 then TabBtn.MouseButton1Click() end
		return Tab
	end
	return Window
end

local Win = Library:CreateWindow({
	title = "Nexxto Premium",
	subtitle = "v2.0.1",
	icon = "10734898592",
	size = UDim2.fromOffset(550, 450)
})

local Combat = Win:AddTab("Combat")
Combat:AddToggle("Kill Aura", "Automatically attacks nearby players", true, function(t) print(t) end)
Combat:AddSlider("Reach", "Adjust hit distance", 1, 100, 15, function(v) print(v) end)

local Misc = Win:AddTab("Misc")
Misc:AddDropdown("Walkspeed", "Change how fast you move", {"Slow", "Fast", "Sonic"}, function(v) print(v) end)
Misc:AddTextbox("Join Server", "Enter server invite code", "Code...", function(v) print(v) end)
Misc:AddButton("Destroy GUI", "Closes the library", function() Win.Gui:Destroy() end)

Library:Notify({Title = "Nexxto", Description = "Successfully initialized library.", Duration = 5})

return Library
