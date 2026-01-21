local Library = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local function Drag(obj, handle)
    local dragging, inputStart, startPos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            inputStart = i.Position
            startPos = obj.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - inputStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

function Library:CreateWindow(cfg)
    local scr = Instance.new("ScreenGui", CoreGui)
    scr.Name = "Nexxto"
    
    local main = Instance.new("Frame", scr)
    main.Size = UDim2.new(0, cfg.size.X, 0, cfg.size.Y)
    main.Position = UDim2.new(0.5, -cfg.size.X/2, 0.5, -cfg.size.Y/2)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    main.BorderSizePixel = 0
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
    local ms = Instance.new("UIStroke", main)
    ms.Color = Color3.fromRGB(40, 40, 40)
    ms.Transparency = 0.5

    local head = Instance.new("Frame", main)
    head.Size = UDim2.new(1, 0, 0, 60)
    head.BackgroundTransparency = 1
    Drag(main, head)

    local tl = Instance.new("TextLabel", head)
    tl.Text = cfg.title:upper()
    tl.Position = UDim2.new(0, 20, 0, 15)
    tl.Size = UDim2.new(0, 200, 0, 20)
    tl.TextColor3 = Color3.fromRGB(255, 255, 255)
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 18
    tl.TextXAlignment = 0
    tl.BackgroundTransparency = 1

    local st = Instance.new("TextLabel", head)
    st.Text = cfg.subtitle
    st.Position = UDim2.new(0, 20, 0, 35)
    st.Size = UDim2.new(0, 200, 0, 15)
    st.TextColor3 = Color3.fromRGB(0, 229, 255)
    st.Font = Enum.Font.GothamMedium
    st.TextSize = 11
    st.TextXAlignment = 0
    st.BackgroundTransparency = 1

    local foot = Instance.new("Frame", main)
    foot.Size = UDim2.new(1, 0, 0, 75)
    foot.Position = UDim2.new(0, 0, 1, -75)
    foot.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    
    local avFrame = Instance.new("Frame", foot)
    avFrame.Size = UDim2.new(0, 45, 0, 45)
    avFrame.Position = UDim2.new(0, 15, 0.5, -22)
    avFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", avFrame).CornerRadius = UDim.new(0, 8)
    
    local av = Instance.new("ImageLabel", avFrame)
    av.Size = UDim2.new(1, 0, 1, 0)
    av.BackgroundTransparency = 1
    av.Image = Players:GetUserThumbnailAsync(LP.UserId, 0, 2)
    Instance.new("UICorner", av).CornerRadius = UDim.new(0, 8)

    local dn = Instance.new("TextLabel", foot)
    dn.Text = "@" .. LP.DisplayName
    dn.Position = UDim2.new(0, 70, 0.2, 0)
    dn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dn.Font = Enum.Font.GothamBold
    dn.TextSize = 13
    dn.BackgroundTransparency = 1
    dn.TextXAlignment = 0

    local un = Instance.new("TextLabel", foot)
    un.Text = LP.Name
    un.Position = UDim2.new(0, 70, 0.45, 0)
    un.TextColor3 = Color3.fromRGB(150, 150, 150)
    un.Font = Enum.Font.Gotham
    un.TextSize = 11
    un.BackgroundTransparency = 1
    un.TextXAlignment = 0

    local tm = Instance.new("TextLabel", foot)
    tm.Position = UDim2.new(0, 70, 0.7, 0)
    tm.TextColor3 = Color3.fromRGB(0, 229, 255)
    tm.Font = Enum.Font.GothamMedium
    tm.TextSize = 10
    tm.BackgroundTransparency = 1
    tm.TextXAlignment = 0

    task.spawn(function()
        while task.wait(1) do
            tm.Text = "Nexxto Library | " .. os.date("%X") .. " | By Zel/Zyre"
        end
    end)

    local side = Instance.new("Frame", main)
    side.Position = UDim2.new(0, 10, 0, 70)
    side.Size = UDim2.new(0, 150, 1, -155)
    side.BackgroundTransparency = 1
    Instance.new("UIListLayout", side).Padding = UDim.new(0, 5)

    local container = Instance.new("Frame", main)
    container.Position = UDim2.new(0, 170, 0, 70)
    container.Size = UDim2.new(1, -180, 1, -155)
    container.BackgroundTransparency = 1

    local Tabs = {}
    function Tabs:CreateTab(data)
        local name = next(data)
        
        local b = Instance.new("TextButton", side)
        b.Size = UDim2.new(1, 0, 0, 35)
        b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        b.Text = "     " .. name
        b.TextColor3 = Color3.fromRGB(180, 180, 180)
        b.Font = Enum.Font.GothamMedium
        b.TextSize = 13
        b.TextXAlignment = 0
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        
        local line = Instance.new("Frame", b)
        line.Size = UDim2.new(0, 2, 0, 0)
        line.Position = UDim2.new(0, 0, 0.5, 0)
        line.BackgroundColor3 = Color3.fromRGB(0, 229, 255)
        line.BorderSizePixel = 0
        line.Visible = false

        local page = Instance.new("ScrollingFrame", container)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = Color3.fromRGB(0, 229, 255)
        Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)

        b.MouseButton1Click:Connect(function()
            for _, v in pairs(side:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                    v.Frame.Visible = false
                end
            end
            for _, v in pairs(container:GetChildren()) do v.Visible = false end
            b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            line.Visible = true
            line.Size = UDim2.new(0, 2, 0, 20)
            line.Position = UDim2.new(0, 0, 0.5, -10)
            page.Visible = true
        end)

        local Components = {}

        function Components:AddButton(text, callback)
            local btn = Instance.new("TextButton", page)
            btn.Size = UDim2.new(1, -10, 0, 35)
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 13
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            local s = Instance.new("UIStroke", btn)
            s.Color = Color3.fromRGB(45, 45, 45)
            btn.MouseButton1Click:Connect(callback)
        end

        function Components:AddToggle(text, callback)
            local t = Instance.new("Frame", page)
            t.Size = UDim2.new(1, -10, 0, 35)
            t.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)
            
            local lbl = Instance.new("TextLabel", t)
            lbl.Text = text
            lbl.Position = UDim2.new(0, 15, 0, 0)
            lbl.Size = UDim2.new(1, -60, 1, 0)
            lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
            lbl.BackgroundTransparency = 1
            lbl.TextXAlignment = 0
            lbl.Font = Enum.Font.GothamMedium

            local box = Instance.new("TextButton", t)
            box.Size = UDim2.new(0, 35, 0, 18)
            box.Position = UDim2.new(1, -45, 0.5, -9)
            box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            box.Text = ""
            Instance.new("UICorner", box).CornerRadius = UDim.new(1, 0)
            
            local inner = Instance.new("Frame", box)
            inner.Size = UDim2.new(0, 12, 0, 12)
            inner.Position = UDim2.new(0, 3, 0.5, -6)
            inner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", inner).CornerRadius = UDim.new(1, 0)

            local state = false
            box.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(box, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 229, 255) or Color3.fromRGB(40, 40, 40)}):Play()
                TweenService:Create(inner, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)}):Play()
                callback(state)
            end)
        end

        function Components:AddSlider(text, min, max, def, callback)
            local s = Instance.new("Frame", page)
            s.Size = UDim2.new(1, -10, 0, 45)
            s.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Instance.new("UICorner", s).CornerRadius = UDim.new(0, 6)

            local lbl = Instance.new("TextLabel", s)
            lbl.Text = text .. " : " .. def
            lbl.Position = UDim2.new(0, 15, 0, 5)
            lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextXAlignment = 0

            local bar = Instance.new("Frame", s)
            bar.Size = UDim2.new(1, -30, 0, 4)
            bar.Position = UDim2.new(0, 15, 0.7, 0)
            bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            
            local fill = Instance.new("Frame", bar)
            fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(0, 229, 255)
            
            UIS.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and UIS:IsMouseButtonPressed(Enum.MouseButton1) then
                    local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + (max - min) * pos)
                    lbl.Text = text .. " : " .. val
                    fill.Size = UDim2.new(pos, 0, 1, 0)
                    callback(val)
                end
            end)
        end

        return Components
    end

    return Tabs
end

return Library
