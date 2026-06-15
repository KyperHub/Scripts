--[[
    KyperHub - Valley Prison (V1.5 - Lasion UI Edition)
    Created For: Zordnnn
    Theme: Lasion Dark & Purple
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local Teams = game:GetService("Teams")
local Camera = workspace.CurrentCamera

-- ==========================================
-- UI Configuration (إعدادات الواجهة والسكربت)
-- ==========================================
local UI_WIDTH = 530  -- عرض الواجهة
local UI_HEIGHT = 470 -- طول الواجهة
local ALLOW_MULTIPLE_EXECUTIONS = false
-- ==========================================

local player = Players.LocalPlayer

-- Prevent Double Execution Logic
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
-- 1. Custom UI Library (Lasion Style - No Warning)
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

    local WindowObj = {Tabs = {}}

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

            function SectionObj:CreateToggle(config, callback)
                local state = config.Default or false
                local ToggleFrame = Instance.new("Frame", SectionFrame)
                ToggleFrame.Size = UDim2.new(1, 0, 0, 24)
                ToggleFrame.BackgroundTransparency = 1

                local Checkbox = Instance.new("TextButton", ToggleFrame)
                Checkbox.Size = UDim2.new(0, 16, 0, 16)
                Checkbox.Position = UDim2.new(0, 0, 0.5, -8)
                Checkbox.BackgroundColor3 = state and Color3.fromRGB(140, 0, 255) or Color3.fromRGB(30, 30, 34)
                Checkbox.Text = ""
                Instance.new("UICorner", Checkbox).CornerRadius = UDim.new(0, 4)
                local CBStroke = Instance.new("UIStroke", Checkbox)
                CBStroke.Color = state and Color3.fromRGB(140, 0, 255) or Color3.fromRGB(50, 50, 55)

                local Title = Instance.new("TextLabel", ToggleFrame)
                Title.Size = UDim2.new(0.6, 0, 1, 0)
                Title.Position = UDim2.new(0, 25, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = config.Name
                Title.TextColor3 = state and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(180, 180, 185)
                Title.TextSize = 13
                Title.Font = Enum.Font.Gotham
                Title.TextXAlignment = Enum.TextXAlignment.Left

                local RightContainer = Instance.new("Frame", ToggleFrame)
                RightContainer.Size = UDim2.new(0.4, 0, 1, 0)
                RightContainer.Position = UDim2.new(0.6, 0, 0, 0)
                RightContainer.BackgroundTransparency = 1
                
                local RightLayout = Instance.new("UIListLayout", RightContainer)
                RightLayout.FillDirection = Enum.FillDirection.Horizontal
                RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                RightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
                RightLayout.Padding = UDim.new(0, 5)

                if config.Keybind then
                    local KeyLbl = Instance.new("TextLabel", RightContainer)
                    KeyLbl.Size = UDim2.new(0, 20, 0, 18)
                    KeyLbl.BackgroundColor3 = Color3.fromRGB(35, 25, 50) 
                    KeyLbl.Text = config.Keybind
                    KeyLbl.TextColor3 = Color3.fromRGB(170, 100, 255) 
                    KeyLbl.TextSize = 11
                    KeyLbl.Font = Enum.Font.GothamBold
                    Instance.new("UICorner", KeyLbl).CornerRadius = UDim.new(0, 4)
                    local KeyStroke = Instance.new("UIStroke", KeyLbl)
                    KeyStroke.Color = Color3.fromRGB(70, 40, 100) 
                    KeyStroke.Thickness = 1
                end

                Checkbox.MouseButton1Click:Connect(function()
                    state = not state
                    if state then
                        TweenService:Create(Checkbox, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(140, 0, 255)}):Play()
                        CBStroke.Color = Color3.fromRGB(140, 0, 255)
                        Title.TextColor3 = Color3.fromRGB(230, 230, 230)
                    else
                        TweenService:Create(Checkbox, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 30, 34)}):Play()
                        CBStroke.Color = Color3.fromRGB(50, 50, 55)
                        Title.TextColor3 = Color3.fromRGB(180, 180, 185)
                    end
                    pcall(callback, state)
                end)
                
                return function(forceState)
                    state = forceState
                    if state then
                        TweenService:Create(Checkbox, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(140, 0, 255)}):Play()
                        CBStroke.Color = Color3.fromRGB(140, 0, 255)
                        Title.TextColor3 = Color3.fromRGB(230, 230, 230)
                    else
                        TweenService:Create(Checkbox, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 30, 34)}):Play()
                        CBStroke.Color = Color3.fromRGB(50, 50, 55)
                        Title.TextColor3 = Color3.fromRGB(180, 180, 185)
                    end
                end
            end

            function SectionObj:CreateSlider(config, callback)
                local SliderFrame = Instance.new("Frame", SectionFrame)
                SliderFrame.Size = UDim2.new(1, 0, 0, 40)
                SliderFrame.BackgroundTransparency = 1

                local Title = Instance.new("TextLabel", SliderFrame)
                Title.Size = UDim2.new(0.7, 0, 0, 15)
                Title.BackgroundTransparency = 1
                Title.Text = config.Name
                Title.TextColor3 = Color3.fromRGB(180, 180, 185)
                Title.TextSize = 12
                Title.Font = Enum.Font.Gotham
                Title.TextXAlignment = Enum.TextXAlignment.Left

                local SliderBG = Instance.new("TextButton", SliderFrame)
                SliderBG.Size = UDim2.new(1, 0, 0, 12)
                SliderBG.Position = UDim2.new(0, 0, 0, 20)
                SliderBG.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                SliderBG.Text = ""
                SliderBG.AutoButtonColor = false
                Instance.new("UICorner", SliderBG).CornerRadius = UDim.new(1, 0)

                local Fill = Instance.new("Frame", SliderBG)
                Fill.Size = UDim2.new(0, 0, 1, 0)
                Fill.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

                local ValueLabel = Instance.new("TextLabel", SliderBG)
                ValueLabel.Size = UDim2.new(1, -10, 1, 0)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(config.Default or config.Min)
                ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                ValueLabel.TextSize = 10
                ValueLabel.Font = Enum.Font.Gotham
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

                local function UpdateSlider(input)
                    local mathHelper = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
                    local realValue = math.floor(config.Min + ((config.Max - config.Min) * mathHelper))
                    TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(mathHelper, 0, 1, 0)}):Play()
                    ValueLabel.Text = tostring(realValue)
                    pcall(callback, realValue)
                end

                local dragging = false
                SliderBG.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true; UpdateSlider(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateSlider(input) end
                end)

                local defMath = math.clamp((config.Default - config.Min) / (config.Max - config.Min), 0, 1)
                Fill.Size = UDim2.new(defMath, 0, 1, 0)
                pcall(callback, config.Default)
            end

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

                local RightContainer = Instance.new("Frame", Btn)
                RightContainer.Size = UDim2.new(0.4, 0, 1, 0)
                RightContainer.Position = UDim2.new(0.6, -5, 0, 0)
                RightContainer.BackgroundTransparency = 1
                
                local RightLayout = Instance.new("UIListLayout", RightContainer)
                RightLayout.FillDirection = Enum.FillDirection.Horizontal
                RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                RightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
                RightLayout.Padding = UDim.new(0, 5)

                if config.Keybind then
                    local KeyLbl = Instance.new("TextLabel", RightContainer)
                    KeyLbl.Size = UDim2.new(0, 20, 0, 18)
                    KeyLbl.BackgroundColor3 = Color3.fromRGB(35, 25, 50) 
                    KeyLbl.Text = config.Keybind
                    KeyLbl.TextColor3 = Color3.fromRGB(170, 100, 255) 
                    KeyLbl.TextSize = 11
                    KeyLbl.Font = Enum.Font.GothamBold
                    Instance.new("UICorner", KeyLbl).CornerRadius = UDim.new(0, 4)
                    local KeyStroke = Instance.new("UIStroke", KeyLbl)
                    KeyStroke.Color = Color3.fromRGB(70, 40, 100) 
                    KeyStroke.Thickness = 1
                end

                Btn.MouseButton1Click:Connect(function()
                    pcall(callback)
                    TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
                    task.wait(0.1)
                    TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
                end)
            end

            function SectionObj:CreateTextBox(config, callback)
                local TxtBox = Instance.new("TextBox", SectionFrame)
                TxtBox.Size = UDim2.new(1, 0, 0, 26)
                TxtBox.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
                TxtBox.Text = ""
                TxtBox.PlaceholderText = config.Name
                TxtBox.TextColor3 = Color3.fromRGB(230, 230, 230)
                TxtBox.TextSize = 13
                TxtBox.Font = Enum.Font.Gotham
                Instance.new("UICorner", TxtBox).CornerRadius = UDim.new(0, 4)
                local TBStroke = Instance.new("UIStroke", TxtBox)
                TBStroke.Color = Color3.fromRGB(45, 45, 50)

                TxtBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed then pcall(callback, TxtBox.Text) end
                end)
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
    pcall(function() StarterGui:SetCore("SendNotification", {Title = title; Text = text; Duration = 5}) end)
