--[[
    KyperHub - Jailbreak (Lasion UI Edition)
    Created For: Zordnnn
    Theme: Lasion Dark & Purple
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local Camera = workspace.CurrentCamera

-- ==========================================
-- UI Configuration 
-- ==========================================
local UI_WIDTH = 530  
local UI_HEIGHT = 470 
local ALLOW_MULTIPLE_EXECUTIONS = false 
local KYPER_HUB_URL = "https://raw.githubusercontent.com/KyperHub/Scripts/refs/heads/main/JailBreak.lua" 
-- ==========================================

local player = Players.LocalPlayer
local mouse = player:GetMouse()

if CoreGui:FindFirstChild("KyperUI") then
    if ALLOW_MULTIPLE_EXECUTIONS then
        CoreGui.KyperUI:Destroy()
    else
        pcall(function() StarterGui:SetCore("SendNotification", {Title = "KyperHub", Text = "UI is already loaded!", Duration = 3}) end)
        return 
    end
end
if CoreGui:FindFirstChild("KyperMobileAim") then CoreGui.KyperMobileAim:Destroy() end

-- ==========================================
-- نظام حظر الإشعارات الغريبة
-- ==========================================
pcall(function()
    local oldSetCore
    oldSetCore = hookfunction(StarterGui.SetCore, function(self, name, data)
        if name == "SendNotification" and type(data) == "table" then
            if data.Title ~= "KyperHub" and data.Title ~= "KyperHub Security" then
                return 
            end
        end
        return oldSetCore(self, name, data)
    end)
end)

-- ==========================================
-- 1. Custom UI Library (Lasion Style)
-- ==========================================
local Kyper = {}

function Kyper:CreateWindow(titleText)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KyperUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Name = "OpenBtn"
    OpenBtn.Size = UDim2.new(0, 50, 0, 50)
    OpenBtn.Position = UDim2.new(0, 20, 0, 20)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
    OpenBtn.Text = "K"
    OpenBtn.TextColor3 = Color3.fromRGB(140, 0, 255) 
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextSize = 24
    OpenBtn.Visible = false
    OpenBtn.Parent = ScreenGui
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
    local OpenStroke = Instance.new("UIStroke", OpenBtn)
    OpenStroke.Color = Color3.fromRGB(140, 0, 255)
    OpenStroke.Thickness = 2

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, UI_WIDTH, 0, UI_HEIGHT)
    MainFrame.Position = UDim2.new(0.5, -(UI_WIDTH/2), 0.5, -(UI_HEIGHT/2))
    MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(140, 0, 255) 
    MainStroke.Thickness = 1

    local Header = Instance.new("Frame", MainFrame)
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundTransparency = 1
    
    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(230, 230, 230)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamMedium
    Title.TextXAlignment = Enum.TextXAlignment.Center

    local MinBtn = Instance.new("TextButton", Header)
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -35, 0, 7)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Color3.fromRGB(150, 150, 155)
    MinBtn.TextSize = 24
    MinBtn.Font = Enum.Font.Gotham
    
    MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenBtn.Visible = true end)

    local dragToggleOpen, dragInputOpen, dragStartOpen, startPosOpen, openedByDrag
    OpenBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggleOpen = true; dragStartOpen = input.Position; startPosOpen = OpenBtn.Position; openedByDrag = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragToggleOpen and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStartOpen
            if delta.Magnitude > 5 then openedByDrag = true end
            OpenBtn.Position = UDim2.new(startPosOpen.X.Scale, startPosOpen.X.Offset + delta.X, startPosOpen.Y.Scale, startPosOpen.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggleOpen = false end end)
    OpenBtn.MouseButton1Up:Connect(function() if not openedByDrag then MainFrame.Visible = true; OpenBtn.Visible = false end end)

    local dragToggle, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true; dragStart = input.Position; startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    RunService.RenderStepped:Connect(function()
        if dragToggle and dragInput then
            local delta = dragInput.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end end)

    local TabContainerWrapper = Instance.new("Frame", MainFrame)
    TabContainerWrapper.Size = UDim2.new(1, -30, 0, 30)
    TabContainerWrapper.Position = UDim2.new(0, 15, 0, 45)
    TabContainerWrapper.BackgroundTransparency = 1

    local TabContainer = Instance.new("ScrollingFrame", TabContainerWrapper)
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
    
    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 15)

    local TabLine = Instance.new("Frame", MainFrame)
    TabLine.Size = UDim2.new(1, -30, 0, 1)
    TabLine.Position = UDim2.new(0, 15, 0, 75)
    TabLine.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    TabLine.BorderSizePixel = 0

    local PagesFolder = Instance.new("Folder", MainFrame)

    local WindowObj = {
        Tabs = {},
        MainFrame = MainFrame,
        OpenBtn = OpenBtn
    }

    function WindowObj:CreateTab(tabName)
        local TabButton = Instance.new("TextButton", TabContainer)
        TabButton.Size = UDim2.new(0, 0, 1, 0)
        TabButton.AutomaticSize = Enum.AutomaticSize.X
        TabButton.BackgroundTransparency = 1
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(120, 120, 125)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.GothamMedium

        local Page = Instance.new("ScrollingFrame", PagesFolder)
        Page.Size = UDim2.new(1, -20, 1, -85)
        Page.Position = UDim2.new(0, 10, 0, 85)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(140, 0, 255)
        Page.Visible = false
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

        local LeftCol = Instance.new("Frame", Page)
        LeftCol.Size = UDim2.new(0.49, 0, 1, 0)
        LeftCol.BackgroundTransparency = 1
        LeftCol.AutomaticSize = Enum.AutomaticSize.Y
        local LeftLayout = Instance.new("UIListLayout", LeftCol)
        LeftLayout.Padding = UDim.new(0, 10); LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local RightCol = Instance.new("Frame", Page)
        RightCol.Size = UDim2.new(0.49, 0, 1, 0)
        RightCol.Position = UDim2.new(0.51, 0, 0, 0)
        RightCol.BackgroundTransparency = 1
        RightCol.AutomaticSize = Enum.AutomaticSize.Y
        local RightLayout = Instance.new("UIListLayout", RightCol)
        RightLayout.Padding = UDim.new(0, 10); RightLayout.SortOrder = Enum.SortOrder.LayoutOrder

        TabButton.MouseButton1Click:Connect(function()
            for _, btn in pairs(TabContainer:GetChildren()) do
                if btn:IsA("TextButton") then btn.TextColor3 = Color3.fromRGB(120, 120, 125) end
            end
            for _, pg in pairs(PagesFolder:GetChildren()) do pg.Visible = false end
            TabButton.TextColor3 = Color3.fromRGB(230, 230, 230)
            Page.Visible = true
        end)

        if #WindowObj.Tabs == 0 then
            TabButton.TextColor3 = Color3.fromRGB(230, 230, 230)
            Page.Visible = true
        end
        table.insert(WindowObj.Tabs, tabName)

        local TabElements = {CurrentCol = LeftCol}

        function TabElements:CreateSection(secName)
            if LeftLayout.AbsoluteContentSize.Y <= RightLayout.AbsoluteContentSize.Y then
                self.CurrentCol = LeftCol
            else
                self.CurrentCol = RightCol
            end

            local SectionFrame = Instance.new("Frame", self.CurrentCol)
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            SectionFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
            Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0, 6)
            local SecStroke = Instance.new("UIStroke", SectionFrame)
            SecStroke.Color = Color3.fromRGB(45, 45, 50)
            SecStroke.Thickness = 1

            local SecPadding = Instance.new("UIPadding", SectionFrame)
            SecPadding.PaddingTop = UDim.new(0, 8); SecPadding.PaddingBottom = UDim.new(0, 8)
            SecPadding.PaddingLeft = UDim.new(0, 10); SecPadding.PaddingRight = UDim.new(0, 10)

            local SecLayout = Instance.new("UIListLayout", SectionFrame)
            SecLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SecLayout.Padding = UDim.new(0, 6)

            if secName ~= "" then
                local SecTitle = Instance.new("TextLabel", SectionFrame)
                SecTitle.Size = UDim2.new(1, 0, 0, 20)
                SecTitle.BackgroundTransparency = 1
                SecTitle.Text = secName
                SecTitle.TextColor3 = Color3.fromRGB(200, 200, 205)
                SecTitle.TextSize = 13
                SecTitle.Font = Enum.Font.GothamMedium
                SecTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local Space = Instance.new("Frame", SectionFrame)
                Space.Size = UDim2.new(1,0,0,2); Space.BackgroundTransparency = 1
            end

            local SectionObj = {}

            function SectionObj:CreateButton(config, callback)
                local Btn = Instance.new("TextButton", SectionFrame)
                Btn.Size = UDim2.new(1, 0, 0, 26)
                Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                Btn.Text = "  " .. config.Name
                Btn.TextColor3 = Color3.fromRGB(200, 200, 205)
                Btn.TextSize = 13
                Btn.Font = Enum.Font.Gotham
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

                Btn.MouseButton1Click:Connect(function()
                    pcall(callback)
                    TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
                    task.wait(0.1)
                    TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
                end)
            end

            function SectionObj:CreateToggle(config, callback)
                local state = config.Default or false
                local isLocked = config.Locked or false
                local Btn = Instance.new("TextButton", SectionFrame)
                Btn.Size = UDim2.new(1, 0, 0, 26)
                Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                Btn.Text = "  " .. config.Name
                Btn.TextColor3 = Color3.fromRGB(200, 200, 205)
                Btn.TextSize = 13
                Btn.Font = Enum.Font.Gotham
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

                local ToggleBg = Instance.new("Frame", Btn)
                ToggleBg.Size = UDim2.new(0, 32, 0, 16)
                ToggleBg.Position = UDim2.new(1, -42, 0.5, -8)
                ToggleBg.BackgroundColor3 = state and Color3.fromRGB(140, 0, 255) or Color3.fromRGB(60, 60, 65)
                Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

                local ToggleCircle = Instance.new("Frame", ToggleBg)
                ToggleCircle.Size = UDim2.new(0, 12, 0, 12)
                ToggleCircle.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

                Btn.MouseButton1Click:Connect(function()
                    if isLocked then return end 
                    
                    state = not state
                    TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(140, 0, 255) or Color3.fromRGB(60, 60, 65)}):Play()
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
                    
                    pcall(callback, state)
                end)

                pcall(callback, state)
            end

            -- نظام شريط الـ FOV الجديد (Slider)
            function SectionObj:CreateSlider(config, callback)
                local min = config.Min or 0
                local max = config.Max or 100
                local default = config.Default or min
                local value = default

                local SliderFrame = Instance.new("Frame", SectionFrame)
                SliderFrame.Size = UDim2.new(1, 0, 0, 40)
                SliderFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
                SliderFrame.BorderSizePixel = 0

                local Label = Instance.new("TextLabel", SliderFrame)
                Label.Size = UDim2.new(1, -10, 0, 20)
                Label.Position = UDim2.new(0, 5, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = config.Name
                Label.TextColor3 = Color3.fromRGB(200, 200, 205)
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left

                local ValueLabel = Instance.new("TextLabel", SliderFrame)
                ValueLabel.Size = UDim2.new(1, -10, 0, 20)
                ValueLabel.Position = UDim2.new(0, 5, 0, 0)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(value)
                ValueLabel.TextColor3 = Color3.fromRGB(140, 0, 255)
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.TextSize = 13
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

                local BarBg = Instance.new("Frame", SliderFrame)
                BarBg.Size = UDim2.new(1, -10, 0, 6)
                BarBg.Position = UDim2.new(0, 5, 0, 26)
                BarBg.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

                local BarFill = Instance.new("Frame", BarBg)
                BarFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                BarFill.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
                Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

                local Button = Instance.new("TextButton", SliderFrame)
                Button.Size = UDim2.new(1, 0, 1, 0)
                Button.BackgroundTransparency = 1
                Button.Text = ""

                local dragging = false
                Button.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local mousePos = UserInputService:GetMouseLocation().X
                        local barAbsPos = BarBg.AbsolutePosition.X
                        local barAbsSize = BarBg.AbsoluteSize.X
                        local percent = math.clamp((mousePos - barAbsPos) / barAbsSize, 0, 1)
                        value = math.floor(min + (max - min) * percent)
                        BarFill.Size = UDim2.new(percent, 0, 1, 0)
                        ValueLabel.Text = tostring(value)
                        pcall(callback, value)
                    end
                end)

                pcall(callback, value)
            end

            function SectionObj:CreateLabel(text)
                local Label = Instance.new("TextLabel", SectionFrame)
                Label.Size = UDim2.new(1, 0, 0, 20)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = Color3.fromRGB(150, 150, 155)
                Label.TextSize = 12
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
            end

            return SectionObj
        end

        return TabElements
    end

    return WindowObj
