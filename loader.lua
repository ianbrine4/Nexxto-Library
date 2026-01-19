local Library = {}
local TweenService = game:GetService("TweenService")

function Library.new(title, logoId)
    local UI = { CurrentTab = nil }
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernLib"
    ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    -- Main Toggle Button (Logo)
    local LogoToggle = Instance.new("ImageButton")
    LogoToggle.Size = UDim2.new(0, 50, 0, 50)
    LogoToggle.Position = UDim2.new(0, 20, 0, 20)
    LogoToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    LogoToggle.Image = "rbxassetid://" .. (logoId or "0")
    LogoToggle.Parent = ScreenGui
    
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 12)
    LogoCorner.Parent = LogoToggle

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Darker Black
    Main.BorderSizePixel = 0
    Main.Visible = true
    Main.Parent = ScreenGui

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

    -- Toggle Visibility Logic
    LogoToggle.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)

    -- Sidebar Area
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 150, 1, -20)
    Sidebar.Position = UDim2.new(0, 10, 0, 10)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = Main

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = Sidebar

    -- Container for Tab Contents
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -170, 1, -20)
    Container.Position = UDim2.new(0, 160, 0, 10)
    Container.BackgroundTransparency = 1
    Container.Parent = Main

    function UI:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 40)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 14
        TabBtn.Parent = Sidebar
        
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        -- The Line Indicator (Left Side)
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 4, 0.6, 0)
        Indicator.Position = UDim2.new(0, 0, 0.2, 0)
        Indicator.BackgroundColor3 = Color3.fromRGB(0, 170, 255) -- Modern Blue
        Indicator.BorderSizePixel = 0
        Indicator.Visible = false
        Indicator.Parent = TabBtn

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.ScrollBarThickness = 0
        TabPage.Parent = Container
        Instance.new("UIListLayout", TabPage).Padding = UDim.new(0, 10)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do v.Visible = false end
            for _, v in pairs(Sidebar:GetChildren()) do 
                if v:IsA("TextButton") then 
                    v.Indicator.Visible = false 
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
                end 
            end
            
            TabPage.Visible = true
            Indicator.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        end)

        local TabItems = {}
        function TabItems:AddButton(txt, callback)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 40)
            b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            b.Text = txt
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.Parent = TabPage
            Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(callback)
        end

        return TabItems
    end

    return UI
end

return Library