end

-- ==========================================
-- 2. Setup KyperHub Valley Prison
-- ==========================================

local Window = Kyper:CreateWindow("KyperHub - Valley Prison")

-- [[ Home Tab ]]
local TabHome = Window:CreateTab("Home")
local SecWelcome = TabHome:CreateSection("Welcome")
SecWelcome:CreateLabel("Welcome back, " .. player.Name .. "!")

local SecInfo = TabHome:CreateSection("Information")
SecInfo:CreateLabel("Owner: @Zordnnn")
SecInfo:CreateLabel("Head Admin: @fr._c")
SecInfo:CreateLabel("Discord: https://discord.gg/kh1")
SecInfo:CreateLabel("Website: https://kyperhub.github.io/Website/")

local SecStatus = TabHome:CreateSection("Status")
SecStatus:CreateLabel("Unsupported game version!")


-- [[ Player Tab ]] 
local TabPlayer = Window:CreateTab("Player")

local SecMovement = TabPlayer:CreateSection("Movement")

_G.VP_IsSpeeding = false
_G.VP_SpeedMultiplier = 16
local SpeedToggleUIUpdater = SecMovement:CreateToggle({Name = "Enable Player Speed", Keybind = "C"}, function(state)
    _G.VP_IsSpeeding = state
end)
SecMovement:CreateSlider({Name = "Speed Adjust", Min = 16, Max = 22, Default = 16}, function(value)
    _G.VP_SpeedMultiplier = value
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.C then
        _G.VP_IsSpeeding = not _G.VP_IsSpeeding
        SpeedToggleUIUpdater(_G.VP_IsSpeeding)
    end
end)

