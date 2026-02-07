local DreamLib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function DreamLib:CreateWindow(config)
    local Library = {
        CurrentTab = nil,
        Focused = true,
        Accent = config.color or Color3.fromRGB(195, 132, 255)
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DreamLibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui

    local OpenIcon = Instance.new("ImageButton")
    OpenIcon.Size = UDim2.new(0, 50, 0, 50)
    OpenIcon.Position = UDim2.new(1, -70, 1, -70)
    OpenIcon.BackgroundColor3 = Library.Accent
    OpenIcon.Image = "rbxassetid://" .. (config.icon or "6031094678")
    OpenIcon.Parent = ScreenGui
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 12)
    IconCorner.Parent = OpenIcon

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 540, 0, 380)
    Main.Position = UDim2.new(0.5, -270, 0.5, -190)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(44, 44, 44)
    MainStroke.Parent = Main

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    Header.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Text = config.title or "Dream Library"
    Title.Size = UDim2.new(0, 200, 0, 30)
    Title.Position = UDim2.new(0, 15, 0, 5)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Text = config.subtitle or "Premium Edition"
    Subtitle.Size = UDim2.new(0, 200, 0, 20)
    Subtitle.Position = UDim2.new(0, 15, 0, 25)
    Subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextSize = 11
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = Header

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0, 10)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 86)
    CloseBtn.Text = ""
    CloseBtn.Parent = Header
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -80, 0, 10)
    MinBtn.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
    MinBtn.Text = ""
    MinBtn.Parent = Header
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0)

    if config.draggable then
        local dragging, dragInput, dragStart, startPos
        Header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = Main.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
    end

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 1, -50)
    Container.Position = UDim2.new(0, 0, 0, 50)
    Container.BackgroundTransparency = 1
    Container.Parent = Main

    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 130, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    Sidebar.Parent = Container

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar

    local ContentHolder = Instance.new("Frame")
    ContentHolder.Size = UDim2.new(1, -130, 1, 0)
    ContentHolder.Position = UDim2.new(0, 130, 0, 0)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Parent = Container

    function Library:AddTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 40)
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.Parent = Sidebar

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.Parent = ContentHolder
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
        Instance.new("UIPadding", Page).PaddingTop = UDim.new(0, 10)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentHolder:GetChildren()) do v.Visible = false end
            for _, v in pairs(Sidebar:GetChildren()) do 
                if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) end
            end
            Page.Visible = true
            TabBtn.TextColor3 = Library.Accent
        end)

        local Elements = {}

        function Elements:AddButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0, 380, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            Btn.Text = text
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Parent = Page
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
            Btn.MouseButton1Click:Connect(callback)
        end

        function Elements:AddToggle(text, callback)
            local TglFrame = Instance.new("Frame")
            TglFrame.Size = UDim2.new(0, 380, 0, 40)
            TglFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            TglFrame.Parent = Page
            Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 6)

            local TglText = Instance.new("TextLabel")
            TglText.Text = text
            TglText.Size = UDim2.new(1, -50, 1, 0)
            TglText.Position = UDim2.new(0, 10, 0, 0)
            TglText.BackgroundTransparency = 1
            TglText.TextColor3 = Color3.fromRGB(255, 255, 255)
            TglText.TextXAlignment = Enum.TextXAlignment.Left
            TglText.Parent = TglFrame

            local TglBtn = Instance.new("TextButton")
            TglBtn.Size = UDim2.new(0, 35, 0, 20)
            TglBtn.Position = UDim2.new(1, -45, 0.5, -10)
            TglBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            TglBtn.Text = ""
            TglBtn.Parent = TglFrame
            Instance.new("UICorner", TglBtn).CornerRadius = UDim.new(1, 0)

            local enabled = false
            TglBtn.MouseButton1Click:Connect(function()
                enabled = not enabled
                TweenService:Create(TglBtn, TweenInfo.new(0.3), {BackgroundColor3 = enabled and Library.Accent or Color3.fromRGB(50, 50, 55)}):Play()
                callback(enabled)
            end)
        end

        function Elements:AddSlider(text, min, max, default, callback)
            local SldFrame = Instance.new("Frame")
            SldFrame.Size = UDim2.new(0, 380, 0, 50)
            SldFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            SldFrame.Parent = Page
            Instance.new("UICorner", SldFrame).CornerRadius = UDim.new(0, 6)

            local SldText = Instance.new("TextLabel")
            SldText.Text = text .. ": " .. default
            SldText.Size = UDim2.new(1, 0, 0, 25)
            SldText.Position = UDim2.new(0, 10, 0, 0)
            SldText.BackgroundTransparency = 1
            SldText.TextColor3 = Color3.fromRGB(255, 255, 255)
            SldText.TextXAlignment = Enum.TextXAlignment.Left
            SldText.Parent = SldFrame

            local Bar = Instance.new("Frame")
            Bar.Size = UDim2.new(1, -20, 0, 4)
            Bar.Position = UDim2.new(0, 10, 0.7, 0)
            Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            Bar.Parent = SldFrame

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Library.Accent
            Fill.Parent = Bar

            local dragging = false
            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    local val = math.floor(min + (max - min) * pos)
                    SldText.Text = text .. ": " .. val
                    callback(val)
                end
            end)
        end

        return Elements
    end

    MinBtn.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)
    OpenIcon.MouseButton1Click:Connect(function()
        Main.Visible = true
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    return Library
end

return DreamLib
