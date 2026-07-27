--[[
    DRACO - Script Completo
    Criador: draco goat
]]

-- =====================
-- SYSTEM KEY (KEEF)
-- =====================

local _TweenService = game:GetService("TweenService")
local _HttpService  = game:GetService("HttpService")
local _Players      = game:GetService("Players")
local _LocalPlayer  = _Players.LocalPlayer
if not _LocalPlayer then
    _Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    _LocalPlayer = _Players.LocalPlayer
end

local function getGuiParent()
    if typeof(gethui) == "function" then return gethui() end
    local ok, cg = pcall(game.GetService, game, "CoreGui")
    if ok and cg then return cg end
    return _LocalPlayer:WaitForChild("PlayerGui", 10) or _LocalPlayer.PlayerGui
end

local authGui = Instance.new("ScreenGui")
authGui.Name = "DRACOAuth"; authGui.ResetOnSpawn = false
authGui.IgnoreGuiInset = true; authGui.DisplayOrder = 9999
authGui.Parent = getGuiParent()

local overlay = Instance.new("Frame", authGui)
overlay.Size = UDim2.fromScale(1,1); overlay.BackgroundColor3 = Color3.fromRGB(10,10,15)
overlay.BackgroundTransparency = 0.2; overlay.BorderSizePixel = 0; overlay.ZIndex = 10

local card = Instance.new("Frame", overlay)
card.AnchorPoint = Vector2.new(0.5,0.5); card.Position = UDim2.fromScale(0.5,0.5)
card.Size = UDim2.fromOffset(420,220); card.BackgroundColor3 = Color3.fromRGB(18,18,25)
card.BorderSizePixel = 0; card.ZIndex = 11
Instance.new("UICorner", card).CornerRadius = UDim.new(0,12)
local cStroke = Instance.new("UIStroke", card)
cStroke.Color = Color3.fromRGB(138,43,226); cStroke.Thickness = 2

local kTitle = Instance.new("TextLabel", card)
kTitle.Size = UDim2.new(1,0,0,40); kTitle.Position = UDim2.fromOffset(0,14)
kTitle.BackgroundTransparency = 1; kTitle.Text = "DRACO"
kTitle.TextColor3 = Color3.fromRGB(138,43,226); kTitle.TextSize = 22
kTitle.Font = Enum.Font.GothamBold; kTitle.TextXAlignment = Enum.TextXAlignment.Center; kTitle.ZIndex = 12

local kSub = Instance.new("TextLabel", card)
kSub.Size = UDim2.new(1,0,0,20); kSub.Position = UDim2.fromOffset(0,52)
kSub.BackgroundTransparency = 1; kSub.Text = "Digite sua key de acesso"
kSub.TextColor3 = Color3.fromRGB(180,180,200); kSub.TextSize = 13
kSub.Font = Enum.Font.Gotham; kSub.TextXAlignment = Enum.TextXAlignment.Center; kSub.ZIndex = 12

local kInputFrame = Instance.new("Frame", card)
kInputFrame.Size = UDim2.new(1,-40,0,40); kInputFrame.Position = UDim2.fromOffset(20,82)
kInputFrame.BackgroundColor3 = Color3.fromRGB(30,30,42); kInputFrame.BorderSizePixel = 0; kInputFrame.ZIndex = 12
Instance.new("UICorner", kInputFrame).CornerRadius = UDim.new(0,8)
Instance.new("UIStroke", kInputFrame).Color = Color3.fromRGB(80,80,110)

local kBox = Instance.new("TextBox", kInputFrame)
kBox.Size = UDim2.new(1,-20,1,0); kBox.Position = UDim2.fromOffset(10,0)
kBox.BackgroundTransparency = 1; kBox.PlaceholderText = "XXXXX-XXXXX-XXXXX-XXXXX"
kBox.PlaceholderColor3 = Color3.fromRGB(100,100,130); kBox.Text = ""
kBox.TextColor3 = Color3.fromRGB(240,240,255); kBox.TextSize = 14
kBox.Font = Enum.Font.Code; kBox.ClearTextOnFocus = false; kBox.ZIndex = 13

local kBtn = Instance.new("TextButton", card)
kBtn.Size = UDim2.new(1,-40,0,38); kBtn.Position = UDim2.fromOffset(20,134)
kBtn.BackgroundColor3 = Color3.fromRGB(138,43,226); kBtn.BorderSizePixel = 0
kBtn.Text = "Confirmar"; kBtn.TextColor3 = Color3.new(1,1,1)
kBtn.TextSize = 15; kBtn.Font = Enum.Font.GothamBold; kBtn.ZIndex = 12; kBtn.AutoButtonColor = false
Instance.new("UICorner", kBtn).CornerRadius = UDim.new(0,8)

local kStatus = Instance.new("TextLabel", card)
kStatus.Size = UDim2.new(1,0,0,20); kStatus.Position = UDim2.fromOffset(0,178)
kStatus.BackgroundTransparency = 1; kStatus.Text = ""
kStatus.TextColor3 = Color3.fromRGB(255,80,80); kStatus.TextSize = 12
kStatus.Font = Enum.Font.Gotham; kStatus.TextXAlignment = Enum.TextXAlignment.Center; kStatus.ZIndex = 12

kBtn.MouseEnter:Connect(function() _TweenService:Create(kBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(160,60,255)}):Play() end)
kBtn.MouseLeave:Connect(function() _TweenService:Create(kBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(138,43,226)}):Play() end)

local userKey, keyConfirmed = "", false
local function tryConfirm()
    local t = kBox.Text:gsub("%s","")
    if t == "" then kStatus.Text="Insira uma key."; kStatus.TextColor3=Color3.fromRGB(255,200,50); return end
    userKey = t; keyConfirmed = true
end
kBtn.MouseButton1Click:Connect(tryConfirm)
kBox.FocusLost:Connect(function(enter) if enter then tryConfirm() end end)
repeat task.wait(0.05) until keyConfirmed
kStatus.Text="Validando key..."; kStatus.TextColor3=Color3.fromRGB(180,180,200)
kBtn.Active=false; task.wait(0.1)