if _G.VPSpeedConnection then _G.VPSpeedConnection:Disconnect() end
_G.VPSpeedConnection = RunService.RenderStepped:Connect(function()
    local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if not rootPart or not humanoid or not _G.VP_IsSpeeding then return end
    
    local inputDir = humanoid.MoveDirection
    if inputDir.Magnitude > 0 then
        local speedOffset = (_G.VP_SpeedMultiplier) / 60 
        rootPart.CFrame = rootPart.CFrame + (inputDir * speedOffset)
    end
end)

_G.VP_IsFlying = false
_G.VP_FlySpeed = 16
local FlyToggleUIUpdater = SecMovement:CreateToggle({Name = "Enable Fly", Keybind = "X"}, function(state)
    _G.VP_IsFlying = state
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if state then
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end
    else
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end)

SecMovement:CreateSlider({Name = "Fly Speed", Min = 16, Max = 50, Default = 16}, function(value)
    _G.VP_FlySpeed = value
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        _G.VP_IsFlying = not _G.VP_IsFlying
        FlyToggleUIUpdater(_G.VP_IsFlying)
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if _G.VP_IsFlying then
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end
        else
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
        end
    end
end)

if _G.VPFlyConnection then _G.VPFlyConnection:Disconnect() end
_G.VPFlyConnection = RunService.RenderStepped:Connect(function()
    local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if not rootPart or not _G.VP_IsFlying or not humanoid then return end
    
    local inputDir = humanoid.MoveDirection
    if inputDir.Magnitude > 0 then
        local camCFrame = workspace.CurrentCamera.CFrame
        local localInput = camCFrame:VectorToObjectSpace(inputDir)
        local flyDir = camCFrame:VectorToWorldSpace(Vector3.new(localInput.X, 0, localInput.Z))
        
        local actualSpeed = _G.VP_FlySpeed / 60
        rootPart.CFrame = rootPart.CFrame + (flyDir.Unit * actualSpeed)
        rootPart.Velocity = Vector3.zero
    else
        rootPart.Velocity = Vector3.zero
    end
end)

