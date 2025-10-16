-- Speed UI Library v3.0 - Inventory Style
-- discord.gg/speedhubx

local SpeedUI = {}
SpeedUI.__index = SpeedUI

-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Configurações
local player = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled

-- Sistema de Auto Save
local DataStoreService = game:GetService("DataStoreService")
local configDataStore = DataStoreService:GetDataStore("SpeedUIConfig")

-- Cores do tema Inventory
local themes = {
    Dark = {
        Background = Color3.fromRGB(30, 32, 35),
        Primary = Color3.fromRGB(47, 49, 54),
        Secondary = Color3.fromRGB(60, 63, 70),
        Accent = Color3.fromRGB(88, 101, 242),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(150, 152, 157),
        TextMuted = Color3.fromRGB(100, 102, 107),
        Border = Color3.fromRGB(50, 52, 57),
        Success = Color3.fromRGB(87, 242, 135),
        Warning = Color3.fromRGB(242, 201, 76),
        Danger = Color3.fromRGB(242, 100, 100)
    }
}

-- Ícones (usando emojis como texto)
local icons = {
    Close = "✕",
    Menu = "☰",
    Home = "🏠",
    Settings = "⚙️",
    Inventory = "🎒",
    Shop = "🛒",
    Favorite = "⭐",
    Unfavorite = "☆",
    Debug = "🐛",
    Market = "💰",
    Miscellaneous = "🔧",
    ArrowDown = "▼",
    ArrowUp = "▲",
    Check = "✓",
    Star = "★"
}

function SpeedUI.new(options)
    options = options or {}
    
    local self = setmetatable({}, SpeedUI)
    
    -- Configurações
    self.theme = options.Theme or "Dark"
    self.autoSave = options.AutoSave or true
    self.saveKey = options.SaveKey or "SpeedUI_Config"
    self.defaultSize = options.Size or UDim2.new(0, 500, 0, 600)
    self.defaultPosition = options.Position or UDim2.new(0.5, -250, 0.5, -300)
    self.isOpen = true
    
    -- Estado da UI
    self.windows = {}
    self.currentWindow = nil
    self.savedSettings = {}
    self.elements = {}
    
    -- Carregar configurações salvas
    if self.autoSave then
        self:loadSettings()
    end
    
    -- Criar interface principal
    self:createMainUI()
    
    return self
end

-- Sistema de Auto Save
function SpeedUI:saveSettings()
    if not self.autoSave then return end
    
    local success, err = pcall(function()
        configDataStore:SetAsync(self.saveKey, self.savedSettings)
    end)
    
    if not success then
        warn("Speed UI - Erro ao salvar: " .. err)
    end
end

function SpeedUI:loadSettings()
    local success, data = pcall(function()
        return configDataStore:GetAsync(self.saveKey)
    end)
    
    if success and data then
        self.savedSettings = data
    end
end

function SpeedUI:getSetting(key, default)
    return self.savedSettings[key] or default
end

function SpeedUI:setSetting(key, value)
    self.savedSettings[key] = value
    if self.autoSave then
        self:saveSettings()
    end
end

