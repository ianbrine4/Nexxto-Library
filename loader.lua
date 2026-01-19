local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function Library:CreateWindow(hubName, logoId)
    local UI = { CurrentTab = nil }
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Nexxto_UI"
    ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- [DRAGGING SYSTEM]
    local function makeDraggable(frame)
        local dragging, dragInput, dragStart, startPos
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true dragStart = input.Position startPos = frame.Position
                input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
            end
        end)
        frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    -- [LOGO TOGGLE]
    local Logo = Instance.new("ImageButton")
    Logo.Size = UDim2.new(0, 48, 0, 48)
    Logo.Position = UDim2.new(0, 25, 0, 25)
    Logo.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Logo.Image = "rbxassetid://" .. (logoId or 0)
    Logo.Parent = ScreenGui
    Instance.new("UICorner", Logo).CornerRadius = UDim.new(0, 10)

    -- [MAIN FRAME]
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main)
    makeDraggable(Main)

    Logo.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    -- Sidebar & Container Setup
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 150, 1, -20)
    Sidebar.Position = UDim2.new(0, 10, 0, 10)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = Main
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -175, 1, -20)
    Container.Position = UDim2.new(0, 165, 0, 10)
    Container.BackgroundTransparency = 1
    Container.Parent = Main

    -- [TAB API]
    function UI:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 38)
        TabBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        TabBtn.Text = "      " .. tabName
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.Parent = Sidebar
        Instance.new("UICorner", TabBtn)

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 3, 0.5, 0)
        Indicator.Position = UDim2.new(0, 2, 0.25, 0)
        Indicator.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
        Indicator.Visible = false
        Indicator.Name = "Line"
        Indicator.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.Parent = Container
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    v.Line.Visible = false
                    v.TextColor3 = Color3.fromRGB(150, 150, 150)
                end
            end
            Page.Visible = true
            Indicator.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        -- [ELEMENT API]
        local Elements = {}
        function Elements:AddButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -10, 0, 40)
            Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Btn.Text = text
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.Parent = Page
            Instance.new("UICorner", Btn)
            Btn.MouseButton1Click:Connect(callback)
            return Btn
        end
        return Elements
    end
    return UI
end

return Library
