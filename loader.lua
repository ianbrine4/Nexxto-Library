local Library = {ToggleKey = Enum.KeyCode.RightShift}
local UIS, TS, CoreGui = game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("CoreGui")

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

function Library:Notify(cfg)
    local n = Instance.new("Frame")
    n.Size = UDim2.new(0, 250, 0, 60)
    n.Position = UDim2.new(1, 10, 1, -70)
    n.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    n.Parent = CoreGui:FindFirstChild("NexxtoUI") or CoreGui
    Instance.new("UICorner", n)
    Instance.new("UIStroke", n).Color = Color3.fromRGB(30, 30, 30)
    
    local t = Instance.new("TextLabel")
    t.Text = cfg.Title or "Notification"
    t.Size = UDim2.new(1, -10, 0, 25)
    t.Position = UDim2.new(0, 10, 0, 5)
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.Font = Enum.Font.GothamBold
    t.BackgroundTransparency = 1
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = n

    local c = Instance.new("TextLabel")
    c.Text = cfg.Content or ""
    c.Size = UDim2.new(1, -10, 0, 20)
    c.Position = UDim2.new(0, 10, 0, 25)
    c.TextColor3 = Color3.fromRGB(180, 180, 180)
    c.Font = Enum.Font.Gotham
    c.BackgroundTransparency = 1
    c.TextXAlignment = Enum.TextXAlignment.Left
    c.Parent = n

    TS:Create(n, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1, -260, 1, -70)}):Play()
    task.delay(cfg.Duration or 3, function()
        TS:Create(n, TweenInfo.new(0.5), {Position = UDim2.new(1, 10, 1, -70)}):Play()
        task.wait(0.5) n:Destroy()
    end)
end

function Library:Init(cfg)
    local SG = Instance.new("ScreenGui", CoreGui)
    SG.Name = "NexxtoUI"
    
    local Main = Instance.new("Frame", SG)
    Main.Size = UDim2.new(0, 550, 0, 380)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    makeDraggable(Main)

    local Top = Instance.new("Frame", Main)
    Top.Size = UDim2.new(1, 0, 0, 40)
    Top.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel", Top)
    Title.Text = cfg.Title or "Syde UI"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Sub = Instance.new("TextLabel", Top)
    Sub.Text = cfg.SubText or ""
    Sub.Position = UDim2.new(0, 15, 0, 22)
    Sub.TextColor3 = Color3.fromRGB(120, 120, 120)
    Sub.Font = Enum.Font.Gotham
    Sub.TextSize = 10
    Sub.BackgroundTransparency = 1
    Sub.Parent = Top

    local TabHolder = Instance.new("Frame", Main)
    TabHolder.Size = UDim2.new(0, 150, 1, -50)
    TabHolder.Position = UDim2.new(0, 10, 0, 45)
    TabHolder.BackgroundTransparency = 1
    local TabList = Instance.new("UIListLayout", TabHolder)
    TabList.Padding = UDim.new(0, 5)

    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -180, 1, -50)
    Container.Position = UDim2.new(0, 170, 0, 45)
    Container.BackgroundTransparency = 1

    local Window = {}
    function Window:InitTab(name)
        local TabBtn = Instance.new("TextButton", TabHolder)
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.Gotham
        Instance.new("UICorner", TabBtn)

        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        local pList = Instance.new("UIListLayout", Page)
        pList.Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            Page.Visible = true
        end)

        local Elements = {}
        function Elements:Section(title)
            local s = Instance.new("TextLabel", Page)
            s.Text = title:upper()
            s.Size = UDim2.new(1, 0, 0, 20)
            s.TextColor3 = Color3.fromRGB(0, 170, 255)
            s.Font = Enum.Font.GothamBold
            s.TextSize = 10
            s.BackgroundTransparency = 1
            s.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Elements:Button(bcfg)
            local b = Instance.new("TextButton", Page)
            b.Size = UDim2.new(1, -5, 0, 40)
            b.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            b.Text = "  " .. bcfg.Title
            b.TextColor3 = Color3.fromRGB(220, 220, 220)
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.Font = Enum.Font.Gotham
            Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(bcfg.CallBack)
        end

        return Elements
    end
    return Window
end

return Library
