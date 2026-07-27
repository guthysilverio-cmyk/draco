--[[
    DRACO - Script Completo
    Criador: draco goat
]]

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
-- PAINEL DE KEY
-- =====================

local authGui = Instance.new("ScreenGui")
authGui.Name = "DRACOAuth"
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
kTitle.Text = "DRACO"
kTitle.TextColor3 = Color3.fromRGB(138,43,226)
kTitle.TextSize = 22
kTitle.Font = Enum.Font.GothamBold
kTitle.TextXAlignment = Enum.TextXAlignment.Center
kTitle.ZIndex = 12

local kCreator = Instance.new("TextLabel", card)
kCreator.Size = UDim2.new(1,0,0,16)
kCreator.Position = UDim2.fromOffset(0,38)
kCreator.BackgroundTransparency = 1
kCreator.Text = "Criador: draco goat"
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
local KEYAUTH_NAME    = "Guthysilverio's Application"
local KEYAUTH_OWNERID = "H5AiXGE89t"
local KEYAUTH_SECRET  = "ca5b279214afeb45d9189590c6c8c9a968cda93a6d78079e32775473c20c8f50"
local KEYAUTH_VERSION = "1.0"

local _body = "type=license&key="..userKey.."&ownerid="..KEYAUTH_OWNERID.."&name="..HttpService:UrlEncode(KEYAUTH_NAME).."&ver="..KEYAUTH_VERSION
local _opts = {
    Url     = "https://keyauth.win/api/1.2/",
    Method  = "POST",
    Headers = {["Content-Type"]="application/x-www-form-urlencoded"},
    Body    = _body,
}
local _response = nil
for _, fn in ipairs({
    function() return request(_opts) end,
    function() return http_request(_opts) end,
    function() return (syn and syn.request)(_opts) end,
    function() return (http and http.request)(_opts) end,
    function() return HttpService:RequestAsync(_opts) end,
}) do
    local ok, res = pcall(fn)
    if ok and res and (res.Body or res.body) then _response = res; break end
end

local _authOk, _authMsg = false, "Erro de conexao. Tente novamente."
if _response then
    local ok2, data = pcall(HttpService.JSONDecode, HttpService, _response.Body or _response.body or "")
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
    game:GetService("StarterGui"):SetCore("SendNotification",{Title="DRACO",Text="Autenticado! Carregando...",Duration=3})
end)

-- =====================
-- ESTADO GLOBAL
-- =====================

local G = {
    HitboxEnabled      = false,
    HitboxSize         = 1,
    HitboxTransparency = 0.3,
    ESPEnabled         = false,
    ESPLineSize        = 10,
    ESPNeon            = false,
    AutoLong           = false,
    AutoLongAngle      = 15,
    AutoLongDir        = "DIREITA",
    FreezeAir          = false,
    LeedFeat           = false,
    CameraJump         = false,
    FPSBoost           = false,
    NightMode          = false,
    GrayFloor          = false,
    NoShadows          = false,
    AutoSpinStyle      = false,
    AutoSpinHabi       = false,
    AutoYen            = false,
    ThemeColor         = Color3.fromRGB(138,43,226),
}

-- =====================
-- HITBOX
-- =====================

local function clear_hitboxes()
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name:match("^CLIENT_BALL_") then
            local b = obj:FindFirstChild("Ball.001")
            if b then b:Destroy() end
        end
    end
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
                    ball.Material = Enum.Material.ForceField
                end
            end
            if ball then
                ball.Size = Vector3.new(2,2,2)*G.HitboxSize
                ball.Transparency = G.HitboxTransparency
                ball.Color = G.ThemeColor
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
-- ESP
-- =====================

local esp_lines = {}
RunService.Heartbeat:Connect(function()
    if G.ESPEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    if not esp_lines[player] or not esp_lines[player].Parent then
                        local ln = Instance.new("Part")
                        ln.Name="ZYNEXESPLine"; ln.Anchored=true; ln.CanCollide=false
                        ln.CanTouch=false; ln.CastShadow=false; ln.Shape=Enum.PartType.Cylinder
                        ln.Parent=Workspace; esp_lines[player]=ln
                    end
                    local ln=esp_lines[player]
                    local lv=root.CFrame.LookVector
                    local dir=Vector3.new(lv.X,0,lv.Z)
                    if dir.Magnitude>0 then dir=dir.Unit end
                    local pos=root.Position+Vector3.new(0,1.6,0)+dir*0.65
                    ln.Material=G.ESPNeon and Enum.Material.Neon or Enum.Material.SmoothPlastic
                    ln.Color=G.ThemeColor; ln.Size=Vector3.new(G.ESPLineSize,0.35,0.35)
                    ln.CFrame=CFrame.lookAt(pos+dir*G.ESPLineSize/2,pos+dir*G.ESPLineSize)*CFrame.Angles(0,math.rad(90),0)
                end
            end
        end
    else
        for p,ln in pairs(esp_lines) do if ln then pcall(function()ln:Destroy()end) end; esp_lines[p]=nil end
    end
end)