end

local function sendNotification(title, text)
    pcall(function() StarterGui:SetCore("SendNotification", {Title = title; Text = text; Duration = 3}) end)
end

-- ==========================================
-- 2. Setup KyperHub Jailbreak
-- ==========================================

local Window = Kyper:CreateWindow("KyperHub - Jailbreak")

-- [[ Home Tab ]]
local TabHome = Window:CreateTab("Home")
local SecWelcome = TabHome:CreateSection("Welcome")
SecWelcome:CreateLabel("Welcome back, " .. player.Name .. "!")

local SecInfo = TabHome:CreateSection("Information")
SecInfo:CreateLabel("Owner: @Zordnnn")
SecInfo:CreateLabel("Head Admin: @fr._c")
SecInfo:CreateLabel("Discord: https://discord.gg/kh1")
SecInfo:CreateLabel("Website: https://kyperhub.github.io/Website/")

-- [[ Combat Tab (Magic Bullet & Aimbot) ]]
local TabCombat = Window:CreateTab("Combat")
local SecMagic = TabCombat:CreateSection("Magic Bullet Settings")

local MagicBullet_Enabled = false
local TeamCheck_Enabled = true
local WallCheck_Enabled = true
local ShowFOV_Enabled = false
local FOV_Radius = 150

-- إعداد الـ FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(140, 0, 255)
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Radius = FOV_Radius

