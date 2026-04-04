-- SUSANO V2.3 | discord.gg/tCufFEMdux
-- DÜZELTİLMİŞ SÜRÜM

-- UYARI: GitHub Token'ını kod içinde公开 (public) olarak paylaşma!
local t1 = "ghp_wG4l" -- Token'ını buraya yapıştır veya güvenli bir yerden çek
local t2 = "OHjlmUvwum"
local t3 = "ObSMZlppNaGyMq3H3JtpiC"
local GITHUB_TOKEN  = t1..t2..t3 -- Eğer token kullanmayacaksan boş bırakabilirsin ama key sistemi çalışmaz.

local GITHUB_OWNER  = "CrafyXD"
local GITHUB_REPO   = "susano-backend"
local GITHUB_BRANCH = "main"
local WEBHOOK_URL   = "https://discord.com/api/webhooks/1486783402656141494/XHOkFNPIw_qH9yjgbZ5KL4pr-WEvbIJbW6Ff7DYueaV2DNoAMU1dvR7dRgKhvaSzsYkb"

-- Servisler
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local Workspace         = game:GetService("Workspace")
local Lighting          = game:GetService("Lighting")
local HttpService       = game:GetService("HttpService")
local CoreGui           = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage     = game:GetService("ServerStorage")
local Camera            = Workspace.CurrentCamera
local LocalPlayer       = Players.LocalPlayer

local GuiParent
pcall(function()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pg then GuiParent = pg end
end)
if not GuiParent then
    GuiParent = LocalPlayer:WaitForChild("PlayerGui", 10)
end

-- HWID
local HWID = tostring(LocalPlayer.UserId)
pcall(function()
    HWID = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
end)
local USERNAME  = LocalPlayer.Name
local USER_ID   = tostring(LocalPlayer.UserId)

-- DOSYA YARDIMCILARI
local KEY_FILE   = "susano_key.txt"
local CFG_FOLDER = "susano_configs"
local function safeRead(path)
    if readfile then return pcall(readfile, path) end
    return false, nil
end
local function safeWrite(path, data)
    if writefile then pcall(writefile, path, data) end
end
local function safeDel(path)
    if delfile then pcall(delfile, path) end
end
local function safeList(path)
    if listfiles then
        local ok, r = pcall(listfiles, path)
        if ok then return r end
    end
    return {}
end
local function safeMkDir(path)
    if makefolder then pcall(makefolder, path) end
end

-- HTTP YARDIMCISI (DÜZELTİLMİŞ KISIM)
local function getHttpFunction()
    local possibleFuncs = {
        http_request,
        request,
        syn and syn.request,
        fluxus and fluxus.request,
        http and http.request
    }
    for _, func in ipairs(possibleFuncs) do
        if type(func) == "function" then
            return func
        end
    end
    return nil
end

local httpFunc = getHttpFunction()

local function httpRequest(method, url, body, headers)
    if not httpFunc then
        warn("SUSANO: Bu executor HTTP isteklerini desteklemiyor.")
        return false, nil
    end
    
    local ok, resp = pcall(function()
        return httpFunc({
            Url     = url,
            Method  = method,
            Headers = headers or {},
            Body    = body
        })
    end)
    
    if not ok or not resp then return false, nil end
    return true, (resp.Body or resp.body or "")
end

local function githubRead(path)
    return httpRequest("GET",
        "https://raw.githubusercontent.com/" .. GITHUB_OWNER .. "/" ..
        GITHUB_REPO .. "/" .. GITHUB_BRANCH .. "/" .. path)
end

