-- Script principal Kaitun para Plants vs Brainrots
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Variáveis
local Stats = {
    Money = 0,
    SeedsPurchased = {},
    RowsUnlocked = 0,
    StartTime = os.time()
}

-- IDs das imagens para ícones
local IconIds = {
    Money = "rbxassetid://6031280882", -- Ícone de dinheiro
    Seeds = "rbxassetid://6035067830", -- Ícone de planta
    Rows = "rbxassetid://6031075938", -- Ícone de grade
    Time = "rbxassetid://6031302933", -- Ícone de relógio
    Player = "rbxassetid://3926305904", -- Ícone de jogador
    Status = "rbxassetid://6031222726", -- Ícone de status
    AntiAFK = "rbxassetid://6034287533", -- Ícone de escudo
    Performance = "rbxassetid://6031222726", -- Ícone de raio
    Farm = "rbxassetid://6035067830" -- Ícone de farm
}

-- Criar UI Responsiva para Todos os Dispositivos
local function CreateResponsiveUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlessedHubResponsiveUI"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Efeito Blur
    local BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Size = 8
    BlurEffect.Parent = game:GetService("Lighting")
    
    -- Container principal responsivo
    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Size = UDim2.new(0.8, 0, 0.7, 0) -- 80% da largura, 70% da altura
    MainContainer.Position = UDim2.new(0.1, 0, 0.15, 0) -- Centralizado
    MainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    MainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    MainContainer.BackgroundTransparency = 0.1
    MainContainer.BorderSizePixel = 2
    MainContainer.BorderColor3 = Color3.fromRGB(212, 175, 55)
    MainContainer.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = MainContainer
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 80)
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Header.BorderSizePixel = 0
    Header.Parent = MainContainer
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header
    
    -- Barra dourada
    local GoldBar = Instance.new("Frame")
    GoldBar.Name = "GoldBar"
    GoldBar.Size = UDim2.new(1, 0, 0, 3)
    GoldBar.Position = UDim2.new(0, 0, 1, -3)
    GoldBar.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
    GoldBar.BorderSizePixel = 0
    GoldBar.Parent = Header
    
    -- Título
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -40, 0.5, 0)
    Title.Position = UDim2.new(0, 20, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "BLESSED HUB - KAITUN"
    Title.TextColor3 = Color3.fromRGB(212, 175, 55)
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    -- Subtítulo
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
    SubTitle.Size = UDim2.new(1, -40, 0.3, 0)
    SubTitle.Position = UDim2.new(0, 20, 0.5, 0)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "Plants vs Brainrots"
    SubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    SubTitle.TextScaled = true
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.Parent = Header
    
    -- Container de informações principais
    local MainInfoContainer = Instance.new("Frame")
    MainInfoContainer.Name = "MainInfoContainer"
    MainInfoContainer.Size = UDim2.new(1, -40, 0.4, 0)
    MainInfoContainer.Position = UDim2.new(0, 20, 0, 100)
    MainInfoContainer.BackgroundTransparency = 1
    MainInfoContainer.Parent = MainContainer
    
    local MainGrid = Instance.new("UIGridLayout")
    MainGrid.CellSize = UDim2.new(0.5, -10, 0.5, -10)
    MainGrid.CellPadding = UDim2.new(0, 20, 0, 10)
    MainGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
    MainGrid.VerticalAlignment = Enum.VerticalAlignment.Center
    MainGrid.Parent = MainInfoContainer
    
    -- Container de informações secundárias
    local SecondaryInfoContainer = Instance.new("Frame")
    SecondaryInfoContainer.Name = "SecondaryInfoContainer"
    SecondaryInfoContainer.Size = UDim2.new(1, -40, 0.3, 0)
    SecondaryInfoContainer.Position = UDim2.new(0, 20, 0.4, 100)
    SecondaryInfoContainer.BackgroundTransparency = 1
    SecondaryInfoContainer.Parent = MainContainer
    
    local SecondaryGrid = Instance.new("UIGridLayout")
    SecondaryGrid.CellSize = UDim2.new(1, 0, 0.5, -5)
    SecondaryGrid.CellPadding = UDim2.new(0, 0, 0, 5)
    SecondaryGrid.Parent = SecondaryInfoContainer
    
    -- Botão Discord
    local DiscordButton = Instance.new("TextButton")
    DiscordButton.Name = "DiscordButton"
    DiscordButton.Size = UDim2.new(0.6, 0, 0.1, 0)
    DiscordButton.Position = UDim2.new(0.2, 0, 0.85, 0)
    DiscordButton.AnchorPoint = Vector2.new(0.5, 0.5)
    DiscordButton.Position = UDim2.new(0.5, 0, 0.85, 0)
    DiscordButton.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
    DiscordButton.BorderSizePixel = 0
    DiscordButton.Text = "JOIN DISCORD"
    DiscordButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    DiscordButton.TextScaled = true
    DiscordButton.Font = Enum.Font.GothamBold
    DiscordButton.Parent = MainContainer
    
    local DiscordCorner = Instance.new("UICorner")
    DiscordCorner.CornerRadius = UDim.new(0, 8)
    DiscordCorner.Parent = DiscordButton
    
    DiscordButton.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/Wzx2AdSTWs")
        
        -- Notificação
        local notif = Instance.new("TextLabel")
        notif.Text = "Discord link copied!"
        notif.Size = UDim2.new(0.8, 0, 0.08, 0)
        notif.Position = UDim2.new(0.1, 0, 0.75, 0)
        notif.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
        notif.BackgroundTransparency = 0.1
        notif.TextColor3 = Color3.fromRGB(0, 0, 0)
        notif.TextScaled = true
        notif.Font = Enum.Font.GothamBold
        notif.Parent = MainContainer
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 6)
        notifCorner.Parent = notif
        
        task.wait(2)
        notif:Destroy()
    end)
    
    return ScreenGui, MainInfoContainer, SecondaryInfoContainer