local SecProtect = TabPlayer:CreateSection("Protection")

local AntiArrestToggle = SecProtect:CreateToggle({Name = "Anti Arrested 🔒"}, function(state)
    if state then
        sendNotification("KyperHub Security", "Error 404!")
        task.spawn(function()
            task.wait(0.1)
            if _G.UpdateAntiArrest then _G.UpdateAntiArrest(false) end
        end)
    end
end)
_G.UpdateAntiArrest = AntiArrestToggle

local AntiTaserToggle = SecProtect:CreateToggle({Name = "Anti Taser 🔒"}, function(state)
    if state then
        sendNotification("KyperHub Security", "Error 404!")
        task.spawn(function()
            task.wait(0.1)
            if _G.UpdateAntiTaser then _G.UpdateAntiTaser(false) end
        end)
    end
end)
_G.UpdateAntiTaser = AntiTaserToggle

local AutoDropToggle = SecProtect:CreateToggle({Name = "Auto Collect Dropped Items 🔒"}, function(state)
    if state then
        sendNotification("KyperHub Security", "Error 404!")
        task.spawn(function()
            task.wait(0.1)
            if _G.UpdateAutoDrop then _G.UpdateAutoDrop(false) end
        end)
    end
end)
_G.UpdateAutoDrop = AutoDropToggle

local AntiVoteToggle = SecProtect:CreateToggle({Name = "Anti Vote Kick 🔒"}, function(state)
    if state then
        sendNotification("KyperHub Security", "Error 404!")
        task.spawn(function()
            task.wait(0.1)
            if _G.UpdateAntiVote then _G.UpdateAntiVote(false) end
        end)
    end
end)
_G.UpdateAntiVote = AntiVoteToggle


local SecCam = TabPlayer:CreateSection("Camera")
SecCam:CreateSlider({Name = "Camera FOV", Min = 1, Max = 120, Default = 70}, function(value) Camera.FieldOfView = value end)


-- [[ Visuals Tab ]] 
local TabVisuals = Window:CreateTab("Visuals")

_G.WorldESP_Ropes = false
_G.WorldESP_Tools = false
_G.WorldESP_Keys = false
_G.WorldESP_Mats = false

local function AddWorldESP(target, textLabel, color)
    if target:FindFirstChild("KyperWorldESP_HL") then return end
    
    local hl = Instance.new("Highlight")
    hl.Name = "KyperWorldESP_HL"
    hl.FillColor = color
    hl.OutlineColor = Color3.new(1, 1, 1)
    hl.FillTransparency = 0.5
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = target

    if textLabel then
        local bb = Instance.new("BillboardGui")
        bb.Name = "KyperWorldESP_BB"
        bb.Size = UDim2.new(0, 100, 0, 20)
        bb.AlwaysOnTop = true
        
        if target:IsA("Model") then
            bb.Adornee = target.PrimaryPart or target:FindFirstChild("Handle") or target:FindFirstChildWhichIsA("BasePart")
        end
        bb.Parent = target
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = textLabel
        lbl.TextColor3 = color
        lbl.Font = Enum.Font.GothamBold
        lbl.TextStrokeTransparency = 0
        lbl.Parent = bb
    end