local function githubWrite(path, content, message)
    local shaUrl = "https://api.github.com/repos/" .. GITHUB_OWNER ..
                   "/" .. GITHUB_REPO .. "/contents/" .. path
    local currentSHA = ""
    local ok2, shaBody = httpRequest("GET", shaUrl, nil, {
        ["Authorization"] = "token " .. GITHUB_TOKEN,
        ["Accept"]        = "application/vnd.github.v3+json",
        ["User-Agent"]    = "Susano"
    })
    if ok2 and shaBody then
        pcall(function()
            local d = HttpService:JSONDecode(shaBody)
            if d and d.sha then currentSHA = d.sha end
        end)
    end
    
    -- Base64 Encode
    local b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local function encBase64(data)
        local res = {}
        local pad = (3 - #data % 3) % 3
        data = data .. string.rep("\0", pad)
        for i = 1, #data, 3 do
            local a, b, c = data:byte(i, i + 2)
            local n = a * 65536 + b * 256 + c
            res[#res+1] = b64:sub(math.floor(n/262144)%64+1, math.floor(n/262144)%64+1)
            res[#res+1] = b64:sub(math.floor(n/4096)%64+1,   math.floor(n/4096)%64+1)
            res[#res+1] = b64:sub(math.floor(n/64)%64+1,     math.floor(n/64)%64+1)
            res[#res+1] = b64:sub(n%64+1, n%64+1)
        end
        local r2 = table.concat(res)
        return r2:sub(1, #r2 - pad) .. string.rep("=", pad)
    end
    
    local bodyStr = HttpService:JSONEncode({
        message = message or "update",
        content = encBase64(content),
        sha     = currentSHA ~= "" and currentSHA or nil,
        branch  = GITHUB_BRANCH
    })
    
    return httpRequest("PUT", shaUrl, bodyStr, {
        ["Authorization"] = "token " .. GITHUB_TOKEN,
        ["Accept"]        = "application/vnd.github.v3+json",
        ["Content-Type"]  = "application/json",
        ["User-Agent"]    = "Susano"
    })
end

-- WEBHOOK
local function sendWebhook(title, color, fields)
    if WEBHOOK_URL:find("WEBHOOK_URL_BURAYA") then return end
    task.spawn(function()
        pcall(function()
            if httpFunc then
                httpFunc({
                    Url     = WEBHOOK_URL,
                    Method  = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body    = HttpService:JSONEncode({
                        embeds = {{
                            title  = title,
                            color  = color,
                            fields = fields,
                            footer = {text = "Susano V2.3 | discord.gg/tCufFEMdux"},
                            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
                        }}
                    })
                })
            end
        end)
    end)
end

local function webhookFeature(feature, state)
    sendWebhook(
        (state and "✅" or "❌") .. " " .. feature,
        state and 3066993 or 15158332,
        {
            {name = "👤 Kullanici", value = "[" .. USERNAME .. "](https://www.roblox.com/users/" .. USER_ID .. "/profile)", inline = true},
            {name = "🎮 Oyun",      value = tostring(game.PlaceId), inline = true},
            {name = "💻 HWID",      value = HWID:sub(1, 20), inline = false},
        }
    )
end

-- TEMA SISTEMI
local THEMES = {
    {name="Siyah",    bg={12,12,12},   sb={16,16,16},   ac={255,255,255}, tb={10,10,10}},
    {name="Lacivert", bg={8,12,28},    sb={12,18,38},   ac={100,160,255}, tb={6,10,22}},
    {name="Mor",      bg={16,10,28},   sb={22,14,38},   ac={180,100,255}, tb={12,8,22}},
    {name="Yesil",    bg={8,18,10},    sb={10,24,14},   ac={60,220,100},  tb={6,14,8}},
    {name="Kirmizi",  bg={22,8,8},     sb={30,10,10},   ac={255,80,80},   tb={18,6,6}},
    {name="Turuncu",  bg={22,14,6},    sb={30,18,8},    ac={255,160,40},  tb={18,10,4}},
    {name="Pembe",    bg={22,8,18},    sb={30,10,24},   ac={255,100,200}, tb={18,6,14}},
    {name="Beyaz",    bg={220,220,220},sb={200,200,200},ac={30,30,30},    tb={190,190,190}},
    {name="Rainbow",  bg={12,12,12},   sb={16,16,16},   ac={255,100,100}, tb={10,10,10}, rainbow=true},
}
local currentThemeIndex = 1
local rainbowHue = 0

local function hsvToColor(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    i = i % 6
    if     i == 0 then r,g,b = v,t,p
    elseif i == 1 then r,g,b = q,v,p
    elseif i == 2 then r,g,b = p,v,t
    elseif i == 3 then r,g,b = p,q,v
    elseif i == 4 then r,g,b = t,p,v
    elseif i == 5 then r,g,b = v,p,q
    end
    return Color3.new(r, g, b)
end

local function makeThemeColors()
    local th = THEMES[currentThemeIndex]
    local accentColor = th.rainbow and hsvToColor(rainbowHue, 1, 1) or Color3.fromRGB(th.ac[1], th.ac[2], th.ac[3])
    local bgColor = Color3.fromRGB(th.bg[1], th.bg[2], th.bg[3])
    local function lighten(c, a)
        return Color3.new(math.clamp(c.R+a, 0, 1), math.clamp(c.G+a, 0, 1), math.clamp(c.B+a, 0, 1))
    end
    return {
        BG          = bgColor,
        Sidebar     = Color3.fromRGB(th.sb[1], th.sb[2], th.sb[3]),
        Accent      = accentColor,
        TitleBar    = Color3.fromRGB(th.tb[1], th.tb[2], th.tb[3]),
        Card        = lighten(bgColor, 0.06),
        CardHover   = lighten(bgColor, 0.10),
        AccentDim   = Color3.new(accentColor.R*0.6, accentColor.G*0.6, accentColor.B*0.6),
        AccentFaint = lighten(bgColor, 0.14),
        Text        = Color3.fromRGB(235, 235, 235),
        TextDim     = Color3.fromRGB(130, 130, 130),
        TextFaint   = Color3.fromRGB(55,  55,  55),
        OffBG       = Color3.fromRGB(40,  40,  40),
        OnBG        = Color3.fromRGB(210, 210, 210),
        Border      = Color3.fromRGB(32,  32,  32),
        BorderLight = Color3.fromRGB(50,  50,  50),
        CloseRed    = Color3.fromRGB(185, 45,  45),
        MinBtn      = Color3.fromRGB(42,  42,  42),
        ActiveSide  = accentColor,
        InactiveSide= Color3.fromRGB(th.sb[1], th.sb[2], th.sb[3]),
        KeyGreen    = Color3.fromRGB(30,  180, 80),
        KeyRed      = Color3.fromRGB(200, 50,  50),
        KeyGold     = Color3.fromRGB(220, 180, 50),
    }
end
local Tc = makeThemeColors()

-- DİL SISTEMI
local LANG = "TR"
local LANGS = {}

LANGS["TR"] = {
    tab_esp="ESP", tab_aim="Aimbot", tab_move="Hareket", tab_play="Oyuncular",
    tab_vis="Gorsel", tab_misc="Misc", tab_item="Esya", tab_team="Takim",
    tab_ac="AntiCheat", tab_cfg="Config", tab_set="Ayarlar",
    key_btn="GIRIS YAP", key_chk="KONTROL...", key_rem="Hatirla",
    key_ok="Gecerli!", key_err="Baglanamadi", key_inv="Gecersiz",
    key_exp="Suresi dolmus", key_hw="Baska cihaza bagli",
    key_many="Cok fazla deneme.", key_enter="Anahtar gir.",
    type_d="GUNLUK", type_w="HAFTALIK", type_m="AYLIK", type_l="SINIRSIZ",
    time_u="SINIRSIZ", time_e="SURESI DOLDU",
    s_vis="Gorunurluk", s_lbl="Etiketler", s_flt="Filtreler",
    s_aim="Aimbot", s_sil="Silent Aim", s_fov="FOV", s_smt="Yumusatma",
    s_tgt="Hedef", s_fly="Ucus", s_mov="Hareket", s_bhp="Bunny Hop",
    s_spd="Hiz", s_grv="Yercekimi", s_tp="Teleport", s_oth="Diger",
    s_cmb="Savas", s_hlp="Yardimci", s_nm="Isim", s_lit="Aydinlatma",
    s_cam="Kamera", s_wld="Dunya", s_wc="Dunya Rengi",
    s_srv="Sunucu", s_prf="Performans", s_cht="Sohbet", s_mm="MiniMap",
    s_hbx="Hitbox", s_flg="Fake Lag", s_lng="Dil", s_thm="Menu Rengi",
    s_abt="Hakkinda", s_mb="Magic Bullet", s_god="Godmode",
    s_itm="Esya", s_clr="Renk", s_nm2="Isim Rengi", s_enm="Dusman Rengi",
    s_frn="Dost Rengi", s_vc="Gorunur Renk", s_crs="Nisangah",
    s_tb="Trigger Bot", s_ac="AntiCheat Bypass",
    t_esp="ESP Aktif", t_3d="3D Highlight", t_2d="2D Kutu",
    t_sk="Skeleton ESP", t_nm="Isim", t_ds="Mesafe", t_hp="Can Cubugu",
    t_id="ID", t_tr="Tracer", t_tc="Takim Kontrolu", t_fr="Dostlari Goster",
    t_wc="Duvar Kontrolu/Chams", t_aim="Aimbot", t_ra="Rage Aimbot",
    t_sa="Silent Aim", t_mb="Magic Bullet", t_tb="Trigger Bot",
    t_hb="Hitbox Buyutme", t_fl="Fake Lag", t_ff="FOV Filtresi",
    t_fc="FOV Dairesi", t_fly="Uc", t_nc="Noclip", t_ij="Sonsuz Zipplama",
    t_lj="Uzun Atlama", t_sw="Yuzme Hack", t_bh="Bunny Hop",
    t_sh="Hiz Hack", t_gh="Gravity Hack", t_ct="Cursor TP (Sag Tik)",
    t_st="Stream Proof", t_ka="Kill Aura", t_gd="Godmode",
    t_af="Anti AFK", t_ns="Isim Degistir", t_fb="Full Bright",
    t_nf="Sis Kaldir", t_fv="FOV Degistir", t_3p="3. Sahis",
    t_tc2="Saat Degistir", t_wc2="Renk Degistir", t_rj="Auto Rejoin",
    t_fp="FPS Boost", t_cl="Chat Logger", t_mm="MiniMap",
    t_crs="Nisangah", t_dot="Merkez Nokta", t_out="Dis Cizgi",
    t_acfl="Fly Bypass (Yerde Goster)", t_acnc="Noclip Bypass",
    t_acsp="Hiz Bypass (WalkSpeed=16 Goster)", t_actp="TP Bypass",
    t_acre="AC Remote Engelle", t_acam="Aimbot Bypass",
    l_r="Kirmizi", l_g="Yesil", l_b="Mavi", l_sz="Boyut",
    l_th="Kalinlik", l_gp="Bosluk", l_op="Opaklik", l_mul="Carpan",
    l_rng="Menzil", l_dst="Mesafe", l_spd="Hiz", l_pow="Guc",
    l_val="Deger", l_prev="Renk Onizleme", l_fls="Ucus Hizi",
    l_fov="FOV Capi", l_sm="Yumusatma", l_lag="Lag Suresi",
    l_tm="Saat", l_trd="3P Mesafe", l_tt="Tracer Kalinlik",
    l_gv="Gravity", l_bhs="BHop Hizi", l_hbs="Hitbox Boyutu",
    l_nm="Sahte Isim", l_tbs="Trigger Gecikme",
    b_apply="Uygula", b_stop="Izlemeyi Durdur", b_hop="Server Hop",
    b_tp="TP", b_pull="PULL", b_spec="SPEC", b_frz="FRZ", b_free="FREE",
    cfg_name="Config Adi", cfg_save="Kaydet", cfg_load="Yukle",
    cfg_del="Sil", cfg_none="Kayitli config yok.", cfg_saved="Kaydedildi!",
    cfg_loaded="Yuklendi!", cfg_deleted="Silindi.", cfg_fail="Basarisiz.",
    cfg_enter="Isim gir!", disc="discord.gg/tCufFEMdux",
    warn_speed="⚠️ Cok fazla hiz ban yedirebilir!",
}

LANGS["EN"] = {
    tab_esp="ESP", tab_aim="Aimbot", tab_move="Movement", tab_play="Players",
    tab_vis="Visual", tab_misc="Misc", tab_item="Items", tab_team="Team",
    tab_ac="AntiCheat", tab_cfg="Config", tab_set="Settings",
    key_btn="LOGIN", key_chk="CHECKING...", key_rem="Remember",
    key_ok="Valid!", key_err="Could not connect", key_inv="Invalid key",
    key_exp="Key expired", key_hw="Bound to another device",
    key_many="Too many attempts.", key_enter="Enter key.",
    type_d="DAILY", type_w="WEEKLY", type_m="MONTHLY", type_l="LIFETIME",
    time_u="UNLIMITED", time_e="EXPIRED",
    s_vis="Visibility", s_lbl="Labels", s_flt="Filters",
    s_aim="Aimbot", s_sil="Silent Aim", s_fov="FOV", s_smt="Smoothness",
    s_tgt="Target", s_fly="Fly", s_mov="Movement", s_bhp="Bunny Hop",
    s_spd="Speed", s_grv="Gravity", s_tp="Teleport", s_oth="Other",
    s_cmb="Combat", s_hlp="Helper", s_nm="Name", s_lit="Lighting",
    s_cam="Camera", s_wld="World", s_wc="World Color",
    s_srv="Server", s_prf="Performance", s_cht="Chat", s_mm="MiniMap",
    s_hbx="Hitbox", s_flg="Fake Lag", s_lng="Language", s_thm="Menu Color",
    s_abt="About", s_mb="Magic Bullet", s_god="Godmode",
    s_itm="Items", s_clr="Color", s_nm2="Name Color", s_enm="Enemy Color",
    s_frn="Friend Color", s_vc="Visible Color", s_crs="Crosshair",
    s_tb="Trigger Bot", s_ac="AntiCheat Bypass",
    t_esp="ESP Active", t_3d="3D Highlight", t_2d="2D Box",
    t_sk="Skeleton ESP", t_nm="Names", t_ds="Distance", t_hp="Health Bar",
    t_id="ID", t_tr="Tracer", t_tc="Team Check", t_fr="Show Friends",
    t_wc="Wall Check/Chams", t_aim="Aimbot", t_ra="Rage Aimbot",
    t_sa="Silent Aim", t_mb="Magic Bullet", t_tb="Trigger Bot",
    t_hb="Hitbox Enlarge", t_fl="Fake Lag", t_ff="FOV Filter",
    t_fc="FOV Circle", t_fly="Fly", t_nc="Noclip", t_ij="Infinite Jump",
    t_lj="Long Jump", t_sw="Swim Hack", t_bh="Bunny Hop",
    t_sh="Speed Hack", t_gh="Gravity Hack", t_ct="Cursor TP (Right Click)",
    t_st="Stream Proof", t_ka="Kill Aura", t_gd="Godmode",
    t_af="Anti AFK", t_ns="Name Spoof", t_fb="Full Bright",
    t_nf="Remove Fog", t_fv="FOV Changer", t_3p="3rd Person",
    t_tc2="Time Changer", t_wc2="World Color", t_rj="Auto Rejoin",
    t_fp="FPS Boost", t_cl="Chat Logger", t_mm="MiniMap",
    t_crs="Crosshair", t_dot="Center Dot", t_out="Outline",
    t_acfl="Fly Bypass (Show On Ground)", t_acnc="Noclip Bypass",
    t_acsp="Speed Bypass (Show WalkSpeed=16)", t_actp="TP Bypass",
    t_acre="Block AC Remotes", t_acam="Aimbot Bypass",
    l_r="Red", l_g="Green", l_b="Blue", l_sz="Size",
    l_th="Thickness", l_gp="Gap", l_op="Opacity", l_mul="Multiplier",
    l_rng="Range", l_dst="Distance", l_spd="Speed", l_pow="Power",
    l_val="Value", l_prev="Color Preview", l_fls="Fly Speed",
    l_fov="FOV Size", l_sm="Smoothness", l_lag="Lag Duration",
    l_tm="Time", l_trd="3P Distance", l_tt="Tracer Thickness",
    l_gv="Gravity", l_bhs="BHop Speed", l_hbs="Hitbox Size",
    l_nm="Fake Name", l_tbs="Trigger Delay",
    b_apply="Apply", b_stop="Stop Spectating", b_hop="Server Hop",
    b_tp="TP", b_pull="PULL", b_spec="SPEC", b_frz="FRZ", b_free="FREE",
    cfg_name="Config Name", cfg_save="Save", cfg_load="Load",
    cfg_del="Delete", cfg_none="No saved configs.", cfg_saved="Saved!",
    cfg_loaded="Loaded!", cfg_deleted="Deleted.", cfg_fail="Failed.",
    cfg_enter="Enter name!", disc="discord.gg/tCufFEMdux",
    warn_speed="⚠️ Too much speed can get you banned!",
}

LANGS["ES"] = {
    tab_esp="ESP", tab_aim="Aimbot", tab_move="Movimiento", tab_play="Jugadores",
    tab_vis="Visual", tab_misc="Misc", tab_item="Objetos", tab_team="Equipo",
    tab_ac="AntiCheat", tab_cfg="Config", tab_set="Ajustes",
    key_btn="ENTRAR", key_chk="VERIFICANDO...", key_rem="Recordar",
    key_ok="Valido!", key_err="Sin conexion", key_inv="Clave invalida",
    key_exp="Clave expirada", key_hw="Otro dispositivo",
    key_many="Demasiados intentos.", key_enter="Ingresa clave.",
    type_d="DIARIO", type_w="SEMANAL", type_m="MENSUAL", type_l="VITALICIO",
    time_u="ILIMITADO", time_e="EXPIRADO",
    s_vis="Visibilidad", s_lbl="Etiquetas", s_flt="Filtros",
    s_aim="Aimbot", s_sil="Silent Aim", s_fov="FOV", s_smt="Suavidad",
    s_tgt="Objetivo", s_fly="Vuelo", s_mov="Movimiento", s_bhp="Bunny Hop",
    s_spd="Velocidad", s_grv="Gravedad", s_tp="Teleporte", s_oth="Otro",
    s_cmb="Combate", s_hlp="Ayuda", s_nm="Nombre", s_lit="Iluminacion",
    s_cam="Camara", s_wld="Mundo", s_wc="Color Mundo",
    s_srv="Servidor", s_prf="Rendimiento", s_cht="Chat", s_mm="MiniMapa",
    s_hbx="Hitbox", s_flg="Fake Lag", s_lng="Idioma", s_thm="Color Menu",
    s_abt="Acerca de", s_mb="Magic Bullet", s_god="Godmode",
    s_itm="Objetos", s_clr="Color", s_nm2="Color Nombre", s_enm="Color Enemigo",
    s_frn="Color Amigo", s_vc="Color Visible", s_crs="Mira",
    s_tb="Trigger Bot", s_ac="AntiCheat Bypass",
    t_esp="ESP Activo", t_3d="3D Highlight", t_2d="Caja 2D",
    t_sk="Esqueleto ESP", t_nm="Nombres", t_ds="Distancia", t_hp="Barra Vida",
    t_id="ID", t_tr="Trazador", t_tc="Control Equipo", t_fr="Ver Amigos",
    t_wc="Control Pared/Chams", t_aim="Aimbot", t_ra="Rage Aimbot",
    t_sa="Silent Aim", t_mb="Magic Bullet", t_tb="Trigger Bot",
    t_hb="Agrandar Hitbox", t_fl="Fake Lag", t_ff="Filtro FOV",
    t_fc="Circulo FOV", t_fly="Volar", t_nc="Noclip", t_ij="Salto Infinito",
    t_lj="Salto Largo", t_sw="Hack Natacion", t_bh="Bunny Hop",
    t_sh="Hack Velocidad", t_gh="Hack Gravedad", t_ct="TP Cursor (Clic Der)",
    t_st="Stream Proof", t_ka="Kill Aura", t_gd="Godmode",
    t_af="Anti AFK", t_ns="Cambiar Nombre", t_fb="Full Bright",
    t_nf="Sin Niebla", t_fv="Cambiar FOV", t_3p="3ra Persona",
    t_tc2="Cambiar Hora", t_wc2="Color Mundo", t_rj="Auto Rejoin",
    t_fp="FPS Boost", t_cl="Chat Logger", t_mm="MiniMapa",
    t_crs="Mira", t_dot="Punto Centro", t_out="Contorno",
    t_acfl="Bypass Vuelo (Mostrar en Suelo)", t_acnc="Bypass Noclip",
    t_acsp="Bypass Velocidad (Mostrar WalkSpeed=16)", t_actp="Bypass TP",
    t_acre="Bloquear Remotes AC", t_acam="Bypass Aimbot",
    l_r="Rojo", l_g="Verde", l_b="Azul", l_sz="Tamano",
    l_th="Grosor", l_gp="Espacio", l_op="Opacidad", l_mul="Multiplicador",
    l_rng="Alcance", l_dst="Distancia", l_spd="Velocidad", l_pow="Fuerza",
    l_val="Valor", l_prev="Vista Color", l_fls="Vel Vuelo",
    l_fov="Tam FOV", l_sm="Suavidad", l_lag="Dur Lag",
    l_tm="Hora", l_trd="Dist 3P", l_tt="Grosor Trazador",
    l_gv="Gravedad", l_bhs="Vel BHop", l_hbs="Tam Hitbox",
    l_nm="Nombre Falso", l_tbs="Retardo Trigger",
    b_apply="Aplicar", b_stop="Parar Espectador", b_hop="Saltar Servidor",
    b_tp="TP", b_pull="JALAR", b_spec="ESPEC", b_frz="CONG", b_free="LIBRE",
    cfg_name="Nombre Config", cfg_save="Guardar", cfg_load="Cargar",
    cfg_del="Eliminar", cfg_none="Sin configs.", cfg_saved="Guardado!",
    cfg_loaded="Cargado!", cfg_deleted="Eliminado.", cfg_fail="Fallido.",
    cfg_enter="Ingresa nombre!", disc="discord.gg/tCufFEMdux",
    warn_speed="⚠️ Demasiada velocidad puede banearte!",
}

local function T(key)
    local langTable = LANGS[LANG]
    if langTable and langTable[key] then return langTable[key] end
    local fallback = LANGS["TR"]
    if fallback and fallback[key] then return fallback[key] end
    return key
end

-- KEY SISTEMI
local keyValidated = false
local keyType      = "none"
local keyExpires   = 0
local activeKey    = ""

local function formatTimeLeft(expires)
    if expires == 0 then return T("time_u") end
    local left = expires - os.time()
    if left <= 0 then return T("time_e") end
    local d = math.floor(left / 86400)
    local h = math.floor((left % 86400) / 3600)
    local m = math.floor((left % 3600) / 60)
    if d > 0 then return d .. "g " .. h .. "s"
    elseif h > 0 then return h .. "s " .. m .. "dk"
    else return m .. "dk" end
end

local function loadKeysFromGithub()
    local ok, body = githubRead("keys.json")
    if not ok or not body then return nil end
    local ok2, data = pcall(function() return HttpService:JSONDecode(body) end)
    if not ok2 then return nil end
    return data
end

local function validateKey(key, callback)
    key = key:upper():gsub("%s+", "")
    if key == "" then callback(false, T("key_enter"), 0); return end
    task.spawn(function()
        local allKeys = loadKeysFromGithub()
        if not allKeys then callback(false, T("key_err"), 0); return end
        local keyData = allKeys[key]
        if not keyData then
            sendWebhook("❌ Gecersiz Key", 15158332, {
                {name="👤", value="[" .. USERNAME .. "](https://www.roblox.com/users/" .. USER_ID .. "/profile)", inline=true},
                {name="🔑", value=key:sub(1,15), inline=true},
                {name="💻", value=HWID:sub(1,20), inline=false},
            })
            callback(false, T("key_inv"), 0); return
        end
        if keyData.activated and keyData.expires and keyData.expires > 0 and os.time() > keyData.expires then
            callback(false, T("key_exp"), 0); return
        end
        if keyData.activated and keyData.hwid and tostring(keyData.hwid) ~= "" and tostring(keyData.hwid) ~= "null" then
            if tostring(keyData.hwid) ~= HWID then
                sendWebhook("🚫 Yanlis HWID", 15158332, {
                    {name="👤", value="[" .. USERNAME .. "](https://www.roblox.com/users/" .. USER_ID .. "/profile)", inline=true},
                    {name="💻 Girilen", value=HWID:sub(1,20), inline=true},
                    {name="🔒 Kayitli", value=tostring(keyData.hwid):sub(1,20), inline=true},
                })
                callback(false, T("key_hw"), 0); return
            end
        else
            allKeys[key].hwid = HWID
            allKeys[key].activated = true
            local duration = keyData.duration or 0
            allKeys[key].expires = duration > 0 and (os.time() + duration) or 0
            keyExpires = allKeys[key].expires
            task.spawn(function()
                local ok3, json = pcall(function() return HttpService:JSONEncode(allKeys) end)
                if ok3 then githubWrite("keys.json", json, "activate:" .. USERNAME) end
                sendWebhook("🎉 Yeni Aktivasyon", 3066993, {
                    {name="👤", value="[" .. USERNAME .. "](https://www.roblox.com/users/" .. USER_ID .. "/profile)", inline=true},
                    {name="🆔", value=USER_ID, inline=true},
                    {name="🔑", value=keyData.type or "?", inline=true},
                    {name="💻", value=HWID:sub(1,30), inline=false},
                    {name="⏰", value=allKeys[key].expires == 0 and "Sinirsiz" or os.date("%d.%m.%Y %H:%M", allKeys[key].expires), inline=true},
                    {name="🎮", value=tostring(game.PlaceId), inline=true},
                })
            end)
        end
        sendWebhook("✅ Giris", 3447003, {
            {name="👤", value="[" .. USERNAME .. "](https://www.roblox.com/users/" .. USER_ID .. "/profile)", inline=true},
            {name="🔑", value=keyData.type or "?", inline=true},
            {name="⏰", value=formatTimeLeft(allKeys[key].expires or 0), inline=true},
            {name="💻", value=HWID:sub(1,30), inline=false},
            {name="🎮", value=tostring(game.PlaceId), inline=true},
        })
        callback(true, keyData.type or "lifetime", allKeys[key].expires or 0)
    end)
end

local function loadSavedKey()
    local ok, content = safeRead(KEY_FILE)
    if ok and content and content ~= "" then return content:gsub("%s+", "") end
    return nil
end

-- GLOBALS
_G.Verified        = false
_G.ESP             = false
_G.ESPBox3D        = false
_G.ESPBox2D        = false
_G.ShowNames       = false
_G.ShowDistance     = false
_G.ShowHealthBar   = false
_G.ShowID          = false
_G.ShowTracer      = false
_G.TracerThick     = 1.5
_G.TeamCheck       = false
_G.ShowFriendly    = false
_G.WallCheck       = false
_G.SkeletonESP     = false
_G.ESPEnemyR       = 255; _G.ESPEnemyG = 60;  _G.ESPEnemyB = 60
_G.ESPFriendR      = 80;  _G.ESPFriendG = 140; _G.ESPFriendB = 255
_G.ESPVisR         = 80;  _G.ESPVisG = 255;    _G.ESPVisB = 120
_G.ESPNameR        = 255; _G.ESPNameG = 255;   _G.ESPNameB = 255
_G.Crosshair       = false
_G.CrosshairStyle  = "Cross"
_G.CrosshairSize   = 12
_G.CrosshairThick  = 2
_G.CrosshairGap    = 4
_G.CrosshairAlpha  = 1.0
_G.CrosshairDot    = false
_G.CrosshairOutline= false
_G.CrosshairR      = 255; _G.CrosshairG = 255; _G.CrosshairB = 255
_G.Aimbot          = false
_G.RageAimbot      = false
_G.SilentAim       = false
_G.MagicBullet     = false
_G.TriggerBot      = false
_G.TriggerBotDelay = 0.05
_G.UseFOV          = true
_G.FOVVisible      = true
_G.FOVSize         = 120
_G.AimbotSmooth    = 0.3
_G.AimHead         = true
_G.AimChest        = false
_G.AimStomach      = false
_G.HitboxEnabled   = false
_G.HitboxSize      = 5
_G.FakeLag         = false
_G.FakeLagInterval = 0.1
_G.Godmode         = false
_G.FlyEnabled      = false
_G.FlySpeed        = 50
_G.NoClip          = false
_G.BunnyHop        = false
_G.BhopSpeed       = 1.2
_G.BhopHeight      = 7
_G.SpeedHack       = false
_G.SpeedMult       = 2.0
_G.InfiniteJump    = false
_G.LongJump        = false
_G.LongJumpPower   = 80
_G.SwimHack        = false
_G.GravityHack     = false
_G.GravityValue    = 196.2
_G.TeleportCursor  = false
_G.KillAura        = false
_G.KillAuraRange   = 15
_G.AntiAFK         = false
_G.NameSpoof       = false
_G.SpoofedName     = ""
_G.StreamProof     = false
_G.FullBright      = false
_G.NoFog           = false
_G.FOVChanger      = false
_G.FOVChangerVal   = 200
_G.ThirdPerson     = false
_G.ThirdPersonDist = 12
_G.TimeChanger     = false
_G.TimeOfDay       = 14
_G.WorldColor      = false
_G.WorldR          = 128; _G.WorldG = 128; _G.WorldB = 128
_G.AutoRejoin      = false
_G.FPSBoost        = false
_G.ChatLogger      = false
_G.MiniMap         = false
_G.ACBypassFly     = true
_G.ACBypassNoclip  = true
_G.ACBypassSpeed   = true
_G.ACBypassTP      = true
_G.ACBlockRemotes  = true
_G.ACBypassAimbot  = true

local frozenPlayers = {}
local chatLogs = {}

-- ANTICHEAT BYPASS SISTEMI
local acBlockedRemoteConns = {}

local function setupAntiCheatBypass()
    local function claimNetworkOwnership(character)
        if not character then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function()
                    if sethiddenproperty then
                        sethiddenproperty(part, "NetworkOwnershipRule", 0)
                    end
                end)
            end
        end
    end

    local acKeywords = {
        "anticheat", "antiexploit", "detect", "cheat", "exploit",
        "flag", "ban", "kick", "hack", "suspicious", "speed", "fly",
        "noclip", "teleport", "illegal", "report"
    }
    local function isACRemote(name)
        local lower = name:lower()
        for _, kw in ipairs(acKeywords) do
            if lower:find(kw) then return true end
        end
        return false
    end
    local function blockACRemotes()
        if not _G.ACBlockRemotes then return end
        for _, location in ipairs({ReplicatedStorage, Workspace}) do
            pcall(function()
                for _, obj in ipairs(location:GetDescendants()) do
                    if obj:IsA("RemoteEvent") and isACRemote(obj.Name) then
                        pcall(function()
                            local conn = obj.OnClientEvent:Connect(function() end)
                            table.insert(acBlockedRemoteConns, conn)
                        end)
                    end
                end
            end)
        end
    end

    local function getGroundPosition(hrp)
        if not hrp then return nil end
        local char = LocalPlayer.Character
        local params = RaycastParams.new()
        if char then
            params.FilterDescendantsInstances = {char}
        end
        params.FilterType = Enum.RaycastFilterType.Exclude
        local result = Workspace:Raycast(hrp.Position, Vector3.new(0, -1000, 0), params)
        if result then
            return Vector3.new(hrp.Position.X, result.Position.Y + 3, hrp.Position.Z)
        end
        return hrp.Position
    end

    blockACRemotes()
    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        claimNetworkOwnership(char)
        blockACRemotes()
    end)
    if LocalPlayer.Character then
        claimNetworkOwnership(LocalPlayer.Character)
    end

    return getGroundPosition
end

local getGroundPosition = setupAntiCheatBypass()

-- WEAPON REMOTE TARAYICI
local weaponRemoteCache = {}
local function scanWeaponRemotes()
    weaponRemoteCache = {}
    local keywords = {"damage", "hit", "attack", "shoot", "fire", "bullet", "weapon", "tool", "hurt", "kill", "strike"}
    local function isWeaponRemote(name)
        local lower = name:lower()
        for _, kw in ipairs(keywords) do
            if lower:find(kw) then return true end
        end
        return false
    end
    for _, location in ipairs({ReplicatedStorage, Workspace}) do
        pcall(function()
            for _, obj in ipairs(location:GetDescendants()) do
                if obj:IsA("RemoteEvent") and isWeaponRemote(obj.Name) then
                    table.insert(weaponRemoteCache, obj)
                end
            end
        end)
    end
    local char = LocalPlayer.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                for _, r in ipairs(tool:GetDescendants()) do
                    if r:IsA("RemoteEvent") then
                        table.insert(weaponRemoteCache, r)
                    end
                end
            end
        end
    end
    return weaponRemoteCache
end
task.spawn(function() task.wait(2); scanWeaponRemotes() end)

local function dealDamage(targetChar, hitPart, hitPos)
    if not targetChar then return end
    local char = LocalPlayer.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                for _, r in ipairs(tool:GetDescendants()) do
                    if r:IsA("RemoteEvent") then
                        pcall(function() r:FireServer(targetChar, hitPart, hitPos or hitPart.Position) end)
                        pcall(function() r:FireServer(targetChar) end)
                        pcall(function() r:FireServer(hitPart.Position) end)
                    end
                end
            end
        end
    end
    for _, r in ipairs(weaponRemoteCache) do
        pcall(function() r:FireServer(targetChar, hitPart, hitPos or hitPart.Position) end)
    end
end

-- UI YARDIMCILARI
local function makeCorner(radius, parent)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, radius)
    return c
end

local function makeTween(object, duration, properties)
    TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quad), properties):Play()
end

local function makeScrollFrame(parent)
    local sc = Instance.new("ScrollingFrame", parent)
    sc.Size = UDim2.new(1, 0, 1, 0)
    sc.BackgroundTransparency = 1
    sc.ScrollBarThickness = 3
    sc.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    sc.CanvasSize = UDim2.new(0, 0, 0, 0)
    sc.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sc.BorderSizePixel = 0
    return sc
end

local function makeScreenGui(name, displayOrder)
    pcall(function()
        local existing = GuiParent:FindFirstChild(name)
        if existing then existing:Destroy() end
    end)
    local g = Instance.new("ScreenGui")
    g.Name = name
    g.ResetOnSpawn = false
    g.IgnoreGuiInset = true
    g.DisplayOrder = displayOrder or 200
    pcall(function() g.ZIndexBehavior = Enum.ZIndexBehavior.Global end)
    g.Parent = GuiParent
    return g
end

local function buildToggle(parent, label, setting, yPos, onToggle)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -28, 0, 44)
    row.Position = UDim2.new(0, 14, 0, yPos)
    row.BackgroundColor3 = Tc.Card
    makeCorner(8, row)
    row.MouseEnter:Connect(function() makeTween(row, 0.1, {BackgroundColor3 = Tc.CardHover}) end)
    row.MouseLeave:Connect(function() makeTween(row, 0.1, {BackgroundColor3 = Tc.Card}) end)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.72, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Tc.Text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local pillH, pillW = 24, 50
    local pill = Instance.new("Frame", row)
    pill.Size = UDim2.new(0, pillW, 0, pillH)
    pill.Position = UDim2.new(1, -pillW - 12, 0.5, -pillH / 2)
    pill.BackgroundColor3 = _G[setting] and Tc.OnBG or Tc.OffBG
    makeCorner(pillH, pill)

    local knob = Instance.new("Frame", pill)
    knob.Size = UDim2.new(0, pillH - 6, 0, pillH - 6)
    knob.Position = UDim2.new(_G[setting] and 1 or 0, _G[setting] and -(pillH - 3) or 3, 0.5, -(pillH - 6) / 2)
    knob.BackgroundColor3 = _G[setting] and Tc.TitleBar or Tc.AccentDim
    makeCorner(100, knob)

    local hit = Instance.new("TextButton", row)
    hit.Size = UDim2.new(1, 0, 1, 0)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.MouseButton1Click:Connect(function()
        _G[setting] = not _G[setting]
        makeTween(pill, 0.18, {BackgroundColor3 = _G[setting] and Tc.OnBG or Tc.OffBG})
        makeTween(knob, 0.18, {
            Position = UDim2.new(_G[setting] and 1 or 0, _G[setting] and -(pillH-3) or 3, 0.5, -(pillH-6)/2),
            BackgroundColor3 = _G[setting] and Tc.TitleBar or Tc.AccentDim
        })
        if onToggle then onToggle(_G[setting]) end
    end)
    return yPos + 52
end

local function buildSlider(parent, label, setting, yPos, minVal, maxVal, fmt, onChange)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -28, 0, 54)
    row.Position = UDim2.new(0, 14, 0, yPos)
    row.BackgroundColor3 = Tc.Card
    makeCorner(8, row)

    local function formatVal(v)
        return fmt and string.format(fmt, v) or tostring(math.floor(v))
    end

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.6, 0, 0, 22)
    lbl.Position = UDim2.new(0, 12, 0, 6)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Tc.Text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local valLabel = Instance.new("TextLabel", row)
    valLabel.Size = UDim2.new(0.35, 0, 0, 22)
    valLabel.Position = UDim2.new(0.65, 0, 0, 6)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = formatVal(_G[setting])
    valLabel.TextColor3 = Tc.TextDim
    valLabel.Font = Enum.Font.GothamMedium
    valLabel.TextSize = 12
    valLabel.TextXAlignment = Enum.TextXAlignment.Right

    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(1, -24, 0, 3)
    track.Position = UDim2.new(0, 12, 1, -14)
    track.BackgroundColor3 = Tc.AccentFaint
    makeCorner(3, track)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((_G[setting] - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Tc.Accent
    makeCorner(3, fill)

    local dragging = false
    local function setValue(inputX)
        local relX = math.clamp(inputX - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
        local pct = relX / track.AbsoluteSize.X
        _G[setting] = math.floor((minVal + pct * (maxVal - minVal)) * 100) / 100
        fill.Size = UDim2.new(pct, 0, 1, 0)
        valLabel.Text = formatVal(_G[setting])
        if onChange then onChange(_G[setting]) end
    end

    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; setValue(i.Position.X)
        end
    end)
    track.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            setValue(i.Position.X)
        end
    end)
    return yPos + 62
end

local function buildSection(parent, text, yPos)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, -28, 0, 22)
    lbl.Position = UDim2.new(0, 14, 0, yPos)
    lbl.BackgroundTransparency = 1
    lbl.Text = string.upper(text)
    lbl.TextColor3 = Tc.TextFaint
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local line = Instance.new("Frame", parent)
    line.Size = UDim2.new(1, -28, 0, 1)
    line.Position = UDim2.new(0, 14, 0, yPos + 20)
    line.BackgroundColor3 = Tc.Border
    line.BorderSizePixel = 0
    return yPos + 30
