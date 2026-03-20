local ok, result = pcall(function()
    local mainScript = game:HttpGet(
        "https://raw.githubusercontent.com/CrafyXD/susano-backend/main/susano_obfuscated.lua",
        true
    )
    loadstring(mainScript)()
end)

if not ok then
    local gui = Instance.new("ScreenGui")
    gui.Name = "SusanoError"
    gui.Parent = game:GetService("CoreGui")
    gui.ResetOnSpawn = false
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 400, 0, 80)
    frame.Position = UDim2.new(0.5, -200, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Susano yuklenemedi: " .. tostring(result):sub(1, 80)
    lbl.TextColor3 = Color3.fromRGB(255, 80, 80)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextWrapped = true
    task.delay(5, function() gui:Destroy() end)
end