local _body = _HttpService:JSONEncode({key=userKey, hwid=tostring(_LocalPlayer.UserId)})
local _opts = {Url="https://authkeef.discloud.app/api/validate", Method="POST", Headers={["Content-Type"]="application/json"}, Body=_body}
local _response = nil
for _, fn in ipairs({
    function() return request(_opts) end,
    function() return http_request(_opts) end,
    function() return (syn and syn.request)(_opts) end,
    function() return (http and http.request)(_opts) end,
    function() return _HttpService:RequestAsync(_opts) end,
}) do
    local ok, res = pcall(fn)
    if ok and res and (res.Body or res.body) then _response = res; break end
end

local _authOk, _authMsg = false, "Erro de conexao. Tente novamente."
if _response then
    local ok2, data = pcall(_HttpService.JSONDecode, _HttpService, _response.Body or _response.body or "")
    if ok2 and data then
        if data.success == true then _authOk=true; _authMsg=""
        else _authMsg = data.message or "Key invalida ou expirada!" end
    end
end

if not _authOk then
    kStatus.Text=_authMsg; kStatus.TextColor3=Color3.fromRGB(255,60,60)
    task.wait(3); authGui:Destroy(); error("[DRACO] ".._authMsg)
end
authGui:Destroy()
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{Title="DRACO",Text="Autenticado!",Duration=3})
end)

local Env = getfenv()
local _ = {}

-- =====================
-- CONFIGURAÇÕES GLOBAIS
-- =====================

local G = {
    Enabled = false,
    HitboxEnabled = false,
    HitboxSize = 1,
    HitboxTransparency = 0.3,
    HitboxKey = "H",
    HitboxTouch = false,
    CameraJump = false,
    FreezeAir = false,
    FreezeAirKey = Enum.KeyCode.F,
    FreezeTouch = false,
    LeedFeat = false,
    LeedFeatKey = Enum.KeyCode.G,
    LeedFeatTouch = false,
    AutoLong = false,
    AutoLongKey = Enum.KeyCode.L,
    AutoLongAngle = 15,
    AutoLongDir = "DIREITA",
    AutoLongTouch = false,
    RainbowTag = false,
    CustomTagName = "",
    ESPEnabled = false,
    ESPLineSize = 10,
    AutoSpinStyle = false,
    AutoSpinHabi = false,
    AutoYen = false,
    InterfaceMode = "PC",
    JerseyEnabled = false,
    JerseyAtomicEnabled = false,
    JerseyDragaoEnabled = false,
    JerseyDragaoTeam = "PRETA",
    JerseyAtomicTeam = "PRETA",
    JerseyPijamaEnabled = false,
    JerseyPijamaTeam = "PRETO",
    ESPNeon = false,
    ThemeColor = Color3.fromRGB(138, 43, 226),
    FPSBoost = false,
    NightMode = false,
    GrayFloor = false,
    NoShadows = false,
    CrosshairEnabled = false,
    CrosshairStyle = "CRUZ",
    CrosshairY = 50,
}

-- =====================
-- SERVIÇOS
-- =====================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- =====================
-- ANTI-DETECÇÃO
-- =====================

(function()
    if getfenv then
        local env = getfenv()
        env.script = nil
        env.getfenv = function() return env end
    end
    
    if hookfunction then
        local original = game.IsDescendantOf
        hookfunction(game.IsDescendantOf, function(instance, parent)
            if instance == script and parent == script:GetService("Workspace") then
                return false
            end
            return original(instance, parent)
        end)
    end
    
    if rconsoleprint then
        hookfunction(rconsoleprint, function() end)
    end
    
    local original_print = print
    print = function(...)
        local args = {...}
        for i, v in ipairs(args) do
            if type(v) == "string" and v:match("script") then
                args[i] = "[REDACTED]"
            end
        end
        return original_print(table.unpack(args))
    end
end)()

-- =====================
-- SALVAR/CARREGAR CONFIG
-- =====================

local CONFIG_FILES = {
    "ZYNEXConfig_V2.json",
    "ZYNEXConfig.json",
}

local function color_to_table(color)
    return {r = color.R, g = color.G, b = color.B}
end

local function table_to_color(tbl)
    if type(tbl) == "table" and tbl.r and tbl.g and tbl.b then
        return Color3.new(tbl.r, tbl.g, tbl.b)
    end
    return Color3.fromRGB(138, 43, 226)
end

local function enum_to_string(enum_item)
    if typeof(enum_item) == "EnumItem" then
        return enum_item.Name
    end
    return tostring(enum_item)
end

local function parse_bool(value, default)
    if value == nil then return default == true end
    return value == true
end

local function parse_number(value, default)
    local num = tonumber(value)
    if num == nil then return default end
    return num
end

local function parse_interface_mode(mode)
    if isMobile then
        return "ANTIGA"
    end
    if mode == "PC" or mode == "ANTIGA" then
        return mode
    end
    return "PC"
end