SecMagic:CreateToggle({Name = "Enable Magic Bullet", Default = false}, function(state)
    MagicBullet_Enabled = state
end)

SecMagic:CreateToggle({Name = "Team Check", Default = true}, function(state)
    TeamCheck_Enabled = state
end)

SecMagic:CreateToggle({Name = "Wall Check", Default = true}, function(state)
    WallCheck_Enabled = state
end)

SecMagic:CreateToggle({Name = "Show FOV Circle", Default = false}, function(state)
    ShowFOV_Enabled = state
    FOVCircle.Visible = state
end)

SecMagic:CreateSlider({Name = "FOV Radius", Min = 50, Max = 600, Default = 150}, function(value)
    FOV_Radius = value
    FOVCircle.Radius = value
end)

-- تحديث موقع الـ FOV مع الماوس
RunService.RenderStepped:Connect(function()
    if ShowFOV_Enabled then
        local mousePos = UserInputService:GetMouseLocation()
        FOVCircle.Position = mousePos
    end
end)

-- دوال الـ Aimbot والتحقق
local function isVisible(targetPart)
    if not WallCheck_Enabled then return true end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * (targetPart.Position - origin).Magnitude
    local ray = Ray.new(origin, direction)
    local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character, Camera})
    
    if hit and hit:IsDescendantOf(targetPart.Parent) then
        return true
    end
    return false