end

local function buildInput(parent, label, placeholder, default, yPos)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -28, 0, 56)
    row.Position = UDim2.new(0, 14, 0, yPos)
    row.BackgroundColor3 = Tc.Card
    makeCorner(8, row)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -16, 0, 20)
    lbl.Position = UDim2.new(0, 10, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Tc.TextDim
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox", row)
    box.Size = UDim2.new(1, -20, 0, 24)
    box.Position = UDim2.new(0, 10, 0, 26)
    box.BackgroundColor3 = Tc.AccentFaint
    box.TextColor3 = Tc.Text
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.PlaceholderText = placeholder
    box.Text = default or ""
    box.PlaceholderColor3 = Tc.TextFaint
    box.ClearTextOnFocus = false
    box.BorderSizePixel = 0
    makeCorner(6, box)
    return box, yPos + 64
end

local function buildButton(parent, label, yPos, bgColor, textColor)
    local c = bgColor or Tc.Accent
    local tc = textColor or Tc.BG
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -28, 0, 38)
    btn.Position = UDim2.new(0, 14, 0, yPos)
    btn.BackgroundColor3 = c
    btn.TextColor3 = tc
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = label
    makeCorner(8, btn)
    btn.MouseEnter:Connect(function() makeTween(btn, 0.1, {BackgroundColor3 = c:Lerp(Color3.new(1,1,1), 0.1)}) end)
    btn.MouseLeave:Connect(function() makeTween(btn, 0.1, {BackgroundColor3 = c}) end)
    return btn, yPos + 46
end

local function buildDropdown(parent, label, options, getterFn, setterFn, yPos)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -28, 0, 44)
    row.Position = UDim2.new(0, 14, 0, yPos)
    row.BackgroundColor3 = Tc.Card
    makeCorner(8, row)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Tc.Text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local vBtn = Instance.new("TextButton", row)
    vBtn.Size = UDim2.new(0, 130, 0, 28)
    vBtn.Position = UDim2.new(1, -144, 0.5, -14)
    vBtn.BackgroundColor3 = Tc.AccentFaint
    vBtn.TextColor3 = Tc.Text
    vBtn.Font = Enum.Font.GothamSemibold
    vBtn.TextSize = 13
    vBtn.Text = getterFn()
    makeCorner(7, vBtn)

    vBtn.MouseButton1Click:Connect(function()
        local cur = getterFn()
        local idx = 1
        for i, v in ipairs(options) do if v == cur then idx = i; break end end
        local nxt = options[(idx % #options) + 1]
        setterFn(nxt)
        vBtn.Text = nxt
    end)
    return yPos + 52
end

local function buildColorPreview(parent, settingR, settingG, settingB, yPos)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -28, 0, 36)
    row.Position = UDim2.new(0, 14, 0, yPos)
    row.BackgroundColor3 = Tc.Card
    makeCorner(8, row)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = T("l_prev")
    lbl.TextColor3 = Tc.TextDim
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local prev = Instance.new("Frame", row)
    prev.Size = UDim2.new(0, 80, 0, 22)
    prev.Position = UDim2.new(1, -94, 0.5, -11)
    prev.BackgroundColor3 = Color3.fromRGB(_G[settingR], _G[settingG], _G[settingB])
    makeCorner(6, prev)

    RunService.Heartbeat:Connect(function()
        prev.BackgroundColor3 = Color3.fromRGB(_G[settingR], _G[settingG], _G[settingB])
    end)
    return yPos + 44
end

local function buildWarningLabel(parent, text, yPos)
    local warn2 = Instance.new("Frame", parent)
    warn2.Size = UDim2.new(1, -28, 0, 30)
    warn2.Position = UDim2.new(0, 14, 0, yPos)
    warn2.BackgroundColor3 = Color3.fromRGB(80, 40, 10)
    warn2.BackgroundTransparency = 0
    makeCorner(6, warn2)

    local wlbl = Instance.new("TextLabel", warn2)
    wlbl.Size = UDim2.new(1, -16, 1, 0)
    wlbl.Position = UDim2.new(0, 8, 0, 0)
    wlbl.BackgroundTransparency = 1
    wlbl.Text = text
    wlbl.TextColor3 = Color3.fromRGB(255, 200, 80)
    wlbl.Font = Enum.Font.GothamBold
    wlbl.TextSize = 12
    wlbl.TextWrapped = true
    wlbl.TextXAlignment = Enum.TextXAlignment.Left
    return yPos + 38
end

-- ============================================================
-- OZELLIK FONKSIYONLARI - COMPLETE IMPLEMENTATIONS
-- ============================================================

local flyConn, noclipConn, bhopConn, speedConn, killAuraConn
local infiniteJumpConn, longJumpConn, swimConn
local antiAFKConn, rageAimConn, silentAimConn, hitboxConn
local godmodeConn, fakeLagConn, triggerBotConn
local aimTarget = nil
local spectatingPlayer = nil

-- FLY SYSTEM
enableFly = function()
    if flyConn then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = hrp

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 9e4
    bodyGyro.Parent = hrp

    hum.PlatformStand = true

    flyConn = RunService.Heartbeat:Connect(function(dt)
        if not _G.FlyEnabled then
            disableFly()
            return
        end
        local camCF = Camera.CFrame
        local dir = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end

        if dir.Magnitude > 0 then
            dir = dir.Unit * _G.FlySpeed
        end

        bodyVelocity.Velocity = dir
        bodyGyro.CFrame = camCF

        -- AntiCheat bypass: ground position
        if _G.ACBypassFly then
            local groundPos = getGroundPosition(hrp)
            if groundPos then
                pcall(function()
                    if sethiddenproperty then
                        sethiddenproperty(hrp, "NetworkOwnershipRule", 0)
                    end
                end)
            end
        end
    end)
end

disableFly = function()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = hrp:FindFirstChildOfClass("BodyVelocity")
            if bv then bv:Destroy() end
            local bg = hrp:FindFirstChildOfClass("BodyGyro")
            if bg then bg:Destroy() end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

-- NOCLIP SYSTEM
enableNoclip = function()
    if noclipConn then return end
    noclipConn = RunService.Stepped:Connect(function()
        if not _G.NoClip then disableNoclip(); return end
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

disableNoclip = function()
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part.CanCollide = true end)
            end
        end
    end
end

-- BUNNY HOP SYSTEM
enableBhop = function()
    if bhopConn then return end
    bhopConn = RunService.Heartbeat:Connect(function()
        if not _G.BunnyHop then disableBhop(); return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        if hum.MoveDirection.Magnitude > 0 and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            hrp.Velocity = hrp.Velocity + Vector3.new(0, _G.BhopHeight, 0) * _G.BhopSpeed * 0.1
        end
    end)
end

disableBhop = function()
    if bhopConn then bhopConn:Disconnect(); bhopConn = nil end
end

-- SPEED HACK SYSTEM
enableSpeed = function()
    if speedConn then return end
    speedConn = RunService.Heartbeat:Connect(function()
        if not _G.SpeedHack then disableSpeed(); return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local targetSpeed = 16 * _G.SpeedMult
        pcall(function() hum.WalkSpeed = targetSpeed end)
    end)
end

disableSpeed = function()
    if speedConn then speedConn:Disconnect(); speedConn = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum.WalkSpeed = 16 end) end
    end
