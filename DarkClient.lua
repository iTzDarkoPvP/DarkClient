--[[
    ========================================
          DARK CLIENT v3.1 - FLOATING BTN
    ========================================
    ✅ Botón Flotante para Abrir/Cerrar
    ✅ Sin dependencias de teclas raras
    ✅ Estética Neon Purple + Negro
    ✅ HUD FPS/Ping Funcional
    ========================================
]]

-- SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- TEMA NEON PURPLE
local Theme = {
    Main = Color3.fromRGB(10, 10, 15),
    Secondary = Color3.fromRGB(20, 20, 30),
    Accent = Color3.fromRGB(160, 32, 240),
    Glow = Color3.fromRGB(200, 80, 255),
    Text = Color3.fromRGB(255, 255, 255),
    ToggleOn = Color3.fromRGB(180, 50, 255),
    ToggleOff = Color3.fromRGB(80, 80, 90)
}

-- VARIABLES
local MenuOpen = false
local Dragging = false
local DragOffset = Vector2.zero

-- ==========================================
-- 1. HUD DE ESTADÍSTICAS
-- ==========================================
local StatsGui = Instance.new("ScreenGui")
StatsGui.Name = "DarkClient_Stats"
StatsGui.ResetOnSpawn = false
StatsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
StatsGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local StatsBox = Instance.new("Frame")
StatsBox.Size = UDim2.new(0, 170, 0, 65)
StatsBox.Position = UDim2.new(1, -180, 0, 10)
StatsBox.BackgroundColor3 = Theme.Main
StatsBox.BorderSizePixel = 0
StatsBox.Parent = StatsGui

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 10)
StatsCorner.Parent = StatsBox

local StatsStroke = Instance.new("UIStroke")
StatsStroke.Color = Theme.Accent
StatsStroke.Thickness = 2
StatsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
StatsStroke.Parent = StatsBox

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, -15, 1, 0)
StatsLabel.Position = UDim2.new(0, 8, 0, 0)
StatsLabel.BackgroundTransparency = 1
StatsLabel.TextColor3 = Theme.Text
StatsLabel.Font = Enum.Font.Code
StatsLabel.TextSize = 15
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.TextYAlignment = Enum.TextYAlignment.Center
StatsLabel.Text = "⏳ Cargando..."
StatsLabel.Parent = StatsBox

task.spawn(function()
    while task.wait(0.5) do
        local fps = math.round(1 / RunService.RenderStepped:Wait())
        local ping = math.round(LocalPlayer:GetNetworkPing() * 1000)
        StatsLabel.Text = string.format("⚡ FPS: %d\n PING: %d ms", fps, ping)
    end
end)

-- ==========================================
-- 2. BOTÓN FLOTANTE (TOGGLE)
-- ==========================================
local FloatGui = Instance.new("ScreenGui")
FloatGui.Name = "DarkClient_FloatBtn"
FloatGui.ResetOnSpawn = false
FloatGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
FloatGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local FloatBtn = Instance.new("TextButton")
FloatBtn.Size = UDim2.new(0, 50, 0, 50)
FloatBtn.Position = UDim2.new(0, 20, 0.5, -25) -- Lado izquierdo centro
FloatBtn.BackgroundColor3 = Theme.Accent
FloatBtn.Text = "D"
FloatBtn.TextColor3 = Theme.Text
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 24
FloatBtn.AutoButtonColor = false
FloatBtn.Parent = FloatGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0) -- Círculo perfecto
FloatCorner.Parent = FloatBtn

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Theme.Glow
FloatStroke.Thickness = 2
FloatStroke.Parent = FloatBtn

-- Animación al hacer hover
FloatBtn.MouseEnter:Connect(function()
    TweenService:Create(FloatBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 55, 0, 55)}):Play()
end)
FloatBtn.MouseLeave:Connect(function()
    TweenService:Create(FloatBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 50, 0, 50)}):Play()
end)