function save_config()
    if not writefile then
        warn("[ZYNEX] writefile não existe")
        return false
    end
    
    local data = {
        Version = 5,
        HitboxEnabled = G.HitboxEnabled,
        HitboxSize = G.HitboxSize,
        HitboxTransparency = G.HitboxTransparency,
        HitboxKey = tostring(G.HitboxKey or "H"),
        HitboxTouch = G.HitboxTouch,
        FreezeAir = G.FreezeAir,
        FreezeAirKey = enum_to_string(G.FreezeAirKey),
        FreezeTouch = G.FreezeTouch,
        LeedFeat = G.LeedFeat,
        LeedFeatKey = enum_to_string(G.LeedFeatKey),
        LeedFeatTouch = G.LeedFeatTouch,
        CameraJump = G.CameraJump,
        ESPEnabled = G.ESPEnabled,
        ESPLineSize = G.ESPLineSize,
        ESPNeon = G.ESPNeon,
        AutoSpinStyle = G.AutoSpinStyle,
        AutoSpinHabi = G.AutoSpinHabi,
        AutoYen = G.AutoYen,
        JerseyEnabled = G.JerseyEnabled,
        JerseyAtomicEnabled = G.JerseyAtomicEnabled,
        JerseyAtomicTeam = tostring(G.JerseyAtomicTeam or "PRETA"),
        JerseyDragaoEnabled = G.JerseyDragaoEnabled,
        JerseyDragaoTeam = tostring(G.JerseyDragaoTeam or "PRETA"),
        JerseyPijamaEnabled = G.JerseyPijamaEnabled,
        JerseyPijamaTeam = tostring(G.JerseyPijamaTeam or "PRETO"),
        FPSBoost = G.FPSBoost,
        NightMode = G.NightMode,
        GrayFloor = G.GrayFloor,
        NoShadows = G.NoShadows,
        CrosshairEnabled = G.CrosshairEnabled,
        CrosshairStyle = tostring(G.CrosshairStyle or "CRUZ"),
        CrosshairY = G.CrosshairY,
        AutoLong = G.AutoLong,
        AutoLongKey = enum_to_string(G.AutoLongKey),
        AutoLongAngle = G.AutoLongAngle,
        AutoLongDir = tostring(G.AutoLongDir or "DIREITA"),
        AutoLongTouch = G.AutoLongTouch,
        RainbowTag = false,
        CustomTagName = "",
        InterfaceMode = parse_interface_mode(G.InterfaceMode),
        ThemeColor = color_to_table(G.ThemeColor)
    }
    
    local json_success, json_string = pcall(function()
        return HttpService:JSONEncode(data)
    end)
    
    if not json_success or not json_string then
        warn("[ZYNEX] Erro ao gerar JSON")
        return false
    end
    
    for _, filename in ipairs(CONFIG_FILES) do
        if filename and filename ~= "" then
            pcall(function()
                writefile(filename, json_string)
            end)
        end
    end
    return true
end

function load_config()
    if not isfile or not readfile then
        warn("[ZYNEX] isfile/readfile não existe")
        return nil
    end
    
    for _, filename in ipairs(CONFIG_FILES) do
        if filename and filename ~= "" then
            local success, content = pcall(function()
                return readfile(filename)
            end)
            
            if success and type(content) == "string" and content ~= "" then
                local json_success, data = pcall(function()
                    return HttpService:JSONDecode(content)
                end)
                
                if json_success and type(data) == "table" then
                    return data, filename
                end
            end
        end
    end
    return nil
end

function apply_config(data)
    if type(data) ~= "table" then return false end
    
    if data.ThemeColor then G.ThemeColor = table_to_color(data.ThemeColor) end
    
    G.HitboxEnabled = parse_bool(data.HitboxEnabled, G.HitboxEnabled)
    G.HitboxSize = parse_number(data.HitboxSize, G.HitboxSize)
    G.HitboxTransparency = parse_number(data.HitboxTransparency, G.HitboxTransparency)
    if data.HitboxKey ~= nil then G.HitboxKey = tostring(data.HitboxKey) end
    G.HitboxTouch = parse_bool(data.HitboxTouch, G.HitboxTouch)
    
    G.FreezeAir = parse_bool(data.FreezeAir, G.FreezeAir)
    if data.FreezeAirKey ~= nil then
        G.FreezeAirKey = Enum.KeyCode[tostring(data.FreezeAirKey)] or Enum.KeyCode.F
    end
    G.FreezeTouch = parse_bool(data.FreezeTouch, G.FreezeTouch)
    
    G.LeedFeat = parse_bool(data.LeedFeat, G.LeedFeat)
    if data.LeedFeatKey ~= nil then
        G.LeedFeatKey = Enum.KeyCode[tostring(data.LeedFeatKey)] or Enum.KeyCode.G
    end
    G.LeedFeatTouch = parse_bool(data.LeedFeatTouch, G.LeedFeatTouch)
    
    G.CameraJump = parse_bool(data.CameraJump, G.CameraJump)
    G.ESPEnabled = parse_bool(data.ESPEnabled, G.ESPEnabled)
    G.ESPLineSize = parse_number(data.ESPLineSize, G.ESPLineSize)
    G.ESPNeon = parse_bool(data.ESPNeon, G.ESPNeon)
    G.AutoSpinStyle = parse_bool(data.AutoSpinStyle, G.AutoSpinStyle)
    G.AutoSpinHabi = parse_bool(data.AutoSpinHabi, G.AutoSpinHabi)
    G.AutoYen = parse_bool(data.AutoYen, G.AutoYen)
    
    G.JerseyEnabled = parse_bool(data.JerseyEnabled, G.JerseyEnabled)
    G.JerseyAtomicEnabled = parse_bool(data.JerseyAtomicEnabled, G.JerseyAtomicEnabled)
    if data.JerseyAtomicTeam ~= nil then
        local team = tostring(data.JerseyAtomicTeam)
        if team == "PRETA" or team == "LARANJA" or team == "ROXO" or team == "VERMELHO" or team == "BRANCO" then
            G.JerseyAtomicTeam = team
        end
    end
    
    G.JerseyDragaoEnabled = parse_bool(data.JerseyDragaoEnabled, G.JerseyDragaoEnabled)
    if data.JerseyDragaoTeam ~= nil then
        local team = tostring(data.JerseyDragaoTeam)
        if team == "PRETA" or team == "LARANJA" or team == "ROXO" or team == "VERMELHO" or team == "BRANCO" then
            G.JerseyDragaoTeam = team
        end
    end
    
    G.JerseyPijamaEnabled = parse_bool(data.JerseyPijamaEnabled, G.JerseyPijamaEnabled)
    if data.JerseyPijamaTeam ~= nil then
        local team = tostring(data.JerseyPijamaTeam)
        if team == "PRETA" then team = "PRETO" end
        if team == "PRETO" or team == "ORANGE" or team == "ROXO" or team == "VERMELHO" or team == "BRANCO" then
            G.JerseyPijamaTeam = team
        end
    end
    
    G.FPSBoost = parse_bool(data.FPSBoost, G.FPSBoost)
    G.NightMode = parse_bool(data.NightMode, G.NightMode)
    G.GrayFloor = parse_bool(data.GrayFloor, G.GrayFloor)
    G.NoShadows = parse_bool(data.NoShadows, G.NoShadows)
    
    G.CrosshairEnabled = parse_bool(data.CrosshairEnabled, G.CrosshairEnabled)
    if data.CrosshairStyle ~= nil then
        local style = tostring(data.CrosshairStyle)
        if style == "CRUZ" or style == "PONTO" or style == "CIRCULO" or style == "X" then
            G.CrosshairStyle = style
        end
    end
    G.CrosshairY = math.clamp(parse_number(data.CrosshairY, G.CrosshairY), 0, 50)
    
    G.AutoLong = parse_bool(data.AutoLong, G.AutoLong)
    if data.AutoLongKey ~= nil then
        G.AutoLongKey = Enum.KeyCode[tostring(data.AutoLongKey)] or Enum.KeyCode.L
    end
    G.AutoLongAngle = parse_number(data.AutoLongAngle, G.AutoLongAngle)
    if data.AutoLongDir ~= nil then G.AutoLongDir = tostring(data.AutoLongDir) end
    G.AutoLongTouch = parse_bool(data.AutoLongTouch, G.AutoLongTouch)
    
    G.RainbowTag = false
    G.CustomTagName = ""
    G.InterfaceMode = parse_interface_mode(data.InterfaceMode)
    
    return true