end

local function ClearWorldESP(target)
    if target:FindFirstChild("KyperWorldESP_HL") then target.KyperWorldESP_HL:Destroy() end
    if target:FindFirstChild("KyperWorldESP_BB") then target.KyperWorldESP_BB:Destroy() end
end

task.spawn(function()
    while task.wait(0.5) do
        local mapFolder = workspace:FindFirstChild("Map")
        if mapFolder then
            local funcFolder = mapFolder:FindFirstChild("Functional")
            if funcFolder then
                local ropesFolder = funcFolder:FindFirstChild("Ropes")
                if ropesFolder then
                    for _, rModel in pairs(ropesFolder:GetChildren()) do
                        if rModel.Name == "Rope" and rModel:IsA("Model") then
                            local rPart = rModel:FindFirstChild("Rope")
                            if rPart then
                                if _G.WorldESP_Ropes then AddWorldESP(rPart, nil, Color3.fromRGB(0, 255, 0)) else ClearWorldESP(rPart) end
                            end
                        end
                    end
                end
                
                local craftFolder = funcFolder:FindFirstChild("Crafting")
                if craftFolder then
                    for _, matPart in pairs(craftFolder:GetChildren()) do
                        if matPart.Name == "Plastic" or matPart.Name == "Metal" then
                            if _G.WorldESP_Mats then AddWorldESP(matPart, nil, Color3.fromRGB(0, 200, 255)) else ClearWorldESP(matPart) end
                        end
                    end
                end
            end
            
            local keyFolder = mapFolder:FindFirstChild("Keycards")
            if keyFolder then
                for _, kPart in pairs(keyFolder:GetDescendants()) do
                    if kPart.Name == "Handle" and kPart:IsA("BasePart") then
                        if _G.WorldESP_Keys then AddWorldESP(kPart, "Key Card", Color3.fromRGB(255, 255, 0)) else ClearWorldESP(kPart) end
                    end
                end
            end
        end

        local dropFolder = workspace:FindFirstChild("DroppedTools")
        if dropFolder then
            for _, dModel in pairs(dropFolder:GetChildren()) do
                if dModel:IsA("Model") then
                    if _G.WorldESP_Tools then 
                        local espName = dModel.Name
                        if espName == "ToolCaptrue" or espName == "ToolCapture" then
                            espName = "Dropped Keycard"
                        end
                        AddWorldESP(dModel, espName, Color3.fromRGB(255, 0, 0)) 
                    else 
                        ClearWorldESP(dModel) 
                    end
                end
            end
        end
    end
end)

local SecWorld = TabVisuals:CreateSection("World ESP")
SecWorld:CreateToggle({Name = "Ropes ESP"}, function(state) _G.WorldESP_Ropes = state end)
SecWorld:CreateToggle({Name = "Dropped Tools ESP"}, function(state) _G.WorldESP_Tools = state end)
SecWorld:CreateToggle({Name = "Keycards ESP"}, function(state) _G.WorldESP_Keys = state end)
SecWorld:CreateToggle({Name = "Materials ESP"}, function(state) _G.WorldESP_Mats = state end)

_G.ESP_Highlight = false
_G.ESP_Boxes = false
_G.ESP_Names = false
_G.ESP_Health = false
_G.ESP_Skeleton = false
_G.ESP_Lines = false
_G.ESP_TeamColor = false