-- =====================
-- FREEZE
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
    if al_conn then pcall(function()RunService:UnbindFromRenderStep("DRACOAutoLong")end); al_conn=nil end
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
    RunService:BindToRenderStep("DRACOAutoLong",Enum.RenderPriority.Camera.Value+1,function()
        if not al_active then pcall(function()RunService:UnbindFromRenderStep("DRACOAutoLong")end); al_conn=nil; return end
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
    -- Modo noturno
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

    -- Sombras
    Lighting.GlobalShadows = not (G.NoShadows or G.FPSBoost)

    -- FPS Boost: desativa efeitos visuais pesados
    if G.FPSBoost then
        Lighting.FogEnd = 100000
        -- desativa efeitos de iluminação
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or
               obj:IsA("ColorCorrectionEffect") or obj:IsA("DepthOfFieldEffect") or
               obj:IsA("SunRaysEffect") then
                obj.Enabled = false
            end
        end
        -- desativa partículas e efeitos no workspace
        for _, o in ipairs(Workspace:GetDescendants()) do
            if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") or o:IsA("Fire") or o:IsA("Smoke") or o:IsA("Sparkles") then
                if saved_effects[o] == nil then saved_effects[o] = o.Enabled end
                o.Enabled = false
            end
        end
    else
        -- reativa efeitos de iluminação
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

    -- Chão cinza
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
-- JERSEYS
-- =====================

local original_clothes={}; local active_jersey=nil; local jersey_conn=nil

local JERSEY_TUXEDO={
    PRETA={Shirt="rbxassetid://118132190175545",Pants="rbxassetid://110200199953723"},
    LARANJA={Shirt="rbxassetid://86344308385192",Pants="rbxassetid://128599368986740"},
    ROXO={Shirt="rbxassetid://70403569023919",Pants="rbxassetid://100135147407319"},
    VERMELHA={Shirt="rbxassetid://117446934835886",Pants="rbxassetid://82230977528428"},
    BRANCA={Shirt="rbxassetid://113388156554953",Pants="rbxassetid://99618919969542"},
}
local JERSEY_DRAGAO={
    PRETA={Shirt="rbxassetid://104102200186439",Pants="rbxassetid://96110031810524"},
    LARANJA={Shirt="rbxassetid://132973270253302",Pants="rbxassetid://85172161335350"},
    ROXO={Shirt="rbxassetid://116808129640162",Pants="rbxassetid://139666428760490"},
    VERMELHA={Shirt="rbxassetid://80954367566093",Pants="rbxassetid://123817816516456"},
    BRANCA={Shirt="rbxassetid://111076753133496",Pants="rbxassetid://118418667305258"},
}
local JERSEY_PIJAMA={
    PRETA={Shirt="rbxassetid://73515737995241",Pants="rbxassetid://115411367769806"},
    LARANJA={Shirt="rbxassetid://73515737995241",Pants="rbxassetid://98261789486915"},
    ROXO={Shirt="rbxassetid://73515737995241",Pants="rbxassetid://84134229912519"},
    VERMELHA={Shirt="rbxassetid://73515737995241",Pants="rbxassetid://81837535879996"},
    BRANCA={Shirt="rbxassetid://73515737995241",Pants="rbxassetid://118575272229757"},
}
local JERSEY_CLASSIC={
    PRETA={Shirt="rbxassetid://112368798136022",Pants="rbxassetid://124438632183908"},
    LARANJA={Shirt="rbxassetid://79602504375071",Pants="rbxassetid://103369184802793"},
    ROXO={Shirt="rbxassetid://123441617925044",Pants="rbxassetid://103369184802793"},
    VERMELHA={Shirt="rbxassetid://79600316188348",Pants="rbxassetid://116577177642214"},
    BRANCA={Shirt="rbxassetid://116096773053478",Pants="rbxassetid://83350533401346"},
}
local JERSEY_SPARKLE={
    PRETA={Shirt="rbxassetid://79419126444394",Pants="rbxassetid://123015621765016"},
    LARANJA={Shirt="rbxassetid://90814817391229",Pants="rbxassetid://78131972193601"},
    ROXO={Shirt="rbxassetid://119109444404595",Pants="rbxassetid://137727739269710"},
    VERMELHA={Shirt="rbxassetid://88492680333870",Pants="rbxassetid://122028137354835"},
    BRANCA={Shirt="rbxassetid://101878166391387",Pants="rbxassetid://98723112188566"},
}

local function save_clothes()
    local c=LocalPlayer.Character; if not c then return end
    local s=c:FindFirstChildOfClass("Shirt"); local p=c:FindFirstChildOfClass("Pants")
    if not original_clothes.shirt then original_clothes.shirt=s and s.ShirtTemplate or "" end
    if not original_clothes.pants then original_clothes.pants=p and p.PantsTemplate or "" end
end
local function apply_clothes(sid,pid)
    local c=LocalPlayer.Character; if not c then return end
    save_clothes()
    local s=c:FindFirstChildOfClass("Shirt")
    local p=c:FindFirstChildOfClass("Pants")
    if not s then
        s=Instance.new("Shirt"); s.Parent=c
    end
    if not p then
        p=Instance.new("Pants"); p.Parent=c
    end
    s.ShirtTemplate=sid
    p.PantsTemplate=pid
end
local function restore_clothes()
    if jersey_conn then jersey_conn:Disconnect(); jersey_conn=nil end
    active_jersey=nil
    local c=LocalPlayer.Character; if not c then original_clothes={}; return end
    local s=c:FindFirstChildOfClass("Shirt"); local p=c:FindFirstChildOfClass("Pants")
    if s then
        if original_clothes.shirt and original_clothes.shirt~="" then
            s.ShirtTemplate=original_clothes.shirt
        else s:Destroy() end
    end
    if p then
        if original_clothes.pants and original_clothes.pants~="" then
            p.PantsTemplate=original_clothes.pants
        else p:Destroy() end
    end
    original_clothes={}
end
local function start_jersey(sid,pid,name)
    restore_clothes()
    active_jersey=name
    apply_clothes(sid,pid)
    if jersey_conn then jersey_conn:Disconnect() end
    jersey_conn=RunService.Heartbeat:Connect(function()
        if active_jersey~=name then return end
        local c=LocalPlayer.Character; if not c then return end
        local s=c:FindFirstChildOfClass("Shirt")
        if not s or s.ShirtTemplate~=sid then apply_clothes(sid,pid) end
    end)
end

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
assert(OrionLib, "[DRACO] Falha ao carregar Orion Library")

local Window = OrionLib:MakeWindow({
    Name         = "DRACO",
    HidePremium  = true,
    SaveConfig   = false,
    IntroEnabled = true,
    IntroText    = "DRACO",
})

-- ======== ABA COMBATE ========
local TabCombate = Window:MakeTab({ Name = "Combate", Icon = "rbxassetid://4483345998" })

TabCombate:AddSection({ Name = "Hitbox" })
TabCombate:AddToggle({ Name = "Hitbox", Default = false, Callback = function(v) G.HitboxEnabled=v; if not v then clear_hitboxes() end end })
TabCombate:AddSlider({ Name = "Tamanho da Hitbox", Min=1, Max=100, Default=1, Increment=1, ValueName="x", Callback = function(v) G.HitboxSize=v end })
TabCombate:AddSlider({ Name = "Transparencia Hitbox", Min=0, Max=9, Default=3, Increment=1, ValueName="/10", Callback = function(v) G.HitboxTransparency=v/10 end })

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
TabCombate:AddToggle({ Name = "Camera Jump [Espaco]", Default = false, Callback = function(v) G.CameraJump=v end })

-- ======== ABA VISUAL ========
local TabVisual = Window:MakeTab({ Name = "Visual", Icon = "rbxassetid://4483345998" })

TabVisual:AddSection({ Name = "ESP" })
TabVisual:AddToggle({ Name = "ESP", Default = false, Callback = function(v) G.ESPEnabled=v end })
TabVisual:AddToggle({ Name = "ESP Neon", Default = false, Callback = function(v) G.ESPNeon=v end })
TabVisual:AddSlider({ Name = "Tamanho ESP", Min=1, Max=30, Default=10, Increment=1, ValueName="", Callback = function(v) G.ESPLineSize=v end })

TabVisual:AddSection({ Name = "Efeitos" })
TabVisual:AddToggle({ Name = "FPS Boost",    Default = false, Callback = function(v) G.FPSBoost=v; apply_visuals() end })
TabVisual:AddToggle({ Name = "Modo Noturno", Default = false, Callback = function(v) G.NightMode=v; apply_visuals() end })
TabVisual:AddToggle({ Name = "Chao Cinza",   Default = false, Callback = function(v) G.GrayFloor=v; apply_visuals() end })
TabVisual:AddToggle({ Name = "Sem Sombras",  Default = false, Callback = function(v) G.NoShadows=v; apply_visuals() end })
TabVisual:AddColorpicker({ Name = "Cor Theme", Default = Color3.fromRGB(138,43,226), Callback = function(v) G.ThemeColor=v end })

-- ======== ABA JERSEYS ========
local TabJersey = Window:MakeTab({ Name = "Jerseys", Icon = "rbxassetid://4483345998" })
local TIMES = {"PRETA","LARANJA","ROXO","VERMELHA","BRANCA"}

TabJersey:AddSection({ Name = "Tuxedo" })
local tt="PRETA"
TabJersey:AddDropdown({ Name="Time Tuxedo", Default="PRETA", Options=TIMES, Callback=function(v) tt=v; if active_jersey=="tuxedo" then local d=JERSEY_TUXEDO[v]; start_jersey(d.Shirt,d.Pants,"tuxedo") end end })
TabJersey:AddToggle({ Name="Vestir Tuxedo", Default=false, Callback=function(v) if v then local d=JERSEY_TUXEDO[tt]; start_jersey(d.Shirt,d.Pants,"tuxedo") elseif active_jersey=="tuxedo" then restore_clothes() end end })

TabJersey:AddSection({ Name = "Dragon Tuxedo" })
local dt="PRETA"
TabJersey:AddDropdown({ Name="Time Dragao", Default="PRETA", Options=TIMES, Callback=function(v) dt=v; if active_jersey=="dragao" then local d=JERSEY_DRAGAO[v]; start_jersey(d.Shirt,d.Pants,"dragao") end end })
TabJersey:AddToggle({ Name="Vestir Dragon Tuxedo", Default=false, Callback=function(v) if v then local d=JERSEY_DRAGAO[dt]; start_jersey(d.Shirt,d.Pants,"dragao") elseif active_jersey=="dragao" then restore_clothes() end end })

TabJersey:AddSection({ Name = "Pijama" })
local pt="PRETA"
TabJersey:AddDropdown({ Name="Time Pijama", Default="PRETA", Options=TIMES, Callback=function(v) pt=v; if active_jersey=="pijama" then local d=JERSEY_PIJAMA[v]; start_jersey(d.Shirt,d.Pants,"pijama") end end })
TabJersey:AddToggle({ Name="Vestir Pijama", Default=false, Callback=function(v) if v then local d=JERSEY_PIJAMA[pt]; start_jersey(d.Shirt,d.Pants,"pijama") elseif active_jersey=="pijama" then restore_clothes() end end })

TabJersey:AddSection({ Name = "Classic" })
local ct="PRETA"
TabJersey:AddDropdown({ Name="Time Classic", Default="PRETA", Options=TIMES, Callback=function(v) ct=v; if active_jersey=="classic" then local d=JERSEY_CLASSIC[v]; start_jersey(d.Shirt,d.Pants,"classic") end end })
TabJersey:AddToggle({ Name="Vestir Classic", Default=false, Callback=function(v) if v then local d=JERSEY_CLASSIC[ct]; start_jersey(d.Shirt,d.Pants,"classic") elseif active_jersey=="classic" then restore_clothes() end end })

TabJersey:AddSection({ Name = "Sparkle Time" })
local st="PRETA"
TabJersey:AddDropdown({ Name="Time Sparkle", Default="PRETA", Options=TIMES, Callback=function(v) st=v; if active_jersey=="sparkle" then local d=JERSEY_SPARKLE[v]; start_jersey(d.Shirt,d.Pants,"sparkle") end end })
TabJersey:AddToggle({ Name="Vestir Sparkle Time", Default=false, Callback=function(v) if v then local d=JERSEY_SPARKLE[st]; start_jersey(d.Shirt,d.Pants,"sparkle") elseif active_jersey=="sparkle" then restore_clothes() end end })
TabJersey:AddButton({ Name="Remover Jersey", Callback=function() restore_clothes() end })

-- ======== ABA AUTO SPIN ========
local TabSpin = Window:MakeTab({ Name = "Auto Spin", Icon = "rbxassetid://4483345998" })
TabSpin:AddSection({ Name = "Recompensas" })
TabSpin:AddToggle({ Name="Auto Spin Style",      Default=false, Callback=function(v) G.AutoSpinStyle=v end })
TabSpin:AddToggle({ Name="Auto Spin Habilidade", Default=false, Callback=function(v) G.AutoSpinHabi=v  end })
TabSpin:AddToggle({ Name="Auto Yen",             Default=false, Callback=function(v) G.AutoYen=v       end })

-- ======== ABA MISC ========
local TabMisc = Window:MakeTab({ Name = "Misc", Icon = "rbxassetid://4483345998" })
TabMisc:AddSection({ Name = "Info" })
TabMisc:AddLabel("DRACO - Script Volleyball")
TabMisc:AddLabel("Criador: draco goat")
TabMisc:AddParagraph("Teclas", "F = Freeze | G = Leed Feat | L = Auto Long")

-- =====================
-- NOTIFICAÇÃO FINAL
-- =====================

OrionLib:MakeNotification({
    Name    = "DRACO",
    Content = "Script carregado! | Criador: draco goat",
    Image   = "rbxassetid://4483345998",
    Time    = 4
})

OrionLib:Init()
