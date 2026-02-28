local YorLib = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function YorLib:CreateWindow(hubName)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "YorSystem_Template"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 550, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
    mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(255, 0, 0)

    -- TOP BAR
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 35)
    topBar.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    topBar.ZIndex = 100
    topBar.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Text = "  [ " .. hubName:upper() .. " ]"
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.Code
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar

    -- CLOSE & MINIMIZE BUTTONS
    local function createTopBtn(txt, xPos, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 35, 1, 0)
        btn.Position = UDim2.new(1, xPos, 0, 0)
        btn.BackgroundTransparency = 1
        btn.Text = txt
        btn.TextColor3 = color
        btn.TextSize = 18
        btn.Font = Enum.Font.Code
        btn.ZIndex = 101
        btn.Parent = topBar
        return btn
    end

    local closeBtn = createTopBtn("X", -35, Color3.fromRGB(255, 0, 0))
    local miniBtn = createTopBtn("-", -70, Color3.new(1,1,1))

    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    local minimized = false
    miniBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        local goalSize = minimized and UDim2.new(0, 550, 0, 35) or UDim2.new(0, 550, 0, 380)
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = goalSize}):Play()
    end)

    -- TOGGLE VISIBILITY KEYBIND (Left Control)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.LeftControl then
            screenGui.Enabled = not screenGui.Enabled
        end
    end)

    -- SIDEBAR
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 130, 1, -35)
    sidebar.Position = UDim2.new(0, 0, 0, 35)
    sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    
    local sideLayout = Instance.new("UIListLayout", sidebar)
    sideLayout.Padding = UDim.new(0, 2)
    sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", sidebar).PaddingTop = UDim.new(0, 10)

    -- DRAGGING
    local dragging, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true dragStart = input.Position startPos = mainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    local tabContainer = {}
    local firstTab = true

    function tabContainer:CreateTab(tabName)
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, -150, 1, -55)
        page.Position = UDim2.new(0, 140, 0, 45)
        page.BackgroundTransparency = 1
        page.Visible = firstTab
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Color3.fromRGB(255,0,0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Parent = mainFrame
        local pageLayout = Instance.new("UIListLayout", page)
        pageLayout.Padding = UDim.new(0, 10)
        
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0.9, 0, 0, 35)
        tabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        tabBtn.Text = tabName:upper()
        tabBtn.TextColor3 = Color3.new(1,1,1)
        tabBtn.Font = Enum.Font.Code
        tabBtn.TextSize = 13
        tabBtn.BorderSizePixel = 0
        tabBtn.Parent = sidebar
        
        tabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(mainFrame:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            page.Visible = true
        end)
        
        firstTab = false
        local pageFunctions = {}

        -- COMPONENT HELPERS
        local function makeButton(parent, text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.95, 0, 0, 35)
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            btn.Text = "      " .. text:upper()
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Font = Enum.Font.Code
            btn.TextSize = 13
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.BorderSizePixel = 0
            btn.Parent = parent
            local accent = Instance.new("Frame", btn)
            accent.Size = UDim2.new(0, 4, 1, 0)
            accent.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            accent.BorderSizePixel = 0
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 0, 0), TextColor3 = Color3.new(1,1,1)}):Play()
                TweenService:Create(accent, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 0, 0)}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
                TweenService:Create(accent, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(150, 0, 0)}):Play()
            end)
            btn.MouseButton1Click:Connect(callback)
        end

        local function makeToggle(parent, text, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0.95, 0, 0, 32)
            frame.BackgroundTransparency = 1
            frame.Parent = parent
            local box = Instance.new("TextButton", frame)
            box.Size = UDim2.new(0, 20, 0, 20)
            box.Position = UDim2.new(0, 5, 0.5, -10)
            box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            box.Text = ""
            box.BorderSizePixel = 0
            Instance.new("UIStroke", box).Color = Color3.fromRGB(255, 0, 0)
            local inner = Instance.new("Frame", box)
            inner.Size = UDim2.new(0, 0, 0, 0)
            inner.Position = UDim2.new(0.5, 0, 0.5, 0)
            inner.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(1, -40, 1, 0)
            label.Position = UDim2.new(0, 35, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.new(1,1,1)
            label.Font = Enum.Font.Code
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            local active = false
            box.MouseButton1Click:Connect(function()
                active = not active
                inner:TweenSizeAndPosition(active and UDim2.new(0.7, 0, 0.7, 0) or UDim2.new(0,0,0,0), active and UDim2.new(0.15, 0, 0.15, 0) or UDim2.new(0.5,0,0.5,0), "Out", "Quart", 0.2, true)
                callback(active)
            end)
        end

        local function makeSlider(parent, text, min, max, callback)
            local sliderFrame = Instance.new("Frame", parent)
            sliderFrame.Size = UDim2.new(0.95, 0, 0, 45)
            sliderFrame.BackgroundTransparency = 1
            local label = Instance.new("TextLabel", sliderFrame)
            label.Size = UDim2.new(1, 0, 0, 20)
            label.Text = text .. " : " .. min
            label.TextColor3 = Color3.new(1,1,1)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Code
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            local track = Instance.new("Frame", sliderFrame)
            track.Size = UDim2.new(1, -10, 0, 4)
            track.Position = UDim2.new(0, 5, 0.7, 0)
            track.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            local fill = Instance.new("Frame", track)
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            local handle = Instance.new("Frame", track)
            handle.Size = UDim2.new(0, 10, 0, 14)
            handle.AnchorPoint = Vector2.new(0.5, 0.5)
            handle.BackgroundColor3 = Color3.new(1,1,1)
            local function update(input)
                local ratio = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(ratio, 0, 1, 0)
                handle.Position = UDim2.new(ratio, 0, 0.5, 0)
                local value = math.floor(min + (max - min) * ratio)
                label.Text = text .. " : " .. value
                callback(value)
            end
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local moveConn
                    moveConn = UserInputService.InputChanged:Connect(function(input2)
                        if input2.UserInputType == Enum.UserInputType.MouseMovement then update(input2) end
                    end)
                    UserInputService.InputEnded:Connect(function(input2)
                        if input2.UserInputType == Enum.UserInputType.MouseButton1 then moveConn:Disconnect() end
                    end)
                    update(input)
                end
            end)
        end

        -- EXPORTS
        function pageFunctions:CreateButton(t, c) makeButton(page, t, c) end
        function pageFunctions:CreateToggle(t, c) makeToggle(page, t, c) end
        function pageFunctions:CreateSlider(t, min, max, c) makeSlider(page, t, min, max, c) end

        function pageFunctions:CreateDropdown(text)
            local dropFrame = Instance.new("Frame", page)
            dropFrame.Size = UDim2.new(0.95, 0, 0, 35)
            dropFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            dropFrame.ClipsDescendants = true
            dropFrame.BorderSizePixel = 0
            local mainBtn = Instance.new("TextButton", dropFrame)
            mainBtn.Size = UDim2.new(1, 0, 0, 35)
            mainBtn.BackgroundTransparency = 1
            mainBtn.Text = "   " .. text:upper()
            mainBtn.TextColor3 = Color3.new(1,1,1)
            mainBtn.Font = Enum.Font.Code
            mainBtn.TextSize = 13
            mainBtn.TextXAlignment = Enum.TextXAlignment.Left
            local container = Instance.new("Frame", dropFrame)
            container.Size = UDim2.new(1, -10, 0, 0)
            container.Position = UDim2.new(0, 10, 0, 40)
            container.BackgroundTransparency = 1
            container.AutomaticSize = Enum.AutomaticSize.Y
            local dropLayout = Instance.new("UIListLayout", container)
            dropLayout.Padding = UDim.new(0, 8)
            mainBtn.MouseButton1Click:Connect(function()
                local isOpen = dropFrame.Size.Y.Offset > 40
                local targetHeight = isOpen and 35 or (dropLayout.AbsoluteContentSize.Y + 50)
                TweenService:Create(dropFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.95, 0, 0, targetHeight)}):Play()
            end)
            local dropFunctions = {}
            function dropFunctions:CreateButton(t, c) makeButton(container, t, c) end
            function dropFunctions:CreateToggle(t, c) makeToggle(container, t, c) end
            function dropFunctions:CreateSlider(t, min, max, c) makeSlider(container, t, min, max, c) end
            return dropFunctions
        end
        return pageFunctions
    end
    return tabContainer
end

return YorLib