end

local function getClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            
            -- فحص الفريق (Team Check)
            if TeamCheck_Enabled and v.Team == player.Team then
                continue
            end

            local screenPos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local distanceToMouse = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if distanceToMouse < FOV_Radius and distanceToMouse < shortestDistance then
                    -- فحص الجدار (Wall Check)
                    if isVisible(v.Character.Head) then
                        closestPlayer = v
                        shortestDistance = distanceToMouse
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- اختطاف الميتاتيبول لتوجيه الرصاص (Magic Bullet Hook)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if MagicBullet_Enabled then
        local target = getClosestPlayerToCursor()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            -- توجيه مسار الرصاصة في أنظمة Raycast المعتادة في روبلوكس
            if method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRayWithWhitelist" or method == "FindPartOnRay" then
                local origin = args[1].Origin
                local direction = (target.Character.Head.Position - origin).Unit * 1000
                args[1] = Ray.new(origin, direction)
                return oldNamecall(self, unpack(args))
            elseif method == "Raycast" then
                local origin = args[1]
                local direction = (target.Character.Head.Position - origin).Unit * 1000
                args[2] = direction
                return oldNamecall(self, unpack(args))
            end
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- تنظيف الـ FOV عند حذف الواجهة
Window.MainFrame.Destroying:Connect(function()
    FOVCircle:Remove()
end)

-- [[ Auto Farm Tab ]]
local TabFarm = Window:CreateTab("Auto Farm")
local SecRob = TabFarm:CreateSection("Kyper Auto Farm")