end

-- =====================
-- JERSEY SYSTEM
-- =====================

local original_clothes = {}
local jersey_connection = nil
local saved_parts = {}
local saved_effects = {}

local function is_floor_part(part)
    if not part:IsA("BasePart") then return false end
    local name = part.Name:lower()
    return part.Anchored and (name:find("floor") or name:find("ground") or name:find("baseplate") or name:find("chao") or name:find("chão"))
end

function apply_jersey()
    local character = LocalPlayer.Character
    if not character then return end
    
    pcall(function()
        local assets = ReplicatedStorage:WaitForChild("Assets")
        local jersey = assets:WaitForChild("Jersey")
        local tuxedo = jersey:WaitForChild("TuxedoJersey")
        local white_team = tuxedo:WaitForChild("White Team")
        
        local pajamas = jersey:WaitForChild("PajamasJersey")
        local white_pajamas = pajamas:WaitForChild("White Team")
        local pants_template = white_pajamas:WaitForChild("Pants").PantsTemplate
        
        local shirt = character:FindFirstChildOfClass("Shirt")
        local pants = character:FindFirstChildOfClass("Pants")
        
        if not original_clothes.shirt then
            original_clothes.shirt = shirt and shirt.ShirtTemplate or ""
        end
        if not original_clothes.pants then
            original_clothes.pants = pants and pants.PantsTemplate or ""
        end
        
        if shirt then
            shirt.ShirtTemplate = white_team:WaitForChild("Shirt").ShirtTemplate
            if pants then
                pants.PantsTemplate = pants_template
            else
                Instance.new("Pants", character)
            end
        else
            Instance.new("Shirt", character)
        end
    end)
end

function apply_visual_effects()
    local original_lighting = {
        ClockTime = Lighting.ClockTime,
        Brightness = Lighting.Brightness,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        FogEnd = Lighting.FogEnd
    }
    
    if G.NightMode then
        Lighting.ClockTime = 0
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(45, 45, 60)
        Lighting.OutdoorAmbient = Color3.fromRGB(30, 30, 45)
    else
        Lighting.ClockTime = original_lighting.ClockTime
        Lighting.Brightness = original_lighting.Brightness
        Lighting.Ambient = original_lighting.Ambient
        Lighting.OutdoorAmbient = original_lighting.OutdoorAmbient
    end
    
    Lighting.GlobalShadows = not (G.NoShadows or G.FPSBoost)
    Lighting.FogEnd = G.FPSBoost and 100000 or original_lighting.FogEnd
    
    if G.GrayFloor then
        for _, part in ipairs(Workspace:GetDescendants()) do
            if is_floor_part(part) then
                if not saved_parts[part] then
                    saved_parts[part] = {Color = part.Color, Material = part.Material}
                end
                part.Color = Color3.fromRGB(95, 95, 95)
                part.Material = Enum.Material.SmoothPlastic
            end
        end
    else
        for part, data in pairs(saved_parts) do
            if part and part.Parent then
                part.Color = data.Color
                part.Material = data.Material
            end
        end
        saved_parts = {}
    end
    
    if G.FPSBoost then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                if saved_effects[obj] == nil then
                    saved_effects[obj] = obj.Enabled
                end
                obj.Enabled = false
            end
        end
    else
        for obj, enabled in pairs(saved_effects) do
            if obj and obj.Parent then
                obj.Enabled = enabled
            end
        end
        saved_effects = {}
    end
end

function restore_original_clothes()
    if jersey_connection then
        jersey_connection:Disconnect()
        jersey_connection = nil
    end
    
    local character = LocalPlayer.Character
    if character then
        local shirt = character:FindFirstChildOfClass("Shirt")
        local pants = character:FindFirstChildOfClass("Pants")
        
        if shirt then
            if original_clothes.shirt and original_clothes.shirt ~= "" then
                shirt.ShirtTemplate = original_clothes.shirt
            else
                shirt:Destroy()
            end
        end
        
        if pants then
            if original_clothes.pants and original_clothes.pants ~= "" then
                pants.PantsTemplate = original_clothes.pants
            else
                pants:Destroy()
            end
        end
    end
end

function apply_tuxedo_jersey()
    restore_original_clothes()
    if not G.JerseyEnabled then return end
    
    G.JerseyAtomicEnabled = false
    G.JerseyDragaoEnabled = false
    G.JerseyPijamaEnabled = false
    
    apply_jersey()
    
    jersey_connection = RunService.Heartbeat:Connect(function()
        if not G.JerseyEnabled then
            restore_original_clothes()
            return
        end
        apply_jersey()
    end)
