-- SUSANO V2.3 | discord.gg/tCufFEMdux
-- Tum degiskenler acik yazildi, hic kisaltma yok

local t1 = "ghp_wG4l"
local t2 = "OHjlmUvwum"
local t3 = "ObSMZlppNaGyMq3H3JtpiC"
local GITHUB_TOKEN  = t1..t2..t3
local GITHUB_OWNER  = "CrafyXD"
local GITHUB_REPO   = "susano-backend"
local GITHUB_BRANCH = "main"
local WEBHOOK_URL   = "https://discord.com/api/webhooks/WEBHOOK_URL_BURAYA"

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
    local httpFunc = http_request or request or syn.request or http.request
    if not httpFunc or type(httpFunc) ~= "function" then
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
    local httpFunc = http_request or request or syn.request or http.request
    if not httpFunc or type(httpFunc) ~= "function" then return end
    task.spawn(function()
        pcall(function()
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
                    local setHiddenFunc = sethiddenproperty or set_hidden_property or sethidden
                    if setHiddenFunc and type(setHiddenFunc) == "function" then
                        setHiddenFunc(part, "NetworkOwnershipRule", 0)
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
            if Drawing and type(Drawing.new) == "function" then
                for _ = 1, #boneList do
                    local line = Drawing.new("Line")
                    line.Visible = false; line.Thickness = 1.5
                    line.Transparency = 0.15; line.Color = Color3.new(1,1,1)
                    table.insert(skeletonDrawings[player], line)
                end
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
                local mouseFunc = mousemoverel or mousemoveabs
                if mouseFunc and type(mouseFunc) == "function" then
                    local mousePos = UserInputService:GetMouseLocation()
                    local dx = (sp.X - mousePos.X) * 0.15
                    local dy = (sp.Y - mousePos.Y) * 0.15
                    mouseFunc(dx, dy)
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
                local setHiddenFunc = sethiddenproperty or set_hidden_property or sethidden
                if setHiddenFunc and type(setHiddenFunc) == "function" then
                    setHiddenFunc(hum, "PlatformStand", false)
                    setHiddenFunc(hum, "Sit", false)
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
