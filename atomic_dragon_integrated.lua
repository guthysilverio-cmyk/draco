--[[
    ATOMIC DRAGON - Script Integrado
    Interface Orion Library (Estilo Dragon)
    Sistema KeyAuth
    Hitbox com opções de transparência e cor
    Funcionalidades melhoradas do Atomic + Draco
--]]

-- =====================
-- SERVIÇOS
-- =====================

local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")
local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local Lighting          = game:GetService("Lighting")
local HttpService       = game:GetService("HttpService")
local LocalPlayer       = Players.LocalPlayer
local Camera            = Workspace.CurrentCamera
local CoreGui           = game:GetService("CoreGui")

-- =====================
-- PARENT DA GUI
-- =====================

local function getGuiParent()
    if typeof(gethui) == "function" then return gethui() end
    local ok, cg = pcall(game.GetService, game, "CoreGui")
    if ok and cg then return cg end
    return LocalPlayer.PlayerGui
end

-- =====================
-- PAINEL DE KEY (KeyAuth)
-- =====================

local authGui = Instance.new("ScreenGui")
authGui.Name = "ATOMIC_DRAGON_Auth"
authGui.ResetOnSpawn = false
authGui.IgnoreGuiInset = true
authGui.DisplayOrder = 9999
authGui.Parent = getGuiParent()

local overlay = Instance.new("Frame", authGui)
overlay.Size = UDim2.fromScale(1,1)
overlay.BackgroundColor3 = Color3.fromRGB(10,10,15)
overlay.BackgroundTransparency = 0.2
overlay.BorderSizePixel = 0
overlay.ZIndex = 10

local card = Instance.new("Frame", overlay)
card.AnchorPoint = Vector2.new(0.5,0.5)
card.Position = UDim2.fromScale(0.5,0.5)
card.Size = UDim2.fromOffset(420,220)
card.BackgroundColor3 = Color3.fromRGB(18,18,25)
card.BorderSizePixel = 0
card.ZIndex = 11
Instance.new("UICorner", card).CornerRadius = UDim.new(0,12)
local cStroke = Instance.new("UIStroke", card)
cStroke.Color = Color3.fromRGB(138,43,226)
cStroke.Thickness = 2

local kTitle = Instance.new("TextLabel", card)
kTitle.Size = UDim2.new(1,0,0,40)
kTitle.Position = UDim2.fromOffset(0,14)
kTitle.BackgroundTransparency = 1
kTitle.Text = "ATOMIC DRAGON"
kTitle.TextColor3 = Color3.fromRGB(138,43,226)
kTitle.TextSize = 22
kTitle.Font = Enum.Font.GothamBold
kTitle.TextXAlignment = Enum.TextXAlignment.Center
kTitle.ZIndex = 12

local kCreator = Instance.new("TextLabel", card)
kCreator.Size = UDim2.new(1,0,0,16)
kCreator.Position = UDim2.fromOffset(0,38)
kCreator.BackgroundTransparency = 1
kCreator.Text = "Criador: Dragon"
kCreator.TextColor3 = Color3.fromRGB(120,120,150)
kCreator.TextSize = 11
kCreator.Font = Enum.Font.Gotham
kCreator.TextXAlignment = Enum.TextXAlignment.Center
kCreator.ZIndex = 12

local kSub = Instance.new("TextLabel", card)
kSub.Size = UDim2.new(1,0,0,20)
kSub.Position = UDim2.fromOffset(0,58)
kSub.BackgroundTransparency = 1
kSub.Text = "Digite sua key de acesso"
kSub.TextColor3 = Color3.fromRGB(180,180,200)
kSub.TextSize = 13
kSub.Font = Enum.Font.Gotham
kSub.TextXAlignment = Enum.TextXAlignment.Center
kSub.ZIndex = 12

local kInputFrame = Instance.new("Frame", card)
kInputFrame.Size = UDim2.new(1,-40,0,40)
kInputFrame.Position = UDim2.fromOffset(20,82)
kInputFrame.BackgroundColor3 = Color3.fromRGB(30,30,42)
kInputFrame.BorderSizePixel = 0
kInputFrame.ZIndex = 12
Instance.new("UICorner", kInputFrame).CornerRadius = UDim.new(0,8)
Instance.new("UIStroke", kInputFrame).Color = Color3.fromRGB(80,80,110)