end

-- =====================
-- JERSEY ATOMIC
-- =====================

local JERSEY_ATOMIC_COLORS = {
    PRETA = {Shirt = "rbxassetid://1234567890", Short = "rbxassetid://1234567890"},
    LARANJA = {Shirt = "rbxassetid://1234567890", Short = "rbxassetid://1234567890"},
    ROXO = {Shirt = "rbxassetid://1234567890", Short = "rbxassetid://1234567890"},
    VERMELHO = {Shirt = "rbxassetid://1234567890", Short = "rbxassetid://1234567890"},
    BRANCO = {Shirt = "rbxassetid://1234567890", Short = "rbxassetid://1234567890"}
}

function get_atomic_jersey(team)
    return JERSEY_ATOMIC_COLORS[tostring(team)] or JERSEY_ATOMIC_COLORS.PRETA
end

local atomic_connection = nil

function apply_atomic_jersey()
    if atomic_connection then
        atomic_connection:Disconnect()
        atomic_connection = nil
    end
    
    if not G.JerseyAtomicEnabled then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local data = get_atomic_jersey(G.JerseyAtomicTeam)
    local shirt_template, pants_template = data.Shirt, data.Short
    
    local shirt = character:FindFirstChildOfClass("Shirt")
    local pants = character:FindFirstChildOfClass("Pants")
    
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Shirt") and child ~= shirt then
            child:Destroy()
        elseif child:IsA("Pants") and child ~= pants then
            child:Destroy()
        elseif child:IsA("ShirtGraphic") then
            child:Destroy()
        end
    end
    
    if shirt then
        shirt.Name = "ZYNEXAtomicShirt"
        shirt.ShirtTemplate = shirt_template
        if not pants then
            pants = Instance.new("Pants")
            pants.Name = "ZYNEXAtomicShort"
            pants.Parent = character
        end
        pants.PantsTemplate = pants_template
    else
        local new_shirt = Instance.new("Shirt")
        new_shirt.Name = "ZYNEXAtomicShirt"
        new_shirt.Parent = character
        new_shirt.ShirtTemplate = shirt_template
        local new_pants = Instance.new("Pants")
        new_pants.Name = "ZYNEXAtomicShort"
        new_pants.Parent = character
        new_pants.PantsTemplate = pants_template
    end
    
    atomic_connection = RunService.Heartbeat:Connect(function()
        if not G.JerseyAtomicEnabled then
            restore_original_clothes()
            return
        end
    end)
    
    task.spawn(function()
        while G.JerseyAtomicEnabled do
            pcall(apply_atomic_jersey)
            task.wait(3)
        end
    end)
end

-- =====================
-- JERSEY DRAGÃO
-- =====================

local JERSEY_DRAGAO_COLORS = {
    PRETA = {Shirt = "rbxassetid://1234567890", Short = "rbxassetid://1234567890"},
    LARANJA = {Shirt = "rbxassetid://1234567890", Short = "rbxassetid://1234567890"},
    ROXO = {Shirt = "rbxassetid://1234567890", Short = "rbxassetid://1234567890"},
    VERMELHO = {Shirt = "rbxassetid://1234567890", Short = "rbxassetid://1234567890"},
    BRANCO = {Shirt = "rbxassetid://1234567890", Short = "rbxassetid://1234567890"}
}

function get_dragao_jersey(team)
    return JERSEY_DRAGAO_COLORS[tostring(team)] or JERSEY_DRAGAO_COLORS.PRETA
end

local dragao_connection = nil

function apply_dragao_jersey()
    local character = LocalPlayer.Character
    if not character then return end
    
    local data = get_dragao_jersey(G.JerseyDragaoTeam)
    local shirt_template, pants_template = data.Shirt, data.Short
    
    local shirt = character:FindFirstChildOfClass("Shirt")
    local pants = character:FindFirstChildOfClass("Pants")
    
    if shirt then
        shirt.ShirtTemplate = shirt_template
        if not pants then
            pants = Instance.new("Pants", character)
        end
        pants.PantsTemplate = pants_template
    else
        local new_shirt = Instance.new("Shirt", character)
        new_shirt.ShirtTemplate = shirt_template
    end
end

-- =====================
-- JERSEY PIJAMA
-- =====================

local JERSEY_PIJAMA_COLORS = {
    PRETO = {Shirt = "rbxassetid://1234567890", Short = "rbxassetid://1234567890"},
    ORANGE = {Shirt = "rbxassetid://1234567890", Short = "rbxassetid://1234567890"},
    ROXO = {Shirt = "rbxassetid://1234567890", Short = "rbxassetid://1234567890"},
    VERMELHO = {Shirt = "rbxassetid://1234567890", Short = "rbxassetid://1234567890"},
    BRANCO = {Shirt = "rbxassetid://1234567890", Short = "rbxassetid://1234567890"}
}

function get_pijama_jersey(team)
    local team_name = tostring(team)
    if team_name == "PRETA" then team_name = "PRETO" end
    return JERSEY_PIJAMA_COLORS[team_name] or JERSEY_PIJAMA_COLORS.PRETO
end

local pijama_connection = nil

function apply_pijama_jersey()
    local character = LocalPlayer.Character
    if not character then return end
    
    local data = get_pijama_jersey(G.JerseyPijamaTeam)
    local shirt_template, pants_template = data.Shirt, data.Short
    
    local shirt = character:FindFirstChildOfClass("Shirt")
    local pants = character:FindFirstChildOfClass("Pants")
    
    if shirt then
        shirt.ShirtTemplate = shirt_template
        if not pants then
            pants = Instance.new("Pants", character)
        end
        pants.PantsTemplate = pants_template
    else
        local new_shirt = Instance.new("Shirt", character)
        new_shirt.ShirtTemplate = shirt_template
    end
end

-- =====================
-- HITBOX SYSTEM
-- =====================

