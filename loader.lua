local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local DreamLib = {}

function DreamLib:CreateWindow(Config)
    local Window = {}
    local CurrentTab = nil
    local Accent = Config.Color or Color3.fromRGB(195, 132, 255)
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DreamLibrary"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = CoreGui

    local OpenBtn = Instance.new("ImageButton")
    OpenBtn.Name = "OpenButton"
    OpenBtn.Size = UDim2.new(0, 50, 0, 50)
    OpenBtn.Position = UDim2.new(0, 50, 0, 50)
    OpenBtn.BackgroundColor3 = Accent
    OpenBtn.Image = "rbxassetid://" .. (Config.Icon or "6031094678")
    OpenBtn.Visible = false
    OpenBtn.Parent = ScreenGui
    local OpenCorner = Instance.new("UICorner")
    OpenCorner.CornerRadius = UDim.new(0, 14)
    OpenCorner.Parent = OpenBtn
    local OpenShadow = Instance.new("ImageLabel")
    OpenShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    OpenShadow.Position = UDim2.new(0.5, 0, 0.5, 5)
    OpenShadow.Size = UDim2.new(1, 10, 1, 10)
    OpenShadow.BackgroundTransparency = 1
    OpenShadow.Image = "rbxassetid://6014261993"
    OpenShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    OpenShadow.ImageTransparency = 0.6
    OpenShadow.ZIndex = 0
    OpenShadow.Parent = OpenBtn

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(0, 580, 0, 430)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.Parent = ScreenGui

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 540, 0, 390)
    Main.Position = UDim2.new(0.5, -270, 0.5, -195)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = Shadow

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(45, 45, 48)
    MainStroke.Thickness = 1
    MainStroke.Parent = Main

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    Header.BorderSizePixel = 0
    Header.Parent = Main

    local HeaderLine = Instance.new("Frame")
    HeaderLine.Size = UDim2.new(1, 0, 0, 1)
    HeaderLine.Position = UDim2.new(0, 0, 1, -1)
    HeaderLine.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    HeaderLine.BorderSizePixel = 0
    HeaderLine.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Text = Config.Title or "Dream Library"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Accent
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 12, 0, 12)
    CloseBtn.Position = UDim2.new(1, -25, 0.5, -6)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    CloseBtn.Text = ""
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = Header
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseBtn

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 12, 0, 12)
    MinBtn.Position = UDim2.new(1, -45, 0.5, -6)
    MinBtn.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
    MinBtn.Text = ""
    MinBtn.AutoButtonColor = false
    MinBtn.Parent = Header
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(1, 0)
    MinCorner.Parent = MinBtn

    if Config.Draggable then
        local dragging, dragInput, dragStart, startPos
        Header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = Shadow.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                TweenService:Create(Shadow, TweenInfo.new(0.05), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
    end

    local function ToggleUI()
        if Shadow.Visible then
            TweenService:Create(Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            wait(0.3)
            Shadow.Visible = false
            OpenBtn.Visible = true
            OpenBtn.Size = UDim2.new(0,0,0,0)
            TweenService:Create(OpenBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 50, 0, 50)}):Play()
        else
            OpenBtn.Visible = false
            Shadow.Visible = true
            Shadow.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(Shadow, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 580, 0, 430)}):Play()
        end
    end

    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    MinBtn.MouseButton1Click:Connect(ToggleUI)
    OpenBtn.MouseButton1Click:Connect(ToggleUI)

    local dragIcon, dStart, dPos
    OpenBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragIcon=true dStart=i.Position dPos=OpenBtn.Position end end)
    UserInputService.InputChanged:Connect(function(i) if dragIcon and i.UserInputType==Enum.UserInputType.MouseMovement then local d=i.Position-dStart OpenBtn.Position=UDim2.new(dPos.X.Scale, dPos.X.Offset+d.X, dPos.Y.Scale, dPos.Y.Offset+d.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragIcon=false end end)

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 1, -45)
    Container.Position = UDim2.new(0, 0, 0, 45)
    Container.BackgroundTransparency = 1
    Container.Parent = Main

    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 130, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    Sidebar.Parent = Container

    local SidebarBorder = Instance.new("Frame")
    SidebarBorder.Size = UDim2.new(0, 1, 1, 0)
    SidebarBorder.Position = UDim2.new(1, -1, 0, 0)
    SidebarBorder.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    SidebarBorder.BorderSizePixel = 0
    SidebarBorder.Parent = Sidebar

    local SideLayout = Instance.new("UIListLayout")
    SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SideLayout.Padding = UDim.new(0, 2)
    SideLayout.Parent = Sidebar

    local SidePad = Instance.new("UIPadding")
    SidePad.PaddingTop = UDim.new(0, 10)
    SidePad.Parent = Sidebar

    local Pages = Instance.new("Frame")
    Pages.Size = UDim2.new(1, -130, 1, 0)
    Pages.Position = UDim2.new(0, 130, 0, 0)
    Pages.BackgroundTransparency = 1
    Pages.Parent = Container

    function Window:Tab(Name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = Name
        TabBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.Parent = Sidebar

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 3, 0.6, 0)
        Indicator.Position = UDim2.new(0, 0, 0.2, 0)
        Indicator.BackgroundColor3 = Accent
        Indicator.BorderSizePixel = 0
        Indicator.Visible = false
        Indicator.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Accent
        Page.Visible = false
        Page.Parent = Pages
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = Page
        local PagePad = Instance.new("UIPadding")
        PagePad.PaddingTop = UDim.new(0, 15)
        PagePad.PaddingLeft = UDim.new(0, 15)
        PagePad.PaddingRight = UDim.new(0, 15)
        PagePad.Parent = Page

        TabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(100, 100, 100)}):Play()
                    v.Frame.Visible = false
                    v.BackgroundTransparency = 1
                end
            end
            for _,v in pairs(Pages:GetChildren()) do v.Visible = false end
            
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.95}):Play()
            TabBtn.BackgroundColor3 = Accent
            Indicator.Visible = true
            Page.Visible = true
        end)

        if not CurrentTab then
            CurrentTab = TabBtn
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.Visible = true
            Page.Visible = true
        end

        local Elements = {}

        function Elements:Button(Text, Callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 34)
            Btn.BackgroundColor3 = Color3.fromRGB(32, 32, 35)
            Btn.Text = Text
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 13
            Btn.AutoButtonColor = false
            Btn.Parent = Page
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = Btn
            
            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Color = Color3.fromRGB(50, 50, 55)
            BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            BtnStroke.Parent = Btn

            Btn.MouseEnter:Connect(function() TweenService:Create(BtnStroke, TweenInfo.new(0.3), {Color = Accent}):Play() end)
            Btn.MouseLeave:Connect(function() TweenService:Create(BtnStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(50, 50, 55)}):Play() end)
            Btn.MouseButton1Click:Connect(function()
                Callback()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 48)}):Play()
                wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(32, 32, 35)}):Play()
            end)
        end

        function Elements:Toggle(Text, Default, Callback)
            local Enabled = Default or false
            local Tgl = Instance.new("TextButton")
            Tgl.Size = UDim2.new(1, 0, 0, 34)
            Tgl.BackgroundColor3 = Color3.fromRGB(32, 32, 35)
            Tgl.Text = ""
            Tgl.AutoButtonColor = false
            Tgl.Parent = Page
            Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 6)
            local TglStroke = Instance.new("UIStroke")
            TglStroke.Color = Color3.fromRGB(50, 50, 55)
            TglStroke.Parent = Tgl

            local TglLabel = Instance.new("TextLabel")
            TglLabel.Text = Text
            TglLabel.Size = UDim2.new(1, -50, 1, 0)
            TglLabel.Position = UDim2.new(0, 12, 0, 0)
            TglLabel.BackgroundTransparency = 1
            TglLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TglLabel.Font = Enum.Font.Gotham
            TglLabel.TextSize = 13
            TglLabel.TextXAlignment = Enum.TextXAlignment.Left
            TglLabel.Parent = Tgl

            local Switch = Instance.new("Frame")
            Switch.Size = UDim2.new(0, 36, 0, 18)
            Switch.Position = UDim2.new(1, -48, 0.5, -9)
            Switch.BackgroundColor3 = Enabled and Accent or Color3.fromRGB(55, 55, 60)
            Switch.Parent = Tgl
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

            local Dot = Instance.new("Frame")
            Dot.Size = UDim2.new(0, 14, 0, 14)
            Dot.Position = Enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Dot.Parent = Switch
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

            Tgl.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                Callback(Enabled)
                TweenService:Create(Switch, TweenInfo.new(0.3), {BackgroundColor3 = Enabled and Accent or Color3.fromRGB(55, 55, 60)}):Play()
                TweenService:Create(Dot, TweenInfo.new(0.3), {Position = Enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
            end)
        end

        function Elements:Slider(Text, Min, Max, Default, Callback)
            local Value = Default or Min
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 48)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 35)
            SliderFrame.Parent = Page
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)
            Instance.new("UIStroke", SliderFrame).Color = Color3.fromRGB(50, 50, 55)

            local Label = Instance.new("TextLabel")
            Label.Text = Text
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Position = UDim2.new(0, 12, 0, 5)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SliderFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Text = tostring(Value)
            ValueLabel.Size = UDim2.new(0, 50, 0, 20)
            ValueLabel.Position = UDim2.new(1, -60, 0, 5)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            ValueLabel.Font = Enum.Font.Gotham
            ValueLabel.TextSize = 13
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SliderFrame

            local Bar = Instance.new("Frame")
            Bar.Size = UDim2.new(1, -24, 0, 4)
            Bar.Position = UDim2.new(0, 12, 0, 32)
            Bar.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
            Bar.Parent = SliderFrame
            Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = Accent
            Fill.Parent = Bar
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            local function Update(Input)
                local SizeX = math.clamp((Input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local NewValue = math.floor(Min + ((Max - Min) * SizeX))
                Value = NewValue
                ValueLabel.Text = tostring(Value)
                TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(SizeX, 0, 1, 0)}):Play()
                Callback(Value)
            end

            SliderFrame.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local dragging = true
                    Update(Input)
                    local con
                    con = UserInputService.InputChanged:Connect(function(Move)
                        if Move.UserInputType == Enum.UserInputType.MouseMovement then
                            Update(Move)
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(End)
                        if End.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                            con:Disconnect()
                        end
                    end)
                end
            end)
        end

        function Elements:Dropdown(Text, Options, Callback)
            local Dropped = false
            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, 0, 0, 34)
            DropFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 35)
            DropFrame.ClipsDescendants = true
            DropFrame.ZIndex = 2
            DropFrame.Parent = Page
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)
            local Stroke = Instance.new("UIStroke")
            Stroke.Color = Color3.fromRGB(50, 50, 55)
            Stroke.Parent = DropFrame

            local Trigger = Instance.new("TextButton")
            Trigger.Size = UDim2.new(1, 0, 1, 0)
            Trigger.BackgroundTransparency = 1
            Trigger.Text = ""
            Trigger.Parent = DropFrame

            local Label = Instance.new("TextLabel")
            Label.Text = Text .. "..."
            Label.Size = UDim2.new(1, -30, 0, 34)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = DropFrame

            local Arrow = Instance.new("ImageLabel")
            Arrow.Size = UDim2.new(0, 20, 0, 20)
            Arrow.Position = UDim2.new(1, -30, 0, 7)
            Arrow.BackgroundTransparency = 1
            Arrow.Image = "rbxassetid://6034818372"
            Arrow.Parent = DropFrame

            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, 0, 0, 0)
            Container.Position = UDim2.new(0, 0, 0, 34)
            Container.BackgroundTransparency = 1
            Container.Parent = DropFrame
            local Layout = Instance.new("UIListLayout")
            Layout.SortOrder = Enum.SortOrder.LayoutOrder
            Layout.Parent = Container

            for _, Option in pairs(Options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 30)
                OptBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
                OptBtn.Text = Option
                OptBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 13
                OptBtn.Parent = Container
                OptBtn.MouseButton1Click:Connect(function()
                    Label.Text = Text .. ": " .. Option
                    Callback(Option)
                    Dropped = false
                    TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 34)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                end)
            end

            Trigger.MouseButton1Click:Connect(function()
                Dropped = not Dropped
                local Height = Dropped and (#Options * 30) + 34 or 34
                TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, Height)}):Play()
                TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = Dropped and 180 or 0}):Play()
            end)
        end

        function Elements:TextBox(Text, Placeholder, Callback)
            local BoxFrame = Instance.new("Frame")
            BoxFrame.Size = UDim2.new(1, 0, 0, 34)
            BoxFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 35)
            BoxFrame.Parent = Page
            Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 6)
            Instance.new("UIStroke", BoxFrame).Color = Color3.fromRGB(50, 50, 55)

            local Label = Instance.new("TextLabel")
            Label.Text = Text
            Label.Size = UDim2.new(0, 100, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = BoxFrame

            local Input = Instance.new("TextBox")
            Input.Size = UDim2.new(0, 120, 0, 20)
            Input.Position = UDim2.new(1, -132, 0, 7)
            Input.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
            Input.PlaceholderText = Placeholder
            Input.Text = ""
            Input.TextColor3 = Color3.fromRGB(255, 255, 255)
            Input.Font = Enum.Font.Gotham
            Input.TextSize = 12
            Input.Parent = BoxFrame
            Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 4)

            Input.FocusLost:Connect(function()
                Callback(Input.Text)
            end)
        end

        return Elements
    end

    return Window
end

return DreamLib
