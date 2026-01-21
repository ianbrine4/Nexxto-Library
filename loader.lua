local NexxtoLib = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {
    Windows = {},
    Theme = {
        Accent = Color3.fromRGB(59, 130, 246),
        Bg = Color3.fromRGB(15, 15, 23),
        Dark = Color3.fromRGB(10, 10, 18),
        Text = Color3.fromRGB(226, 232, 240),
        Dim = Color3.fromRGB(148, 163, 184),
        Border = Color3.fromRGB(30, 41, 59),
        Success = Color3.fromRGB(34, 197, 94),
        Error = Color3.fromRGB(239, 68, 68),
    },
    Notifications = {},
}

local function new(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then obj[k] = v end
    end
    if props and props.Parent then obj.Parent = props.Parent end
    return obj
end

local function tween(obj, info, props)
    TweenService:Create(obj, info or TweenInfo.new(0.18, Enum.EasingStyle.Sine), props):Play()
end

function Library:CreateToggleIcon(customIconId)
    local sg = new("ScreenGui", {Name = "NexxtoToggle", ResetOnSpawn = false, Parent = PlayerGui})
    local iconAsset = customIconId and ("rbxassetid://" .. tostring(customIconId)) or "rbxassetid://3926305904"
    local btn = new("ImageButton", {
        Size = UDim2.fromOffset(54, 54),
        Position = UDim2.new(0, 24, 0.5, -27),
        BackgroundColor3 = Library.Theme.Accent,
        BackgroundTransparency = 0.35,
        Image = iconAsset,
        ImageColor3 = Color3.new(1,1,1),
        AutoButtonColor = false,
        Parent = sg,
    })
    new("UICorner", {CornerRadius = UDim.new(1,0), Parent = btn})
    new("UIStroke", {Color = Library.Theme.Accent, Transparency = 0.4, Parent = btn})
    btn.MouseEnter:Connect(function() tween(btn, nil, {BackgroundTransparency = 0.15}) end)
    btn.MouseLeave:Connect(function() tween(btn, nil, {BackgroundTransparency = 0.35}) end)
    return btn, sg
end

function Library:Notify(text, duration, color)
    duration = duration or 4
    color = color or Library.Theme.Accent
    local notifGui = new("ScreenGui", {Name = "NexxtoNotifs", ResetOnSpawn = false, Parent = PlayerGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    local frame = new("Frame", {
        Size = UDim2.new(0, 280, 0, 68),
        Position = UDim2.new(1, -300, 0, 20 + (#Library.Notifications * 78)),
        BackgroundColor3 = Library.Theme.Dark,
        BorderSizePixel = 0,
        Parent = notifGui,
    })
    new("UICorner", {CornerRadius = UDim.new(0,8), Parent = frame})
    new("UIStroke", {Color = color, Transparency = 0.6, Parent = frame})
    new("TextLabel", {
        Size = UDim2.new(1,-16,1,-16),
        Position = UDim2.new(0,8,0,8),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Library.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = frame,
    })
    table.insert(Library.Notifications, frame)
    tween(frame, TweenInfo.new(0.4), {Position = UDim2.new(1, -300, 0, 20 + (#Library.Notifications-1) * 78)})
    task.delay(duration, function()
        tween(frame, TweenInfo.new(0.4), {Position = UDim2.new(1, 20, frame.Position.Y.Scale, frame.Position.Y.Offset)})
        task.wait(0.4)
        frame:Destroy()
        table.remove(Library.Notifications, table.find(Library.Notifications, frame))
        for i, f in ipairs(Library.Notifications) do
            tween(f, TweenInfo.new(0.3), {Position = UDim2.new(1, -300, 0, 20 + (i-1) * 78)})
        end
    end)
end

function NexxtoLib:CreateWindow(opts)
    opts = opts or {}
    local title = opts.Title or "Nexxto Library"
    local subtitle = opts.Subtitle or "by Ian"
    local size = opts.Size or UDim2.fromOffset(400, 340)
    local toggleKey = opts.ToggleKey or Enum.KeyCode.RightShift
    local icon = opts.icon
    local sg = new("ScreenGui", {Name = "NexxtoLib", ResetOnSpawn = false, Parent = PlayerGui})
    local main = new("Frame", {
        Name = "Window",
        Size = size,
        Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2),
        BackgroundColor3 = Library.Theme.Bg,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = sg,
    })
    new("UICorner", {CornerRadius = UDim.new(0,9), Parent = main})
    new("UIStroke", {Color = Library.Theme.Border, Parent = main})
    local titlebar = new("Frame", {
        Size = UDim2.new(1,0,0,42),
        BackgroundColor3 = Color3.fromRGB(26,26,46),
        BorderSizePixel = 0,
        Parent = main,
    })
    new("UICorner", {CornerRadius = UDim.new(0,9), Parent = titlebar})
    new("TextLabel", {
        Size = UDim2.new(1,-140,0.5,0),
        Position = UDim2.new(0,16,0,0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.new(1,1,1),
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titlebar,
    })
    new("TextLabel", {
        Size = UDim2.new(1,-140,0.5,0),
        Position = UDim2.new(0,16,0.5,0),
        BackgroundTransparency = 1,
        Text = subtitle,
        TextColor3 = Library.Theme.Dim,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titlebar,
    })
    local close = new("TextButton", {
        Size = UDim2.fromOffset(32,32),
        Position = UDim2.new(1,-42,0,5),
        BackgroundColor3 = Color3.fromRGB(239,68,68),
        Text = "×",
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        Parent = titlebar,
    })
    new("UICorner", {CornerRadius = UDim.new(0,6), Parent = close})
    local sidebar = new("Frame", {
        Size = UDim2.new(0,190,1,-42),
        Position = UDim2.new(0,0,0,42),
        BackgroundColor3 = Library.Theme.Dark,
        BorderSizePixel = 0,
        Parent = main,
    })
    local content = new("Frame", {
        Size = UDim2.new(1,-190,1,-42),
        Position = UDim2.new(0,190,0,42),
        BackgroundTransparency = 1,
        Parent = main,
    })
    local dragging, dragInput, dragStart, startPos
    titlebar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    titlebar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    close.MouseButton1Click:Connect(function()
        sg.Enabled = false
    end)
    local toggleBtn, toggleGui = Library:CreateToggleIcon(icon)
    toggleBtn.MouseButton1Click:Connect(function()
        sg.Enabled = not sg.Enabled
    end)
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == toggleKey then
            sg.Enabled = not sg.Enabled
        end
    end)
    local window = {
        Frame = main,
        Sidebar = sidebar,
        Content = content,
        Tabs = {},
    }
    function window:AddTab(name)
        local btn = new("TextButton", {
            Size = UDim2.new(1,-20,0,40),
            Position = UDim2.new(0,10,0,#window.Tabs*44 + 10),
            BackgroundTransparency = 1,
            Text = "  " .. name,
            TextColor3 = Library.Theme.Dim,
            Font = Enum.Font.GothamSemibold,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = sidebar,
        })
        local tabContent = new("ScrollingFrame", {
            Name = name,
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0,0,0,0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Library.Theme.Dim,
            Visible = false,
            Parent = content,
        })
        new("UIPadding", {PaddingLeft = UDim.new(0,24), PaddingRight = UDim.new(0,24), PaddingTop = UDim.new(0,20), PaddingBottom = UDim.new(0,20), Parent = tabContent})
        local list = new("UIListLayout", {Padding = UDim.new(0,16), SortOrder = Enum.SortOrder.LayoutOrder, Parent = tabContent})
        list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0,0,0,list.AbsoluteContentSize.Y + 40)
        end)
        btn.MouseButton1Click:Connect(function()
            for _, t in pairs(window.Tabs) do
                t.Button.TextColor3 = Library.Theme.Dim
                t.Content.Visible = false
            end
            btn.TextColor3 = Color3.new(1,1,1)
            tabContent.Visible = true
        end)
        local tab = {
            Button = btn,
            Content = tabContent,
        }
        table.insert(window.Tabs, tab)
        if #window.Tabs == 1 then
            btn.TextColor3 = Color3.new(1,1,1)
            tabContent.Visible = true
        end
        function tab:AddToggle(options)
            options = options or {}
            local text = options.Text or "Toggle"
            local desc = options.Description or ""
            local default = options.Default or false
            local callback = options.Callback or function() end
            local container = new("Frame", {Size = UDim2.new(1,0,0,0), BackgroundTransparency = 1, Parent = tabContent})
            local label = new("TextLabel", {
                Size = UDim2.new(1,-80,0,18),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Library.Theme.Text,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container,
            })
            local descLabel = new("TextLabel", {
                Size = UDim2.new(1,-80,0,0),
                Position = UDim2.new(0,0,0,20),
                BackgroundTransparency = 1,
                Text = desc,
                TextColor3 = Library.Theme.Dim,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container,
            })
            descLabel.Size = UDim2.new(1,-80,0,descLabel.TextBounds.Y)
            local toggle = new("TextButton", {
                Size = UDim2.fromOffset(48,24),
                Position = UDim2.new(1,-60,0,0),
                BackgroundColor3 = default and Library.Theme.Accent or Library.Theme.Border,
                Text = "",
                AutoButtonColor = false,
                Parent = container,
            })
            new("UICorner", {CornerRadius = UDim.new(1,0), Parent = toggle})
            local knob = new("Frame", {
                Size = UDim2.fromOffset(20,20),
                Position = default and UDim2.new(0,26,0,2) or UDim2.new(0,2,0,2),
                BackgroundColor3 = Color3.new(1,1,1),
                Parent = toggle,
            })
            new("UICorner", {CornerRadius = UDim.new(1,0), Parent = knob})
            local state = default
            toggle.MouseButton1Click:Connect(function()
                state = not state
                tween(toggle, nil, {BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Border})
                tween(knob, nil, {Position = state and UDim2.new(0,26,0,2) or UDim2.new(0,2,0,2)})
                callback(state)
            end)
            container.Size = UDim2.new(1,0,0, math.max(38, 22 + descLabel.TextBounds.Y))
            return { Toggle = toggle, Value = function() return state end }
        end
        function tab:AddButton(options)
            options = options or {}
            local text = options.Text or "Button"
            local callback = options.Callback or function() end
            local btn = new("TextButton", {
                Size = UDim2.new(1,0,0,38),
                BackgroundColor3 = Library.Theme.Accent,
                BorderSizePixel = 0,
                Text = text,
                TextColor3 = Color3.new(1,1,1),
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                Parent = tabContent,
            })
            new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})
            btn.MouseButton1Click:Connect(callback)
            btn.MouseEnter:Connect(function() tween(btn, nil, {BackgroundColor3 = Color3.fromRGB(79,150,255)}) end)
            btn.MouseLeave:Connect(function() tween(btn, nil, {BackgroundColor3 = Library.Theme.Accent}) end)
            return btn
        end
        function tab:AddSlider(options)
            options = options or {}
            local text = options.Text or "Slider"
            local desc = options.Description or ""
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local callback = options.Callback or function() end
            local container = new("Frame", {Size = UDim2.new(1,0,0,60), BackgroundTransparency = 1, Parent = tabContent})
            new("TextLabel", {
                Size = UDim2.new(1,-80,0,18),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Library.Theme.Text,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container,
            })
            new("TextLabel", {
                Size = UDim2.new(1,-80,0,0),
                Position = UDim2.new(0,0,0,20),
                BackgroundTransparency = 1,
                Text = desc,
                TextColor3 = Library.Theme.Dim,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container,
            }).Size = UDim2.new(1,-80,0,desc ~= "" and 18 or 0)
            local track = new("Frame", {
                Size = UDim2.new(1,-80,0,6),
                Position = UDim2.new(0,0,1,-26),
                BackgroundColor3 = Library.Theme.Border,
                Parent = container,
            })
            new("UICorner", {CornerRadius = UDim.new(1,0), Parent = track})
            local fill = new("Frame", {
                Size = UDim2.new((default-min)/(max-min),0,1,0),
                BackgroundColor3 = Library.Theme.Accent,
                BorderSizePixel = 0,
                Parent = track,
            })
            new("UICorner", {CornerRadius = UDim.new(1,0), Parent = fill})
            local valueLabel = new("TextLabel", {
                Size = UDim2.fromOffset(50,20),
                Position = UDim2.new(1,-60,0,0),
                BackgroundTransparency = 1,
                Text = tostring(default),
                TextColor3 = Library.Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                Parent = container,
            })
            local dragging = false
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            RunService.RenderStepped:Connect(function()
                if dragging then
                    local mouse = UserInputService:GetMouseLocation()
                    local rel = math.clamp((mouse.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    local val = math.round(min + (max - min) * rel)
                    fill.Size = UDim2.new(rel,0,1,0)
                    valueLabel.Text = tostring(val)
                    callback(val)
                end
            end)
            return { Value = function() return tonumber(valueLabel.Text) end }
        end
        function tab:AddDropdown(options)
            options = options or {}
            local text = options.Text or "Dropdown"
            local desc = options.Description or ""
            local items = options.Items or {"Option 1", "Option 2"}
            local default = options.Default or items[1]
            local callback = options.Callback or function() end
            local container = new("Frame", {Size = UDim2.new(1,0,0,0), BackgroundTransparency = 1, Parent = tabContent})
            new("TextLabel", {Size = UDim2.new(1,-140,0,18), BackgroundTransparency = 1, Text = text, TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamSemibold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = container})
            local descL = new("TextLabel", {Size = UDim2.new(1,-140,0,0), Position = UDim2.new(0,0,0,20), BackgroundTransparency = 1, Text = desc, TextColor3 = Library.Theme.Dim, Font = Enum.Font.Gotham, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, Parent = container})
            descL.Size = UDim2.new(1,-140,0,descL.TextBounds.Y)
            local btn = new("TextButton", {
                Size = UDim2.new(0,140,0,34),
                Position = UDim2.new(1,-150,0,0),
                BackgroundColor3 = Library.Theme.Dark,
                BorderColor3 = Library.Theme.Border,
                Text = default,
                TextColor3 = Library.Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                Parent = container,
            })
            new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})
            local list = new("ScrollingFrame", {
                Size = UDim2.new(0,140,0,120),
                Position = UDim2.new(1,-150,0,40),
                BackgroundColor3 = Library.Theme.Dark,
                BorderSizePixel = 0,
                CanvasSize = UDim2.new(0,0,0,#items*30),
                ScrollBarThickness = 0,
                Visible = false,
                ZIndex = 2,
                Parent = container,
            })
            new("UICorner", {CornerRadius = UDim.new(0,6), Parent = list})
            new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Parent = list})
            for _, v in ipairs(items) do
                local opt = new("TextButton", {
                    Size = UDim2.new(1,0,0,30),
                    BackgroundTransparency = 1,
                    Text = v,
                    TextColor3 = Library.Theme.Dim,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    Parent = list,
                })
                opt.MouseButton1Click:Connect(function()
                    btn.Text = v
                    list.Visible = false
                    callback(v)
                end)
                opt.MouseEnter:Connect(function() tween(opt, nil, {TextColor3 = Color3.new(1,1,1)}) end)
                opt.MouseLeave:Connect(function() tween(opt, nil, {TextColor3 = Library.Theme.Dim}) end)
            end
            btn.MouseButton1Click:Connect(function()
                list.Visible = not list.Visible
            end)
            container.Size = UDim2.new(1,0,0, math.max(44, 44 + descL.TextBounds.Y))
            return { Value = function() return btn.Text end }
        end
        function tab:AddTextbox(options)
            options = options or {}
            local text = options.Text or "Input"
            local desc = options.Description or ""
            local placeholder = options.Placeholder or "Type here..."
            local callback = options.Callback or function() end
            local container = new("Frame", {Size = UDim2.new(1,0,0,0), BackgroundTransparency = 1, Parent = tabContent})
            new("TextLabel", {Size = UDim2.new(1,-140,0,18), BackgroundTransparency = 1, Text = text, TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamSemibold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = container})
            local descL = new("TextLabel", {Size = UDim2.new(1,-140,0,0), Position = UDim2.new(0,0,0,20), BackgroundTransparency = 1, Text = desc, TextColor3 = Library.Theme.Dim, Font = Enum.Font.Gotham, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, Parent = container})
            descL.Size = UDim2.new(1,-140,0,descL.TextBounds.Y)
            local box = new("TextBox", {
                Size = UDim2.new(0,180,0,34),
                Position = UDim2.new(1,-190,0,0),
                BackgroundColor3 = Library.Theme.Dark,
                BorderColor3 = Library.Theme.Border,
                PlaceholderText = placeholder,
                PlaceholderColor3 = Library.Theme.Dim,
                Text = "",
                TextColor3 = Library.Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                ClearTextOnFocus = false,
                Parent = container,
            })
            new("UICorner", {CornerRadius = UDim.new(0,6), Parent = box})
            box.FocusLost:Connect(function(enter)
                if enter then
                    callback(box.Text)
                end
            end)
            container.Size = UDim2.new(1,0,0, math.max(44, 44 + descL.TextBounds.Y))
            return { Value = function() return box.Text end, Set = function(v) box.Text = v end }
        end
        return tab
    end
    table.insert(Library.Windows, window)
    return window
end

return NexxtoLib

-- Example usage right here (after the library code)
local Window = NexxtoLib:CreateWindow({
    Title = "Nexxto Library",
    Subtitle = "by Ian",
    Size = UDim2.fromOffset(400, 340),
    ToggleKey = Enum.KeyCode.RightShift,
    icon = 125890342252654
})

local Main = Window:AddTab("Main")

Main:AddToggle({
    Text = "Godmode",
    Description = "Invulnerability toggle",
    Default = false,
    Callback = function(v) print("Godmode:", v) end
})

Main:AddSlider({
    Text = "WalkSpeed",
    Description = "Movement speed",
    Min = 16,
    Max = 150,
    Default = 16,
    Callback = function(v)
        local h = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if h then h.WalkSpeed = v end
    end
})

Main:AddDropdown({
    Text = "ESP Color",
    Description = "Highlight color",
    Items = {"Green", "Red", "Blue"},
    Default = "Green",
    Callback = function(v) print("ESP:", v) end
})

Main:AddTextbox({
    Text = "Input",
    Description = "Type something",
    Placeholder = "Hello...",
    Callback = function(txt) print("Input:", txt) end
})

Main:AddButton({
    Text = "Test Notification",
    Callback = function()
        NexxtoLib:Notify("UI Loaded!", 4, NexxtoLib.Theme.Success)
    end
})

print("Nexxto UI ready - check floating icon")