function clear_hitboxes()
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj.Name and obj.Name:match("^CLIENT_BALL_") then
            local ball = obj:FindFirstChild("Ball.001")
            if ball then
                ball:Destroy()
            end
        end
    end
end

function update_hitboxes()
    if G.HitboxEnabled then
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name and obj.Name:match("^CLIENT_BALL_") then
                local ball = obj:FindFirstChild("Ball.001")
                if not ball then
                    ball = Instance.new("Part")
                    ball.Name = "Ball.001"
                    ball.Parent = obj
                end
                ball.Shape = Enum.PartType.Ball
                ball.Anchored = true
                ball.CanCollide = false
                ball.Material = Enum.Material.ForceField
                ball.Transparency = G.HitboxTransparency
                ball.Size = Vector3.new(2, 2, 2) * G.HitboxSize
                ball.Color = G.ThemeColor
                ball.CFrame = obj.CFrame
            end
        end
    end
end

-- =====================
-- ESP SYSTEM
-- =====================

local esp_lines = {}

function update_esp()
    if G.ESPEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                
                if head and root then
                    if not esp_lines[player] or not esp_lines[player].Parent then
                        local line = Instance.new("Part")
                        line.Name = "ZYNEXESPLine"
                        line.Anchored = true
                        line.CanCollide = false
                        line.CanTouch = false
                        line.CastShadow = false
                        line.Material = Enum.Material.SmoothPlastic
                        line.Shape = Enum.PartType.Cylinder
                        line.Parent = Workspace
                        esp_lines[player] = line
                    end
                    
                    local line = esp_lines[player]
                    local look = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
                    local dir = look.Unit
                    local pos = root.Position + Vector3.new(0, 1.6, 0) + dir * 0.65
                    
                    line.Material = G.ESPNeon and Enum.Material.Neon or Enum.Material.SmoothPlastic
                    line.Color = G.ThemeColor
                    line.Size = Vector3.new(G.ESPLineSize, 0.35, 0.35)
                    line.CFrame = CFrame.lookAt(pos + dir * G.ESPLineSize / 2, pos + dir * G.ESPLineSize) * CFrame.Angles(0, math.rad(90), 0)
                end
            end
        end
    else
        for player, line in pairs(esp_lines) do
            if line then line:Destroy() end
            esp_lines[player] = nil
        end
    end
end

-- =====================
-- AUTO LONG SYSTEM
-- =====================

local is_auto_long_active = false
local auto_long_connection = nil

function start_auto_long()
    if not G.AutoLong then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local root_part = character:FindFirstChild("HumanoidRootPart")
    local lower_torso = character:FindFirstChild("LowerTorso")
    if not lower_torso then return end
    local root_joint = lower_torso:FindFirstChild("Root")
    
    if not root_part or not root_joint then return end
    
    if is_auto_long_active then return end
    is_auto_long_active = true
    
    local current_yaw = Camera.CFrame:ToEulerAnglesYXZ()
    local target_yaw = current_yaw + (G.AutoLongDir == "DIREITA" and -1 or 1) * math.rad(math.clamp(G.AutoLongAngle, 0, 30))
    local current_angle = current_yaw
    local original_c0 = root_joint.C0
    
    if auto_long_connection then
        auto_long_connection:Disconnect()
        auto_long_connection = nil
    end
    
    auto_long_connection = RunService.RenderStepped:Connect(function(delta)
        if not is_auto_long_active then
            if auto_long_connection then
                auto_long_connection:Disconnect()
                auto_long_connection = nil
            end
            return
        end
        
        current_angle = current_angle + (target_yaw - current_angle) * math.min(1, 7 * delta)
        
        local _, yaw, pitch = Camera.CFrame:ToEulerAnglesYXZ()
        Camera.CFrame = CFrame.new(Camera.CFrame.Position) * CFrame.fromEulerAnglesYXZ(yaw, current_angle, pitch)
        
        local look = Camera.CFrame.LookVector
        local dir = Vector3.new(-look.X, 0, -look.Z)
        if dir.Magnitude < 0.01 then return end
        dir = dir.Unit
        
        pcall(function()
            local forward = root_part.CFrame.LookVector
            local dot = forward:Dot(dir)
            if dot > 0 then dot = dot * 2 end
            
            local new_c0 = original_c0:Lerp(original_c0 * CFrame.Angles(math.rad(-dot * 25), 0, math.rad(-dot * 25)), math.min(1, delta * 15))
            root_joint.C0 = new_c0
        end)
    end)
end

function stop_auto_long()
    is_auto_long_active = false
    
    if auto_long_connection then
        auto_long_connection:Disconnect()
        auto_long_connection = nil
    end
    
    local character = LocalPlayer.Character
    if character then
        local lower_torso = character:FindFirstChild("LowerTorso")
        if lower_torso then
            local root_joint = lower_torso:FindFirstChild("Root")
            if root_joint then
                pcall(function()
                    root_joint.C0 = CFrame.new(root_joint.C0.Position) * CFrame.fromEulerAnglesYXZ(0, 0, 0)
                end)
            end
        end
    end
end

function toggle_auto_long()
    G.AutoLong = not G.AutoLong
    if not G.AutoLong then
        stop_auto_long()
    else
        start_auto_long()
    end
end

-- =====================
-- LEED FEAT SYSTEM
-- =====================

local leed_feat_active = false

function apply_leed_feat()
    if not G.LeedFeat then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end
    
    root.Anchored = false
    root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -260, root.AssemblyLinearVelocity.Z)
    
    if leed_feat_active then return end
    leed_feat_active = true
    
    task.spawn(function()
        local start_time = tick()
        while character.Parent and humanoid.FloorMaterial == Enum.Material.Air and tick() - start_time <= 2.5 do
            task.wait(0.03)
        end
        leed_feat_active = false
    end)
end

