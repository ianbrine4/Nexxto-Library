local Library = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local function MakeDraggable(obj, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

function Library:CreateWindow(config)
    local title = config.title or "Nexxto"
    local subtitle = config.subtitle or "V1.0"
    local iconId = config.icon or 0
    local size = config.size or Vector2.new(650, 400)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexxtoLibrary"
    ScreenGui.Parent = CoreGui

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, size.X, 0, size.Y)
    Main.Position = UDim2.new(0.5, -size.X/2, 0.5, -size.Y/2)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(40, 40, 40)
    Stroke.Thickness = 1

    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 55)
    Topbar.BackgroundTransparency = 1
    Topbar.Parent = Main
    
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 28, 0, 28)
    Icon.Position = UDim2.new(0, 15, 0.5, -14)
    Icon.Image = "rbxassetid://" .. tostring(iconId)
    Icon.BackgroundTransparency = 1
    Icon.Parent = Topbar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title
    TitleLabel.Position = UDim2.new(0, 52, 0.25, 0)
    TitleLabel.Size = UDim2.new(0, 200, 0, 18)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = "Left"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Topbar

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Text = subtitle
    SubLabel.Position = UDim2.new(0, 52, 0.6, 0)
    SubLabel.Size = UDim2.new(0, 200, 0, 12)
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.TextColor3 = Color3.fromRGB(0, 229, 255)
    SubLabel.TextSize = 11
    SubLabel.TextXAlignment = "Left"
    SubLabel.BackgroundTransparency = 1
    SubLabel.Parent = Topbar

    local Footer = Instance.new("Frame")
    Footer.Name = "Footer"
    Footer.Size = UDim2.new(1, 0, 0, 25)
    Footer.Position = UDim2.new(0, 0, 1, -25)
    Footer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Footer.BorderSizePixel = 0
    Footer.Parent = Main
    
    local FooterCorner = Instance.new("UICorner", Footer)
    FooterCorner.CornerRadius = UDim.new(0, 10)

    local FooterText = Instance.new("TextLabel")
    FooterText.Size = UDim2.new(1, -20, 1, 0)
    FooterText.Position = UDim2.new(0, 10, 0, 0)
    FooterText.Font = Enum.Font.GothamMedium
    FooterText.TextColor3 = Color3.fromRGB(100, 100, 100)
    FooterText.TextSize = 10
    FooterText.TextXAlignment = "Left"
    FooterText.BackgroundTransparency = 1
    FooterText.Parent = Footer

    task.spawn(function()
        while task.wait(1) do
            local timeString = os.date("%X") 
            FooterText.Text = "Nexxto Library | " .. timeString .. " | By Zel/Zyre"
        end
    end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Position = UDim2.new(0, 10, 0, 65)
    Sidebar.Size = UDim2.new(0, 150, 1, -100)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = Main

    local TabContainer = Instance.new("Frame")
    TabContainer.Position = UDim2.new(0, 170, 0, 65)
    TabContainer.Size = UDim2.new(1, -180, 1, -100)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = Main

    MakeDraggable(Main, Topbar)

    local Tabs = {}
    function Tabs:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Parent = Sidebar
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)

        return {}
    end

    return Tabs
end

return Library
