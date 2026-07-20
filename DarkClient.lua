--[[
    ========================================
          DARK CLIENT v1.0 - DELTA
    ========================================
    Autor: Asistente AI
    Compatibilidad: Delta / Fluxus / Wave
    Funciones: Stats HUD, Speed, Fly, Noclip
    ========================================
]]

-- SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- VARIABLES DE ESTADO
local DarkClient = {
    Enabled = true,
    Speed = false,
    Fly = false,
    Noclip = false,
    SpeedValue = 16,
    FlySpeed = 50
}

-- CONFIGURACIÓN DE ESTILO (Tema Oscuro)
local Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    Accent = Color3.fromRGB(138, 43, 226), -- Violeta Neón
    Text = Color3.fromRGB(255, 255, 255),
    SecondaryText = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(40, 40, 50)
}

-- ==========================================
-- 1. SISTEMA DE ESTADÍSTICAS (PING / FPS)
-- ==========================================
local function CreateStatsHUD()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DarkClient_Stats"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local StatsFrame = Instance.new("Frame")
    StatsFrame.Size = UDim2.new(0, 140, 0, 50)
    StatsFrame.Position = UDim2.new(1, -150, 0, 10)
    StatsFrame.BackgroundColor3 = Theme.Background
    StatsFrame.BorderSizePixel = 0
    StatsFrame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = StatsFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme.Accent
    Stroke.Thickness = 1
    Stroke.Parent = StatsFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.Code
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.PaddingLeft = UDim.new(0, 10)
    Label.Parent = StatsFrame

    -- Actualización constante
    RunService.RenderStepped:Connect(function()
        if not DarkClient.Enabled then 
            StatsFrame.Visible = false 
            return 
        end
        
        StatsFrame.Visible = true
        local fps = math.round(1 / RunService.RenderStepped:Wait())
        local ping = math.round(LocalPlayer:GetNetworkPing() * 1000)
        
        Label.Text = string.format("FPS: %d\nPING: %d ms", fps, ping)
    end)
    
    return ScreenGui
end

-- ==========================================
-- 2. FUNCIONES UNIVERSALES
-- ==========================================

-- SPEED HACK
local SpeedConnection
local function ToggleSpeed(state)
    DarkClient.Speed = state
    if SpeedConnection then SpeedConnection:Disconnect() end
    
    if state then
        SpeedConnection = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = DarkClient.SpeedValue
            end
        end)
    else
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end

-- NOCLIP
local NoclipConnection
local function ToggleNoclip(state)
    DarkClient.Noclip = state
    if NoclipConnection then NoclipConnection:Disconnect() end
    
    if state then
        NoclipConnection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- FLY (Básico)
local FlyBV, FlyBG
local function ToggleFly(state)
    DarkClient.Fly = state
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if not root or not hum then return end
    
    if state then
        hum.PlatformStand = true
        FlyBV = Instance.new("BodyVelocity", root)
        FlyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        FlyBV.Velocity = Vector3.zero
        
        FlyBG = Instance.new("BodyGyro", root)
        FlyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        FlyBG.D = 100
        FlyBG.P = 10000
    else
        hum.PlatformStand = false
        if FlyBV then FlyBV:Destroy() end
        if FlyBG then FlyBG:Destroy() end
    end
end

-- Controles de Vuelo
RunService.RenderStepped:Connect(function()
    if DarkClient.Fly and FlyBV and FlyBG then
        local moveDir = Camera.CFrame.LookVector * (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
                      + Camera.CFrame.LookVector * (UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0)
                      + Camera.CFrame.RightVector * (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0)
                      + Camera.CFrame.RightVector * (UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0)
                      + Vector3.yAxis * (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0)
                      + Vector3.yAxis * (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and -1 or 0)
        
        FlyBV.Velocity = moveDir * DarkClient.FlySpeed
        FlyBG.CFrame = Camera.CFrame
    end
end)

-- ==========================================
-- 3. INICIALIZACIÓN
-- ==========================================
CreateStatsHUD()

-- Atajos de Teclado
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        DarkClient.Enabled = not DarkClient.Enabled
    end
    if input.KeyCode == Enum.KeyCode.V then ToggleSpeed(not DarkClient.Speed) end
    if input.KeyCode == Enum.KeyCode.F then ToggleFly(not DarkClient.Fly) end
    if input.KeyCode == Enum.KeyCode.N then ToggleNoclip(not DarkClient.Noclip) end
end)

print("✅ DarkClient v1.0 Cargado | RightShift = Toggle HUD | V=Speed F=Fly N=Noclip")