function create_leed_feat_effect(position)
    local part = Instance.new("Part")
    part.Name = "ZYNEXLeedFeatPurpleEffect"
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.CastShadow = false
    part.Shape = Enum.PartType.Cylinder
    part.Material = Enum.Material.Neon
    part.Color = Color3.fromRGB(170, 0, 255)
    part.Transparency = 0.15
    part.Size = Vector3.new(0.18, 0.25, 0.25)
    part.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
    part.Parent = Workspace
    
    local tween = TweenService:Create(part, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.18, 8, 8),
        Transparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function()
        part:Destroy()
    end)
end

-- =====================
-- CROSSHAIR SYSTEM
-- =====================

local crosshair_parts = {}
local crosshair_frame = nil
local crosshair_container = nil

function create_crosshair_part(name, position, size, rotation)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Position = position
    frame.Size = size
    frame.Rotation = rotation or 0
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = G.ThemeColor
    frame.BorderSizePixel = 0
    frame.ZIndex = 1001
    frame.Parent = crosshair_container
    Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
    return frame
end

function update_crosshair()
    if not crosshair_frame or not crosshair_container then return end
    
    crosshair_frame.Visible = G.CrosshairEnabled == true
    crosshair_frame.Position = UDim2.new(0.5, 0, math.clamp(tonumber(G.CrosshairY) or 50, 0, 50) / 100, 0)
    
    for _, child in ipairs(crosshair_container:GetChildren()) do
        child:Destroy()
    end
    
    if not G.CrosshairEnabled then return end
    
    local style = tostring(G.CrosshairStyle or "CRUZ")
    
    if style == "PONTO" then
        local dot = Instance.new("Frame")
        dot.Name = "Dot"
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Position = UDim2.new(0.5, 0, 0.5, 0)
        dot.Size = UDim2.new(0, 7, 0, 7)
        dot.BackgroundColor3 = G.ThemeColor
        dot.BorderSizePixel = 0
        dot.ZIndex = 1001
        dot.Parent = crosshair_container
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        
    elseif style == "CIRCULO" then
        local circle = Instance.new("Frame")
        circle.Name = "Circle"
        circle.AnchorPoint = Vector2.new(0.5, 0.5)
        circle.Position = UDim2.new(0.5, 0, 0.5, 0)
        circle.Size = UDim2.new(0, 28, 0, 28)
        circle.BackgroundTransparency = 1
        circle.BorderSizePixel = 0
        circle.ZIndex = 1001
        circle.Parent = crosshair_container
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = G.ThemeColor
        stroke.Thickness = 2
        stroke.Transparency = 0.05
        stroke.Parent = circle
        
        create_crosshair_part("CircleDot", UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0, 4, 0, 4), 0)
        
    elseif style == "X" then
        create_crosshair_part("X1", UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0, 34, 0, 3), 45)
        create_crosshair_part("X2", UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0, 34, 0, 3), -45)
        
    else -- CRUZ
        create_crosshair_part("Top", UDim2.new(0.5, 0, 0.18, 0), UDim2.new(0, 3, 0, 13), 0)
        create_crosshair_part("Bottom", UDim2.new(0.5, 0, 0.82, 0), UDim2.new(0, 3, 0, 13), 0)
        create_crosshair_part("Left", UDim2.new(0.18, 0, 0.5, 0), UDim2.new(0, 13, 0, 3), 0)
        create_crosshair_part("Right", UDim2.new(0.82, 0, 0.5, 0), UDim2.new(0, 13, 0, 3), 0)
        create_crosshair_part("Center", UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0, 4, 0, 4), 0)
    end
end

-- =====================
-- RAINBOW TAG SYSTEM
-- =====================

local rainbow_hue = 0
local rainbow_connection = nil

function find_name_tag(character)
    local targets = {"Head", "UpperTorso", "Torso"}
    for _, part_name in ipairs(targets) do
        local part = character:FindFirstChild(part_name)
        if part then
            for _, child in ipairs(part:GetChildren()) do
                if child:IsA("BillboardGui") then
                    for _, descendant in ipairs(child:GetDescendants()) do
                        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                            local name = descendant.Name:lower()
                            if name:find("name") or name:find("tag") or name:find("title") or name:find("text") then
                                return descendant
                            end
                        end
                    end
                    for _, descendant in ipairs(child:GetDescendants()) do
                        if descendant:IsA("TextLabel") then
                            return descendant
                        end
                    end
                end
            end
        end
    end
    return nil
end

function update_rainbow_tag()
    if rainbow_connection then
        rainbow_connection:Disconnect()
        rainbow_connection = nil
    end
    
    if not G.RainbowTag then return end
    
    rainbow_connection = RunService.RenderStepped:Connect(function()
        local character = LocalPlayer.Character
        if not character then return end
        
        local tag = find_name_tag(character)
        if not tag then return end
        
        local display_name = G.CustomTagName ~= "" and G.CustomTagName or LocalPlayer.DisplayName
        if tag.Text ~= display_name then
            tag.Text = display_name
        end
        
        rainbow_hue = (rainbow_hue + 0.5) % 360
        tag.TextColor3 = Color3.fromHSV(rainbow_hue / 360, 1, 1)
        tag.TextStrokeTransparency = 0.5
        tag.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        tag.RichText = false
    end)
end

-- =====================
-- FREEZE AIR SYSTEM
-- =====================

local is_frozen = false

function toggle_freeze()
    if not G.FreezeAir then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    is_frozen = not is_frozen
    root.Anchored = is_frozen
end

-- =====================
-- AUTO SPIN SYSTEM
-- =====================

