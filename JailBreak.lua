--[[
    KyperHub - Jailbreak (V5.0 - Ultimate Edition w/ Key System)
    Created For: Zordnnn / Reevy
    Theme: Lasion Dark & Purple (Mini Panel)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer

-- ==========================================
-- Safe UNC & Teleport Interceptor (Solara Fix)
-- ==========================================
local isFarming = false
local isAutoRobActive = false
local isAutoArrestActive = false
local isOnlyCarsRob = false 
local isOnlyCarsArrest = false 
local isKillAuraEnabled = true 

if type(hookfunction) == "function" then
    pcall(function()
        local oldTeleport
        oldTeleport = hookfunction(TeleportService.Teleport, function(self, ...)
            if isAutoArrestActive or isAutoRobActive then
                player:Kick("\n[ KyperHub ]\n\nThere are no more criminals in this server.\nPlease rejoin a different server.")
                return task.wait(9e9)
            end
            return oldTeleport(self, ...)
        end)
    end)

    pcall(function()
        local oldTeleportToPlaceInstance
        oldTeleportToPlaceInstance = hookfunction(TeleportService.TeleportToPlaceInstance, function(self, ...)
            if isAutoArrestActive or isAutoRobActive then
                player:Kick("\n[ KyperHub ]\n\nThere are no more criminals in this server.\nPlease rejoin a different server.")
                return task.wait(9e9)
            end
            return oldTeleportToPlaceInstance(self, ...)
        end)
    end)
    
    pcall(function()
        local oldSetCore
        oldSetCore = hookfunction(StarterGui.SetCore, function(self, name, data)
            if name == "SendNotification" and type(data) == "table" then
                if data.Title and type(data.Title) == "string" and data.Title ~= "KyperHub" and data.Title ~= "Please Wait" then
                    return 
                end
            end
            return oldSetCore(self, name, data)
        end)
    end)
end

if type(hookmetamethod) == "function" then
    pcall(function()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = tostring(getnamecallmethod())
            if self == TeleportService and string.find(method, "Teleport") then
                if isAutoArrestActive or isAutoRobActive then
                    player:Kick("\n[ KyperHub ]\n\nThere are no more criminals in this server.\nPlease rejoin a different server.")
                    return task.wait(9e9)
                end
            end
            return oldNamecall(self, ...)
        end)
    end)
end

-- ==========================================
-- Cleaning Previous Executions
-- ==========================================
if CoreGui:FindFirstChild("KyperUI") then CoreGui.KyperUI:Destroy() end
if CoreGui:FindFirstChild("KyperAuth") then CoreGui.KyperAuth:Destroy() end
if CoreGui:FindFirstChild("KyperMobileAim") then CoreGui.KyperMobileAim:Destroy() end

-- ==========================================
-- 1. Key Auth System (Mini Panel)
-- ==========================================
local AuthGui = Instance.new("ScreenGui")
AuthGui.Name = "KyperAuth"
AuthGui.Parent = CoreGui
AuthGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local AuthFrame = Instance.new("Frame", AuthGui)
AuthFrame.Size = UDim2.new(0, 320, 0, 180)
AuthFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
AuthFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
Instance.new("UICorner", AuthFrame).CornerRadius = UDim.new(0, 8)
local AuthStroke = Instance.new("UIStroke", AuthFrame)
AuthStroke.Color = Color3.fromRGB(140, 0, 255)
AuthStroke.Thickness = 1

local AuthTitle = Instance.new("TextLabel", AuthFrame)
AuthTitle.Size = UDim2.new(1, 0, 0, 45)
AuthTitle.Text = "KyperHub Premium Login"
AuthTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
AuthTitle.BackgroundTransparency = 1
AuthTitle.Font = Enum.Font.GothamMedium
AuthTitle.TextSize = 16

local KeyBox = Instance.new("TextBox", AuthFrame)
KeyBox.Size = UDim2.new(0.85, 0, 0, 35)
KeyBox.Position = UDim2.new(0.075, 0, 0.35, 0)
KeyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.Text = "" 
KeyBox.PlaceholderText = "Enter Premium Key..."
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 4)
local KBStroke = Instance.new("UIStroke", KeyBox)
KBStroke.Color = Color3.fromRGB(140, 0, 255)