local kBox = Instance.new("TextBox", kInputFrame)
kBox.Size = UDim2.new(1,-20,1,0)
kBox.Position = UDim2.fromOffset(10,0)
kBox.BackgroundTransparency = 1
kBox.PlaceholderText = "XXXXX-XXXXX-XXXXX-XXXXX"
kBox.PlaceholderColor3 = Color3.fromRGB(100,100,130)
kBox.Text = ""
kBox.TextColor3 = Color3.fromRGB(240,240,255)
kBox.TextSize = 14
kBox.Font = Enum.Font.Code
kBox.ClearTextOnFocus = false
kBox.ZIndex = 13

local kBtn = Instance.new("TextButton", card)
kBtn.Size = UDim2.new(1,-40,0,38)
kBtn.Position = UDim2.fromOffset(20,134)
kBtn.BackgroundColor3 = Color3.fromRGB(138,43,226)
kBtn.BorderSizePixel = 0
kBtn.Text = "Confirmar"
kBtn.TextColor3 = Color3.new(1,1,1)
kBtn.TextSize = 15
kBtn.Font = Enum.Font.GothamBold
kBtn.ZIndex = 12
kBtn.AutoButtonColor = false
Instance.new("UICorner", kBtn).CornerRadius = UDim.new(0,8)

local kStatus = Instance.new("TextLabel", card)
kStatus.Size = UDim2.new(1,0,0,20)
kStatus.Position = UDim2.fromOffset(0,178)
kStatus.BackgroundTransparency = 1
kStatus.Text = ""
kStatus.TextColor3 = Color3.fromRGB(255,80,80)
kStatus.TextSize = 12
kStatus.Font = Enum.Font.Gotham
kStatus.TextXAlignment = Enum.TextXAlignment.Center
kStatus.ZIndex = 12

kBtn.MouseEnter:Connect(function()
    TweenService:Create(kBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(160,60,255)}):Play()
end)
kBtn.MouseLeave:Connect(function()
    TweenService:Create(kBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(138,43,226)}):Play()
end)

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

-- KeyAuth via API direta
local function kaRequest(body)
    local opts = {
        Url     = "https://keyauth.win/api/1.3/",
        Method  = "POST",
        Headers = {["Content-Type"]="application/x-www-form-urlencoded"},
        Body    = body,
    }
    local response = nil
    for _, fn in ipairs({
        function() return request(opts) end,
        function() return http_request(opts) end,
        function() return (syn and syn.request)(opts) end,
        function() return (http and http.request)(opts) end,
        function() return HttpService:RequestAsync(opts) end,
    }) do
        local ok, res = pcall(fn)
        if ok and res and (res.Body or res.body) then response = res; break end
    end
    if not response then return nil end
    local ok, data = pcall(HttpService.JSONDecode, HttpService, response.Body or response.body or "")
    if ok and data then return data end
    return nil
end

local initData = kaRequest("type=init&name=DracoApp&ownerid=H5AiXGE89t&secret=ca5b279214afeb45d9189590c6c8c9a968cda93a6d78079e32775473c20c8f50&ver=1.0&hash=0000000000000000000000000000000000000000000000000000000000000000")

local _authOk, _authMsg = false, "Erro de conexao. Tente novamente."

if not initData or not initData.sessionid then
    _authMsg = (initData and initData.message) or "Erro ao iniciar sessao KeyAuth."
else
    local licData = kaRequest("type=license&key="..userKey.."&ownerid=H5AiXGE89t&secret=ca5b279214afeb45d9189590c6c8c9a968cda93a6d78079e32775473c20c8f50&sessionid="..initData.sessionid)
    if licData then
        if licData.success == true then
            _authOk = true; _authMsg = ""
        else
            _authMsg = licData.message or "Key invalida ou expirada!"
        end
    end
end

if not _authOk then
    kStatus.Text=_authMsg; kStatus.TextColor3=Color3.fromRGB(255,60,60)
    task.wait(3); authGui:Destroy(); error("[ATOMIC DRAGON] ".._authMsg)
end
authGui:Destroy()
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{Title="ATOMIC DRAGON",Text="Autenticado! Carregando...",Duration=3})
end)

-- =====================
-- ESTADO GLOBAL
-- =====================