-- Reivindica recompensas automáticas
task.spawn(function()
    while task.wait(0.5) do
        if G.AutoSpinStyle or G.AutoSpinHabi or G.AutoYen then
            pcall(function()
                local rewards = {}
                if G.AutoSpinStyle then table.insert(rewards, 1) end
                if G.AutoSpinHabi then table.insert(rewards, 4) end
                if G.AutoYen then table.insert(rewards, 2) end
                
                local packages = ReplicatedStorage:FindFirstChild("Packages")
                if packages then
                    local index = packages:FindFirstChild("_Index")
                    if index then
                        local knit = index:FindFirstChild("sleitnick_knit@1.7.0")
                        if knit then
                            local services = knit:FindFirstChild("knit"):FindFirstChild("Services")
                            if services then
                                local season = services:FindFirstChild("SeasonService")
                                if season then
                                    local rf = season:FindFirstChild("RF")
                                    if rf then
                                        local request = rf:FindFirstChild("RequestRankedReward")
                                        if request then
                                            for _, reward_id in ipairs(rewards) do
                                                request:InvokeServer(reward_id)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- =====================
-- CAMERA JUMP SYSTEM
-- =====================

UserInputService.InputBegan:Connect(function(input)
    if G.CameraJump then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            local root = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and root and input.KeyCode == Enum.KeyCode.Space then
                task.defer(function()
                    task.wait(0.03)
                    local dir = Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z)
                    if dir.Magnitude > 0 then
                        root.CFrame = CFrame.lookAt(root.Position, root.Position + dir.Unit)
                        humanoid.AutoRotate = false
                    end
                end)
            end
        end
    end
end)

-- =====================
-- NOTIFICAÇÕES
-- =====================

local notification_container = nil

function show_notification(text)
    if not notification_container then return end
    
    local frame = Instance.new("Frame")
    frame.Name = "NotifFrame"
    frame.Size = UDim2.new(0, 300, 0, 60)
    frame.Position = UDim2.new(0.5, -150, 0, -80)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Parent = notification_container
    
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = G.ThemeColor
    stroke.Thickness = 2
    stroke.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local tween_in = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -150, 0, 20)
    })
    tween_in:Play()
    
    task.wait(3)
    
    local tween_out = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -150, 0, -80)
    })
    tween_out:Play()
    tween_out.Completed:Wait()
    frame:Destroy()
end

-- =====================
-- INICIALIZAÇÃO
-- =====================

-- Carregar configuração
local config_loaded = apply_config(load_config())

-- Iniciar conexões automáticas
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    apply_tuxedo_jersey()
end)

-- Atualizações em loop
RunService.Heartbeat:Connect(function()
    update_hitboxes()
    update_esp()
end)

print("[ZYNEX] Carregado com sucesso!")
show_notification("ZYNEX CARREGADO!")

-- =====================
-- GUI PRINCIPAL
-- =====================

local gui_parent
if typeof(gethui) == "function" then
    gui_parent = gethui()
else
    local ok, cg = pcall(game.GetService, game, "CoreGui")
    gui_parent = (ok and cg) or LocalPlayer:WaitForChild("PlayerGui")
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CHEternalGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = gui_parent

-- Janela principal
local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.fromOffset(420, 340)
Window.Position = UDim2.fromOffset(300, 200)
Window.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Window.BorderSizePixel = 0
Window.ZIndex = 10
Window.Parent = ScreenGui
Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 10)
local winStroke = Instance.new("UIStroke", Window)
winStroke.Color = Color3.fromRGB(100, 0, 200)
winStroke.Thickness = 1.5

-- Topbar (título + fechar)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 11
TopBar.Parent = Window
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

-- Cobre cantos inferiores da topbar
local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 10)
TopBarFix.Position = UDim2.new(0, 0, 1, -10)
TopBarFix.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
TopBarFix.BorderSizePixel = 0
TopBarFix.ZIndex = 11
TopBarFix.Parent = TopBar

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size = UDim2.new(1, -40, 1, 0)
TitleLbl.Position = UDim2.fromOffset(14, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = "CH | ETERNAL"
TitleLbl.TextColor3 = Color3.fromRGB(160, 60, 255)
TitleLbl.TextSize = 15
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.ZIndex = 12
TitleLbl.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(20, 20)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 12
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.MouseButton1Click:Connect(function() Window.Visible = false end)

-- Barra de abas
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, -16, 0, 30)
TabBar.Position = UDim2.fromOffset(8, 42)
TabBar.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 11
TabBar.Parent = Window
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 2)
TabLayout.Parent = TabBar

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingLeft = UDim.new(0, 4)
UIPadding.PaddingTop = UDim.new(0, 4)
UIPadding.PaddingRight = UDim.new(0, 4)
UIPadding.PaddingBottom = UDim.new(0, 4)
UIPadding.Parent = TabBar

-- Área de conteúdo das abas
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -16, 1, -88)
ContentArea.Position = UDim2.fromOffset(8, 80)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 11
ContentArea.Parent = Window

-- Função para criar aba
local tab_buttons = {}
local tab_pages = {}
local active_tab = nil

local function setActiveTab(name)
    active_tab = name
    for n, btn in pairs(tab_buttons) do
        if n == name then
            btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            btn.TextColor3 = Color3.new(1,1,1)
        else
            btn.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end
    for n, page in pairs(tab_pages) do
        page.Visible = (n == name)
    end
end

local TAB_NAMES = {"COMBATE", "GIRAR", "MOVIMENTAÇÃO", "EQUIPAME"}

for i, name in ipairs(TAB_NAMES) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, -3, 1, -8)
    btn.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.ZIndex = 12
    btn.LayoutOrder = i
    btn.Parent = TabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
    page.CanvasSize = UDim2.fromOffset(0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ZIndex = 11
    page.Visible = false
    page.Parent = ContentArea

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 6)
    pageLayout.Parent = page

    local pagePad = Instance.new("UIPadding")
    pagePad.PaddingTop = UDim.new(0, 4)
    pagePad.PaddingBottom = UDim.new(0, 4)
    pagePad.Parent = page

    tab_buttons[name] = btn
    tab_pages[name] = page

    btn.MouseButton1Click:Connect(function() setActiveTab(name) end)
end

setActiveTab("COMBATE")

-- =====================
-- COMPONENTES
-- =====================

-- Linha separadora de seção
local function addSection(page, text)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 22)
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.ZIndex = 12
    row.Parent = page

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.fromScale(1, 1)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(138, 43, 226)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 13
    lbl.Parent = row

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, -1)
    line.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
    line.BorderSizePixel = 0
    line.ZIndex = 13
    line.Parent = row
    return row
end
