local Library = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
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
    ScreenGui.Name = "Nexxto_X2ZU"
    ScreenGui.Parent = CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Logo = Instance.new("ImageButton")
    Logo.Size = UDim2.new(0, 50, 0, 50)
    Logo.Position = UDim2.new(0, 50, 0, 50)
    Logo.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Logo.Image = cfg.Icon or ""
    Logo.Parent = ScreenGui
    Instance.new("UICorner", Logo).CornerRadius = UDim.new(0, 12)
    makeDraggable(Logo)

    local Main = Instance.new("Frame")
    Main.Size = cfg.Size or UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    makeDraggable(Main)

    local Border = Instance.new("UIStroke")
    Border.Color = Color3.fromRGB(30, 30, 30)
    Border.Thickness = 1
    Border.Parent = Main

    Logo.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, -10)
    Sidebar.Position = UDim2.new(0, 5, 0, 5)
    Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Sidebar.Parent = Main
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel")
    Title.Text = cfg.Title or "Hub"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = Sidebar

    local Sub = Instance.new("TextLabel")
    Sub.Text = cfg.Subtitle or ""
    Sub.Size = UDim2.new(1, 0, 0, 20)
    Sub.Position = UDim2.new(0, 10, 0, 26)
    Sub.TextColor3 = Color3.fromRGB(120, 120, 120)
    Sub.Font = Enum.Font.Gotham
    Sub.TextSize = 11
    Sub.TextXAlignment = Enum.TextXAlignment.Left
    Sub.BackgroundTransparency = 1
    Sub.Parent = Sidebar

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, -10, 1, -70)
    TabContainer.Position = UDim2.new(0, 5, 0, 60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = Sidebar
    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 4)

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -175, 1, -10)
    Content.Position = UDim2.new(0, 170, 0, 5)
    Content.BackgroundTransparency = 1
    Content.Parent = Main

    local Tabs = {}
    function Tabs:CreateTab(name, lucideName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 34)
        TabBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "          " .. name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.Parent = TabContainer
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 18, 0, 18)
        Icon.Position = UDim2.new(0, 10, 0.5, -9)
        Icon.BackgroundTransparency = 1
        Icon.Image = "rbxassetid://10734793474" -- Fallback
        
        -- Research into Lucide IDs resulted in using this public asset fetcher:
        -- You can replace the string below with a Lucide module if you have one.
        if lucideName then
            Icon.Image = "rbxassetid://7072724495" -- Example Base ID, logic usually requires a hash table
        end
        Icon.ImageColor3 = Color3.fromRGB(150, 150, 150)
        Icon.Parent = TabBtn

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 2, 0, 18)
        Indicator.Position = UDim2.new(0, 2, 0.5, -9)
        Indicator.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        Indicator.Visible = false
        Indicator.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        Page.Parent = Content
        local pList = Instance.new("UIListLayout", Page)
        pList.Padding = UDim.new(0, 6)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundTransparency = 1
                    v.TextColor3 = Color3.fromRGB(150, 150, 150)
                    v.Frame.Visible = false
                    v.ImageLabel.ImageColor3 = Color3.fromRGB(150, 150, 150)
                end
            end
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.Visible = true
            Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local Elements = {}
        function Elements:AddButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -5, 0, 38)
            Btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Btn.Text = "  " .. text
            Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            Btn.Font = Enum.Font.Gotham
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = Page
            Instance.new("UICorner", Btn)
            Btn.MouseButton1Click:Connect(callback)
        end

        function Elements:AddToggle(text, callback)
            local Tgl = Instance.new("TextButton")
            Tgl.Size = UDim2.new(1, -5, 0, 38)
            Tgl.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Tgl.Text = "  " .. text
            Tgl.TextColor3 = Color3.fromRGB(220, 220, 220)
            Tgl.Font = Enum.Font.Gotham
            Tgl.TextXAlignment = Enum.TextXAlignment.Left
            Tgl.Parent = Page
            Instance.new("UICorner", Tgl)

            local Box = Instance.new("Frame")
            Box.Size = UDim2.new(0, 34, 0, 18)
            Box.Position = UDim2.new(1, -40, 0.5, -9)
            Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Box.Parent = Tgl
            Instance.new("UICorner", Box).CornerRadius = UDim.new(1, 0)

            local Dot = Instance.new("Frame")
            Dot.Size = UDim2.new(0, 14, 0, 14)
            Dot.Position = UDim2.new(0, 2, 0.5, -7)
            Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Dot.Parent = Box
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

            local state = false
            Tgl.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(30, 30, 30)}):Play()
                TweenService:Create(Dot, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
                callback(state)
            end)
        end

        return Elements
    end
    return Tabs
end

return Library