local G = {
    HitboxEnabled      = false,
    HitboxSize         = 5,
    HitboxTransparency = 0.35,
    HitboxColor        = Color3.fromRGB(138,43,226),
    ESPEnabled         = false,
    ESPLineSize        = 25,
    ESPNeon            = true,
    ESPThickness       = 0.35,
    AutoLong           = false,
    AutoLongAngle      = 15,
    AutoLongDir        = "DIREITA",
    FreezeAir          = false,
    LeedFeat           = false,
    CameraJump         = true,
    FPSBoost           = false,
    NightMode          = false,
    GrayFloor          = false,
    NoShadows          = false,
    AutoSpinStyle      = false,
    AutoSpinHabi       = false,
    AutoYen            = false,
    AntiAFK            = false,
    StretchedRes       = false,
    ShowFPS            = false,
    ThemeColor         = Color3.fromRGB(138,43,226),
}

-- =====================
-- DETECTAR REMOTES
-- =====================

local SeasonServiceRF = nil
local ClaimSkillRemote = nil

pcall(function()
    local Packages = ReplicatedStorage:FindFirstChild("Packages")
    if Packages then
        local Index = Packages:FindFirstChild("_Index")
        if Index then
            for _, child in ipairs(Index:GetChildren()) do
                if child.Name:match("knit") then
                    local knit = child:FindFirstChild("knit")
                    if knit then
                        local Services = knit:FindFirstChild("Services")
                        if Services then
                            local SeasonService = Services:FindFirstChild("SeasonService")
                            if SeasonService and SeasonService:FindFirstChild("RF") then
                                SeasonServiceRF = SeasonService.RF:FindFirstChild("RequestRankedReward")
                            end
                            
                            local SkillService = Services:FindFirstChild("SkillService") or Services:FindFirstChild("AbilityService") or Services:FindFirstChild("MasteryService")
                            if SkillService and SkillService:FindFirstChild("RF") then
                                ClaimSkillRemote = SkillService.RF:FindFirstChild("ClaimReward") or SkillService.RF:FindFirstChild("ClaimSkill") or SkillService.RF:FindFirstChild("RequestReward")
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- =====================
-- SETUP CHARACTER
-- =====================

local humanoid, hrp
local function setupCharacter(char)
    if not char then return end
    humanoid = char:WaitForChild("Humanoid", 5)
    hrp = char:WaitForChild("HumanoidRootPart", 5)
end
if LocalPlayer.Character then setupCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(setupCharacter)

-- =====================
-- HITBOX COM TRANSPARÊNCIA E COR
-- =====================

local function clear_hitboxes()
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name:match("^CLIENT_BALL_") then
            local b = obj:FindFirstChild("Ball.001")
            if b then b:Destroy() end
        end
    end
end

local function getHitboxTransparency()
    local transparency = tonumber(G.HitboxTransparency) or 0.35
    return math.clamp(transparency, 0, 1)
end

RunService.RenderStepped:Connect(function()
    if not G.HitboxEnabled then return end
    for _, model in ipairs(Workspace:GetChildren()) do
        if model:IsA("Model") and model.Name:match("^CLIENT_BALL_%d+$") then
            local ball = model:FindFirstChild("Ball.001")
            if not ball then
                local ref
                for _, p in ipairs(model:GetDescendants()) do if p:IsA("BasePart") then ref=p; break end end
                if ref then
                    ball = Instance.new("Part", model)
                    ball.Name = "Ball.001"; ball.Shape = Enum.PartType.Ball
                    ball.Anchored = true; ball.CanCollide = false
                    ball.Material = Enum.Material.Neon
                    ball.Transparency = getHitboxTransparency()
                    ball.Color = G.HitboxColor
                end
            end
            if ball then
                ball.Size = Vector3.new(2,2,2)*G.HitboxSize
                ball.Transparency = getHitboxTransparency()
                ball.Color = G.HitboxColor
                ball.Material = Enum.Material.Neon
                local ref
                for _, p in ipairs(model:GetDescendants()) do
                    if p:IsA("BasePart") and p.Name ~= "Ball.001" then ref=p; break end
                end
                if ref then ball.CFrame = ref.CFrame end
            end
        end
    end
end)

-- =====================
-- ESP RAIO DOS OLHOS
-- =====================

local espFolder = Instance.new("Folder")
espFolder.Name = "Atomic_EyeDirection_ESP"
espFolder.Parent = Workspace
local espObjects = {}

local function clearESPFor(player)
    local data = espObjects[player]
    if data then
        for _, obj in pairs(data) do
            pcall(function() obj:Destroy() end)
        end
        espObjects[player] = nil
    end
end

local function clearAllESP()
    for player in pairs(espObjects) do
        clearESPFor(player)
    end
end

local function getCharacterParts(character)
    if not character then return nil, nil end
    return character:FindFirstChild("Head"), character:FindFirstChild("HumanoidRootPart")
end

local function ensureEyeRay(player)
    if player == LocalPlayer then return nil end

    local char = player.Character
    local head, root = getCharacterParts(char)
    if not head or not root then
        clearESPFor(player)
        return nil
    end

    local data = espObjects[player]
    if data and data.root == root and data.head == head then
        return data
    end

    clearESPFor(player)

    local startPart = Instance.new("Part")
    startPart.Name = "Atomic_EyeStartPart"
    startPart.Size = Vector3.new(0.12, 0.12, 0.12)
    startPart.Transparency = 1
    startPart.Anchored = true
    startPart.CanCollide = false
    startPart.CanTouch = false
    startPart.CanQuery = false
    startPart.Parent = espFolder

    local startAtt = Instance.new("Attachment")
    startAtt.Name = "Atomic_EyeStart"
    startAtt.Parent = startPart

    local endPart = Instance.new("Part")
    endPart.Name = "Atomic_EyeEnd"
    endPart.Size = Vector3.new(0.12, 0.12, 0.12)
    endPart.Transparency = 1
    endPart.Anchored = true
    endPart.CanCollide = false
    endPart.CanTouch = false
    endPart.CanQuery = false
    endPart.Parent = espFolder

    local endAtt = Instance.new("Attachment")
    endAtt.Name = "Atomic_EyeEndAttachment"
    endAtt.Parent = endPart

    local beam = Instance.new("Beam")
    beam.Name = "Atomic_EyeLookRay"
    beam.Attachment0 = startAtt
    beam.Attachment1 = endAtt
    beam.FaceCamera = true
    beam.LightEmission = 1
    beam.LightInfluence = 0
    beam.Width0 = G.ESPThickness or 0.35
    beam.Width1 = G.ESPThickness or 0.35
    beam.Transparency = NumberSequence.new(0.05)
    beam.Color = ColorSequence.new(G.ThemeColor)
    beam.Parent = espFolder

    data = {head = head, root = root, startPart = startPart, startAtt = startAtt, endPart = endPart, endAtt = endAtt, beam = beam}
    espObjects[player] = data
    return data
end

local function updateEyeRayESP()
    if not G.ESPEnabled then
        clearAllESP()
        return
    end

    local length = math.clamp(tonumber(G.ESPLineSize) or 25, 5, 120)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local data = ensureEyeRay(plr)
            if data and data.head and data.root and data.head.Parent and data.root.Parent then
                local startWorld = data.root.CFrame:PointToWorldSpace(Vector3.new(0, 1.55, -0.55))
                local look = data.head.CFrame.LookVector
                local flatLook = Vector3.new(look.X, 0, look.Z)
                if flatLook.Magnitude < 0.05 then
                    flatLook = Vector3.new(data.root.CFrame.LookVector.X, 0, data.root.CFrame.LookVector.Z)
                end
                flatLook = flatLook.Unit

                local endWorld = startWorld + (flatLook * length)
                data.startPart.CFrame = CFrame.new(startWorld)
                data.endPart.CFrame = CFrame.new(endWorld)
                data.beam.Width0 = math.clamp(tonumber(G.ESPThickness) or 0.35, 0.05, 1)
                data.beam.Width1 = math.clamp(tonumber(G.ESPThickness) or 0.35, 0.05, 1)
                data.beam.Color = ColorSequence.new(G.ThemeColor)
                if G.ESPNeon then
                    data.beam.LightEmission = 1
                else
                    data.beam.LightEmission = 0
                end
            end
        end
    end
end

Players.PlayerRemoving:Connect(function(plr)
    clearESPFor(plr)
end)

-- =====================
-- FREEZE AIR
-- =====================

local is_frozen = false
local function set_freeze(state)
    is_frozen = state
    local c = LocalPlayer.Character
    if c then local r=c:FindFirstChild("HumanoidRootPart"); if r then r.Anchored=state end end
end

-- =====================
-- LEED FEAT
-- =====================

local leed_active = false
local function do_leed_feat()
    local c=LocalPlayer.Character; if not c then return end
    local h=c:FindFirstChildOfClass("Humanoid"); local r=c:FindFirstChild("HumanoidRootPart")
    if not h or not r then return end
    r.Anchored=false
    r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,-260,r.AssemblyLinearVelocity.Z)
    if leed_active then return end; leed_active=true
    task.spawn(function()
        local t=tick()
        while c.Parent and h.FloorMaterial==Enum.Material.Air and tick()-t<=2.5 do task.wait(0.03) end
        leed_active=false
    end)
