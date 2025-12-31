-- =========================
-- IVORY PERIASTRON | UI BRANCA + TOGGLE VERMELHO OFF (COMO NOS OUTROS)
-- =========================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local enabled = false
local loopConnection

-- =========================
-- IVORY PERIASTRON ACTIVATION (SIMULA TECLA Q CONTINUAMENTE)
-- =========================

local function startIvoryPeriastron()
    if loopConnection then return end
    
    loopConnection = RunService.Heartbeat:Connect(function()
        if not enabled then return end
        task.wait(0.1)
        
        local char = LocalPlayer.Character
        local bp = LocalPlayer.Backpack
        if not char or not bp then return end
        
        -- Equipa todas as IvoryPeriastron da backpack
        for _, tool in pairs(bp:GetChildren()) do
            if tool.Name == "IvoryPeriastron" then
                tool.Parent = char
            end
        end
        
        -- Dispara o remote nas que estão equipadas
        for _, tool in pairs(char:GetChildren()) do
            if tool.Name == "IvoryPeriastron" and tool:FindFirstChild("Handle") then
                local remote = tool:FindFirstChild("Remote") or tool:FindFirstChild("ServerControl")
                if remote then
                    pcall(function()
                        remote:FireServer(Enum.KeyCode.Q)
                    end)
                end
            end
        end
    end)
end

local function stopIvoryPeriastron()
    if loopConnection then
        loopConnection:Disconnect()
        loopConnection = nil
    end
end

-- =========================
-- GUI IVORY (TEMA BRANCO COM SWITCH VERMELHO OFF)
-- =========================

local gui = Instance.new("ScreenGui")
gui.Name = "IvoryUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 110, 0, 30)
main.Position = UDim2.new(1, -140, 0.25, 0)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = false
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

-- BORDA BRANCA
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2.5
stroke.Color = Color3.fromRGB(255, 255, 255)  -- BRANCO
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 55, 1, 0)
title.Position = UDim2.new(0, 6, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Ivory"
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextColor3 = Color3.fromRGB(255, 255, 255)  -- BRANCO
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- SWITCH
local switch = Instance.new("Frame")
switch.Size = UDim2.new(0, 34, 0, 18)
switch.Position = UDim2.new(1, -38, 0.5, -9)
switch.BackgroundColor3 = Color3.fromRGB(255, 40, 40)  -- VERMELHO QUANDO DESLIGADO (igual aos outros)
switch.BorderSizePixel = 0
switch.Parent = main
Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

local knob = Instance.new("Frame")
knob.Size = UDim2.new(0, 14, 0, 14)
knob.Position = UDim2.new(0, 2, 0.5, -7)
knob.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
knob.BorderSizePixel = 0
knob.Parent = switch
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

-- =========================
-- DRAG SYSTEM (IDÊNTICO AO RAINBOW QUE MOVE PERFEITO)
-- =========================
local dragging = false
local dragStart
local startPos

main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

main.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- =========================
-- TOGGLE (CLIQUE DIRETO NO SWITCH)
-- =========================
switch.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        enabled = not enabled

        if enabled then
            TweenService:Create(switch, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- BRANCO QUANDO LIGADO
            }):Play()

            TweenService:Create(knob, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -16, 0.5, -7)
            }):Play()

            startIvoryPeriastron()

        else
            TweenService:Create(switch, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(255, 40, 40)  -- VERMELHO QUANDO DESLIGADO
            }):Play()

            TweenService:Create(knob, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0.5, -7)
            }):Play()

            stopIvoryPeriastron()
        end
    end
end)