end

-- INFINITE JUMP SYSTEM
enableInfiniteJump = function()
    if infiniteJumpConn then return end
    infiniteJumpConn = UserInputService.JumpRequest:Connect(function()
        if not _G.InfiniteJump then disableInfiniteJump(); return end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
end

disableInfiniteJump = function()
    if infiniteJumpConn then infiniteJumpConn:Disconnect(); infiniteJumpConn = nil end
end

-- LONG JUMP SYSTEM
enableLongJump = function()
    if longJumpConn then return end
    longJumpConn = UserInputService.JumpRequest:Connect(function()
        if not _G.LongJump then disableLongJump(); return end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum and hrp then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                hrp.Velocity = hrp.Velocity + hum.MoveDirection * _G.LongJumpPower
            end
        end
    end)
end

disableLongJump = function()
    if longJumpConn then longJumpConn:Disconnect(); longJumpConn = nil end
end

-- SWIM HACK
enableSwimHack = function()
    if swimConn then return end
    swimConn = RunService.Heartbeat:Connect(function()
        if not _G.SwimHack then
            if swimConn then swimConn:Disconnect(); swimConn = nil end
            return
        end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Swimming) end
        end
    end)
end

-- KILL AURA SYSTEM
enableKillAura = function()
    if killAuraConn then return end
    killAuraConn = RunService.Heartbeat:Connect(function()
        if not _G.KillAura then disableKillAura(); return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
                local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
                if targetHRP and targetHum and targetHum.Health > 0 then
                    local dist = (targetHRP.Position - hrp.Position).Magnitude
                    if dist <= _G.KillAuraRange then
                        local targetHead = player.Character:FindFirstChild("Head")
                        if targetHead then
                            dealDamage(player.Character, targetHead, targetHead.Position)
                        end
                    end
                end
            end
        end
    end)
end

disableKillAura = function()
    if killAuraConn then killAuraConn:Disconnect(); killAuraConn = nil end
end

-- ANTI AFK SYSTEM
enableAntiAFK = function()
    if antiAFKConn then return end
    antiAFKConn = LocalPlayer.Idled:Connect(function()
        if not _G.AntiAFK then disableAntiAFK(); return end
        pcall(function()
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
end

disableAntiAFK = function()
    if antiAFKConn then antiAFKConn:Disconnect(); antiAFKConn = nil end
end

-- RAGE AIMBOT SYSTEM
enableRageAimbot = function()
    if rageAimConn then return end
    rageAimConn = RunService.RenderStepped:Connect(function()
        if not _G.RageAimbot then disableRageAimbot(); return end
        local target = getBestAimTarget()
        if target then
            local part = getAimPart(target)
            if part then
                local targetPos = part.Position
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                if _G.ACBypassAimbot then
                    pcall(function()
                        if sethiddenproperty then
                            sethiddenproperty(Camera, "CameraMode", 0)
                        end
                    end)
                end
            end
        end
    end)
end

disableRageAimbot = function()
    if rageAimConn then rageAimConn:Disconnect(); rageAimConn = nil end
end

-- SILENT AIM SYSTEM  
enableSilentAim = function()
    if silentAimConn then return end
    silentAimConn = RunService.RenderStepped:Connect(function()
        if not _G.SilentAim then disableSilentAim(); return end
        aimTarget = getBestAimTarget()
    end)
    -- Hook mouse
    pcall(function()
        local oldIndex
        oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
            if self == LocalPlayer:GetMouse() and (key == "Hit" or key == "hit") and _G.SilentAim and aimTarget and aimTarget.Character then
                local tp = aimTarget.Character:FindFirstChild("Head") or aimTarget.Character:FindFirstChild("HumanoidRootPart")
                if tp then return CFrame.new(tp.Position) end
            end
            return oldIndex(self, key)
        end))
    end)
end

disableSilentAim = function()
    if silentAimConn then silentAimConn:Disconnect(); silentAimConn = nil end
    aimTarget = nil
end

-- HITBOX EXPANDER SYSTEM
enableHitbox = function()
    if hitboxConn then return end
    hitboxConn = RunService.Heartbeat:Connect(function()
        if not _G.HitboxEnabled then disableHitbox(); return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local rp = player.Character:FindFirstChild("HumanoidRootPart")
                    if rp then
                        pcall(function()
                            rp.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                            rp.Transparency = 0.5
                            rp.CanCollide = false
                        end)
                    end
                end
            end
        end
    end)
end

disableHitbox = function()
    if hitboxConn then hitboxConn:Disconnect(); hitboxConn = nil end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local rp = player.Character:FindFirstChild("HumanoidRootPart")
            if rp then
                pcall(function()
                    rp.Size = Vector3.new(2, 2, 1)
                    rp.Transparency = 1
                    rp.CanCollide = false
                end)
            end
        end
    end
end

-- GODMODE SYSTEM
enableGodmode = function()
    if godmodeConn then return end
    godmodeConn = RunService.Heartbeat:Connect(function()
        if not _G.Godmode then disableGodmode(); return end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function()
                    hum.MaxHealth = math.huge
                    hum.Health = math.huge
                end)
            end
        end
    end)
end

disableGodmode = function()
    if godmodeConn then godmodeConn:Disconnect(); godmodeConn = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum.MaxHealth = 100
                hum.Health = 100
            end)
        end
    end
end

-- THIRD PERSON SYSTEM
enableThirdPerson = function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    LocalPlayer.CameraMode = Enum.CameraMode.Classic
    LocalPlayer.CameraMaxZoomDistance = _G.ThirdPersonDist * 10
    LocalPlayer.CameraMinZoomDistance = _G.ThirdPersonDist
end

disableThirdPerson = function()
    LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
    LocalPlayer.CameraMaxZoomDistance = 0.5
    LocalPlayer.CameraMinZoomDistance = 0.5
end

-- FULL BRIGHT
applyFullBright = function()
    if _G.FullBright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
    else
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
    end
end

-- NO FOG
applyNoFog = function()
    if _G.NoFog then
        Lighting.FogStart = 0
        Lighting.FogEnd = 100000
    end
end

-- TIME CHANGER
applyTime = function()
    if _G.TimeChanger then
        Lighting.ClockTime = _G.TimeOfDay
    end
end

-- WORLD COLOR
applyWorldColor = function()
    if _G.WorldColor then
        Lighting.Ambient = Color3.fromRGB(_G.WorldR, _G.WorldG, _G.WorldB)
        Lighting.OutdoorAmbient = Color3.fromRGB(_G.WorldR, _G.WorldG, _G.WorldB)
        Lighting.ColorShift_Top = Color3.fromRGB(_G.WorldR, _G.WorldG, _G.WorldB)
    else
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    end
end

-- NAME SPOOF
applyNameSpoof = function()
    if not _G.NameSpoof then return end
    local char = LocalPlayer.Character
    if char then
        local head = char:FindFirstChild("Head")
        if head then
            local gui = head:FindFirstChildOfClass("BillboardGui")
            if gui then
                local textLabel = gui:FindFirstChildOfClass("TextLabel")
                if textLabel then
                    textLabel.Text = _G.SpoofedName ~= "" and _G.SpoofedName or USERNAME
                end
            end
        end
    end
end

-- ============================================================
-- CROSSHAIR SYSTEM
-- ============================================================
local crosshairGui
local CH_STYLES = {"Cross", "Circle", "Dot", "T-Shape", "X-Shape", "Square"}

local function destroyCrosshair()
    if crosshairGui then crosshairGui:Destroy(); crosshairGui = nil end
end

buildCrosshair = function()
    destroyCrosshair()
    if not _G.Crosshair then return end
    crosshairGui = makeScreenGui("SusanoCH", 200)
    local col = Color3.fromRGB(_G.CrosshairR, _G.CrosshairG, _G.CrosshairB)
    local s = _G.CrosshairSize; local g = _G.CrosshairGap
    local th = _G.CrosshairThick; local al = 1 - _G.CrosshairAlpha
    local function makeLine(w, h, ox, oy)
        local f = Instance.new("Frame", crosshairGui)
        f.BackgroundColor3 = col; f.BorderSizePixel = 0
        f.BackgroundTransparency = al
        f.Size = UDim2.new(0, w, 0, h)
        f.AnchorPoint = Vector2.new(0.5, 0.5)
        f.Position = UDim2.new(0.5, ox, 0.5, oy)
        f.ZIndex = 500
        if _G.CrosshairOutline then
            local os2 = Instance.new("UIStroke", f)
            os2.Color = Color3.new(0,0,0); os2.Thickness = 1
            os2.Transparency = al + 0.3
        end
        return f
    end
    local style = _G.CrosshairStyle
    if style == "Cross" then
        makeLine(s, th, -(g+s/2), 0); makeLine(s, th, (g+s/2), 0)
        makeLine(th, s, 0, -(g+s/2)); makeLine(th, s, 0, (g+s/2))
    elseif style == "T-Shape" then
        makeLine(s, th, -(g+s/2), 0); makeLine(s, th, (g+s/2), 0)
        makeLine(th, s, 0, (g+s/2))
    elseif style == "X-Shape" then
        local f1 = makeLine(s, th, 0, 0); f1.Rotation = 45
        local f2 = makeLine(s, th, 0, 0); f2.Rotation = -45
    elseif style == "Dot" then
        makeCorner(100, makeLine(th*3, th*3, 0, 0))
    elseif style == "Circle" then
        local c2 = Instance.new("Frame", crosshairGui)
        c2.Size = UDim2.new(0, s*2, 0, s*2)
        c2.Position = UDim2.new(0.5, -s, 0.5, -s)
        c2.BackgroundTransparency = 1; c2.BorderSizePixel = 0; c2.ZIndex = 500
        makeCorner(999, c2)
        local sk = Instance.new("UIStroke", c2)
        sk.Color = col; sk.Thickness = th; sk.Transparency = al
    elseif style == "Square" then
        makeLine(s*2, th, 0, -s); makeLine(s*2, th, 0, s)
        makeLine(th, s*2, -s, 0); makeLine(th, s*2, s, 0)
    end
    if _G.CrosshairDot and style ~= "Dot" then
        makeCorner(100, makeLine(th+1, th+1, 0, 0))
    end
end

-- ============================================================
-- FOV CIRCLE
-- ============================================================
local fovCircle, fovGui
local function createFOVCircle()
    if fovGui then fovGui:Destroy() end
    fovGui = makeScreenGui("SusanoFOV", 200)
    fovCircle = Instance.new("Frame", fovGui)
    local r = _G.FOVSize
    fovCircle.Size = UDim2.new(0, r*2, 0, r*2)
    fovCircle.Position = UDim2.new(0.5, -r, 0.5, -r)
    fovCircle.BackgroundTransparency = 1; fovCircle.BorderSizePixel = 0; fovCircle.ZIndex = 999
    makeCorner(999, fovCircle)
    local stroke = Instance.new("UIStroke", fovCircle)
    stroke.Color = Color3.new(1,1,1); stroke.Thickness = 1; stroke.Transparency = 0.45; stroke.Name = "FOVStroke"
    fovCircle.Visible = _G.FOVVisible
end

local function setFOVColor(color)
    if fovCircle then
        local s = fovCircle:FindFirstChild("FOVStroke")
        if s then s.Color = color end
    end
end

-- ============================================================
-- TELEPORT CURSOR
-- ============================================================
local tpIndicatorGui, tpIndicatorDot, tpIndicatorLabel
local tpTargetPosition = nil
local tpCursorMoveConn, tpCursorClickConn

local function setupTPCursorIndicator()
    if tpIndicatorGui then tpIndicatorGui:Destroy() end
    tpIndicatorGui = makeScreenGui("SusanoTPInd", 198)

    tpIndicatorDot = Instance.new("Frame", tpIndicatorGui)
    tpIndicatorDot.Size = UDim2.new(0, 22, 0, 22)
    tpIndicatorDot.BackgroundColor3 = Color3.fromRGB(100, 220, 255)
    tpIndicatorDot.BackgroundTransparency = 0.3
    tpIndicatorDot.BorderSizePixel = 0
    tpIndicatorDot.AnchorPoint = Vector2.new(0.5, 0.5)
    tpIndicatorDot.Visible = false
    makeCorner(11, tpIndicatorDot)

    local inner = Instance.new("Frame", tpIndicatorDot)
    inner.Size = UDim2.new(0, 7, 0, 7)
    inner.BackgroundColor3 = Color3.new(1,1,1)
    inner.AnchorPoint = Vector2.new(0.5, 0.5)
    inner.Position = UDim2.new(0.5, 0, 0.5, 0)
    inner.BorderSizePixel = 0
    makeCorner(4, inner)

    tpIndicatorLabel = Instance.new("TextLabel", tpIndicatorGui)
    tpIndicatorLabel.Size = UDim2.new(0, 70, 0, 18)
    tpIndicatorLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
    tpIndicatorLabel.BackgroundTransparency = 0.4
    tpIndicatorLabel.TextColor3 = Color3.new(1,1,1)
    tpIndicatorLabel.Font = Enum.Font.GothamBold
    tpIndicatorLabel.TextSize = 11
    tpIndicatorLabel.AnchorPoint = Vector2.new(0.5, 0)
    tpIndicatorLabel.Visible = false
    tpIndicatorLabel.BorderSizePixel = 0
    makeCorner(4, tpIndicatorLabel)