end

-- =====================
-- AUTO LONG
-- =====================

local al_active=false; local al_conn=nil
local function stop_auto_long()
    al_active=false
    if al_conn then pcall(function()RunService:UnbindFromRenderStep("AtomicDragonAutoLong")end); al_conn=nil end
    local c=LocalPlayer.Character
    if c then local lt=c:FindFirstChild("LowerTorso"); if lt then local rj=lt:FindFirstChild("Root"); if rj then pcall(function()rj.C0=CFrame.new(rj.C0.Position)end)end end end
end
local function start_auto_long()
    stop_auto_long()
    local c=LocalPlayer.Character; if not c then return end
    local rp=c:FindFirstChild("HumanoidRootPart")
    local lt=c:FindFirstChild("LowerTorso"); if not lt then return end
    local rj=lt:FindFirstChild("Root"); if not rp or not rj then return end
    al_active=true; local oc0=rj.C0
    local ao=(G.AutoLongDir=="DIREITA" and -1 or 1)*math.rad(math.clamp(G.AutoLongAngle,0,30))
    al_conn=true
    RunService:BindToRenderStep("AtomicDragonAutoLong",Enum.RenderPriority.Camera.Value+1,function()
        if not al_active then pcall(function()RunService:UnbindFromRenderStep("AtomicDragonAutoLong")end); al_conn=nil; return end
        pcall(function()
            local cl=Camera.CFrame.LookVector
            local fl=Vector3.new(cl.X,0,cl.Z)
            if fl.Magnitude<0.01 then return end; fl=fl.Unit
            local dot=rp.CFrame.LookVector:Dot(fl)
            rj.C0=oc0*CFrame.Angles(math.rad(-dot*20),0,math.clamp(ao*1.5,-math.rad(30),math.rad(30)))
        end)
    end)
