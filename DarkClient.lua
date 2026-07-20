--[[
    ========================================
      DARK CLIENT v4.0 - RIELES MUERTOS
    ========================================
    ✅ Bypass Anti-GUI Básico
    ✅ ESP Entidades (Monstruos/Jugadores)
    ✅ Speed, Noclip, InfJump Optimizados
    ✅ Botón Flotante + Menú Neon Purple
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
    ToggleOff = Color3.fromRGB(80, 80, 90),
    ESPColor = Color3.fromRGB(255, 50, 50) -- Rojo para enemigos
}

-- VARIABLES GLOBALES
local MenuOpen = false
local Dragging = false
local DragOffset = Vector2.zero
local ESPBoxes = {} -- Tabla para guardar cajas ESP

-- ==========================================
-- 1. BYPASS ANTI-GUI BÁSICO
-- ==========================================
-- Renombramos la GUI para evitar detección por nombre "DarkClient"
local SafeName = "SystemRender_" .. math.random(1000,9999)

-- ==========================================
-- 2. HUD DE ESTADÍSTICAS
-- ==========================================
local StatsGui = Instance.new("ScreenGui")
StatsGui.Name = SafeName .. "_Stats"
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
-- 3. BOTÓN FLOTANTE
-- ==========================================
local FloatGui = Instance.new("ScreenGui")
FloatGui.Name = SafeName .. "_Float"
FloatGui.ResetOnSpawn = false
FloatGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
FloatGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local FloatBtn = Instance.new("TextButton")
FloatBtn.Size = UDim2.new(0, 50, 0, 50)
FloatBtn.Position = UDim2.new(0, 20, 0.5, -25)
FloatBtn.BackgroundColor3 = Theme.Accent
FloatBtn.Text = "D"
FloatBtn.TextColor3 = Theme.Text
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 24
FloatBtn.AutoButtonColor = false
FloatBtn.Parent = FloatGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatBtn

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Theme.Glow
FloatStroke.Thickness = 2
FloatStroke.Parent = FloatBtn

FloatBtn.MouseEnter:Connect(function()
    TweenService:Create(FloatBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 55, 0, 55)}):Play()
end)
FloatBtn.MouseLeave:Connect(function()
    TweenService:Create(FloatBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 50, 0, 50)}):Play()
end)

-- ==========================================
-- 4. MENÚ GUI PRINCIPAL
-- ==========================================
local MenuGui = Instance.new("ScreenGui")
MenuGui.Name = SafeName .. "_Menu"
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
TitleLabel.Text = "DARK CLIENT v4.0"
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

-- CREAR TOGGLE
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

-- FEATURES ESPECÍFICOS PARA RIELES MUERTOS
local Features = {}
Features.Speed = CreateToggle("Speed Hack", "Correr rápido (x3)", 1)
Features.Noclip = CreateToggle("Noclip", "Atravesar vagones/paredes", 2)
Features.InfJump = CreateToggle("Infinite Jump", "Saltar sin límite", 3)
Features.ESP = CreateToggle("Entity ESP", "Ver monstruos/jugadores", 4)
Features.NoFog = CreateToggle("Remove Fog", "Quitar niebla oscura", 5)

-- LÓGICA DE FUNCIONES
local SpeedConn, NoclipConn, ESPConn
local FlyBV, FlyBG

-- SPEED
local function ToggleSpeed(active)
    if SpeedConn then SpeedConn:Disconnect(); SpeedConn = nil end
    if active then
        SpeedConn = RunService.RenderStepped:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 48 end -- Velocidad segura para Rieles Muertos
        end)
    else
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end

-- NOCLIP
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

-- INFINITE JUMP
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

-- ESP ENTIDADES (Optimizado para Rieles Muertos)
local function ToggleESP(active)
    if ESPConn then ESPConn:Disconnect(); ESPConn = nil end
    -- Limpiar ESP anterior
    for _, box in pairs(ESPBoxes) do if box then box:Destroy() end end
    table.clear(ESPBoxes)
    
    if active then
        ESPConn = RunService.RenderStepped:Connect(function()
            -- Buscar jugadores y posibles entidades
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local root = player.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        -- Crear o actualizar caja ESP
                        if not ESPBoxes[player] then
                            local box = Instance.new("BillboardGui")
                            box.Size = UDim2.new(0, 100, 0, 100)
                            box.AlwaysOnTop = true
                            box.StudsOffset = Vector3.new(0, 2, 0)
                            box.Parent = root
                            
                            local frame = Instance.new("Frame")
                            frame.Size = UDim2.new(1, 0, 1, 0)
                            frame.BackgroundTransparency = 1
                            frame.Parent = box
                            
                            local stroke = Instance.new("UIStroke")
                            stroke.Color = Theme.ESPColor
                            stroke.Thickness = 2
                            stroke.Parent = frame
                            
                            ESPBoxes[player] = box
                        end
                    end
                end
            end
        end)
    end
end

-- REMOVE FOG (Específico para juegos de terror)
local function ToggleNoFog(active)
    if active then
        if workspace:FindFirstChild("Atmosphere") then
            workspace.Atmosphere.Density = 0
            workspace.Atmosphere.Offset = 0
        end
        if workspace:FindFirstChild("Clouds") then
            workspace.Clouds.Cover = 0
        end
        -- Ajustar iluminación
        game.Lighting.Brightness = 2
        game.Lighting.ClockTime = 14
    else
        -- Restaurar valores originales (aproximados)
        if workspace:FindFirstChild("Atmosphere") then
            workspace.Atmosphere.Density = 0.35
            workspace.Atmosphere.Offset = 0
        end
        game.Lighting.Brightness = 1
        game.Lighting.ClockTime = 0
    end
end

-- LOOP DE ACTUALIZACIÓN
task.spawn(function()
    while task.wait(0.1) do
        ToggleSpeed(Features.Speed.GetState())
        ToggleNoclip(Features.Noclip.GetState())
        ToggleInfJump(Features.InfJump.GetState())
        ToggleESP(Features.ESP.GetState())
        ToggleNoFog(Features.NoFog.GetState())
    end
end)

-- ==========================================
-- 5. ARRASTRE Y TOGGLE
-- ==========================================
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

FloatBtn.MouseButton1Click:Connect(function()
    MenuOpen = not MenuOpen
    MenuFrame.Visible = MenuOpen
    if MenuOpen then MenuFrame.Position = UDim2.new(0.5, -140, 0.5, -190) end
end)

CloseBtn.MouseButton1Click:Connect(function()
    MenuFrame.Visible = false
    MenuOpen = false
end)

print("✅ DarkClient v4.0 Rieles Muertos Loaded")
print("🟣 Click 'D' button to open menu | ESP optimizado")