local VerifyBtn = Instance.new("TextButton", AuthFrame)
VerifyBtn.Size = UDim2.new(0.4, 0, 0, 35)
VerifyBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
VerifyBtn.Text = "Verify Key"
VerifyBtn.TextColor3 = Color3.new(1,1,1)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 13
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 4)

local FreeBtn = Instance.new("TextButton", AuthFrame)
FreeBtn.Size = UDim2.new(0.4, 0, 0, 35)
FreeBtn.Position = UDim2.new(0.525, 0, 0.65, 0)
FreeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
FreeBtn.Text = "Continue Free"
FreeBtn.TextColor3 = Color3.new(1,1,1)
FreeBtn.Font = Enum.Font.GothamBold
FreeBtn.TextSize = 13
Instance.new("UICorner", FreeBtn).CornerRadius = UDim.new(0, 4)

local authEvent = Instance.new("BindableEvent")

VerifyBtn.MouseButton1Click:Connect(function()
    local inputKey = KeyBox.Text
    VerifyBtn.Text = "Checking..."
    local success, realKey = pcall(function() return game:HttpGet("https://pastebin.com/raw/1wZnsqhm") end)
    
    if success and realKey then
        realKey = string.gsub(realKey, "%s+", "") 
        inputKey = string.gsub(inputKey, "%s+", "")
        if inputKey == realKey then
            authEvent:Fire(true)
        else
            KeyBox.Text = ""
            KeyBox.PlaceholderText = "Invalid Key!"
            VerifyBtn.Text = "Verify Key"
        end
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Network Error!"
        VerifyBtn.Text = "Verify Key"
    end
end)

FreeBtn.MouseButton1Click:Connect(function()
    authEvent:Fire(false)
end)

-- Wait for User Input
_G.KyperPremium = authEvent.Event:Wait()
AuthGui:Destroy()

-- ==========================================
-- UI Configuration 
-- ==========================================
local UI_WIDTH = 530  
local UI_HEIGHT = 470 
local PREMIUM_ICON = "rbxassetid://14103525998"

local function sendNotification(title, text, duration)
    pcall(function() StarterGui:SetCore("SendNotification", {Title = title; Text = text; Duration = duration or 3}) end)
end