end

-- =====================
-- EFEITOS VISUAIS
-- =====================

local orig_lt={ClockTime=Lighting.ClockTime,Brightness=Lighting.Brightness,Ambient=Lighting.Ambient,OutdoorAmbient=Lighting.OutdoorAmbient,FogEnd=Lighting.FogEnd,GlobalShadows=Lighting.GlobalShadows}
local saved_parts={}; local saved_effects={}
local function apply_visuals()
    if G.NightMode then
        Lighting.ClockTime = 0
        Lighting.Brightness = 0.5
        Lighting.Ambient = Color3.fromRGB(60, 60, 80)
        Lighting.OutdoorAmbient = Color3.fromRGB(40, 40, 60)
        Lighting.FogEnd = 1000
    else
        Lighting.ClockTime = orig_lt.ClockTime
        Lighting.Brightness = orig_lt.Brightness
        Lighting.Ambient = orig_lt.Ambient
        Lighting.OutdoorAmbient = orig_lt.OutdoorAmbient
        Lighting.FogEnd = orig_lt.FogEnd
    end

    Lighting.GlobalShadows = not (G.NoShadows or G.FPSBoost)

    if G.FPSBoost then
        Lighting.FogEnd = 100000
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or
               obj:IsA("ColorCorrectionEffect") or obj:IsA("DepthOfFieldEffect") or
               obj:IsA("SunRaysEffect") then
                obj.Enabled = false
            end
        end
        for _, o in ipairs(Workspace:GetDescendants()) do
            if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") or o:IsA("Fire") or o:IsA("Smoke") or o:IsA("Sparkles") then
                if saved_effects[o] == nil then saved_effects[o] = o.Enabled end
                o.Enabled = false
            end
        end
    else
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or
               obj:IsA("ColorCorrectionEffect") or obj:IsA("DepthOfFieldEffect") or
               obj:IsA("SunRaysEffect") then
                obj.Enabled = true
            end
        end
        for o,e in pairs(saved_effects) do if o and o.Parent then o.Enabled=e end end
        saved_effects={}
        if not G.NightMode then Lighting.FogEnd=orig_lt.FogEnd end
    end

    if G.GrayFloor then
        for _,p in ipairs(Workspace:GetDescendants()) do
            if p:IsA("BasePart") and p.Anchored then
                local n=p.Name:lower()
                if n:find("floor") or n:find("ground") or n:find("baseplate") or n:find("chao") then
                    if not saved_parts[p] then saved_parts[p]={Color=p.Color,Material=p.Material} end
                    p.Color=Color3.fromRGB(95,95,95); p.Material=Enum.Material.SmoothPlastic
                end
            end
        end
    else
        for p,d in pairs(saved_parts) do if p and p.Parent then p.Color=d.Color; p.Material=d.Material end end
        saved_parts={}
    end
