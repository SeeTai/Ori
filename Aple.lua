local lib = {}
local sections, workareas, notifs = {}, {}, {}
local visible, dbcooper = true, false

local function tp(ins, pos, time)
    game:GetService("TweenService"):Create(ins, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Position = pos}):Play()
end

function lib:init(ti, dosplash, visiblekey, deleteprevious)
    local cg = game:GetService("CoreGui")
    if syn then
        cg = cg
        if cg:FindFirstChild("ScreenGui") and deleteprevious then
            tp(cg.ScreenGui.main, cg.ScreenGui.main.Position + UDim2.new(0,0,2,0), 0.5)
            game:GetService("Debris"):AddItem(cg.ScreenGui, 1)
        end
        scrgui = Instance.new("ScreenGui")
        syn.protect_gui(scrgui)
        scrgui.Parent = cg
    elseif gethui then
        if gethui():FindFirstChild("ScreenGui") and deleteprevious then
            gethui().ScreenGui.main:TweenPosition(gethui().ScreenGui.main.Position + UDim2.new(0,0,2,0), "InOut", "Quart", 0.5)
            game:GetService("Debris"):AddItem(gethui().ScreenGui, 1)
        end
        scrgui = Instance.new("ScreenGui")
        scrgui.Parent = gethui()
    else
        if cg:FindFirstChild("ScreenGui") and deleteprevious then
            tp(cg.ScreenGui.main, cg.ScreenGui.main.Position + UDim2.new(0,0,2,0), 0.5)
            game:GetService("Debris"):AddItem(cg.ScreenGui, 1)
        end
        scrgui = Instance.new("ScreenGui")
        scrgui.Parent = cg
    end

    if dosplash then
        local splash = Instance.new("Frame")
        splash.Name = "splash"
        splash.Parent = scrgui
        splash.AnchorPoint = Vector2.new(0.5, 0.5)
        splash.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        splash.BackgroundTransparency = 0.1
        splash.Position = UDim2.new(0.5, 0, 2, 0)
        splash.Size = UDim2.new(0, 340, 0, 340)
        splash.ZIndex = 40
        local uc = Instance.new("UICorner", splash)
        uc.CornerRadius = UDim.new(0, 18)
        local sicon = Instance.new("ImageLabel", splash)
        sicon.AnchorPoint = Vector2.new(0.5, 0.5)
        sicon.BackgroundTransparency = 1
        sicon.Position = UDim2.new(0.5,0,0.5,0)
        sicon.Size = UDim2.new(0,191,0,190)
        sicon.Image = "rbxassetid://12621719043"
        splash:TweenPosition(UDim2.new(0.5,0,0.5,0),"InOut","Quart",1)
        wait(2)
        splash:TweenPosition(UDim2.new(0.5,0,2,0),"InOut","Quart",1)
        game:GetService("Debris"):AddItem(splash,1)
    end

    local main = Instance.new("Frame")
    main.Name = "main"
    main.Parent = scrgui
    main.AnchorPoint = Vector2.new(0.5,0.5)
    main.BackgroundColor3 = Color3.fromRGB(25,25,25)
    main.BackgroundTransparency = 0.05
    main.Position = UDim2.new(0.5,0,2,0)
    main.Size = UDim2.new(0,721,0,584)
    Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

    local UserInputService = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
    end
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)

    local workarea = Instance.new("Frame", main)
    workarea.Name = "workarea"
    workarea.BackgroundColor3 = Color3.fromRGB(25,25,25)
    workarea.Position = UDim2.new(0.364,0,0,0)
    workarea.Size = UDim2.new(0,458,0,584)
    Instance.new("UICorner", workarea).CornerRadius = UDim.new(0,18)
    local workareacornerhider = Instance.new("Frame", workarea)
    workareacornerhider.BackgroundColor3 = Color3.fromRGB(25,25,25)
    workareacornerhider.Size = UDim2.new(0,18,0.998,0)

    local search = Instance.new("Frame", main)
    search.BackgroundColor3 = Color3.fromRGB(35,35,35)
    search.Position = UDim2.new(0.026,0,0.096,0)
    search.Size = UDim2.new(0,225,0,34)
    Instance.new("UICorner", search).CornerRadius = UDim.new(0,9)
    local searchicon = Instance.new("ImageButton", search)
    searchicon.BackgroundTransparency = 1
    searchicon.Position = UDim2.new(0.038,-2,0.139,2)
    searchicon.Size = UDim2.new(0,24,0,21)
    searchicon.ImageColor3 = Color3.fromRGB(180,180,180)
    searchicon.Image = "rbxassetid://2804603863"
    local searchtextbox = Instance.new("TextBox", search)
    searchtextbox.BackgroundTransparency = 1
    searchtextbox.Position = UDim2.new(0.18,0,-0.016,0)
    searchtextbox.Size = UDim2.new(0,176,0,34)
    searchtextbox.Font = Enum.Font.Gotham
    searchtextbox.PlaceholderText = "Search"
    searchtextbox.TextColor3 = Color3.fromRGB(180,180,180)
    searchtextbox.TextSize = 22
    searchtextbox.TextXAlignment = Enum.TextXAlignment.Left
    searchicon.MouseButton1Click:Connect(function() searchtextbox:CaptureFocus() end)

    local sidebar = Instance.new("ScrollingFrame", main)
    sidebar.Active = true
    sidebar.BackgroundTransparency = 1
    sidebar.Position = UDim2.new(0.025,0,0.182,0)
    sidebar.Size = UDim2.new(0,233,0,463)
    sidebar.AutomaticCanvasSize = "Y"
    sidebar.ScrollBarThickness = 2
    local ull_2 = Instance.new("UIListLayout", sidebar)
    ull_2.SortOrder = Enum.SortOrder.LayoutOrder
    ull_2.Padding = UDim.new(0,5)
    game:GetService("RunService"):BindToRenderStep("search",1,function()
        local InputText = string.upper(searchtextbox.Text)
        for _,button in pairs(sidebar:GetChildren()) do
            if button:IsA("TextButton") then
                button.Visible = InputText=="" or string.find(string.upper(button.Text),InputText)~=nil
            end
        end
    end)

    local buttons = Instance.new("Frame", main)
    buttons.BackgroundTransparency = 1
    buttons.Size = UDim2.new(0,105,0,57)
    local ull_3 = Instance.new("UIListLayout", buttons)
    ull_3.FillDirection = Enum.FillDirection.Horizontal
    ull_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ull_3.SortOrder = Enum.SortOrder.LayoutOrder
    ull_3.VerticalAlignment = Enum.VerticalAlignment.Center
    ull_3.Padding = UDim.new(0,10)

    local close = Instance.new("TextButton", buttons)
    close.BackgroundColor3 = Color3.fromRGB(254,94,86)
    close.Size = UDim2.new(0,16,0,16)
    Instance.new("UICorner", close).CornerRadius = UDim.new(1,0)
    close.MouseButton1Click:Connect(function() scrgui:Destroy() end)

    local minimize = Instance.new("TextButton", buttons)
    minimize.BackgroundColor3 = Color3.fromRGB(255,189,46)
    minimize.Size = UDim2.new(0,16,0,16)
    Instance.new("UICorner", minimize).CornerRadius = UDim.new(1,0)

    local resize = Instance.new("TextButton", buttons)
    resize.BackgroundColor3 = Color3.fromRGB(39,200,63)
    resize.Size = UDim2.new(0,16,0,16)
    Instance.new("UICorner", resize).CornerRadius = UDim.new(1,0)

    local title = Instance.new("TextLabel", main)
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0.389,0,0.035,0)
    title.Size = UDim2.new(0,400,0,15)
    title.Font = Enum.Font.Gotham
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.TextSize = 28
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = ti or ""

    tp(main,UDim2.new(0.5,0,0.5,0),1)

    local window = {}

    function window:ToggleVisible()
        if dbcooper then return end
        visible = not visible
        dbcooper = true
        if visible then
            tp(main, UDim2.new(0.5,0,0.5,0),0.5)
            task.wait(0.5)
            dbcooper = false
        else
            tp(main, main.Position + UDim2.new(0,0,2,0),0.5)
            task.wait(0.5)
            dbcooper = false
        end
    end

    if visiblekey then
        minimize.MouseButton1Click:Connect(function() window:ToggleVisible() end)
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == visiblekey then window:ToggleVisible() end
        end)
    end

    function window:GreenButton(callback)
        if _G.gbutton_123123 then _G.gbutton_123123:Disconnect() end
        _G.gbutton_123123 = resize.MouseButton1Click:Connect(callback)
    end

    function window:Section(name)
        local btn = Instance.new("TextButton", sidebar)
        btn.Text = name
        btn.BackgroundTransparency = 1
        btn.Size = UDim2.new(0,226,0,37)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,9)
        table.insert(sections, btn)
        local wa = Instance.new("ScrollingFrame", workarea)
        wa.Active = true
        wa.BackgroundTransparency = 1
        wa.Position = UDim2.new(0.039,0,0.096,0)
        wa.Size = UDim2.new(0,422,0,512)
        wa.CanvasSize = UDim2.new(0,0,0,0)
        wa.ScrollBarThickness = 2
        local ull = Instance.new("UIListLayout", wa)
        ull.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ull.SortOrder = Enum.SortOrder.LayoutOrder
        ull.Padding = UDim.new(0,5)
        wa.Visible = false
        table.insert(workareas, wa)

        local sec = {}
        function sec:Select()
            for _,v in next, sections do
                v.BackgroundTransparency = 1
                v.TextColor3 = Color3.fromRGB(255,255,255)
            end
            btn.BackgroundTransparency = 0
            btn.TextColor3 = Color3.fromRGB(25,25,25)
            for _,v in next, workareas do v.Visible = false end
            wa.Visible = true
        end
        btn.MouseButton1Click:Connect(function() sec:Select() end)
        return sec
    end

    return window
end

return lib