-- ==========================================
-- 3. MENÚ GUI PRINCIPAL
-- ==========================================
local MenuGui = Instance.new("ScreenGui")
MenuGui.Name = "DarkClient_Menu"
MenuGui.ResetOnSpawn = false
MenuGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MenuGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 280, 0, 380)
MenuFrame.Position = UDim2.new(0.5, -140, 0.5, -190)
MenuFrame.BackgroundColor3 = Theme.Main
MenuFrame.BorderSizePixel = 0
MenuFrame.Visible = false
MenuFrame.Parent = MenuGui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 12)
MenuCorner.Parent = MenuFrame

local MenuStroke = Instance.new("UIStroke")
MenuStroke.Color = Theme.Accent
MenuStroke.Thickness = 2
MenuStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MenuStroke.Parent = MenuFrame

-- Barra superior arrastrable
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Theme.Secondary
TopBar.BorderSizePixel = 0
TopBar.Parent = MenuFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "DARK CLIENT v3.1"
TitleLabel.TextColor3 = Theme.Glow
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 22
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

-- Contenedor de funciones
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -20, 1, -55)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
ContentFrame.BorderSizePixel = 0
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 300)
ContentFrame.ScrollBarThickness = 4
ContentFrame.ScrollBarImageColor3 = Theme.Accent
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.Parent = MenuFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 8)
ListLayout.Parent = ContentFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 5)
UIPadding.PaddingRight = UDim.new(0, 5)
UIPadding.Parent = ContentFrame

-- Función Toggle Creator
local function CreateToggle(name, desc, order)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 55)
    Container.BackgroundColor3 = Theme.Secondary
    Container.BorderSizePixel = 0
    Container.LayoutOrder = order
    Container.Parent = ContentFrame
    
    local ContCorner = Instance.new("UICorner")
    ContCorner.CornerRadius = UDim.new(0, 8)
    ContCorner.Parent = Container
    
    local NameLbl = Instance.new("TextLabel")
    NameLbl.Size = UDim2.new(0.65, 0, 0.5, 0)
    NameLbl.Position = UDim2.new(0, 12, 0, 8)
    NameLbl.BackgroundTransparency = 1
    NameLbl.Text = name
    NameLbl.TextColor3 = Theme.Text
    NameLbl.Font = Enum.Font.GothamBold
    NameLbl.TextSize = 16
    NameLbl.TextXAlignment = Enum.TextXAlignment.Left
    NameLbl.Parent = Container
    
    local DescLbl = Instance.new("TextLabel")
    DescLbl.Size = UDim2.new(0.65, 0, 0.4, 0)
    DescLbl.Position = UDim2.new(0, 12, 0.5, 2)
    DescLbl.BackgroundTransparency = 1
    DescLbl.Text = desc or ""
    DescLbl.TextColor3 = Theme.ToggleOff
    DescLbl.Font = Enum.Font.Gotham
    DescLbl.TextSize = 12
    DescLbl.TextXAlignment = Enum.TextXAlignment.Left
    DescLbl.Parent = Container
    
    local ToggleBg = Instance.new("Frame")
    ToggleBg.Size = UDim2.new(0, 50, 0, 26)
    ToggleBg.Position = UDim2.new(1, -60, 0.5, -13)
    ToggleBg.BackgroundColor3 = Theme.ToggleOff
    ToggleBg.BorderSizePixel = 0
    ToggleBg.Parent = Container
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleBg
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
    ToggleCircle.Position = UDim2.new(0, 3, 0.5, -10)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Parent = ToggleBg
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    local state = false
    local function UpdateToggle(val)
        state = val
        ToggleBg.BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff
        TweenService:Create(ToggleCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Position = state and UDim2.new(0, 27, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        }):Play()
    end
    
    Container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            UpdateToggle(state)
        end
    end)
    
    return { Update = UpdateToggle, GetState = function() return state end }
end