end

-- =====================
-- AUTO SPIN
-- =====================

task.spawn(function()
    while task.wait(0.5) do
        if G.AutoSpinStyle or G.AutoSpinHabi or G.AutoYen then
            pcall(function()
                local rewards={}
                if G.AutoSpinStyle then table.insert(rewards,1) end
                if G.AutoSpinHabi  then table.insert(rewards,4) end
                if G.AutoYen       then table.insert(rewards,2) end
                local pkg=ReplicatedStorage:FindFirstChild("Packages"); if not pkg then return end
                local idx=pkg:FindFirstChild("_Index"); if not idx then return end
                local knit=idx:FindFirstChild("sleitnick_knit@1.7.0"); if not knit then return end
                local kmod=knit:FindFirstChild("knit"); if not kmod then return end
                local svcs=kmod:FindFirstChild("Services"); if not svcs then return end
                local ss=svcs:FindFirstChild("SeasonService"); if not ss then return end
                local rf=ss:FindFirstChild("RF"); if not rf then return end
                local req=rf:FindFirstChild("RequestRankedReward"); if not req then return end
                for _,id in ipairs(rewards) do req:InvokeServer(id) end
            end)
        end
    end
end)

-- =====================
-- CAMERA JUMP
-- =====================

UserInputService.InputBegan:Connect(function(input,gp)
    if gp then return end
    if G.CameraJump and input.KeyCode==Enum.KeyCode.Space then
        local c=LocalPlayer.Character; if not c then return end
        local h=c:FindFirstChild("Humanoid"); local r=c:FindFirstChild("HumanoidRootPart")
        if h and r then task.defer(function() task.wait(0.03); local dir=Vector3.new(Camera.CFrame.LookVector.X,0,Camera.CFrame.LookVector.Z); if dir.Magnitude>0 then r.CFrame=CFrame.lookAt(r.Position,r.Position+dir.Unit); h.AutoRotate=false end end) end
    end
end)

-- =====================
-- ANTI AFK
-- =====================

local antiAfkConnection = nil
local function setAntiAFK(state)
    G.AntiAFK = state
    if state and not antiAfkConnection then
        antiAfkConnection = LocalPlayer.Idled:Connect(function()
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:Button2Down(Vector2.new(0, 0), Camera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0, 0), Camera.CFrame)
            end)
        end)
    elseif not state and antiAfkConnection then
        antiAfkConnection:Disconnect()
        antiAfkConnection = nil
    end
end

-- =====================
-- FPS COUNTER
-- =====================

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 105, 0, 25)
fpsLabel.Position = UDim2.new(0, 12, 0, 55)
fpsLabel.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
fpsLabel.BackgroundTransparency = 0.15
fpsLabel.TextColor3 = Color3.fromRGB(220, 200, 255)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 12
fpsLabel.TextXAlignment = Enum.TextXAlignment.Center
fpsLabel.Visible = false
fpsLabel.Parent = getGuiParent()

local fpsCorner = Instance.new("UICorner")
fpsCorner.CornerRadius = UDim.new(0, 10)
fpsCorner.Parent = fpsLabel

local fpsStroke = Instance.new("UIStroke")
fpsStroke.Thickness = 1.5
fpsStroke.Color = G.ThemeColor
fpsStroke.Parent = fpsLabel

