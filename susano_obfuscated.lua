-- SUSANO V2.3 | discord.gg/tCufFEMdux
-- Tum degiskenler acik yazildi, hic kisaltma yok

local t1 = "ghp_wG4l"
local t2 = "OHjlmUvwum"
local t3 = "ObSMZlppNaGyMq3H3JtpiC"
local GITHUB_TOKEN  = t1..t2..t3
local GITHUB_OWNER  = "CrafyXD"
local GITHUB_REPO   = "susano-backend"
local GITHUB_BRANCH = "main"
local WEBHOOK_URL   = "https://discord.com/api/webhooks/1486783402656141494/XHOkFNPIw_qH9yjgbZ5KL4pr-WEvbIJbW6Ff7DYueaV2DNoAMU1dvR7dRgKhvaSzsYkb"

-- Servisler - hic kisaltma yok
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

local HWID = tostring(LocalPlayer.UserId)
pcall(function()
    HWID = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
end)
local USERNAME  = LocalPlayer.Name
local USER_ID   = tostring(LocalPlayer.UserId)

-- Dosya yardimcilari
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

-- HTTP yardimcisi
local function httpRequest(method, url, body, headers)
    local ok, resp = pcall(function()
        return (http_request or request)({
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

-- Webhook
local function sendWebhook(title, color, fields)
    if WEBHOOK_URL:find("WEBHOOK_URL_BURAYA") then return end
    task.spawn(function()
        pcall(function()
            (http_request or request)({
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
        -- Sure kontrolu - sadece aktive edilmisse
        if keyData.activated and keyData.expires and keyData.expires > 0 and os.time() > keyData.expires then
            callback(false, T("key_exp"), 0); return
        end
        -- HWID kontrolu
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
            -- ILK KULLANIM: HWID bagla + sureyi SIMDI basla
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
-- ESP
_G.ESP             = false
_G.ESPBox3D        = false
_G.ESPBox2D        = false
_G.ShowNames       = false
_G.ShowDistance    = false
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
-- Crosshair
_G.Crosshair       = false
_G.CrosshairStyle  = "Cross"
_G.CrosshairSize   = 12
_G.CrosshairThick  = 2
_G.CrosshairGap    = 4
_G.CrosshairAlpha  = 1.0
_G.CrosshairDot    = false
_G.CrosshairOutline= false
_G.CrosshairR      = 255; _G.CrosshairG = 255; _G.CrosshairB = 255
-- Aimbot
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
-- Movement
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
-- Players
_G.KillAura        = false
_G.KillAuraRange   = 15
_G.AntiAFK         = false
_G.NameSpoof       = false
_G.SpoofedName     = ""
_G.StreamProof     = false
-- Visual
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
-- Misc
_G.AutoRejoin      = false
_G.FPSBoost        = false
_G.ChatLogger      = false
_G.MiniMap         = false
-- AntiCheat Bypass
_G.ACBypassFly     = true
_G.ACBypassNoclip  = true
_G.ACBypassSpeed   = true
_G.ACBypassTP      = true
_G.ACBlockRemotes  = true
_G.ACBypassAimbot  = true

local frozenPlayers = {}
local chatLogs = {}

-- ANTICHEAT BYPASS SISTEMI
-- Fly: WalkSpeed=16 gozukur, gercek ucus BodyVelocity ile
-- Speed: WalkSpeed=16 gozukur, gercek hiz BodyVelocity ile
local acBlockedRemoteConns = {}

local function setupAntiCheatBypass()
    -- 1. Network Ownership - tum part'lari biz kontrol edelim
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

    -- 2. AC Remote'larini blokla
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
        -- Tum RemoteEvent'leri tara
        for _, location in ipairs({ReplicatedStorage, Workspace}) do
            pcall(function()
                for _, obj in ipairs(location:GetDescendants()) do
                    -- SADECE RemoteEvent kontrol et, RemoteFunction degil
                    if obj:IsA("RemoteEvent") and isACRemote(obj.Name) then
                        pcall(function()
                            -- OnClientEvent'i yakala ve bos birak
                            local conn = obj.OnClientEvent:Connect(function() end)
                            table.insert(acBlockedRemoteConns, conn)
                        end)
                    end
                end
            end)
        end
    end

    -- 3. Yere Yansima - fly icin zemin pozisyonu hesapla
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

    -- Baslat
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
        local next = options[(idx % #options) + 1]
        setterFn(next)
        vBtn.Text = next
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
    local warn = Instance.new("Frame", parent)
    warn.Size = UDim2.new(1, -28, 0, 30)
    warn.Position = UDim2.new(0, 14, 0, yPos)
    warn.BackgroundColor3 = Color3.fromRGB(80, 40, 10)
    warn.BackgroundTransparency = 0
    makeCorner(6, warn)

    local wlbl = Instance.new("TextLabel", warn)
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

-- OZELLIK FONKSIYONLARI
local enableFly, disableFly, enableNoclip, disableNoclip
local enableBhop, disableBhop, enableSpeed, disableSpeed
local enableInfiniteJump, disableInfiniteJump, enableLongJump, disableLongJump
local enableSwimHack, enableKillAura, disableKillAura
local enableAntiAFK, disableAntiAFK, enableRageAimbot, disableRageAimbot
local enableSilentAim, disableSilentAim, enableThirdPerson, disableThirdPerson
local enableHitbox, disableHitbox, enableGodmode, disableGodmode
local applyNameSpoof, applyFullBright, applyNoFog, applyTime, applyWorldColor
local buildCrosshair, MainGui, switchTab, createMenu, rebuildMenu
local aimTarget = nil

-- Crosshair
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

-- FOV
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

-- TP Cursor Gostergesi
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
                -- Karakter yuksekligine gore offset
                local charHeight = 5
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    pcall(function()
                        local desc = hum:GetAppliedDescription()
                        if desc then charHeight = math.max(desc.HeadScale * 1.5 + desc.BodyTypeScale * 3, 3) end
                    end)
                end
                hrp.CFrame = CFrame.new(tpTargetPosition + Vector3.new(0, charHeight / 2 + 1, 0))
                -- Goze batan geri bildirim
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

-- Skeleton ESP
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

local function updateSkeleton()
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
                local line = Drawing.new("Line")
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

-- Duvar kontrolu
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

-- Aimbot hedef secimi
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

local function getBestAimTarget()
    local best, bestDist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer or not player.Character then continue end
        local friendly = player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team
        if friendly and not _G.ShowFriendly then continue end
        if not friendly and not _G.TeamCheck then continue end
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local part = getAimPart(player); if not part then continue end
        local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end
        local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
        if _G.UseFOV and dist > _G.FOVSize then continue end
        if dist < bestDist then bestDist = dist; best = {part = part, player = player} end
    end
    return best
end

-- Silent Aim - mouse yonlendirme (kamera degil)
local silentAimActive = false
local silentAimConn

enableSilentAim = function()
    silentAimActive = true
    if silentAimConn then silentAimConn:Disconnect() end
    silentAimConn = RunService.RenderStepped:Connect(function()
        if not _G.SilentAim or not silentAimActive then return end
        local t = getBestAimTarget(); if not t then return end
        local sp, onS = Camera:WorldToViewportPoint(t.part.Position)
        if not onS then return end
        if _G.ACBypassAimbot then
            -- Mouse hareketi ile yonlendir (kamera manipulation yerine)
            pcall(function()
                if mousemoverel then
                    local mousePos = UserInputService:GetMouseLocation()
                    local dx = (sp.X - mousePos.X) * 0.15
                    local dy = (sp.Y - mousePos.Y) * 0.15
                    mousemoverel(dx, dy)
                end
            end)
        else
            -- Fallback: kamera
            local savedCam = Camera.CFrame
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.part.Position)
            task.wait()
            Camera.CFrame = savedCam
        end
    end)
end
disableSilentAim = function()
    silentAimActive = false
    if silentAimConn then silentAimConn:Disconnect(); silentAimConn = nil end
end

-- Rage Aimbot
local rageActive, rageConn = false, nil
disableRageAimbot = function()
    rageActive = false
    if rageConn then rageConn:Disconnect(); rageConn = nil end
end
enableRageAimbot = function()
    if rageActive then return end; rageActive = true
    rageConn = RunService.RenderStepped:Connect(function()
        if not _G.RageAimbot then disableRageAimbot(); return end
        local best, bestDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer or not p.Character then continue end
            local friendly = p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team
            if friendly and not _G.ShowFriendly then continue end
            if not friendly and not _G.TeamCheck then continue end
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then continue end
            for _, pn in ipairs({"Head","UpperTorso","Torso","HumanoidRootPart"}) do
                local part = p.Character:FindFirstChild(pn)
                if part then
                    local d = (part.Position - Camera.CFrame.Position).Magnitude
                    if d < bestDist then bestDist = d; best = part end
                end
            end
        end
        if best then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, best.Position)
            setFOVColor(Color3.fromRGB(255, 80, 80))
        else setFOVColor(Color3.new(1,1,1)) end
    end)
end

-- Trigger Bot
local triggerBotConn
local function enableTriggerBot()
    if triggerBotConn then triggerBotConn:Disconnect() end
    triggerBotConn = RunService.Heartbeat:Connect(function()
        if not _G.TriggerBot then return end
        local t = getBestAimTarget(); if not t then return end
        local sp, onS = Camera:WorldToViewportPoint(t.part.Position)
        if not onS then return end
        local mousePos = UserInputService:GetMouseLocation()
        local dist2d = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
        if dist2d > 35 then return end
        task.wait(_G.TriggerBotDelay)
        local char = LocalPlayer.Character; if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            pcall(function() tool:Activate() end)
            dealDamage(t.player.Character, t.part, t.part.Position)
        end
    end)
end
local function disableTriggerBot()
    if triggerBotConn then triggerBotConn:Disconnect(); triggerBotConn = nil end
end

-- Magic Bullet
local magicBulletConn
local function enableMagicBullet()
    if magicBulletConn then magicBulletConn:Disconnect() end
    magicBulletConn = RunService.Heartbeat:Connect(function()
        if not _G.MagicBullet then return end
        local t = getBestAimTarget(); if not t then return end
        task.wait(0.12) -- Throttle - kasmasin
        dealDamage(t.player.Character, t.part, t.part.Position)
    end)
end
local function disableMagicBullet()
    if magicBulletConn then magicBulletConn:Disconnect(); magicBulletConn = nil end
end

-- Hitbox
local hitboxConn
enableHitbox = function()
    if hitboxConn then hitboxConn:Disconnect() end
    hitboxConn = RunService.Heartbeat:Connect(function()
        if not _G.HitboxEnabled then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(function()
                        hrp.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                        hrp.Transparency = 0.8
                    end)
                end
            end
        end
    end)
end
disableHitbox = function()
    if hitboxConn then hitboxConn:Disconnect(); hitboxConn = nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then pcall(function() hrp.Size = Vector3.new(2,2,1); hrp.Transparency = 1 end) end
        end
    end
end

-- Fake Lag
local fakeLagConn
local function enableFakeLag()
    if fakeLagConn then fakeLagConn:Disconnect() end
    fakeLagConn = RunService.Heartbeat:Connect(function()
        if not _G.FakeLag then return end
        task.wait(_G.FakeLagInterval)
    end)
end
local function disableFakeLag()
    if fakeLagConn then fakeLagConn:Disconnect(); fakeLagConn = nil end
end

-- Godmode
local godmodeConn1, godmodeConn2
enableGodmode = function()
    if godmodeConn1 then godmodeConn1:Disconnect() end
    if godmodeConn2 then godmodeConn2:Disconnect() end
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    hum.BreakJointsOnDeath = false
    pcall(function() hum.MaxHealth = math.huge end)
    godmodeConn1 = hum.HealthChanged:Connect(function()
        if not _G.Godmode then return end
        pcall(function() hum.Health = hum.MaxHealth end)
    end)
    godmodeConn2 = RunService.Heartbeat:Connect(function()
        if not _G.Godmode then return end
        if hum and hum.Health < hum.MaxHealth then
            pcall(function() hum.Health = hum.MaxHealth end)
        end
    end)
end
disableGodmode = function()
    if godmodeConn1 then godmodeConn1:Disconnect(); godmodeConn1 = nil end
    if godmodeConn2 then godmodeConn2:Disconnect(); godmodeConn2 = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum.MaxHealth = 100; hum.Health = 100 end) end
    end
end

-- Infinite Jump
local ijConn
enableInfiniteJump = function()
    if ijConn then ijConn:Disconnect() end
    ijConn = UserInputService.JumpRequest:Connect(function()
        if not _G.InfiniteJump then return end
        local char = LocalPlayer.Character; if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end
disableInfiniteJump = function()
    if ijConn then ijConn:Disconnect(); ijConn = nil end
end

-- Long Jump
local ljConn
enableLongJump = function()
    if ljConn then ljConn:Disconnect() end
    ljConn = UserInputService.JumpRequest:Connect(function()
        if not _G.LongJump then return end
        local char = LocalPlayer.Character; if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.FloorMaterial ~= Enum.Material.Air then
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = hrp.CFrame.LookVector * _G.LongJumpPower + Vector3.new(0, 30, 0)
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5); bv.P = 1e4; bv.Parent = hrp
            game:GetService("Debris"):AddItem(bv, 0.15)
        end
    end)
end
disableLongJump = function()
    if ljConn then ljConn:Disconnect(); ljConn = nil end
end

-- Swim Hack
local swimConn
enableSwimHack = function()
    if swimConn then swimConn:Disconnect() end
    swimConn = RunService.Stepped:Connect(function()
        if not _G.SwimHack then return end
        local char = LocalPlayer.Character; if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum:GetState() == Enum.HumanoidStateType.Swimming then
            hum.WalkSpeed = 16 * _G.SpeedMult
        end
    end)
end

-- Bunny Hop
local bhopConn, bhopActive = nil, false
enableBhop = function()
    if bhopActive then return end
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    bhopActive = true
    bhopConn = RunService.RenderStepped:Connect(function()
        if not _G.BunnyHop or not char or not hum then
            bhopActive = false
            if bhopConn then bhopConn:Disconnect() end
            return
        end
        if hum.FloorMaterial ~= Enum.Material.Air then
            hum.JumpPower = _G.BhopHeight; hum.Jump = true
        end
        hum.WalkSpeed = hum.MoveDirection.Magnitude > 0 and 16 * _G.BhopSpeed or 16
    end)
end
disableBhop = function()
    bhopActive = false
    if bhopConn then bhopConn:Disconnect(); bhopConn = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16; hum.JumpPower = 50 end
    end
end

-- SPEED HACK - BYPASS: WalkSpeed=16 goster, gercek hiz BodyVelocity
local speedConn, speedActive = nil, false
local originalSpeed = 16
local speedBodyVelocity = nil

enableSpeed = function()
    if speedActive then return end
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    speedActive = true
    originalSpeed = hum.WalkSpeed

    -- BodyVelocity olustur (asil hareketi bu saglar)
    if speedBodyVelocity then speedBodyVelocity:Destroy() end
    speedBodyVelocity = Instance.new("BodyVelocity")
    speedBodyVelocity.MaxForce = Vector3.new(1e5, 0, 1e5) -- Y yok (gravity calissın)
    speedBodyVelocity.P = 5000
    speedBodyVelocity.Parent = hrp

    speedConn = RunService.RenderStepped:Connect(function()
        if not _G.SpeedHack or not char or not hum then
            speedActive = false
            if speedConn then speedConn:Disconnect() end
            return
        end
        local char2 = LocalPlayer.Character; if not char2 then return end
        local hum2 = char2:FindFirstChildOfClass("Humanoid")
        local hrp2 = char2:FindFirstChild("HumanoidRootPart")
        if not hum2 or not hrp2 then return end

        -- BYPASS: AC'ye WalkSpeed=16 goster
        if _G.ACBypassSpeed then
            pcall(function() hum2.WalkSpeed = 16 end)
        end

        -- Gercek hizi BodyVelocity ile ver
        local moveDir = hum2.MoveDirection
        if moveDir.Magnitude > 0 then
            local realSpeed = originalSpeed * _G.SpeedMult
            speedBodyVelocity.Velocity = moveDir.Unit * realSpeed
        else
            speedBodyVelocity.Velocity = Vector3.zero
        end
    end)
end

disableSpeed = function()
    speedActive = false
    if speedConn then speedConn:Disconnect(); speedConn = nil end
    if speedBodyVelocity then speedBodyVelocity:Destroy(); speedBodyVelocity = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = originalSpeed end
    end
end

-- FLY HACK - BYPASS: Humanoid state'i AC'den gizle
local flyConn, flying = nil, false
local flyBodyVelocity, flyBodyGyro

enableFly = function()
    if flying then return end
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    flying = true

    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBodyVelocity.P = 1e4; flyBodyVelocity.Parent = hrp

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyBodyGyro.P = 1e4; flyBodyGyro.D = 100; flyBodyGyro.Parent = hrp

    flyConn = RunService.RenderStepped:Connect(function()
        if not flying or not hrp then disableFly(); return end
        flyBodyGyro.CFrame = Camera.CFrame

        local velocity = Vector3.zero
        local ui = UserInputService
        if ui:IsKeyDown(Enum.KeyCode.W)          then velocity = velocity + Camera.CFrame.LookVector  * _G.FlySpeed end
        if ui:IsKeyDown(Enum.KeyCode.S)          then velocity = velocity - Camera.CFrame.LookVector  * _G.FlySpeed end
        if ui:IsKeyDown(Enum.KeyCode.D)          then velocity = velocity + Camera.CFrame.RightVector * _G.FlySpeed end
        if ui:IsKeyDown(Enum.KeyCode.A)          then velocity = velocity - Camera.CFrame.RightVector * _G.FlySpeed end
        if ui:IsKeyDown(Enum.KeyCode.Space)      then velocity = velocity + Vector3.new(0, _G.FlySpeed, 0) end
        if ui:IsKeyDown(Enum.KeyCode.LeftShift) or ui:IsKeyDown(Enum.KeyCode.Q) then
            velocity = velocity - Vector3.new(0, _G.FlySpeed, 0)
        end
        flyBodyVelocity.Velocity = velocity

        -- BYPASS: AC'ye farkli state goster
        if _G.ACBypassFly then
            -- WalkSpeed=16 goster
            pcall(function() hum.WalkSpeed = 16 end)
            -- State manipulasyonu - Freefall yerine baska state
            pcall(function()
                if sethiddenproperty then
                    sethiddenproperty(hum, "PlatformStand", false)
                    sethiddenproperty(hum, "Sit", false)
                end
            end)
            -- Running state taklit et
            if hum:GetState() == Enum.HumanoidStateType.Freefall then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end
        else
            if hum:GetState() ~= Enum.HumanoidStateType.Freefall then
                hum:ChangeState(Enum.HumanoidStateType.Freefall)
            end
        end
    end)
end

disableFly = function()
    flying = false
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
    if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Landed) end
    end
end

-- Noclip
local noclipConn, noclipActive = nil, false
enableNoclip = function()
    if noclipActive then return end; noclipActive = true
    noclipConn = RunService.Stepped:Connect(function()
        if not noclipActive or not LocalPlayer.Character then
            noclipActive = false
            if noclipConn then noclipConn:Disconnect() end
            return
        end
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end
disableNoclip = function()
    noclipActive = false
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

-- Kill Aura
local killAuraConn
enableKillAura = function()
    if killAuraConn then killAuraConn:Disconnect() end
    killAuraConn = RunService.Heartbeat:Connect(function()
        if not _G.KillAura then return end
        local char = LocalPlayer.Character; if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local tool = char:FindFirstChildOfClass("Tool")
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer or not p.Character then continue end
            local friendly = p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team
            if friendly then continue end
            local phum = p.Character:FindFirstChildOfClass("Humanoid")
            local phrp = p.Character:FindFirstChild("HumanoidRootPart")
            if not phum or not phrp or phum.Health <= 0 then continue end
            if (phrp.Position - hrp.Position).Magnitude <= _G.KillAuraRange then
                if tool then
                    for _, child in ipairs(tool:GetDescendants()) do
                        if child:IsA("RemoteEvent") then
                            pcall(function() child:FireServer(p.Character) end)
                        end
                    end
                    pcall(function() tool:Activate() end)
                end
                dealDamage(p.Character, phrp, phrp.Position)
            end
        end
    end)
end
disableKillAura = function()
    if killAuraConn then killAuraConn:Disconnect(); killAuraConn = nil end
end

-- Anti AFK
local antiAfkConn
enableAntiAFK = function()
    if antiAfkConn then antiAfkConn:Disconnect() end
    antiAfkConn = RunService.Heartbeat:Connect(function()
        if not _G.AntiAFK then return end
        pcall(function()
            local vu = game:GetService("VirtualUser")
            vu:CaptureController(); vu:ClickButton2(Vector2.new())
        end)
    end)
end
disableAntiAFK = function()
    if antiAfkConn then antiAfkConn:Disconnect(); antiAfkConn = nil end
end

-- Name Spoof
local nameSpoofConn
applyNameSpoof = function()
    local name = _G.SpoofedName ~= "" and _G.SpoofedName or LocalPlayer.Name
    local function spoof(char)
        if not char then return end
        local head = char:FindFirstChild("Head"); if not head then return end
        for _, gui in ipairs(head:GetChildren()) do
            if gui:IsA("BillboardGui") and gui.Name ~= "SusanoNameTag" then
                gui.Enabled = not _G.NameSpoof
            end
        end
        local existing = head:FindFirstChild("SusanoNameTag")
        if _G.NameSpoof then
            if not existing then
                local bb = Instance.new("BillboardGui", head)
                bb.Name = "SusanoNameTag"; bb.AlwaysOnTop = false
                bb.Size = UDim2.new(0, 250, 0, 36); bb.StudsOffset = Vector3.new(0, 2.2, 0)
                local lbl = Instance.new("TextLabel", bb)
                lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.new(1,1,1); lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = 17; lbl.TextStrokeTransparency = 0.5; lbl.Name = "NSL"
            end
            local lbl = head.SusanoNameTag:FindFirstChild("NSL")
            if lbl then lbl.Text = name end
            pcall(function() LocalPlayer.DisplayName = name end)
        else
            if existing then existing:Destroy() end
            for _, gui in ipairs(head:GetChildren()) do
                if gui:IsA("BillboardGui") then gui.Enabled = true end
            end
            pcall(function() LocalPlayer.DisplayName = LocalPlayer.Name end)
        end
    end
    spoof(LocalPlayer.Character)
    if nameSpoofConn then nameSpoofConn:Disconnect() end
    if _G.NameSpoof then
        nameSpoofConn = LocalPlayer.CharacterAdded:Connect(function(char)
            task.wait(0.5); spoof(char)
        end)
    end
end

-- Visual
local origAmbient   = Lighting.Ambient
local origBrightness= Lighting.Brightness
local origFogEnd    = Lighting.FogEnd
local origFogStart  = Lighting.FogStart
local origCamFOV    = Camera.FieldOfView
local origTimeOfDay = Lighting.TimeOfDay
local origColorShift= Lighting.ColorShift_Top

applyFullBright = function(on)
    if on then
        Lighting.Ambient = Color3.new(1,1,1); Lighting.Brightness = 2
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("BlurEffect") or e:IsA("ColorCorrectionEffect") or
               e:IsA("SunRaysEffect") or e:IsA("BloomEffect") then
                e.Enabled = false
            end
        end
    else
        Lighting.Ambient = origAmbient; Lighting.Brightness = origBrightness
    end
end

applyNoFog = function(on)
    if on then Lighting.FogEnd = 1e6; Lighting.FogStart = 1e6
    else Lighting.FogEnd = origFogEnd; Lighting.FogStart = origFogStart end
end

applyTime = function(on)
    if on then Lighting.TimeOfDay = string.format("%02d:00:00", math.floor(_G.TimeOfDay))
    else Lighting.TimeOfDay = origTimeOfDay end
end

applyWorldColor = function(on)
    if on then Lighting.ColorShift_Top = Color3.fromRGB(_G.WorldR, _G.WorldG, _G.WorldB)
    else Lighting.ColorShift_Top = origColorShift end
end

local thirdPersonConn
enableThirdPerson = function()
    Camera.CameraType = Enum.CameraType.Scriptable
    if thirdPersonConn then thirdPersonConn:Disconnect() end
    thirdPersonConn = RunService.RenderStepped:Connect(function()
        if not _G.ThirdPerson then disableThirdPerson(); return end
        local char = LocalPlayer.Character; if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local d = _G.ThirdPersonDist
        Camera.CFrame = CFrame.new(
            hrp.CFrame.Position - hrp.CFrame.LookVector * d + Vector3.new(0, d * 0.4, 0),
            hrp.Position
        )
    end)
end
disableThirdPerson = function()
    if thirdPersonConn then thirdPersonConn:Disconnect(); thirdPersonConn = nil end
    Camera.CameraType = Enum.CameraType.Custom
end

-- Auto Rejoin
local function setupAutoRejoin()
    Players.PlayerRemoving:Connect(function(p)
        if p == LocalPlayer and _G.AutoRejoin then
            task.wait(3)
            pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end)
        end
    end)
end

-- Server Hop
local function serverHop()
    task.spawn(function()
        local ok, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(
                "https://games.roblox.com/v1/games/" .. game.PlaceId ..
                "/servers/Public?sortOrder=Asc&limit=100"
            ))
        end)
        if ok and result and result.data then
            for _, s in ipairs(result.data) do
                if s.id ~= game.JobId and s.playing < s.maxPlayers then
                    pcall(function()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(
                            game.PlaceId, s.id, LocalPlayer
                        )
                    end)
                    return
                end
            end
        end
    end)
end

-- FPS Boost
local fpsBoostActive = false
local hiddenObjects = {}
local function enableFPSBoost()
    if fpsBoostActive then return end; fpsBoostActive = true
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or
           obj:IsA("Fire") or obj:IsA("Sparkles") then
            pcall(function() obj.Enabled = false; table.insert(hiddenObjects, obj) end)
        end
    end
    Lighting.GlobalShadows = false
end
local function disableFPSBoost()
    fpsBoostActive = false
    for _, obj in ipairs(hiddenObjects) do pcall(function() obj.Enabled = true end) end
    hiddenObjects = {}
    Lighting.GlobalShadows = true
end

-- Chat Logger
local chatLoggerConn, chatLoggerGui, chatLogScroll

local function enableChatLogger()
    if chatLoggerGui then return end
    chatLoggerGui = makeScreenGui("SusanoChatLog", 100)
    local frame = Instance.new("Frame", chatLoggerGui)
    frame.Size = UDim2.new(0, 300, 0, 180)
    frame.Position = UDim2.new(0, 10, 1, -200)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    frame.BackgroundTransparency = 0.2; frame.BorderSizePixel = 0
    makeCorner(8, frame)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 22)
    title.BackgroundColor3 = Color3.fromRGB(15, 15, 15); title.BackgroundTransparency = 0
    title.Text = "💬 Chat Log - Susano"; title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold; title.TextSize = 12
    makeCorner(8, title)

    chatLogScroll = Instance.new("ScrollingFrame", frame)
    chatLogScroll.Size = UDim2.new(1, -6, 1, -26)
    chatLogScroll.Position = UDim2.new(0, 3, 0, 24)
    chatLogScroll.BackgroundTransparency = 1; chatLogScroll.ScrollBarThickness = 2
    chatLogScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    chatLogScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; chatLogScroll.BorderSizePixel = 0
    Instance.new("UIListLayout", chatLogScroll).Padding = UDim.new(0, 2)

    -- Mevcut loglari goster
    for _, log in ipairs(chatLogs) do
        local lbl = Instance.new("TextLabel", chatLogScroll)
        lbl.Size = UDim2.new(1, -4, 0, 16); lbl.BackgroundTransparency = 1
        lbl.Text = log:sub(1, 48); lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    end

    local function addLog(playerName, message)
        local logText = os.date("%H:%M") .. " [" .. playerName .. "] " .. message
        table.insert(chatLogs, logText)
        if chatLogScroll then
            local lbl = Instance.new("TextLabel", chatLogScroll)
            lbl.Size = UDim2.new(1, -4, 0, 16); lbl.BackgroundTransparency = 1
            lbl.Text = logText:sub(1, 48); lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
            lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
        end
    end

    -- TUM oyunculari bagla
    local function bindPlayerChat(p)
        if p == LocalPlayer then return end
        p.Chatted:Connect(function(msg) if _G.ChatLogger then addLog(p.Name, msg) end end)
    end
    for _, p in ipairs(Players:GetPlayers()) do bindPlayerChat(p) end
    chatLoggerConn = Players.PlayerAdded:Connect(function(p) bindPlayerChat(p) end)
end

local function disableChatLogger()
    if chatLoggerConn then chatLoggerConn:Disconnect(); chatLoggerConn = nil end
    if chatLoggerGui then chatLoggerGui:Destroy(); chatLoggerGui = nil; chatLogScroll = nil end
end

-- MiniMap
local miniMapGui, miniMapConn, miniMapDots
local function enableMiniMap()
    if miniMapGui then return end
    miniMapGui = makeScreenGui("SusanoMiniMap", 150); miniMapDots = {}
    local size = 180
    local frame = Instance.new("Frame", miniMapGui)
    frame.Size = UDim2.new(0, size, 0, size)
    frame.Position = UDim2.new(1, -size - 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    frame.BackgroundTransparency = 0.15; frame.BorderSizePixel = 0
    makeCorner(90, frame)
    local brd = Instance.new("UIStroke", frame)
    brd.Color = Tc.Accent; brd.Thickness = 1.5; brd.Transparency = 0.5

    local radarLabel = Instance.new("TextLabel", frame)
    radarLabel.Size = UDim2.new(1, 0, 0, 14); radarLabel.BackgroundTransparency = 1
    radarLabel.Text = "RADAR"; radarLabel.TextColor3 = Tc.Accent
    radarLabel.Font = Enum.Font.GothamBold; radarLabel.TextSize = 9

    local centerDot = Instance.new("Frame", frame)
    centerDot.Size = UDim2.new(0, 8, 0, 8)
    centerDot.AnchorPoint = Vector2.new(0.5, 0.5); centerDot.Position = UDim2.new(0.5, 0, 0.5, 0)
    centerDot.BackgroundColor3 = Color3.new(1,1,1); centerDot.BorderSizePixel = 0
    makeCorner(4, centerDot)

    if miniMapConn then miniMapConn:Disconnect() end
    miniMapConn = RunService.RenderStepped:Connect(function()
        if not _G.MiniMap then return end
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local activePlayers = {}
        for _, p in ipairs(Players:GetPlayers()) do activePlayers[p] = true end
        for p, dot in pairs(miniMapDots) do
            if not activePlayers[p] then dot:Destroy(); miniMapDots[p] = nil end
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer or not p.Character then continue end
            local hrp = p.Character:FindFirstChild("HumanoidRootPart"); if not hrp then continue end
            local diff = hrp.Position - myHRP.Position
            local range = 200
            local nx = math.clamp(diff.X / range, -0.5, 0.5)
            local nz = math.clamp(diff.Z / range, -0.5, 0.5)
            if not miniMapDots[p] then
                local dot = Instance.new("Frame", frame)
                dot.Size = UDim2.new(0, 6, 0, 6)
                dot.AnchorPoint = Vector2.new(0.5, 0.5); dot.BorderSizePixel = 0
                makeCorner(3, dot)
                local nameLabel = Instance.new("TextLabel", dot)
                nameLabel.Size = UDim2.new(0, 60, 0, 12)
                nameLabel.Position = UDim2.new(1, 2, 0, -2); nameLabel.BackgroundTransparency = 1
                nameLabel.Text = p.Name:sub(1, 7); nameLabel.TextColor3 = Color3.new(1,1,1)
                nameLabel.Font = Enum.Font.GothamBold; nameLabel.TextSize = 8
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                miniMapDots[p] = dot
            end
            local friendly = p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team
            miniMapDots[p].BackgroundColor3 = friendly and Color3.fromRGB(80,180,255) or Color3.fromRGB(255,80,80)
            miniMapDots[p].Position = UDim2.new(0.5 + nx, 0, 0.5 + nz, 0)
        end
    end)
end
local function disableMiniMap()
    if miniMapConn then miniMapConn:Disconnect(); miniMapConn = nil end
    if miniMapGui then miniMapGui:Destroy(); miniMapGui = nil; miniMapDots = nil end
end

-- ESP SİSTEMİ
local espCache = {}
local esp2DDrawings = {}
local espTracerDrawings = {}

local function clearESPDrawings(player)
    if esp2DDrawings[player] then
        for _, v in pairs(esp2DDrawings[player]) do
            pcall(function() v.Visible = false; v:Remove() end)
        end
        esp2DDrawings[player] = nil
    end
    if espTracerDrawings[player] then
        pcall(function() espTracerDrawings[player].Visible = false; espTracerDrawings[player]:Remove() end)
        espTracerDrawings[player] = nil
    end
end

local function clearESPPlayer(player)
    if espCache[player] then
        if espCache[player].highlight then pcall(function() espCache[player].highlight:Destroy() end) end
        if espCache[player].billboard then pcall(function() espCache[player].billboard:Destroy() end) end
        if espCache[player].healthBillboard then pcall(function() espCache[player].healthBillboard:Destroy() end) end
        espCache[player] = nil
    end
    clearESPDrawings(player)
    clearSkeleton(player)
end

local function clearAllESP()
    for player in pairs(espCache) do clearESPPlayer(player) end
    for player in pairs(esp2DDrawings) do clearESPDrawings(player) end
end

local function buildESPForPlayer(player)
    if not _G.ESP or player == LocalPlayer or espCache[player] then return end
    local char = player.Character; if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart", 5); if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")

    -- 3D Highlight
    local hl = Instance.new("Highlight")
    hl.Adornee = char; hl.FillTransparency = 0.75
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled = false; hl.Parent = CoreGui

    -- Name/Distance billboard
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(6, 0, 3, 0); bb.AlwaysOnTop = true
    bb.StudsOffset = Vector3.new(0, 4, 0); bb.Adornee = hrp
    bb.Enabled = false; bb.Parent = CoreGui

    local function makeBBLabel(posY, sizeY, color, fontSize)
        local lbl = Instance.new("TextLabel", bb)
        lbl.Size = UDim2.new(1, 0, sizeY, 0)
        lbl.Position = UDim2.new(0, 0, posY, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = color
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = fontSize
        lbl.TextStrokeTransparency = 0.4
        return lbl
    end
    local idLabel   = makeBBLabel(0,   0.3, Color3.fromRGB(160, 160, 255), 12)
    local nameLabel = makeBBLabel(0.3, 0.4, Color3.fromRGB(_G.ESPNameR, _G.ESPNameG, _G.ESPNameB), 16)
    local distLabel = makeBBLabel(0.7, 0.3, Color3.fromRGB(255, 220, 80), 12)

    -- Health bar billboard
    local hbBB = Instance.new("BillboardGui")
    hbBB.Size = UDim2.new(0.4, 0, 2, 0); hbBB.AlwaysOnTop = true
    hbBB.StudsOffset = Vector3.new(-1.8, 2, 0); hbBB.Adornee = hrp
    hbBB.Enabled = false; hbBB.Parent = CoreGui
    local hbBG = Instance.new("Frame", hbBB)
    hbBG.Size = UDim2.new(0, 4, 1, 0); hbBG.BackgroundColor3 = Color3.fromRGB(20, 20, 20); hbBG.BorderSizePixel = 0
    local hbFill = Instance.new("Frame", hbBG)
    hbFill.Size = UDim2.new(1, 0, 1, 0); hbFill.BackgroundColor3 = Color3.fromRGB(80, 255, 120); hbFill.BorderSizePixel = 0

    espCache[player] = {
        highlight = hl, billboard = bb, healthBillboard = hbBB,
        hbFill = hbFill, idLabel = idLabel, nameLabel = nameLabel, distLabel = distLabel,
        hrp = hrp, hum = hum
    }

    -- 2D Drawing
    local e = {}
    e.box = Drawing.new("Square"); e.box.Visible = false; e.box.Thickness = 1.5; e.box.Filled = false
    e.name = Drawing.new("Text"); e.name.Visible = false; e.name.Size = 14; e.name.Font = 2; e.name.Center = true
    e.dist = Drawing.new("Text"); e.dist.Visible = false; e.dist.Size = 12; e.dist.Font = 2; e.dist.Center = true; e.dist.Color = Color3.fromRGB(255, 220, 80)
    e.idtxt = Drawing.new("Text"); e.idtxt.Visible = false; e.idtxt.Size = 11; e.idtxt.Font = 2; e.idtxt.Center = true; e.idtxt.Color = Color3.fromRGB(160, 160, 255)
    e.hbg = Drawing.new("Square"); e.hbg.Visible = false; e.hbg.Filled = true; e.hbg.Color = Color3.fromRGB(20, 20, 20)
    e.hbf = Drawing.new("Square"); e.hbf.Visible = false; e.hbf.Filled = true
    esp2DDrawings[player] = e

    local tracer = Drawing.new("Line")
    tracer.Visible = false; tracer.Thickness = _G.TracerThick; tracer.Transparency = 0.3
    espTracerDrawings[player] = tracer
end

local function updateESP()
    if not _G.ESP then clearAllESP(); return end
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    local colorEnemy  = Color3.fromRGB(_G.ESPEnemyR,  _G.ESPEnemyG,  _G.ESPEnemyB)
    local colorFriend = Color3.fromRGB(_G.ESPFriendR, _G.ESPFriendG, _G.ESPFriendB)
    local colorVis    = Color3.fromRGB(_G.ESPVisR,    _G.ESPVisG,    _G.ESPVisB)
    local colorName   = Color3.fromRGB(_G.ESPNameR,   _G.ESPNameG,   _G.ESPNameB)

    -- Ayrilan oyunculari temizle
    local activePlayers = {}
    for _, p in ipairs(Players:GetPlayers()) do activePlayers[p] = true end
    for p in pairs(espCache) do if not activePlayers[p] then clearESPPlayer(p) end end

    for player, cache in pairs(espCache) do
        if not (player and player.Parent and cache.hrp and cache.hrp.Parent) then
            clearESPPlayer(player); continue
        end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = cache.hrp
        local dist = (hrp.Position - myHRP.Position).Magnitude
        local friendly = player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team
        local show = (friendly and _G.ShowFriendly) or (not friendly and _G.TeamCheck)
        if not (show and hum and hum.Health > 0) then show = false end

        local visible = false
        if _G.WallCheck and show and not friendly then visible = isPlayerVisible(player) end
        local col = friendly and colorFriend or (_G.WallCheck and (visible and colorVis or colorEnemy) or colorEnemy)

        -- 3D Highlight
        if cache.highlight then
            cache.highlight.Enabled = _G.ESPBox3D and show
            if cache.highlight.Enabled then
                cache.highlight.FillColor = col; cache.highlight.OutlineColor = col
                cache.highlight.DepthMode = (_G.WallCheck and visible) and
                    Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
            end
        end

        -- Billboard labels
        if cache.billboard then
            cache.billboard.Enabled = show
            if show then
                cache.idLabel.Visible  = _G.ShowID;       cache.idLabel.Text  = "ID:" .. player.UserId
                cache.nameLabel.Visible = _G.ShowNames;   cache.nameLabel.Text = player.Name; cache.nameLabel.TextColor3 = colorName
                cache.distLabel.Visible = _G.ShowDistance; cache.distLabel.Text = math.floor(dist) .. "m"
            end
        end

        -- Health bar
        if cache.healthBillboard then
            cache.healthBillboard.Enabled = _G.ShowHealthBar and show
            if cache.healthBillboard.Enabled and hum and hum.Health > 0 then
                local pct = hum.Health / hum.MaxHealth
                cache.hbFill.Size = UDim2.new(1, 0, pct, 0)
                cache.hbFill.Position = UDim2.new(0, 0, 1 - pct, 0)
                cache.hbFill.BackgroundColor3 = pct > 0.6 and Color3.fromRGB(80, 255, 120) or
                    (pct > 0.3 and Color3.fromRGB(255, 220, 80) or Color3.fromRGB(255, 80, 80))
            end
        end

        -- 2D Box
        local e = esp2DDrawings[player]
        if e then
            if _G.ESPBox2D and show then
                local sp, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local sh = Camera:WorldToViewportPoint(head.Position)
                        local boxH = math.abs(sh.Y - sp.Y) * 2.3
                        local boxW = boxH * 0.55
                        local topLeft = Vector2.new(sp.X - boxW/2, sh.Y - boxH/2)

                        e.box.Visible = true; e.box.Position = topLeft; e.box.Size = Vector2.new(boxW, boxH); e.box.Color = col

                        if _G.ShowNames then e.name.Visible = true; e.name.Position = Vector2.new(sp.X, sh.Y-boxH/2-18); e.name.Text = player.Name; e.name.Color = colorName else e.name.Visible = false end
                        if _G.ShowDistance then e.dist.Visible = true; e.dist.Position = Vector2.new(sp.X, sh.Y+boxH/2+4); e.dist.Text = math.floor(dist).."m" else e.dist.Visible = false end
                        if _G.ShowID then e.idtxt.Visible = true; e.idtxt.Position = Vector2.new(sp.X, sh.Y-boxH/2-32); e.idtxt.Text = "ID:"..player.UserId else e.idtxt.Visible = false end

                        if _G.ShowHealthBar and hum and hum.Health > 0 then
                            local pct = hum.Health / hum.MaxHealth
                            e.hbg.Visible = true; e.hbg.Position = Vector2.new(topLeft.X-7, topLeft.Y); e.hbg.Size = Vector2.new(3, boxH)
                            e.hbf.Visible = true; e.hbf.Position = Vector2.new(topLeft.X-7, topLeft.Y+boxH*(1-pct)); e.hbf.Size = Vector2.new(3, boxH*pct)
                            e.hbf.Color = pct>0.6 and Color3.fromRGB(80,255,120) or (pct>0.3 and Color3.fromRGB(255,220,80) or Color3.fromRGB(255,80,80))
                        else e.hbg.Visible = false; e.hbf.Visible = false end
                    else for _, v in pairs(e) do pcall(function() v.Visible = false end) end end
                else for _, v in pairs(e) do pcall(function() v.Visible = false end) end end
            else for _, v in pairs(e) do pcall(function() v.Visible = false end) end end
        end

        -- Tracer
        local tracer = espTracerDrawings[player]
        if tracer then
            tracer.Thickness = _G.TracerThick
            if _G.ShowTracer and show then
                local sp, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    tracer.Visible = true
                    tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    tracer.To = Vector2.new(sp.X, sp.Y)
                    tracer.Color = col
                else tracer.Visible = false end
            else tracer.Visible = false end
        end
    end
end

-- ESP oyuncu baglama
local function bindESPToPlayer(player)
    if player == LocalPlayer then return end
    player.CharacterAdded:Connect(function()
        if _G.ESP then task.wait(1); buildESPForPlayer(player) end
    end)
    player.CharacterRemoving:Connect(function() clearESPPlayer(player) end)
    if player.Character and _G.ESP then task.wait(0.5); buildESPForPlayer(player) end
end
Players.PlayerAdded:Connect(function(p) bindESPToPlayer(p) end)
Players.PlayerRemoving:Connect(function(p) clearESPPlayer(p) end)
for _, p in ipairs(Players:GetPlayers()) do bindESPToPlayer(p) end

-- LOCAL CONFIG
local function buildConfigData()
    return {
        ESP=_G.ESP,ESPBox3D=_G.ESPBox3D,ESPBox2D=_G.ESPBox2D,ShowNames=_G.ShowNames,
        ShowDistance=_G.ShowDistance,ShowHealthBar=_G.ShowHealthBar,ShowID=_G.ShowID,
        ShowTracer=_G.ShowTracer,TracerThick=_G.TracerThick,TeamCheck=_G.TeamCheck,
        ShowFriendly=_G.ShowFriendly,WallCheck=_G.WallCheck,SkeletonESP=_G.SkeletonESP,
        ESPEnemyR=_G.ESPEnemyR,ESPEnemyG=_G.ESPEnemyG,ESPEnemyB=_G.ESPEnemyB,
        ESPFriendR=_G.ESPFriendR,ESPFriendG=_G.ESPFriendG,ESPFriendB=_G.ESPFriendB,
        ESPVisR=_G.ESPVisR,ESPVisG=_G.ESPVisG,ESPVisB=_G.ESPVisB,
        ESPNameR=_G.ESPNameR,ESPNameG=_G.ESPNameG,ESPNameB=_G.ESPNameB,
        Crosshair=_G.Crosshair,CrosshairStyle=_G.CrosshairStyle,CrosshairSize=_G.CrosshairSize,
        CrosshairThick=_G.CrosshairThick,CrosshairGap=_G.CrosshairGap,CrosshairAlpha=_G.CrosshairAlpha,
        CrosshairDot=_G.CrosshairDot,CrosshairOutline=_G.CrosshairOutline,
        CrosshairR=_G.CrosshairR,CrosshairG=_G.CrosshairG,CrosshairB=_G.CrosshairB,
        Aimbot=_G.Aimbot,RageAimbot=_G.RageAimbot,SilentAim=_G.SilentAim,
        MagicBullet=_G.MagicBullet,TriggerBot=_G.TriggerBot,TriggerBotDelay=_G.TriggerBotDelay,
        UseFOV=_G.UseFOV,FOVVisible=_G.FOVVisible,FOVSize=_G.FOVSize,AimbotSmooth=_G.AimbotSmooth,
        AimHead=_G.AimHead,AimChest=_G.AimChest,AimStomach=_G.AimStomach,
        HitboxEnabled=_G.HitboxEnabled,HitboxSize=_G.HitboxSize,FakeLag=_G.FakeLag,FakeLagInterval=_G.FakeLagInterval,
        Godmode=_G.Godmode,FlyEnabled=_G.FlyEnabled,FlySpeed=_G.FlySpeed,
        NoClip=_G.NoClip,BunnyHop=_G.BunnyHop,BhopSpeed=_G.BhopSpeed,BhopHeight=_G.BhopHeight,
        SpeedHack=_G.SpeedHack,SpeedMult=_G.SpeedMult,InfiniteJump=_G.InfiniteJump,
        LongJump=_G.LongJump,LongJumpPower=_G.LongJumpPower,SwimHack=_G.SwimHack,
        GravityHack=_G.GravityHack,GravityValue=_G.GravityValue,TeleportCursor=_G.TeleportCursor,
        KillAura=_G.KillAura,KillAuraRange=_G.KillAuraRange,AntiAFK=_G.AntiAFK,
        NameSpoof=_G.NameSpoof,SpoofedName=_G.SpoofedName,
        FullBright=_G.FullBright,NoFog=_G.NoFog,FOVChanger=_G.FOVChanger,FOVChangerVal=_G.FOVChangerVal,
        ThirdPerson=_G.ThirdPerson,ThirdPersonDist=_G.ThirdPersonDist,TimeChanger=_G.TimeChanger,
        TimeOfDay=_G.TimeOfDay,WorldColor=_G.WorldColor,WorldR=_G.WorldR,WorldG=_G.WorldG,WorldB=_G.WorldB,
        _THEME = currentThemeIndex, _LANG = LANG,
    }
end

local function applyConfigData(data)
    for k, v in pairs(data) do
        if k == "_THEME" then currentThemeIndex = v; Tc = makeThemeColors()
        elseif k == "_LANG" then LANG = v
        else _G[k] = v end
    end
end

local function listLocalConfigs()
    local result = {}
    for _, f in ipairs(safeList(CFG_FOLDER)) do
        local name = f:match("([^/\\]+)%.json$")
        if name then table.insert(result, name) end
    end
    return result
end

local function saveLocalConfig(name)
    safeMkDir(CFG_FOLDER)
    local ok, json = pcall(function() return HttpService:JSONEncode(buildConfigData()) end)
    if not ok then return false end
    safeWrite(CFG_FOLDER .. "/" .. name .. ".json", json)
    return true
end

local function loadLocalConfig(name)
    local ok, content = safeRead(CFG_FOLDER .. "/" .. name .. ".json")
    if not ok or not content then return false end
    local ok2, data = pcall(function() return HttpService:JSONDecode(content) end)
    if not ok2 then return false end
    applyConfigData(data)
    return true
end

local function deleteLocalConfig(name)
    safeDel(CFG_FOLDER .. "/" .. name .. ".json")
end

-- TAB BUILDER'LAR
local tabBuilders = {}

tabBuilders["ESP"] = function(parent)
    local sc = makeScrollFrame(parent); local y = 10
    y = buildSection(sc, T("s_vis"), y)
    y = buildToggle(sc, T("t_esp"),    "ESP",        y, function(v) if not v then clearAllESP() end end)
    y = buildToggle(sc, T("t_3d"),     "ESPBox3D",   y)
    y = buildToggle(sc, T("t_2d"),     "ESPBox2D",   y)
    y = buildToggle(sc, T("t_sk"),     "SkeletonESP",y)
    y = buildSection(sc, T("s_lbl"), y+4)
    y = buildToggle(sc, T("t_nm"),  "ShowNames",    y)
    y = buildToggle(sc, T("t_ds"),  "ShowDistance", y)
    y = buildToggle(sc, T("t_hp"),  "ShowHealthBar",y)
    y = buildToggle(sc, T("t_id"),  "ShowID",       y)
    y = buildToggle(sc, T("t_tr"),  "ShowTracer",   y)
    y = buildSlider(sc, T("l_tt"),  "TracerThick",  y, 0.5, 6, "%.1f")
    y = buildSection(sc, T("s_flt"), y+4)
    y = buildToggle(sc, T("t_tc"),  "TeamCheck",    y)
    y = buildToggle(sc, T("t_fr"),  "ShowFriendly", y)
    y = buildToggle(sc, T("t_wc"),  "WallCheck",    y)
    y = buildSection(sc, T("s_nm2"), y+4)
    y = buildColorPreview(sc, "ESPNameR","ESPNameG","ESPNameB", y)
    y = buildSlider(sc, T("l_r"), "ESPNameR", y, 0, 255)
    y = buildSlider(sc, T("l_g"), "ESPNameG", y, 0, 255)
    y = buildSlider(sc, T("l_b"), "ESPNameB", y, 0, 255)
    y = buildSection(sc, T("s_enm"), y+4)
    y = buildColorPreview(sc, "ESPEnemyR","ESPEnemyG","ESPEnemyB", y)
    y = buildSlider(sc, T("l_r"), "ESPEnemyR", y, 0, 255)
    y = buildSlider(sc, T("l_g"), "ESPEnemyG", y, 0, 255)
    y = buildSlider(sc, T("l_b"), "ESPEnemyB", y, 0, 255)
    y = buildSection(sc, T("s_frn"), y+4)
    y = buildColorPreview(sc, "ESPFriendR","ESPFriendG","ESPFriendB", y)
    y = buildSlider(sc, T("l_r"), "ESPFriendR", y, 0, 255)
    y = buildSlider(sc, T("l_g"), "ESPFriendG", y, 0, 255)
    y = buildSlider(sc, T("l_b"), "ESPFriendB", y, 0, 255)
    y = buildSection(sc, T("s_vc"), y+4)
    y = buildColorPreview(sc, "ESPVisR","ESPVisG","ESPVisB", y)
    y = buildSlider(sc, T("l_r"), "ESPVisR", y, 0, 255)
    y = buildSlider(sc, T("l_g"), "ESPVisG", y, 0, 255)
    y = buildSlider(sc, T("l_b"), "ESPVisB", y, 0, 255)
    y = buildSection(sc, T("s_crs"), y+4)
    y = buildToggle(sc, T("t_crs"), "Crosshair", y, function() buildCrosshair() end)
    y = buildDropdown(sc, "Stil", CH_STYLES, function() return _G.CrosshairStyle end, function(v) _G.CrosshairStyle=v; buildCrosshair() end, y)
    y = buildSlider(sc, T("l_sz"),  "CrosshairSize",  y, 4,  50,  nil,   function() buildCrosshair() end)
    y = buildSlider(sc, T("l_th"),  "CrosshairThick", y, 1,  8,   nil,   function() buildCrosshair() end)
    y = buildSlider(sc, T("l_gp"),  "CrosshairGap",   y, 0,  24,  nil,   function() buildCrosshair() end)
    y = buildSlider(sc, T("l_op"),  "CrosshairAlpha", y, 0.1,1.0,"%.1f", function() buildCrosshair() end)
    y = buildToggle(sc, T("t_dot"), "CrosshairDot",   y, function() buildCrosshair() end)
    y = buildToggle(sc, T("t_out"), "CrosshairOutline",y,function() buildCrosshair() end)
    y = buildColorPreview(sc, "CrosshairR","CrosshairG","CrosshairB", y)
    y = buildSlider(sc, T("l_r"), "CrosshairR", y, 0, 255, nil, function() buildCrosshair() end)
    y = buildSlider(sc, T("l_g"), "CrosshairG", y, 0, 255, nil, function() buildCrosshair() end)
    y = buildSlider(sc, T("l_b"), "CrosshairB", y, 0, 255, nil, function() buildCrosshair() end)
end

tabBuilders["AIMBOT"] = function(parent)
    local sc = makeScrollFrame(parent); local y = 10
    y = buildSection(sc, T("s_aim"), y)
    y = buildToggle(sc, T("t_aim"), "Aimbot",    y, function(v) webhookFeature("Aimbot", v) end)
    y = buildToggle(sc, T("t_ra"),  "RageAimbot",y, function(v) if v then enableRageAimbot() else disableRageAimbot() end; webhookFeature("Rage Aimbot", v) end)
    y = buildSection(sc, T("s_sil"), y+4)
    y = buildToggle(sc, T("t_sa"),  "SilentAim", y, function(v) if v then enableSilentAim() else disableSilentAim() end; webhookFeature("Silent Aim", v) end)
    y = buildSection(sc, T("s_tb"), y+4)
    y = buildToggle(sc, T("t_tb"),  "TriggerBot",y, function(v) if v then enableTriggerBot() else disableTriggerBot() end; webhookFeature("Trigger Bot", v) end)
    y = buildSlider(sc, T("l_tbs"), "TriggerBotDelay", y, 0.01, 0.5, "%.2f")
    y = buildSection(sc, T("s_mb"), y+4)
    y = buildToggle(sc, T("t_mb"),  "MagicBullet",y, function(v) if v then enableMagicBullet() else disableMagicBullet() end; webhookFeature("Magic Bullet", v) end)
    y = buildSection(sc, T("s_hbx"), y+4)
    y = buildToggle(sc, T("t_hb"),  "HitboxEnabled",y, function(v) if v then enableHitbox() else disableHitbox() end; webhookFeature("Hitbox", v) end)
    y = buildSlider(sc, T("l_hbs"), "HitboxSize",    y, 1, 20, "%.1f")
    y = buildSection(sc, T("s_flg"), y+4)
    y = buildToggle(sc, T("t_fl"),  "FakeLag",y, function(v) if v then enableFakeLag() else disableFakeLag() end; webhookFeature("Fake Lag", v) end)
    y = buildSlider(sc, T("l_lag"), "FakeLagInterval", y, 0.0, 0.5, "%.2f")
    y = buildSection(sc, T("s_fov"), y+4)
    y = buildToggle(sc, T("t_ff"),  "UseFOV",   y)
    y = buildToggle(sc, T("t_fc"),  "FOVVisible",y, function(v) if fovCircle then fovCircle.Visible = v end end)
    y = buildSlider(sc, T("l_fov"), "FOVSize",   y, 20, 400)
    y = buildSection(sc, T("s_smt"), y+4)
    y = buildSlider(sc, T("l_sm"),  "AimbotSmooth", y, 0.02, 1.0, "%.2f")
    y = buildSection(sc, T("s_tgt"), y+4)
    y = buildToggle(sc, "Kafa",    "AimHead",   y)
    y = buildToggle(sc, "Gogus",   "AimChest",  y)
    y = buildToggle(sc, "Karin",   "AimStomach",y)
end

tabBuilders["MOVEMENT"] = function(parent)
    local sc = makeScrollFrame(parent); local y = 10
    y = buildSection(sc, T("s_fly"), y)
    y = buildToggle(sc, T("t_fly"), "FlyEnabled", y, function(v) if v then enableFly() else disableFly() end; webhookFeature("Fly", v) end)
    y = buildSlider(sc, T("l_fls"), "FlySpeed", y, 10, 2000)
    y = buildWarningLabel(sc, T("warn_speed"), y)
    y = buildSection(sc, T("s_mov"), y+4)
    y = buildToggle(sc, T("t_nc"),  "NoClip",       y, function(v) if v then enableNoclip() else disableNoclip() end; webhookFeature("Noclip", v) end)
    y = buildToggle(sc, T("t_ij"),  "InfiniteJump", y, function(v) if v then enableInfiniteJump() else disableInfiniteJump() end; webhookFeature("Inf Jump", v) end)
    y = buildToggle(sc, T("t_lj"),  "LongJump",     y, function(v) if v then enableLongJump() else disableLongJump() end; webhookFeature("Long Jump", v) end)
    y = buildSlider(sc, T("l_pow"), "LongJumpPower",y, 20, 200)
    y = buildToggle(sc, T("t_sw"),  "SwimHack",     y, function(v) webhookFeature("Swim Hack", v) end)
    y = buildSection(sc, T("s_bhp"), y+4)
    y = buildToggle(sc, T("t_bh"),  "BunnyHop", y, function(v) if v then enableBhop() else disableBhop() end; webhookFeature("Bhop", v) end)
    y = buildSlider(sc, T("l_bhs"), "BhopSpeed",y, 1.0, 3.0, "%.1f")
    y = buildSection(sc, T("s_spd"), y+4)
    y = buildToggle(sc, T("t_sh"),  "SpeedHack", y, function(v) if v then enableSpeed() else disableSpeed() end; webhookFeature("Speed Hack", v) end)
    y = buildSlider(sc, T("l_mul"), "SpeedMult", y, 1.0, 50.0, "%.1f")
    y = buildWarningLabel(sc, T("warn_speed"), y)
    y = buildSection(sc, T("s_grv"), y+4)
    y = buildToggle(sc, T("t_gh"),  "GravityHack", y, function(v) if not v then Workspace.Gravity = 196.2 end; webhookFeature("Gravity", v) end)
    y = buildSlider(sc, T("l_gv"),  "GravityValue",y, 0, 500, "%.1f", function(v) if _G.GravityHack then Workspace.Gravity = v end end)
    y = buildSection(sc, T("s_tp"), y+4)
    y = buildToggle(sc, T("t_ct"),  "TeleportCursor", y, function(v) webhookFeature("Cursor TP", v) end)
    y = buildSection(sc, T("s_oth"), y+4)
    y = buildToggle(sc, T("t_st"),  "StreamProof", y, function(v) if MainGui then MainGui.DisplayOrder = v and 200 or 10 end end)
end

tabBuilders["PLAYERS"] = function(parent)
    local sc = makeScrollFrame(parent); local y = 10
    y = buildSection(sc, T("s_cmb"), y)
    y = buildToggle(sc, T("t_ka"),  "KillAura", y, function(v) if v then enableKillAura() else disableKillAura() end; webhookFeature("Kill Aura", v) end)
    y = buildSlider(sc, T("l_rng"), "KillAuraRange", y, 5, 50)
    y = buildSection(sc, T("s_god"), y+4)
    y = buildToggle(sc, T("t_gd"),  "Godmode", y, function(v) if v then enableGodmode() else disableGodmode() end; webhookFeature("Godmode", v) end)
    y = buildSection(sc, T("s_hlp"), y+4)
    y = buildToggle(sc, T("t_af"),  "AntiAFK", y, function(v) if v then enableAntiAFK() else disableAntiAFK() end; webhookFeature("Anti AFK", v) end)
    y = buildSection(sc, T("s_nm"), y+4)
    y = buildToggle(sc, T("t_ns"),  "NameSpoof", y, function() applyNameSpoof() end)
    local nameBox; nameBox, y = buildInput(sc, T("l_nm"), "Isim gir", "", y)
    local applyBtn; applyBtn, y = buildButton(sc, T("b_apply"), y)
    applyBtn.MouseButton1Click:Connect(function() _G.SpoofedName = nameBox.Text; applyNameSpoof() end)
    y = buildSection(sc, "Oyuncu Listesi", y+4)
    local stopBtn; stopBtn, y = buildButton(sc, T("b_stop"), y, Tc.AccentFaint, Tc.Text)
    stopBtn.MouseButton1Click:Connect(function()
        local c = LocalPlayer.Character
        Camera.CameraSubject = (c and c:FindFirstChildOfClass("Humanoid")) or LocalPlayer
    end)
    -- Oyuncu listesi
    local plist = Instance.new("ScrollingFrame", sc)
    plist.Size = UDim2.new(1, -28, 0, 260); plist.Position = UDim2.new(0, 14, 0, y)
    plist.BackgroundColor3 = Tc.Card; makeCorner(8, plist)
    plist.ScrollBarThickness = 3; plist.CanvasSize = UDim2.new(0,0,0,0)
    plist.AutomaticCanvasSize = Enum.AutomaticSize.Y; plist.BorderSizePixel = 0
    local pLayout = Instance.new("UIListLayout", plist); pLayout.Padding = UDim.new(0, 4)
    local pPad = Instance.new("UIPadding", plist)
    pPad.PaddingTop = UDim.new(0,6); pPad.PaddingLeft = UDim.new(0,6); pPad.PaddingRight = UDim.new(0,6)

    local function refreshPlayerList()
        for _, c in ipairs(plist:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end
            local row = Instance.new("Frame", plist)
            row.Size = UDim2.new(1, 0, 0, 42); row.BackgroundColor3 = Tc.CardHover; makeCorner(6, row)
            local nameLbl = Instance.new("TextLabel", row)
            nameLbl.Size = UDim2.new(1, -196, 1, 0); nameLbl.Position = UDim2.new(0, 8, 0, 0)
            nameLbl.BackgroundTransparency = 1; nameLbl.Text = plr.Name
            nameLbl.TextColor3 = Tc.Text; nameLbl.Font = Enum.Font.GothamSemibold
            nameLbl.TextSize = 12; nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            -- HP bar
            local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                local hpBar = Instance.new("Frame", row)
                hpBar.Size = UDim2.new(0, pct * 60, 0, 4)
                hpBar.Position = UDim2.new(0, 8, 1, -6); hpBar.BorderSizePixel = 0
                hpBar.BackgroundColor3 = pct > 0.6 and Color3.fromRGB(80,255,120) or
                    (pct > 0.3 and Color3.fromRGB(255,220,80) or Color3.fromRGB(255,80,80))
                makeCorner(2, hpBar)
            end
            local btDefs = {
                {l=T("b_tp"),   c=Color3.fromRGB(55,55,180),  x=1, xo=-188},
                {l=T("b_pull"), c=Color3.fromRGB(160,90,0),   x=1, xo=-140},
                {l=T("b_spec"), c=Color3.fromRGB(75,75,160),  x=1, xo=-92},
                {l=T("b_frz"),  c=Color3.fromRGB(0,130,130),  x=1, xo=-44},
            }
            local createdBtns = {}
            for _, bd in ipairs(btDefs) do
                local b = Instance.new("TextButton", row)
                b.Size = UDim2.new(0, 42, 0, 28); b.Position = UDim2.new(bd.x, bd.xo, 0.5, -14)
                b.BackgroundColor3 = bd.c; b.TextColor3 = Color3.new(1,1,1)
                b.Font = Enum.Font.GothamBold; b.TextSize = 10; b.Text = bd.l; makeCorner(5, b)
                createdBtns[bd.l] = b
            end
            createdBtns[T("b_tp")].MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and
                   LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                end
            end)
            createdBtns[T("b_pull")].MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and
                   LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    plr.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                end
            end)
            createdBtns[T("b_spec")].MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                    Camera.CameraSubject = plr.Character.Humanoid
                end
            end)
            local frozen = false
            createdBtns[T("b_frz")].MouseButton1Click:Connect(function()
                frozen = not frozen
                if plr.Character then
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        if frozen then
                            if frozenPlayers[plr] then return end
                            local bp = Instance.new("BodyPosition")
                            bp.MaxForce = Vector3.new(4e4,4e4,4e4); bp.P = 2000; bp.D = 100
                            bp.Position = root.Position; bp.Parent = root
                            frozenPlayers[plr] = bp
                        else
                            if frozenPlayers[plr] then frozenPlayers[plr]:Destroy(); frozenPlayers[plr] = nil end
                        end
                    end
                end
                createdBtns[T("b_frz")].Text = frozen and T("b_free") or T("b_frz")
                createdBtns[T("b_frz")].BackgroundColor3 = frozen and Color3.fromRGB(0,180,90) or Color3.fromRGB(0,130,130)
            end)
        end
    end
    refreshPlayerList()
    Players.PlayerAdded:Connect(function() task.wait(0.5); refreshPlayerList() end)
    Players.PlayerRemoving:Connect(function() task.wait(0.2); refreshPlayerList() end)
end

tabBuilders["VISUAL"] = function(parent)
    local sc = makeScrollFrame(parent); local y = 10
    y = buildSection(sc, T("s_lit"), y)
    y = buildToggle(sc, T("t_fb"),  "FullBright", y, function(v) applyFullBright(v); webhookFeature("Full Bright", v) end)
    y = buildToggle(sc, T("t_nf"),  "NoFog",      y, function(v) applyNoFog(v) end)
    y = buildSection(sc, T("s_cam"), y+4)
    y = buildToggle(sc, T("t_fv"),  "FOVChanger", y, function(v) if not v then Camera.FieldOfView = origCamFOV end end)
    y = buildSlider(sc, T("l_val"), "FOVChangerVal", y, 50, 200, nil, function(v) if _G.FOVChanger then Camera.FieldOfView = v end end)
    y = buildToggle(sc, T("t_3p"),  "ThirdPerson",y, function(v) if v then enableThirdPerson() else disableThirdPerson() end end)
    y = buildSlider(sc, T("l_trd"), "ThirdPersonDist", y, 4, 30)
    y = buildSection(sc, T("s_wld"), y+4)
    y = buildToggle(sc, T("t_tc2"), "TimeChanger", y, function(v) applyTime(v) end)
    y = buildSlider(sc, T("l_tm"),  "TimeOfDay",   y, 0, 23, nil, function(v) if _G.TimeChanger then applyTime(true) end end)
    y = buildSection(sc, T("s_wc"), y+4)
    y = buildToggle(sc, T("t_wc2"), "WorldColor", y, function(v) applyWorldColor(v) end)
    y = buildColorPreview(sc, "WorldR","WorldG","WorldB", y)
    y = buildSlider(sc, T("l_r"), "WorldR", y, 0, 255, nil, function() if _G.WorldColor then applyWorldColor(true) end end)
    y = buildSlider(sc, T("l_g"), "WorldG", y, 0, 255, nil, function() if _G.WorldColor then applyWorldColor(true) end end)
    y = buildSlider(sc, T("l_b"), "WorldB", y, 0, 255, nil, function() if _G.WorldColor then applyWorldColor(true) end end)
end

tabBuilders["MISC"] = function(parent)
    local sc = makeScrollFrame(parent); local y = 10
    y = buildSection(sc, T("s_srv"), y)
    local hopBtn; hopBtn, y = buildButton(sc, T("b_hop"), y, Color3.fromRGB(40,100,180), Color3.new(1,1,1))
    hopBtn.MouseButton1Click:Connect(function()
        hopBtn.Text = "..."
        task.spawn(function() serverHop(); task.wait(2); hopBtn.Text = T("b_hop") end)
    end)
    y = buildToggle(sc, T("t_rj"), "AutoRejoin", y, function(v) webhookFeature("Auto Rejoin", v) end)
    y = buildSection(sc, T("s_prf"), y+4)
    y = buildToggle(sc, T("t_fp"), "FPSBoost", y, function(v) if v then enableFPSBoost() else disableFPSBoost() end; webhookFeature("FPS Boost", v) end)
    y = buildSection(sc, T("s_cht"), y+4)
    y = buildToggle(sc, T("t_cl"), "ChatLogger", y, function(v) if v then enableChatLogger() else disableChatLogger() end; webhookFeature("Chat Logger", v) end)
    if #chatLogs > 0 then
        local chatFrame = Instance.new("Frame", sc)
        chatFrame.Size = UDim2.new(1,-28,0,140); chatFrame.Position = UDim2.new(0,14,0,y)
        chatFrame.BackgroundColor3 = Tc.Card; makeCorner(8, chatFrame)
        local chatSc = Instance.new("ScrollingFrame", chatFrame)
        chatSc.Size = UDim2.new(1,-8,1,-8); chatSc.Position = UDim2.new(0,4,0,4)
        chatSc.BackgroundTransparency = 1; chatSc.ScrollBarThickness = 2
        chatSc.CanvasSize = UDim2.new(0,0,0,0); chatSc.AutomaticCanvasSize = Enum.AutomaticSize.Y; chatSc.BorderSizePixel = 0
        Instance.new("UIListLayout", chatSc).Padding = UDim.new(0,2)
        for _, log in ipairs(chatLogs) do
            local lbl = Instance.new("TextLabel", chatSc)
            lbl.Size = UDim2.new(1,-4,0,14); lbl.BackgroundTransparency = 1
            lbl.Text = log:sub(1,50); lbl.TextColor3 = Tc.TextDim
            lbl.Font = Enum.Font.Gotham; lbl.TextSize = 10; lbl.TextXAlignment = Enum.TextXAlignment.Left
        end
        y = y + 148
    end
    y = buildSection(sc, T("s_mm"), y+4)
    y = buildToggle(sc, T("t_mm"), "MiniMap", y, function(v) if v then enableMiniMap() else disableMiniMap() end; webhookFeature("MiniMap", v) end)
end

tabBuilders["ITEMS"] = function(parent)
    local sc = makeScrollFrame(parent); local y = 10
    y = buildSection(sc, T("s_itm"), y)
    local pBox; pBox, y = buildInput(sc, "Kullanici", "Isim", "", y)
    local tBox; tBox, y = buildInput(sc, "Esya", "Kilıc", "", y)
    local cBox; cBox, y = buildInput(sc, "Adet", "1", "1", y)
    local giveBtn; giveBtn, y = buildButton(sc, "Ver", y)
    local scanBtn; scanBtn, y = buildButton(sc, "Tara", y, Tc.AccentFaint, Tc.Text)
    local resLbl = Instance.new("TextLabel", sc)
    resLbl.Size = UDim2.new(1,-28,0,28); resLbl.Position = UDim2.new(0,14,0,y)
    resLbl.BackgroundTransparency = 1; resLbl.TextColor3 = Tc.TextDim
    resLbl.Font = Enum.Font.GothamMedium; resLbl.TextSize = 13
    resLbl.TextWrapped = true; resLbl.TextXAlignment = Enum.TextXAlignment.Left; y = y+34
    local toolsFrame = Instance.new("Frame", sc)
    toolsFrame.Size = UDim2.new(1,-28,0,180); toolsFrame.Position = UDim2.new(0,14,0,y)
    toolsFrame.BackgroundColor3 = Tc.Card; makeCorner(8, toolsFrame)
    local tscroll = Instance.new("ScrollingFrame", toolsFrame)
    tscroll.Size = UDim2.new(1,-8,1,-8); tscroll.Position = UDim2.new(0,4,0,4)
    tscroll.BackgroundTransparency = 1; tscroll.ScrollBarThickness = 3
    tscroll.CanvasSize = UDim2.new(0,0,0,0); tscroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; tscroll.BorderSizePixel = 0
    Instance.new("UIListLayout", tscroll).Padding = UDim.new(0,3)
    local function scanItems()
        for _, c in ipairs(tscroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        task.spawn(function()
            local found = {}
            for _, loc in ipairs({ServerStorage, ReplicatedStorage, Workspace}) do
                pcall(function()
                    for _, item in ipairs(loc:GetDescendants()) do
                        if item:IsA("Tool") then found[item.Name] = true end
                    end
                end)
            end
            local cnt = 0
            for name in pairs(found) do
                local btn = Instance.new("TextButton", tscroll)
                btn.Size = UDim2.new(1,0,0,26); btn.Text = name
                btn.TextColor3 = Tc.Text; btn.Font = Enum.Font.Gotham; btn.TextSize = 13
                btn.BackgroundColor3 = Tc.CardHover; makeCorner(5, btn)
                btn.MouseButton1Click:Connect(function() tBox.Text = name end)
                cnt = cnt + 1
            end
            resLbl.Text = cnt .. " esya bulundu"
            resLbl.TextColor3 = cnt > 0 and Tc.KeyGreen or Tc.KeyRed
        end)
    end
    local function giveItem(playerName, toolName, count)
        count = count or 1
        local targetPlayer
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Name:lower():find(playerName:lower()) then targetPlayer = plr; break end
        end
        if not targetPlayer then return false, "Oyuncu bulunamadi" end
        local foundTool
        for _, loc in ipairs({ServerStorage, ReplicatedStorage, Workspace}) do
            pcall(function()
                local t = loc:FindFirstChild(toolName, true)
                if t and t:IsA("Tool") then foundTool = t:Clone() end
            end)
            if foundTool then break end
        end
        if not foundTool then return false, "Esya bulunamadi" end
        for i = 1, count do
            local clone = foundTool:Clone()
            local bp = targetPlayer:FindFirstChild("Backpack")
            if bp then clone.Parent = bp
            elseif targetPlayer.Character then clone.Parent = targetPlayer.Character end
            task.wait(0.1)
        end
        return true, count .. "x " .. toolName .. " -> " .. targetPlayer.Name
    end
    giveBtn.MouseButton1Click:Connect(function()
        local ok, msg = giveItem(pBox.Text, tBox.Text, math.clamp(tonumber(cBox.Text) or 1, 1, 20))
        resLbl.Text = msg; resLbl.TextColor3 = ok and Tc.KeyGreen or Tc.KeyRed
    end)
    scanBtn.MouseButton1Click:Connect(scanItems); scanItems()
end

tabBuilders["TEAM"] = function(parent)
    local sc = makeScrollFrame(parent); local y = 10
    y = buildSection(sc, "Takim Degistir", y)
    local uBox; uBox, y = buildInput(sc, "Kullanici", "Isim", "", y)
    local tBox; tBox, y = buildInput(sc, "Takim", "Takim adi", "", y)
    local cBtn; cBtn, y = buildButton(sc, "Degistir", y)
    local resLbl = Instance.new("TextLabel", sc)
    resLbl.Size = UDim2.new(1,-28,0,28); resLbl.Position = UDim2.new(0,14,0,y)
    resLbl.BackgroundTransparency = 1; resLbl.TextColor3 = Tc.TextDim
    resLbl.Font = Enum.Font.GothamMedium; resLbl.TextSize = 13; resLbl.TextXAlignment = Enum.TextXAlignment.Left
    cBtn.MouseButton1Click:Connect(function()
        if uBox.Text == "" or tBox.Text == "" then resLbl.Text = "Doldur!"; resLbl.TextColor3 = Tc.KeyRed; return end
        local tp; for _, p in ipairs(Players:GetPlayers()) do if p.Name:lower() == uBox.Text:lower() then tp = p; break end end
        if not tp then resLbl.Text = "Oyuncu yok"; resLbl.TextColor3 = Tc.KeyRed; return end
        local tt; for _, t in ipairs(game:GetService("Teams"):GetChildren()) do if t.Name:lower() == tBox.Text:lower() then tt = t; break end end
        if not tt then resLbl.Text = "Takim yok"; resLbl.TextColor3 = Tc.KeyRed; return end
        tp.Team = tt; resLbl.Text = tp.Name .. " -> " .. tt.Name; resLbl.TextColor3 = Tc.KeyGreen
    end)
end

tabBuilders["ANTICHEAT"] = function(parent)
    local sc = makeScrollFrame(parent); local y = 10
    local infoCard = Instance.new("Frame", sc)
    infoCard.Size = UDim2.new(1,-28,0,56); infoCard.Position = UDim2.new(0,14,0,y)
    infoCard.BackgroundColor3 = Color3.fromRGB(30,20,10); makeCorner(8, infoCard)
    local il = Instance.new("TextLabel", infoCard)
    il.Size = UDim2.new(1,-16,1,0); il.Position = UDim2.new(0,8,0,0); il.BackgroundTransparency = 1
    il.Text = "Tum bypass'lar acik tutulmasini tavsiye ederiz. Client-side AC kontrolleri engellenir."
    il.TextColor3 = Color3.fromRGB(255,200,100); il.Font = Enum.Font.Gotham; il.TextSize = 11; il.TextWrapped = true; il.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 64
    y = buildSection(sc, T("s_ac"), y)
    y = buildToggle(sc, T("t_acfl"), "ACBypassFly",    y)
    y = buildToggle(sc, T("t_acnc"), "ACBypassNoclip", y)
    y = buildToggle(sc, T("t_acsp"), "ACBypassSpeed",  y)
    y = buildToggle(sc, T("t_actp"), "ACBypassTP",     y)
    y = buildToggle(sc, T("t_acre"), "ACBlockRemotes", y)
    y = buildToggle(sc, T("t_acam"), "ACBypassAimbot", y)
    y = buildSection(sc, "Bilgi", y+4)
    local infoCard2 = Instance.new("Frame", sc)
    infoCard2.Size = UDim2.new(1,-28,0,0); infoCard2.AutomaticSize = Enum.AutomaticSize.Y
    infoCard2.Position = UDim2.new(0,14,0,y); infoCard2.BackgroundColor3 = Tc.Card; makeCorner(8, infoCard2)
    local il2 = Instance.new("TextLabel", infoCard2)
    il2.Size = UDim2.new(1,-16,0,0); il2.AutomaticSize = Enum.AutomaticSize.Y
    il2.Position = UDim2.new(0,8,0,8); il2.BackgroundTransparency = 1
    il2.Text = "Fly Bypass: WalkSpeed=16 gozukur, ucus BodyVelocity ile yapilir.\n\nSpeed Bypass: WalkSpeed=16 SABIT kalir, gercek hiz BodyVelocity'den gelir. AC WalkSpeed=16 gorur.\n\nNoclip Bypass: Carpisme kapaliyken Network Ownership bize ait.\n\nRemote Engelle: Bilinen AC keyword'leri olan RemoteEvent'ler intercept edilir.\n\nAimbot Bypass: mousemoverel kullanilir, kamera manipulation yok."
    il2.TextColor3 = Tc.TextDim; il2.Font = Enum.Font.Gotham; il2.TextSize = 11; il2.TextWrapped = true; il2.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UIPadding", infoCard2).PaddingBottom = UDim.new(0,10)
end

tabBuilders["CONFIG"] = function(parent)
    local sc = makeScrollFrame(parent); local y = 10
    local ic = Instance.new("Frame", sc)
    ic.Size = UDim2.new(1,-28,0,36); ic.Position = UDim2.new(0,14,0,y); ic.BackgroundColor3 = Tc.AccentFaint; makeCorner(8, ic)
    local il = Instance.new("TextLabel", ic)
    il.Size = UDim2.new(1,-16,1,0); il.Position = UDim2.new(0,8,0,0); il.BackgroundTransparency = 1
    il.Text = "Configler bu cihaza kaydedilir. Tema + Dil de kaydedilir. | " .. T("disc")
    il.TextColor3 = Tc.TextDim; il.Font = Enum.Font.Gotham; il.TextSize = 11; il.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 44
    y = buildSection(sc, T("cfg_save"), y)
    local nameBox; nameBox, y = buildInput(sc, T("cfg_name"), "benim-config", "", y)
    local saveBtn; saveBtn, y = buildButton(sc, T("cfg_save"), y, Tc.KeyGreen, Color3.new(1,1,1))
    local resLbl = Instance.new("TextLabel", sc)
    resLbl.Size = UDim2.new(1,-28,0,28); resLbl.Position = UDim2.new(0,14,0,y)
    resLbl.BackgroundTransparency = 1; resLbl.Font = Enum.Font.GothamMedium; resLbl.TextSize = 13
    resLbl.TextXAlignment = Enum.TextXAlignment.Left; resLbl.TextWrapped = true; y = y+36
    saveBtn.MouseButton1Click:Connect(function()
        local n = nameBox.Text:gsub("[^%w%-_]",""):lower()
        if n == "" then resLbl.Text = T("cfg_enter"); resLbl.TextColor3 = Tc.KeyRed; return end
        if saveLocalConfig(n) then resLbl.Text = T("cfg_saved") .. " (" .. n .. ")"; resLbl.TextColor3 = Tc.KeyGreen; task.wait(0.5); switchTab("CONFIG")
        else resLbl.Text = T("cfg_fail"); resLbl.TextColor3 = Tc.KeyRed end
    end)
    y = buildSection(sc, "Kayitli Configler", y+4)
    local configs = listLocalConfigs()
    if #configs == 0 then
        local el = Instance.new("TextLabel", sc)
        el.Size = UDim2.new(1,-28,0,28); el.Position = UDim2.new(0,14,0,y)
        el.BackgroundTransparency = 1; el.Text = T("cfg_none"); el.TextColor3 = Tc.TextFaint
        el.Font = Enum.Font.GothamMedium; el.TextSize = 13; el.TextXAlignment = Enum.TextXAlignment.Left
    else
        for _, cfgName in ipairs(configs) do
            local row = Instance.new("Frame", sc)
            row.Size = UDim2.new(1,-28,0,44); row.Position = UDim2.new(0,14,0,y); row.BackgroundColor3 = Tc.Card; makeCorner(8, row)
            local nl = Instance.new("TextLabel", row)
            nl.Size = UDim2.new(1,-160,1,0); nl.Position = UDim2.new(0,12,0,0); nl.BackgroundTransparency = 1
            nl.Text = cfgName; nl.TextColor3 = Tc.Text; nl.Font = Enum.Font.GothamSemibold; nl.TextSize = 13; nl.TextXAlignment = Enum.TextXAlignment.Left
            local function mkB(txt, col, xOff)
                local b = Instance.new("TextButton", row)
                b.Size = UDim2.new(0,46,0,28); b.Position = UDim2.new(1,xOff,0.5,-14)
                b.BackgroundColor3 = col; b.TextColor3 = Color3.new(1,1,1)
                b.Font = Enum.Font.GothamBold; b.TextSize = 11; b.Text = txt; makeCorner(6, b); return b
            end
            local lb = mkB(T("cfg_load"), Tc.KeyGreen, -152)
            local db = mkB(T("cfg_del"),  Tc.KeyRed,   -98)
            lb.MouseButton1Click:Connect(function()
                if loadLocalConfig(cfgName) then buildCrosshair(); resLbl.Text = T("cfg_loaded") .. " (" .. cfgName .. ")"; resLbl.TextColor3 = Tc.KeyGreen; task.wait(0.2); rebuildMenu()
                else resLbl.Text = T("cfg_fail"); resLbl.TextColor3 = Tc.KeyRed end
            end)
            db.MouseButton1Click:Connect(function()
                deleteLocalConfig(cfgName); resLbl.Text = T("cfg_deleted"); resLbl.TextColor3 = Tc.TextDim
                task.wait(0.3); switchTab("CONFIG")
            end)
            y = y + 52
        end
    end
end

tabBuilders["SETTINGS"] = function(parent)
    local sc = makeScrollFrame(parent); local y = 10
    -- Dil
    y = buildSection(sc, T("s_lng"), y)
    local langRow = Instance.new("Frame", sc)
    langRow.Size = UDim2.new(1,-28,0,44); langRow.Position = UDim2.new(0,14,0,y); langRow.BackgroundColor3 = Tc.Card; makeCorner(8, langRow)
    local langLbl = Instance.new("TextLabel", langRow)
    langLbl.Size = UDim2.new(0.45,0,1,0); langLbl.Position = UDim2.new(0,12,0,0); langLbl.BackgroundTransparency = 1
    langLbl.Text = "Language / Dil / Idioma"; langLbl.TextColor3 = Tc.Text; langLbl.Font = Enum.Font.GothamMedium; langLbl.TextSize = 13; langLbl.TextXAlignment = Enum.TextXAlignment.Left
    local LANG_LIST = {"TR","EN","ES"}
    local function getLangName(l) return l=="TR" and "Turkce" or l=="EN" and "English" or "Espanol" end
    local langBtn = Instance.new("TextButton", langRow)
    langBtn.Size = UDim2.new(0,120,0,30); langBtn.Position = UDim2.new(1,-134,0.5,-15); langBtn.BackgroundColor3 = Tc.AccentFaint
    langBtn.TextColor3 = Tc.Text; langBtn.Font = Enum.Font.GothamBold; langBtn.TextSize = 13; langBtn.Text = getLangName(LANG); makeCorner(6, langBtn)
    langBtn.MouseButton1Click:Connect(function()
        local idx = 1
        for i, l in ipairs(LANG_LIST) do if l == LANG then idx = i; break end end
        LANG = LANG_LIST[(idx % #LANG_LIST) + 1]; langBtn.Text = getLangName(LANG)
        task.wait(0.1); rebuildMenu()
    end)
    y = y + 52
    -- Tema
    y = buildSection(sc, T("s_thm"), y)
    local themeGrid = Instance.new("Frame", sc)
    themeGrid.Size = UDim2.new(1,-28,0,0); themeGrid.AutomaticSize = Enum.AutomaticSize.Y
    themeGrid.Position = UDim2.new(0,14,0,y); themeGrid.BackgroundTransparency = 1
    local tgLayout = Instance.new("UIGridLayout", themeGrid)
    tgLayout.CellSize = UDim2.new(0,100,0,56); tgLayout.CellPadding = UDim2.new(0,6,0,6); tgLayout.SortOrder = Enum.SortOrder.LayoutOrder
    for i, theme in ipairs(THEMES) do
        local acCol = theme.rainbow and Color3.fromRGB(255,100,100) or Color3.fromRGB(theme.ac[1],theme.ac[2],theme.ac[3])
        local bgCol = Color3.fromRGB(theme.bg[1],theme.bg[2],theme.bg[3])
        local btn = Instance.new("TextButton", themeGrid)
        btn.BackgroundColor3 = bgCol; btn.BorderSizePixel = 0; btn.Text = ""; btn.LayoutOrder = i; makeCorner(8, btn)
        local acBar = Instance.new("Frame", btn)
        acBar.Size = UDim2.new(1,0,0,4); acBar.BackgroundColor3 = acCol; acBar.BorderSizePixel = 0; makeCorner(4, acBar)
        local nameLbl = Instance.new("TextLabel", btn)
        nameLbl.Size = UDim2.new(1,0,1,-4); nameLbl.Position = UDim2.new(0,0,0,4)
        nameLbl.BackgroundTransparency = 1; nameLbl.Text = theme.name; nameLbl.TextColor3 = acCol
        nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextSize = 12
        if i == currentThemeIndex then
            local sel = Instance.new("UIStroke", btn); sel.Color = acCol; sel.Thickness = 2
        end
        if theme.rainbow then
            task.spawn(function()
                while btn and btn.Parent do
                    local rb = hsvToColor(rainbowHue, 1, 1)
                    acBar.BackgroundColor3 = rb; nameLbl.TextColor3 = rb
                    task.wait(0.05)
                end
            end)
        end
        btn.MouseButton1Click:Connect(function()
            currentThemeIndex = i; Tc = makeThemeColors(); task.wait(0.1); rebuildMenu()
        end)
    end
    y = y + 200
    y = buildSection(sc, T("s_abt"), y)
    local aCard = Instance.new("Frame", sc)
    aCard.Size = UDim2.new(1,-28,0,0); aCard.AutomaticSize = Enum.AutomaticSize.Y
    aCard.Position = UDim2.new(0,14,0,y); aCard.BackgroundColor3 = Tc.Card; makeCorner(8, aCard)
    local aLbl = Instance.new("TextLabel", aCard)
    aLbl.Size = UDim2.new(1,-16,0,0); aLbl.AutomaticSize = Enum.AutomaticSize.Y
    aLbl.Position = UDim2.new(0,8,0,8); aLbl.BackgroundTransparency = 1
    aLbl.Text = "SUSANO V2.3\n" .. T("disc") .. "\n\nESP (2D/3D/Skeleton/Chams), Aimbot, Rage Aimbot, Silent Aim, Magic Bullet, Trigger Bot, Hitbox, Fake Lag, Fly, Noclip, Speed, BunnyHop, LongJump, Gravity, Cursor TP, Godmode, Kill Aura, Anti AFK, Name Spoof, Full Bright, No Fog, FOV, 3rd Person, Time, World Color, Server Hop, Auto Rejoin, FPS Boost, Chat Logger, MiniMap, Esya, Takim, AntiCheat Bypass, Config, 9 Tema, TR/EN/ES\n\nF5 - Menu | Sag Tik - Cursor TP"
    aLbl.TextColor3 = Tc.TextDim; aLbl.Font = Enum.Font.Gotham; aLbl.TextSize = 12; aLbl.TextWrapped = true; aLbl.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UIPadding", aCard).PaddingBottom = UDim.new(0,10)
end

-- ANA MENU
local MainFrame, SideBar, Content
local currentTab = "ESP"
local menuBuilt = false
local minimized = false
local MENU_FULL = UDim2.new(0, 940, 0, 680)
local MENU_MINI = UDim2.new(0, 940, 0, 46)
local sideButtons = {}

local function getTabList()
    return {
        {id="ESP",       label=T("tab_esp")},
        {id="AIMBOT",    label=T("tab_aim")},
        {id="MOVEMENT",  label=T("tab_move")},
        {id="PLAYERS",   label=T("tab_play")},
        {id="VISUAL",    label=T("tab_vis")},
        {id="MISC",      label=T("tab_misc")},
        {id="ITEMS",     label=T("tab_item")},
        {id="TEAM",      label=T("tab_team")},
        {id="ANTICHEAT", label=T("tab_ac")},
        {id="CONFIG",    label=T("tab_cfg")},
        {id="SETTINGS",  label=T("tab_set")},
    }
end

switchTab = function(id)
    currentTab = id
    local tabs = getTabList()
    for i, btn in ipairs(sideButtons) do
        local isActive = btn:GetAttribute("TabID") == id
        makeTween(btn, 0.15, {BackgroundColor3 = isActive and Tc.ActiveSide or Tc.InactiveSide})
        local iconLbl = btn:FindFirstChild("IconLbl")
        local nameLbl = btn:FindFirstChild("NameLbl")
        if iconLbl then
            makeTween(iconLbl, 0.15, {TextColor3 = isActive and Tc.BG or Tc.TextFaint})
            if tabs[i] then iconLbl.Text = tabs[i].label:sub(1,1):upper() end
        end
        if nameLbl then
            makeTween(nameLbl, 0.15, {TextColor3 = isActive and Tc.BG or Tc.TextDim})
            if tabs[i] then nameLbl.Text = tabs[i].label end
        end
    end
    for _, c in ipairs(Content:GetChildren()) do c:Destroy() end
    Content.BackgroundTransparency = 0.15; makeTween(Content, 0.12, {BackgroundTransparency = 1})
    local builder = tabBuilders[id]
    if builder then builder(Content) end
end

createMenu = function()
    if MainGui then pcall(function() MainGui:Destroy() end) end
    MainGui = makeScreenGui("SusanoUI", 200); MainGui.Enabled = true
    Tc = makeThemeColors()

    MainFrame = Instance.new("Frame", MainGui)
    MainFrame.Size = MENU_FULL; MainFrame.Position = UDim2.new(0.5,-470,0.5,-340)
    MainFrame.BackgroundColor3 = Tc.BG; MainFrame.Active = true; makeCorner(10, MainFrame)
    local iBorder = Instance.new("UIStroke", MainFrame)
    iBorder.Color = Tc.Accent; iBorder.Thickness = 1; iBorder.Transparency = 0.6

    -- Golge efekti
    for _, sd in ipairs({{4,3,0.82},{12,6,0.88},{22,10,0.94}}) do
        local s = Instance.new("Frame", MainFrame)
        s.Size = UDim2.new(1,sd[1],1,sd[1]); s.Position = UDim2.new(0,-sd[1]/2,0,sd[2])
        s.BackgroundColor3 = Color3.new(0,0,0); s.BackgroundTransparency = sd[3]
        s.ZIndex = MainFrame.ZIndex-1; s.BorderSizePixel = 0; makeCorner(15, s)
    end

    -- Title bar
    local titleBar = Instance.new("Frame", MainFrame)
    titleBar.Size = UDim2.new(1,0,0,46); titleBar.BackgroundColor3 = Tc.TitleBar
    titleBar.BorderSizePixel = 0; titleBar.ClipsDescendants = true; makeCorner(10, titleBar)
    local tbFix = Instance.new("Frame", titleBar)
    tbFix.Size = UDim2.new(1,0,0.5,0); tbFix.Position = UDim2.new(0,0,0.5,0)
    tbFix.BackgroundColor3 = Tc.TitleBar; tbFix.BorderSizePixel = 0
    local titleLine = Instance.new("Frame", titleBar)
    titleLine.Size = UDim2.new(1,0,0,1); titleLine.Position = UDim2.new(0,0,1,-1)
    titleLine.BackgroundColor3 = Tc.Accent; titleLine.BorderSizePixel = 0; titleLine.BackgroundTransparency = 0.7
    local logoTxt = Instance.new("TextLabel", titleBar)
    logoTxt.Size = UDim2.new(0,110,1,0); logoTxt.Position = UDim2.new(0,16,0,0)
    logoTxt.BackgroundTransparency = 1; logoTxt.Text = "SUSANO"
    logoTxt.TextColor3 = Tc.Accent; logoTxt.Font = Enum.Font.GothamBlack; logoTxt.TextSize = 20; logoTxt.TextXAlignment = Enum.TextXAlignment.Left
    local verTxt = Instance.new("TextLabel", titleBar)
    verTxt.Size = UDim2.new(0,40,1,0); verTxt.Position = UDim2.new(0,122,0,0)
    verTxt.BackgroundTransparency = 1; verTxt.Text = "v2.3"
    verTxt.TextColor3 = Tc.TextFaint; verTxt.Font = Enum.Font.GothamMedium; verTxt.TextSize = 11; verTxt.TextXAlignment = Enum.TextXAlignment.Left
    local keyBadge = Instance.new("Frame", titleBar)
    keyBadge.Size = UDim2.new(0,80,0,22); keyBadge.Position = UDim2.new(0,168,0.5,-11)
    keyBadge.BackgroundColor3 = keyType=="lifetime" and Tc.KeyGold or
        (keyType=="monthly" and Color3.fromRGB(180,120,255) or
        (keyType=="weekly"  and Color3.fromRGB(80,180,255)  or Tc.AccentFaint)); makeCorner(5, keyBadge)
    local keyBadgeLbl = Instance.new("TextLabel", keyBadge)
    keyBadgeLbl.Size = UDim2.new(1,0,1,0); keyBadgeLbl.BackgroundTransparency = 1
    keyBadgeLbl.TextColor3 = Color3.new(1,1,1); keyBadgeLbl.Font = Enum.Font.GothamBold; keyBadgeLbl.TextSize = 11
    local keyNames = {daily=T("type_d"),weekly=T("type_w"),monthly=T("type_m"),lifetime=T("type_l")}
    keyBadgeLbl.Text = keyNames[keyType] or keyType:upper()
    local timeLbl = Instance.new("TextLabel", titleBar)
    timeLbl.Size = UDim2.new(0,110,1,0); timeLbl.Position = UDim2.new(0,256,0,0)
    timeLbl.BackgroundTransparency = 1; timeLbl.TextColor3 = Tc.TextFaint
    timeLbl.Font = Enum.Font.GothamMedium; timeLbl.TextSize = 10; timeLbl.TextXAlignment = Enum.TextXAlignment.Left
    timeLbl.Text = formatTimeLeft(keyExpires)
    task.spawn(function() while MainGui and MainGui.Parent do timeLbl.Text = formatTimeLeft(keyExpires); task.wait(60) end end)
    local discLbl = Instance.new("TextLabel", titleBar)
    discLbl.Size = UDim2.new(0,180,1,0); discLbl.Position = UDim2.new(0.5,-90,0,0)
    discLbl.BackgroundTransparency = 1; discLbl.Text = T("disc")
    discLbl.TextColor3 = Tc.Accent; discLbl.Font = Enum.Font.GothamBold; discLbl.TextSize = 12

    -- Rainbow animasyon
    if THEMES[currentThemeIndex].rainbow then
        task.spawn(function()
            while MainGui and MainGui.Parent and THEMES[currentThemeIndex].rainbow do
                rainbowHue = (rainbowHue + 0.002) % 1
                local rb = hsvToColor(rainbowHue, 1, 1)
                Tc.Accent = rb; Tc.ActiveSide = rb
                pcall(function()
                    logoTxt.TextColor3 = rb; titleLine.BackgroundColor3 = rb
                    iBorder.Color = rb; keyBadge.BackgroundColor3 = rb; discLbl.TextColor3 = rb
                end)
                task.wait(0.05)
            end
        end)
    end

    -- Kapat / Minimize butonlari
    local function makeTitleBtn(text, bgColor, xOffset)
        local btn = Instance.new("TextButton", titleBar)
        btn.Size = UDim2.new(0,28,0,28); btn.Position = UDim2.new(1,xOffset,0.5,-14)
        btn.BackgroundColor3 = bgColor; btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold; btn.TextSize = 15; btn.Text = text; makeCorner(6, btn)
        return btn
    end
    local closeBtn = makeTitleBtn("x", Tc.CloseRed, -36)
    closeBtn.MouseEnter:Connect(function() makeTween(closeBtn,0.1,{BackgroundColor3=Color3.fromRGB(220,70,70)}) end)
    closeBtn.MouseLeave:Connect(function() makeTween(closeBtn,0.1,{BackgroundColor3=Tc.CloseRed}) end)
    closeBtn.MouseButton1Click:Connect(function()
        makeTween(MainFrame,0.18,{BackgroundTransparency=1}); task.wait(0.2)
        MainGui.Enabled = false; MainFrame.BackgroundTransparency = 0
    end)
    local minBtn = makeTitleBtn("-", Tc.MinBtn, -70)
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        makeTween(MainFrame, 0.2, {Size = minimized and MENU_MINI or MENU_FULL})
        task.wait(0.05); SideBar.Visible = not minimized; Content.Visible = not minimized
    end)

    -- Sidebar
    SideBar = Instance.new("Frame", MainFrame)
    SideBar.Size = UDim2.new(0,185,1,-46); SideBar.Position = UDim2.new(0,0,0,46)
    SideBar.BackgroundColor3 = Tc.Sidebar; SideBar.BorderSizePixel = 0; makeCorner(10, SideBar)
    local sbFix = Instance.new("Frame", SideBar)
    sbFix.Size = UDim2.new(1,0,0.5,0); sbFix.BackgroundColor3 = Tc.Sidebar; sbFix.BorderSizePixel = 0
    local sideDiv = Instance.new("Frame", MainFrame)
    sideDiv.Size = UDim2.new(0,1,1,-46); sideDiv.Position = UDim2.new(0,185,0,46)
    sideDiv.BackgroundColor3 = Tc.Accent; sideDiv.BorderSizePixel = 0; sideDiv.BackgroundTransparency = 0.8

    sideButtons = {}
    local tabs = getTabList()
    for i, tab in ipairs(tabs) do
        local isActive = tab.id == currentTab
        local btn = Instance.new("TextButton", SideBar)
        btn.Size = UDim2.new(1,-14,0,34); btn.Position = UDim2.new(0,7,0,3+(i-1)*36)
        btn.BackgroundColor3 = isActive and Tc.ActiveSide or Tc.InactiveSide
        btn.AutoButtonColor = false; btn.BorderSizePixel = 0; btn.Text = ""; makeCorner(7, btn)
        btn:SetAttribute("TabID", tab.id)
        if isActive then
            local al = Instance.new("Frame", btn)
            al.Size = UDim2.new(0,3,1,-8); al.Position = UDim2.new(0,2,0,4)
            al.BackgroundColor3 = Tc.BG; al.BorderSizePixel = 0; makeCorner(2, al)
        end
        local iconLbl = Instance.new("TextLabel", btn); iconLbl.Name = "IconLbl"
        iconLbl.Size = UDim2.new(0,28,1,0); iconLbl.Position = UDim2.new(0,8,0,0)
        iconLbl.BackgroundTransparency = 1; iconLbl.Text = tab.label:sub(1,1):upper()
        iconLbl.TextColor3 = isActive and Tc.BG or Tc.TextFaint
        iconLbl.Font = Enum.Font.GothamBold; iconLbl.TextSize = 12
        local nameLbl = Instance.new("TextLabel", btn); nameLbl.Name = "NameLbl"
        nameLbl.Size = UDim2.new(1,-40,1,0); nameLbl.Position = UDim2.new(0,38,0,0)
        nameLbl.BackgroundTransparency = 1; nameLbl.Text = tab.label
        nameLbl.TextColor3 = isActive and Tc.BG or Tc.TextDim
        nameLbl.Font = Enum.Font.GothamSemibold; nameLbl.TextSize = 13; nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        btn.MouseEnter:Connect(function()
            if btn:GetAttribute("TabID") ~= currentTab then makeTween(btn,0.1,{BackgroundColor3=Tc.CardHover}) end
        end)
        btn.MouseLeave:Connect(function()
            if btn:GetAttribute("TabID") ~= currentTab then makeTween(btn,0.1,{BackgroundColor3=Tc.InactiveSide}) end
        end)
        btn.MouseButton1Click:Connect(function() switchTab(tab.id) end)
        table.insert(sideButtons, btn)
    end

    Content = Instance.new("Frame", MainFrame)
    Content.Size = UDim2.new(1,-186,1,-46); Content.Position = UDim2.new(0,186,0,46)
    Content.BackgroundTransparency = 1; Content.ClipsDescendants = true

    -- Surukle
    local dragging, dragStart, startPos = false
    titleBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = i.Position; startPos = MainFrame.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    local dragInput
    titleBar.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then dragInput = i end end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i == dragInput then
            local d = i.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
        end
    end)

    -- Yeniden boyutlandir
    local resizeHandle = Instance.new("Frame", MainFrame)
    resizeHandle.Size = UDim2.new(0,14,0,14); resizeHandle.Position = UDim2.new(1,-14,1,-14); resizeHandle.BackgroundTransparency = 1
    local resizeDot = Instance.new("Frame", resizeHandle)
    resizeDot.Size = UDim2.new(0,5,0,5); resizeDot.Position = UDim2.new(1,-5,1,-5)
    resizeDot.BackgroundColor3 = Tc.Accent; resizeDot.BackgroundTransparency = 0.4; makeCorner(2, resizeDot)
    local resizing, resStart, resStartSize = false
    resizeHandle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true; resStart = i.Position
            resStartSize = Vector2.new(MainFrame.AbsoluteSize.X, MainFrame.AbsoluteSize.Y)
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then resizing = false end end)
        end
    end)
    local resInput
    resizeHandle.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then resInput = i end end)
    UserInputService.InputChanged:Connect(function(i)
        if resizing and i == resInput then
            local d = i.Position - resStart
            MainFrame.Size = UDim2.new(0,math.clamp(resStartSize.X+d.X,620,1400), 0,math.clamp(resStartSize.Y+d.Y,420,900))
            SideBar.Size = UDim2.new(0,185,1,-46); Content.Size = UDim2.new(1,-186,1,-46)
        end
    end)

    menuBuilt = true
    local ep = MainFrame.Position
    MainFrame.Position = ep + UDim2.new(0,0,0,14); MainFrame.BackgroundTransparency = 1
    makeTween(MainFrame, 0.22, {BackgroundTransparency=0, Position=ep})
    switchTab(currentTab)
