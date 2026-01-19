local Library = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local function makeDraggable(obj, dragPart)
    local dragging, dragInput, dragStart, startPos
    local target = dragPart or obj
    target.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true dragStart = input.Position startPos = obj.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

function Library:CreateWindow(cfg)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Nexxto_Modern"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Logo = Instance.new("ImageButton")
    Logo.Size = UDim2.new(0, 45, 0, 45)
    Logo.Position = UDim2.new(0, 50, 0, 50)
    Logo.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Logo.Image = cfg.Icon or ""
    Logo.Parent = ScreenGui
    Instance.new("UICorner", Logo).CornerRadius = UDim.new(0, 10)
    makeDraggable(Logo)

    local Main = Instance.new("Frame")
    Main.Size = cfg.Size or UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    makeDraggable(Main)

    Logo.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TopBar.Parent = Main
    
    local Title = Instance.new("TextLabel")
    Title.Text = cfg.Title .. " | " .. (cfg.Subtitle or "")
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.TextColor3 = Color3.fromRGB(200, 200, 200)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamSemibold
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    local Btns = Instance.new("Frame")
    Btns.Size = UDim2.new(0, 90, 1, 0)
    Btns.Position = UDim2.new(1, -95, 0, 0)
    Btns.BackgroundTransparency = 1
    Btns.Parent = TopBar
    Instance.new("UIListLayout", Btns).FillDirection = Enum.FillDirection.Horizontal

    local function createTopBtn(icon, color, callback)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 30, 1, 0)
        b.BackgroundTransparency = 1
        b.Text = icon
        b.TextColor3 = color
        b.Font = Enum.Font.GothamBold
        b.Parent = Btns
        b.MouseButton1Click:Connect(callback)
    end

    createTopBtn("-", Color3.fromRGB(200, 200, 200), function() Main.Visible = false end)
    createTopBtn("□", Color3.fromRGB(200, 200, 200), function() 
        Main.Size = (Main.Size == UDim2.new(0, 550, 0, 350)) and UDim2.new(0, 700, 0, 450) or UDim2.new(0, 550, 0, 350)
    end)
    createTopBtn("×", Color3.fromRGB(255, 100, 100), function() ScreenGui:Destroy() end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 140, 1, -40)
    Sidebar.Position = UDim2.new(0, 5, 0, 35)
    Sidebar.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    Sidebar.Parent = Main
    Instance.new("UICorner", Sidebar)
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 2)

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -155, 1, -40)
    Content.Position = UDim2.new(0, 150, 0, 35)
    Content.BackgroundTransparency = 1
    Content.Parent = Main

    local Tabs = {}
    function Tabs:CreateTab(name, iconId)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "      " .. name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.Parent = Sidebar

        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 16, 0, 16)
        Icon.Position = UDim2.new(0, 8, 0.5, -8)
        Icon.BackgroundTransparency = 1
        Icon.Image = "rbxassetid://" .. (iconId or 0)
        Icon.ImageColor3 = Color3.fromRGB(150, 150, 150)
        Icon.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, -10, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        Page.Parent = Content
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) v.ImageLabel.ImageColor3 = Color3.fromRGB(150, 150, 150) end end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Icon.ImageColor3 = Color3.fromRGB(0, 170, 255)
        end)

        local Elements = {}
        
        function Elements:AddDropdown(text, list, callback)
            local Drop = Instance.new("TextButton")
            Drop.Size = UDim2.new(1, 0, 0, 35)
            Drop.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            Drop.Text = "  " .. text .. " : None"
            Drop.TextColor3 = Color3.fromRGB(200, 200, 200)
            Drop.TextXAlignment = Enum.TextXAlignment.Left
            Drop.Parent = Page
            Instance.new("UICorner", Drop)

            local Open = false
            Drop.MouseButton1Click:Connect(function()
                Open = not Open
                Drop.Size = Open and UDim2.new(1, 0, 0, 100) or UDim2.new(1, 0, 0, 35)
            end)
        end

        function Elements:AddColorPicker(text, default, callback)
            local CP = Instance.new("Frame")
            CP.Size = UDim2.new(1, 0, 0, 35)
            CP.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            CP.Parent = Page
            Instance.new("UICorner", CP)

            local Lbl = Instance.new("TextLabel")
            Lbl.Text = "  " .. text
            Lbl.Size = UDim2.new(1, 0, 1, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = CP

            local Box = Instance.new("TextButton")
            Box.Size = UDim2.new(0, 25, 0, 25)
            Box.Position = UDim2.new(1, -35, 0.5, -12)
            Box.BackgroundColor3 = default
            Box.Text = ""
            Box.Parent = CP
            Instance.new("UICorner", Box)
        end

        return Elements
    end
    return Tabs
end

return Library
