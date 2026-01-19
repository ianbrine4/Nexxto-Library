local Library = {}
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

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

function Library:Init(cfg)
    local MainUI = Instance.new("ScreenGui", CoreGui)
    MainUI.Name = "Nexxto_Syde"
    
    local Main = Instance.new("Frame", MainUI)
    Main.Size = cfg.Size or UDim2.new(0, 580, 0, 380)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    
    local Outline = Instance.new("UIStroke", Main)
    Outline.Color = Color3.fromRGB(35, 35, 35)
    Outline.Thickness = 1
    Outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
    Sidebar.BorderSizePixel = 0
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)
    
    local SideOutline = Instance.new("Frame", Sidebar)
    SideOutline.Size = UDim2.new(0, 1, 1, -20)
    SideOutline.Position = UDim2.new(1, 0, 0, 10)
    SideOutline.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SideOutline.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", Sidebar)
    Title.Text = cfg.Title or "SYDE"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 15, 0, 10)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, -10, 1, -80)
    TabContainer.Position = UDim2.new(0, 5, 0, 60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 4)

    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(1, -170, 1, -10)
    Content.Position = UDim2.new(0, 165, 0, 5)
    Content.BackgroundTransparency = 1

    makeDraggable(Main, Sidebar)

    local Window = {}
    function Window:InitTab(name, iconId)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 34)
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "          " .. name
        TabBtn.TextColor3 = Color3.fromRGB(140, 140, 140)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Icon = Instance.new("ImageLabel", TabBtn)
        Icon.Size = UDim2.new(0, 18, 0, 18)
        Icon.Position = UDim2.new(0, 10, 0.5, -9)
        Icon.BackgroundTransparency = 1
        Icon.Image = "rbxassetid://" .. (iconId or 0)
        Icon.ImageColor3 = Color3.fromRGB(140, 140, 140)

        local Page = Instance.new("ScrollingFrame", Content)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        local pList = Instance.new("UIListLayout", Page)
        pList.Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundTransparency = 1
                    v.TextColor3 = Color3.fromRGB(140, 140, 140)
                    v.ImageLabel.ImageColor3 = Color3.fromRGB(140, 140, 140)
                end
            end
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0.95
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Icon.ImageColor3 = Color3.fromRGB(0, 160, 255)
        end)

        local Elements = {}
        function Elements:Section(title)
            local s = Instance.new("TextLabel", Page)
            s.Text = title:upper()
            s.Size = UDim2.new(1, 0, 0, 25)
            s.TextColor3 = Color3.fromRGB(100, 100, 100)
            s.Font = Enum.Font.GothamBold
            s.TextSize = 10
            s.BackgroundTransparency = 1
            s.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Elements:Button(bcfg)
            local b = Instance.new("TextButton", Page)
            b.Size = UDim2.new(1, -10, 0, 42)
            b.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            b.Text = "  " .. bcfg.Title
            b.TextColor3 = Color3.fromRGB(230, 230, 230)
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.Font = Enum.Font.Gotham
            b.TextSize = 13
            Instance.new("UICorner", b)
            Instance.new("UIStroke", b).Color = Color3.fromRGB(30, 30, 30)
            b.MouseButton1Click:Connect(bcfg.CallBack)
        end

        return Elements
    end
    return Window
end

return Library
