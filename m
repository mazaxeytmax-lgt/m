local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- Interfaz Principal
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 280)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
MainFrame.Active = true
MainFrame.Draggable = true

-- Título
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "MAZ HUB"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- Botón Minimizar
local MiniBtn = Instance.new("TextButton", MainFrame)
MiniBtn.Text = "-"
MiniBtn.Size = UDim2.new(0, 30, 0, 30)
MiniBtn.Position = UDim2.new(1, -35, 0, 5)
MiniBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 1.2, 0)
Container.ScrollBarThickness = 2

local layout = Instance.new("UIListLayout", Container)
layout.Padding = UDim.new(0, 10)

-- Función para crear botones estilizados
local function CreateButton(txt, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Text = txt .. ": OFF"
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = txt .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(35, 35, 35)
        callback(state)
    end)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
end

--- LÓGICA DE LAS FUNCIONES ---

-- 1. Silent Aim (Hitbox 60)
CreateButton("SILENT AIM", function(t)
    _G.HitboxSize = t and 60 or 2
    RunService.RenderStepped:Connect(function()
        if _G.HitboxSize > 2 then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    v.Character.HumanoidRootPart.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                    v.Character.HumanoidRootPart.Transparency = 0.7
                    v.Character.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end)
end)

-- 2. ESP Chams
CreateButton("ESP CHAMS", function(t)
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character then
            if t then
                local highlight = Instance.new("Highlight", v.Character)
                highlight.Name = "Chams"
                highlight.FillColor = Color3.fromRGB(0, 170, 255)
            else
                if v.Character:FindFirstChild("Chams") then v.Character.Chams:Destroy() end
            end
        end
    end
end)

-- 3. ESP Name
CreateButton("ESP NAME", function(t)
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
            if t then
                local billboard = Instance.new("BillboardGui", v.Character.Head)
                billboard.Name = "NameTag"
                billboard.AlwaysOnTop = true
                billboard.Size = UDim2.new(0, 100, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                local label = Instance.new("TextLabel", billboard)
                label.Text = v.Name
                label.Size = UDim2.new(1, 0, 1, 0)
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.BackgroundTransparency = 1
                label.TextStrokeTransparency = 0
            else
                if v.Character.Head:FindFirstChild("NameTag") then v.Character.Head.NameTag:Destroy() end
            end
        end
    end
end)

-- Lógica Minimizar
local min = false
MiniBtn.MouseButton1Click:Connect(function()
    min = not min
    Container.Visible = not min
    MainFrame:TweenSize(min and UDim2.new(0, 220, 0, 45) or UDim2.new(0, 220, 0, 280), "Out", "Quad", 0.3)
end)