-- ==========================================
-- 2. Custom UI Library (With Smart Blockers & Built-in Keybinds)
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

            local function applyBadge(container, badgeType)
                local BadgeLbl = Instance.new("TextLabel", container)
                if badgeType == "Premium" then
                    BadgeLbl.Size = UDim2.new(0, 60, 0, 18)
                    BadgeLbl.BackgroundColor3 = Color3.fromRGB(45, 35, 10)
                    BadgeLbl.Text = "Premium"
                    BadgeLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
                    local Stroke = Instance.new("UIStroke", BadgeLbl)
                    Stroke.Color = Color3.fromRGB(150, 120, 0)
                elseif badgeType == "UnSupported" then
                    BadgeLbl.Size = UDim2.new(0, 75, 0, 18)
                    BadgeLbl.BackgroundColor3 = Color3.fromRGB(45, 25, 25)
                    BadgeLbl.Text = "UnSupported"
                    BadgeLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
                    local Stroke = Instance.new("UIStroke", BadgeLbl)
                    Stroke.Color = Color3.fromRGB(80, 40, 40)
                end
                BadgeLbl.TextSize = 10
                BadgeLbl.Font = Enum.Font.GothamBold
                Instance.new("UICorner", BadgeLbl).CornerRadius = UDim.new(0, 4)
            end

            local function CheckBlocker(badge)
                if badge == "UnSupported" then
                    sendNotification("KyperHub", "This feature is currently unsupported!", 3)
                    return true
                elseif badge == "Premium" and not _G.KyperPremium then
                    sendNotification("KyperHub", "Premium Key is required to use this feature!", 3)
                    return true
                end
                return false
            end

            function SectionObj:CreateToggle(config, callback)
                local isBlocked = (config.Badge == "UnSupported") or (config.Badge == "Premium" and not _G.KyperPremium)
                local state = false
                
                local ToggleFrame = Instance.new("Frame", SectionFrame)
                ToggleFrame.Size = UDim2.new(1, 0, 0, 24)
                ToggleFrame.BackgroundTransparency = 1

                local Checkbox = Instance.new("TextButton", ToggleFrame)
                Checkbox.Size = UDim2.new(0, 16, 0, 16)
                Checkbox.Position = UDim2.new(0, 0, 0.5, -8)
                Checkbox.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
                Checkbox.Text = ""
                Instance.new("UICorner", Checkbox).CornerRadius = UDim.new(0, 4)
                local CBStroke = Instance.new("UIStroke", Checkbox)
                CBStroke.Color = Color3.fromRGB(50, 50, 55)

                local Title = Instance.new("TextLabel", ToggleFrame)
                Title.Size = UDim2.new(0.6, 0, 1, 0)
                Title.Position = UDim2.new(0, 25, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = config.Name
                Title.TextColor3 = Color3.fromRGB(180, 180, 185)
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

                if config.Badge then applyBadge(RightContainer, config.Badge) end

                if config.Badge == "Premium" then
                    local Icon = Instance.new("ImageLabel", ToggleFrame)
                    Icon.Size = UDim2.new(0, 16, 0, 16)
                    Icon.AnchorPoint = Vector2.new(1, 0.5)
                    Icon.Position = UDim2.new(1, -50, 0.5, 0)
                    Icon.BackgroundTransparency = 1
                    Icon.Image = PREMIUM_ICON
                end

                local function ToggleAction()
                    if CheckBlocker(config.Badge) then return end
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
                end

                Checkbox.MouseButton1Click:Connect(ToggleAction)

                -- نظام الاختصارات الذكي (Built-in Keybind Toggles)
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
                    
                    local kc = Enum.KeyCode[config.Keybind]
                    if kc then
                        UserInputService.InputBegan:Connect(function(input, gp)
                            if gp then return end
                            if input.KeyCode == kc then
                                ToggleAction()
                            end
                        end)
                    end
                end

                if config.Default and not isBlocked then
                    state = true
                    TweenService:Create(Checkbox, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(140, 0, 255)}):Play()
                    CBStroke.Color = Color3.fromRGB(140, 0, 255)
                    Title.TextColor3 = Color3.fromRGB(230, 230, 230)
                    pcall(callback, state)
                end
            end

            function SectionObj:CreateSlider(config, callback)
                local isBlocked = (config.Badge == "UnSupported") or (config.Badge == "Premium" and not _G.KyperPremium)
                
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
                    if CheckBlocker(config.Badge) then return end
                    local mathHelper = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
                    local realValue = math.floor(config.Min + ((config.Max - config.Min) * mathHelper))
                    TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(mathHelper, 0, 1, 0)}):Play()
                    ValueLabel.Text = tostring(realValue)
                    pcall(callback, realValue)
                end

                local dragging = false
                SliderBG.InputBegan:Connect(function(input)
                    if CheckBlocker(config.Badge) then return end
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

                if not isBlocked then
                    local defMath = math.clamp((config.Default - config.Min) / (config.Max - config.Min), 0, 1)
                    Fill.Size = UDim2.new(defMath, 0, 1, 0)
                    pcall(callback, config.Default)
                end
            end

            function SectionObj:CreateButton(config, callback)
                local Btn = Instance.new("TextButton", SectionFrame)
                Btn.Size = UDim2.new(1, 0, 0, 26)
                Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                Btn.Text = "  " .. config.Name
                Btn.TextColor3 = config.Color or Color3.fromRGB(200, 200, 205)
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

                if config.Badge then applyBadge(RightContainer, config.Badge) end

                if config.Badge == "Premium" then
                    local Icon = Instance.new("ImageLabel", Btn)
                    Icon.Size = UDim2.new(0, 16, 0, 16)
                    Icon.AnchorPoint = Vector2.new(1, 0.5)
                    Icon.Position = UDim2.new(1, -10, 0.5, 0)
                    Icon.BackgroundTransparency = 1
                    Icon.Image = PREMIUM_ICON
                end

                Btn.MouseButton1Click:Connect(function()
                    if CheckBlocker(config.Badge) then return end
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

-- ==========================================
-- 3. Hitbox & Background Logic (Failsafe Edition)
-- ==========================================
_G.HitboxEnabled = false
_G.HitboxVisible = false
_G.HitboxSize = 5

-- نظام هيت بوكس الذكي لمنع تجميد اللاعبين (Zero-Desync)
RunService.RenderStepped:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            if _G.HitboxEnabled then
                if _G.TeamCheckAimbot and p.Team == player.Team then
                    if head.Size ~= Vector3.new(2, 1, 1) then
                        head.Size = Vector3.new(2, 1, 1)
                        head.Transparency = 0
                        head.Material = Enum.Material.Plastic
                    end
                else
                    local targetSize = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                    if head.Size ~= targetSize then
                        head.Size = targetSize
                        head.CanCollide = false
                        head.Massless = true 
                    end
                    
                    local targetTrans = _G.HitboxVisible and 0.5 or 1
                    if head.Transparency ~= targetTrans then
                        head.Transparency = targetTrans
                        if _G.HitboxVisible then
                            head.Color = Color3.fromRGB(255, 0, 0)
                            head.Material = Enum.Material.ForceField
                        else
                            head.Material = Enum.Material.Plastic
                        end
                    end
                end
            else
                if head.Size ~= Vector3.new(2, 1, 1) then
                    head.Size = Vector3.new(2, 1, 1)
                    head.Transparency = 0
                    head.Material = Enum.Material.Plastic
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if isAutoRobActive and not isKillAuraEnabled then
            pcall(function()
                local itemsFolder = workspace:FindFirstChild("Items")
                if itemsFolder then
                    for _, item in ipairs(itemsFolder:GetChildren()) do
                        if item:IsA("Model") or item.Name == "Pistol" then
                            item:Destroy()
                        end
                    end
                end
            end)
        end
    end
end)

local isHoldingE = false
task.spawn(function()
    while task.wait(0.2) do
        if isAutoArrestActive and not isHoldingE then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local targetFound = false
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        local targetHrp = p.Character:FindFirstChild("HumanoidRootPart")
                        local targetHum = p.Character:FindFirstChildOfClass("Humanoid")
                        if targetHrp and targetHum and targetHum.Health > 0 then
                            if (targetHrp.Position - hrp.Position).Magnitude <= 8 then
                                targetFound = true
                                break
                            end
                        end
                    end
                end
                
                if targetFound then
                    isHoldingE = true
                    task.spawn(function()
                        pcall(function()
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                            task.wait(3) 
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                        end)
                        task.wait(0.5) 
                        isHoldingE = false
                    end)
                end
            end
        end
    end
end)

local uiConnectionCore = nil
local uiConnectionPlayer = nil

local function startFarmLogic()
    local guiTargetCore = game:GetService("CoreGui")
    if gethui then pcall(function() guiTargetCore = gethui() end) end
    local guiTargetPlayer = player:WaitForChild("PlayerGui")

    local function blockUI(child)
        if child.Name ~= "KyperUI" and child.Name ~= "KyperAuth" then
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

    if not uiConnectionCore then uiConnectionCore = guiTargetCore.ChildAdded:Connect(blockUI) end
    if not uiConnectionPlayer then uiConnectionPlayer = guiTargetPlayer.ChildAdded:Connect(blockUI) end

    task.spawn(function()
        while isFarming and task.wait(0.5) do
            pcall(function()
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local parts = workspace:GetPartBoundsInRadius(hrp.Position, 10)
                    for _, v in ipairs(parts) do
                        if v.Parent == workspace and v:IsA("BasePart") and v.Name ~= "Terrain" then
                            if v.Transparency > 0.1 then 
                                local logo = v:FindFirstChildOfClass("Decal") or v:FindFirstChildOfClass("Texture")
                                if logo then logo:Destroy() end
                                v.Name = "KyperPlatform"
                                v.Color = Color3.fromRGB(140, 0, 255) 
                                v.Material = Enum.Material.Neon
                                v.Transparency = 0.4
                            end
                        end
                    end
                end
            end)
        end
    end)

    task.spawn(function()
        while isFarming and task.wait(0.2) do
            pcall(function()
                if (isAutoRobActive and isOnlyCarsRob) or (isAutoArrestActive and isOnlyCarsArrest) then
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    
                    if hrp and hum and hum.Health > 0 then
                        local function checkHeli(parent)
                            for _, v in pairs(parent:GetChildren()) do
                                if v.Name == "Heli" or v.Name == "HeliSpawner_Decorative" then
                                    local primary = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                                    if primary and (hrp.Position - primary.Position).Magnitude < 15 then
                                        hum.Health = 0 
                                        return true
                                    end
                                end
                            end
                            return false
                        end
                        if checkHeli(workspace) then return end
                        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
                        if vehiclesFolder and checkHeli(vehiclesFolder) then return end
                    end
                end
            end)
        end
    end)
end

-- ==========================================
-- 4. Setup KyperHub Tabs
-- ==========================================
local Window = Kyper:CreateWindow("KyperHub - Jailbreak")

local TabHome = Window:CreateTab("Home")
local SecWelcome = TabHome:CreateSection("Welcome")
SecWelcome:CreateLabel("Welcome back, " .. player.Name .. "!")

local SecInfo = TabHome:CreateSection("Information")
SecInfo:CreateLabel("Owner: @Zordnnn")
SecInfo:CreateLabel("Head Admin: @fr._c")
SecInfo:CreateLabel("Discord: https://discord.gg/kh1")
SecInfo:CreateLabel("Website: https://kyperhub.github.io/Website/")

local TabPlayer = Window:CreateTab("Player")
local SecMovement = TabPlayer:CreateSection("Movement")

local function ToggleFlySystem(state)
    _G.IsFlying = state
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    if state then
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end
        if _G.FlyConnection then _G.FlyConnection:Disconnect() end
        local FLY_SPEED = 0.8

        _G.FlyConnection = RunService.RenderStepped:Connect(function()
            if not rootPart or not _G.IsFlying or not humanoid then return end
            local inputDir = humanoid.MoveDirection
            if inputDir.Magnitude > 0 then
                local camCFrame = workspace.CurrentCamera.CFrame
                local localInput = camCFrame:VectorToObjectSpace(inputDir)
                local flyDir = camCFrame:VectorToWorldSpace(Vector3.new(localInput.X, 0, localInput.Z))
                rootPart.CFrame = rootPart.CFrame + (flyDir.Unit * FLY_SPEED)
                rootPart.Velocity = Vector3.new(0, 0, 0)
            else rootPart.Velocity = Vector3.new(0, 0, 0) end
        end)
    else
        if _G.FlyConnection then _G.FlyConnection:Disconnect() _G.FlyConnection = nil end
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end

SecMovement:CreateToggle({Name = "Enable Fly", Keybind = "Z", Badge = "Premium"}, function(state) ToggleFlySystem(state) end)

_G.SpeedMultiplier = 2
SecMovement:CreateToggle({Name = "Player Speed", Keybind = "X"}, function(state) _G.IsSpeeding = state end)

if _G.SpeedConnection then _G.SpeedConnection:Disconnect() end
_G.SpeedConnection = RunService.RenderStepped:Connect(function()
    local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if not rootPart or not humanoid or not _G.IsSpeeding then return end
    local inputDir = humanoid.MoveDirection
    if inputDir.Magnitude > 0 then
        local extraMove = inputDir * (_G.SpeedMultiplier * 0.1)
        rootPart.CFrame = rootPart.CFrame + Vector3.new(extraMove.X, 0, extraMove.Z)
    end
end)

SecMovement:CreateSlider({Name = "Speed Level", Min = 1, Max = 20, Default = 2}, function(value) _G.SpeedMultiplier = value end)

local SecCam = TabPlayer:CreateSection("Camera")
SecCam:CreateSlider({Name = "Camera POV (FOV)", Min = 1, Max = 120, Default = 70}, function(value) Camera.FieldOfView = value end)

local TabCombat = Window:CreateTab("Combat")

-- === Premium Hitbox Section ===
local SecHitbox = TabCombat:CreateSection("Hitbox Expand")
SecHitbox:CreateToggle({Name = "Enable Hitbox", Badge = "Premium"}, function(state) _G.HitboxEnabled = state end)
SecHitbox:CreateToggle({Name = "Hitbox Visible", Badge = "Premium"}, function(state) _G.HitboxVisible = state end)
SecHitbox:CreateSlider({Name = "Hitbox Size", Min = 2, Max = 12, Default = 5, Badge = "Premium"}, function(value) _G.HitboxSize = value end)

local SecAimbot = TabCombat:CreateSection("Aimbot")
local AimbotEnabled = false
local HoldingRightClick = false
_G.MobileAimbotActive = false
_G.TeamCheckAimbot = false
_G.WallCheck = false

local HasDrawing = type(Drawing) == "table" or type(Drawing) == "userdata"

local FOVRadius = 150
local FOVCircle = nil
if HasDrawing then
    pcall(function()
        FOVCircle = Drawing.new("Circle")
        FOVCircle.Thickness = 1.5; FOVCircle.NumSides = 60; FOVCircle.Radius = FOVRadius; FOVCircle.Filled = false; FOVCircle.Visible = false; FOVCircle.Color = Color3.fromRGB(140, 0, 255) 
    end)
end

local function getClosestTargetToMouse()
    if not FOVCircle then return nil end
    local closestPlayer = nil; local shortestDistance = FOVCircle.Radius; local mousePos = UserInputService:GetMouseLocation()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            if _G.TeamCheckAimbot and p.Team == player.Team then continue end
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
    if FOVCircle then
        if AimbotEnabled or _G.MobileAimbotActive then FOVCircle.Visible = true; FOVCircle.Position = UserInputService:GetMouseLocation() else FOVCircle.Visible = false end
    end
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

SecAimbot:CreateToggle({Name = "Team Check"}, function(state) _G.TeamCheckAimbot = state end)
SecAimbot:CreateToggle({Name = "Wall Check"}, function(state) _G.WallCheck = state end)
SecAimbot:CreateSlider({Name = "FOV Circle Size", Min = 50, Max = 500, Default = 150}, function(value) if FOVCircle then FOVCircle.Radius = value end end)

local SecHL = TabCombat:CreateSection("Highlight & Colors")
SecHL:CreateToggle({Name = "Use Team Colors"}, function(state) _G.ESP_TeamColor = state end)
SecHL:CreateToggle({Name = "Player ESP (Highlight)"}, function(state)
    _G.ESP_Highlight = state
    if not state then
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("KyperHighlight") then p.Character.KyperHighlight:Destroy() end
        end
    end
end)

local SecRadar = TabCombat:CreateSection("Player Radar")
SecRadar:CreateToggle({Name = "Show Names", Badge = "Premium"}, function(state) _G.ESP_Names = state end)
SecRadar:CreateToggle({Name = "Show Boxes", Badge = "Premium"}, function(state) _G.ESP_Boxes = state end)
SecRadar:CreateToggle({Name = "Show Health", Badge = "Premium"}, function(state) _G.ESP_Health = state end)
SecRadar:CreateToggle({Name = "Show Tracers", Badge = "Premium"}, function(state) _G.ESP_Tracers = state end)
SecRadar:CreateToggle({Name = "Show Skeleton", Badge = "Premium"}, function(state) _G.ESP_Skeleton = state end)

local ESP_Objects = {}
local function CreateESP(p)
    if not HasDrawing then return end
    pcall(function()
        local esp = {
            Box = Drawing.new("Square"), Name = Drawing.new("Text"), Tracer = Drawing.new("Line"),
            HealthBarBG = Drawing.new("Square"), HealthBar = Drawing.new("Square"), Skeleton = {} 
        }
        esp.Box.Thickness = 1.5; esp.Box.Filled = false
        esp.Name.Size = 16; esp.Name.Center = true; esp.Name.Outline = true; esp.Tracer.Thickness = 1
        esp.HealthBarBG.Filled = true; esp.HealthBarBG.Color = Color3.fromRGB(0,0,0); esp.HealthBar.Filled = true
        ESP_Objects[p] = esp
    end)
end

if HasDrawing then
    -- دالة إخفاء ذكية بدون أخطاء
    local function HideESP(esp)
        pcall(function()
            if esp.Box then esp.Box.Visible = false end
            if esp.Name then esp.Name.Visible = false end
            if esp.Tracer then esp.Tracer.Visible = false end
            if esp.HealthBarBG then esp.HealthBarBG.Visible = false end
            if esp.HealthBar then esp.HealthBar.Visible = false end
            if esp.Skeleton and esp.Skeleton[1] then esp.Skeleton[1].Visible = false end
        end)
    end

    for _, p in ipairs(Players:GetPlayers()) do if p ~= player then CreateESP(p) end end
    Players.PlayerAdded:Connect(function(p) if p ~= player then CreateESP(p) end end)
    Players.PlayerRemoving:Connect(function(p)
        if ESP_Objects[p] then
            pcall(function()
                for _, v in pairs(ESP_Objects[p]) do 
                    if type(v) == "table" then 
                        for _, s in pairs(v) do s:Remove() end 
                    else 
                        v:Remove() 
                    end 
                end
            end)
            ESP_Objects[p] = nil
        end
        if p.Character and p.Character:FindFirstChild("KyperHighlight") then p.Character.KyperHighlight:Destroy() end
    end)

    RunService.RenderStepped:Connect(function()
        -- Highlight Loop (Protected)
        pcall(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if _G.ESP_Highlight and hrp and hum and hum.Health > 0 then
                        local hl = p.Character:FindFirstChild("KyperHighlight")
                        if not hl then
                            hl = Instance.new("Highlight", p.Character)
                            hl.Name = "KyperHighlight"; hl.FillTransparency = 0.5; hl.OutlineTransparency = 0; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        end
                        if _G.ESP_TeamColor and p.Team then
                            hl.FillColor = p.TeamColor.Color; hl.OutlineColor = Color3.new(1,1,1)
                        else hl.FillColor = Color3.fromRGB(140, 0, 255); hl.OutlineColor = Color3.new(1,1,1) end
                    else
                        local hl = p.Character:FindFirstChild("KyperHighlight")
                        if hl then hl:Destroy() end
                    end
                end
            end
        end)

        -- Drawing ESP Loop (Fail-safe)
        for p, esp in pairs(ESP_Objects) do
            local success = pcall(function()
                if not p or not p.Parent or not p.Character or not p.Character.Parent then
                    HideESP(esp)
                    return
                end
                
                local char = p.Character
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local head = char:FindFirstChild("Head")

                if humanoid and humanoid.Health > 0 and hrp and head then
                    local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local color = Color3.new(1,1,1)
                        if _G.ESP_TeamColor and p.Team then color = p.TeamColor.Color end
                        
                        local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                        local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                        local boxHeight = math.abs(headPos.Y - legPos.Y)
                        local boxWidth = boxHeight * 0.6

                        esp.Box.Size = Vector2.new(boxWidth, boxHeight)
                        esp.Box.Position = Vector2.new(pos.X - boxWidth/2, headPos.Y)
                        esp.Box.Color = color
                        esp.Box.Visible = _G.ESP_Boxes

                        esp.Name.Text = p.Name
                        esp.Name.Position = Vector2.new(pos.X, headPos.Y - 20)
                        esp.Name.Color = color
                        esp.Name.Visible = _G.ESP_Names

                        esp.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        esp.Tracer.To = Vector2.new(pos.X, legPos.Y)
                        esp.Tracer.Color = color
                        esp.Tracer.Visible = _G.ESP_Tracers

                        if _G.ESP_Health then
                            local healthPct = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                            esp.HealthBarBG.Size = Vector2.new(4, boxHeight)
                            esp.HealthBarBG.Position = Vector2.new(pos.X - boxWidth/2 - 6, headPos.Y)
                            esp.HealthBarBG.Visible = true

                            esp.HealthBar.Size = Vector2.new(2, boxHeight * healthPct)
                            esp.HealthBar.Position = Vector2.new(pos.X - boxWidth/2 - 5, headPos.Y + (boxHeight - (boxHeight * healthPct)))
                            esp.HealthBar.Color = Color3.fromRGB(255 - (healthPct * 255), healthPct * 255, 0)
                            esp.HealthBar.Visible = true
                        else 
                            esp.HealthBarBG.Visible = false
                            esp.HealthBar.Visible = false 
                        end

                        if _G.ESP_Skeleton then
                            if not esp.Skeleton[1] then 
                                esp.Skeleton[1] = Drawing.new("Line") 
                                esp.Skeleton[1].Thickness = 1.5 
                            end
                            local hP = Camera:WorldToViewportPoint(head.Position)
                            local rP = Camera:WorldToViewportPoint(hrp.Position)
                            esp.Skeleton[1].From = Vector2.new(hP.X, hP.Y)
                            esp.Skeleton[1].To = Vector2.new(rP.X, rP.Y)
                            esp.Skeleton[1].Color = color
                            esp.Skeleton[1].Visible = true
                        else 
                            if esp.Skeleton[1] then esp.Skeleton[1].Visible = false end 
                        end
                    else
                        HideESP(esp)
                    end
                else
                    HideESP(esp)
                end
            end)
            if not success then HideESP(esp) end
        end
    end)
end

local TabAuto = Window:CreateTab("Auto Farm")

local function resetAndRejoin()
    if not isFarming then return end
    isFarming = false
    isAutoRobActive = false
    isAutoArrestActive = false
    
    sendNotification("KyperHub", "Stopping & Rejoining...", 5)
    
    if uiConnectionCore then uiConnectionCore:Disconnect(); uiConnectionCore = nil end
    if uiConnectionPlayer then uiConnectionPlayer:Disconnect(); uiConnectionPlayer = nil end

    pcall(function()
        local teleportFunc = oldTeleport or TeleportService.Teleport
        teleportFunc(TeleportService, game.PlaceId, player)
    end)
end

local SecAutoRob = TabAuto:CreateSection("Auto Rob")

SecAutoRob:CreateButton({Name = "Start Auto Rob", Color = Color3.fromRGB(100, 255, 100), Badge = "UnSupported"}, function()
end)

SecAutoRob:CreateButton({Name = "Stop Auto Rob (Rejoin)", Color = Color3.fromRGB(255, 80, 80), Badge = "UnSupported"}, function()
end)

SecAutoRob:CreateToggle({Name = "Only Cars", Default = isOnlyCarsRob, Badge = "UnSupported"}, function(state)
end)

SecAutoRob:CreateToggle({Name = "Kill Aura", Default = isKillAuraEnabled, Badge = "UnSupported"}, function(state)
end)

local SecAutoArrest = TabAuto:CreateSection("Auto Arrest")

SecAutoArrest:CreateButton({Name = "Start Auto Arrest", Color = Color3.fromRGB(100, 255, 100), Badge = "Premium"}, function()
    if isFarming then return end
    isFarming = true
    isAutoArrestActive = true
    
    sendNotification("Please Wait", "Loading...", 8)
    startFarmLogic()

    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/BlitzIsKing/UniversalFarm/refs/heads/main/Jailbreak/autoArrest"))()
        end)
    end)
end)

SecAutoArrest:CreateButton({Name = "Stop Auto Arrest (Rejoin)", Color = Color3.fromRGB(255, 80, 80), Badge = "Premium"}, resetAndRejoin)

SecAutoArrest:CreateToggle({Name = "Only Cars", Default = isOnlyCarsArrest, Badge = "Premium"}, function(state)
    isOnlyCarsArrest = state 
end)

SecAutoArrest:CreateToggle({Name = "Smart AI", Default = false, Badge = "Premium"}, function(state)
end)