end

rebuildMenu = function() menuBuilt = false; createMenu() end

-- ESC ENGELLE - Menü açıkken ESC kapatmasın
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Escape then
        if MainGui and MainGui.Enabled then
            task.wait(0.05)
            if not MainGui.Enabled then
                MainGui.Enabled = true
                if MainFrame then MainFrame.BackgroundTransparency = 1; makeTween(MainFrame,0.15,{BackgroundTransparency=0}) end
            end
        end
    end
end, true)

-- KEY MENU
local keyMenuGui = makeScreenGui("SusanoKeyMenu", 999)

local function buildKeyMenu(onSuccess)
    local overlay = Instance.new("Frame", keyMenuGui)
    overlay.Size = UDim2.new(1,0,1,0); overlay.BackgroundColor3 = Color3.fromRGB(5,5,5)
    overlay.BackgroundTransparency = 0; overlay.BorderSizePixel = 0

    local card = Instance.new("Frame", keyMenuGui)
    card.Size = UDim2.new(0,460,0,460); card.Position = UDim2.new(0.5,-230,0.5,-230)
    card.BackgroundColor3 = Tc.BG; card.BorderSizePixel = 0; makeCorner(12, card)
    Instance.new("UIStroke", card).Color = Tc.BorderLight

    local topBar = Instance.new("Frame", card)
    topBar.Size = UDim2.new(1,0,0,52); topBar.BackgroundColor3 = Tc.TitleBar
    topBar.BorderSizePixel = 0; topBar.ClipsDescendants = true; makeCorner(12, topBar)
    local tbFix2 = Instance.new("Frame", topBar)
    tbFix2.Size = UDim2.new(1,0,0.5,0); tbFix2.Position = UDim2.new(0,0,0.5,0); tbFix2.BackgroundColor3 = Tc.TitleBar; tbFix2.BorderSizePixel = 0
    local titleLbl = Instance.new("TextLabel", topBar)
    titleLbl.Size = UDim2.new(1,0,0.6,0); titleLbl.BackgroundTransparency = 1; titleLbl.Text = "SUSANO"
    titleLbl.TextColor3 = Tc.Accent; titleLbl.Font = Enum.Font.GothamBlack; titleLbl.TextSize = 24
    local subtitleLbl = Instance.new("TextLabel", topBar)
    subtitleLbl.Size = UDim2.new(1,0,0.4,0); subtitleLbl.Position = UDim2.new(0,0,0.6,0); subtitleLbl.BackgroundTransparency = 1
    subtitleLbl.Text = "v2.3  |  " .. T("disc"); subtitleLbl.TextColor3 = Tc.TextFaint
    subtitleLbl.Font = Enum.Font.GothamMedium; subtitleLbl.TextSize = 11

    -- Profil
    local profBg = Instance.new("Frame", card)
    profBg.Size = UDim2.new(1,-32,0,68); profBg.Position = UDim2.new(0,16,0,60); profBg.BackgroundColor3 = Tc.Card; makeCorner(10, profBg)
    local avFrame = Instance.new("Frame", profBg)
    avFrame.Size = UDim2.new(0,46,0,46); avFrame.Position = UDim2.new(0,10,0.5,-23); avFrame.BackgroundColor3 = Tc.AccentFaint; makeCorner(23, avFrame)
    pcall(function()
        local img = Instance.new("ImageLabel", avFrame)
        img.Size = UDim2.new(1,0,1,0); img.BackgroundTransparency = 1; makeCorner(23, img)
        img.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)
    local infoFrame = Instance.new("Frame", profBg)
    infoFrame.Size = UDim2.new(1,-66,1,0); infoFrame.Position = UDim2.new(0,62,0,0); infoFrame.BackgroundTransparency = 1
    local function addInfoLine(posY, text, color, fontSize)
        local lbl = Instance.new("TextLabel", infoFrame)
        lbl.Size = UDim2.new(1,0,0,17); lbl.Position = UDim2.new(0,0,0,posY); lbl.BackgroundTransparency = 1
        lbl.Text = text; lbl.TextColor3 = color; lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = fontSize; lbl.TextXAlignment = Enum.TextXAlignment.Left
    end
    addInfoLine(6,  "@" .. USERNAME, Tc.Text, 14)
    addInfoLine(24, "HWID: " .. HWID:sub(1,24) .. "...", Tc.TextFaint, 10)
    addInfoLine(40, "UID: " .. USER_ID, Tc.TextFaint, 10)

    local inputLbl = Instance.new("TextLabel", card)
    inputLbl.Size = UDim2.new(1,-32,0,16); inputLbl.Position = UDim2.new(0,16,0,140)
    inputLbl.BackgroundTransparency = 1; inputLbl.Text = "ANAHTAR"; inputLbl.TextColor3 = Tc.TextFaint
    inputLbl.Font = Enum.Font.GothamBold; inputLbl.TextSize = 10; inputLbl.TextXAlignment = Enum.TextXAlignment.Left

    local inputBox = Instance.new("TextBox", card)
    inputBox.Size = UDim2.new(1,-32,0,44); inputBox.Position = UDim2.new(0,16,0,158)
    inputBox.BackgroundColor3 = Tc.Card; inputBox.TextColor3 = Tc.Text; inputBox.Font = Enum.Font.GothamMedium; inputBox.TextSize = 15
    inputBox.PlaceholderText = "SNLIFE-XXXX-XXXX-XXXX"; inputBox.PlaceholderColor3 = Tc.TextFaint
    inputBox.Text = ""; inputBox.ClearTextOnFocus = false; inputBox.BorderSizePixel = 0; makeCorner(8, inputBox)
    local inputStroke = Instance.new("UIStroke", inputBox); inputStroke.Color = Tc.BorderLight; inputStroke.Thickness = 1

    local statusLbl = Instance.new("TextLabel", card)
    statusLbl.Size = UDim2.new(1,-32,0,20); statusLbl.Position = UDim2.new(0,16,0,208)
    statusLbl.BackgroundTransparency = 1; statusLbl.Text = ""; statusLbl.Font = Enum.Font.GothamMedium; statusLbl.TextSize = 13; statusLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Hatırla toggle (varsayılan KAPALI - her girişte key sor)
    local remRow = Instance.new("Frame", card)
    remRow.Size = UDim2.new(1,-32,0,28); remRow.Position = UDim2.new(0,16,0,234); remRow.BackgroundTransparency = 1
    local remLbl = Instance.new("TextLabel", remRow)
    remLbl.Size = UDim2.new(0.78,0,1,0); remLbl.BackgroundTransparency = 1; remLbl.Text = T("key_rem")
    remLbl.TextColor3 = Tc.TextDim; remLbl.Font = Enum.Font.GothamMedium; remLbl.TextSize = 13; remLbl.TextXAlignment = Enum.TextXAlignment.Left
    local remOn = false
    local pH, pW = 24, 50
    local remPill = Instance.new("Frame", remRow)
    remPill.Size = UDim2.new(0,pW,0,pH); remPill.Position = UDim2.new(1,-pW,0.5,-pH/2)
    remPill.BackgroundColor3 = remOn and Tc.OnBG or Tc.OffBG; makeCorner(pH, remPill)
    local remKnob = Instance.new("Frame", remPill)
    remKnob.Size = UDim2.new(0,pH-6,0,pH-6); remKnob.Position = UDim2.new(remOn and 1 or 0, remOn and -(pH-3) or 3, 0.5, -(pH-6)/2)
    remKnob.BackgroundColor3 = remOn and Tc.TitleBar or Tc.AccentDim; makeCorner(100, remKnob)
    local remHit = Instance.new("TextButton", remRow); remHit.Size = UDim2.new(1,0,1,0); remHit.BackgroundTransparency = 1; remHit.Text = ""
    remHit.MouseButton1Click:Connect(function()
        remOn = not remOn
        makeTween(remPill, 0.18, {BackgroundColor3 = remOn and Tc.OnBG or Tc.OffBG})
        makeTween(remKnob, 0.18, {Position = UDim2.new(remOn and 1 or 0, remOn and -(pH-3) or 3, 0.5, -(pH-6)/2)})
    end)

    local activateBtn = Instance.new("TextButton", card)
    activateBtn.Size = UDim2.new(1,-32,0,44); activateBtn.Position = UDim2.new(0,16,0,270)
    activateBtn.BackgroundColor3 = Tc.Accent; activateBtn.TextColor3 = Tc.BG
    activateBtn.Font = Enum.Font.GothamBold; activateBtn.TextSize = 16; activateBtn.Text = T("key_btn"); makeCorner(8, activateBtn)
    activateBtn.MouseEnter:Connect(function() makeTween(activateBtn,0.1,{BackgroundColor3=Tc.Accent:Lerp(Color3.new(1,1,1),0.15)}) end)
    activateBtn.MouseLeave:Connect(function() makeTween(activateBtn,0.1,{BackgroundColor3=Tc.Accent}) end)

    local footLbl = Instance.new("TextLabel", card)
    footLbl.Size = UDim2.new(1,-32,0,18); footLbl.Position = UDim2.new(0,16,0,322)
    footLbl.BackgroundTransparency = 1; footLbl.Text = T("disc")
    footLbl.TextColor3 = Tc.Accent; footLbl.Font = Enum.Font.GothamBold; footLbl.TextSize = 13

    local attempts = 0; local busy = false
    local function tryActivate()
        if busy then return end
        local key = inputBox.Text:upper():gsub("%s+","")
        if key == "" then statusLbl.Text = T("key_enter"); statusLbl.TextColor3 = Tc.KeyRed; return end
        busy = true; statusLbl.Text = "Dogrulanıyor..."; statusLbl.TextColor3 = Tc.TextDim
        activateBtn.Text = T("key_chk"); activateBtn.BackgroundColor3 = Tc.AccentFaint
        validateKey(key, function(ok, result, expires)
            busy = false; activateBtn.Text = T("key_btn"); activateBtn.BackgroundColor3 = Tc.Accent
            if ok then
                if remOn then safeWrite(KEY_FILE, key) end
                activeKey = key; keyExpires = expires
                statusLbl.Text = T("key_ok"); statusLbl.TextColor3 = Tc.KeyGreen
                makeTween(activateBtn,0.2,{BackgroundColor3=Tc.KeyGreen})
                makeTween(inputStroke,0.2,{Color=Tc.KeyGreen})
                task.wait(0.8)
                makeTween(card,0.25,{BackgroundTransparency=1}); makeTween(overlay,0.25,{BackgroundTransparency=1})
                task.wait(0.3)
                keyMenuGui:Destroy(); keyValidated = true; keyType = result; _G.Verified = true
                onSuccess(result)
            else
                attempts = attempts + 1
                statusLbl.Text = tostring(result) .. " (" .. attempts .. ")"; statusLbl.TextColor3 = Tc.KeyRed
                makeTween(inputStroke,0.1,{Color=Tc.KeyRed}); task.wait(0.25); makeTween(inputStroke,0.3,{Color=Tc.BorderLight})
                if attempts >= 5 then statusLbl.Text = T("key_many"); task.wait(1.5); keyMenuGui:Destroy() end
            end
        end)
    end
    activateBtn.MouseButton1Click:Connect(tryActivate)
    inputBox.FocusLost:Connect(function(enter) if enter then tryActivate() end end)
    task.spawn(function() task.wait(0.1); pcall(function() inputBox:CaptureFocus() end) end)

    card.BackgroundTransparency = 1; card.Position = UDim2.new(0.5,-230,0.5,-220)
    makeTween(card, 0.18, {BackgroundTransparency=0, Position=UDim2.new(0.5,-230,0.5,-230)})