local fpsValue = 0
local lastUpdate, frameCount = os.clock(), 0

RunService.RenderStepped:Connect(function()
    frameCount += 1

    if os.clock() - lastUpdate >= 1 then
        fpsValue = frameCount
        if G.ShowFPS then
            fpsLabel.Text = tostring(fpsValue) .. " FPS"
        end
        frameCount = 0
        lastUpdate = os.clock()
    end

    if Camera then
        Camera.FieldOfView = G.StretchedRes and 110 or 70
    end

    updateEyeRayESP()
end)

-- =====================
-- TECLAS DE ATALHO
-- =====================

UserInputService.InputBegan:Connect(function(input,gp)
    if gp then return end
    if input.KeyCode==Enum.KeyCode.F and G.FreezeAir then set_freeze(not is_frozen) end
    if input.KeyCode==Enum.KeyCode.G and G.LeedFeat then do_leed_feat() end
    if input.KeyCode==Enum.KeyCode.L then
        G.AutoLong=not G.AutoLong
        if G.AutoLong then start_auto_long() else stop_auto_long() end
    end
end)

-- =====================
-- ORION LIBRARY
-- =====================

local OrionLib
for _, url in ipairs({
    "https://raw.githubusercontent.com/jensonhirst/Orion/main/source",
    "https://raw.githubusercontent.com/High1000/Orion-Roblox-UI/main/source",
}) do
    local ok, res = pcall(function() return loadstring(game:HttpGet(url))() end)
    if ok and res then OrionLib = res; break end
end
assert(OrionLib, "[ATOMIC DRAGON] Falha ao carregar Orion Library")

local Window = OrionLib:MakeWindow({
    Name         = "ATOMIC DRAGON",
    HidePremium  = true,
    SaveConfig   = false,
    IntroEnabled = true,
    IntroText    = "ATOMIC DRAGON",
})

-- ======== ABA COMBATE ========
local TabCombate = Window:MakeTab({ Name = "Combate", Icon = "rbxassetid://4483345998" })

TabCombate:AddSection({ Name = "Hitbox" })
TabCombate:AddToggle({ Name = "Hitbox", Default = false, Callback = function(v) G.HitboxEnabled=v; if not v then clear_hitboxes() end end })
TabCombate:AddSlider({ Name = "Tamanho da Hitbox", Min=1, Max=100, Default=5, Increment=1, ValueName="x", Callback = function(v) G.HitboxSize=v end })
TabCombate:AddSlider({ Name = "Transparencia Hitbox", Min=0, Max=10, Default=4, Increment=1, ValueName="/10", Callback = function(v) G.HitboxTransparency=v/10 end })
TabCombate:AddColorpicker({ Name = "Cor da Hitbox", Default = Color3.fromRGB(138,43,226), Callback = function(v) G.HitboxColor=v end })

TabCombate:AddSection({ Name = "Freeze Air" })
TabCombate:AddToggle({ Name = "Freeze Air", Default = false, Callback = function(v) G.FreezeAir=v; if not v then set_freeze(false) end end })
TabCombate:AddButton({ Name = "Toggle Freeze [F]", Callback = function() if G.FreezeAir then set_freeze(not is_frozen) end end })

TabCombate:AddSection({ Name = "Leed Feat" })
TabCombate:AddToggle({ Name = "Leed Feat [G]", Default = false, Callback = function(v) G.LeedFeat=v end })
TabCombate:AddButton({ Name = "Aplicar Leed Feat", Callback = function() do_leed_feat() end })

TabCombate:AddSection({ Name = "Auto Long" })
TabCombate:AddToggle({ Name = "Auto Long", Default = false, Callback = function(v) G.AutoLong=v; if v then start_auto_long() else stop_auto_long() end end })
TabCombate:AddSlider({ Name = "Angulo Auto Long", Min=1, Max=30, Default=15, Increment=1, ValueName=" graus", Callback = function(v) G.AutoLongAngle=v; if G.AutoLong then stop_auto_long(); start_auto_long() end end })
TabCombate:AddDropdown({ Name = "Direcao Auto Long", Default="DIREITA", Options={"DIREITA","ESQUERDA"}, Callback = function(v) G.AutoLongDir=v; if G.AutoLong then stop_auto_long(); start_auto_long() end end })