local SecRadar = TabVisuals:CreateSection("Player Radar")
SecRadar:CreateToggle({Name = "Player ESP (Highlight)"}, function(state)
    _G.ESP_Highlight = state
    if not state then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("KyperHighlight") then p.Character.KyperHighlight:Destroy() end
        end
    end
end)
SecRadar:CreateToggle({Name = "Use Team Colors"}, function(state) _G.ESP_TeamColor = state end)
SecRadar:CreateToggle({Name = "Show Boxes"}, function(state) _G.ESP_Boxes = state end)
SecRadar:CreateToggle({Name = "Show Lines"}, function(state) _G.ESP_Lines = state end)
SecRadar:CreateToggle({Name = "Show Names"}, function(state) _G.ESP_Names = state end)
SecRadar:CreateToggle({Name = "Show Health"}, function(state) _G.ESP_Health = state end)
SecRadar:CreateToggle({Name = "Show Skeleton"}, function(state) _G.ESP_Skeleton = state end)

local ESP_Objects = {}
local function CreatePlayerESP(p)
    local esp = {
        Box = Drawing.new("Square"), Name = Drawing.new("Text"), Tracer = Drawing.new("Line"),
        HealthBarBG = Drawing.new("Square"), HealthBar = Drawing.new("Square"), Skeleton = {} 
    }
    esp.Box.Thickness = 1.5; esp.Box.Filled = false
    esp.Name.Size = 16; esp.Name.Center = true; esp.Name.Outline = true; esp.Tracer.Thickness = 1
    esp.HealthBarBG.Filled = true; esp.HealthBarBG.Color = Color3.fromRGB(0,0,0); esp.HealthBar.Filled = true
    ESP_Objects[p] = esp
end

for _, p in pairs(Players:GetPlayers()) do if p ~= player then CreatePlayerESP(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= player then CreatePlayerESP(p) end end)
Players.PlayerRemoving:Connect(function(p)
    if ESP_Objects[p] then
        for _, v in pairs(ESP_Objects[p]) do if type(v) == "table" then for _, s in pairs(v) do s:Remove() end else v:Remove() end end
        ESP_Objects[p] = nil
    end
    if p.Character and p.Character:FindFirstChild("KyperHighlight") then p.Character.KyperHighlight:Destroy() end
end)

RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            if _G.ESP_Highlight and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local hl = p.Character:FindFirstChild("KyperHighlight")
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "KyperHighlight"; hl.FillTransparency = 0.5; hl.OutlineTransparency = 0; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
                if _G.ESP_TeamColor and p.Team then
                    hl.FillColor = p.TeamColor.Color; hl.OutlineColor = Color3.new(1,1,1)
                else hl.FillColor = Color3.fromRGB(140, 0, 255); hl.OutlineColor = Color3.new(1,1,1) end
            elseif p.Character:FindFirstChild("KyperHighlight") then p.Character.KyperHighlight:Destroy() end
        end
    end

    for p, esp in pairs(ESP_Objects) do
        local char = p.Character; local humanoid = char and char:FindFirstChild("Humanoid"); local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if char and humanoid and humanoid.Health > 0 and hrp then
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local color = Color3.new(1,1,1)
                if _G.ESP_TeamColor and p.Team then color = p.TeamColor.Color end
                local head = char:FindFirstChild("Head")
                local headPos = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)) or pos
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local boxHeight = math.abs(headPos.Y - legPos.Y); local boxWidth = boxHeight * 0.6

                if _G.ESP_Boxes then esp.Box.Size = Vector2.new(boxWidth, boxHeight); esp.Box.Position = Vector2.new(pos.X - boxWidth/2, headPos.Y); esp.Box.Color = color; esp.Box.Visible = true else esp.Box.Visible = false end
                if _G.ESP_Names then esp.Name.Text = p.Name; esp.Name.Position = Vector2.new(pos.X, headPos.Y - 20); esp.Name.Color = color; esp.Name.Visible = true else esp.Name.Visible = false end
                if _G.ESP_Lines then esp.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); esp.Tracer.To = Vector2.new(pos.X, legPos.Y); esp.Tracer.Color = color; esp.Tracer.Visible = true else esp.Tracer.Visible = false end
                if _G.ESP_Health then
                    local healthPct = humanoid.Health / humanoid.MaxHealth
                    esp.HealthBarBG.Size = Vector2.new(4, boxHeight); esp.HealthBarBG.Position = Vector2.new(pos.X - boxWidth/2 - 6, headPos.Y); esp.HealthBarBG.Visible = true
                    esp.HealthBar.Size = Vector2.new(2, boxHeight * healthPct); esp.HealthBar.Position = Vector2.new(pos.X - boxWidth/2 - 5, headPos.Y + (boxHeight - (boxHeight * healthPct))); esp.HealthBar.Color = Color3.fromRGB(255 - (healthPct * 255), healthPct * 255, 0); esp.HealthBar.Visible = true
                else esp.HealthBarBG.Visible = false; esp.HealthBar.Visible = false end
                if _G.ESP_Skeleton then
                    if not esp.Skeleton[1] then esp.Skeleton[1] = Drawing.new("Line") esp.Skeleton[1].Thickness = 1.5 end
                    if head and hrp then
                        local hP = Camera:WorldToViewportPoint(head.Position); local rP = Camera:WorldToViewportPoint(hrp.Position)
                        esp.Skeleton[1].From = Vector2.new(hP.X, hP.Y); esp.Skeleton[1].To = Vector2.new(rP.X, rP.Y); esp.Skeleton[1].Color = color; esp.Skeleton[1].Visible = true
                    else esp.Skeleton[1].Visible = false end
                else for _, line in pairs(esp.Skeleton) do line.Visible = false end end
            else
                esp.Box.Visible = false; esp.Name.Visible = false; esp.Tracer.Visible = false; esp.HealthBarBG.Visible = false; esp.HealthBar.Visible = false; for _, line in pairs(esp.Skeleton) do line.Visible = false end
            end
        else
            esp.Box.Visible = false; esp.Name.Visible = false; esp.Tracer.Visible = false; esp.HealthBarBG.Visible = false; esp.HealthBar.Visible = false; for _, line in pairs(esp.Skeleton) do line.Visible = false end
        end
    end