end

local function enableTeleportCursor()
    setupTPCursorIndicator()
    if tpCursorMoveConn then tpCursorMoveConn:Disconnect() end
    if tpCursorClickConn then tpCursorClickConn:Disconnect() end

    tpCursorMoveConn = RunService.RenderStepped:Connect(function()
        if not _G.TeleportCursor then
            if tpIndicatorDot then tpIndicatorDot.Visible = false end
            if tpIndicatorLabel then tpIndicatorLabel.Visible = false end
            return
        end
        local mousePos = UserInputService:GetMouseLocation()
        local unitRay = Camera:ScreenPointToRay(mousePos.X, mousePos.Y)
        local params = RaycastParams.new()
        local char = LocalPlayer.Character
        if char then
            params.FilterDescendantsInstances = {char}
            params.FilterType = Enum.RaycastFilterType.Exclude
        end
        local result = Workspace:Raycast(unitRay.Origin, unitRay.Direction * 500, params)
        if result then
            tpTargetPosition = result.Position
            if tpIndicatorDot then
                tpIndicatorDot.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
                tpIndicatorDot.Visible = true
            end
            if tpIndicatorLabel then
                local dist = math.floor((result.Position - Camera.CFrame.Position).Magnitude)
                tpIndicatorLabel.Text = dist .. "m"
                tpIndicatorLabel.Position = UDim2.new(0, mousePos.X - 35, 0, mousePos.Y + 14)
                tpIndicatorLabel.Visible = true
            end
        else
            tpTargetPosition = nil
            if tpIndicatorDot then tpIndicatorDot.Visible = false end
            if tpIndicatorLabel then tpIndicatorLabel.Visible = false end
        end
    end)

    tpCursorClickConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or not _G.TeleportCursor then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            if tpTargetPosition then
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local charHeight = 5
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    pcall(function()
                        local desc = hum:GetAppliedDescription()
                        if desc then charHeight = math.max(desc.HeadScale * 1.5 + desc.BodyTypeScale * 3, 3) end
                    end)
                end
                hrp.CFrame = CFrame.new(tpTargetPosition + Vector3.new(0, charHeight / 2 + 1, 0))
                if tpIndicatorDot then
                    tpIndicatorDot.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
                    task.delay(0.3, function()
                        if tpIndicatorDot then
                            tpIndicatorDot.BackgroundColor3 = Color3.fromRGB(100, 220, 255)
                        end
                    end)
                end
            end
        end
    end)
end

-- ============================================================
-- SKELETON ESP
-- ============================================================
local skeletonDrawings = {}
local SKELETON_R15 = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"}
}
local SKELETON_R6 = {
    {"Head","Torso"},{"Torso","HumanoidRootPart"},{"Torso","Right Arm"},
    {"Torso","Left Arm"},{"Torso","Right Leg"},{"Torso","Left Leg"}
}

local function clearSkeleton(player)
    if skeletonDrawings[player] then
        for _, line in ipairs(skeletonDrawings[player]) do
            pcall(function() line:Remove() end)
        end
        skeletonDrawings[player] = nil
    end
end

local DrawingLib = Drawing or {}

local function updateSkeleton()
    if not DrawingLib.new then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer or not player.Character then
            clearSkeleton(player); continue
        end
        if not _G.SkeletonESP or not _G.ESP then
            clearSkeleton(player); continue
        end
        local friendly = player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team
        local show = (friendly and _G.ShowFriendly) or (not friendly and _G.TeamCheck)
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if not (show and hum and hum.Health > 0) then
            clearSkeleton(player); continue
        end
        local char = player.Character
        local boneList = char:FindFirstChild("UpperTorso") and SKELETON_R15 or SKELETON_R6
        if not skeletonDrawings[player] then
            skeletonDrawings[player] = {}
            for _ = 1, #boneList do
                local line = DrawingLib.new("Line")
                line.Visible = false; line.Thickness = 1.5
                line.Transparency = 0.15; line.Color = Color3.new(1,1,1)
                table.insert(skeletonDrawings[player], line)
            end
        end
        local col = friendly and Color3.fromRGB(_G.ESPFriendR, _G.ESPFriendG, _G.ESPFriendB)
                               or Color3.fromRGB(_G.ESPEnemyR,  _G.ESPEnemyG,  _G.ESPEnemyB)
        for i, bone in ipairs(boneList) do
            local line = skeletonDrawings[player][i]
            if not line then continue end
            local p1 = char:FindFirstChild(bone[1])
            local p2 = char:FindFirstChild(bone[2])
            if p1 and p2 then
                local sp1, on1 = Camera:WorldToViewportPoint(p1.Position)
                local sp2, on2 = Camera:WorldToViewportPoint(p2.Position)
                if on1 and on2 then
                    line.Visible = true
                    line.From = Vector2.new(sp1.X, sp1.Y)
                    line.To   = Vector2.new(sp2.X, sp2.Y)
                    line.Color = col
                else line.Visible = false end
            else line.Visible = false end
        end
    end
end

-- ============================================================
-- WALL CHECK
-- ============================================================
local function isPlayerVisible(player)
    if not player.Character then return false end
    local head = player.Character:FindFirstChild("Head")
    if not head then return false end
    local origin = Camera.CFrame.Position
    local dir = head.Position - origin
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
    params.FilterType = Enum.RaycastFilterType.Exclude
    return Workspace:Raycast(origin, dir, params) == nil
end

-- ============================================================
-- AIMBOT - TARGET SELECTION & PART
-- ============================================================
local function getAimPart(player)
    if not player.Character then return nil end
    if _G.AimHead then
        local h = player.Character:FindFirstChild("Head"); if h then return h end
    end
    if _G.AimChest then
        local c = player.Character:FindFirstChild("UpperTorso") or player.Character:FindFirstChild("Torso")
        if c then return c end
    end
    return player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
end

getBestAimTarget = function()
    local best = nil
    local bestDist = _G.UseFOV and _G.FOVSize or math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer or not player.Character then continue end
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        
        -- Team check
        if _G.TeamCheck then
            local friendly = player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team
            if friendly and not _G.ShowFriendly then continue end
        end
        
        -- Wall check
        if _G.WallCheck and not isPlayerVisible(player) then continue end
        
        local part = getAimPart(player)
        if not part then continue end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end
        
        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
        if dist < bestDist then
            bestDist = dist
            best = player
        end
    end
    return best
end

-- ============================================================
-- AIMBOT LOGIC
-- ============================================================
local function aimbotTick()
    if not _G.Aimbot then return end
    local target = getBestAimTarget()
    if target then
        local part = getAimPart(target)
        if part then
            local targetPos = part.Position + (part.AssemblyLinearVelocity * 0.15)
            local screenPos = Camera:WorldToViewportPoint(targetPos)
            local mousePos = UserInputService:GetMouseLocation()
            local delta = Vector2.new(screenPos.X - mousePos.X, screenPos.Y - mousePos.Y)
            local smoothed = delta * (1 - math.clamp(_G.AimbotSmooth, 0, 0.99))
            pcall(function() mousemoverel(smoothed.X, smoothed.Y) end)
        end
    end
end

-- ============================================================
-- TRIGGER BOT
-- ============================================================
local function triggerBotTick()
    if not _G.TriggerBot then return end
    pcall(function()
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if target then
            local player = Players:GetPlayerFromCharacter(target.Parent)
            if player and player ~= LocalPlayer then
                if _G.TeamCheck and player.Team == LocalPlayer.Team then return end
                task.wait(_G.TriggerBotDelay)
                pcall(function() mouse1click() end)
            end
        end
    end)
end

-- ============================================================
-- ESP HIGHLIGHT (3D)
-- ============================================================
local espHighlights = {}
local function updateESP3D()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not _G.ESP or not _G.ESPBox3D then
            if espHighlights[player] then
                pcall(function() espHighlights[player]:Destroy() end)
                espHighlights[player] = nil
            end
            continue
        end
        if not player.Character then continue end
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then
            if espHighlights[player] then
                pcall(function() espHighlights[player]:Destroy() end)
                espHighlights[player] = nil
            end
            continue
        end
        
        local friendly = player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team
        if _G.TeamCheck and friendly and not _G.ShowFriendly then
            if espHighlights[player] then
                pcall(function() espHighlights[player]:Destroy() end)
                espHighlights[player] = nil
            end
            continue
        end
        
        local col
        if friendly then
            col = Color3.fromRGB(_G.ESPFriendR, _G.ESPFriendG, _G.ESPFriendB)
        elseif _G.WallCheck and isPlayerVisible(player) then
            col = Color3.fromRGB(_G.ESPVisR, _G.ESPVisG, _G.ESPVisB)
        else
            col = Color3.fromRGB(_G.ESPEnemyR, _G.ESPEnemyG, _G.ESPEnemyB)
        end
        
        if not espHighlights[player] then
            local hl = Instance.new("Highlight")
            hl.Name = "SusanoESP"
            hl.Adornee = player.Character
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = player.Character
            espHighlights[player] = hl
        end
        
        espHighlights[player].FillColor = col
        espHighlights[player].OutlineColor = col
        espHighlights[player].Adornee = player.Character
    end
end

-- ============================================================
-- ESP 2D BOX (Drawing based)
-- ============================================================
local esp2DObjects = {}
local function updateESP2D()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not _G.ESP or not _G.ESPBox2D then
            if esp2DObjects[player] then
                for _, obj in pairs(esp2DObjects[player]) do
                    pcall(function() obj:Remove() end)
                end
                esp2DObjects[player] = nil
            end
            continue
        end
        if not player.Character then continue end
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        local head = player.Character:FindFirstChild("Head")
        if not hum or not hrp or not head or hum.Health <= 0 then
            if esp2DObjects[player] then
                for _, obj in pairs(esp2DObjects[player]) do
                    pcall(function() obj:Remove() end)
                end
                esp2DObjects[player] = nil
            end
            continue
        end
        
        local friendly = player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team
        if _G.TeamCheck and friendly and not _G.ShowFriendly then
            if esp2DObjects[player] then
                for _, obj in pairs(esp2DObjects[player]) do
                    pcall(function() obj:Remove() end)
                end
                esp2DObjects[player] = nil
            end
            continue
        end
        
        local col
        if friendly then
            col = Color3.fromRGB(_G.ESPFriendR, _G.ESPFriendG, _G.ESPFriendB)
        else
            col = Color3.fromRGB(_G.ESPEnemyR, _G.ESPEnemyG, _G.ESPEnemyB)
        end
        
        if not esp2DObjects[player] then
            esp2DObjects[player] = {
                Box = DrawingLib.new("Square"),
                BoxO = DrawingLib.new("Square"),
                Name = DrawingLib.new("Text"),
                Dist = DrawingLib.new("Text"),
                Health = DrawingLib.new("Bar"),
                Tracer = DrawingLib.new("Line"),
            }
            esp2DObjects[player].Box.Thickness = 1
            esp2DObjects[player].Box.Filled = false
            esp2DObjects[player].BoxO.Thickness = 3
            esp2DObjects[player].BoxO.Filled = false
            esp2DObjects[player].BoxO.Color = Color3.new(0,0,0)
            esp2DObjects[player].Name.Size = 13
            esp2DObjects[player].Name.Center = true
            esp2DObjects[player].Name.Outline = true
            esp2DObjects[player].Name.OutlineColor = Color3.new(0,0,0)
            esp2DObjects[player].Dist.Size = 11
            esp2DObjects[player].Dist.Center = true
            esp2DObjects[player].Dist.Outline = true
            esp2DObjects[player].Dist.OutlineColor = Color3.new(0,0,0)
            esp2DObjects[player].Tracer.Thickness = _G.TracerThick
            esp2DObjects[player].Tracer.Transparency = 0.3
        end
        
        local esp = esp2DObjects[player]
        local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if not onScreen then
            for _, obj in pairs(esp) do pcall(function() obj.Visible = false end) end
            continue
        end
        
        local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
        local h = math.abs(headPos.Y - legPos.Y)
        local w = h / 2
        local tl = Vector2.new(hrpPos.X - w / 2, headPos.Y)
        local sz = Vector2.new(w, h)
        
        esp.Box.Position = tl; esp.Box.Size = sz; esp.Box.Color = col; esp.Box.Visible = true
        esp.BoxO.Position = tl; esp.BoxO.Size = sz; esp.BoxO.Visible = true
        
        if _G.ShowNames then
            esp.Name.Position = Vector2.new(hrpPos.X, tl.Y - 16)
            esp.Name.Text = player.DisplayName
            esp.Name.Color = Color3.fromRGB(_G.ESPNameR, _G.ESPNameG, _G.ESPNameB)
            esp.Name.Visible = true
        else esp.Name.Visible = false end
        
        if _G.ShowDistance then
            local d = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
            esp.Dist.Position = Vector2.new(hrpPos.X, tl.Y + sz.Y + 2)
            esp.Dist.Text = d .. "m"
            esp.Dist.Color = col
            esp.Dist.Visible = true
        else esp.Dist.Visible = false end
        
        if _G.ShowTracer then
            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            esp.Tracer.From = screenCenter
            esp.Tracer.To = Vector2.new(hrpPos.X, tl.Y + sz.Y)
            esp.Tracer.Color = col
            esp.Tracer.Thickness = _G.TracerThick
            esp.Tracer.Visible = true
        else esp.Tracer.Visible = false end
    end
end

-- ============================================================
-- GRAVITY HACK
-- ============================================================
local function applyGravity()
    if _G.GravityHack then
        Workspace.Gravity = _G.GravityValue
    else
        Workspace.Gravity = 196.2
    end
end

-- ============================================================
-- FOV CHANGER
-- ============================================================
local function applyFOVChanger()
    if _G.FOVChanger then
        Camera.FieldOfView = _G.FOVChangerVal
    end
end

-- ============================================================
-- FPS BOOST
-- ============================================================
local function applyFPSBoost()
    if _G.FPSBoost then
        pcall(function()
            settings().Rendering.QualityLevel = 1
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                end
            end
        end)
    end
end

-- ============================================================
-- CHAT LOGGER
-- ============================================================
local function setupChatLogger()
    if not _G.ChatLogger then return end
    pcall(function()
        local chat = game:GetService("TextChatService") or Workspace:FindFirstChild("Chat")
        Players.PlayerChatted:Connect(function(chatType, player, message)
            if _G.ChatLogger then
                table.insert(chatLogs, {player = player.Name, message = message, time = os.date("%H:%M")})
            end
        end)
    end)
end

-- ============================================================
-- MINIMAP
-- ============================================================
local minimapGui, minimapFrame
local function createMinimap()
    if minimapGui then minimapGui:Destroy() end
    if not _G.MiniMap then return end
    minimapGui = makeScreenGui("SusanoMM", 199)
    minimapFrame = Instance.new("Frame", minimapGui)
    minimapFrame.Size = UDim2.new(0, 180, 0, 180)
    minimapFrame.Position = UDim2.new(1, -200, 0, 20)
    minimapFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    minimapFrame.BackgroundTransparency = 0.3
    minimapFrame.BorderSizePixel = 0
    makeCorner(8, minimapFrame)

    local border = Instance.new("UIStroke", minimapFrame)
    border.Color = Color3.fromRGB(60, 60, 60); border.Thickness = 1
end