end

-- RESPAWN - ozellikleri yeniden etkinlestir
LocalPlayer.CharacterAdded:Connect(function()
    task.spawn(function()
        task.wait(0.5)
        if _G.FlyEnabled    then enableFly()           end
        if _G.NoClip        then enableNoclip()        end
        if _G.BunnyHop      then enableBhop()          end
        if _G.SpeedHack     then enableSpeed()         end
        if _G.InfiniteJump  then enableInfiniteJump()  end
        if _G.LongJump      then enableLongJump()      end
        if _G.SwimHack      then enableSwimHack()      end
        if _G.NameSpoof     then applyNameSpoof()      end
        if _G.KillAura      then enableKillAura()      end
        if _G.HitboxEnabled then enableHitbox()        end
        if _G.Godmode       then enableGodmode()       end
    end)
end)

-- F5 - Menüyü aç/kapat
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F5 then
        if not keyValidated then return end
        if not menuBuilt then
            createMenu()
        else
            MainGui.Enabled = not MainGui.Enabled
            if MainGui.Enabled then
                MainFrame.BackgroundTransparency = 1
                makeTween(MainFrame, 0.22, {BackgroundTransparency = 0})
            end
        end
    end
end)

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    if not _G.Verified then return end
    -- Rainbow hue
    if THEMES[currentThemeIndex] and THEMES[currentThemeIndex].rainbow then
        rainbowHue = (rainbowHue + 0.002) % 1
    end
    -- ESP
    if _G.ESP then
        pcall(updateESP)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and not espCache[p] and p.Character then
                buildESPForPlayer(p)
            end
        end
    else clearAllESP() end
    pcall(updateSkeleton)
    -- Aimbot
    if _G.Aimbot and not _G.RageAimbot then
        local t = getBestAimTarget()
        if t then
            local cf = CFrame.new(Camera.CFrame.Position, t.part.Position)
            Camera.CFrame = Camera.CFrame:Lerp(cf, _G.AimbotSmooth)
            aimTarget = t.part; setFOVColor(Color3.fromRGB(80,255,120))
        else aimTarget = nil; setFOVColor(Color3.new(1,1,1)) end
    elseif not _G.RageAimbot then aimTarget = nil; setFOVColor(Color3.new(1,1,1)) end
    -- FOV circle
    if fovCircle then
        local r = _G.FOVSize
        fovCircle.Size = UDim2.new(0,r*2,0,r*2); fovCircle.Position = UDim2.new(0.5,-r,0.5,-r)
        fovCircle.Visible = _G.FOVVisible and (_G.Aimbot or _G.RageAimbot or _G.SilentAim or _G.MagicBullet)
    end
    -- Toggle'lar
    if _G.FlyEnabled     and not flying          then enableFly()           elseif not _G.FlyEnabled     and flying          then disableFly()           end
    if _G.NoClip         and not noclipActive     then enableNoclip()        elseif not _G.NoClip         and noclipActive     then disableNoclip()        end
    if _G.BunnyHop       and not bhopActive       then enableBhop()          elseif not _G.BunnyHop       and bhopActive       then disableBhop()          end
    if _G.SpeedHack      and not speedActive      then enableSpeed()         elseif not _G.SpeedHack      and speedActive      then disableSpeed()         end
    if _G.RageAimbot     and not rageActive       then enableRageAimbot()    elseif not _G.RageAimbot     and rageActive       then disableRageAimbot()    end
    if _G.SilentAim      and not silentAimActive  then enableSilentAim()     elseif not _G.SilentAim      and silentAimActive  then disableSilentAim()     end
    if _G.MagicBullet    and not magicBulletConn  then enableMagicBullet()   elseif not _G.MagicBullet    and magicBulletConn  then disableMagicBullet()   end
    if _G.TriggerBot     and not triggerBotConn   then enableTriggerBot()    elseif not _G.TriggerBot     and triggerBotConn   then disableTriggerBot()    end
    if _G.InfiniteJump   and not ijConn           then enableInfiniteJump()  elseif not _G.InfiniteJump   and ijConn           then disableInfiniteJump()  end
    if _G.LongJump       and not ljConn           then enableLongJump()      elseif not _G.LongJump       and ljConn           then disableLongJump()      end
    if _G.KillAura       and not killAuraConn     then enableKillAura()      elseif not _G.KillAura       and killAuraConn     then disableKillAura()      end
    if _G.AntiAFK        and not antiAfkConn      then enableAntiAFK()       elseif not _G.AntiAFK        and antiAfkConn      then disableAntiAFK()       end
    if _G.ThirdPerson    and not thirdPersonConn  then enableThirdPerson()   elseif not _G.ThirdPerson    and thirdPersonConn  then disableThirdPerson()   end
    if _G.HitboxEnabled  and not hitboxConn       then enableHitbox()        elseif not _G.HitboxEnabled  and hitboxConn       then disableHitbox()        end
    if _G.Godmode        and not godmodeConn1     then enableGodmode()       elseif not _G.Godmode        and godmodeConn1     then disableGodmode()       end
    if _G.FakeLag        and not fakeLagConn      then enableFakeLag()       elseif not _G.FakeLag        and fakeLagConn      then disableFakeLag()       end
    -- Surekli uygulanan ozellikler
    if _G.GravityHack then Workspace.Gravity = _G.GravityValue else Workspace.Gravity = 196.2 end
    if _G.FullBright  then applyFullBright(true) end
    if _G.NoFog       then applyNoFog(true)      end
    if _G.FOVChanger  then Camera.FieldOfView = _G.FOVChangerVal end
    if _G.TimeChanger then applyTime(true)       end
    if _G.WorldColor  then applyWorldColor(true) end
    -- Mini map ve chat
    if _G.MiniMap    and not miniMapGui    then enableMiniMap()     elseif not _G.MiniMap    and miniMapGui    then disableMiniMap()     end
    if _G.ChatLogger and not chatLoggerGui then enableChatLogger()  elseif not _G.ChatLogger and chatLoggerGui then disableChatLogger()  end
    if _G.FPSBoost   and not fpsBoostActive then enableFPSBoost()  elseif not _G.FPSBoost   and fpsBoostActive then disableFPSBoost()  end
end)

-- BASLANGIC
safeMkDir(CFG_FOLDER)
enableTeleportCursor()
enableSwimHack()
setupAutoRejoin()

-- Her zaman key menüsü çıksın (hatırlama varsayılan kapalı)
buildKeyMenu(function()
    createFOVCircle()
    task.spawn(function() task.wait(0.05); createMenu() end)
end)
