-- Script principal Kaitun para Plants vs Brainrots
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

-- Variáveis
local Stats = {
    Money = 0,
    SeedsPurchased = {},
    PlatformsPurchased = 0,
    RowsUnlocked = 0,
    StartTime = os.time()
}

-- Criar UI com Blur
local function CreateBlurUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlessedHubUI"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Efeito Blur
    local BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Size = 10
    BlurEffect.Parent = game:GetService("Lighting")
    
    -- Container principal
    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Size = UDim2.new(0, 400, 0, 300)
    MainContainer.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainContainer.BackgroundTransparency = 0.3
    MainContainer.BorderSizePixel = 0
    MainContainer.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 15)
    Corner.Parent = MainContainer
    
    -- Título
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "BLESSED HUB - KAITUN MODE"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainContainer
    
    -- Informações
    local InfoFrame = Instance.new("Frame")
    InfoFrame.Name = "InfoFrame"
    InfoFrame.Size = UDim2.new(1, -40, 0, 180)
    InfoFrame.Position = UDim2.new(0, 20, 0, 60)
    InfoFrame.BackgroundTransparency = 1
    InfoFrame.Parent = MainContainer
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.Parent = InfoFrame
    
    -- Botão Discord
    local DiscordButton = Instance.new("TextButton")
    DiscordButton.Name = "DiscordButton"
    DiscordButton.Size = UDim2.new(0, 150, 0, 40)
    DiscordButton.Position = UDim2.new(0.5, -75, 1, -50)
    DiscordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    DiscordButton.BorderSizePixel = 0
    DiscordButton.Text = "JOIN DISCORD"
    DiscordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DiscordButton.Font = Enum.Font.GothamBold
    DiscordButton.TextScaled = true
    DiscordButton.Parent = MainContainer
    
    local DiscordCorner = Instance.new("UICorner")
    DiscordCorner.CornerRadius = UDim.new(0, 8)
    DiscordCorner.Parent = DiscordButton
    
    DiscordButton.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/Wzx2AdSTWs")
        
        -- Notificação
        local notif = Instance.new("TextLabel")
        notif.Text = "Discord link copied!"
        notif.Size = UDim2.new(0, 200, 0, 40)
        notif.Position = UDim2.new(0.5, -100, 0, -50)
        notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        notif.BackgroundTransparency = 0.3
        notif.TextColor3 = Color3.fromRGB(255, 255, 255)
        notif.Font = Enum.Font.Gotham
        notif.TextScaled = true
        notif.Parent = MainContainer
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 8)
        notifCorner.Parent = notif
        
        task.wait(2)
        notif:Destroy()
    end)
    
    return ScreenGui, InfoFrame
end