-- Função de animação segura
local function safeTween(object, properties, duration)
    if not object or not object.Parent then return end
    duration = duration or 0.2
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Criar UI principal
function SpeedUI:createMainUI()
    -- ScreenGui principal
    self.mainGui = Instance.new("ScreenGui")
    self.mainGui.Name = "SpeedUIV3"
    self.mainGui.ResetOnSpawn = false
    self.mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.mainGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Container principal
    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Size = isMobile and UDim2.new(1, -20, 1, -20) or self.defaultSize
    self.mainFrame.Position = isMobile and UDim2.new(0, 10, 0, 10) or self.defaultPosition
    self.mainFrame.BackgroundColor3 = themes[self.theme].Background
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.ClipsDescendants = true
    self.mainFrame.Parent = self.mainGui
    
    -- Arredondamento
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = self.mainFrame
    
    -- Borda
    local stroke = Instance.new("UIStroke")
    stroke.Color = themes[self.theme].Border
    stroke.Thickness = 2
    stroke.Parent = self.mainFrame
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = themes[self.theme].Primary
    header.BorderSizePixel = 0
    header.Parent = self.mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "# Inventory"
    title.TextColor3 = themes[self.theme].Text
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.Parent = header
    
    -- Botão de fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
    closeBtn.BackgroundColor3 = themes[self.theme].Secondary
    closeBtn.Text = icons.Close
    closeBtn.TextColor3 = themes[self.theme].Text
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    
    -- Efeitos hover no botão de fechar
    closeBtn.MouseEnter:Connect(function()
        safeTween(closeBtn, {BackgroundColor3 = themes[self.theme].Danger}, 0.2)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        safeTween(closeBtn, {BackgroundColor3 = themes[self.theme].Secondary}, 0.2)
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        self:ToggleUI()
    end)
    
    -- Container de conteúdo
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, 0, 1, -50)
    contentContainer.Position = UDim2.new(0, 0, 0, 50)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = self.mainFrame
    
    -- Container de abas (sidebar)
    self.tabContainer = Instance.new("ScrollingFrame")
    self.tabContainer.Size = isMobile and UDim2.new(1, 0, 0, 60) or UDim2.new(0, 180, 1, 0)
    self.tabContainer.Position = isMobile and UDim2.new(0, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
    self.tabContainer.BackgroundColor3 = themes[self.theme].Primary
    self.tabContainer.BorderSizePixel = 0
    self.tabContainer.ScrollBarThickness = 3
    self.tabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.tabContainer.Parent = contentContainer
    
    -- Container de conteúdo principal
    self.contentContainer = Instance.new("Frame")
    self.contentContainer.Size = isMobile and UDim2.new(1, 0, 1, -60) or UDim2.new(1, -180, 1, 0)
    self.contentContainer.Position = isMobile and UDim2.new(0, 0, 0, 60) or UDim2.new(0, 180, 0, 0)
    self.contentContainer.BackgroundTransparency = 1
    self.contentContainer.ClipsDescendants = true
    self.contentContainer.Parent = contentContainer
    
    -- ScrollingFrame para conteúdo
    self.contentScrolling = Instance.new("ScrollingFrame")
    self.contentScrolling.Size = UDim2.new(1, 0, 1, 0)
    self.contentScrolling.BackgroundTransparency = 1
    self.contentScrolling.ScrollBarThickness = 6
    self.contentScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.contentScrolling.Parent = self.contentContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 15)
    contentLayout.Parent = self.contentScrolling
    
    -- Layout para abas
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.Parent = self.tabContainer
    
    if isMobile then
        tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        self.tabContainer.ScrollingDirection = Enum.ScrollingDirection.X
        self.tabContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
    else
        tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        self.tabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    end
end

-- Criar nova janela/aba
function SpeedUI:Window(name, icon)
    local window = {
        name = name,
        tabs = {},
        currentTab = nil,
        icon = icon or icons.Settings
    }
    
    -- Criar botão da aba
    local tabButton = Instance.new("TextButton")
    tabButton.Size = isMobile and UDim2.new(0, 120, 0, 50) or UDim2.new(1, -16, 0, 45)
    tabButton.BackgroundColor3 = themes[self.theme].Secondary
    tabButton.Text = (icon and (icon .. "  ") or "") .. name
    tabButton.TextColor3 = themes[self.theme].TextSecondary
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.Parent = self.tabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabButton
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingLeft = UDim.new(0, 12)
    tabPadding.Parent = tabButton
    
    -- Container de conteúdo da aba
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 6
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentFrame.Visible = false
    contentFrame.Parent = self.contentScrolling
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 15)
    contentLayout.Parent = contentFrame
    
    window.contentFrame = contentFrame
    window.tabButton = tabButton
    
    -- Evento de clique
    tabButton.MouseButton1Click:Connect(function()
        self:switchWindow(window)
    end)
    
    -- Efeitos hover
    tabButton.MouseEnter:Connect(function()
        if self.currentWindow ~= window then
            safeTween(tabButton, {BackgroundColor3 = Color3.fromRGB(70, 73, 80)}, 0.2)
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.currentWindow ~= window then
            safeTween(tabButton, {BackgroundColor3 = themes[self.theme].Secondary}, 0.2)
        end
    end)
    
    table.insert(self.windows, window)
    
    -- Se for a primeira aba, ativar
    if #self.windows == 1 then
        self:switchWindow(window)
    end
    
    return setmetatable(window, {__index = self})
end