end)


-- [[ Combat Tab ]]
local TabCombat = Window:CreateTab("Combat")
local SecAimbot = TabCombat:CreateSection("Aimbot")

local AimbotEnabled = false
local HoldingRightClick = false
_G.MobileAimbotActive = false
_G.WallCheck = false
_G.TargetTeams = {}

local FOVRadius = 150
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5; FOVCircle.NumSides = 60; FOVCircle.Radius = FOVRadius; FOVCircle.Filled = false; FOVCircle.Visible = false; FOVCircle.Color = Color3.fromRGB(140, 0, 255) 

local function getClosestTargetToMouse()
    local closestPlayer = nil; local shortestDistance = FOVCircle.Radius; local mousePos = UserInputService:GetMouseLocation()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            if p.Team and _G.TargetTeams[p.Team.Name] == false then continue end
            
            local targetPart = p.Character:FindFirstChild("Head"); local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
            if targetPart and humanoid and humanoid.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local isVisible = true
                    if _G.WallCheck then
                        local parts = Camera:GetPartsObscuringTarget({Camera.CFrame.Position, targetPart.Position}, {player.Character, p.Character})
                        if #parts > 0 then isVisible = false end
                    end
                    if isVisible then
                        local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                        if distance < shortestDistance then closestPlayer = p.Character; shortestDistance = distance end
                    end
                end
            end
        end
    end
    return closestPlayer
end

UserInputService.InputBegan:Connect(function(input, processed) if not processed and input.UserInputType == Enum.UserInputType.MouseButton2 then HoldingRightClick = true end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton2 then HoldingRightClick = false end end)

RunService.RenderStepped:Connect(function()
    if AimbotEnabled or _G.MobileAimbotActive then FOVCircle.Visible = true; FOVCircle.Position = UserInputService:GetMouseLocation() else FOVCircle.Visible = false end
    if (AimbotEnabled and HoldingRightClick) or _G.MobileAimbotActive then
        local target = getClosestTargetToMouse()
        if target and target:FindFirstChild("Head") then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Head.Position) end
    end