TabCombate:AddSection({ Name = "Camera Jump" })
TabCombate:AddToggle({ Name = "Camera Jump [Espaco]", Default = true, Callback = function(v) G.CameraJump=v end })

-- ======== ABA VISUAL ========
local TabVisual = Window:MakeTab({ Name = "Visual", Icon = "rbxassetid://4483345998" })

TabVisual:AddSection({ Name = "ESP" })
TabVisual:AddToggle({ Name = "ESP Raio dos Olhos", Default = false, Callback = function(v) G.ESPEnabled=v end })
TabVisual:AddToggle({ Name = "ESP Neon", Default = true, Callback = function(v) G.ESPNeon=v end })
TabVisual:AddSlider({ Name = "Comprimento ESP", Min=5, Max=120, Default=25, Increment=1, ValueName="", Callback = function(v) G.ESPLineSize=v end })
TabVisual:AddSlider({ Name = "Grossura ESP", Min=1, Max=10, Default=4, Increment=1, ValueName="/10", Callback = function(v) G.ESPThickness=v/10 end })

TabVisual:AddSection({ Name = "Efeitos" })
TabVisual:AddToggle({ Name = "FPS Boost",    Default = false, Callback = function(v) G.FPSBoost=v; apply_visuals() end })
TabVisual:AddToggle({ Name = "Modo Noturno", Default = false, Callback = function(v) G.NightMode=v; apply_visuals() end })
TabVisual:AddToggle({ Name = "Chao Cinza",   Default = false, Callback = function(v) G.GrayFloor=v; apply_visuals() end })
TabVisual:AddToggle({ Name = "Sem Sombras",  Default = false, Callback = function(v) G.NoShadows=v; apply_visuals() end })
TabVisual:AddColorpicker({ Name = "Cor Theme", Default = Color3.fromRGB(138,43,226), Callback = function(v) G.ThemeColor=v; fpsStroke.Color=v end })

-- ======== ABA AUTO SPIN ========
local TabSpin = Window:MakeTab({ Name = "Auto Spin", Icon = "rbxassetid://4483345998" })
TabSpin:AddSection({ Name = "Recompensas" })
TabSpin:AddToggle({ Name="Auto Spin Style",      Default=false, Callback=function(v) G.AutoSpinStyle=v end })
TabSpin:AddToggle({ Name="Auto Spin Habilidade", Default=false, Callback=function(v) G.AutoSpinHabi=v  end })
TabSpin:AddToggle({ Name="Auto Yen",             Default=false, Callback=function(v) G.AutoYen=v       end })

-- ======== ABA MOVIMENTAÇÃO ========
local TabMove = Window:MakeTab({ Name = "Movimentação", Icon = "rbxassetid://4483345998" })
TabMove:AddSection({ Name = "Movimento" })
TabMove:AddToggle({ Name = "Anti AFK", Default = false, Callback = function(v) setAntiAFK(v) end })
TabMove:AddToggle({ Name = "Tela Esticada", Default = false, Callback = function(v) G.StretchedRes=v end })
TabMove:AddToggle({ Name = "Mostrar FPS", Default = false, Callback = function(v) G.ShowFPS=v; fpsLabel.Visible=v end })

-- ======== ABA MISC ========
local TabMisc = Window:MakeTab({ Name = "Misc", Icon = "rbxassetid://4483345998" })
TabMisc:AddSection({ Name = "Info" })
TabMisc:AddLabel("ATOMIC DRAGON - Script Volleyball")
TabMisc:AddLabel("Criador: Dragon")
TabMisc:AddParagraph("Teclas", "F = Freeze | G = Leed Feat | L = Auto Long")
TabMisc:AddButton({ Name = "Otimizar Grafico", Callback = function()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsA("MeshPart") then
            obj.Material = Enum.Material.SmoothPlastic
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        end
    end
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") then
            effect.Enabled = false
        end
    end
end })

-- =====================
-- NOTIFICAÇÃO FINAL
-- =====================

OrionLib:MakeNotification({
    Name    = "ATOMIC DRAGON",
    Content = "Script carregado! | Criador: Dragon",
    Image   = "rbxassetid://4483345998",
    Time    = 4
})

OrionLib:Init()

print("ATOMIC DRAGON carregado. Creditos: Dragon")