local isFarming = false
local isOnlyCarsEnabled = true
local uiConnectionCore = nil
local uiConnectionPlayer = nil
local platformConnection = nil

SecRob:CreateButton({Name = "Start Auto Farm"}, function()
    if isFarming then return end
    isFarming = true
    
    local guiTargetCore = game:GetService("CoreGui")
    if gethui then pcall(function() guiTargetCore = gethui() end) end
    local guiTargetPlayer = player:WaitForChild("PlayerGui")

    -- مُختطف الواجهات وحجبها
    local function blockUI(child)
        if child.Name ~= "KyperUI" and child.Name ~= "KyperMobileAim" then
            if child:IsA("ScreenGui") then
                child.Enabled = false
                child:GetPropertyChangedSignal("Enabled"):Connect(function() child.Enabled = false end)
            elseif child:IsA("GuiObject") then
                child.Visible = false
                child:GetPropertyChangedSignal("Visible"):Connect(function() child.Visible = false end)
            end
            task.spawn(function()
                for _, v in pairs(child:GetDescendants()) do
                    if v:IsA("GuiObject") then
                        v.Visible = false
                        v:GetPropertyChangedSignal("Visible"):Connect(function() v.Visible = false end)
                    end
                end
            end)
        end
    end

    uiConnectionCore = guiTargetCore.ChildAdded:Connect(blockUI)
    uiConnectionPlayer = guiTargetPlayer.ChildAdded:Connect(blockUI)

    -- منصة لون بنفسجي مضيء
    platformConnection = RunService.Stepped:Connect(function()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("BasePart") then
                    if (v.Position - hrp.Position).Magnitude < 12 then
                        local logo = v:FindFirstChildOfClass("Decal") or v:FindFirstChildOfClass("Texture")
                        if logo then
                            logo:Destroy() 
                            v.Name = "KyperPlatform" 
                        end
                    end
                    if v.Name == "KyperPlatform" then
                        v.Color = Color3.fromRGB(140, 0, 255) 
                        v.Material = Enum.Material.Neon
                        v.Transparency = 0.4
                    end
                end
            end
        end
    end)

    -- نظام Only Cars (حماية ضد طائرات الهيليكوبتر)
    task.spawn(function()
        while isFarming and task.wait(0.2) do
            if isOnlyCarsEnabled then
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                
                if hrp and hum and hum.Health > 0 then
                    local function checkHeli(parent)
                        for _, v in pairs(parent:GetChildren()) do
                            if v.Name == "Heli" then
                                local primary = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                                if primary and (hrp.Position - primary.Position).Magnitude < 15 then
                                    hum.Health = 0 
                                    return true
                                end
                            end
                        end
                        return false
                    end
                    
                    if checkHeli(workspace) then break end
                    local vehiclesFolder = workspace:FindFirstChild("Vehicles")
                    if vehiclesFolder and checkHeli(vehiclesFolder) then break end
                end
            end
        end
    end)

    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/BlitzIsKing/UniversalFarm/refs/heads/main/Jailbreak/autoRob"))()
        end)
        
        task.wait(2.5)
        
        if guiTargetCore:FindFirstChild("KyperUI") then
            guiTargetCore.KyperUI:Destroy()
        end
        
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/KyperHub/Scripts/refs/heads/main/JailBreak.lua"))()
        end)
    end)
end)

SecRob:CreateButton({Name = "Stop Auto Farm (Rejoin Server)", Color = Color3.fromRGB(255, 80, 80)}, function()
    if not isFarming then return end
    isFarming = false
    
    if uiConnectionCore then uiConnectionCore:Disconnect(); uiConnectionCore = nil end
    if uiConnectionPlayer then uiConnectionPlayer:Disconnect(); uiConnectionPlayer = nil end
    if platformConnection then platformConnection:Disconnect(); platformConnection = nil end

    pcall(function()
        local queue_on_teleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
        if queue_on_teleport and KYPER_HUB_URL ~= "" then
            queue_on_teleport('loadstring(game:HttpGet("' .. KYPER_HUB_URL .. '"))()')
        end
    end)
    
    task.wait(1.5)
    TeleportService:Teleport(game.PlaceId, player)
end)

SecRob:CreateToggle({Name = "Only Cars", Default = true, Locked = true}, function(state)
    isOnlyCarsEnabled = true 
end)
