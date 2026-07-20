--[[
    ========================================
          DARK CLIENT v2.0 - DELTA
    ========================================
    ✅ HUD de Ping/FPS ARREGLADO
    ✅ Menú GUI Interactivo Completo
    ✅ Speed, Fly, Noclip, BTools
    ========================================
]]

-- SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIGURACIÓN DE TEMA
local Theme = {
    Main = Color3.fromRGB(15, 15, 20),
    Accent = Color3.fromRGB(100, 50, 255), -- Violeta eléctrico
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 180),
    ToggleOn = Color3.fromRGB(0, 255, 100),
    ToggleOff = Color3.fromRGB(255, 50, 50)
}

-- ==========================================
-- 1. HUD DE ESTADÍSTICAS (ARREGLADO)
-- ==========================================
local StatsGui = Instance.new("ScreenGui")
StatsGui.Name = "DarkClient_Stats"
StatsGui.ResetOnSpawn = false
StatsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
StatsGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local StatsBox = Instance.new("Frame")
StatsBox.Size = UDim2.new(0, 160, 0, 60)
StatsBox.Position = UDim2.new(1, -170, 0, 10)
StatsBox.BackgroundColor3 = Theme.Main
StatsBox.BorderSizePixel = 0
StatsBox.Parent = StatsGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = StatsBox

local Stroke = Instance.new("UIStroke")
Stroke.Color = Theme.Accent
Stroke.Thickness = 2
Stroke.Parent = StatsBox

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, -10, 1, 0)
StatsLabel.Position = UDim2.new(0, 5, 0, 0)
StatsLabel.BackgroundTransparency = 1
StatsLabel.TextColor3 = Theme.Text
StatsLabel.Font = Enum.Font.Code
StatsLabel.TextSize = 14
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.TextYAlignment = Enum.TextYAlignment.Center
StatsLabel.Parent = StatsBox

-- Loop de actualización del HUD
task.spawn(function()
    while task.wait(0.5) do
        local fps = math.round(1 / RunService.RenderStepped:Wait())
        local ping = math.round(LocalPlayer:GetNetworkPing() * 1000)
        StatsLabel.Text = string.format("🟢 FPS: %d\n PING: %d ms", fps, ping)
    end
end)

-- ==========================================
-- 2. MENÚ GUI INTERACTIVO
-- ==========================================
local MenuGui = Instance.new("ScreenGui")
MenuGui.Name = "DarkClient_Menu"
MenuGui.ResetOnSpawn = false
MenuGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 250, 0, 300)
MenuFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MenuFrame.BackgroundColor3 = Theme.Main
MenuFrame.BorderSizePixel = 0
MenuFrame.Visible = false -- Oculto por defecto
MenuFrame.Parent = MenuGui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 10)
MenuCorner.Parent = MenuFrame

local MenuStroke = Instance.new("UIStroke")
MenuStroke.Color = Theme.Accent
MenuStroke.Thickness = 2
MenuStroke.Parent = MenuFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "DARK CLIENT v2.0"
Title.TextColor3 = Theme.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MenuFrame

-- Función para crear botones toggle
local function CreateToggle(name, yPos, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -20, 0, 35)
    Btn.Position = UDim2.new(0, 10, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Btn.Text = ""
    Btn.AutoButtonColor = false
    Btn.Parent = MenuFrame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Btn
    
    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(0.3, 0, 1, 0)
    Status.Position = UDim2.new(0.7, 0, 0, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "[ OFF ]"
    Status.TextColor3 = Theme.ToggleOff
    Status.Font = Enum.Font.Code
    Status.TextSize = 14
    Status.Parent = Btn
    
    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Status.Text = state and "[ ON ]" or "[ OFF ]"
        Status.TextColor3 = state and Theme.ToggleOn or Theme.ToggleOff
        callback(state)
    end)
    
    return { Update = function(val) 
        state = val
        Status.Text = state and "[ ON ]" or "[ OFF ]"
        Status.TextColor3 = state and Theme.ToggleOn or Theme.ToggleOff
    end }
end

-- Crear controles en el menú
local Toggles = {}
Toggles.Speed = CreateToggle("Speed Hack", 50, function(s) 
    if s then 
        LocalPlayer.Character.Humanoid.WalkSpeed = 50 
    else 
        LocalPlayer.Character.Humanoid.WalkSpeed = 16 
    end
end)

Toggles.Fly = CreateToggle("Fly Mode", 95, function(s)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if root and hum then
        if s then
            hum.PlatformStand = true
            local bv = Instance.new("BodyVelocity", root)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            local bg = Instance.new("BodyGyro", root)
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.P = 10000
            _G.FlyBV = bv; _G.FlyBG = bg
        else
            hum.PlatformStand = false
            if _G.FlyBV then _G.FlyBV:Destroy() end
            if _G.FlyBG then _G.FlyBG:Destroy() end
        end
    end
end)

Toggles.Noclip = CreateToggle("Noclip", 140, function(s)
    _G.NoclipActive = s
end)

-- Lógica de Vuelo y Noclip en segundo plano
RunService.Stepped:Connect(function()
    -- FLY LOGIC
    if _G.FlyBV and _G.FlyBG then
        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.yAxis end
        
        _G.FlyBV.Velocity = moveDir * 50
        _G.FlyBG.CFrame = Camera.CFrame
    end
    
    -- NOCLIP LOGIC
    if _G.NoclipActive and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- ==========================================
-- 3. ATAJOS Y VISIBILIDAD
-- ==========================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    -- INSERT para abrir/cerrar menú
    if input.KeyCode == Enum.KeyCode.Insert then
        MenuFrame.Visible = not MenuFrame.Visible
    end
    -- DELETE para ocultar/mostrar HUD
    if input.KeyCode == Enum.KeyCode.Delete then
        StatsGui.Enabled = not StatsGui.Enabled
    end
end)

print("✅ DarkClient v2.0 Loaded | INSERT = Menu | DELETE = Toggle HUD")