-- Mudar entre abas
function SpeedUI:switchWindow(window)
    if self.currentWindow then
        self.currentWindow.contentFrame.Visible = false
        safeTween(self.currentWindow.tabButton, {
            BackgroundColor3 = themes[self.theme].Secondary,
            TextColor3 = themes[self.theme].TextSecondary
        }, 0.2)
    end
    
    self.currentWindow = window
    window.contentFrame.Visible = true
    safeTween(window.tabButton, {
        BackgroundColor3 = themes[self.theme].Accent,
        TextColor3 = themes[self.theme].Text
    }, 0.2)
end

-- Seção com título
function SpeedUI:Section(title)
    local section = {}
    
    -- Container da seção
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -30, 0, 0)
    container.BackgroundTransparency = 1
    container.LayoutOrder = #self.currentWindow.contentFrame:GetChildren() + 1
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.Parent = self.currentWindow.contentFrame
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = container
    
    -- Título da seção
    if title then
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, 0, 0, 25)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = themes[self.theme].Text
        titleLabel.TextSize = 16
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.Parent = container
    end
    
    section.container = container
    return setmetatable(section, {__index = self})
end

-- Toggle estilo Inventory
function SpeedUI:Toggle(name, default, callback)
    local toggle = {
        value = self:getSetting(name, default or false),
        callback = callback
    }
    
    -- Container do toggle
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 35)
    container.BackgroundColor3 = themes[self.theme].Primary
    container.LayoutOrder = #self.currentWindow.contentFrame:GetChildren() + 1
    container.Parent = self.currentWindow.contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = container
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = themes[self.theme].Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = container
    
    -- Botão do toggle
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(1, -65, 0.5, -12.5)
    toggleButton.BackgroundColor3 = toggle.value and themes[self.theme].Success or themes[self.theme].Secondary
    toggleButton.Text = ""
    toggleButton.Parent = container
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleButton
    
    -- Bolinha do toggle
    local toggleDot = Instance.new("Frame")
    toggleDot.Size = UDim2.new(0, 19, 0, 19)
    toggleDot.Position = toggle.value and UDim2.new(1, -21, 0.5, -9.5) or UDim2.new(0, 2, 0.5, -9.5)
    toggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleDot.Parent = toggleButton
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(0, 9)
    dotCorner.Parent = toggleDot
    
    -- Evento de clique
    toggleButton.MouseButton1Click:Connect(function()
        toggle.value = not toggle.value
        
        -- Animar toggle
        if toggle.value then
            safeTween(toggleButton, {BackgroundColor3 = themes[self.theme].Success}, 0.2)
            safeTween(toggleDot, {Position = UDim2.new(1, -21, 0.5, -9.5)}, 0.2)
        else
            safeTween(toggleButton, {BackgroundColor3 = themes[self.theme].Secondary}, 0.2)
            safeTween(toggleDot, {Position = UDim2.new(0, 2, 0.5, -9.5)}, 0.2)
        end
        
        -- Salvar configuração
        self:setSetting(name, toggle.value)
        
        -- Chamar callback
        if callback then
            callback(toggle.value)
        end
    end)
    
    return toggle
end