-- Crear Features
local Features = {}
Features.Speed = CreateToggle("Speed Hack", "Velocidad x3", 1)
Features.Fly = CreateToggle("Fly Mode", "WASD + Space/Ctrl", 2)
Features.Noclip = CreateToggle("Noclip", "Atravesar paredes", 3)
Features.BTools = CreateToggle("Build Tools", "Herramientas Admin", 4)
Features.InfJump = CreateToggle("Infinite Jump", "Salto ilimitado", 5)

-- Lógica de Funciones
local SpeedConn, NoclipConn
local FlyBV, FlyBG

local function ToggleSpeed(active)
    if SpeedConn then SpeedConn:Disconnect(); SpeedConn = nil end
    if active then
        SpeedConn = RunService.RenderStepped:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 50 end
        end)
    else
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end

local function ToggleFly(active)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    
    if active then
        hum.PlatformStand = true
        FlyBV = Instance.new("BodyVelocity", root)
        FlyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        FlyBG = Instance.new("BodyGyro", root)
        FlyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        FlyBG.P = 10000; FlyBG.D = 100
    else
        hum.PlatformStand = false
        if FlyBV then FlyBV:Destroy(); FlyBV = nil end
        if FlyBG then FlyBG:Destroy(); FlyBG = nil end
    end
end

local function ToggleNoclip(active)
    if NoclipConn then NoclipConn:Disconnect(); NoclipConn = nil end
    if active then
        NoclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
                end
            end
        end)
    else
        local char = LocalPlayer.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.CanCollide = true end
            end
        end
    end
end

local function ToggleBTools(active)
    if active then
        for _, t in ipairs({"Clone", "Delete", "Grab"}) do
            if not LocalPlayer.Backpack:FindFirstChild(t) then
                local tool = Instance.new("Tool"); tool.Name = t; tool.RequiresHandle = false
                tool.Parent = LocalPlayer.Backpack
            end
        end
    else
        for _, t in ipairs({"Clone", "Delete", "Grab"}) do
            local tool = LocalPlayer.Backpack:FindFirstChild(t)
            if tool then tool:Destroy() end
        end
    end
end

local InfJumpConn
local function ToggleInfJump(active)
    if InfJumpConn then InfJumpConn:Disconnect(); InfJumpConn = nil end
    if active then
        InfJumpConn = UserInputService.JumpRequest:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
end

-- Loop de actualización
task.spawn(function()
    while task.wait(0.1) do
        ToggleSpeed(Features.Speed.GetState())
        ToggleFly(Features.Fly.GetState())
        ToggleNoclip(Features.Noclip.GetState())
        ToggleBTools(Features.BTools.GetState())
        ToggleInfJump(Features.InfJump.GetState())
    end
end)

-- Movimiento de Vuelo
RunService.RenderStepped:Connect(function()
    if FlyBV and FlyBG then
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end
        FlyBV.Velocity = dir * 60
        FlyBG.CFrame = Camera.CFrame
    end
end)

-- ==========================================
-- 4. ARRASTRE Y TOGGLE DEL MENÚ
-- ==========================================
-- Arrastrar menú
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragOffset = input.Position - Vector2.new(MenuFrame.AbsolutePosition.X, MenuFrame.AbsolutePosition.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
end)

RunService.RenderStepped:Connect(function()
    if Dragging then
        local mousePos = UserInputService:GetMouseLocation()
        MenuFrame.Position = UDim2.new(0, mousePos.X - DragOffset.X, 0, mousePos.Y - DragOffset.Y)
    end
end)

-- Toggle Menú con Botón Flotante
FloatBtn.MouseButton1Click:Connect(function()
    MenuOpen = not MenuOpen
    MenuFrame.Visible = MenuOpen
    
    -- Animación simple de entrada/salida
    if MenuOpen then
        MenuFrame.Position = UDim2.new(0.5, -140, 0.5, -190) -- Centrar al abrir
    end
end)

-- Cerrar con X
CloseBtn.MouseButton1Click:Connect(function()
    MenuFrame.Visible = false
    MenuOpen = false
end)

print("✅ DarkClient v3.1 Loaded | Click 'D' button to open menu")