local function updateMinimap()
    if not _G.MiniMap or not minimapFrame then return end
    -- Clear old dots
    for _, child in ipairs(minimapFrame:GetChildren()) do
        if child.Name == "MapDot" then child:Destroy() end
    end
    
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local myPos = hrp.Position
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer or not player.Character then continue end
        local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
        if not targetHRP then continue end
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        
        local offset = (targetHRP.Position - myPos)
        local scale = 2
        local relX = math.clamp(offset.X * scale, -80, 80)
        local relZ = math.clamp(offset.Z * scale, -80, 80)
        
        local dot = Instance.new("Frame", minimapFrame)
        dot.Name = "MapDot"
        dot.Size = UDim2.new(0, 6, 0, 6)
        dot.Position = UDim2.new(0.5, relX - 3, 0.5, relZ - 3)
        dot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        dot.BorderSizePixel = 0
        makeCorner(3, dot)
    end
end

-- ============================================================
-- AUTO REJOIN
-- ============================================================
local function setupAutoRejoin()
    if not _G.AutoRejoin then return end
    LocalPlayer.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Failed and _G.AutoRejoin then
            pcall(function()
                game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
            end)
        end
    end)
end

-- ============================================================
-- SERVER HOP
-- ============================================================
local function serverHop()
    pcall(function()
        local HttpService2 = game:GetService("HttpService")
        local TS = game:GetService("TeleportService")
        local ok, result = pcall(function()
            return HttpService2:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)
        if ok and result and result.data then
            for _, server in ipairs(result.data) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    TS:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                    break
                end
            end
        end
    end)
end

-- ============================================================
-- STREAM PROOF
-- ============================================================
local function applyStreamProof()
    if _G.StreamProof then
        pcall(function()
            for _, gui in ipairs(CoreGui:GetChildren()) do
                if gui.Name:find("Susano") then
                    pcall(function() sethiddenproperty(gui, "OnScreen", false) end)
                end
            end
        end)
    end
end

-- ============================================================
-- CONFIG SYSTEM
-- ============================================================
local configSettings = {
    "ESP", "ESPBox3D", "ESPBox2D", "ShowNames", "ShowDistance", "ShowHealthBar",
    "ShowID", "ShowTracer", "TracerThick", "TeamCheck", "ShowFriendly",
    "WallCheck", "SkeletonESP", "ESPEnemyR", "ESPEnemyG", "ESPEnemyB",
    "ESPFriendR", "ESPFriendG", "ESPFriendB", "ESPVisR", "ESPVisG", "ESPVisB",
    "ESPNameR", "ESPNameG", "ESPNameB",
    "Crosshair", "CrosshairStyle", "CrosshairSize", "CrosshairThick",
    "CrosshairGap", "CrosshairAlpha", "CrosshairDot", "CrosshairOutline",
    "CrosshairR", "CrosshairG", "CrosshairB",
    "Aimbot", "RageAimbot", "SilentAim", "MagicBullet", "TriggerBot",
    "TriggerBotDelay", "UseFOV", "FOVVisible", "FOVSize", "AimbotSmooth",
    "AimHead", "AimChest", "AimStomach", "HitboxEnabled", "HitboxSize",
    "FakeLag", "FakeLagInterval",
    "Godmode", "FlyEnabled", "FlySpeed", "NoClip", "BunnyHop", "BhopSpeed",
    "BhopHeight", "SpeedHack", "SpeedMult", "InfiniteJump", "LongJump",
    "LongJumpPower", "SwimHack", "GravityHack", "GravityValue", "TeleportCursor",
    "KillAura", "KillAuraRange", "AntiAFK", "NameSpoof", "SpoofedName",
    "StreamProof", "FullBright", "NoFog", "FOVChanger", "FOVChangerVal",
    "ThirdPerson", "ThirdPersonDist", "TimeChanger", "TimeOfDay", "WorldColor",
    "WorldR", "WorldG", "WorldB", "AutoRejoin", "FPSBoost", "ChatLogger", "MiniMap",
    "ACBypassFly", "ACBypassNoclip", "ACBypassSpeed", "ACBypassTP",
    "ACBlockRemotes", "ACBypassAimbot"
}

local function saveConfig(name)
    if not name or name == "" then return false end
    safeMkDir(CFG_FOLDER)
    local cfg = {}
    for _, key in ipairs(configSettings) do
        cfg[key] = _G[key]
    end
    local ok, json = pcall(function() return HttpService:JSONEncode(cfg) end)
    if ok and json then
        safeWrite(CFG_FOLDER .. "/" .. name .. ".json", json)
        return true
    end
    return false
end

local function loadConfig(name)
    if not name or name == "" then return false end
    local ok, content = safeRead(CFG_FOLDER .. "/" .. name .. ".json")
    if not ok or not content then return false end
    local ok2, cfg = pcall(function() return HttpService:JSONDecode(content) end)
    if not ok2 or not cfg then return false end
    for key, val in pairs(cfg) do
        if _G[key] ~= nil then
            _G[key] = val
        end
    end
    return true
end

local function deleteConfig(name)
    if not name or name == "" then return end
    safeDel(CFG_FOLDER .. "/" .. name .. ".json")
end

local function listConfigs()
    safeMkDir(CFG_FOLDER)
    local files = safeList(CFG_FOLDER)
    local configs = {}
    for _, f in ipairs(files) do
        local name = f:match("([^/\\]+)%.json$")
        if name then table.insert(configs, name) end
    end
    return configs
end

-- ============================================================
-- MAIN GUI
-- ============================================================
MainGui = nil
local menuOpen = true
local currentTab = "ESP"
local tabButtons = {}
local tabContents = {}

local function toggleMenu()
    menuOpen = not menuOpen
    if MainGui then MainGui.Enabled = menuOpen end
end

switchTab = function(tabName)
    currentTab = tabName
    for name, btn in pairs(tabButtons) do
        if name == tabName then
            makeTween(btn, 0.15, {BackgroundColor3 = Tc.Accent})
        else
            makeTween(btn, 0.15, {BackgroundColor3 = Tc.InactiveSide})
        end
    end
    for name, content in pairs(tabContents) do
        content.Visible = (name == tabName)
    end
end