end)

SecAimbot:CreateToggle({Name = "PC Aimbot (Right Click)"}, function(state) AimbotEnabled = state end)

SecAimbot:CreateToggle({Name = "Mobile Aimbot UI"}, function(state)
    if state then
        local MobGui = Instance.new("ScreenGui", CoreGui); MobGui.Name = "KyperMobileAim"
        local MobBtn = Instance.new("TextButton", MobGui)
        MobBtn.Size = UDim2.new(0, 100, 0, 50); MobBtn.Position = UDim2.new(0.8, 0, 0.5, 0); MobBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 34); MobBtn.Text = "Aim: OFF"; MobBtn.TextColor3 = Color3.new(1,1,1); MobBtn.Font = Enum.Font.GothamBold; MobBtn.TextSize = 14; Instance.new("UICorner", MobBtn).CornerRadius = UDim.new(0, 8)
        
        local dragToggleAim, dragInputAim, dragStartAim, startPosAim, openedByDragAim
        MobBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragToggleAim = true; dragStartAim = input.Position; startPosAim = MobBtn.Position; openedByDragAim = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragToggleAim and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStartAim
                if delta.Magnitude > 5 then openedByDragAim = true end
                MobBtn.Position = UDim2.new(startPosAim.X.Scale, startPosAim.X.Offset + delta.X, startPosAim.Y.Scale, startPosAim.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggleAim = false end end)
        MobBtn.MouseButton1Up:Connect(function()
            if not openedByDragAim then
                _G.MobileAimbotActive = not _G.MobileAimbotActive
                if _G.MobileAimbotActive then MobBtn.BackgroundColor3 = Color3.fromRGB(140, 0, 255); MobBtn.Text = "Aim: ON" else MobBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 34); MobBtn.Text = "Aim: OFF" end
            end
        end)
    else _G.MobileAimbotActive = false; if CoreGui:FindFirstChild("KyperMobileAim") then CoreGui.KyperMobileAim:Destroy() end end
end)

SecAimbot:CreateToggle({Name = "Wall Check"}, function(state) _G.WallCheck = state end)
SecAimbot:CreateSlider({Name = "FOV Circle Size", Min = 50, Max = 500, Default = 150}, function(value) FOVCircle.Radius = value end)

local SecTeams = TabCombat:CreateSection("Target Teams (Aimbot)")
for _, team in pairs(Teams:GetTeams()) do
    _G.TargetTeams[team.Name] = true 
    SecTeams:CreateToggle({Name = team.Name, Default = true}, function(state)
        _G.TargetTeams[team.Name] = state
    end)
end

local SecHitbox = TabCombat:CreateSection("Hitbox Expander")

_G.HitboxEnabled = false
_G.HitboxVisible = false
local defaultHeadSize = Vector3.new(2, 1, 1)
local expandHeadSize = Vector3.new(4.5, 4.5, 4.5) 

SecHitbox:CreateToggle({Name = "Enable Hitbox"}, function(state) _G.HitboxEnabled = state end)
SecHitbox:CreateToggle({Name = "Hitbox Visible"}, function(state) _G.HitboxVisible = state end)

RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            if p.Team and _G.TargetTeams[p.Team.Name] == false then
                p.Character.Head.Size = defaultHeadSize
                p.Character.Head.Transparency = 0
                p.Character.Head.Material = Enum.Material.Plastic
                continue 
            end

            local head = p.Character.Head
            if _G.HitboxEnabled then
                head.Size = expandHeadSize
                head.CanCollide = false
                if _G.HitboxVisible then
                    head.Transparency = 0.5
                    head.Color = Color3.fromRGB(255, 0, 0)
                    head.Material = Enum.Material.ForceField
                else
                    head.Transparency = 0
                    head.Material = Enum.Material.Plastic
                end
            else
                head.Size = defaultHeadSize
                head.Transparency = 0
                head.Material = Enum.Material.Plastic
            end
        end
    end
end)