-- Atualizar informações na UI
local function UpdateUI(infoFrame)
    local afkHours = math.floor((os.time() - Stats.StartTime) / 3600)
    local afkMinutes = math.floor(((os.time() - Stats.StartTime) % 3600) / 60)
    
    -- Limpar informações antigas
    for _, child in ipairs(infoFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    -- Criar novas informações
    local infoTexts = {
        "💰 Money: $" .. tostring(Stats.Money),
        "🌱 Seeds Purchased: " .. (next(Stats.SeedsPurchased) and "Yes" or "No"),
        "🏗️ Platforms: " .. Stats.PlatformsPurchased,
        "📏 Rows: " .. Stats.RowsUnlocked,
        "⏰ AFK Time: " .. afkHours .. "h " .. afkMinutes .. "m",
        "⚡ Status: ACTIVE",
        "🎮 Script: Blessed Hub Kaitun",
        "👤 Player: " .. LocalPlayer.Name
    }
    
    for i, text in ipairs(infoTexts) do
        local InfoLabel = Instance.new("TextLabel")
        InfoLabel.Name = "Info_" .. i
        InfoLabel.Size = UDim2.new(1, 0, 0, 25)
        InfoLabel.BackgroundTransparency = 1
        InfoLabel.Text = text
        InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
        InfoLabel.Font = Enum.Font.Gotham
        InfoLabel.TextScaled = true
        InfoLabel.Parent = infoFrame
    end
end

-- White Screen Corrigido
local function WhiteScreen()
    if not Config["Performance"]["White Screen"] then return end
    
    spawn(function()
        while Config["Performance"]["White Screen"] do
            pcall(function()
                local lighting = game:GetService("Lighting")
                lighting.Ambient = Color3.new(1, 1, 1)
                lighting.Brightness = 2
                lighting.GlobalShadows = false
                lighting.OutdoorAmbient = Color3.new(1, 1, 1)
                
                -- Forçar white screen no workspace também
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Part") then
                        obj.Material = Enum.Material.SmoothPlastic
                        obj.Color = Color3.new(1, 1, 1)
                    end
                end
            end)
            task.wait(5)
        end
    end)
end

-- Redeem Codes
local function RedeemCodes()
    if not Config["Redeem Code"] then return end
    
    local codes = {"based", "RELEASE", "UPDT1"}
    
    for _, code in ipairs(codes) do
        local args = {[1] = code}
        pcall(function()
            ReplicatedStorage.Remotes.ClaimCode:FireServer(unpack(args))
            print("✅ Code redeemed: " .. code)
        end)
        task.wait(1)
    end
end

-- Anti-Lag Melhorado
local function AntiLag()
    if not Config["Performance"]["Anti Lag"] then return end
    
    spawn(function()
        while Config["Performance"]["Anti Lag"] do
            pcall(function()
                -- Remover texturas e efeitos
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Decal") or obj:IsA("Texture") then
                        obj:Destroy()
                    end
                    
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
                        obj.Enabled = false
                    end
                    
                    if obj:IsA("SurfaceLight") or obj:IsA("PointLight") or obj:IsA("SpotLight") then
                        obj.Enabled = false
                    end
                    
                    if obj:IsA("BasePart") then
                        obj.Material = Enum.Material.Plastic
                    end
                end
                
                -- Configuração gráfica
                local args = {
                    [1] = {
                        ["Value"] = true,
                        ["Setting"] = "Graphics"
                    }
                }
                ReplicatedStorage.Remotes.ChangeSetting:FireServer(unpack(args))
            end)
            task.wait(10)
        end
    end)
end

-- Auto Buy Seeds FAST
local function AutoBuySeeds()
    if not Config["Auto Buy"]["Seeds"]["Enable"] then return end
    
    spawn(function()
        while Config["Auto Buy"]["Seeds"]["Enable"] do
            pcall(function()
                for seed, enabled in pairs(Config["Auto Buy"]["Seeds"]["Select Seeds"]) do
                    if enabled then
                        ReplicatedStorage.Remotes.BuyItem:FireServer(seed)
                        Stats.SeedsPurchased[seed] = (Stats.SeedsPurchased[seed] or 0) + 1
                        
                        -- FAST MODE - delay reduzido
                        if Config["Auto Buy"]["Seeds"]["Fast Mode"] then
                            task.wait(0.05)
                        else
                            task.wait(0.5)
                        end
                    end
                end
            end)
            task.wait(Config["Auto Buy"]["Seeds"]["Fast Mode"] and 1 or 5)
        end
    end)
end

-- Auto Buy Gears
local function AutoBuyGears()
    if not Config["Auto Buy"]["Gears"]["Enable"] then return end
    
    spawn(function()
        while Config["Auto Buy"]["Gears"]["Enable"] do
            pcall(function()
                for gear, enabled in pairs(Config["Auto Buy"]["Gears"]["Select Gears"]) do
                    if enabled then
                        ReplicatedStorage.Remotes.BuyGear:FireServer(gear)
                        task.wait(0.5)
                    end
                end
            end)
            task.wait(10)
        end
    end)
end

-- Auto Buy Platform
local function AutoBuyPlatform()
    if not Config["Auto Buy"]["Platform"]["Enable"] then return end
    
    local function GetMyPlot()
        for i = 1, 6 do
            local plot = Workspace.Plots:FindFirstChild(tostring(i))
            if plot and plot:GetAttribute("Owner") == LocalPlayer.Name then
                return plot, i
            end
        end
        return nil
    end
    
    spawn(function()
        while Config["Auto Buy"]["Platform"]["Enable"] do
            pcall(function()
                local myPlot, plotNum = GetMyPlot()
                if not myPlot then return end
                
                for i = 1, 6 do
                    local platform = myPlot.Brainrots:FindFirstChild(tostring(i))
                    if platform and platform:FindFirstChild("PlatformPrice") then
                        local price = platform.PlatformPrice.Value
                        if price > 0 then
                            local args = {[1] = tostring(i)}
                            ReplicatedStorage.Remotes.BuyPlatform:FireServer(unpack(args))
                            Stats.PlatformsPurchased = Stats.PlatformsPurchased + 1
                            task.wait(1)
                        end
                    end
                end
            end)
            task.wait(30)
        end
    end)
end

-- Auto Unlock Rows
local function AutoUnlockRows()
    if not Config["Auto Play"]["Auto Unlock Rows"]["Enable"] then return end
    
    spawn(function()
        while Config["Auto Play"]["Auto Unlock Rows"]["Enable"] do
            pcall(function()
                for i = 1, Config["Auto Play"]["Auto Unlock Rows"]["Max Unlock"] do
                    local args = {[1] = i}
                    ReplicatedStorage.Remotes.BuyRow:FireServer(unpack(args))
                    Stats.RowsUnlocked = math.max(Stats.RowsUnlocked, i)
                    task.wait(1)
                end
            end)
            task.wait(60)
        end
    end)
end

-- Auto Sell por Raridade/Mutação
local function SetupAutoSell()
    spawn(function()
        while true do
            -- Auto Sell Brainrot
            if Config["Auto Play"]["Auto Sell"]["Brainrot"]["Enable"] then
                for rarity, enabled in pairs(Config["Auto Play"]["Auto Sell"]["Brainrot"]["Select Brainrot Rarity"]) do
                    if enabled then
                        local args = {[1] = rarity}
                        pcall(function()
                            ReplicatedStorage.Remotes.AutoSell:FireServer(unpack(args))
                        end)
                        task.wait(1)
                    end
                end
                
                for mutation, enabled in pairs(Config["Auto Play"]["Auto Sell"]["Brainrot"]["Select Brainrot Mutation"]) do
                    if enabled then
                        local args = {[1] = mutation}
                        pcall(function()
                            ReplicatedStorage.Remotes.AutoSell:FireServer(unpack(args))
                        end)
                        task.wait(1)
                    end
                end
            end
            
            -- Auto Sell Plants
            if Config["Auto Play"]["Auto Sell"]["Plants"]["Enable"] then
                for rarity, enabled in pairs(Config["Auto Play"]["Auto Sell"]["Plants"]["Select Plants Rarity"]) do
                    if enabled then
                        local args = {[1] = rarity}
                        pcall(function()
                            ReplicatedStorage.Remotes.AutoSell:FireServer(unpack(args))
                        end)
                        task.wait(1)
                    end
                end
            end
            
            task.wait(30)
        end
    end)
end

-- Monitorar Dinheiro
local function MonitorMoney()
    spawn(function()
        while true do
            pcall(function()
                local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
                if leaderstats and leaderstats:FindFirstChild("Money") then
                    Stats.Money = leaderstats.Money.Value
                end
            end)
            task.wait(2)
        end
    end)
end

-- Anti-AFK
local function SetupAntiAFK()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- FPS Boost
local function FPSBoost()
    if not Config["Performance"]["FPS Boost"] then return end
    
    if setfpscap then
        setfpscap(999)
    end
end

-- Inicialização
local function Initialize()
    print("🎮 Blessed Hub Kaitun Loading...")
    
    -- Criar UI
    local UI, InfoFrame = CreateBlurUI()
    
    -- Configurações de performance
    FPSBoost()
    WhiteScreen()
    AntiLag()
    
    -- Sistemas básicos
    SetupAntiAFK()
    MonitorMoney()
    
    -- Auto Skip Tutorial
    if Config["Skip Tutorial"] then
        spawn(function()
            print("⏳ Waiting 15 minutes to skip tutorial...")
            task.wait(900)
            print("✅ Tutorial skipped - Starting all functions...")
            StartAllFunctions()
        end)
    else
        StartAllFunctions()
    end
    
    -- Atualizar UI
    spawn(function()
        while task.wait(3) do
            UpdateUI(InfoFrame)
        end
    end)
    
    print("✅ Blessed Hub Kaitun Fully Loaded!")
end

-- Iniciar todas as funções
function StartAllFunctions()
    RedeemCodes()
    SetupAutoSell()
    AutoBuySeeds()
    AutoBuyGears()
    AutoBuyPlatform()
    AutoUnlockRows()
end

-- Resposta à sua pergunta:
-- SIM, você precisa transformar em loadstring para funcionar corretamente!
-- Use este comando:
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/seuusuario/seurepositorio/main/script.lua"))()

-- Iniciar o script
Initialize()