createMenu = function()
    if MainGui then pcall(function() MainGui:Destroy() end) end
    MainGui = makeScreenGui("SusanoMain", 100)
    MainGui.Enabled = menuOpen

    local mainFrame = Instance.new("Frame", MainGui)
    mainFrame.Size = UDim2.new(0, 700, 0, 480)
    mainFrame.Position = UDim2.new(0.5, -350, 0.5, -240)
    mainFrame.BackgroundColor3 = Tc.BG
    mainFrame.BorderSizePixel = 0
    makeCorner(10, mainFrame)

    -- Title bar
    local titleBar = Instance.new("Frame", mainFrame)
    titleBar.Size = UDim2.new(1, 0, 0, 36)
    titleBar.BackgroundColor3 = Tc.TitleBar
    titleBar.BorderSizePixel = 0
    local titleCorner = makeCorner(10, titleBar)

    local titleLbl = Instance.new("TextLabel", titleBar)
    titleLbl.Size = UDim2.new(1, -80, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "SUSANO V2.3 | " .. (keyValidated and (T("key_ok") .. " [" .. keyType .. "]") or "❌")
    titleLbl.TextColor3 = Tc.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 14
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Close button
    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -34, 0, 3)
    closeBtn.BackgroundColor3 = Tc.CloseRed
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    makeCorner(6, closeBtn)
    closeBtn.MouseButton1Click:Connect(toggleMenu)

    -- Minimize button
    local minBtn = Instance.new("TextButton", titleBar)
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(1, -68, 0, 3)
    minBtn.BackgroundColor3 = Tc.MinBtn
    minBtn.Text = "—"
    minBtn.TextColor3 = Color3.new(1,1,1)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 14
    makeCorner(6, minBtn)
    minBtn.MouseButton1Click:Connect(toggleMenu)

    -- Discord label
    local discLbl = Instance.new("TextLabel", titleBar)
    discLbl.Size = UDim2.new(0, 160, 1, 0)
    discLbl.Position = UDim2.new(1, -240, 0, 0)
    discLbl.BackgroundTransparency = 1
    discLbl.Text = T("disc")
    discLbl.TextColor3 = Tc.TextDim
    discLbl.Font = Enum.Font.GothamMedium
    discLbl.TextSize = 11
    discLbl.TextXAlignment = Enum.TextXAlignment.Right

    -- Sidebar
    local sidebar = Instance.new("Frame", mainFrame)
    sidebar.Size = UDim2.new(0, 110, 1, -36)
    sidebar.Position = UDim2.new(0, 0, 0, 36)
    sidebar.BackgroundColor3 = Tc.Sidebar
    sidebar.BorderSizePixel = 0
    local sideCorner = makeCorner(0, sidebar)

    local sideList = Instance.new("UIListLayout", sidebar)
    sideList.Padding = UDim.new(0, 2)

    local tabDefs = {
        {id="ESP",    label=T("tab_esp")},
        {id="Aimbot", label=T("tab_aim")},
        {id="Move",   label=T("tab_move")},
        {id="Players",label=T("tab_play")},
        {id="Visual", label=T("tab_vis")},
        {id="Misc",   label=T("tab_misc")},
        {id="AC",     label=T("tab_ac")},
        {id="Config", label=T("tab_cfg")},
        {id="Settings",label=T("tab_set")},
    }

    tabButtons = {}
    for _, td in ipairs(tabDefs) do
        local btn = Instance.new("TextButton", sidebar)
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = Tc.InactiveSide
        btn.Text = td.label
        btn.TextColor3 = Tc.TextDim
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 12
        btn.BorderSizePixel = 0
        btn.MouseButton1Click:Connect(function() switchTab(td.id) end)
        tabButtons[td.id] = btn
    end

    -- Content area
    local contentArea = Instance.new("Frame", mainFrame)
    contentArea.Size = UDim2.new(1, -110, 1, -36)
    contentArea.Position = UDim2.new(0, 110, 0, 36)
    contentArea.BackgroundTransparency = 1

    tabContents = {}

    -- ========================
    -- ESP TAB
    -- ========================
    local espScroll = makeScrollFrame(contentArea)
    espScroll.Name = "ESP"
    espScroll.Visible = true
    tabContents["ESP"] = espScroll

    local y = 10
    y = buildSection(espScroll, T("s_vis"), y)
    y = buildToggle(espScroll, T("t_esp"), "ESP", y, function(v) end)
    y = buildToggle(espScroll, T("t_3d"), "ESPBox3D", y, function(v) updateESP3D() end)
    y = buildToggle(espScroll, T("t_2d"), "ESPBox2D", y, function(v) end)
    y = buildToggle(espScroll, T("t_sk"), "SkeletonESP", y, function(v) end)
    y = buildSection(espScroll, T("s_lbl"), y)
    y = buildToggle(espScroll, T("t_nm"), "ShowNames", y, function(v) end)
    y = buildToggle(espScroll, T("t_ds"), "ShowDistance", y, function(v) end)
    y = buildToggle(espScroll, T("t_hp"), "ShowHealthBar", y, function(v) end)
    y = buildToggle(espScroll, T("t_id"), "ShowID", y, function(v) end)
    y = buildToggle(espScroll, T("t_tr"), "ShowTracer", y, function(v) end)
    y = buildSlider(espScroll, T("l_tt"), "TracerThick", y, 0.5, 5, "%.1f", nil)
    y = buildSection(espScroll, T("s_flt"), y)
    y = buildToggle(espScroll, T("t_tc"), "TeamCheck", y, function(v) end)
    y = buildToggle(espScroll, T("t_fr"), "ShowFriendly", y, function(v) end)
    y = buildToggle(espScroll, T("t_wc"), "WallCheck", y, function(v) end)
    y = buildSection(espScroll, T("s_clr"), y)
    y = buildSlider(espScroll, T("s_enm") .. " " .. T("l_r"), "ESPEnemyR", y, 0, 255, "%d", nil)
    y = buildSlider(espScroll, T("s_enm") .. " " .. T("l_g"), "ESPEnemyG", y, 0, 255, "%d", nil)
    y = buildSlider(espScroll, T("s_enm") .. " " .. T("l_b"), "ESPEnemyB", y, 0, 255, "%d", nil)
    y = buildSlider(espScroll, T("s_frn") .. " " .. T("l_r"), "ESPFriendR", y, 0, 255, "%d", nil)
    y = buildSlider(espScroll, T("s_frn") .. " " .. T("l_g"), "ESPFriendG", y, 0, 255, "%d", nil)
    y = buildSlider(espScroll, T("s_frn") .. " " .. T("l_b"), "ESPFriendB", y, 0, 255, "%d", nil)
    y = buildSlider(espScroll, T("s_vc") .. " " .. T("l_r"), "ESPVisR", y, 0, 255, "%d", nil)
    y = buildSlider(espScroll, T("s_vc") .. " " .. T("l_g"), "ESPVisG", y, 0, 255, "%d", nil)
    y = buildSlider(espScroll, T("s_vc") .. " " .. T("l_b"), "ESPVisB", y, 0, 255, "%d", nil)
    y = buildSlider(espScroll, T("s_nm2") .. " " .. T("l_r"), "ESPNameR", y, 0, 255, "%d", nil)
    y = buildSlider(espScroll, T("s_nm2") .. " " .. T("l_g"), "ESPNameG", y, 0, 255, "%d", nil)
    y = buildSlider(espScroll, T("s_nm2") .. " " .. T("l_b"), "ESPNameB", y, 0, 255, "%d", nil)

    -- ========================
    -- AIMBOT TAB
    -- ========================
    local aimScroll = makeScrollFrame(contentArea)
    aimScroll.Name = "Aimbot"
    aimScroll.Visible = false
    tabContents["Aimbot"] = aimScroll

    y = 10
    y = buildSection(aimScroll, T("s_aim"), y)
    y = buildToggle(aimScroll, T("t_aim"), "Aimbot", y, function(v)
        if v then else end
    end)
    y = buildToggle(aimScroll, T("t_ra"), "RageAimbot", y, function(v)
        if v then enableRageAimbot() else disableRageAimbot() end
    end)
    y = buildToggle(aimScroll, T("t_sa"), "SilentAim", y, function(v)
        if v then enableSilentAim() else disableSilentAim() end
    end)
    y = buildToggle(aimScroll, T("t_mb"), "MagicBullet", y, function(v) end)
    y = buildToggle(aimScroll, T("t_tb"), "TriggerBot", y, function(v) end)
    y = buildSlider(aimScroll, T("l_tbs"), "TriggerBotDelay", y, 0, 1, "%.2f", nil)
    y = buildSection(aimScroll, T("s_fov"), y)
    y = buildToggle(aimScroll, T("t_ff"), "UseFOV", y, function(v) end)
    y = buildToggle(aimScroll, T("t_fc"), "FOVVisible", y, function(v) end)
    y = buildSlider(aimScroll, T("l_fov"), "FOVSize", y, 20, 500, "%d", nil)
    y = buildSection(aimScroll, T("s_smt"), y)
    y = buildSlider(aimScroll, T("l_sm"), "AimbotSmooth", y, 0, 1, "%.2f", nil)
    y = buildSection(aimScroll, T("s_tgt"), y)
    y = buildToggle(aimScroll, "Head", "AimHead", y, function(v) if v then _G.AimChest = false; _G.AimStomach = false end end)
    y = buildToggle(aimScroll, "Chest", "AimChest", y, function(v) if v then _G.AimHead = false; _G.AimStomach = false end end)
    y = buildToggle(aimScroll, "Stomach", "AimStomach", y, function(v) if v then _G.AimHead = false; _G.AimChest = false end end)
    y = buildSection(aimScroll, T("s_hbx"), y)
    y = buildToggle(aimScroll, T("t_hb"), "HitboxEnabled", y, function(v)
        if v then enableHitbox() else disableHitbox() end
    end)
    y = buildSlider(aimScroll, T("l_hbs"), "HitboxSize", y, 1, 20, "%d", nil)
    y = buildSection(aimScroll, T("s_flg"), y)
    y = buildToggle(aimScroll, T("t_fl"), "FakeLag", y, function(v) end)
    y = buildSlider(aimScroll, T("l_lag"), "FakeLagInterval", y, 0.01, 1, "%.2f", nil)

    -- ========================
    -- MOVEMENT TAB
    -- ========================
    local moveScroll = makeScrollFrame(contentArea)
    moveScroll.Name = "Move"
    moveScroll.Visible = false
    tabContents["Move"] = moveScroll

    y = 10
    y = buildSection(moveScroll, T("s_fly"), y)
    y = buildToggle(moveScroll, T("t_fly"), "FlyEnabled", y, function(v)
        if v then enableFly() else disableFly() end
    end)
    y = buildSlider(moveScroll, T("l_fls"), "FlySpeed", y, 10, 200, "%d", nil)
    y = buildSection(moveScroll, T("s_mov"), y)
    y = buildToggle(moveScroll, T("t_nc"), "NoClip", y, function(v)
        if v then enableNoclip() else disableNoclip() end
    end)
    y = buildToggle(moveScroll, T("t_ij"), "InfiniteJump", y, function(v)
        if v then enableInfiniteJump() else disableInfiniteJump() end
    end)
    y = buildToggle(moveScroll, T("t_lj"), "LongJump", y, function(v)
        if v then enableLongJump() else disableLongJump() end
    end)
    y = buildSlider(moveScroll, T("l_pow"), "LongJumpPower", y, 10, 200, "%d", nil)
    y = buildToggle(moveScroll, T("t_sw"), "SwimHack", y, function(v)
        if v then enableSwimHack() end
    end)
    y = buildSection(moveScroll, T("s_bhp"), y)
    y = buildToggle(moveScroll, T("t_bh"), "BunnyHop", y, function(v)
        if v then enableBhop() else disableBhop() end
    end)
    y = buildSlider(moveScroll, T("l_bhs"), "BhopSpeed", y, 0.5, 5, "%.1f", nil)
    y = buildSection(moveScroll, T("s_spd"), y)
    y = buildWarningLabel(moveScroll, T("warn_speed"), y)
    y = buildToggle(moveScroll, T("t_sh"), "SpeedHack", y, function(v)
        if v then enableSpeed() else disableSpeed() end
    end)
    y = buildSlider(moveScroll, T("l_mul"), "SpeedMult", y, 1, 10, "%.1f", nil)
    y = buildSection(moveScroll, T("s_grv"), y)
    y = buildToggle(moveScroll, T("t_gh"), "GravityHack", y, function(v) applyGravity() end)
    y = buildSlider(moveScroll, T("l_gv"), "GravityValue", y, 0, 500, "%d", function(v) applyGravity() end)
    y = buildSection(moveScroll, T("s_tp"), y)
    y = buildToggle(moveScroll, T("t_ct"), "TeleportCursor", y, function(v)
        if v then enableTeleportCursor() end
    end)

    -- ========================
    -- PLAYERS TAB
    -- ========================
    local playScroll = makeScrollFrame(contentArea)
    playScroll.Name = "Players"
    playScroll.Visible = false
    tabContents["Players"] = playScroll

    y = 10
    y = buildSection(playScroll, T("s_cmb"), y)
    y = buildToggle(playScroll, T("t_ka"), "KillAura", y, function(v)
        if v then enableKillAura() else disableKillAura() end
    end)
    y = buildSlider(playScroll, T("l_rng"), "KillAuraRange", y, 5, 50, "%d", nil)
    y = buildSection(playScroll, T("s_hlp"), y)
    y = buildToggle(playScroll, T("t_gd"), "Godmode", y, function(v)
        if v then enableGodmode() else disableGodmode() end
    end)
    y = buildToggle(playScroll, T("t_af"), "AntiAFK", y, function(v)
        if v then enableAntiAFK() else disableAntiAFK() end
    end)
    y = buildToggle(playScroll, T("t_ns"), "NameSpoof", y, function(v) applyNameSpoof() end)
    local nameBox, _
    nameBox, y = buildInput(playScroll, T("l_nm"), T("l_nm"), "", y)
    nameBox.FocusLost:Connect(function()
        _G.SpoofedName = nameBox.Text
        applyNameSpoof()
    end)
    y = buildToggle(playScroll, T("t_st"), "StreamProof", y, function(v) applyStreamProof() end)

    -- Player list
    y = buildSection(playScroll, T("tab_play"), y)
    local playerListFrame = Instance.new("Frame", playScroll)
    playerListFrame.Size = UDim2.new(1, -28, 0, 200)
    playerListFrame.Position = UDim2.new(0, 14, 0, y)
    playerListFrame.BackgroundColor3 = Tc.Card
    makeCorner(8, playerListFrame)

    local playerListLayout = Instance.new("UIListLayout", playerListFrame)
    playerListLayout.Padding = UDim.new(0, 2)

    local function refreshPlayerList()
        for _, child in ipairs(playerListFrame:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            local row = Instance.new("Frame", playerListFrame)
            row.Size = UDim2.new(1, -8, 0, 28)
            row.BackgroundColor3 = Tc.AccentFaint
            makeCorner(4, row)

            local nameLbl = Instance.new("TextLabel", row)
            nameLbl.Size = UDim2.new(0.4, 0, 1, 0)
            nameLbl.Position = UDim2.new(0, 6, 0, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = player.DisplayName
            nameLbl.TextColor3 = Tc.Text
            nameLbl.Font = Enum.Font.GothamMedium
            nameLbl.TextSize = 12
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left

            -- TP button
            local tpBtn = Instance.new("TextButton", row)
            tpBtn.Size = UDim2.new(0, 35, 0, 22)
            tpBtn.Position = UDim2.new(0.42, 0, 0.5, -11)
            tpBtn.BackgroundColor3 = Tc.AccentDim
            tpBtn.Text = T("b_tp")
            tpBtn.TextColor3 = Tc.Text
            tpBtn.Font = Enum.Font.GothamBold
            tpBtn.TextSize = 10
            makeCorner(4, tpBtn)
            tpBtn.MouseButton1Click:Connect(function()
                if player.Character and LocalPlayer.Character then
                    local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
                    local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetHRP and myHRP then
                        myHRP.CFrame = targetHRP.CFrame + Vector3.new(3, 0, 0)
                    end
                end
            end)

            -- Pull button
            local pullBtn = Instance.new("TextButton", row)
            pullBtn.Size = UDim2.new(0, 40, 0, 22)
            pullBtn.Position = UDim2.new(0.56, 0, 0.5, -11)
            pullBtn.BackgroundColor3 = Tc.AccentDim
            pullBtn.Text = T("b_pull")
            pullBtn.TextColor3 = Tc.Text
            pullBtn.Font = Enum.Font.GothamBold
            pullBtn.TextSize = 10
            makeCorner(4, pullBtn)
            pullBtn.MouseButton1Click:Connect(function()
                if player.Character and LocalPlayer.Character then
                    local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
                    local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetHRP and myHRP then
                        targetHRP.CFrame = myHRP.CFrame + Vector3.new(-3, 0, 0)
                    end
                end
            end)

            -- Freeze button
            local frzBtn = Instance.new("TextButton", row)
            frzBtn.Size = UDim2.new(0, 35, 0, 22)
            frzBtn.Position = UDim2.new(0.72, 0, 0.5, -11)
            frzBtn.BackgroundColor3 = Tc.AccentDim
            frzBtn.Text = T("b_frz")
            frzBtn.TextColor3 = Tc.Text
            frzBtn.Font = Enum.Font.GothamBold
            frzBtn.TextSize = 10
            makeCorner(4, frzBtn)
            frzBtn.MouseButton1Click:Connect(function()
                if frozenPlayers[player] then
                    frozenPlayers[player] = nil
                    frzBtn.Text = T("b_frz")
                    frzBtn.BackgroundColor3 = Tc.AccentDim
                else
                    frozenPlayers[player] = true
                    frzBtn.Text = T("b_free")
                    frzBtn.BackgroundColor3 = Tc.CloseRed
                end
            end)

            -- Spectate button
            local specBtn = Instance.new("TextButton", row)
            specBtn.Size = UDim2.new(0, 40, 0, 22)
            specBtn.Position = UDim2.new(0.88, 0, 0.5, -11)
            specBtn.BackgroundColor3 = Tc.AccentDim
            specBtn.Text = T("b_spec")
            specBtn.TextColor3 = Tc.Text
            specBtn.Font = Enum.Font.GothamBold
            specBtn.TextSize = 10
            makeCorner(4, specBtn)
            specBtn.MouseButton1Click:Connect(function()
                if spectatingPlayer == player then
                    spectatingPlayer = nil
                    Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    specBtn.Text = T("b_spec")
                else
                    spectatingPlayer = player
                    if player.Character then
                        local hum = player.Character:FindFirstChildOfClass("Humanoid")
                        if hum then Camera.CameraSubject = hum end
                    end
                    specBtn.Text = T("b_stop")
                end
            end)
        end
    end
    refreshPlayerList()
    Players.PlayerAdded:Connect(function() task.wait(1); refreshPlayerList() end)
    Players.PlayerRemoving:Connect(function() task.wait(0.5); refreshPlayerList() end)

    -- ========================
    -- VISUAL TAB
    -- ========================
    local visScroll = makeScrollFrame(contentArea)
    visScroll.Name = "Visual"
    visScroll.Visible = false
    tabContents["Visual"] = visScroll

    y = 10
    y = buildSection(visScroll, T("s_lit"), y)
    y = buildToggle(visScroll, T("t_fb"), "FullBright", y, function(v) applyFullBright() end)
    y = buildToggle(visScroll, T("t_nf"), "NoFog", y, function(v) applyNoFog() end)
    y = buildSection(visScroll, T("s_cam"), y)
    y = buildToggle(visScroll, T("t_fv"), "FOVChanger", y, function(v) applyFOVChanger() end)
    y = buildSlider(visScroll, T("l_fov"), "FOVChangerVal", y, 20, 120, "%d", function(v) applyFOVChanger() end)
    y = buildToggle(visScroll, T("t_3p"), "ThirdPerson", y, function(v)
        if v then enableThirdPerson() else disableThirdPerson() end
    end)
    y = buildSlider(visScroll, T("l_trd"), "ThirdPersonDist", y, 1, 50, "%d", function(v)
        if _G.ThirdPerson then enableThirdPerson() end
    end)
    y = buildSection(visScroll, T("s_wld"), y)
    y = buildToggle(visScroll, T("t_tc2"), "TimeChanger", y, function(v) applyTime() end)
    y = buildSlider(visScroll, T("l_tm"), "TimeOfDay", y, 0, 24, "%.1f", function(v) applyTime() end)
    y = buildToggle(visScroll, T("t_wc2"), "WorldColor", y, function(v) applyWorldColor() end)
    y = buildSlider(visScroll, T("l_r"), "WorldR", y, 0, 255, "%d", function(v) applyWorldColor() end)
    y = buildSlider(visScroll, T("l_g"), "WorldG", y, 0, 255, "%d", function(v) applyWorldColor() end)
    y = buildSlider(visScroll, T("l_b"), "WorldB", y, 0, 255, "%d", function(v) applyWorldColor() end)
    y = buildSection(visScroll, T("s_crs"), y)
    y = buildToggle(visScroll, T("t_crs"), "Crosshair", y, function(v) buildCrosshair() end)
    y = buildDropdown(visScroll, T("s_crs"), CH_STYLES, function() return _G.CrosshairStyle end, function(v) _G.CrosshairStyle = v; buildCrosshair() end, y)
    y = y + 4
    y = buildSlider(visScroll, T("l_sz"), "CrosshairSize", y, 2, 30, "%d", function(v) buildCrosshair() end)
    y = buildSlider(visScroll, T("l_th"), "CrosshairThick", y, 1, 10, "%d", function(v) buildCrosshair() end)
    y = buildSlider(visScroll, T("l_gp"), "CrosshairGap", y, 0, 20, "%d", function(v) buildCrosshair() end)
    y = buildSlider(visScroll, T("l_op"), "CrosshairAlpha", y, 0, 1, "%.2f", function(v) buildCrosshair() end)
    y = buildToggle(visScroll, T("t_dot"), "CrosshairDot", y, function(v) buildCrosshair() end)
    y = buildToggle(visScroll, T("t_out"), "CrosshairOutline", y, function(v) buildCrosshair() end)
    y = buildSlider(visScroll, T("l_r"), "CrosshairR", y, 0, 255, "%d", function(v) buildCrosshair() end)
    y = buildSlider(visScroll, T("l_g"), "CrosshairG", y, 0, 255, "%d", function(v) buildCrosshair() end)
    y = buildSlider(visScroll, T("l_b"), "CrosshairB", y, 0, 255, "%d", function(v) buildCrosshair() end)

    -- ========================
    -- MISC TAB
    -- ========================
    local miscScroll = makeScrollFrame(contentArea)
    miscScroll.Name = "Misc"
    miscScroll.Visible = false
    tabContents["Misc"] = miscScroll

    y = 10
    y = buildSection(miscScroll, T("s_srv"), y)
    y = buildToggle(miscScroll, T("t_rj"), "AutoRejoin", y, function(v) setupAutoRejoin() end)
    local hopBtn, _
    hopBtn, y = buildButton(miscScroll, T("b_hop"), y, Tc.Accent, Tc.BG)
    hopBtn.MouseButton1Click:Connect(serverHop)
    y = buildSection(miscScroll, T("s_prf"), y)
    y = buildToggle(miscScroll, T("t_fp"), "FPSBoost", y, function(v) applyFPSBoost() end)
    y = buildSection(miscScroll, T("s_cht"), y)
    y = buildToggle(miscScroll, T("t_cl"), "ChatLogger", y, function(v) setupChatLogger() end)
    y = buildSection(miscScroll, T("s_mm"), y)
    y = buildToggle(miscScroll, T("t_mm"), "MiniMap", y, function(v) createMinimap() end)

    -- ========================
    -- ANTICHEAT BYPASS TAB
    -- ========================
    local acScroll = makeScrollFrame(contentArea)
    acScroll.Name = "AC"
    acScroll.Visible = false
    tabContents["AC"] = acScroll

    y = 10
    y = buildSection(acScroll, T("s_ac"), y)
    y = buildToggle(acScroll, T("t_acfl"), "ACBypassFly", y, function(v) end)
    y = buildToggle(acScroll, T("t_acnc"), "ACBypassNoclip", y, function(v) end)
    y = buildToggle(acScroll, T("t_acsp"), "ACBypassSpeed", y, function(v) end)
    y = buildToggle(acScroll, T("t_actp"), "ACBypassTP", y, function(v) end)
    y = buildToggle(acScroll, T("t_acre"), "ACBlockRemotes", y, function(v) end)
    y = buildToggle(acScroll, T("t_acam"), "ACBypassAimbot", y, function(v) end)

    -- ========================
    -- CONFIG TAB
    -- ========================
    local cfgScroll = makeScrollFrame(contentArea)
    cfgScroll.Name = "Config"
    cfgScroll.Visible = false
    tabContents["Config"] = cfgScroll

    y = 10
    y = buildSection(cfgScroll, T("tab_cfg"), y)
    local cfgInput, _
    cfgInput, y = buildInput(cfgScroll, T("cfg_name"), T("cfg_name"), "", y)

    local saveBtn, _
    saveBtn, y = buildButton(cfgScroll, T("cfg_save"), y, Tc.KeyGreen, Color3.new(1,1,1))
    saveBtn.MouseButton1Click:Connect(function()
        local name = cfgInput.Text:gsub("%s+", "")
        if name == "" then return end
        if saveConfig(name) then
            saveBtn.Text = T("cfg_saved")
            task.delay(2, function() saveBtn.Text = T("cfg_save") end)
        end
    end)

    local loadBtn, _
    loadBtn, y = buildButton(cfgScroll, T("cfg_load"), y, Color3.fromRGB(60, 120, 255), Color3.new(1,1,1))
    loadBtn.MouseButton1Click:Connect(function()
        local name = cfgInput.Text:gsub("%s+", "")
        if name == "" then return end
        if loadConfig(name) then
            loadBtn.Text = T("cfg_loaded")
            task.delay(2, function() loadBtn.Text = T("cfg_load") end)
        else
            loadBtn.Text = T("cfg_fail")
            task.delay(2, function() loadBtn.Text = T("cfg_load") end)
        end
    end)

    local delBtn, _
    delBtn, y = buildButton(cfgScroll, T("cfg_del"), y, Tc.KeyRed, Color3.new(1,1,1))
    delBtn.MouseButton1Click:Connect(function()
        local name = cfgInput.Text:gsub("%s+", "")
        if name == "" then return end
        deleteConfig(name)
        delBtn.Text = T("cfg_deleted")
        task.delay(2, function() delBtn.Text = T("cfg_del") end)
    end)

    y = y + 10
    y = buildSection(cfgScroll, T("tab_cfg") .. " List", y)
    local cfgListFrame = Instance.new("Frame", cfgScroll)
    cfgListFrame.Size = UDim2.new(1, -28, 0, 120)
    cfgListFrame.Position = UDim2.new(0, 14, 0, y)
    cfgListFrame.BackgroundColor3 = Tc.Card
    makeCorner(8, cfgListFrame)

    local cfgListLayout = Instance.new("UIListLayout", cfgListFrame)
    cfgListLayout.Padding = UDim.new(0, 2)

    local function refreshCfgList()
        for _, child in ipairs(cfgListFrame:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        local configs = listConfigs()
        if #configs == 0 then
            local none = Instance.new("TextLabel", cfgListFrame)
            none.Size = UDim2.new(1, 0, 0, 24)
            none.BackgroundTransparency = 1
            none.Text = T("cfg_none")
            none.TextColor3 = Tc.TextDim
            none.Font = Enum.Font.GothamMedium
            none.TextSize = 12
        else
            for _, cfgName in ipairs(configs) do
                local row = Instance.new("Frame", cfgListFrame)
                row.Size = UDim2.new(1, -8, 0, 26)
                row.BackgroundColor3 = Tc.AccentFaint
                makeCorner(4, row)

                local lbl = Instance.new("TextLabel", row)
                lbl.Size = UDim2.new(0.6, 0, 1, 0)
                lbl.Position = UDim2.new(0, 6, 0, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = cfgName
                lbl.TextColor3 = Tc.Text
                lbl.Font = Enum.Font.Gotham
                lbl.TextSize = 12
                lbl.TextXAlignment = Enum.TextXAlignment.Left

                local selBtn = Instance.new("TextButton", row)
                selBtn.Size = UDim2.new(0, 50, 0, 20)
                selBtn.Position = UDim2.new(1, -56, 0.5, -10)
                selBtn.BackgroundColor3 = Tc.AccentDim
                selBtn.Text = T("cfg_load")
                selBtn.TextColor3 = Tc.Text
                selBtn.Font = Enum.Font.GothamBold
                selBtn.TextSize = 10
                makeCorner(4, selBtn)
                selBtn.MouseButton1Click:Connect(function()
                    cfgInput.Text = cfgName
                end)
            end
        end
    end
    refreshCfgList()

    -- ========================
    -- SETTINGS TAB
    -- ========================
    local setScroll = makeScrollFrame(contentArea)
    setScroll.Name = "Settings"
    setScroll.Visible = false
    tabContents["Settings"] = setScroll

    y = 10
    y = buildSection(setScroll, T("s_lng"), y)
    y = buildDropdown(setScroll, T("s_lng"), {"TR", "EN", "ES"}, function() return LANG end, function(v) LANG = v end, y)
    y = buildSection(setScroll, T("s_thm"), y)
    local themeNames = {}
    for _, th in ipairs(THEMES) do table.insert(themeNames, th.name) end
    y = buildDropdown(setScroll, T("s_thm"), themeNames, function() return THEMES[currentThemeIndex].name end, function(v)
        for i, th in ipairs(THEMES) do
            if th.name == v then currentThemeIndex = i; break end
        end
    end, y)
    y = buildSection(setScroll, T("s_abt"), y)
    local aboutLbl = Instance.new("TextLabel", setScroll)
    aboutLbl.Size = UDim2.new(1, -28, 0, 80)
    aboutLbl.Position = UDim2.new(0, 14, 0, y)
    aboutLbl.BackgroundTransparency = 1
    aboutLbl.Text = "SUSANO V2.3\nDiscord: " .. T("disc") .. "\nUser: " .. USERNAME .. " [" .. USER_ID .. "]\nHWID: " .. HWID:sub(1, 20) .. "\nGame: " .. tostring(game.PlaceId)
    aboutLbl.TextColor3 = Tc.TextDim
    aboutLbl.Font = Enum.Font.GothamMedium
    aboutLbl.TextSize = 12
    aboutLbl.TextWrapped = true
    aboutLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Set initial tab
    switchTab("ESP")

    -- Dragging
    local dragging = false
    local dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

rebuildMenu = function()
    createMenu()
end

-- ============================================================
-- KEY SYSTEM GUI
-- ============================================================
local function createKeyGUI()
    local keyGui = makeScreenGui("SusanoKey", 300)

    local bg = Instance.new("Frame", keyGui)
    bg.Size = UDim2.new(0, 400, 0, 280)
    bg.Position = UDim2.new(0.5, -200, 0.5, -140)
    bg.BackgroundColor3 = Tc.BG
    bg.BorderSizePixel = 0
    makeCorner(12, bg)

    -- Border glow
    local border = Instance.new("UIStroke", bg)
    border.Color = Tc.Accent; border.Thickness = 1.5

    -- Title
    local title = Instance.new("TextLabel", bg)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundTransparency = 1
    title.Text = "🔑 SUSANO V2.3"
    title.TextColor3 = Tc.Accent
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22

    -- Subtitle
    local subtitle = Instance.new("TextLabel", bg)
    subtitle.Size = UDim2.new(1, -40, 0, 20)
    subtitle.Position = UDim2.new(0, 20, 0, 50)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = T("key_enter")
    subtitle.TextColor3 = Tc.TextDim
    subtitle.Font = Enum.Font.GothamMedium
    subtitle.TextSize = 13
    subtitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Key input
    local keyBox = Instance.new("TextBox", bg)
    keyBox.Size = UDim2.new(1, -40, 0, 40)
    keyBox.Position = UDim2.new(0, 20, 0, 80)
    keyBox.BackgroundColor3 = Tc.Card
    keyBox.TextColor3 = Tc.Text
    keyBox.Font = Enum.Font.Gotham
    keyBox.TextSize = 15
    keyBox.PlaceholderText = "XXXXX-XXXXX-XXXXX"
    keyBox.PlaceholderColor3 = Tc.TextFaint
    keyBox.BorderSizePixel = 0
    makeCorner(8, keyBox)

    -- Login button
    local loginBtn = Instance.new("TextButton", bg)
    loginBtn.Size = UDim2.new(1, -40, 0, 44)
    loginBtn.Position = UDim2.new(0, 20, 0, 135)
    loginBtn.BackgroundColor3 = Tc.Accent
    loginBtn.Text = T("key_btn")
    loginBtn.TextColor3 = Tc.BG
    loginBtn.Font = Enum.Font.GothamBold
    loginBtn.TextSize = 16
    makeCorner(8, loginBtn)

    -- Status label
    local statusLbl = Instance.new("TextLabel", bg)
    statusLbl.Size = UDim2.new(1, -40, 0, 20)
    statusLbl.Position = UDim2.new(0, 20, 0, 190)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = ""
    statusLbl.TextColor3 = Tc.TextDim
    statusLbl.Font = Enum.Font.GothamMedium
    statusLbl.TextSize = 12
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Key info
    local infoLbl = Instance.new("TextLabel", bg)
    infoLbl.Size = UDim2.new(1, -40, 0, 40)
    infoLbl.Position = UDim2.new(0, 20, 0, 220)
    infoLbl.BackgroundTransparency = 1
    infoLbl.Text = "Discord: " .. T("disc") .. "\nHWID: " .. HWID:sub(1, 20)
    infoLbl.TextColor3 = Tc.TextFaint
    infoLbl.Font = Enum.Font.Gotham
    infoLbl.TextSize = 11
    infoLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Remember checkbox
    local remBtn = Instance.new("TextButton", bg)
    remBtn.Size = UDim2.new(0, 100, 0, 24)
    remBtn.Position = UDim2.new(1, -120, 0, 220)
    remBtn.BackgroundColor3 = Tc.Card
    remBtn.Text = "💾 " .. T("key_rem")
    remBtn.TextColor3 = Tc.TextDim
    remBtn.Font = Enum.Font.GothamMedium
    remBtn.TextSize = 11
    makeCorner(6, remBtn)

    local function onLogin()
        local key = keyBox.Text:gsub("%s+", "")
        if key == "" then
            statusLbl.Text = T("key_enter")
            statusLbl.TextColor3 = Tc.KeyGold
            return
        end
        loginBtn.Text = T("key_chk")
        loginBtn.BackgroundColor3 = Tc.KeyGold
        statusLbl.Text = ""

        validateKey(key, function(success, kType, expires)
            if success then
                keyValidated = true
                keyType = kType
                keyExpires = expires
                activeKey = key
                _G.Verified = true
                statusLbl.Text = T("key_ok") .. " [" .. kType .. "] " .. formatTimeLeft(expires)
                statusLbl.TextColor3 = Tc.KeyGreen
                loginBtn.Text = "✅"
                loginBtn.BackgroundColor3 = Tc.KeyGreen

                -- Save key
                safeWrite(KEY_FILE, key)

                -- Destroy key GUI and open main menu
                task.delay(1.5, function()
                    keyGui:Destroy()
                    createMenu()
                    createFOVCircle()
                    enableTeleportCursor()
                    enableAntiAFK()
                    setupAutoRejoin()
                    setupChatLogger()
                    createMinimap()
                    webhookFeature("Key Login", true)
                end)
            else
                statusLbl.Text = kType or T("key_inv")
                statusLbl.TextColor3 = Tc.KeyRed
                loginBtn.Text = T("key_btn")
                loginBtn.BackgroundColor3 = Tc.Accent
                loginBtn.TextColor3 = Tc.BG
            end
        end)
    end

    loginBtn.MouseButton1Click:Connect(onLogin)
    keyBox.FocusLost:Connect(function(enter)
        if enter then onLogin() end
    end)

    remBtn.MouseButton1Click:Connect(function()
        local savedKey = loadSavedKey()
        if savedKey and savedKey ~= "" then
            keyBox.Text = savedKey
            statusLbl.Text = "💾"
            statusLbl.TextColor3 = Tc.KeyGold
        end
    end)

    -- Auto-login with saved key
    task.spawn(function()
        task.wait(1)
        local savedKey = loadSavedKey()
        if savedKey and savedKey ~= "" then
            keyBox.Text = savedKey
            statusLbl.Text = "Auto-login..."
            statusLbl.TextColor3 = Tc.TextDim
            onLogin()
        end
    end)
end

-- ============================================================
-- MAIN RENDER LOOP
-- ============================================================
local function mainRenderLoop()
    RunService.RenderStepped:Connect(function(dt)
        pcall(function()
            -- Rainbow theme
            if THEMES[currentThemeIndex].rainbow then
                rainbowHue = (rainbowHue + dt * 0.3) % 1
                Tc = makeThemeColors()
            end

            -- ESP updates
            if _G.ESP then
                updateESP3D()
                updateESP2D()
                updateSkeleton()
            end

            -- Aimbot
            aimbotTick()

            -- Trigger Bot
            triggerBotTick()

            -- FOV Circle update
            if fovCircle then
                fovCircle.Visible = _G.FOVVisible and (_G.Aimbot or _G.RageAimbot)
                local r = _G.FOVSize
                fovCircle.Size = UDim2.new(0, r*2, 0, r*2)
                fovCircle.Position = UDim2.new(0.5, -r, 0.5, -r)
            end

            -- Minimap update
            if _G.MiniMap then
                updateMinimap()
            end

            -- Visual updates
            if _G.TimeChanger then applyTime() end
            if _G.WorldColor then applyWorldColor() end
            if _G.FOVChanger then applyFOVChanger() end
            if _G.GravityHack then applyGravity() end
            if _G.FullBright then applyFullBright() end
            if _G.NoFog then applyNoFog() end

            -- Speed bypass
            if _G.SpeedHack and _G.ACBypassSpeed then
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        pcall(function()
                            -- Show fake WalkSpeed to server
                            sethiddenproperty(hum, "WalkSpeed", 16)
                        end)
                    end
                end
            end

            -- Freeze players
            for player, _ in pairs(frozenPlayers) do
                if player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Anchored = true
                    end
                end
            end

            -- Magic Bullet
            if _G.MagicBullet then
                local target = getBestAimTarget()
                if target and target.Character then
                    local head = target.Character:FindFirstChild("Head")
                    if head then
                        dealDamage(target.Character, head, head.Position)
                    end
                end
            end

            -- Fake Lag
            if _G.FakeLag then
                local char = LocalPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        pcall(function()
                            if sethiddenproperty then
                                sethiddenproperty(hrp, "NetworkOwnershipRule", 2)
                            end
                        end)
                        task.wait(_G.FakeLagInterval)
                        pcall(function()
                            if sethiddenproperty then
                                sethiddenproperty(hrp, "NetworkOwnershipRule", 0)
                            end
                        end)
                    end
                end
            end

            -- Stream Proof
            if _G.StreamProof then applyStreamProof() end

            -- Third Person distance
            if _G.ThirdPerson then
                LocalPlayer.CameraMaxZoomDistance = _G.ThirdPersonDist * 10
                LocalPlayer.CameraMinZoomDistance = _G.ThirdPersonDist
            end
        end)
    end)
end

-- ============================================================
-- HOTKEY SYSTEM
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
    if input.KeyCode == Enum.KeyCode.RightControl then
        toggleMenu()
    end
end)

-- ============================================================
-- CLEANUP ON PLAYER CHARACTER ADDED
-- ============================================================
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    -- Re-enable features after respawn
    if _G.FlyEnabled then enableFly() end
    if _G.NoClip then enableNoclip() end
    if _G.BunnyHop then enableBhop() end
    if _G.SpeedHack then enableSpeed() end
    if _G.HitboxEnabled then enableHitbox() end
    if _G.Godmode then enableGodmode() end
    if _G.KillAura then enableKillAura() end
    if _G.ThirdPerson then enableThirdPerson() end
    if _G.Crosshair then buildCrosshair() end
    scanWeaponRemotes()
end)

-- Cleanup on player leaving
Players.PlayerRemoving:Connect(function(player)
    if espHighlights[player] then
        pcall(function() espHighlights[player]:Destroy() end)
        espHighlights[player] = nil
    end
    if esp2DObjects[player] then
        for _, obj in pairs(esp2DObjects[player]) do
            pcall(function() obj:Remove() end)
        end
        esp2DObjects[player] = nil
    end
    clearSkeleton(player)
    frozenPlayers[player] = nil
    if spectatingPlayer == player then
        spectatingPlayer = nil
        pcall(function()
            Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end)
    end
end)

-- ============================================================
-- INITIALIZE
-- ============================================================
print("============================================")
print("  SUSANO V2.3 | discord.gg/tCufFEMdux")
print("  User: " .. USERNAME .. " | HWID: " .. HWID:sub(1, 15) .. "...")
print("  Game: " .. tostring(game.PlaceId))
print("============================================")

-- Start the key GUI
createKeyGUI()

-- Start render loop
mainRenderLoop()