-- Botão estilo Inventory
function SpeedUI:Button(name, callback, icon)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = themes[self.theme].Primary
    button.Text = (icon and (icon .. "  ") or "") .. name
    button.TextColor3 = themes[self.theme].Text
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.LayoutOrder = #self.currentWindow.contentFrame:GetChildren() + 1
    button.Parent = self.currentWindow.contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 15)
    padding.Parent = button
    
    -- Efeitos hover
    button.MouseEnter:Connect(function()
        safeTween(button, {BackgroundColor3 = themes[self.theme].Accent}, 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        safeTween(button, {BackgroundColor3 = themes[self.theme].Primary}, 0.2)
    end)
    
    -- Evento de clique
    button.MouseButton1Click:Connect(function()
        -- Efeito de clique
        safeTween(button, {BackgroundColor3 = themes[self.theme].Secondary}, 0.1)
        wait(0.1)
        safeTween(button, {BackgroundColor3 = themes[self.theme].Primary}, 0.1)
        
        if callback then
            callback()
        end
    end)
    
    return button
end

-- Dropdown múltiplo estilo Inventory
function SpeedUI:MultiDropdown(name, options, defaults, callback)
    local dropdown = {
        values = defaults or {},
        isOpen = false,
        callback = callback
    }
    
    -- Container principal
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundColor3 = themes[self.theme].Primary
    container.ClipsDescendants = true
    container.LayoutOrder = #self.currentWindow.contentFrame:GetChildren() + 1
    container.Parent = self.currentWindow.contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = container
    
    -- Botão do dropdown
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(1, 0, 0, 40)
    dropdownButton.BackgroundTransparency = 1
    dropdownButton.Text = name .. " (" .. #dropdown.values .. " selecionados)"
    dropdownButton.TextColor3 = themes[self.theme].Text
    dropdownButton.TextSize = 14
    dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.Parent = container
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 15)
    padding.Parent = dropdownButton
    
    -- Seta do dropdown
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 0, 20)
    arrow.Position = UDim2.new(1, -30, 0.5, -10)
    arrow.BackgroundTransparency = 1
    arrow.Text = icons.ArrowDown
    arrow.TextColor3 = themes[self.theme].TextSecondary
    arrow.TextSize = 12
    arrow.Parent = container
    
    -- Container de opções
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Size = UDim2.new(1, 0, 0, 0)
    optionsContainer.Position = UDim2.new(0, 0, 0, 40)
    optionsContainer.BackgroundColor3 = themes[self.theme].Secondary
    optionsContainer.Parent = container
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = optionsContainer
    
    -- Criar opções
    for i, option in ipairs(options) do
        local optionFrame = Instance.new("Frame")
        optionFrame.Size = UDim2.new(1, 0, 0, 35)
        optionFrame.BackgroundTransparency = 1
        optionFrame.Parent = optionsContainer
        
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 1, 0)
        optionButton.BackgroundTransparency = 1
        optionButton.Text = "  " .. option
        optionButton.TextColor3 = themes[self.theme].Text
        optionButton.TextSize = 13
        optionButton.TextXAlignment = Enum.TextXAlignment.Left
        optionButton.Font = Enum.Font.Gotham
        optionButton.Parent = optionFrame
        
        local checkIcon = Instance.new("TextLabel")
        checkIcon.Size = UDim2.new(0, 20, 0, 20)
        checkIcon.Position = UDim2.new(1, -25, 0.5, -10)
        checkIcon.BackgroundTransparency = 1
        checkIcon.Text = dropdown.values[option] and icons.Check or ""
        checkIcon.TextColor3 = themes[self.theme].Success
        checkIcon.TextSize = 14
        checkIcon.Font = Enum.Font.GothamBold
        checkIcon.Parent = optionFrame
        
        optionButton.MouseButton1Click:Connect(function()
            dropdown.values[option] = not dropdown.values[option]
            checkIcon.Text = dropdown.values[option] and icons.Check or ""
            
            -- Atualizar texto do botão
            local selectedCount = 0
            for k, v in pairs(dropdown.values) do
                if v then selectedCount = selectedCount + 1 end
            end
            dropdownButton.Text = name .. " (" .. selectedCount .. " selecionados)"
            
            -- Salvar configuração
            self:setSetting(name, dropdown.values)
            
            -- Chamar callback
            if callback then
                callback(dropdown.values)
            end
        end)
    end
    
    -- Evento de abrir/fechar dropdown
    dropdownButton.MouseButton1Click:Connect(function()
        dropdown.isOpen = not dropdown.isOpen
        
        if dropdown.isOpen then
            local optionCount = #options
            local optionsHeight = optionCount * 35
            
            safeTween(optionsContainer, {Size = UDim2.new(1, 0, 0, optionsHeight)}, 0.2)
            safeTween(container, {Size = UDim2.new(1, 0, 0, 40 + optionsHeight)}, 0.2)
            safeTween(arrow, {Rotation = 180}, 0.2)
        else
            safeTween(optionsContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
            safeTween(container, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
            safeTween(arrow, {Rotation = 0}, 0.2)
        end
    end)
    
    return dropdown
end

-- Slider
function SpeedUI:Slider(name, min, max, default, callback)
    local slider = {
        value = self:getSetting(name, default or min),
        callback = callback
    }
    
    -- Container do slider
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 60)
    container.BackgroundColor3 = themes[self.theme].Primary
    container.LayoutOrder = #self.currentWindow.contentFrame:GetChildren() + 1
    container.Parent = self.currentWindow.contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = container
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -30, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. slider.value
    label.TextColor3 = themes[self.theme].Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = container
    
    -- Barra do slider
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -30, 0, 6)
    track.Position = UDim2.new(0, 15, 1, -20)
    track.BackgroundColor3 = themes[self.theme].Secondary
    track.Parent = container
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = track
    
    -- Fill do slider
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((slider.value - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = themes[self.theme].Accent
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill
    
    -- Handle do slider
    local handle = Instance.new("TextButton")
    handle.Size = UDim2.new(0, 16, 0, 16)
    handle.Position = UDim2.new((slider.value - min) / (max - min), -8, 0.5, -8)
    handle.BackgroundColor3 = themes[self.theme].Text
    handle.Text = ""
    handle.Parent = track
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 8)
    handleCorner.Parent = handle
    
    -- Função para atualizar slider
    local function updateSlider(value)
        value = math.clamp(value, min, max)
        slider.value = math.floor(value)
        
        label.Text = name .. ": " .. slider.value
        fill.Size = UDim2.new((slider.value - min) / (max - min), 0, 1, 0)
        handle.Position = UDim2.new((slider.value - min) / (max - min), -8, 0.5, -8)
        
        -- Salvar configuração
        self:setSetting(name, slider.value)
        
        -- Chamar callback
        if callback then
            callback(slider.value)
        end
    end
    
    -- Eventos do slider
    local isDragging = false
    
    handle.MouseButton1Down:Connect(function()
        isDragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local trackAbsolutePos = track.AbsolutePosition
            local trackAbsoluteSize = track.AbsoluteSize
            
            local relativeX = (mousePos.X - trackAbsolutePos.X) / trackAbsoluteSize.X
            relativeX = math.clamp(relativeX, 0, 1)
            
            local value = min + (relativeX * (max - min))
            updateSlider(value)
        end
    end)
    
    return slider
end

-- TextBox
function SpeedUI:TextBox(placeholder, default, callback)
    local textbox = {
        value = default or "",
        callback = callback
    }
    
    -- Container do textbox
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundColor3 = themes[self.theme].Primary
    container.LayoutOrder = #self.currentWindow.contentFrame:GetChildren() + 1
    container.Parent = self.currentWindow.contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = container
    
    -- Caixa de texto
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -30, 1, 0)
    textBox.Position = UDim2.new(0, 15, 0, 0)
    textBox.BackgroundTransparency = 1
    textBox.Text = default or ""
    textBox.PlaceholderText = placeholder
    textBox.TextColor3 = themes[self.theme].Text
    textBox.PlaceholderColor3 = themes[self.theme].TextMuted
    textBox.TextSize = 14
    textBox.Font = Enum.Font.Gotham
    textBox.Parent = container
    
    textBox.FocusLost:Connect(function(enterPressed)
        textbox.value = textBox.Text
        if callback then
            callback(textBox.Text, enterPressed)
        end
    end)
    
    return textbox