end

-- Função para criar item de informação com ícone
local function CreateInfoItem(parent, iconId, text, value, color)
    local ItemFrame = Instance.new("Frame")
    ItemFrame.Name = "InfoItem"
    ItemFrame.Size = UDim2.new(1, 0, 1, 0)
    ItemFrame.BackgroundTransparency = 1
    ItemFrame.Parent = parent
    
    local ItemLayout = Instance.new("UIListLayout")
    ItemLayout.FillDirection = Enum.FillDirection.Horizontal
    ItemLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    ItemLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ItemLayout.Padding = UDim.new(0, 10)
    ItemLayout.Parent = ItemFrame
    
    -- Ícone
    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.Size = UDim2.new(0, 25, 0, 25)
    Icon.BackgroundTransparency = 1
    Icon.Image = iconId
    Icon.Parent = ItemFrame
    
    -- Texto
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "TextLabel"
    TextLabel.Size = UDim2.new(1, -35, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = text .. ": " .. value
    TextLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    TextLabel.TextScaled = true
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.Parent = ItemFrame
    
    return ItemFrame
end

-- Atualizar UI Responsiva
local function UpdateResponsiveUI(mainInfoContainer, secondaryInfoContainer)
    local afkHours = math.floor((os.time() - Stats.StartTime) / 3600)
    local afkMinutes = math.floor(((os.time() - Stats.StartTime) % 3600) / 60)
    
    -- Limpar containers
    for _, child in ipairs(mainInfoContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    for _, child in ipairs(secondaryInfoContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Informações principais
    local mainInfoData = {
        {Icon = IconIds.Money, Text = "Money", Value = tostring(Stats.Money), Color = Color3.fromRGB(212, 175, 55)},
        {Icon = IconIds.Seeds, Text = "Seeds", Value = next(Stats.SeedsPurchased) and "ACTIVE" or "INACTIVE", Color = Color3.fromRGB(76, 175, 80)},
        {Icon = IconIds.Rows, Text = "Rows", Value = tostring(Stats.RowsUnlocked), Color = Color3.fromRGB(33, 150, 243)},
        {Icon = IconIds.Time, Text = "AFK Time", Value = afkHours .. "h " .. afkMinutes .. "m", Color = Color3.fromRGB(156, 39, 176)}
    }
    
    for _, info in ipairs(mainInfoData) do
        CreateInfoItem(mainInfoContainer, info.Icon, info.Text, info.Value, info.Color)
    end
    
    -- Informações secundárias
    local secondaryInfoData = {
        {Icon = IconIds.Player, Text = "Player", Value = LocalPlayer.Name, Color = Color3.fromRGB(200, 200, 200)},
        {Icon = IconIds.Status, Text = "Status", Value = "ACTIVE", Color = Color3.fromRGB(76, 175, 80)},
        {Icon = IconIds.AntiAFK, Text = "Anti-AFK", Value = Config["Anti AFK"] and "ON" or "OFF", Color = Color3.fromRGB(255, 193, 7)},
        {Icon = IconIds.Performance, Text = "Performance", Value = "MAX", Color = Color3.fromRGB(33, 150, 243)},
        {Icon = IconIds.Farm, Text = "Auto Farm", Value = "ENABLED", Color = Color3.fromRGB(156, 39, 176)},
        {Icon = IconIds.Status, Text = "Script", Value = "Blessed Hub", Color = Color3.fromRGB(212, 175, 55)}
    }
    
    for _, info in ipairs(secondaryInfoData) do
        CreateInfoItem(secondaryInfoContainer, info.Icon, info.Text, info.Value, info.Color)
    end
end

-- Anti-Lag Externo
local function LoadAntiLag()
    if not Config["Performance"]["Anti Lag"] then return end
    
    pcall(function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-antilag-universal-test-30627"))()
    end)
end

-- White Screen
local function WhiteScreen()
    if not Config["Performance"]["White Screen"] then return end
    
    spawn(function()
        while Config["Performance"]["White Screen"] do
            pcall(function()
                local lighting = game:GetService("Lighting")
                lighting.Ambient = Color3.new(1, 1, 1)
                lighting.Brightness = 3
                lighting.GlobalShadows = false
                lighting.OutdoorAmbient = Color3.new(1, 1, 1)
                lighting.ClockTime = 12
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
                        task.wait(Config["Auto Buy"]["Seeds"]["Fast Mode"] and 0.05 or 0.5)
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
            local plot = Workspace.Plots:FindChild(tostring(i))
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

-- Auto Sell
local function SetupAutoSell()
    spawn(function()
        while true do
            if Config["Auto Play"]["Auto Sell"]["Brainrot"]["Enable"] then
                for rarity, enabled in pairs(Config["Auto Play"]["Auto Sell"]["Brainrot"]["Select Brainrot Rarity"]) do
                    if enabled then
                        local args = {[1] = rarity}
                        pcall(function() ReplicatedStorage.Remotes.AutoSell:FireServer(unpack(args)) end)
                        task.wait(1)
                    end
                end
                for mutation, enabled in pairs(Config["Auto Play"]["Auto Sell"]["Brainrot"]["Select Brainrot Mutation"]) do
                    if enabled then
                        local args = {[1] = mutation}
                        pcall(function() ReplicatedStorage.Remotes.AutoSell:FireServer(unpack(args)) end)
                        task.wait(1)
                    end
                end
            end
            
            if Config["Auto Play"]["Auto Sell"]["Plants"]["Enable"] then
                for rarity, enabled in pairs(Config["Auto Play"]["Auto Sell"]["Plants"]["Select Plants Rarity"]) do
                    if enabled then
                        local args = {[1] = rarity}
                        pcall(function() ReplicatedStorage.Remotes.AutoSell:FireServer(unpack(args)) end)
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
    if not Config["Anti AFK"] then return end
    
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
    
    -- Criar UI Responsiva
    local UI, MainInfoContainer, SecondaryInfoContainer = CreateResponsiveUI()
    
    -- Configurações
    FPSBoost()
    WhiteScreen()
    LoadAntiLag()
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
            UpdateResponsiveUI(MainInfoContainer, SecondaryInfoContainer)
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

-- Iniciar o script
Initialize()