end

-- Label/Paragraph
function SpeedUI:Label(text, isParagraph)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -30, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = isParagraph and themes[self.theme].TextSecondary or themes[self.theme].Text
    label.TextSize = isParagraph and 13 or 14
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = isParagraph and Enum.Font.Gotham or Enum.Font.GothamMedium
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.LayoutOrder = #self.currentWindow.contentFrame:GetChildren() + 1
    label.Parent = self.currentWindow.contentFrame
    
    return label
end

-- Paragraph (alias para Label com isParagraph = true)
function SpeedUI:Paragraph(text)
    return self:Label(text, true)
end

-- Separador
function SpeedUI:Separator()
    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(1, -30, 0, 1)
    separator.Position = UDim2.new(0, 15, 0, 0)
    separator.BackgroundColor3 = themes[self.theme].Border
    separator.BorderSizePixel = 0
    separator.LayoutOrder = #self.currentWindow.contentFrame:GetChildren() + 1
    separator.Parent = self.currentWindow.contentFrame
    
    return separator
end

-- Função para mostrar/ocultar a UI com animação
function SpeedUI:ToggleUI()
    self.isOpen = not self.isOpen
    
    if self.isOpen then
        self.mainGui.Enabled = true
        safeTween(self.mainFrame, {Size = isMobile and UDim2.new(1, -20, 1, -20) or self.defaultSize}, 0.3)
    else
        safeTween(self.mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        wait(0.3)
        self.mainGui.Enabled = false
    end
end

-- Função para destruir a UI
function SpeedUI:Destroy()
    if self.mainGui then
        self.mainGui:Destroy()
    end
end

return SpeedUI
