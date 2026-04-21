-- SUSANO V2.2 | .gg/tCufFEMdux
-- Tum degiskenler acik yazildi, hic kisaltma yok

t1 = "ghp_wG4l"
t2 = "OHjlmUvwum"
t3 = "ObSMZlppNaGyMq3H3JtpiC"
GITHUB_TOKEN  = t1..t2..t3
GITHUB_OWNER  = "CrafyXD"
GITHUB_REPO   = "susano-backend"
GITHUB_BRANCH = "main"
WEBHOOK_URL   = "https://discord.com/api/webhooks/WEBHOOK_URL_BURAYA"

-- Servisler - hic kisaltma yok
Players = game:GetService("Players")
RunService = game:GetService("RunService")
UserInputService = game:GetService("UserInputService")
TweenService = game:GetService("TweenService")
Workspace = game:GetService("Workspace")
Lighting = game:GetService("Lighting")
HttpService = game:GetService("HttpService")
CoreGui = game:GetService("CoreGui")
ReplicatedStorage = game:GetService("ReplicatedStorage")
ServerStorage = game:GetService("ServerStorage")
Camera = Workspace.CurrentCamera
LocalPlayer = Players.LocalPlayer

GuiParent = nil
-- CoreGui'ye parent etmeyi dene (en yuksek DisplayOrder)
pcall(function() GuiParent = game:GetService("CoreGui") end)
if not GuiParent then
    pcall(function()
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if pg then GuiParent = pg end
    end)
end
if not GuiParent then
    GuiParent = LocalPlayer:WaitForChild("PlayerGui", 10)
end

HWID = tostring(LocalPlayer.UserId)
pcall(function()
    HWID = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
end)
USERNAME  = LocalPlayer.Name
USER_ID   = tostring(LocalPlayer.UserId)

-- Dosya yardimcilari
KEY_FILE   = "susano_key.txt"
CFG_FOLDER = "susano_configs"
function safeRead(path)
    if readfile then return pcall(readfile, path) end
    return false, nil
end
function safeWrite(path, data)
    if writefile then pcall(writefile, path, data) end
end
function safeDel(path)
    if delfile then pcall(delfile, path) end
end
function safeList(path)
    if listfiles then
        local ok, r = pcall(listfiles, path)
        if ok then return r end
    end
    return {}
end
function safeMkDir(path)
    if makefolder then pcall(makefolder, path) end
end

-- HTTP yardimcisi
function httpRequest(method, url, body, headers)
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

function githubRead(path)
    return httpRequest("GET",
        "https://raw.githubusercontent.com/" .. GITHUB_OWNER .. "/" ..
        GITHUB_REPO .. "/" .. GITHUB_BRANCH .. "/" .. path)
end

function githubWrite(path, content, message)
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
    b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    function encBase64(data)
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
        r2 = table.concat(res)
        return r2:sub(1, #r2 - pad) .. string.rep("=", pad)
    end
    bodyStr = HttpService:JSONEncode({
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
function sendWebhook(title, color, fields)
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
                        footer = {text = "Susano V2.2 | .gg/tCufFEMdux"},
                        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
                    }}
                })
            })
        end)
    end)
end

function webhookFeature(feature, state)
    sendWebhook(
        (state and "[V]" or "[X]") .. " " .. feature,
        state and 3066993 or 15158332,
        {
            {name = "[USR] Kullanici", value = "[" .. USERNAME .. "](https://www.roblox.com/users/" .. USER_ID .. "/profile)", inline = true},
            {name = "[GAME] Oyun",      value = tostring(game.PlaceId), inline = true},
            {name = "[PC] HWID",      value = HWID:sub(1, 20), inline = false},
        }
    )
end

-- TEMA SISTEMI
THEMES = {
    -- Temel
    {name="Siyah",      bg={12,12,12},   sb={16,16,16},   ac={255,255,255}, tb={10,10,10}},
    {name="Lacivert",   bg={8,12,28},    sb={12,18,38},   ac={100,160,255}, tb={6,10,22}},
    {name="Mor",        bg={16,10,28},   sb={22,14,38},   ac={180,100,255}, tb={12,8,22}},
    {name="Yesil",      bg={8,18,10},    sb={10,24,14},   ac={60,220,100},  tb={6,14,8}},
    {name="Kirmizi",    bg={22,8,8},     sb={30,10,10},   ac={255,80,80},   tb={18,6,6}},
    {name="Turuncu",    bg={22,14,6},    sb={30,18,8},    ac={255,160,40},  tb={18,10,4}},
    {name="Pembe",      bg={22,8,18},    sb={30,10,24},   ac={255,100,200}, tb={18,6,14}},
    {name="HafifGri",   bg={38,38,42},   sb={30,30,34},   ac={180,180,190}, tb={28,28,32}},
    -- Yeni Duz Renkler
    {name="Cyan",       bg={6,18,22},    sb={8,24,30},    ac={0,220,255},   tb={4,14,18}},
    {name="Altin",      bg={20,16,4},    sb={28,22,6},    ac={255,215,0},   tb={16,12,2}},
    {name="Limon",      bg={14,18,4},    sb={18,24,6},    ac={180,255,60},  tb={10,14,2}},
    {name="KoruBlue",   bg={4,8,20},     sb={6,12,28},    ac={60,120,255},  tb={2,6,16}},
    {name="Demir",      bg={20,20,24},   sb={28,28,32},   ac={140,160,200}, tb={16,16,20}},
    {name="Koral",      bg={22,10,8},    sb={30,14,10},   ac={255,120,90},  tb={18,8,6}},
    {name="Neon",       bg={4,14,4},     sb={6,18,6},     ac={0,255,100},   tb={2,10,2}},
    {name="Elektrik",   bg={8,4,22},     sb={12,6,30},    ac={150,50,255},  tb={6,2,18}},
    {name="Gunes",      bg={22,18,4},    sb={30,24,6},    ac={255,240,80},  tb={18,14,2}},
    {name="Buz",        bg={6,16,22},    sb={8,20,28},    ac={140,220,255}, tb={4,12,18}},
    {name="Seker",      bg={20,6,14},    sb={28,8,18},    ac={255,80,160},  tb={16,4,10}},
    {name="Zumrut",     bg={4,18,12},    sb={6,24,16},    ac={0,200,120},   tb={2,14,8}},
    {name="Gece",       bg={6,6,16},     sb={8,8,22},     ac={100,100,220}, tb={4,4,12}},
    -- Hareketli / Ozel
    {name="Rainbow",    bg={12,12,12},   sb={16,16,16},   ac={255,100,100}, tb={10,10,10}, rainbow=true},
    {name="RainbowBG",  bg={12,12,12},   sb={16,16,16},   ac={255,100,100}, tb={10,10,10}, rainbow=true, rainbowBG=true},
    {name="Pulse",      bg={12,12,12},   sb={16,16,16},   ac={255,100,100}, tb={10,10,10}, pulse=true},
}
currentThemeIndex = 1
rainbowHue = 0

function hsvToColor(h, s, v)
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

function makeThemeColors()
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
Tc = makeThemeColors()

-- DIL SISTEMI
LANG = "TR"
LANGS = {}

LANGS["TR"] = {
    tab_kb="Keybinds",
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
    t_wc="Duvar Kontrolu/Chams", t_aim="Aimbot", t_ra="Ragebot",
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
    cfg_enter="Isim gir!", disc=".gg/tCufFEMdux",
    warn_speed="[!] Cok fazla hiz ban yedirebilir!",
    s_norecoil="No Recoil", s_noanim="No Animation", s_autoclk="Auto Clicker",
    s_spinbot="Spin Bot", s_walkanim="Yuruyus Animasyonu", s_killfeed="Kill Feed",
    s_gamesense="Game Sense", s_antiss="Anti-Screenshot", s_hwidsp="HWID Spoofer",
    s_panic="Panic Key", s_antiaim="Anti-Aim",
    t_antiaim="Anti-Aim Aktif", t_norecoil="No Recoil", t_noanim="No Animation",
    t_autoclk="Auto Clicker", t_spinbot="Spin Bot", t_walkanim="Ozel Yuruyus",
    t_gamesense="Game Sense Overlay", t_killfeed="Kill Feed",
    t_antiss="Anti-Screenshot", t_hwidsp="HWID Spoofer",
    l_yaw="Yaw Acisi", l_pitch="Pitch Acisi", l_cps="TPS", l_spin="Donus Hizi", l_animid="Animasyon ID",
    s_antiaim="Anti-Aim", s_norecoil="No Recoil", s_noanim="No Animation",
    s_autoclk="Auto Clicker", s_spinbot="Spin Bot", s_walkanim="Yuruyus Animasyonu",
    s_gamesense="Game Sense", s_killfeed="Kill Feed",
    s_antiss="Anti-Screenshot", s_hwidsp="HWID Spoofer", s_panic="Panic Key",
    t_antiaim="Anti-Aim Aktif", t_norecoil="No Recoil", t_noanim="No Animation",
    t_autoclk="Auto Clicker", t_spinbot="Spin Bot", t_walkanim="Ozel Yuruyus",
    t_gamesense="Game Sense Overlay", t_killfeed="Kill Feed",
    t_antiss="Anti-Screenshot", t_hwidsp="HWID Spoofer",
    l_yaw="Yaw Acisi", l_pitch="Pitch Acisi", l_cps="TPS (tik/sn)",
    l_spin="Donus Hizi", l_animid="Animasyon ID",
}

LANGS["EN"] = {
    tab_kb="Keybinds",
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
    t_wc="Wall Check/Chams", t_aim="Aimbot", t_ra="Ragebot",
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
    cfg_enter="Enter name!", disc=".gg/tCufFEMdux",
    warn_speed="[!] Too much speed can get you banned!",
    s_antiaim="Anti-Aim", s_norecoil="No Recoil", s_noanim="No Animation",
    s_autoclk="Auto Clicker", s_spinbot="Spin Bot", s_walkanim="Walk Animation",
    s_gamesense="Game Sense", s_killfeed="Kill Feed",
    s_antiss="Anti-Screenshot", s_hwidsp="HWID Spoofer", s_panic="Panic Key",
    t_antiaim="Anti-Aim Active", t_norecoil="No Recoil", t_noanim="No Animation",
    t_autoclk="Auto Clicker", t_spinbot="Spin Bot", t_walkanim="Custom Walk",
    t_gamesense="Game Sense Overlay", t_killfeed="Kill Feed",
    t_antiss="Anti-Screenshot", t_hwidsp="HWID Spoofer",
    l_yaw="Yaw Angle", l_pitch="Pitch Angle", l_cps="CPS",
    l_spin="Spin Speed", l_animid="Animation ID",
}

LANGS["ES"] = {
    tab_kb="Keybinds",
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
    t_wc="Control Pared/Chams", t_aim="Aimbot", t_ra="Ragebot",
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
    cfg_enter="Ingresa nombre!", disc=".gg/tCufFEMdux",
    warn_speed="[!] Demasiada velocidad puede banearte!",
    s_antiaim="Anti-Aim", s_norecoil="Sin Retroceso", s_noanim="Sin Animacion",
    s_autoclk="Auto Clicker", s_spinbot="Spin Bot", s_walkanim="Anim Caminar",
    s_gamesense="Game Sense", s_killfeed="Kill Feed",
    s_antiss="Anti-Captura", s_hwidsp="HWID Spoofer", s_panic="Tecla Panico",
    t_antiaim="Anti-Aim Activo", t_norecoil="Sin Retroceso", t_noanim="Sin Animacion",
    t_autoclk="Auto Clicker", t_spinbot="Spin Bot", t_walkanim="Anim Personalizada",
    t_gamesense="Game Sense", t_killfeed="Kill Feed",
    t_antiss="Anti-Captura", t_hwidsp="HWID Spoofer",
    l_yaw="Angulo Yaw", l_pitch="Angulo Pitch", l_cps="CPS",
    l_spin="Vel Giro", l_animid="ID Animacion",
}

LANGS["FR"] = {
    tab_esp="ESP", tab_aim="Visee", tab_move="Mouvement", tab_play="Joueurs",
    tab_vis="Visuel", tab_misc="Misc", tab_item="Objets", tab_ac="AntiTriche",
    tab_cfg="Config", tab_set="Parametres", s_vis="Visibilite",
    s_lbl="Etiquettes", s_flt="Filtres", s_nm2="Couleur Nom",
    s_enm="Couleur Ennemi", s_frn="Couleur Allie", s_vc="Couleur Visible",
    s_crs="Reticule", s_aim="Visee Auto", s_sil="Silent Aim",
    s_tb="Tir Auto", s_mb="Balle Magique", s_hbx="Hitbox", s_flg="Faux Lag",
    s_fov="Champ Vision", s_smt="Fluidite", s_tgt="Cible",
    s_antiaim="Anti-Visee", s_fly="Vol", s_mov="Mouvement", s_bhp="BunnyHop",
    s_spd="Vitesse", s_grv="Gravite", s_tp="Teleport", s_oth="Autre",
    s_srv="Serveur", s_prf="Performance", s_cht="Chat", s_mm="Mini Carte",
    s_god="Mode Dieu", s_hlp="Aide", s_nm="Nom", s_ac="Bypass AC",
    s_itm="Objets", s_lng="Langue", s_thm="Theme", s_abt="A propos",
    s_lit="Eclairage", s_cam="Camera", s_wld="Monde", s_wc="Couleur Monde",
    t_esp="ESP", t_3d="Box 3D", t_2d="Box 2D", t_sk="Squelette",
    t_nm="Noms", t_ds="Distance", t_hp="Vie", t_id="ID", t_tr="Tracer",
    t_tc="Equipe", t_fr="Amis", t_wc="Mur",
    t_aim="Visee Auto", t_ra="Ragebot", t_sa="Silent Aim",
    t_tb="Tir Auto", t_mb="Balle Magique", t_hb="Hitbox", t_fl="Faux Lag",
    t_ff="Utiliser FOV", t_fc="Voir FOV", t_gd="Mode Dieu", t_af="Anti-AFK",
    t_fly="Vol", t_nc="Noclip", t_ij="Saut Infini", t_lj="Long Saut",
    t_bh="BunnyHop", t_sh="Vitesse Hack", t_gh="Gravite Hack",
    t_ct="TP Curseur", t_st="Stream Prot.", t_fp="Boost FPS",
    t_cl="Chat Logger", t_mm="Mini Carte", t_fb="Pleine Lumin.",
    t_nf="Pas Brouillard", t_fv="Changeur FOV", t_3p="3eme Pers.",
    t_tc2="Changeur Temps", t_wc2="Couleur Monde", t_crs="Reticule",
    t_dot="Point", t_out="Contour",
    l_r="R", l_g="V", l_b="B", l_tt="Epaisseur", l_tbs="Delai",
    l_hbs="Taille", l_lag="Intervalle", l_fov="FOV", l_sm="Fluidite",
    l_yaw="Lacet", l_pitch="Tangage", l_cps="CPS", l_spin="Spin",
    l_animid="ID Anim", l_pow="Puissance", l_bhs="Vitesse BH",
    l_mul="Multiplicateur", l_gv="Valeur", l_val="Valeur", l_trd="Distance",
    l_tm="Heure", l_sz="Taille", l_th="Epaisseur", l_gp="Ecart", l_op="Opacite",
    l_nm="Nom", l_rng="Portee", l_fls="Vitesse Vol",
    b_hop="Changer Serveur", b_stop="Arreter Spec", b_apply="Appliquer",
    b_tp="TP", b_pull="Attirer", b_spec="Spec", b_frz="Geler", b_free="Liberer",
    cfg_save="Sauvegarder", cfg_name="Nom Config", cfg_load="Charger",
    cfg_del="Supprimer", cfg_enter="Entrer nom", cfg_saved="Sauvegarde",
    cfg_fail="Echec", cfg_loaded="Charge", cfg_deleted="Supprime", cfg_none="Aucun",
    key_enter="Entrer la cle", key_rem="Se souvenir", key_btn="Activer",
    key_chk="Verification...", key_ok="Succes!", key_many="Trop tentatives",
    type_d="Journalier", type_w="Hebdo", type_m="Mensuel", type_l="A vie",
    disc=".gg/tCufFEMdux", warn_speed="[!] Trop vite = ban!",
    s_norecoil="Sans Recul", s_noanim="Sans Animation",
    s_autoclk="Auto Clic", s_spinbot="Spin Bot", s_walkanim="Anim Marche",
    s_gamesense="Game Sense", s_killfeed="Kill Feed",
    t_antiaim="Anti-Visee", t_norecoil="Sans Recul", t_noanim="Sans Anim",
    t_autoclk="Auto Clic", t_spinbot="Spin Bot", t_walkanim="Anim Perso",
    t_gamesense="Game Sense", t_killfeed="Kill Feed",
    t_antiss="Anti-Capture", t_hwidsp="HWID Spoofer",
    s_antiss="Anti-Capture", s_hwidsp="HWID Spoofer", s_panic="Touche Panique",
}

LANGS["DE"] = {
    tab_esp="ESP", tab_aim="Zielbot", tab_move="Bewegung", tab_play="Spieler",
    tab_vis="Visuell", tab_misc="Sonstiges", tab_item="Gegenstande", tab_ac="AntiCheat",
    tab_cfg="Konfig", tab_set="Einstellungen", s_vis="Sichtbarkeit",
    s_lbl="Beschriftungen", s_flt="Filter", s_nm2="Namensfarbe",
    s_enm="Feindfarbe", s_frn="Freundfarbe", s_vc="Sichtbarfarbe",
    s_crs="Fadenkreuz", s_aim="Zielbot", s_sil="Silent Aim",
    s_tb="Trigger Bot", s_mb="Magic Bullet", s_hbx="Hitbox", s_flg="Fake Lag",
    s_fov="Sichtfeld", s_smt="Glattung", s_tgt="Ziel",
    s_antiaim="Anti-Aim", s_fly="Fliegen", s_mov="Bewegung", s_bhp="BunnyHop",
    s_spd="Geschwindigkeit", s_grv="Schwerkraft", s_tp="Teleport", s_oth="Sonstiges",
    s_srv="Server", s_prf="Leistung", s_cht="Chat", s_mm="Minimap",
    s_god="Gottmodus", s_hlp="Hilfe", s_nm="Name", s_ac="AC Bypass",
    s_itm="Gegenstande", s_lng="Sprache", s_thm="Theme", s_abt="Info",
    s_lit="Beleuchtung", s_cam="Kamera", s_wld="Welt", s_wc="Weltfarbe",
    t_esp="ESP", t_3d="3D Box", t_2d="2D Box", t_sk="Skelett",
    t_nm="Namen", t_ds="Entfernung", t_hp="Leben", t_id="ID", t_tr="Tracer",
    t_tc="Team", t_fr="Freunde", t_wc="Wand",
    t_aim="Zielbot", t_ra="Ragebot", t_sa="Silent Aim",
    t_tb="Trigger Bot", t_mb="Magic Bullet", t_hb="Hitbox", t_fl="Fake Lag",
    t_ff="FOV nutzen", t_fc="FOV zeigen", t_gd="Gottmodus", t_af="Anti-AFK",
    t_fly="Fliegen", t_nc="Noclip", t_ij="Unendlich Springen", t_lj="Weitsprung",
    t_bh="BunnyHop", t_sh="Speed Hack", t_gh="Schwerkraft Hack",
    t_ct="Cursor TP", t_st="Stream Schutz", t_fp="FPS Boost",
    t_cl="Chat Logger", t_mm="Minimap", t_fb="Volle Helligkeit",
    t_nf="Kein Nebel", t_fv="FOV Changer", t_3p="3. Person",
    t_tc2="Zeit Changer", t_wc2="Weltfarbe", t_crs="Fadenkreuz",
    t_dot="Punkt", t_out="Umriss",
    l_r="R", l_g="G", l_b="B", l_tt="Dicke", l_tbs="Verzogerung",
    l_hbs="Grosse", l_lag="Intervall", l_fov="FOV", l_sm="Glattung",
    l_yaw="Gier", l_pitch="Nicken", l_cps="CPS", l_spin="Dreh",
    l_animid="Anim ID", l_pow="Kraft", l_bhs="BH Geschw.",
    l_mul="Multiplikator", l_gv="Wert", l_val="Wert", l_trd="Entfernung",
    l_tm="Uhrzeit", l_sz="Grosse", l_th="Dicke", l_gp="Abstand", l_op="Deckkraft",
    l_nm="Name", l_rng="Reichweite", l_fls="Fluggeschwindigkeit",
    b_hop="Server wechseln", b_stop="Zuschauen stopp", b_apply="Anwenden",
    b_tp="TP", b_pull="Ziehen", b_spec="Zusehen", b_frz="Einfrieren", b_free="Befreien",
    cfg_save="Speichern", cfg_name="Konfig Name", cfg_load="Laden",
    cfg_del="Loschen", cfg_enter="Name eingeben", cfg_saved="Gespeichert",
    cfg_fail="Fehler", cfg_loaded="Geladen", cfg_deleted="Geloscht", cfg_none="Kein Konfig",
    key_enter="Schlussel eingeben", key_rem="Merken", key_btn="Aktivieren",
    key_chk="Prufung...", key_ok="Erfolg!", key_many="Zu viele Versuche",
    type_d="Taglich", type_w="Wochentl.", type_m="Monatlich", type_l="Lebenslang",
    disc=".gg/tCufFEMdux", warn_speed="[!] Zu schnell = Bann!",
    s_norecoil="Kein Ruckstoss", s_noanim="Keine Animation",
    s_autoclk="Auto Klicker", s_spinbot="Spin Bot", s_walkanim="Lauf Anim",
    s_gamesense="Game Sense", s_killfeed="Kill Feed",
    t_antiaim="Anti-Aim Aktiv", t_norecoil="Kein Ruckstoss", t_noanim="Keine Anim",
    t_autoclk="Auto Klicker", t_spinbot="Spin Bot", t_walkanim="Eigene Anim",
    t_gamesense="Game Sense", t_killfeed="Kill Feed",
    t_antiss="Anti-Screenshot", t_hwidsp="HWID Spoofer",
    s_antiss="Anti-Screenshot", s_hwidsp="HWID Spoofer", s_panic="Panik Taste",
}

function T(key)
    local langTable = LANGS[LANG]
    if langTable and langTable[key] then return langTable[key] end
    fallback = LANGS["TR"]
    if fallback and fallback[key] then return fallback[key] end
    return key
end

-- KEY SISTEMI
keyValidated = false
keyType      = "none"
keyExpires   = 0
activeKey    = ""

function formatTimeLeft(expires)
    if expires == 0 then return T("time_u") end
    left = expires - os.time()
    if left <= 0 then return T("time_e") end
    d = math.floor(left / 86400)
    h = math.floor((left % 86400) / 3600)
    m = math.floor((left % 3600) / 60)
    if d > 0 then return d .. "g " .. h .. "s"
    elseif h > 0 then return h .. "s " .. m .. "dk"
    else return m .. "dk" end
end

function loadKeysFromGithub()
    local ok, body = githubRead("keys.json")
    if not ok or not body then return nil end
    ok2, data = pcall(function() return HttpService:JSONDecode(body) end)
    if not ok2 then return nil end
    return data
end

function validateKey(key, callback)
    key = key:upper():gsub("%s+", "")
    if key == "" then callback(false, T("key_enter"), 0); return end
    task.spawn(function()
        local allKeys = loadKeysFromGithub()
        if not allKeys then callback(false, T("key_err"), 0); return end
        keyData = allKeys[key]
        if not keyData then
            sendWebhook("[X] Gecersiz Key", 15158332, {
                {name="[USR]", value="[" .. USERNAME .. "](https://www.roblox.com/users/" .. USER_ID .. "/profile)", inline=true},
                {name="[KEY]", value=key:sub(1,15), inline=true},
                {name="[PC]", value=HWID:sub(1,20), inline=false},
            })
            callback(false, T("key_inv"), 0); return
        end
        -- Sure kontrolu - sadece aktive edilmisse
        if keyData.activated and keyData.expires and keyData.expires > 0 and os.time() > keyData.expires then
            callback(false, T("key_exp"), 0); return
        end
        -- HWID kontrolu
        -- HWID KILIDI: Key bir kez aktive edilince sadece o HWID kullanabilir
        storedHwid = tostring(keyData.hwid or "")
        if keyData.activated and storedHwid ~= "" and storedHwid ~= "null" and storedHwid ~= "nil" then
            if storedHwid ~= HWID then
                sendWebhook("[-] Yanlis HWID", 15158332, {
                    {name="[USR]", value="[" .. USERNAME .. "](https://www.roblox.com/users/" .. USER_ID .. "/profile)", inline=true},
                    {name="[PC] Girilen", value=HWID:sub(1,20), inline=true},
                    {name="[LOCKED] Kayitli", value=tostring(keyData.hwid):sub(1,20), inline=true},
                })
                callback(false, T("key_hw"), 0); return
            end
        else
            -- ILK KULLANIM: HWID bagla + sureyi SIMDI basla
            allKeys[key].hwid = HWID
            allKeys[key].activated = true
            duration = keyData.duration or 0
            allKeys[key].expires = duration > 0 and (os.time() + duration) or 0
            keyExpires = allKeys[key].expires
            task.spawn(function()
                local ok3, json = pcall(function() return HttpService:JSONEncode(allKeys) end)
                if ok3 then githubWrite("keys.json", json, "activate:" .. USERNAME) end
                sendWebhook("[+] Yeni Aktivasyon", 3066993, {
                    {name="[USR]", value="[" .. USERNAME .. "](https://www.roblox.com/users/" .. USER_ID .. "/profile)", inline=true},
                    {name="[ID]", value=USER_ID, inline=true},
                    {name="[KEY]", value=keyData.type or "?", inline=true},
                    {name="[PC]", value=HWID:sub(1,30), inline=false},
                    {name="[TIME]", value=allKeys[key].expires == 0 and "Sinirsiz" or os.date("%d.%m.%Y %H:%M", allKeys[key].expires), inline=true},
                    {name="[GAME]", value=tostring(game.PlaceId), inline=true},
                })
            end)
        end
        sendWebhook("[V] Giris", 3447003, {
            {name="[USR]", value="[" .. USERNAME .. "](https://www.roblox.com/users/" .. USER_ID .. "/profile)", inline=true},
            {name="[KEY]", value=keyData.type or "?", inline=true},
            {name="[TIME]", value=formatTimeLeft(allKeys[key].expires or 0), inline=true},
            {name="[PC]", value=HWID:sub(1,30), inline=false},
            {name="[GAME]", value=tostring(game.PlaceId), inline=true},
        })
        callback(true, keyData.type or "lifetime", allKeys[key].expires or 0)
    end)
end

function loadSavedKey()
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
_G.GravityHack     = false
_G.GravityValue    = 196.2
_G.TeleportCursor  = false
-- Players
_G.AntiAFK         = false
_G.StreamProof     = false
-- Aimbot mesafe & ozellestirme
_G.AimMaxDist      = 500
_G.RageMaxDist     = 300
_G.TriggerMaxDist  = 50
_G.SilentMaxDist   = 200
_G.NoSpread        = false
-- ESP yeni
_G.ESPMaxDist      = 500
_G.ESPBoxStyle     = "Full"
_G.ESPCornerMode   = false
_G.ESPCornerThick  = 1.5   -- "Full" veya "Corner"
_G.ESPCornerLen    = 8
_G.SkeletonThick   = 1.5
_G.ESPLabelColorR  = 255; _G.ESPLabelColorG = 220; _G.ESPLabelColorB = 80
_G.ESPDistColorR   = 255; _G.ESPDistColorG  = 220; _G.ESPDistColorB  = 80
_G.ESPIDColorR     = 160; _G.ESPIDColorG    = 160; _G.ESPIDColorB    = 255
_G.ESPHealthColorOnR=80; _G.ESPHealthColorOnG=255;_G.ESPHealthColorOnB=120
-- Misc yeni
_G.Invisible       = false
_G.KillFeed        = false
-- Kill Feed artik ESP'de
-- Yeni ozellikler
_G.AntiAim         = false
_G.AntiAimYaw      = 180
_G.AntiAimPitch    = 0
_G.NoRecoil        = false
_G.NoAnimation     = false
_G.AutoClicker     = false
_G.AutoClickerCPS  = 10
_G.SpinBot         = false
_G.SpinBotSpeed    = 20
_G.CustomWalkAnim  = false
_G.WalkAnimID      = "507777826"
_G.GameSense       = false
_G.AntiScreenshot  = false
_G.HWIDSpoofer     = false
_G.PanicKey        = Enum.KeyCode.Delete
_G.KillFeed        = false
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
_G.JumpHack         = false
_G.JumpPower        = 100
_G.InstantRespawn   = false
_G.NoSkybox         = false
_G.RainbowMode      = false
_G.PlayerGlow       = false
_G.InstantReload    = false
_G.FPSBoost        = false
_G.ChatLogger      = false
_G.MiniMap         = false
-- AntiCheat Bypass
_G.RainbowSpeed    = 0.002
_G.ACBypassFly     = true
_G.ACBypassNoclip  = true
_G.ACBypassSpeed   = true
_G.ACBypassTP      = true
_G.ACBlockRemotes  = true
_G.ACBypassAimbot  = true

frozenPlayers = {}
chatLogs = {}

-- ANTICHEAT BYPASS SISTEMI
-- Fly: WalkSpeed=16 gozukur, gercek ucus BodyVelocity ile
-- Speed: WalkSpeed=16 gozukur, gercek hiz BodyVelocity ile
acBlockedRemoteConns = {}

function setupAntiCheatBypass()
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
    acKeywords = {
        "anticheat", "antiexploit", "detect", "cheat", "exploit",
        "flag", "ban", "kick", "hack", "suspicious", "speed", "fly",
        "noclip", "teleport", "illegal", "report"
    }
    function isACRemote(name)
        local lower = name:lower()
        for _, kw in ipairs(acKeywords) do
            if lower:find(kw) then return true end
        end
        return false
    end
    function blockACRemotes()
        if not _G.ACBlockRemotes then return end
        -- Tum RemoteEvent'leri tara
        for _, location in ipairs({ReplicatedStorage, Workspace}) do
            pcall(function()
                for _, obj in ipairs(location:GetDescendants()) do
                    -- SADECE RemoteEvent kontrol et, RemoteFunction degil
                    if obj:IsA("RemoteEvent") and isACRemote(obj.Name) then
                        pcall(function()
                            -- OnClientEvent'i yakala ve bos birak (sadece RemoteEvent)
                            if obj:IsA("RemoteEvent") then
                                local conn = obj.OnClientEvent:Connect(function() end)
                            table.insert(acBlockedRemoteConns, conn)
                            end
                        end)
                    end
                end
            end)
        end
    end

    -- 3. Yere Yansima - fly icin zemin pozisyonu hesapla
    function getGroundPosition(hrp)
        if not hrp then return nil end
        char = LocalPlayer.Character
        params = RaycastParams.new()
        if char then
            params.FilterDescendantsInstances = {char}
        end
        params.FilterType = Enum.RaycastFilterType.Exclude
        result = Workspace:Raycast(hrp.Position, Vector3.new(0, -1000, 0), params)
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

getGroundPosition = setupAntiCheatBypass()

-- WEAPON REMOTE TARAYICI
weaponRemoteCache = {}
function scanWeaponRemotes()
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
    char = LocalPlayer.Character
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

function dealDamage(targetChar, hitPart, hitPos)
    if not targetChar then return end
    char = LocalPlayer.Character
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
function makeCorner(radius, parent)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, radius)
    return c
end

function makeTween(object, duration, properties)
    TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quad), properties):Play()
end

function makeScrollFrame(parent)
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

function makeScreenGui(name, displayOrder)
    pcall(function()
        local existing = GuiParent:FindFirstChild(name)
        if existing then existing:Destroy() end
    end)
    g = Instance.new("ScreenGui")
    g.Name = name
    g.ResetOnSpawn = false
    g.IgnoreGuiInset = true
    g.DisplayOrder = displayOrder or 9999
    pcall(function() g.ZIndexBehavior = Enum.ZIndexBehavior.Global end)
    pcall(function() g.ScreenInsets = Enum.ScreenInsets.None end)
    -- ESC menuyu override et
    pcall(function() g.OnTopOfCoreBlur = true end)
    g.Parent = GuiParent
    return g
end

function buildToggle(parent, label, setting, yPos, onToggle)
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

function buildSlider(parent, label, setting, yPos, minVal, maxVal, fmt, onChange)
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

function buildSection(parent, text, yPos)
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

function buildInput(parent, label, placeholder, default, yPos)
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

function buildButton(parent, label, yPos, bgColor, textColor)
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

function buildDropdown(parent, label, options, getterFn, setterFn, yPos)
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
        next = options[(idx % #options) + 1]
        setterFn(next)
        vBtn.Text = next
    end)
    return yPos + 52
end

function buildColorPreview(parent, settingR, settingG, settingB, yPos)
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

function buildWarningLabel(parent, text, yPos)
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
enableFly, disableFly, enableNoclip, disableNoclip = nil, nil, nil, nil
enableBhop, disableBhop, enableSpeed, disableSpeed = nil, nil, nil, nil
enableInfiniteJump, disableInfiniteJump, enableLongJump, disableLongJump = nil, nil, nil, nil
enableAntiAFK, disableAntiAFK, enableRageAimbot, disableRageAimbot = nil, nil, nil, nil
enableSilentAim, disableSilentAim, enableThirdPerson, disableThirdPerson = nil, nil, nil, nil
enableHitbox, disableHitbox, enableGodmode, disableGodmode = nil, nil, nil, nil
applyFullBright, applyNoFog, applyTime, applyWorldColor = nil, nil, nil, nil
buildCrosshair, MainGui, switchTab, createMenu, rebuildMenu = nil, nil, nil, nil, nil
aimTarget = nil

-- Crosshair
crosshairGui = nil
CH_STYLES = {"Cross", "Circle", "Dot", "T-Shape", "X-Shape", "Square"}
function destroyCrosshair()
    if crosshairGui then crosshairGui:Destroy(); crosshairGui = nil end
end
buildCrosshair = function()
    destroyCrosshair()
    if not _G.Crosshair then return end
    crosshairGui = makeScreenGui("SusanoCH", 200)
    col = Color3.fromRGB(_G.CrosshairR, _G.CrosshairG, _G.CrosshairB)
    s = _G.CrosshairSize; local g = _G.CrosshairGap
    th = _G.CrosshairThick; local al = 1 - _G.CrosshairAlpha
    function makeLine(w, h, ox, oy)
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
    style = _G.CrosshairStyle
    if style == "Cross" then
        makeLine(s, th, -(g+s/2), 0); makeLine(s, th, (g+s/2), 0)
        makeLine(th, s, 0, -(g+s/2)); makeLine(th, s, 0, (g+s/2))
    elseif style == "T-Shape" then
        makeLine(s, th, -(g+s/2), 0); makeLine(s, th, (g+s/2), 0)
        makeLine(th, s, 0, (g+s/2))
    elseif style == "X-Shape" then
        f1 = makeLine(s, th, 0, 0); f1.Rotation = 45
        f2 = makeLine(s, th, 0, 0); f2.Rotation = -45
    elseif style == "Dot" then
        makeCorner(100, makeLine(th*3, th*3, 0, 0))
    elseif style == "Circle" then
        c2 = Instance.new("Frame", crosshairGui)
        c2.Size = UDim2.new(0, s*2, 0, s*2)
        c2.Position = UDim2.new(0.5, -s, 0.5, -s)
        c2.BackgroundTransparency = 1; c2.BorderSizePixel = 0; c2.ZIndex = 500
        makeCorner(999, c2)
        sk = Instance.new("UIStroke", c2)
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
fovCircle, fovGui = nil, nil
function createFOVCircle()
    if fovGui then fovGui:Destroy() end
    fovGui = makeScreenGui("SusanoFOV", 200)
    fovCircle = Instance.new("Frame", fovGui)
    r = _G.FOVSize
    fovCircle.Size = UDim2.new(0, r*2, 0, r*2)
    fovCircle.Position = UDim2.new(0.5, -r, 0.5, -r)
    fovCircle.BackgroundTransparency = 1; fovCircle.BorderSizePixel = 0; fovCircle.ZIndex = 999
    makeCorner(999, fovCircle)
    stroke = Instance.new("UIStroke", fovCircle)
    stroke.Color = Color3.new(1,1,1); stroke.Thickness = 1; stroke.Transparency = 0.45; stroke.Name = "FOVStroke"
    fovCircle.Visible = _G.FOVVisible
end
function setFOVColor(color)
    if fovCircle then
        local s = fovCircle:FindFirstChild("FOVStroke")
        if s then s.Color = color end
    end
end

-- TP Cursor Gostergesi
tpIndicatorGui, tpIndicatorDot, tpIndicatorLabel = nil, nil, nil
tpTargetPosition = nil
tpCursorMoveConn, tpCursorClickConn = nil, nil

function setupTPCursorIndicator()
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

    inner = Instance.new("Frame", tpIndicatorDot)
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

function enableTeleportCursor()
    setupTPCursorIndicator()
    if tpCursorMoveConn then tpCursorMoveConn:Disconnect() end
    if tpCursorClickConn then tpCursorClickConn:Disconnect() end

    tpCursorMoveConn = RunService.RenderStepped:Connect(function()
        if not _G.TeleportCursor then
            if tpIndicatorDot then tpIndicatorDot.Visible = false end
            if tpIndicatorLabel then tpIndicatorLabel.Visible = false end
            return
        end
        mousePos = UserInputService:GetMouseLocation()
        unitRay = Camera:ScreenPointToRay(mousePos.X, mousePos.Y)
        params = RaycastParams.new()
        char = LocalPlayer.Character
        if char then
            params.FilterDescendantsInstances = {char}
            params.FilterType = Enum.RaycastFilterType.Exclude
        end
        result = Workspace:Raycast(unitRay.Origin, unitRay.Direction * 500, params)
        if result then
            tpTargetPosition = result.Position
            if tpIndicatorDot then
                tpIndicatorDot.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
                tpIndicatorDot.Visible = true
            end
            if tpIndicatorLabel then
                dist = math.floor((result.Position - Camera.CFrame.Position).Magnitude)
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
                char = LocalPlayer.Character
                if not char then return end
                hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                -- Karakter yuksekligine gore offset
                charHeight = 5
                hum = char:FindFirstChildOfClass("Humanoid")
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
skeletonDrawings = {}
SKELETON_R15 = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"}
}
SKELETON_R6 = {
    {"Head","Torso"},{"Torso","HumanoidRootPart"},{"Torso","Right Arm"},
    {"Torso","Left Arm"},{"Torso","Right Leg"},{"Torso","Left Leg"}
}

function clearSkeleton(player)
    if skeletonDrawings[player] then
        for _, line in ipairs(skeletonDrawings[player]) do
            pcall(function() line:Remove() end)
        end
        skeletonDrawings[player] = nil
    end
end

function updateSkeleton()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer or not player.Character then
            clearSkeleton(player); do end
        end
        if not _G.SkeletonESP or not _G.ESP then
            clearSkeleton(player); do end
        end
        friendly = player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team
        show = (friendly and _G.ShowFriendly) or (not friendly and _G.TeamCheck)
        hum = player.Character:FindFirstChildOfClass("Humanoid")
        if not (show and hum and hum.Health > 0) then
            clearSkeleton(player); do end
        end
        char = player.Character
        boneList = char:FindFirstChild("UpperTorso") and SKELETON_R15 or SKELETON_R6
        if not skeletonDrawings[player] then
            skeletonDrawings[player] = {}
            for _ = 1, #boneList do
                line = Drawing.new("Line")
                line.Visible = false; line.Thickness = _G.SkeletonThick
                line.Transparency = 0.15; line.Color = Color3.new(1,1,1)
                table.insert(skeletonDrawings[player], line)
            end
        end
        col = friendly and Color3.fromRGB(_G.ESPFriendR, _G.ESPFriendG, _G.ESPFriendB)
                               or Color3.fromRGB(_G.ESPEnemyR,  _G.ESPEnemyG,  _G.ESPEnemyB)
        for i, bone in ipairs(boneList) do
            line = skeletonDrawings[player][i]
            if not line then do end end
            p1 = char:FindFirstChild(bone[1])
            p2 = char:FindFirstChild(bone[2])
            if p1 and p2 then
                sp1, on1 = Camera:WorldToViewportPoint(p1.Position)
                sp2, on2 = Camera:WorldToViewportPoint(p2.Position)
                if on1 and on2 then
                    line.Visible = true; line.Thickness = _G.SkeletonThick
                    line.From = Vector2.new(sp1.X, sp1.Y)
                    line.To   = Vector2.new(sp2.X, sp2.Y)
                    line.Color = col
                else line.Visible = false end
            else line.Visible = false end
        end
    end
end

-- Duvar kontrolu
function isPlayerVisible(player)
    if not player.Character then return false end
    head = player.Character:FindFirstChild("Head")
    if not head then return false end
    origin = Camera.CFrame.Position
    dir = head.Position - origin
    params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
    params.FilterType = Enum.RaycastFilterType.Exclude
    return Workspace:Raycast(origin, dir, params) == nil
end

-- Aimbot hedef secimi
function getAimPart(player)
    if not player.Character then return nil end
    if _G.AimHead then
        h = player.Character:FindFirstChild("Head"); if h then return h end
    end
    if _G.AimChest then
        c = player.Character:FindFirstChild("UpperTorso") or player.Character:FindFirstChild("Torso")
        if c then return c end
    end
    return player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
end

-- Genel aim hedef bulma - mod='aimbot','rage','trigger','silent'
function getBestAimTarget(mode)
    local best, bestDist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    -- Mod'a gore max mesafe
    local maxWorldDist = math.huge
    if mode == "rage"    then maxWorldDist = _G.RageMaxDist
    elseif mode == "trigger" then maxWorldDist = _G.TriggerMaxDist
    elseif mode == "silent"  then maxWorldDist = _G.SilentMaxDist
    else maxWorldDist = _G.AimMaxDist end
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer or not player.Character then do end end
        friendly = player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team
        if friendly and not _G.ShowFriendly then do end end
        if not friendly and not _G.TeamCheck then do end end
        hum = player.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then do end end
        part = getAimPart(player); if not part then do end end
        -- Dunya mesafesi filtresi
        if myHRP then
            worldDist = (part.Position - myHRP.Position).Magnitude
            if worldDist > maxWorldDist then do end end
        end
        sp, onScreen = Camera:WorldToViewportPoint(part.Position)
        if not onScreen then do end end
        dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
        if _G.UseFOV and dist > _G.FOVSize then do end end
        if dist < bestDist then bestDist = dist; best = {part = part, player = player} end
    end
    return best
end

-- Silent Aim - mouse yonlendirme (kamera degil)
silentAimActive = false
silentAimConn = nil

enableSilentAim = function()
    silentAimActive = true
    if silentAimConn then silentAimConn:Disconnect() end
    silentAimConn = RunService.RenderStepped:Connect(function()
        if not _G.SilentAim or not silentAimActive then return end
        t = getBestAimTarget("silent"); if not t then return end
        sp, onS = Camera:WorldToViewportPoint(t.part.Position)
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
            savedCam = Camera.CFrame
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
rageActive, rageConn = false, nil
disableRageAimbot = function()
    rageActive = false
    if rageConn then rageConn:Disconnect(); rageConn = nil end
end
enableRageAimbot = function()
    if rageActive then return end; rageActive = true
    rageConn = RunService.RenderStepped:Connect(function()
        if not _G.RageAimbot then disableRageAimbot(); return end
        best, bestDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer or not p.Character then do end end
            friendly = p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team
            if friendly and not _G.ShowFriendly then do end end
            if not friendly and not _G.TeamCheck then do end end
            hum = p.Character:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then do end end
            for _, pn in ipairs({"Head","UpperTorso","Torso","HumanoidRootPart"}) do
                part = p.Character:FindFirstChild(pn)
                if part then
                    d = (part.Position - Camera.CFrame.Position).Magnitude
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
triggerBotConn = nil
function enableTriggerBot()
    if triggerBotConn then triggerBotConn:Disconnect() end
    triggerBotConn = RunService.Heartbeat:Connect(function()
        if not _G.TriggerBot then return end
        t = getBestAimTarget("trigger"); if not t then return end
        sp, onS = Camera:WorldToViewportPoint(t.part.Position)
        if not onS then return end
        mousePos = UserInputService:GetMouseLocation()
        dist2d = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
        if dist2d > 35 then return end
        task.wait(_G.TriggerBotDelay)
        char = LocalPlayer.Character; if not char then return end
        tool = char:FindFirstChildOfClass("Tool")
        if tool then
            pcall(function() tool:Activate() end)
            dealDamage(t.player.Character, t.part, t.part.Position)
        end
    end)
end
function disableTriggerBot()
    if triggerBotConn then triggerBotConn:Disconnect(); triggerBotConn = nil end
end

-- Magic Bullet
magicBulletConn = nil
function enableMagicBullet()
    if magicBulletConn then magicBulletConn:Disconnect() end
    magicBulletConn = RunService.Heartbeat:Connect(function()
        if not _G.MagicBullet then return end
        t = getBestAimTarget("aimbot"); if not t then return end
        task.wait(0.12) -- Throttle - kasmasin
        dealDamage(t.player.Character, t.part, t.part.Position)
    end)
end
function disableMagicBullet()
    if magicBulletConn then magicBulletConn:Disconnect(); magicBulletConn = nil end
end

-- Hitbox
hitboxConn = nil
enableHitbox = function()
    if hitboxConn then hitboxConn:Disconnect() end
    hitboxConn = RunService.Heartbeat:Connect(function()
        if not _G.HitboxEnabled then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                hrp = p.Character:FindFirstChild("HumanoidRootPart")
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
            hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then pcall(function() hrp.Size = Vector3.new(2,2,1); hrp.Transparency = 1 end) end
        end
    end
end

-- Fake Lag
fakeLagConn = nil
function enableFakeLag()
    if fakeLagConn then fakeLagConn:Disconnect() end
    fakeLagConn = RunService.Heartbeat:Connect(function()
        if not _G.FakeLag then return end
        task.wait(_G.FakeLagInterval)
    end)
end
function disableFakeLag()
    if fakeLagConn then fakeLagConn:Disconnect(); fakeLagConn = nil end
end


-- --- Instant Respawn ---
instantRespawnConn = nil
function enableInstantRespawn()
    if instantRespawnConn then instantRespawnConn:Disconnect() end
    instantRespawnConn = LocalPlayer.CharacterAdded:Connect(function(char)
        if not _G.InstantRespawn then return end
        task.wait(0.05)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = hum.MaxHealth end
    end)
    -- Hemen de uygula
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Died:Connect(function()
                if not _G.InstantRespawn then return end
                task.wait(0.05)
                pcall(function() LocalPlayer:LoadCharacter() end)
            end)
        end
    end
end
function disableInstantRespawn()
    if instantRespawnConn then instantRespawnConn:Disconnect(); instantRespawnConn = nil end
end

-- --- No Skybox ---
origSkybox = nil
function enableNoSkybox()
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky then origSkybox = sky; sky.Parent = nil end
    pcall(function()
        Lighting.FogStart = 0; Lighting.FogEnd = 1e9
        Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
    end)
end
function disableNoSkybox()
    if origSkybox then origSkybox.Parent = Lighting; origSkybox = nil end
end

-- --- Rainbow Mode (Visual) ---
rainbowModeConn = nil
rainbowModeHue = 0
function enableRainbowMode()
    if rainbowModeConn then rainbowModeConn:Disconnect() end
    rainbowModeConn = RunService.RenderStepped:Connect(function()
        if not _G.RainbowMode then return end
        rainbowModeHue = (rainbowModeHue + 0.003) % 1
        local col = hsvToColor(rainbowModeHue, 1, 1)
        -- Tum ESP renklerini degistir
        _G.ESPEnemyR  = math.floor(col.R*255)
        _G.ESPEnemyG  = math.floor(col.G*255)
        _G.ESPEnemyB  = math.floor(col.B*255)
    end)
end
function disableRainbowMode()
    if rainbowModeConn then rainbowModeConn:Disconnect(); rainbowModeConn = nil end
end

-- --- Player Glow ---
playerGlowCache = {}
function enablePlayerGlow()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if not playerGlowCache[p] then
                local hl = Instance.new("Highlight")
                hl.Adornee = p.Character
                hl.FillColor = Color3.fromRGB(_G.ESPEnemyR, _G.ESPEnemyG, _G.ESPEnemyB)
                hl.FillTransparency = 0.5
                hl.OutlineColor = Color3.fromRGB(_G.ESPEnemyR, _G.ESPEnemyG, _G.ESPEnemyB)
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = CoreGui
                playerGlowCache[p] = hl
            end
        end
    end
end
function disablePlayerGlow()
    for p, hl in pairs(playerGlowCache) do
        pcall(function() hl:Destroy() end)
    end
    playerGlowCache = {}
end

-- --- Instant Reload ---
instantReloadConn = nil
function enableInstantReload()
    if instantReloadConn then instantReloadConn:Disconnect() end
    instantReloadConn = RunService.Heartbeat:Connect(function()
        if not _G.InstantReload then return end
        local char = LocalPlayer.Character; if not char then return end
        local tool = char:FindFirstChildOfClass("Tool"); if not tool then return end
        -- Ammo doldur (genel)
        for _, v in ipairs(tool:GetDescendants()) do
            pcall(function()
                if v.Name == "Ammo" or v.Name == "ammo" or v.Name == "AMMO" then
                    if v:IsA("IntValue") or v:IsA("NumberValue") then
                        v.Value = 9999
                    end
                end
            end)
        end
    end)
end
function disableInstantReload()
    if instantReloadConn then instantReloadConn:Disconnect(); instantReloadConn = nil end
end

-- --- No Spread ---
noSpreadConn = nil
function enableNoSpread()
    if noSpreadConn then noSpreadConn:Disconnect() end
    noSpreadConn = RunService.RenderStepped:Connect(function()
        if not _G.NoSpread then return end
        char = LocalPlayer.Character; if not char then return end
        tool = char:FindFirstChildOfClass("Tool"); if not tool then return end
        -- Kamera'nin tam ileri yonune kilitle
        cf = Camera.CFrame
        Camera.CFrame = CFrame.new(cf.Position) *
            CFrame.Angles(0, math.atan2(-cf.LookVector.X, -cf.LookVector.Z), 0) *
            CFrame.Angles(math.asin(cf.LookVector.Y), 0, 0)
    end)
end
function disableNoSpread()
    if noSpreadConn then noSpreadConn:Disconnect(); noSpreadConn = nil end
end

-- --- Gorunmezlik (Server-side: herkese gorunmez) ---
invisibleConn = nil
invisibleHB = nil
function enableInvisible()
    local char = LocalPlayer.Character; if not char then return end
    -- Network ownership al - sunucu bize guvensin
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function() part:SetNetworkOwner(LocalPlayer) end)
        end
    end
    -- Tum parcalari seffaf yap (diger oyuncular da goremiyor)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") or part:IsA("SpecialMesh") then
            pcall(function()
                if part:IsA("BasePart") then
                    part.Transparency = 1
                    part.CastShadow = false
                elseif part:IsA("Decal") then
                    part.Transparency = 1
                end
            end)
        end
    end
    for _, acc in ipairs(char:GetChildren()) do
        if acc:IsA("Accessory") then
            pcall(function()
                for _, d in ipairs(acc:GetDescendants()) do
                    if d:IsA("BasePart") then d.Transparency = 1; d.CastShadow = false end
                    if d:IsA("Decal") or d:IsA("SpecialMesh") then d.Transparency = 1 end
                end
            end)
        end
    end
    -- Surekli seffaf tut (sunucu geri yazarsa)
    if invisibleHB then invisibleHB:Disconnect() end
    invisibleHB = RunService.Heartbeat:Connect(function()
        if not _G.Invisible then return end
        local c = LocalPlayer.Character; if not c then return end
        for _, part in ipairs(c:GetDescendants()) do
            pcall(function()
                if part:IsA("BasePart") and part.Transparency < 0.99 then
                    part.Transparency = 1; part.CastShadow = false
                elseif (part:IsA("Decal") or part:IsA("SpecialMesh")) and part.Transparency < 0.99 then
                    part.Transparency = 1
                end
            end)
        end
    end)
    if invisibleConn then invisibleConn:Disconnect() end
    invisibleConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
        if not _G.Invisible then return end
        task.wait(0.5); enableInvisible()
    end)
end
function disableInvisible()
    if invisibleConn then invisibleConn:Disconnect(); invisibleConn = nil end
    if invisibleHB then invisibleHB:Disconnect(); invisibleHB = nil end
    local char = LocalPlayer.Character; if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        pcall(function()
            if part:IsA("BasePart") then
                part.Transparency = 0; part.CastShadow = true
            elseif part:IsA("Decal") or part:IsA("SpecialMesh") then
                part.Transparency = 0
            end
        end)
    end
    local hrp2 = char:FindFirstChild("HumanoidRootPart")
    if hrp2 then pcall(function() hrp2.Transparency = 1 end) end
end

-- --- Anti-Aim ---
antiAimConn = nil
function enableAntiAim()
    if antiAimConn then antiAimConn:Disconnect() end
    antiAimConn = RunService.RenderStepped:Connect(function()
        if not _G.AntiAim then return end
        char = LocalPlayer.Character; if not char then return end
        hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        yawRad   = math.rad(_G.AntiAimYaw)
        pitchRad = math.rad(_G.AntiAimPitch)
        hrp.CFrame = hrp.CFrame * CFrame.Angles(pitchRad, yawRad, 0)
    end)
end
function disableAntiAim()
    if antiAimConn then antiAimConn:Disconnect(); antiAimConn = nil end
end

-- --- No Recoil ---
noRecoilConn = nil
function enableNoRecoil()
    if noRecoilConn then noRecoilConn:Disconnect() end
    noRecoilConn = RunService.RenderStepped:Connect(function()
        if not _G.NoRecoil then return end
        char = LocalPlayer.Character; if not char then return end
        tool = char:FindFirstChildOfClass("Tool"); if not tool then return end
        -- Camera recoil'i sifirla: up/down titremesini engelle
        cf = Camera.CFrame
        Camera.CFrame = CFrame.new(cf.Position) * CFrame.Angles(0, math.atan2(-cf.LookVector.X, -cf.LookVector.Z), 0) * CFrame.Angles(math.asin(cf.LookVector.Y), 0, 0)
    end)
end
function disableNoRecoil()
    if noRecoilConn then noRecoilConn:Disconnect(); noRecoilConn = nil end
end

-- --- No Animation ---
originalAnimTracks = {}
function enableNoAnimation()
    local char = LocalPlayer.Character; if not char then return end
    humanoid = char:FindFirstChildOfClass("Humanoid"); if not humanoid then return end
    animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            pcall(function()
                table.insert(originalAnimTracks, {track=track, speed=track.Speed})
                track:AdjustSpeed(0)
            end)
        end
    end
end
function disableNoAnimation()
    for _, data in ipairs(originalAnimTracks) do
        pcall(function() data.track:AdjustSpeed(data.speed) end)
    end
    originalAnimTracks = {}
end

-- --- Auto Clicker ---
autoClickConn = nil
lastClickTime = 0
function enableAutoClicker()
    if autoClickConn then autoClickConn:Disconnect() end
    autoClickConn = RunService.Heartbeat:Connect(function()
        if not _G.AutoClicker then return end
        now = tick()
        interval = 1 / math.max(_G.AutoClickerCPS, 1)
        if now - lastClickTime >= interval then
            lastClickTime = now
            pcall(function()
                local char = LocalPlayer.Character; if not char then return end
                tool = char:FindFirstChildOfClass("Tool"); if not tool then return end
                tool:Activate()
            end)
        end
    end)
end
function disableAutoClicker()
    if autoClickConn then autoClickConn:Disconnect(); autoClickConn = nil end
end

-- --- Spin Bot ---
spinBotConn = nil
function enableSpinBot()
    if spinBotConn then spinBotConn:Disconnect() end
    spinBotConn = RunService.RenderStepped:Connect(function()
        if not _G.SpinBot then return end
        char = LocalPlayer.Character; if not char then return end
        hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(_G.SpinBotSpeed), 0)
    end)
end
function disableSpinBot()
    if spinBotConn then spinBotConn:Disconnect(); spinBotConn = nil end
end

-- --- Custom Walk Animation ---
walkAnimTrack = nil
function applyCustomWalkAnim(on)
    local char = LocalPlayer.Character; if not char then return end
    humanoid = char:FindFirstChildOfClass("Humanoid"); if not humanoid then return end
    animator = humanoid:FindFirstChildOfClass("Animator"); if not animator then return end
    if on then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. _G.WalkAnimID
            walkAnimTrack = animator:LoadAnimation(anim)
            walkAnimTrack:Play()
        end)
    else
        pcall(function()
            if walkAnimTrack then walkAnimTrack:Stop(); walkAnimTrack = nil end
        end)
    end
end

-- --- Kill Feed ---
killFeedGui, killFeedEntries = nil, {}
function enableKillFeed()
    if killFeedGui then return end
    killFeedGui = makeScreenGui("SusanoKillFeed", 150)
    frame = Instance.new("Frame", killFeedGui)
    frame.Size = UDim2.new(0, 280, 0, 0); frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.Position = UDim2.new(1, -290, 0, 60); frame.BackgroundTransparency = 1; frame.Name = "KFFrame"
    Instance.new("UIListLayout", frame).Padding = UDim.new(0, 3)

    function addKillEntry(text)
        table.insert(killFeedEntries, text)
        local entry = Instance.new("Frame", frame)
        entry.Size = UDim2.new(1, 0, 0, 28); entry.BackgroundColor3 = Color3.fromRGB(15,15,15)
        entry.BackgroundTransparency = 0.25; entry.BorderSizePixel = 0; makeCorner(6, entry)
        local lbl = Instance.new("TextLabel", entry)
        lbl.Size = UDim2.new(1,-12,1,0); lbl.Position = UDim2.new(0,6,0,0)
        lbl.BackgroundTransparency = 1; lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(240,240,240); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        game:GetService("Debris"):AddItem(entry, 5)
        task.delay(5, function()
            pcall(function()
                TweenService:Create(entry, TweenInfo.new(0.5), {BackgroundTransparency=1}):Play()
                TweenService:Create(lbl, TweenInfo.new(0.5), {TextTransparency=1}):Play()
            end)
        end)
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Died:Connect(function()
                    if _G.KillFeed then
                        addKillEntry("[RIP] " .. p.Name .. " oldu")
                    end
                end)
            end
        end
        p.CharacterAdded:Connect(function(char)
            local hum = char:WaitForChild("Humanoid", 5)
            if hum then
                hum.Died:Connect(function()
                    if _G.KillFeed then
                        addKillEntry("[RIP] " .. p.Name .. " oldu")
                    end
                end)
            end
        end)
    end
    Players.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function(char)
            local hum = char:WaitForChild("Humanoid", 5)
            if hum then
                hum.Died:Connect(function()
                    if _G.KillFeed then addKillEntry("[RIP] " .. p.Name .. " oldu") end
                end)
            end
        end)
    end)
end
function disableKillFeed()
    if killFeedGui then killFeedGui:Destroy(); killFeedGui = nil; killFeedEntries = {} end
end

-- --- Game Sense Overlay ---
gameSenseGui, gameSenseConn = nil, nil
function enableGameSense()
    if gameSenseGui then return end
    gameSenseGui = makeScreenGui("SusanoGameSense", 150)
    frame = Instance.new("Frame", gameSenseGui)
    frame.Size = UDim2.new(0, 160, 0, 72); frame.Position = UDim2.new(1, -168, 0.5, -36)
    frame.BackgroundColor3 = Color3.fromRGB(10,10,10); frame.BackgroundTransparency = 0.25; frame.BorderSizePixel = 0
    makeCorner(8, frame)
    function mkRow(posY, label)
        local lbl = Instance.new("TextLabel", frame)
        lbl.Size = UDim2.new(1,-12,0,18); lbl.Position = UDim2.new(0,6,0,posY)
        lbl.BackgroundTransparency = 1; lbl.Text = label; lbl.TextColor3 = Color3.fromRGB(220,220,220)
        lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
        return lbl
    end
    fpsLbl    = mkRow(6,  "FPS: --")
    pingLbl   = mkRow(26, "Ping: --")
    countLbl  = mkRow(46, "Oyuncular: --")
    if gameSenseConn then gameSenseConn:Disconnect() end
    frameCount, lastTime = 0, tick()
    gameSenseConn = RunService.RenderStepped:Connect(function()
        if not _G.GameSense then return end
        frameCount = frameCount + 1
        now = tick()
        if now - lastTime >= 1 then
            fps = math.floor(frameCount / (now - lastTime))
            fpsLbl.Text = "FPS: " .. fps
            frameCount = 0; lastTime = now
        end
        ping = 0
        pcall(function() ping = Players:GetNetworkPing() * 1000 end)
        pingLbl.Text = "Ping: " .. math.floor(ping) .. "ms"
        countLbl.Text = "Oyuncular: " .. #Players:GetPlayers()
    end)
end
function disableGameSense()
    if gameSenseConn then gameSenseConn:Disconnect(); gameSenseConn = nil end
    if gameSenseGui then gameSenseGui:Destroy(); gameSenseGui = nil end
end

-- --- Anti-Screenshot ---
function setupAntiScreenshot()
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F12 or input.KeyCode == Enum.KeyCode.PrintScreen then
            if _G.AntiScreenshot and MainGui then
                MainGui.Enabled = false
                task.wait(0.1)
                MainGui.Enabled = true
            end
        end
    end)
end

-- --- HWID Spoofer ---
spoofedHWID = nil
function applyHWIDSpoof()
    if not _G.HWIDSpoofer then
        spoofedHWID = nil; return
    end
    -- Rastgele sahte HWID uret
    chars = "ABCDEF0123456789"
    fake = ""
    for i = 1, 32 do
        idx = math.random(1, #chars)
        fake = fake .. chars:sub(idx, idx)
    end
    spoofedHWID = fake
    HWID = fake
end

-- --- Panic Key ---
function setupPanicKey()
    UserInputService.InputBegan:Connect(function(input, gpe)
        if input.KeyCode == Enum.KeyCode.Delete then
            -- Her seyi kapat
            if MainGui then MainGui.Enabled = false end
            if fovGui  then fovGui:Destroy() end
            if crosshairGui then crosshairGui:Destroy() end
            if miniMapGui   then miniMapGui:Destroy()   end
            if killFeedGui  then killFeedGui:Destroy()  end
            if gameSenseGui then gameSenseGui:Destroy() end
            -- Tum aktif ozellikleri kapat
            _G.FlyEnabled = false;   disableFly()
            _G.NoClip     = false;   disableNoclip()
            _G.SpeedHack  = false;   disableSpeed()
            _G.Aimbot     = false;   _G.RageAimbot = false; disableRageAimbot()
            _G.SilentAim  = false;   disableSilentAim()
            _G.AntiAim    = false;   disableAntiAim()
            _G.SpinBot    = false;   disableSpinBot()
            _G.ESP        = false;   clearAllESP()
        end
    end)
end

-- Godmode
godmodeConn1, godmodeConn2 = nil, nil
enableGodmode = function()
    if godmodeConn1 then godmodeConn1:Disconnect() end
    if godmodeConn2 then godmodeConn2:Disconnect() end
    char = LocalPlayer.Character; if not char then return end
    hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
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
    char = LocalPlayer.Character
    if char then
        hum = char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum.MaxHealth = 100; hum.Health = 100 end) end
    end
end

-- Infinite Jump
ijConn = nil
enableInfiniteJump = function()
    if ijConn then ijConn:Disconnect() end
    ijConn = UserInputService.JumpRequest:Connect(function()
        if not _G.InfiniteJump then return end
        char = LocalPlayer.Character; if not char then return end
        hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end
disableInfiniteJump = function()
    if ijConn then ijConn:Disconnect(); ijConn = nil end
end

-- Long Jump
ljConn = nil
enableLongJump = function()
    if ljConn then ljConn:Disconnect() end
    ljConn = UserInputService.JumpRequest:Connect(function()
        if not _G.LongJump then return end
        char = LocalPlayer.Character; if not char then return end
        hrp = char:FindFirstChild("HumanoidRootPart")
        hum = char:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.FloorMaterial ~= Enum.Material.Air then
            bv = Instance.new("BodyVelocity")
            bv.Velocity = hrp.CFrame.LookVector * _G.LongJumpPower + Vector3.new(0, 30, 0)
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5); bv.P = 1e4; bv.Parent = hrp
            game:GetService("Debris"):AddItem(bv, 0.15)
        end
    end)
end
disableLongJump = function()
    if ljConn then ljConn:Disconnect(); ljConn = nil end
end

-- Bunny Hop
bhopConn, bhopActive = nil, false
enableBhop = function()
    if bhopActive then return end
    char = LocalPlayer.Character; if not char then return end
    hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
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
    char = LocalPlayer.Character
    if char then
        hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16; hum.JumpPower = 50 end
    end
end

-- SPEED HACK - BYPASS: WalkSpeed=16 goster, gercek hiz BodyVelocity
speedConn, speedActive = nil, false
originalSpeed = 16
speedBodyVelocity = nil

enableSpeed = function()
    if speedActive then return end
    char = LocalPlayer.Character; if not char then return end
    hum = char:FindFirstChildOfClass("Humanoid")
    hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    speedActive = true
    originalSpeed = hum.WalkSpeed

    -- BodyVelocity olustur (asil hareketi bu saglar)
    if speedBodyVelocity then speedBodyVelocity:Destroy() end
    speedBodyVelocity = Instance.new("BodyVelocity")
    speedBodyVelocity.MaxForce = Vector3.new(1e5, 0, 1e5) -- Y yok (gravity calissin)
    speedBodyVelocity.P = 5000
    speedBodyVelocity.Parent = hrp

    speedConn = RunService.RenderStepped:Connect(function()
        if not _G.SpeedHack or not char or not hum then
            speedActive = false
            if speedConn then speedConn:Disconnect() end
            return
        end
        char2 = LocalPlayer.Character; if not char2 then return end
        hum2 = char2:FindFirstChildOfClass("Humanoid")
        hrp2 = char2:FindFirstChild("HumanoidRootPart")
        if not hum2 or not hrp2 then return end

        -- BYPASS: AC'ye WalkSpeed=16 goster
        if _G.ACBypassSpeed then
            pcall(function() hum2.WalkSpeed = 16 end)
        end

        -- Gercek hizi BodyVelocity ile ver
        moveDir = hum2.MoveDirection
        if moveDir.Magnitude > 0 then
            realSpeed = originalSpeed * _G.SpeedMult
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
    char = LocalPlayer.Character
    if char then
        hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = originalSpeed end
    end
end

-- FLY HACK - BYPASS: Humanoid state'i AC'den gizle
flyConn, flying = nil, false
flyBodyVelocity, flyBodyGyro = nil, nil

enableFly = function()
    if flying then return end
    char = LocalPlayer.Character; if not char then return end
    hum = char:FindFirstChildOfClass("Humanoid")
    hrp = char:FindFirstChild("HumanoidRootPart")
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

        velocity = Vector3.zero
        ui = UserInputService
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
    char = LocalPlayer.Character
    if char then
        hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Landed) end
    end
end

-- Noclip
noclipConn, noclipActive = nil, false
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
    char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

-- Anti AFK
antiAfkConn = nil
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

-- Visual
origAmbient   = Lighting.Ambient
origBrightness= Lighting.Brightness
origFogEnd    = Lighting.FogEnd
origFogStart  = Lighting.FogStart
origCamFOV    = Camera.FieldOfView
origTimeOfDay = Lighting.TimeOfDay
origColorShift= Lighting.ColorShift_Top

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

thirdPersonConn = nil
enableThirdPerson = function()
    Camera.CameraType = Enum.CameraType.Scriptable
    if thirdPersonConn then thirdPersonConn:Disconnect() end
    thirdPersonConn = RunService.RenderStepped:Connect(function()
        if not _G.ThirdPerson then disableThirdPerson(); return end
        char = LocalPlayer.Character; if not char then return end
        hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        d = _G.ThirdPersonDist
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
function setupAutoRejoin()
    Players.PlayerRemoving:Connect(function(p)
        if p == LocalPlayer and _G.AutoRejoin then
            task.wait(3)
            pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end)
        end
    end)
end

-- Server Hop
function serverHop()
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
fpsBoostActive = false
hiddenObjects = {}
function enableFPSBoost()
    if fpsBoostActive then return end; fpsBoostActive = true
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or
           obj:IsA("Fire") or obj:IsA("Sparkles") then
            pcall(function() obj.Enabled = false; table.insert(hiddenObjects, obj) end)
        end
    end
    Lighting.GlobalShadows = false
end
function disableFPSBoost()
    fpsBoostActive = false
    for _, obj in ipairs(hiddenObjects) do pcall(function() obj.Enabled = true end) end
    hiddenObjects = {}
    Lighting.GlobalShadows = true
end

-- Chat Logger
chatLoggerConn, chatLoggerGui, chatLogScroll = nil, nil, nil

function enableChatLogger()
    if chatLoggerGui then return end
    chatLoggerGui = makeScreenGui("SusanoChatLog", 100)
    frame = Instance.new("Frame", chatLoggerGui)
    frame.Size = UDim2.new(0, 300, 0, 180)
    frame.Position = UDim2.new(0, 10, 1, -200)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    frame.BackgroundTransparency = 0.2; frame.BorderSizePixel = 0
    makeCorner(8, frame)

    title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 22)
    title.BackgroundColor3 = Color3.fromRGB(15, 15, 15); title.BackgroundTransparency = 0
    title.Text = "[CHAT] Chat Log - Susano"; title.TextColor3 = Color3.new(1,1,1)
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
        lbl = Instance.new("TextLabel", chatLogScroll)
        lbl.Size = UDim2.new(1, -4, 0, 16); lbl.BackgroundTransparency = 1
        lbl.Text = log:sub(1, 48); lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    end

    function addLog(playerName, message)
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
    function bindPlayerChat(p)
        if p == LocalPlayer then return end
        p.Chatted:Connect(function(msg) if _G.ChatLogger then addLog(p.Name, msg) end end)
    end
    for _, p in ipairs(Players:GetPlayers()) do bindPlayerChat(p) end
    chatLoggerConn = Players.PlayerAdded:Connect(function(p) bindPlayerChat(p) end)
end

function disableChatLogger()
    if chatLoggerConn then chatLoggerConn:Disconnect(); chatLoggerConn = nil end
    if chatLoggerGui then chatLoggerGui:Destroy(); chatLoggerGui = nil; chatLogScroll = nil end
end

-- MiniMap
miniMapGui, miniMapConn, miniMapDots = nil, nil, nil
function enableMiniMap()
    if miniMapGui then return end
    miniMapGui = makeScreenGui("SusanoMiniMap", 150); miniMapDots = {}
    size = 180
    frame = Instance.new("Frame", miniMapGui)
    frame.Size = UDim2.new(0, size, 0, size)
    frame.Position = UDim2.new(1, -size - 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    frame.BackgroundTransparency = 0.15; frame.BorderSizePixel = 0
    makeCorner(90, frame)
    brd = Instance.new("UIStroke", frame)
    brd.Color = Tc.Accent; brd.Thickness = 1.5; brd.Transparency = 0.5

    radarLabel = Instance.new("TextLabel", frame)
    radarLabel.Size = UDim2.new(1, 0, 0, 14); radarLabel.BackgroundTransparency = 1
    radarLabel.Text = "RADAR"; radarLabel.TextColor3 = Tc.Accent
    radarLabel.Font = Enum.Font.GothamBold; radarLabel.TextSize = 9

    centerDot = Instance.new("Frame", frame)
    centerDot.Size = UDim2.new(0, 8, 0, 8)
    centerDot.AnchorPoint = Vector2.new(0.5, 0.5); centerDot.Position = UDim2.new(0.5, 0, 0.5, 0)
    centerDot.BackgroundColor3 = Color3.new(1,1,1); centerDot.BorderSizePixel = 0
    makeCorner(4, centerDot)

    if miniMapConn then miniMapConn:Disconnect() end
    miniMapConn = RunService.RenderStepped:Connect(function()
        if not _G.MiniMap then return end
        myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        activePlayers = {}
        for _, p in ipairs(Players:GetPlayers()) do activePlayers[p] = true end
        for p, dot in pairs(miniMapDots) do
            if not activePlayers[p] then dot:Destroy(); miniMapDots[p] = nil end
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer or not p.Character then do end end
            hrp = p.Character:FindFirstChild("HumanoidRootPart"); if not hrp then do end end
            diff = hrp.Position - myHRP.Position
            range = 200
            nx = math.clamp(diff.X / range, -0.5, 0.5)
            nz = math.clamp(diff.Z / range, -0.5, 0.5)
            if not miniMapDots[p] then
                dot = Instance.new("Frame", frame)
                dot.Size = UDim2.new(0, 6, 0, 6)
                dot.AnchorPoint = Vector2.new(0.5, 0.5); dot.BorderSizePixel = 0
                makeCorner(3, dot)
                nameLabel = Instance.new("TextLabel", dot)
                nameLabel.Size = UDim2.new(0, 60, 0, 12)
                nameLabel.Position = UDim2.new(1, 2, 0, -2); nameLabel.BackgroundTransparency = 1
                nameLabel.Text = p.Name:sub(1, 7); nameLabel.TextColor3 = Color3.new(1,1,1)
                nameLabel.Font = Enum.Font.GothamBold; nameLabel.TextSize = 8
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                miniMapDots[p] = dot
            end
            friendly = p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team
            miniMapDots[p].BackgroundColor3 = friendly and Color3.fromRGB(80,180,255) or Color3.fromRGB(255,80,80)
            miniMapDots[p].Position = UDim2.new(0.5 + nx, 0, 0.5 + nz, 0)
        end
    end)
end
function disableMiniMap()
    if miniMapConn then miniMapConn:Disconnect(); miniMapConn = nil end
    if miniMapGui then miniMapGui:Destroy(); miniMapGui = nil; miniMapDots = nil end
end

-- ESP SISTEMI
espCache = {}
esp2DDrawings = {}
espTracerDrawings = {}

function clearESPDrawings(player)
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

function clearESPPlayer(player)
    if espCache[player] then
        if espCache[player].highlight then pcall(function() espCache[player].highlight:Destroy() end) end
        if espCache[player].billboard then pcall(function() espCache[player].billboard:Destroy() end) end
        if espCache[player].healthBillboard then pcall(function() espCache[player].healthBillboard:Destroy() end) end
        espCache[player] = nil
    end
    clearESPDrawings(player)
    clearSkeleton(player)
end

function clearAllESP()
    for player in pairs(espCache) do clearESPPlayer(player) end
    for player in pairs(esp2DDrawings) do clearESPDrawings(player) end
end

function buildESPForPlayer(player)
    if not _G.ESP or player == LocalPlayer or espCache[player] then return end
    char = player.Character; if not char then return end
    hrp = char:WaitForChild("HumanoidRootPart", 5); if not hrp then return end
    hum = char:FindFirstChildOfClass("Humanoid")

    -- 3D Highlight
    hl = Instance.new("Highlight")
    hl.Adornee = char; hl.FillTransparency = 0.75
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled = false; hl.Parent = CoreGui

    -- Name/Distance billboard
    bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(6, 0, 3, 0); bb.AlwaysOnTop = true
    bb.StudsOffset = Vector3.new(0, 4, 0); bb.Adornee = hrp
    bb.Enabled = false; bb.Parent = CoreGui

    function makeBBLabel(posY, sizeY, color, fontSize)
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
    idLabel   = makeBBLabel(0,   0.3, Color3.fromRGB(160, 160, 255), 12)
    nameLabel = makeBBLabel(0.3, 0.4, Color3.fromRGB(_G.ESPNameR, _G.ESPNameG, _G.ESPNameB), 16)
    distLabel = makeBBLabel(0.7, 0.3, Color3.fromRGB(255, 220, 80), 12)

    -- Health bar billboard
    hbBB = Instance.new("BillboardGui")
    hbBB.Size = UDim2.new(0.4, 0, 2, 0); hbBB.AlwaysOnTop = true
    hbBB.StudsOffset = Vector3.new(-1.8, 2, 0); hbBB.Adornee = hrp
    hbBB.Enabled = false; hbBB.Parent = CoreGui
    hbBG = Instance.new("Frame", hbBB)
    hbBG.Size = UDim2.new(0, 4, 1, 0); hbBG.BackgroundColor3 = Color3.fromRGB(20, 20, 20); hbBG.BorderSizePixel = 0
    hbFill = Instance.new("Frame", hbBG)
    hbFill.Size = UDim2.new(1, 0, 1, 0); hbFill.BackgroundColor3 = Color3.fromRGB(80, 255, 120); hbFill.BorderSizePixel = 0

    espCache[player] = {
        highlight = hl, billboard = bb, healthBillboard = hbBB,
        hbFill = hbFill, idLabel = idLabel, nameLabel = nameLabel, distLabel = distLabel,
        hrp = hrp, hum = hum
    }

    -- 2D Drawing
    e = {}
    e.box = Drawing.new("Square"); e.box.Visible = false; e.box.Thickness = 1.5; e.box.Filled = false
    e.name = Drawing.new("Text"); e.name.Visible = false; e.name.Size = 14; e.name.Font = 2; e.name.Center = true
    e.dist = Drawing.new("Text"); e.dist.Visible = false; e.dist.Size = 12; e.dist.Font = 2; e.dist.Center = true; e.dist.Color = Color3.fromRGB(255, 220, 80)
    e.idtxt = Drawing.new("Text"); e.idtxt.Visible = false; e.idtxt.Size = 11; e.idtxt.Font = 2; e.idtxt.Center = true; e.idtxt.Color = Color3.fromRGB(160, 160, 255)
    e.hbg = Drawing.new("Square"); e.hbg.Visible = false; e.hbg.Filled = true; e.hbg.Color = Color3.fromRGB(20, 20, 20)
    e.hbf = Drawing.new("Square"); e.hbf.Visible = false; e.hbf.Filled = true
    esp2DDrawings[player] = e

    tracer = Drawing.new("Line")
    tracer.Visible = false; tracer.Thickness = _G.TracerThick; tracer.Transparency = 0.3
    espTracerDrawings[player] = tracer
end

function updateESP()
    if not _G.ESP then clearAllESP(); return end
    myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    colorEnemy  = Color3.fromRGB(_G.ESPEnemyR,  _G.ESPEnemyG,  _G.ESPEnemyB)
    colorFriend = Color3.fromRGB(_G.ESPFriendR, _G.ESPFriendG, _G.ESPFriendB)
    colorVis    = Color3.fromRGB(_G.ESPVisR,    _G.ESPVisG,    _G.ESPVisB)
    colorName   = Color3.fromRGB(_G.ESPNameR,   _G.ESPNameG,   _G.ESPNameB)

    -- Ayrilan oyunculari temizle
    activePlayers = {}
    for _, p in ipairs(Players:GetPlayers()) do activePlayers[p] = true end
    for p in pairs(espCache) do if not activePlayers[p] then clearESPPlayer(p) end end

    for player, cache in pairs(espCache) do
        if not (player and player.Parent and cache.hrp and cache.hrp.Parent) then
            clearESPPlayer(player); do end
        end
        char = player.Character
        hum = char and char:FindFirstChildOfClass("Humanoid")
        hrp = cache.hrp
        dist = (hrp.Position - myHRP.Position).Magnitude
        friendly = player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team
        show = (friendly and _G.ShowFriendly) or (not friendly and _G.TeamCheck)
        if not (show and hum and hum.Health > 0) then show = false end

        visible = false
        if _G.WallCheck and show and not friendly then visible = isPlayerVisible(player) end
        col = friendly and colorFriend or (_G.WallCheck and (visible and colorVis or colorEnemy) or colorEnemy)

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
                pct = hum.Health / hum.MaxHealth
                cache.hbFill.Size = UDim2.new(1, 0, pct, 0)
                cache.hbFill.Position = UDim2.new(0, 0, 1 - pct, 0)
                cache.hbFill.BackgroundColor3 = pct > 0.6 and Color3.fromRGB(80, 255, 120) or
                    (pct > 0.3 and Color3.fromRGB(255, 220, 80) or Color3.fromRGB(255, 80, 80))
            end
        end

        -- 2D Box
        e = esp2DDrawings[player]
        if e then
            if _G.ESPBox2D and show then
                sp, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    head = char:FindFirstChild("Head")
                    if head then
                        sh = Camera:WorldToViewportPoint(head.Position)
                        boxH = math.abs(sh.Y - sp.Y) * 2.3
                        boxW = boxH * 0.55
                        topLeft = Vector2.new(sp.X - boxW/2, sh.Y - boxH/2)
                        nameColor = Color3.fromRGB(_G.ESPNameR, _G.ESPNameG, _G.ESPNameB)
                        distColor = Color3.fromRGB(_G.ESPDistColorR, _G.ESPDistColorG, _G.ESPDistColorB)
                        idColor = Color3.fromRGB(_G.ESPIDColorR, _G.ESPIDColorG, _G.ESPIDColorB)
                        if dist > _G.ESPMaxDist then
                            -- Too far, hide all
                            e.box.Visible = false; e.name.Visible = false
                            e.dist.Visible = false; e.idtxt.Visible = false
                            e.hbg.Visible = false; e.hbf.Visible = false
                        else
                            -- Box style
                            if _G.ESPCornerMode then
                                e.box.Visible = false
                                cl = _G.ESPCornerLen
                                if not e.c1 then
                                    for i = 1, 8 do
                                        l = Drawing.new("Line")
                                        l.Thickness = 1.5; l.Visible = false; l.Color = col
                                        e["c"..i] = l
                                    end
                                end
                                tl = topLeft
                                tr = Vector2.new(topLeft.X+boxW, topLeft.Y)
                                bl = Vector2.new(topLeft.X, topLeft.Y+boxH)
                                br = Vector2.new(topLeft.X+boxW, topLeft.Y+boxH)
                                e.c1.From=tl; e.c1.To=tl+Vector2.new(cl,0); e.c1.Visible=true; e.c1.Color=col; e.c1.Thickness=_G.ESPCornerThick
                                e.c2.From=tl; e.c2.To=tl+Vector2.new(0,cl); e.c2.Visible=true; e.c2.Color=col
                                e.c3.From=tr; e.c3.To=tr-Vector2.new(cl,0); e.c3.Visible=true; e.c3.Color=col
                                e.c4.From=tr; e.c4.To=tr+Vector2.new(0,cl); e.c4.Visible=true; e.c4.Color=col
                                e.c5.From=bl; e.c5.To=bl+Vector2.new(cl,0); e.c5.Visible=true; e.c5.Color=col
                                e.c6.From=bl; e.c6.To=bl-Vector2.new(0,cl); e.c6.Visible=true; e.c6.Color=col
                                e.c7.From=br; e.c7.To=br-Vector2.new(cl,0); e.c7.Visible=true; e.c7.Color=col
                                e.c8.From=br; e.c8.To=br-Vector2.new(0,cl); e.c8.Visible=true; e.c8.Color=col
                            else
                                e.box.Visible = true
                                e.box.Position = topLeft; e.box.Size = Vector2.new(boxW, boxH); e.box.Color = col
                                for ci = 1, 8 do if e["c"..ci] then e["c"..ci].Visible = false end end
                            end
                            -- Labels
                            if _G.ShowNames then e.name.Visible=true; e.name.Position=Vector2.new(sp.X,sh.Y-boxH/2-18); e.name.Text=player.Name; e.name.Color=nameColor else e.name.Visible=false end
                            if _G.ShowDistance then e.dist.Visible=true; e.dist.Position=Vector2.new(sp.X,sh.Y+boxH/2+4); e.dist.Text=math.floor(dist).."m"; e.dist.Color=distColor else e.dist.Visible=false end
                            if _G.ShowID then e.idtxt.Visible=true; e.idtxt.Position=Vector2.new(sp.X,sh.Y-boxH/2-32); e.idtxt.Text="ID:"..player.UserId; e.idtxt.Color=idColor else e.idtxt.Visible=false end
                            -- Health bar
                            if _G.ShowHealthBar and hum and hum.Health > 0 then
                                pct = hum.Health / hum.MaxHealth
                                e.hbg.Visible=true; e.hbg.Position=Vector2.new(topLeft.X-7,topLeft.Y); e.hbg.Size=Vector2.new(3,boxH)
                                e.hbf.Visible=true; e.hbf.Position=Vector2.new(topLeft.X-7,topLeft.Y+boxH*(1-pct)); e.hbf.Size=Vector2.new(3,boxH*pct)
                                e.hbf.Color=pct>0.6 and Color3.fromRGB(80,255,120) or (pct>0.3 and Color3.fromRGB(255,220,80) or Color3.fromRGB(255,80,80))
                            else
                                e.hbg.Visible=false; e.hbf.Visible=false
                            end
                        end
                    else
                        -- No head
                        e.box.Visible=false; e.name.Visible=false; e.dist.Visible=false
                        e.idtxt.Visible=false; e.hbg.Visible=false; e.hbf.Visible=false
                    end
                else
                    -- Not on screen
                    e.box.Visible=false; e.name.Visible=false; e.dist.Visible=false
                    e.idtxt.Visible=false; e.hbg.Visible=false; e.hbf.Visible=false
                end
            else
                -- Not E2D
                e.box.Visible=false; e.name.Visible=false; e.dist.Visible=false
                e.idtxt.Visible=false; e.hbg.Visible=false; e.hbf.Visible=false
            end
        end

        -- Tracer
        tracer = espTracerDrawings[player]
        if tracer then
            tracer.Thickness = _G.TracerThick
            if _G.ShowTracer and show then
                sp, onScreen = Camera:WorldToViewportPoint(hrp.Position)
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
function bindESPToPlayer(player)
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
function buildConfigData()
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
        LongJump=_G.LongJump,LongJumpPower=_G.LongJumpPower,
        GravityHack=_G.GravityHack,GravityValue=_G.GravityValue,TeleportCursor=_G.TeleportCursor,
        KillAura=_G.KillAura,KillAuraRange=_G.KillAuraRange,AntiAFK=_G.AntiAFK,
        NameSpoof=_G.NameSpoof,SpoofedName=_G.SpoofedName,
        FullBright=_G.FullBright,NoFog=_G.NoFog,FOVChanger=_G.FOVChanger,FOVChangerVal=_G.FOVChangerVal,
        ThirdPerson=_G.ThirdPerson,ThirdPersonDist=_G.ThirdPersonDist,TimeChanger=_G.TimeChanger,
        TimeOfDay=_G.TimeOfDay,WorldColor=_G.WorldColor,WorldR=_G.WorldR,WorldG=_G.WorldG,WorldB=_G.WorldB,
        _THEME = currentThemeIndex, _LANG = LANG,
        ESPMaxDist=_G.ESPMaxDist, ESPBoxStyle=_G.ESPBoxStyle, ESPCornerLen=_G.ESPCornerLen,
        SkeletonThick=_G.SkeletonThick, NoSpread=_G.NoSpread, Invisible=_G.Invisible,
        AimMaxDist=_G.AimMaxDist, RageMaxDist=_G.RageMaxDist,
        TriggerMaxDist=_G.TriggerMaxDist, SilentMaxDist=_G.SilentMaxDist,
        ESPDistColorR=_G.ESPDistColorR, ESPDistColorG=_G.ESPDistColorG, ESPDistColorB=_G.ESPDistColorB,
        ESPIDColorR=_G.ESPIDColorR, ESPIDColorG=_G.ESPIDColorG, ESPIDColorB=_G.ESPIDColorB,
    }
end

function applyConfigData(data)
    for k, v in pairs(data) do
        if k == "_THEME" then currentThemeIndex = v; Tc = makeThemeColors()
        elseif k == "_LANG" then LANG = v
        else _G[k] = v end
    end
end

function listLocalConfigs()
    local result = {}
    for _, f in ipairs(safeList(CFG_FOLDER)) do
        local name = f:match("([^/\\]+)%.json$")
        if name then table.insert(result, name) end
    end
    return result
end

function saveLocalConfig(name)
    safeMkDir(CFG_FOLDER)
    local ok, json = pcall(function() return HttpService:JSONEncode(buildConfigData()) end)
    if not ok then return false end
    safeWrite(CFG_FOLDER .. "/" .. name .. ".json", json)
    return true
end

function loadLocalConfig(name)
    local ok, content = safeRead(CFG_FOLDER .. "/" .. name .. ".json")
    if not ok or not content then return false end
    ok2, data = pcall(function() return HttpService:JSONDecode(content) end)
    if not ok2 then return false end
    applyConfigData(data)
    return true
end

function deleteLocalConfig(name)
    safeDel(CFG_FOLDER .. "/" .. name .. ".json")
end

-- ================================================================
-- KEYBINDS SISTEMI
-- Chat acikken / TextBox odaklanmisken calisma
-- ================================================================
KeyBinds = {
    -- {setting, enableFn, disableFn, defaultKey, label}
    {s="FlyEnabled",  en=nil, di=nil, key=Enum.KeyCode.F,  lbl="Fly"},
    {s="NoClip",      en=nil, di=nil, key=Enum.KeyCode.X,  lbl="Noclip"},
    {s="SpeedHack",   en=nil, di=nil, key=Enum.KeyCode.V,  lbl="Speed Hack"},
    {s="BunnyHop",    en=nil, di=nil, key=Enum.KeyCode.B,  lbl="Bunny Hop"},
    {s="Aimbot",      en=nil, di=nil, key=Enum.KeyCode.Z,  lbl="Aimbot",  toggle=true},
    {s="ESP",         en=nil, di=nil, key=Enum.KeyCode.K,  lbl="ESP"},
    {s="TeleportCursor",en=nil,di=nil,key=Enum.KeyCode.T,  lbl="Cursor TP"},
    {s="Godmode",     en=nil, di=nil, key=Enum.KeyCode.G,  lbl="Godmode"},
    {s="InfiniteJump",en=nil, di=nil, key=Enum.KeyCode.J,  lbl="Inf Jump"},

}

-- Fonksiyon referanslarini doldur (createMenu'den sonra)
function setupKeybindFunctions()
    KeyBinds[1].en = enableFly;       KeyBinds[1].di = disableFly
    KeyBinds[2].en = enableNoclip;    KeyBinds[2].di = disableNoclip
    KeyBinds[3].en = enableSpeed;     KeyBinds[3].di = disableSpeed
    KeyBinds[4].en = enableBhop;      KeyBinds[4].di = disableBhop
    KeyBinds[5].en = nil;             KeyBinds[5].di = nil  -- Aimbot: sadece toggle
    KeyBinds[6].en = function() _G.ESP=true end;  KeyBinds[6].di = function() _G.ESP=false; clearAllESP() end
    KeyBinds[7].en = nil;             KeyBinds[7].di = nil  -- Cursor TP toggle only
    KeyBinds[8].en = enableGodmode;   KeyBinds[8].di = disableGodmode
    KeyBinds[9].en = enableInfiniteJump; KeyBinds[9].di = disableInfiniteJump
    -- Index 10 kaldir (duplikat noclip)
end

-- Kullanici chat/textbox yaz?yor mu?
function isTyping()
    local focus = UserInputService:GetFocusedTextBox()
    return focus ~= nil
end

-- Keybind listener
function startKeybindListener()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        -- gameProcessed = Roblox UI bir seyi yakaladi (chat gibi)
        if gameProcessed then return end
        -- Textbox odaklanmis mi?
        if isTyping() then return end
        -- F5 zaten ayr? kullaniliyor, atla
        if input.KeyCode == Enum.KeyCode.F5 then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        
        for _, kb in ipairs(KeyBinds) do
            if kb and kb.key == input.KeyCode then
                local newVal = not _G[kb.s]
                _G[kb.s] = newVal
                -- Fonksiyon varsa cagir (enable/disable)
                task.spawn(function()
                    if newVal then
                        if kb.en then pcall(kb.en) end
                    else
                        if kb.di then pcall(kb.di) end
                    end
                end)
                -- Kisa ekran bildirimi goster
                task.spawn(function()
                    local notifGui = makeScreenGui("SusanoKeybindNotif", 9997)
                    local notif = Instance.new("Frame", notifGui)
                    notif.Size = UDim2.new(0, 200, 0, 36)
                    notif.Position = UDim2.new(0.5, -100, 0, 60)
                    notif.BackgroundColor3 = _G[kb.s] and Color3.fromRGB(20,40,20) or Color3.fromRGB(40,20,20)
                    notif.BackgroundTransparency = 0.15
                    notif.BorderSizePixel = 0
                    local nc = Instance.new("UICorner", notif); nc.CornerRadius = UDim.new(0,8)
                    local nl = Instance.new("TextLabel", notif)
                    nl.Size = UDim2.new(1,0,1,0); nl.BackgroundTransparency = 1
                    nl.Text = kb.lbl .. ": " .. (_G[kb.s] and "ACIK" or "KAPALI")
                    nl.TextColor3 = _G[kb.s] and Color3.fromRGB(80,255,120) or Color3.fromRGB(255,80,80)
                    nl.Font = Enum.Font.GothamBold; nl.TextSize = 14
                    TweenService:Create(notif, TweenInfo.new(0.3), {BackgroundTransparency=0.15}):Play()
                    task.wait(1.2)
                    TweenService:Create(notif, TweenInfo.new(0.3), {BackgroundTransparency=1}):Play()
                    TweenService:Create(nl,    TweenInfo.new(0.3), {TextTransparency=1}):Play()
                    task.wait(0.35)
                    notifGui:Destroy()
                end)
                break
            end
        end
    end)
end

-- KEYBIND AYAR MEN?S? builder fonksiyonu
KB_KEY_NAMES = {
    [Enum.KeyCode.F]="F",[Enum.KeyCode.X]="X",[Enum.KeyCode.V]="V",
    [Enum.KeyCode.B]="B",[Enum.KeyCode.Z]="Z",[Enum.KeyCode.K]="K",
    [Enum.KeyCode.T]="T",[Enum.KeyCode.G]="G",[Enum.KeyCode.J]="J",
    [Enum.KeyCode.N]="N",[Enum.KeyCode.Y]="Y",[Enum.KeyCode.H]="H",
    [Enum.KeyCode.U]="U",[Enum.KeyCode.I]="I",[Enum.KeyCode.O]="O",
    [Enum.KeyCode.P]="P",[Enum.KeyCode.L]="L",[Enum.KeyCode.M]="M",
    [Enum.KeyCode.C]="C",[Enum.KeyCode.Q]="Q",[Enum.KeyCode.E]="E",
    [Enum.KeyCode.R]="R",
    [Enum.KeyCode.F1]="F1",[Enum.KeyCode.F2]="F2",[Enum.KeyCode.F3]="F3",
    [Enum.KeyCode.F4]="F4",[Enum.KeyCode.F6]="F6",[Enum.KeyCode.F7]="F7",
    [Enum.KeyCode.F8]="F8",[Enum.KeyCode.F9]="F9",[Enum.KeyCode.F10]="F10",
}
function getKeyName(keyCode)
    return KB_KEY_NAMES[keyCode] or tostring(keyCode):match("KeyCode%.(.+)") or "?"
end

function buildKeybindsTab(parent)
    local sc = makeScrollFrame(parent); local y = 10

    -- Bilgi banner
    local infoF = Instance.new("Frame", sc)
    infoF.Size = UDim2.new(1,-28,0,44); infoF.Position = UDim2.new(0,14,0,y)
    infoF.BackgroundColor3 = Color3.fromRGB(20,30,20); makeCorner(8, infoF)
    local infoL = Instance.new("TextLabel", infoF)
    infoL.Size = UDim2.new(1,-16,1,0); infoL.Position = UDim2.new(0,8,0,0); infoL.BackgroundTransparency=1
    infoL.Text = "Tusa tikla, sonra yeni tusa bas. Chat yazarken calistirmaz."
    infoL.TextColor3 = Color3.fromRGB(100,220,100); infoL.Font = Enum.Font.GothamMedium; infoL.TextSize = 12; infoL.TextWrapped = true; infoL.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 52

    local listeningIdx = nil  -- Hangi satir dinliyor

    local keyBtnRefs = {}

    local listenConn
    local function startListening(idx, keyBtn)
        listeningIdx = idx
        keyBtn.Text = "[ Tusa bas... ]"
        keyBtn.BackgroundColor3 = Color3.fromRGB(60,60,20)
        if listenConn then listenConn:Disconnect() end
        listenConn = UserInputService.InputBegan:Connect(function(input, gpe)
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            if input.KeyCode == Enum.KeyCode.Escape then
                -- Iptal
                keyBtn.Text = getKeyName(KeyBinds[idx].key)
                keyBtn.BackgroundColor3 = Tc.AccentFaint
                listeningIdx = nil
                listenConn:Disconnect()
                return
            end
            KeyBinds[idx].key = input.KeyCode
            keyBtn.Text = getKeyName(input.KeyCode)
            keyBtn.BackgroundColor3 = Tc.AccentFaint
            listeningIdx = nil
            listenConn:Disconnect()
        end)
    end

    for i, kb in ipairs(KeyBinds) do
        if not kb then do end end
        row = Instance.new("Frame", sc)
        row.Size = UDim2.new(1,-28,0,44); row.Position = UDim2.new(0,14,0,y)
        row.BackgroundColor3 = Tc.Card; makeCorner(8, row)

        -- Toggle pill
        pH,pW = 24,50
        pill = Instance.new("Frame", row)
        pill.Size = UDim2.new(0,pW,0,pH); pill.Position = UDim2.new(0,10,0.5,-pH/2)
        pill.BackgroundColor3 = _G[kb.s] and Tc.OnBG or Tc.OffBG; makeCorner(pH, pill)
        knob = Instance.new("Frame", pill)
        knob.Size = UDim2.new(0,pH-6,0,pH-6)
        knob.Position = UDim2.new(_G[kb.s] and 1 or 0, _G[kb.s] and -(pH-3) or 3, 0.5, -(pH-6)/2)
        knob.BackgroundColor3 = _G[kb.s] and Tc.TitleBar or Tc.AccentDim; makeCorner(100, knob)
        toggleHit = Instance.new("TextButton", row)
        toggleHit.Size = UDim2.new(0,pW+10,1,0); toggleHit.Position = UDim2.new(0,5,0,0)
        toggleHit.BackgroundTransparency=1; toggleHit.Text=""
        toggleHit.MouseButton1Click:Connect(function()
            _G[kb.s] = not _G[kb.s]
            TweenService:Create(pill,TweenInfo.new(0.18),{BackgroundColor3=_G[kb.s] and Tc.OnBG or Tc.OffBG}):Play()
            TweenService:Create(knob,TweenInfo.new(0.18),{Position=UDim2.new(_G[kb.s] and 1 or 0,_G[kb.s] and -(pH-3) or 3,0.5,-(pH-6)/2)}):Play()
        end)

        -- Label
        lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.45,0,1,0); lbl.Position = UDim2.new(0,68,0,0)
        lbl.BackgroundTransparency=1; lbl.Text=kb.lbl
        lbl.TextColor3=Tc.Text; lbl.Font=Enum.Font.GothamMedium; lbl.TextSize=14; lbl.TextXAlignment=Enum.TextXAlignment.Left

        -- Key butonu
        keyBtn = Instance.new("TextButton", row)
        keyBtn.Size = UDim2.new(0,72,0,30); keyBtn.Position = UDim2.new(1,-82,0.5,-15)
        keyBtn.BackgroundColor3 = Tc.AccentFaint; keyBtn.TextColor3 = Tc.Text
        keyBtn.Font = Enum.Font.GothamBold; keyBtn.TextSize = 14; keyBtn.Text = getKeyName(kb.key)
        makeCorner(7, keyBtn)
        keyBtn.MouseEnter:Connect(function() TweenService:Create(keyBtn,TweenInfo.new(0.1),{BackgroundColor3=Tc.CardHover}):Play() end)
        keyBtn.MouseLeave:Connect(function() if listeningIdx ~= i then TweenService:Create(keyBtn,TweenInfo.new(0.1),{BackgroundColor3=Tc.AccentFaint}):Play() end end)
        keyBtn.MouseButton1Click:Connect(function()
            startListening(i, keyBtn)
        end)
        keyBtnRefs[i] = keyBtn

        -- Pill guncelleme loop
        RunService.Heartbeat:Connect(function()
            if pill and pill.Parent then
                local isOn = _G[kb.s]
                pill.BackgroundColor3 = isOn and Tc.OnBG or Tc.OffBG
                knob.Position = UDim2.new(isOn and 1 or 0, isOn and -(pH-3) or 3, 0.5, -(pH-6)/2)
            end
        end)

        y = y + 52
    end
end

-- TAB BUILDER'LAR
tabBuilders = {}

tabBuilders["ESP"] = function(parent)
    local sc = makeScrollFrame(parent); local y = 10
    y = buildSection(sc, "ESP Ana Ayarlar", y)
    y = buildToggle(sc, "ESP Aktif", "ESP", y, function(v) if not v then clearAllESP() end end)
    y = buildToggle(sc, "3D Highlight", "ESPBox3D", y)
    y = buildToggle(sc, "2D Box",       "ESPBox2D", y)
    y = buildToggle(sc, "Skeleton",     "SkeletonESP", y)
    y = buildToggle(sc, "Isim",         "ShowNames",   y)
    y = buildToggle(sc, "Mesafe",       "ShowDistance",y)
    y = buildToggle(sc, "Can Cubugu",   "ShowHealthBar",y)
    y = buildToggle(sc, "ID",           "ShowID",      y)
    y = buildToggle(sc, "Tracer",       "ShowTracer",  y)
    y = buildToggle(sc, "Takim Kontrolu","TeamCheck",  y)
    y = buildToggle(sc, "Dostlari Goster","ShowFriendly",y)
    y = buildToggle(sc, "Duvar Kontrolu","WallCheck",  y)
    y = buildSection(sc, "Detayli Ayarlar (ESP Builder)", y+4)
    -- Bilgi karti
    local ebNote = Instance.new("Frame", sc)
    ebNote.Size = UDim2.new(1,-28,0,44); ebNote.Position = UDim2.new(0,14,0,y)
    ebNote.BackgroundColor3 = Color3.fromRGB(15,25,15); makeCorner(8, ebNote)
    local ebNL = Instance.new("TextLabel", ebNote)
    ebNL.Size = UDim2.new(1,-16,1,0); ebNL.Position = UDim2.new(0,8,0,0); ebNL.BackgroundTransparency=1
    ebNL.Text = "Renk, kutu stili ve tum esp ayarlari icin ESP Builder penceresini kullanin"
    ebNL.TextColor3 = Color3.fromRGB(100,220,100); ebNL.Font = Enum.Font.Gotham; ebNL.TextSize = 11
    ebNL.TextWrapped = true; ebNL.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 52
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
    -- Kill Feed (ESP'ye tasindi)
    -- ESP Max Distance
    y = buildSection(sc, "Gorunum Mesafesi", y+4)
    y = buildSlider(sc, "Max Mesafe", "ESPMaxDist", y, 50, 2000)
    -- Box stili
    y = buildSection(sc, "Kutu Stili", y+4)
    y = buildDropdown(sc, "Box Stili", {"Full","Corner"}, function() return _G.ESPBoxStyle end, function(v) _G.ESPBoxStyle=v end, y)
    y = buildSlider(sc, "Corner Uzunluk", "ESPCornerLen", y, 4, 30)
    -- Skeleton kalinlik
    y = buildSection(sc, "Skeleton", y+4)
    y = buildSlider(sc, "Iskelet Kalinligi", "SkeletonThick", y, 0.5, 6, "%.1f")
    -- Etiket renkleri
    y = buildSection(sc, "Etiket Renkleri", y+4)
    y = buildColorPreview(sc, "ESPNameR","ESPNameG","ESPNameB", y)
    y = buildSlider(sc, "Isim R", "ESPNameR", y, 0, 255)
    y = buildSlider(sc, "Isim G", "ESPNameG", y, 0, 255)
    y = buildSlider(sc, "Isim B", "ESPNameB", y, 0, 255)
    y = buildColorPreview(sc, "ESPDistColorR","ESPDistColorG","ESPDistColorB", y)
    y = buildSlider(sc, "Mesafe R", "ESPDistColorR", y, 0, 255)
    y = buildSlider(sc, "Mesafe G", "ESPDistColorG", y, 0, 255)
    y = buildSlider(sc, "Mesafe B", "ESPDistColorB", y, 0, 255)
    y = buildColorPreview(sc, "ESPIDColorR","ESPIDColorG","ESPIDColorB", y)
    y = buildSlider(sc, "ID R", "ESPIDColorR", y, 0, 255)
    y = buildSlider(sc, "ID G", "ESPIDColorG", y, 0, 255)
    y = buildSlider(sc, "ID B", "ESPIDColorB", y, 0, 255)
    -- ESP Builder butonu
    y = buildSection(sc, "ESP Builder", y+4)
    local ebBtn; ebBtn, y = buildButton(sc, "ESP Builder Ac/Kapat", y, Tc.AccentFaint, Tc.Text)
    ebBtn.MouseButton1Click:Connect(function() openESPBuilder() end)
end

tabBuilders["AIMBOT"] = function(parent)
    local sc = makeScrollFrame(parent); local y = 10
    -- AIMBOT
    y = buildSection(sc, "Aimbot", y)
    y = buildToggle(sc, "Aimbot Aktif", "Aimbot", y, function(v) webhookFeature("Aimbot", v) end)
    y = buildSlider(sc, "Max Mesafe",  "AimMaxDist",    y, 10, 2000)
    y = buildSlider(sc, "Yumusatma",   "AimbotSmooth",  y, 0.02, 1.0, "%.2f")
    y = buildToggle(sc, "FOV Kullan",  "UseFOV",        y)
    y = buildSlider(sc, "FOV Boyutu",  "FOVSize",       y, 20, 400)
    y = buildToggle(sc, "FOV Goster",  "FOVVisible",    y, function(v) if fovCircle then fovCircle.Visible = v end end)
    y = buildToggle(sc, "Kafa Hedef",  "AimHead",       y)
    y = buildToggle(sc, "Gogus Hedef", "AimChest",      y)
    y = buildToggle(sc, "Karin Hedef", "AimStomach",    y)
    -- RAGEBOT
    y = buildSection(sc, "Ragebot", y+4)
    y = buildToggle(sc, "Ragebot Aktif", "RageAimbot", y, function(v) if v then enableRageAimbot() else disableRageAimbot() end; webhookFeature("Ragebot", v) end)
    y = buildSlider(sc, "Max Mesafe",   "RageMaxDist",  y, 10, 1000)
    -- SILENT AIM
    y = buildSection(sc, "Silent Aim", y+4)
    y = buildToggle(sc, "Silent Aim Aktif", "SilentAim", y, function(v) if v then enableSilentAim() else disableSilentAim() end; webhookFeature("Silent Aim", v) end)
    y = buildSlider(sc, "Max Mesafe",   "SilentMaxDist", y, 10, 1000)
    -- TRIGGER BOT
    y = buildSection(sc, "Trigger Bot", y+4)
    y = buildToggle(sc, "Trigger Bot Aktif", "TriggerBot", y, function(v) if v then enableTriggerBot() else disableTriggerBot() end; webhookFeature("Trigger Bot", v) end)
    y = buildSlider(sc, "Max Mesafe",   "TriggerMaxDist",  y, 5,  200)
    y = buildSlider(sc, "Gecikme",      "TriggerBotDelay", y, 0.01, 0.5, "%.2f")
    -- MAGIC BULLET
    y = buildSection(sc, "Magic Bullet", y+4)
    y = buildToggle(sc, "Magic Bullet Aktif", "MagicBullet", y, function(v) if v then enableMagicBullet() else disableMagicBullet() end; webhookFeature("Magic Bullet", v) end)
    -- HITBOX
    y = buildSection(sc, "Hitbox", y+4)
    y = buildToggle(sc, "Hitbox Aktif", "HitboxEnabled", y, function(v) if v then enableHitbox() else disableHitbox() end; webhookFeature("Hitbox", v) end)
    y = buildSlider(sc, "Hitbox Boyutu", "HitboxSize",  y, 1, 20, "%.1f")
    -- FAKE LAG
    y = buildSection(sc, "Fake Lag", y+4)
    y = buildToggle(sc, "Fake Lag Aktif", "FakeLag", y, function(v) if v then enableFakeLag() else disableFakeLag() end; webhookFeature("Fake Lag", v) end)
    y = buildSlider(sc, "Aralik",   "FakeLagInterval", y, 0.0, 0.5, "%.2f")
    -- ANTI AIM
    y = buildSection(sc, "Anti-Aim", y+4)
    y = buildToggle(sc, "Anti-Aim Aktif", "AntiAim", y, function(v) if v then enableAntiAim() else disableAntiAim() end; webhookFeature("Anti-Aim", v) end)
    y = buildSlider(sc, "Yaw Acisi",   "AntiAimYaw",   y, 0, 360, nil)
    y = buildSlider(sc, "Pitch Acisi", "AntiAimPitch", y, -90, 90, nil)
    -- NO SPREAD / NO RECOIL
    y = buildSection(sc, "Stabilite", y+4)
    y = buildToggle(sc, "No Spread", "NoSpread", y, function(v) if v then enableNoSpread() else disableNoSpread() end; webhookFeature("No Spread", v) end)
    y = buildToggle(sc, "No Recoil", "NoRecoil", y, function(v) if v then enableNoRecoil() else disableNoRecoil() end; webhookFeature("No Recoil", v) end)
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
    y = buildSection(sc, "Ziplama Gucu", y+4)
    y = buildToggle(sc, "Ziplama Gucu Aktif", "JumpHack", y, function(v)
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = v and _G.JumpPower or 50 end
        end
        webhookFeature("Jump Hack", v)
    end)
    y = buildSlider(sc, "Ziplama Gucu", "JumpPower", y, 10, 500, nil, function(val)
        if _G.JumpHack then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.JumpPower = val end
            end
        end
    end)
    y = buildSection(sc, T("s_tp"), y+4)
    y = buildToggle(sc, T("t_ct"),  "TeleportCursor", y, function(v) webhookFeature("Cursor TP", v) end)
    y = buildSection(sc, T("s_oth"), y+4)
    y = buildToggle(sc, T("t_st"),  "StreamProof", y, function(v) if MainGui then MainGui.DisplayOrder = v and 200 or 10 end end)
end

tabBuilders["PLAYERS"] = function(parent)
    local sc = makeScrollFrame(parent); local y = 10
    y = buildSection(sc, "Oyuncu Listesi", y)
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
            if plr == LocalPlayer then do end end
            row = Instance.new("Frame", plist)
            row.Size = UDim2.new(1, 0, 0, 42); row.BackgroundColor3 = Tc.CardHover; makeCorner(6, row)
            nameLbl = Instance.new("TextLabel", row)
            nameLbl.Size = UDim2.new(1, -196, 1, 0); nameLbl.Position = UDim2.new(0, 8, 0, 0)
            nameLbl.BackgroundTransparency = 1; nameLbl.Text = plr.Name
            nameLbl.TextColor3 = Tc.Text; nameLbl.Font = Enum.Font.GothamSemibold
            nameLbl.TextSize = 12; nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            -- HP bar
            hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                hpBar = Instance.new("Frame", row)
                hpBar.Size = UDim2.new(0, pct * 60, 0, 4)
                hpBar.Position = UDim2.new(0, 8, 1, -6); hpBar.BorderSizePixel = 0
                hpBar.BackgroundColor3 = pct > 0.6 and Color3.fromRGB(80,255,120) or
                    (pct > 0.3 and Color3.fromRGB(255,220,80) or Color3.fromRGB(255,80,80))
                makeCorner(2, hpBar)
            end
            btDefs = {
                {l=T("b_tp"),   c=Color3.fromRGB(55,55,180),  x=1, xo=-188},
                {l=T("b_pull"), c=Color3.fromRGB(160,90,0),   x=1, xo=-140},
                {l=T("b_spec"), c=Color3.fromRGB(75,75,160),  x=1, xo=-92},
                {l=T("b_frz"),  c=Color3.fromRGB(0,130,130),  x=1, xo=-44},
            }
            createdBtns = {}
            for _, bd in ipairs(btDefs) do
                b = Instance.new("TextButton", row)
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
            frozen = false
            createdBtns[T("b_frz")].MouseButton1Click:Connect(function()
                frozen = not frozen
                if plr.Character then
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        if frozen then
                            if frozenPlayers[plr] then return end
                            bp = Instance.new("BodyPosition")
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
    y = buildSection(sc, "Gokyuzu", y+4)
    y = buildToggle(sc, "No Skybox", "NoSkybox", y, function(v) if v then enableNoSkybox() else disableNoSkybox() end; webhookFeature("No Skybox", v) end)
    y = buildSection(sc, "Rainbow Mode", y+4)
    y = buildToggle(sc, "Rainbow Mode (ESP Renkleri)", "RainbowMode", y, function(v) if v then enableRainbowMode() else disableRainbowMode() end; webhookFeature("Rainbow Mode", v) end)
    y = buildSection(sc, "Player Glow", y+4)
    y = buildToggle(sc, "Player Glow (Isiltisi)", "PlayerGlow", y, function(v) if v then enablePlayerGlow() else disablePlayerGlow() end; webhookFeature("Player Glow", v) end)
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
        chatFrame = Instance.new("Frame", sc)
        chatFrame.Size = UDim2.new(1,-28,0,140); chatFrame.Position = UDim2.new(0,14,0,y)
        chatFrame.BackgroundColor3 = Tc.Card; makeCorner(8, chatFrame)
        chatSc = Instance.new("ScrollingFrame", chatFrame)
        chatSc.Size = UDim2.new(1,-8,1,-8); chatSc.Position = UDim2.new(0,4,0,4)
        chatSc.BackgroundTransparency = 1; chatSc.ScrollBarThickness = 2
        chatSc.CanvasSize = UDim2.new(0,0,0,0); chatSc.AutomaticCanvasSize = Enum.AutomaticSize.Y; chatSc.BorderSizePixel = 0
        Instance.new("UIListLayout", chatSc).Padding = UDim.new(0,2)
        for _, log in ipairs(chatLogs) do
            lbl = Instance.new("TextLabel", chatSc)
            lbl.Size = UDim2.new(1,-4,0,14); lbl.BackgroundTransparency = 1
            lbl.Text = log:sub(1,50); lbl.TextColor3 = Tc.TextDim
            lbl.Font = Enum.Font.Gotham; lbl.TextSize = 10; lbl.TextXAlignment = Enum.TextXAlignment.Left
        end
        y = y + 148
    end
    y = buildSection(sc, T("s_mm"), y+4)
    y = buildToggle(sc, T("t_mm"), "MiniMap", y, function(v) if v then enableMiniMap() else disableMiniMap() end; webhookFeature("MiniMap", v) end)
    -- Godmode + Anti AFK (Players'dan tasindi)
    y = buildSection(sc, T("s_god"), y+4)
    y = buildToggle(sc, T("t_gd"), "Godmode", y, function(v) if v then enableGodmode() else disableGodmode() end; webhookFeature("Godmode", v) end)
    y = buildSection(sc, T("s_hlp"), y+4)
    y = buildToggle(sc, T("t_af"), "AntiAFK", y, function(v) if v then enableAntiAFK() else disableAntiAFK() end; webhookFeature("Anti AFK", v) end)
    -- Yeni Misc ozellikleri
    y = buildSection(sc, "Gorunmezlik", y+4)
    y = buildToggle(sc, "Gorunmezlik (Invisible)", "Invisible", y, function(v) if v then enableInvisible() else disableInvisible() end; webhookFeature("Invisible", v) end)
    y = buildSection(sc, T("s_norecoil"), y+4)
    y = buildToggle(sc, T("t_norecoil"), "NoRecoil", y, function(v) if v then enableNoRecoil() else disableNoRecoil() end; webhookFeature("No Recoil", v) end)
    y = buildSection(sc, T("s_noanim"), y+4)
    y = buildToggle(sc, T("t_noanim"), "NoAnimation", y, function(v) if v then enableNoAnimation() else disableNoAnimation() end; webhookFeature("No Animation", v) end)
    y = buildSection(sc, T("s_autoclk"), y+4)
    y = buildToggle(sc, T("t_autoclk"), "AutoClicker", y, function(v) if v then enableAutoClicker() else disableAutoClicker() end; webhookFeature("Auto Clicker", v) end)
    y = buildSlider(sc, T("l_cps"), "AutoClickerCPS", y, 1, 20, nil)
    y = buildSection(sc, T("s_spinbot"), y+4)
    y = buildToggle(sc, T("t_spinbot"), "SpinBot", y, function(v) if v then enableSpinBot() else disableSpinBot() end; webhookFeature("Spin Bot", v) end)
    y = buildSlider(sc, T("l_spin"), "SpinBotSpeed", y, 1, 50, nil)
    y = buildSection(sc, T("s_walkanim"), y+4)
    y = buildToggle(sc, T("t_walkanim"), "CustomWalkAnim", y, function(v) applyCustomWalkAnim(v); webhookFeature("Custom Walk Anim", v) end)
    local animBox; animBox, y = buildInput(sc, T("l_animid"), "507777826", "507777826", y)
    local animApplyBtn; animApplyBtn, y = buildButton(sc, T("b_apply"), y)
    animApplyBtn.MouseButton1Click:Connect(function() _G.WalkAnimID = animBox.Text; applyCustomWalkAnim(true) end)
    y = buildSection(sc, T("s_gamesense"), y+4)
    y = buildToggle(sc, T("t_gamesense"), "GameSense", y, function(v) if v then enableGameSense() else disableGameSense() end; webhookFeature("Game Sense", v) end)
    y = buildSection(sc, "Ani Yeniden Dogma", y+4)
    y = buildToggle(sc, "Instant Respawn", "InstantRespawn", y, function(v) if v then enableInstantRespawn() else disableInstantRespawn() end; webhookFeature("Instant Respawn", v) end)
    y = buildSection(sc, "Ani Reload", y+4)
    y = buildToggle(sc, "Instant Reload", "InstantReload", y, function(v) if v then enableInstantReload() else disableInstantReload() end; webhookFeature("Instant Reload", v) end)
end

tabBuilders["ITEMS"] = function(parent)
    local sc = makeScrollFrame(parent); local y = 10
    y = buildSection(sc, T("s_itm"), y)
    local pBox; pBox, y = buildInput(sc, "Kullanici", "Isim", "", y)
    local tBox; tBox, y = buildInput(sc, "Esya", "Kilic", "", y)
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
            cnt = 0
            for name in pairs(found) do
                btn = Instance.new("TextButton", tscroll)
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
    function giveItem(playerName, toolName, count)
        count = count or 1
        local targetPlayer
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Name:lower():find(playerName:lower()) then targetPlayer = plr; break end
        end
        if not targetPlayer then return false, "Oyuncu bulunamadi" end
        foundTool = nil
        for _, loc in ipairs({ServerStorage, ReplicatedStorage, Workspace}) do
            pcall(function()
                local t = loc:FindFirstChild(toolName, true)
                if t and t:IsA("Tool") then foundTool = t:Clone() end
            end)
            if foundTool then break end
        end
        if not foundTool then return false, "Esya bulunamadi" end
        for i = 1, count do
            clone = foundTool:Clone()
            bp = targetPlayer:FindFirstChild("Backpack")
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

tabBuilders["ANTICHEAT"] = function(parent)
    local sc = makeScrollFrame(parent); local y = 10

    -- Uyari banner
    local warnCard = Instance.new("Frame", sc)
    warnCard.Size = UDim2.new(1,-28,0,44); warnCard.Position = UDim2.new(0,14,0,y)
    warnCard.BackgroundColor3 = Color3.fromRGB(40,25,10); makeCorner(8, warnCard)
    local wl = Instance.new("TextLabel", warnCard); wl.Size = UDim2.new(1,-16,1,0); wl.Position = UDim2.new(0,8,0,0); wl.BackgroundTransparency=1
    wl.Text = "[!] Tum bypass'lar aktif olsun. Ban riski minimuma indirilir."; wl.TextColor3 = Color3.fromRGB(255,200,80); wl.Font = Enum.Font.GothamMedium; wl.TextSize = 12; wl.TextWrapped = true; wl.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 52

    y = buildSection(sc, "Hareket Bypass'lari", y)
    y = buildToggle(sc, "Fly Bypass (Yerde Goster)", "ACBypassFly", y)
    y = buildToggle(sc, "Noclip Bypass (Network Ownership)", "ACBypassNoclip", y)
    y = buildToggle(sc, "Hiz Bypass (WalkSpeed=16 Goster)", "ACBypassSpeed", y)
    y = buildToggle(sc, "TP Bypass (Interpolasyon)", "ACBypassTP", y)

    y = buildSection(sc, "Sistem Bypass'lari", y+4)
    y = buildToggle(sc, "AC Remote Engelle (AC Event'ler)", "ACBlockRemotes", y)
    y = buildToggle(sc, "Aimbot Bypass (Mouse Hareket)", "ACBypassAimbot", y)
    y = buildToggle(sc, "Anti-Screenshot (F12/PrtScr gizle)", "AntiScreenshot", y, function(v) webhookFeature("Anti-Screenshot", v) end)
    y = buildToggle(sc, "HWID Spoofer (Rastgele HWID)", "HWIDSpoofer", y, function(v) applyHWIDSpoof(); webhookFeature("HWID Spoofer", v) end)

    y = buildSection(sc, "Nasil Calisir?", y+4)
    local infoCard = Instance.new("Frame", sc)
    infoCard.Size = UDim2.new(1,-28,0,0); infoCard.AutomaticSize = Enum.AutomaticSize.Y
    infoCard.Position = UDim2.new(0,14,0,y); infoCard.BackgroundColor3 = Tc.Card; makeCorner(8, infoCard)
    local il = Instance.new("TextLabel", infoCard)
    il.Size = UDim2.new(1,-16,0,0); il.AutomaticSize = Enum.AutomaticSize.Y
    il.Position = UDim2.new(0,8,0,8); il.BackgroundTransparency = 1
    il.Text = "Fly Bypass: WalkSpeed=16 gosterilir, ucus BodyVelocity ile yapilir.\n\n" ..
               "Hiz Bypass: WalkSpeed=16 sabit kalir, asil hiz BodyVelocity'den gelir.\n\n" ..
               "Noclip Bypass: Carpisme kapaliyken Network Ownership bizde.\n\n" ..
               "AC Remote Engelle: AC keyword RemoteEvent'ler intercept edilir.\n\n" ..
               "Aimbot Bypass: mousemoverel() kullanilir, kamera manipulation yok.\n\n" ..
               "HWID Spoofer: Rastgele 32 karakterlik sahte HWID uretilir."
    il.TextColor3 = Tc.TextDim; il.Font = Enum.Font.Gotham; il.TextSize = 11; il.TextWrapped = true; il.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UIPadding", infoCard).PaddingBottom = UDim.new(0,10)
end

tabBuilders["KEYBINDS"] = function(parent)
    buildKeybindsTab(parent)
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
    configs = listLocalConfigs()
    if #configs == 0 then
        el = Instance.new("TextLabel", sc)
        el.Size = UDim2.new(1,-28,0,28); el.Position = UDim2.new(0,14,0,y)
        el.BackgroundTransparency = 1; el.Text = T("cfg_none"); el.TextColor3 = Tc.TextFaint
        el.Font = Enum.Font.GothamMedium; el.TextSize = 13; el.TextXAlignment = Enum.TextXAlignment.Left
    else
        for _, cfgName in ipairs(configs) do
            row = Instance.new("Frame", sc)
            row.Size = UDim2.new(1,-28,0,44); row.Position = UDim2.new(0,14,0,y); row.BackgroundColor3 = Tc.Card; makeCorner(8, row)
            nl = Instance.new("TextLabel", row)
            nl.Size = UDim2.new(1,-160,1,0); nl.Position = UDim2.new(0,12,0,0); nl.BackgroundTransparency = 1
            nl.Text = cfgName; nl.TextColor3 = Tc.Text; nl.Font = Enum.Font.GothamSemibold; nl.TextSize = 13; nl.TextXAlignment = Enum.TextXAlignment.Left
            function mkB(txt, col, xOff)
                local b = Instance.new("TextButton", row)
                b.Size = UDim2.new(0,46,0,28); b.Position = UDim2.new(1,xOff,0.5,-14)
                b.BackgroundColor3 = col; b.TextColor3 = Color3.new(1,1,1)
                b.Font = Enum.Font.GothamBold; b.TextSize = 11; b.Text = txt; makeCorner(6, b); return b
            end
            lb = mkB(T("cfg_load"), Tc.KeyGreen, -152)
            db = mkB(T("cfg_del"),  Tc.KeyRed,   -98)
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
    local LANG_LIST = {"TR","EN","ES","FR","DE"}
    local function getLangName(l) return l=="TR" and "Turkce" or l=="EN" and "English" or l=="ES" and "Espanol" or l=="FR" and "Francais" or "Deutsch" end
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
    themeGrid = Instance.new("Frame", sc)
    themeGrid.Size = UDim2.new(1,-28,0,0); themeGrid.AutomaticSize = Enum.AutomaticSize.Y
    themeGrid.Position = UDim2.new(0,14,0,y); themeGrid.BackgroundTransparency = 1
    tgLayout = Instance.new("UIGridLayout", themeGrid)
    tgLayout.CellSize = UDim2.new(0,100,0,56); tgLayout.CellPadding = UDim2.new(0,6,0,6); tgLayout.SortOrder = Enum.SortOrder.LayoutOrder
    for i, theme in ipairs(THEMES) do
        acCol = theme.rainbow and Color3.fromRGB(255,100,100) or Color3.fromRGB(theme.ac[1],theme.ac[2],theme.ac[3])
        bgCol = Color3.fromRGB(theme.bg[1],theme.bg[2],theme.bg[3])
        btn = Instance.new("TextButton", themeGrid)
        btn.BackgroundColor3 = bgCol; btn.BorderSizePixel = 0; btn.Text = ""; btn.LayoutOrder = i; makeCorner(8, btn)
        acBar = Instance.new("Frame", btn)
        acBar.Size = UDim2.new(1,0,0,4); acBar.BackgroundColor3 = acCol; acBar.BorderSizePixel = 0; makeCorner(4, acBar)
        nameLbl = Instance.new("TextLabel", btn)
        nameLbl.Size = UDim2.new(1,0,1,-4); nameLbl.Position = UDim2.new(0,0,0,4)
        nameLbl.BackgroundTransparency = 1; nameLbl.Text = theme.name; nameLbl.TextColor3 = acCol
        nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextSize = 12
        if i == currentThemeIndex then
            sel = Instance.new("UIStroke", btn); sel.Color = acCol; sel.Thickness = 2
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
    y = buildSection(sc, T("s_panic"), y+4)
    panicInfo = Instance.new("Frame", sc)
    panicInfo.Size = UDim2.new(1,-28,0,36); panicInfo.Position = UDim2.new(0,14,0,y)
    panicInfo.BackgroundColor3 = Tc.Card; makeCorner(8, panicInfo)
    pLbl = Instance.new("TextLabel", panicInfo)
    pLbl.Size = UDim2.new(1,-16,1,0); pLbl.Position = UDim2.new(0,8,0,0); pLbl.BackgroundTransparency = 1
    pLbl.Text = "DELETE tusu: Tum ozellikleri aninda kapatir"; pLbl.TextColor3 = Tc.TextDim
    pLbl.Font = Enum.Font.Gotham; pLbl.TextSize = 12; pLbl.TextWrapped = true; pLbl.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 44
    y = buildSection(sc, T("s_abt"), y+4)
    aCard = Instance.new("Frame", sc)
    aCard.Size = UDim2.new(1,-28,0,0); aCard.AutomaticSize = Enum.AutomaticSize.Y
    aCard.Position = UDim2.new(0,14,0,y); aCard.BackgroundColor3 = Tc.Card; makeCorner(8, aCard)
    aLbl = Instance.new("TextLabel", aCard)
    aLbl.Size = UDim2.new(1,-16,0,0); aLbl.AutomaticSize = Enum.AutomaticSize.Y
    aLbl.Position = UDim2.new(0,8,0,8); aLbl.BackgroundTransparency = 1
    aLbl.Text = "SUSANO V2.2\n" .. T("disc") .. "\n\nESP (2D/3D/Skeleton/Chams), Aimbot, Rage Aimbot, Silent Aim, Magic Bullet, Trigger Bot, Hitbox, Fake Lag, Fly, Noclip, Speed, BunnyHop, LongJump, Gravity, Cursor TP, Godmode, Kill Aura, Anti AFK, Name Spoof, Full Bright, No Fog, FOV, 3rd Person, Time, World Color, Server Hop, Auto Rejoin, FPS Boost, Chat Logger, MiniMap, Esya, Takim, AntiCheat Bypass, Config, 9 Tema, TR/EN/ES\n\nF5 - Menu | Sag Tik - Cursor TP"
    aLbl.TextColor3 = Tc.TextDim; aLbl.Font = Enum.Font.Gotham; aLbl.TextSize = 12; aLbl.TextWrapped = true; aLbl.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UIPadding", aCard).PaddingBottom = UDim.new(0,10)
end

-- --- ESP BUILDER ---
espBuilderGui = nil
espBuilderPage = 1
_G.ESPCornerMode = false
_G.ESPCornerThick = 1.5

function openESPBuilder()
    if espBuilderGui and espBuilderGui.Parent then return end
    espBuilderGui = makeScreenGui("SusanoESPBuilder", 8500)
    local W, H = 480, 600
    local main2 = Instance.new("Frame", espBuilderGui)
    main2.Size = UDim2.new(0,W,0,H)
    main2.Position = UDim2.new(1,-(W+10),0.5,-(H/2))
    main2.BackgroundColor3 = Color3.fromRGB(12,12,14)
    main2.BorderSizePixel = 0; main2.Active = true
    makeCorner(10, main2)
    local ms2 = Instance.new("UIStroke",main2); ms2.Color=Tc.Accent; ms2.Thickness=1; ms2.Transparency=0.4

    -- Baslik
    local titleF2 = Instance.new("Frame",main2)
    titleF2.Size=UDim2.new(1,0,0,40); titleF2.BackgroundColor3=Color3.fromRGB(8,8,10); titleF2.BorderSizePixel=0
    makeCorner(10,titleF2)
    local tfix3=Instance.new("Frame",titleF2); tfix3.Size=UDim2.new(1,0,0.5,0); tfix3.Position=UDim2.new(0,0,0.5,0); tfix3.BackgroundColor3=Color3.fromRGB(8,8,10); tfix3.BorderSizePixel=0
    local tl2=Instance.new("TextLabel",titleF2); tl2.Size=UDim2.new(1,-140,1,0); tl2.Position=UDim2.new(0,12,0,0); tl2.BackgroundTransparency=1; tl2.Text="ESP Builder"; tl2.TextColor3=Tc.Accent; tl2.Font=Enum.Font.GothamBlack; tl2.TextSize=16; tl2.TextXAlignment=Enum.TextXAlignment.Left
    local p1Btn2=Instance.new("TextButton",titleF2); p1Btn2.Size=UDim2.new(0,60,0,26); p1Btn2.Position=UDim2.new(1,-130,0.5,-13); p1Btn2.Font=Enum.Font.GothamBold; p1Btn2.TextSize=12; p1Btn2.Text="Sayfa 1"; p1Btn2.BackgroundColor3=Tc.Accent; p1Btn2.TextColor3=Tc.BG; makeCorner(5,p1Btn2)
    local p2Btn2=Instance.new("TextButton",titleF2); p2Btn2.Size=UDim2.new(0,60,0,26); p2Btn2.Position=UDim2.new(1,-65,0.5,-13); p2Btn2.Font=Enum.Font.GothamBold; p2Btn2.TextSize=12; p2Btn2.Text="Sayfa 2"; p2Btn2.BackgroundColor3=Tc.AccentFaint; p2Btn2.TextColor3=Tc.Text; makeCorner(5,p2Btn2)

    -- Drag
    local dr2,ds2,dp2=false
    titleF2.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dr2=true;ds2=i.Position;dp2=main2.Position;i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dr2=false end end) end end)
    local di2; titleF2.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then di2=i end end)
    UserInputService.InputChanged:Connect(function(i) if dr2 and i==di2 then local d2=i.Position-ds2; main2.Position=UDim2.new(dp2.X.Scale,dp2.X.Offset+d2.X,dp2.Y.Scale,dp2.Y.Offset+d2.Y) end end)

    -- Preview (sol taraf)
    local prevF2=Instance.new("Frame",main2); prevF2.Size=UDim2.new(0,160,1,-40); prevF2.Position=UDim2.new(0,0,0,40); prevF2.BackgroundColor3=Color3.fromRGB(16,16,18); prevF2.BorderSizePixel=0; makeCorner(8,prevF2)

    -- Karakter silueti
    local function mcp2(x,y2,w2,h2,c2)
        local f=Instance.new("Frame",prevF2); f.Position=UDim2.new(0.5,x-w2/2,0,y2); f.Size=UDim2.new(0,w2,0,h2); f.BackgroundColor3=c2; f.BorderSizePixel=0; makeCorner(4,f); return f
    end
    local cc2=Color3.fromRGB(55,55,68)
    mcp2(0,50,22,22,cc2); mcp2(0,74,30,52,cc2); mcp2(-19,74,12,44,cc2); mcp2(19,74,12,44,cc2); mcp2(-9,128,12,42,cc2); mcp2(9,128,12,42,cc2)

    -- Suruklenebilir ESP label'lari
    local espLabels={}
    local dragEl2,dElX,dElY=nil,0,0
    local function mkESPLabel2(text,x2,y2,col2,key2)
        local lbl2=Instance.new("TextLabel",prevF2)
        lbl2.Position=UDim2.new(0.5,x2,0,y2); lbl2.Size=UDim2.new(0,110,0,16)
        lbl2.BackgroundTransparency=1; lbl2.Text=text; lbl2.TextColor3=col2
        lbl2.Font=Enum.Font.GothamBold; lbl2.TextSize=11; lbl2.TextXAlignment=Enum.TextXAlignment.Center
        lbl2.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragEl2=lbl2; dElX=i.Position.X-lbl2.AbsolutePosition.X; dElY=i.Position.Y-lbl2.AbsolutePosition.Y end end)
        lbl2.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 and dragEl2==lbl2 then dragEl2=nil end end)
        espLabels[key2]=lbl2; return lbl2
    end
    UserInputService.InputChanged:Connect(function(i)
        if dragEl2 and i.UserInputType==Enum.UserInputType.MouseMovement then
            local px=prevF2.AbsolutePosition.X; local py=prevF2.AbsolutePosition.Y; local pw=prevF2.AbsoluteSize.X
            dragEl2.Position=UDim2.new(0.5,(i.Position.X-dElX-px)-pw/2,0,i.Position.Y-dElY-py)
        end
    end)
    mkESPLabel2("PlayerName [42]",-55,30,Color3.fromRGB(_G.ESPNameR,_G.ESPNameG,_G.ESPNameB),"name2")
    mkESPLabel2("150m",-55,175,Color3.fromRGB(_G.ESPDistColorR,_G.ESPDistColorG,_G.ESPDistColorB),"dist2")
    mkESPLabel2("ID:12345",-55,16,Color3.fromRGB(_G.ESPIDColorR,_G.ESPIDColorG,_G.ESPIDColorB),"id2")
    local prevBox2=Instance.new("Frame",prevF2); prevBox2.Position=UDim2.new(0.5,-22,0,48); prevBox2.Size=UDim2.new(0,44,0,124); prevBox2.BackgroundTransparency=1; prevBox2.BorderSizePixel=0
    local pbs2=Instance.new("UIStroke",prevBox2); pbs2.Color=Color3.fromRGB(_G.ESPEnemyR,_G.ESPEnemyG,_G.ESPEnemyB); pbs2.Thickness=1.5
    local acLbl2=Instance.new("TextLabel",prevF2); acLbl2.Size=UDim2.new(1,-4,0,14); acLbl2.Position=UDim2.new(0,2,1,-16); acLbl2.BackgroundTransparency=1; acLbl2.TextColor3=Color3.fromRGB(80,80,80); acLbl2.Font=Enum.Font.Gotham; acLbl2.TextSize=9; acLbl2.TextXAlignment=Enum.TextXAlignment.Left; acLbl2.Text="  Surukleme ile konum ayarla"

    local function updatePreview2()
        if not espBuilderGui then return end
        if espLabels["name2"] then espLabels["name2"].Visible=_G.ShowNames; espLabels["name2"].TextColor3=Color3.fromRGB(_G.ESPNameR,_G.ESPNameG,_G.ESPNameB) end
        if espLabels["dist2"] then espLabels["dist2"].Visible=_G.ShowDistance; espLabels["dist2"].TextColor3=Color3.fromRGB(_G.ESPDistColorR,_G.ESPDistColorG,_G.ESPDistColorB) end
        if espLabels["id2"] then espLabels["id2"].Visible=_G.ShowID; espLabels["id2"].TextColor3=Color3.fromRGB(_G.ESPIDColorR,_G.ESPIDColorG,_G.ESPIDColorB) end
        pbs2.Color=Color3.fromRGB(_G.ESPEnemyR,_G.ESPEnemyG,_G.ESPEnemyB)
    end

    -- Ayar paneli (sag)
    local settF2=Instance.new("Frame",main2); settF2.Size=UDim2.new(1,-160,1,-40); settF2.Position=UDim2.new(0,160,0,40); settF2.BackgroundTransparency=1; settF2.ClipsDescendants=true

    local pg1=Instance.new("ScrollingFrame",settF2); pg1.Size=UDim2.new(1,0,1,0); pg1.BackgroundTransparency=1; pg1.ScrollBarThickness=3; pg1.CanvasSize=UDim2.new(0,0,0,0); pg1.AutomaticCanvasSize=Enum.AutomaticSize.Y; pg1.BorderSizePixel=0
    Instance.new("UIListLayout",pg1).Padding=UDim.new(0,3)
    local pgPad1=Instance.new("UIPadding",pg1); pgPad1.PaddingLeft=UDim.new(0,5); pgPad1.PaddingRight=UDim.new(0,5); pgPad1.PaddingTop=UDim.new(0,4)

    local pg2=Instance.new("ScrollingFrame",settF2); pg2.Size=UDim2.new(1,0,1,0); pg2.BackgroundTransparency=1; pg2.ScrollBarThickness=3; pg2.CanvasSize=UDim2.new(0,0,0,0); pg2.AutomaticCanvasSize=Enum.AutomaticSize.Y; pg2.BorderSizePixel=0; pg2.Visible=false
    Instance.new("UIListLayout",pg2).Padding=UDim.new(0,3)
    local pgPad2=Instance.new("UIPadding",pg2); pgPad2.PaddingLeft=UDim.new(0,5); pgPad2.PaddingRight=UDim.new(0,5); pgPad2.PaddingTop=UDim.new(0,4)

    local function switchPage2(n)
        pg1.Visible=(n==1); pg2.Visible=(n==2)
        p1Btn2.BackgroundColor3=n==1 and Tc.Accent or Tc.AccentFaint; p1Btn2.TextColor3=n==1 and Tc.BG or Tc.Text
        p2Btn2.BackgroundColor3=n==2 and Tc.Accent or Tc.AccentFaint; p2Btn2.TextColor3=n==2 and Tc.BG or Tc.Text
    end
    p1Btn2.MouseButton1Click:Connect(function() switchPage2(1) end)
    p2Btn2.MouseButton1Click:Connect(function() switchPage2(2) end)

    local function mkSB(parent2,label2)
        local sf=Instance.new("Frame",parent2); sf.Size=UDim2.new(1,0,0,18); sf.BackgroundTransparency=1
        local sl=Instance.new("TextLabel",sf); sl.Size=UDim2.new(1,-4,1,0); sl.Position=UDim2.new(0,4,0,0); sl.BackgroundTransparency=1; sl.Text=label2:upper(); sl.TextColor3=Tc.Accent; sl.Font=Enum.Font.GothamBold; sl.TextSize=9; sl.TextXAlignment=Enum.TextXAlignment.Left
    end
    local function mkTog2(parent2,label2,setting2)
        local row2=Instance.new("Frame",parent2); row2.Size=UDim2.new(1,0,0,28); row2.BackgroundColor3=Color3.fromRGB(18,18,20); row2.BorderSizePixel=0; makeCorner(5,row2)
        local lb2=Instance.new("TextLabel",row2); lb2.Size=UDim2.new(0.7,0,1,0); lb2.Position=UDim2.new(0,6,0,0); lb2.BackgroundTransparency=1; lb2.Text=label2; lb2.TextColor3=Color3.fromRGB(200,200,200); lb2.Font=Enum.Font.GothamMedium; lb2.TextSize=11; lb2.TextXAlignment=Enum.TextXAlignment.Left
        local ph3,pw3=18,36; local pill3=Instance.new("Frame",row2); pill3.Size=UDim2.new(0,pw3,0,ph3); pill3.Position=UDim2.new(1,-pw3-5,0.5,-ph3/2); pill3.BackgroundColor3=_G[setting2] and Color3.fromRGB(200,200,200) or Color3.fromRGB(35,35,35); makeCorner(ph3,pill3)
        local kn3=Instance.new("Frame",pill3); kn3.Size=UDim2.new(0,ph3-4,0,ph3-4); kn3.Position=UDim2.new(_G[setting2] and 1 or 0,_G[setting2] and -(ph3-2) or 2,0.5,-(ph3-4)/2); kn3.BackgroundColor3=Color3.fromRGB(200,200,200); makeCorner(100,kn3)
        local h3=Instance.new("TextButton",row2); h3.Size=UDim2.new(1,0,1,0); h3.BackgroundTransparency=1; h3.Text=""
        h3.MouseButton1Click:Connect(function()
            _G[setting2]=not _G[setting2]
            TweenService:Create(pill3,TweenInfo.new(0.15),{BackgroundColor3=_G[setting2] and Color3.fromRGB(200,200,200) or Color3.fromRGB(35,35,35)}):Play()
            TweenService:Create(kn3,TweenInfo.new(0.15),{Position=UDim2.new(_G[setting2] and 1 or 0,_G[setting2] and -(ph3-2) or 2,0.5,-(ph3-4)/2)}):Play()
            updatePreview2()
        end)
        RunService.Heartbeat:Connect(function() if row2 and row2.Parent then pill3.BackgroundColor3=_G[setting2] and Color3.fromRGB(200,200,200) or Color3.fromRGB(35,35,35); kn3.Position=UDim2.new(_G[setting2] and 1 or 0,_G[setting2] and -(ph3-2) or 2,0.5,-(ph3-4)/2) end end)
    end
    local function mkSld2(parent2,label2,setting2,min2,max2,fmt2)
        local row2=Instance.new("Frame",parent2); row2.Size=UDim2.new(1,0,0,36); row2.BackgroundColor3=Color3.fromRGB(18,18,20); row2.BorderSizePixel=0; makeCorner(5,row2)
        local lb2=Instance.new("TextLabel",row2); lb2.Size=UDim2.new(0.6,0,0,15); lb2.Position=UDim2.new(0,6,0,3); lb2.BackgroundTransparency=1; lb2.Text=label2; lb2.TextColor3=Color3.fromRGB(170,170,170); lb2.Font=Enum.Font.GothamMedium; lb2.TextSize=10; lb2.TextXAlignment=Enum.TextXAlignment.Left
        local vl2=Instance.new("TextLabel",row2); vl2.Size=UDim2.new(0.38,0,0,15); vl2.Position=UDim2.new(0.6,0,0,3); vl2.BackgroundTransparency=1; vl2.Font=Enum.Font.GothamBold; vl2.TextSize=10; vl2.TextXAlignment=Enum.TextXAlignment.Right; vl2.TextColor3=Tc.Accent
        local tr2=Instance.new("Frame",row2); tr2.Size=UDim2.new(1,-12,0,4); tr2.Position=UDim2.new(0,6,0,24); tr2.BackgroundColor3=Color3.fromRGB(40,40,45); tr2.BorderSizePixel=0; makeCorner(2,tr2)
        local fl2=Instance.new("Frame",tr2); fl2.Size=UDim2.new((_G[setting2]-min2)/(max2-min2),0,1,0); fl2.BackgroundColor3=Tc.Accent; fl2.BorderSizePixel=0; makeCorner(2,fl2)
        local hd2=Instance.new("Frame",tr2); hd2.Size=UDim2.new(0,10,0,10); hd2.AnchorPoint=Vector2.new(0.5,0.5); hd2.Position=UDim2.new((_G[setting2]-min2)/(max2-min2),0,0.5,0); hd2.BackgroundColor3=Color3.new(1,1,1); hd2.BorderSizePixel=0; makeCorner(100,hd2)
        local sl2=false
        hd2.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sl2=true end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sl2=false end end)
        UserInputService.InputChanged:Connect(function(i)
            if sl2 and i.UserInputType==Enum.UserInputType.MouseMovement then
                local pct2=math.clamp((i.Position.X-tr2.AbsolutePosition.X)/tr2.AbsoluteSize.X,0,1)
                local val2=min2+(max2-min2)*pct2
                if fmt2==nil then val2=math.floor(val2) end
                _G[setting2]=val2; fl2.Size=UDim2.new(pct2,0,1,0); hd2.Position=UDim2.new(pct2,0,0.5,0)
                vl2.Text=fmt2 and string.format(fmt2,val2) or tostring(math.floor(val2)); updatePreview2()
            end
        end)
        vl2.Text=fmt2 and string.format(fmt2,_G[setting2]) or tostring(math.floor(_G[setting2]))
    end
    local function mkColRow2(parent2,label2,r2,g2,b2)
        mkSB(parent2,label2.." Rengi")
        local cprev=Instance.new("Frame",parent2); cprev.Size=UDim2.new(1,0,0,20); cprev.BackgroundColor3=Color3.fromRGB(_G[r2],_G[g2],_G[b2]); cprev.BorderSizePixel=0; makeCorner(5,cprev)
        RunService.Heartbeat:Connect(function() if cprev and cprev.Parent then cprev.BackgroundColor3=Color3.fromRGB(_G[r2],_G[g2],_G[b2]) end end)
        mkSld2(parent2,"R",r2,0,255); mkSld2(parent2,"G",g2,0,255); mkSld2(parent2,"B",b2,0,255)
    end

    -- Sayfa 1
    mkSB(pg1,"Gorunurluk")
    mkTog2(pg1,"2D Box",      "ESPBox2D")
    mkTog2(pg1,"3D Highlight","ESPBox3D")
    mkTog2(pg1,"Skeleton",    "SkeletonESP")
    mkTog2(pg1,"Isim",        "ShowNames")
    mkTog2(pg1,"Mesafe",      "ShowDistance")
    mkTog2(pg1,"Can Cubugu",  "ShowHealthBar")
    mkTog2(pg1,"ID",          "ShowID")
    mkTog2(pg1,"Tracer",      "ShowTracer")
    mkSB(pg1,"Filtreler")
    mkTog2(pg1,"Takim Kontrol",  "TeamCheck")
    mkTog2(pg1,"Dost Goster",    "ShowFriendly")
    mkTog2(pg1,"Duvar Kontrol",  "WallCheck")
    mkSB(pg1,"Genel Ayarlar")
    mkSld2(pg1,"Max Mesafe",       "ESPMaxDist",   50,2000)
    mkSld2(pg1,"Tracer Kalinlik",  "TracerThick",  0.5,6,"%.1f")
    mkSld2(pg1,"Iskelet Kalinlik", "SkeletonThick",0.5,6,"%.1f")
    mkSB(pg1,"Kutu Stili")
    mkTog2(pg1,"Corner Box",       "ESPCornerMode")
    mkSld2(pg1,"Corner Uzunluk",   "ESPCornerLen", 4,30)
    mkSld2(pg1,"Corner Kalinlik",  "ESPCornerThick",0.5,4,"%.1f")

    -- Sayfa 2
    mkColRow2(pg2,"Dusman",  "ESPEnemyR","ESPEnemyG","ESPEnemyB")
    mkColRow2(pg2,"Dost",    "ESPFriendR","ESPFriendG","ESPFriendB")
    mkColRow2(pg2,"Gorunen", "ESPVisR","ESPVisG","ESPVisB")
    mkColRow2(pg2,"Isim",    "ESPNameR","ESPNameG","ESPNameB")
    mkColRow2(pg2,"Mesafe",  "ESPDistColorR","ESPDistColorG","ESPDistColorB")
    mkColRow2(pg2,"ID",      "ESPIDColorR","ESPIDColorG","ESPIDColorB")

    RunService.RenderStepped:Connect(function() pcall(updatePreview2) end)
end


-- --- WATERMARK ---
watermarkGui = nil
function createWatermark()
    if watermarkGui then watermarkGui:Destroy() end
    watermarkGui = makeScreenGui("SusanoWatermark", 9998)
    wm = Instance.new("Frame", watermarkGui)
    wm.Size = UDim2.new(0, 320, 0, 40)
    wm.AnchorPoint = Vector2.new(0.5, 0)
    wm.Position = UDim2.new(0.5, 0, 0, 8)
    wm.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    wm.BackgroundTransparency = 0.25
    wm.BorderSizePixel = 0
    corner4 = Instance.new("UICorner", wm); corner4.CornerRadius = UDim.new(0, 8)
    stroke4 = Instance.new("UIStroke", wm); stroke4.Color = Tc.Accent; stroke4.Thickness = 1; stroke4.Transparency = 0.5
    txt = Instance.new("TextLabel", wm)
    txt.Size = UDim2.new(1, -16, 1, 0); txt.Position = UDim2.new(0, 8, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = "SUSANO v2.2  |  " .. USERNAME .. "  |  .gg/tCufFEMdux"
    txt.TextColor3 = Color3.fromRGB(220, 220, 220); txt.Font = Enum.Font.GothamBold; txt.TextSize = 13
    txt.TextXAlignment = Enum.TextXAlignment.Left
    -- Rainbow accent bar
    bar = Instance.new("Frame", wm); bar.Size = UDim2.new(0, 3, 1, -8)
    bar.Position = UDim2.new(0, 3, 0, 4); bar.BackgroundColor3 = Tc.Accent; bar.BorderSizePixel = 0
    barC = Instance.new("UICorner", bar); barC.CornerRadius = UDim.new(0, 2)
    RunService.RenderStepped:Connect(function()
        if Tc then bar.BackgroundColor3 = Tc.Accent; stroke4.Color = Tc.Accent end
    end)
    return wm
end

-- ANA MENU
MainFrame, SideBar, Content = nil, nil, nil
currentTab = "ESP"
menuBuilt = false
minimized = false
MENU_FULL = UDim2.new(0, 940, 0, 680)
MENU_MINI = UDim2.new(0, 940, 0, 46)
sideButtons = {}

function getTabList()
    return {
        {id="ESP",       label=T("tab_esp")},
        {id="AIMBOT",    label=T("tab_aim")},
        {id="MOVEMENT",  label=T("tab_move")},
        {id="PLAYERS",   label=T("tab_play")},
        {id="VISUAL",    label=T("tab_vis")},
        {id="MISC",      label=T("tab_misc")},
        {id="ITEMS",     label=T("tab_item")},
        {id="ANTICHEAT", label=T("tab_ac")},
        {id="KEYBINDS",  label="Keybinds"},
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
    builder = tabBuilders[id]
    if builder then builder(Content) end
end

createMenu = function()
    if MainGui then pcall(function() MainGui:Destroy() end) end
    MainGui = makeScreenGui("SusanoUI", 9999); MainGui.Enabled = true
    Tc = makeThemeColors()

    MainFrame = Instance.new("Frame", MainGui)
    MainFrame.Size = MENU_FULL; MainFrame.Position = UDim2.new(0.5,-470,0.5,-340)
    MainFrame.BackgroundColor3 = Tc.BG; MainFrame.Active = true; makeCorner(10, MainFrame)
    iBorder = Instance.new("UIStroke", MainFrame)
    iBorder.Color = Tc.Accent; iBorder.Thickness = 1; iBorder.Transparency = 0.6

    -- Golge efekti
    for _, sd in ipairs({{4,3,0.82},{12,6,0.88},{22,10,0.94}}) do
        s = Instance.new("Frame", MainFrame)
        s.Size = UDim2.new(1,sd[1],1,sd[1]); s.Position = UDim2.new(0,-sd[1]/2,0,sd[2])
        s.BackgroundColor3 = Color3.new(0,0,0); s.BackgroundTransparency = sd[3]
        s.ZIndex = MainFrame.ZIndex-1; s.BorderSizePixel = 0; makeCorner(15, s)
    end

    -- Title bar
    titleBar = Instance.new("Frame", MainFrame)
    titleBar.Size = UDim2.new(1,0,0,46); titleBar.BackgroundColor3 = Tc.TitleBar
    titleBar.BorderSizePixel = 0; titleBar.ClipsDescendants = true; makeCorner(10, titleBar)
    tbFix = Instance.new("Frame", titleBar)
    tbFix.Size = UDim2.new(1,0,0.5,0); tbFix.Position = UDim2.new(0,0,0.5,0)
    tbFix.BackgroundColor3 = Tc.TitleBar; tbFix.BorderSizePixel = 0
    titleLine = Instance.new("Frame", titleBar)
    titleLine.Size = UDim2.new(1,0,0,1); titleLine.Position = UDim2.new(0,0,1,-1)
    titleLine.BackgroundColor3 = Tc.Accent; titleLine.BorderSizePixel = 0; titleLine.BackgroundTransparency = 0.7
    logoTxt = Instance.new("TextLabel", titleBar)
    logoTxt.Size = UDim2.new(0,110,1,0); logoTxt.Position = UDim2.new(0,16,0,0)
    logoTxt.BackgroundTransparency = 1; logoTxt.Text = "SUSANO"
    logoTxt.TextColor3 = Tc.Accent; logoTxt.Font = Enum.Font.GothamBlack; logoTxt.TextSize = 20; logoTxt.TextXAlignment = Enum.TextXAlignment.Left
    verTxt = Instance.new("TextLabel", titleBar)
    verTxt.Size = UDim2.new(0,40,1,0); verTxt.Position = UDim2.new(0,122,0,0)
    verTxt.BackgroundTransparency = 1; verTxt.Text = "v2.2"
    verTxt.TextColor3 = Tc.TextFaint; verTxt.Font = Enum.Font.GothamMedium; verTxt.TextSize = 11; verTxt.TextXAlignment = Enum.TextXAlignment.Left
    keyBadge = Instance.new("Frame", titleBar)
    keyBadge.Size = UDim2.new(0,80,0,22); keyBadge.Position = UDim2.new(0,168,0.5,-11)
    keyBadge.BackgroundColor3 = keyType=="lifetime" and Tc.KeyGold or
        (keyType=="monthly" and Color3.fromRGB(180,120,255) or
        (keyType=="weekly"  and Color3.fromRGB(80,180,255)  or Tc.AccentFaint)); makeCorner(5, keyBadge)
    keyBadgeLbl = Instance.new("TextLabel", keyBadge)
    keyBadgeLbl.Size = UDim2.new(1,0,1,0); keyBadgeLbl.BackgroundTransparency = 1
    keyBadgeLbl.TextColor3 = Color3.new(1,1,1); keyBadgeLbl.Font = Enum.Font.GothamBold; keyBadgeLbl.TextSize = 11
    keyNames = {daily=T("type_d"),weekly=T("type_w"),monthly=T("type_m"),lifetime=T("type_l")}
    keyBadgeLbl.Text = keyNames[keyType] or keyType:upper()
    timeLbl = Instance.new("TextLabel", titleBar)
    timeLbl.Size = UDim2.new(0,110,1,0); timeLbl.Position = UDim2.new(0,256,0,0)
    timeLbl.BackgroundTransparency = 1; timeLbl.TextColor3 = Tc.TextFaint
    timeLbl.Font = Enum.Font.GothamMedium; timeLbl.TextSize = 10; timeLbl.TextXAlignment = Enum.TextXAlignment.Left
    timeLbl.Text = formatTimeLeft(keyExpires)
    task.spawn(function() while MainGui and MainGui.Parent do timeLbl.Text = formatTimeLeft(keyExpires); task.wait(60) end end)
    discLbl = Instance.new("TextLabel", titleBar)
    discLbl.Size = UDim2.new(0,160,1,0); discLbl.Position = UDim2.new(0.5,-80,0,0)
    discLbl.BackgroundTransparency = 1; discLbl.Text = ".gg/tCufFEMdux"
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
    function makeTitleBtn(text, bgColor, xOffset)
        local btn = Instance.new("TextButton", titleBar)
        btn.Size = UDim2.new(0,28,0,28); btn.Position = UDim2.new(1,xOffset,0.5,-14)
        btn.BackgroundColor3 = bgColor; btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold; btn.TextSize = 15; btn.Text = text; makeCorner(6, btn)
        return btn
    end
    closeBtn = makeTitleBtn("x", Tc.CloseRed, -36)
    closeBtn.MouseEnter:Connect(function() makeTween(closeBtn,0.1,{BackgroundColor3=Color3.fromRGB(220,70,70)}) end)
    closeBtn.MouseLeave:Connect(function() makeTween(closeBtn,0.1,{BackgroundColor3=Tc.CloseRed}) end)
    closeBtn.MouseButton1Click:Connect(function()
        makeTween(MainFrame,0.18,{BackgroundTransparency=1}); task.wait(0.2)
        MainGui.Enabled = false; MainFrame.BackgroundTransparency = 0
    end)
    minBtn = makeTitleBtn("-", Tc.MinBtn, -70)
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        makeTween(MainFrame, 0.2, {Size = minimized and MENU_MINI or MENU_FULL})
        task.wait(0.05); SideBar.Visible = not minimized; Content.Visible = not minimized
    end)

    -- Sidebar
    SideBar = Instance.new("Frame", MainFrame)
    SideBar.Size = UDim2.new(0,185,1,-46); SideBar.Position = UDim2.new(0,0,0,46)
    SideBar.BackgroundColor3 = Tc.Sidebar; SideBar.BorderSizePixel = 0; makeCorner(10, SideBar)
    sbFix = Instance.new("Frame", SideBar)
    sbFix.Size = UDim2.new(1,0,0.5,0); sbFix.BackgroundColor3 = Tc.Sidebar; sbFix.BorderSizePixel = 0
    sideDiv = Instance.new("Frame", MainFrame)
    sideDiv.Size = UDim2.new(0,1,1,-46); sideDiv.Position = UDim2.new(0,185,0,46)
    sideDiv.BackgroundColor3 = Tc.Accent; sideDiv.BorderSizePixel = 0; sideDiv.BackgroundTransparency = 0.8

    sideButtons = {}
    tabs = getTabList()
    for i, tab in ipairs(tabs) do
        isActive = tab.id == currentTab
        btn = Instance.new("TextButton", SideBar)
        btn.Size = UDim2.new(1,-14,0,34); btn.Position = UDim2.new(0,7,0,3+(i-1)*36)
        btn.BackgroundColor3 = isActive and Tc.ActiveSide or Tc.InactiveSide
        btn.AutoButtonColor = false; btn.BorderSizePixel = 0; btn.Text = ""; makeCorner(7, btn)
        btn:SetAttribute("TabID", tab.id)
        if isActive then
            al = Instance.new("Frame", btn)
            al.Size = UDim2.new(0,3,1,-8); al.Position = UDim2.new(0,2,0,4)
            al.BackgroundColor3 = Tc.BG; al.BorderSizePixel = 0; makeCorner(2, al)
        end
        iconLbl = Instance.new("TextLabel", btn); iconLbl.Name = "IconLbl"
        iconLbl.Size = UDim2.new(0,28,1,0); iconLbl.Position = UDim2.new(0,8,0,0)
        iconLbl.BackgroundTransparency = 1; iconLbl.Text = tab.label:sub(1,1):upper()
        iconLbl.TextColor3 = isActive and Tc.BG or Tc.TextFaint
        iconLbl.Font = Enum.Font.GothamBold; iconLbl.TextSize = 12
        nameLbl = Instance.new("TextLabel", btn); nameLbl.Name = "NameLbl"
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
    dragging, dragStart, startPos = false
    titleBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = i.Position; startPos = MainFrame.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    dragInput = nil
    titleBar.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then dragInput = i end end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i == dragInput then
            local d = i.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
        end
    end)

    -- Yeniden boyutlandir
    resizeHandle = Instance.new("Frame", MainFrame)
    resizeHandle.Size = UDim2.new(0,14,0,14); resizeHandle.Position = UDim2.new(1,-14,1,-14); resizeHandle.BackgroundTransparency = 1
    resizeDot = Instance.new("Frame", resizeHandle)
    resizeDot.Size = UDim2.new(0,5,0,5); resizeDot.Position = UDim2.new(1,-5,1,-5)
    resizeDot.BackgroundColor3 = Tc.Accent; resizeDot.BackgroundTransparency = 0.4; makeCorner(2, resizeDot)
    resizing, resStart, resStartSize = false
    resizeHandle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true; resStart = i.Position
            resStartSize = Vector2.new(MainFrame.AbsoluteSize.X, MainFrame.AbsoluteSize.Y)
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then resizing = false end end)
        end
    end)
    resInput = nil
    resizeHandle.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then resInput = i end end)
    UserInputService.InputChanged:Connect(function(i)
        if resizing and i == resInput then
            local d = i.Position - resStart
            MainFrame.Size = UDim2.new(0,math.clamp(resStartSize.X+d.X,620,1400), 0,math.clamp(resStartSize.Y+d.Y,420,900))
            SideBar.Size = UDim2.new(0,185,1,-46); Content.Size = UDim2.new(1,-186,1,-46)
        end
    end)

    -- Watermark
    createWatermark()
    menuBuilt = true
    ep = MainFrame.Position
    MainFrame.Position = ep + UDim2.new(0,0,0,14); MainFrame.BackgroundTransparency = 1
    makeTween(MainFrame, 0.22, {BackgroundTransparency=0, Position=ep})
    switchTab(currentTab)
end

rebuildMenu = function() menuBuilt = false; createMenu() end

-- ESC ENGELLE - Menu her zaman ESC'nin uzerinde
-- Yontem 1: CoreGui'de oldugundan otomatik ust katmanda
-- Yontem 2: ESC basinca menuyu yeniden gore al
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.Escape then
        if MainGui then
            -- Kucuk gecikme sonra tekrar ac
            task.delay(0.05, function()
                if MainGui then
                    MainGui.Enabled = true
                    if MainFrame then
                        MainFrame.BackgroundTransparency = 0
                    end
                end
            end)
        end
    end
end, true) -- true = gameProcessed olsa bile yakala

-- KEY MENU
keyMenuGui = makeScreenGui("SusanoKeyMenu", 999)

function buildKeyMenu(onSuccess)
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
    subtitleLbl.Text = "v2.2  |  .gg/tCufFEMdux"; subtitleLbl.TextColor3 = Tc.TextFaint
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

    -- Hatirla toggle (varsayilan KAPALI - her giriste key sor)
    local remRow = Instance.new("Frame", card)
    remRow.Size = UDim2.new(1,-32,0,28); remRow.Position = UDim2.new(0,16,0,234); remRow.BackgroundTransparency = 1
    local remLbl = Instance.new("TextLabel", remRow)
    remLbl.Size = UDim2.new(0.78,0,1,0); remLbl.BackgroundTransparency = 1; remLbl.Text = T("key_rem")
    remLbl.TextColor3 = Tc.TextDim; remLbl.Font = Enum.Font.GothamMedium; remLbl.TextSize = 13; remLbl.TextXAlignment = Enum.TextXAlignment.Left
    -- Kayitli key var mi kontrol et
    local savedKeyVal = ""
    pcall(function()
        local ok, content = safeRead(KEY_FILE)
        if ok and content and content ~= "" then savedKeyVal = content:gsub("%s+","") end
    end)
    -- Kayitli key varsa direkt dogrula
    if savedKeyVal ~= "" then
        statusLbl.Text = "Kayitli key dogrulaniyor..."
        task.spawn(function()
            validateKey(savedKeyVal, function(ok2, result, expires)
                if ok2 then
                    keyValidated = true; keyType = result; keyExpires = expires
                    activeKey = savedKeyVal; _G.Verified = true
                    pcall(function() keyMenuGui:Destroy() end)
                    createFOVCircle()
                    createWatermark()
                    task.spawn(function() task.wait(0.05); createMenu() end)
                    onSuccess(result)
                else
                    -- Gecersiz - key girisi goster
                    statusLbl.Text = "Kayitli key gecersiz, yeniden gir"
                    statusLbl.TextColor3 = Tc.KeyRed
                    safeDel(KEY_FILE)
                end
            end)
        end)
    end
    local remOn = true
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
        busy = true; statusLbl.Text = "Dogrulaniyor..."; statusLbl.TextColor3 = Tc.TextDim
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
        if _G.HitboxEnabled then enableHitbox()        end
        if _G.Godmode       then enableGodmode()       end
        if _G.AntiAim       then enableAntiAim()       end
        if _G.NoRecoil      then enableNoRecoil()      end
        if _G.AutoClicker   then enableAutoClicker()   end
        if _G.SpinBot       then enableSpinBot()       end
    end)
end)

-- F5 - Menuyu ac/kapat
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
    if THEMES[currentThemeIndex] then
        local th = THEMES[currentThemeIndex]
        if th.rainbow then
            rainbowHue = (rainbowHue + (_G.RainbowSpeed or 0.002)) % 1
        end
        if th.pulse then
            pulseTime = (pulseTime or 0) + 0.04
            local pv = math.abs(math.sin(pulseTime))
            local rb = hsvToColor(rainbowHue, 1, 0.6 + pv * 0.4)
            Tc.Accent = rb; Tc.ActiveSide = rb
            rainbowHue = (rainbowHue + 0.001) % 1
        end
    end
    -- ESP
    -- ESP throttle: her 3 frame'de bir guncelle (performans)
    espFrameCount = (espFrameCount or 0) + 1
    if _G.ESP and espFrameCount % 2 == 0 then
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
        t = getBestAimTarget("aimbot")
        if t then
            cf = CFrame.new(Camera.CFrame.Position, t.part.Position)
            Camera.CFrame = Camera.CFrame:Lerp(cf, _G.AimbotSmooth)
            aimTarget = t.part; setFOVColor(Color3.fromRGB(80,255,120))
        else aimTarget = nil; setFOVColor(Color3.new(1,1,1)) end
    elseif not _G.RageAimbot then aimTarget = nil; setFOVColor(Color3.new(1,1,1)) end
    -- FOV circle
    if fovCircle then
        r = _G.FOVSize
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
    if _G.AntiAFK        and not antiAfkConn      then enableAntiAFK()       elseif not _G.AntiAFK        and antiAfkConn      then disableAntiAFK()       end
    if _G.ThirdPerson    and not thirdPersonConn  then enableThirdPerson()   elseif not _G.ThirdPerson    and thirdPersonConn  then disableThirdPerson()   end
    if _G.HitboxEnabled  and not hitboxConn       then enableHitbox()        elseif not _G.HitboxEnabled  and hitboxConn       then disableHitbox()        end
    if _G.Godmode        and not godmodeConn1     then enableGodmode()       elseif not _G.Godmode        and godmodeConn1     then disableGodmode()       end
    if _G.FakeLag        and not fakeLagConn      then enableFakeLag()       elseif not _G.FakeLag        and fakeLagConn      then disableFakeLag()       end
    if _G.AntiAim        and not antiAimConn      then enableAntiAim()        elseif not _G.AntiAim        and antiAimConn      then disableAntiAim()       end
    if _G.NoSpread       and not noSpreadConn     then enableNoSpread()       elseif not _G.NoSpread       and noSpreadConn     then disableNoSpread()      end
    if _G.Invisible      then -- Invisible surekli aktif
        if not invisibleConn then enableInvisible() end
    elseif not _G.Invisible and invisibleConn     then disableInvisible()    end
    if _G.NoRecoil       and not noRecoilConn     then enableNoRecoil()       elseif not _G.NoRecoil       and noRecoilConn     then disableNoRecoil()      end
    if _G.AutoClicker    and not autoClickConn    then enableAutoClicker()    elseif not _G.AutoClicker    and autoClickConn    then disableAutoClicker()   end
    if _G.SpinBot        and not spinBotConn      then enableSpinBot()        elseif not _G.SpinBot        and spinBotConn      then disableSpinBot()       end
    if _G.KillFeed       and not killFeedGui      then enableKillFeed()       elseif not _G.KillFeed       and killFeedGui      then disableKillFeed()      end
    if _G.GameSense      and not gameSenseGui     then enableGameSense()      elseif not _G.GameSense      and gameSenseGui     then disableGameSense()     end
    if _G.PlayerGlow     then enablePlayerGlow()   end
    if _G.RainbowMode    then -- handled in enableRainbowMode loop
    else if rainbowModeConn then disableRainbowMode() end end
    if _G.NoSkybox       and not origSkybox         then enableNoSkybox()        end
    if not _G.NoSkybox   and origSkybox             then disableNoSkybox()       end
    if _G.InstantReload  and not instantReloadConn  then enableInstantReload()   elseif not _G.InstantReload  and instantReloadConn  then disableInstantReload()  end
    -- Surekli uygulanan ozellikler
    if _G.GravityHack then Workspace.Gravity = _G.GravityValue else Workspace.Gravity = 196.2 end
    -- Jump hack
    if _G.JumpHack then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.JumpPower ~= _G.JumpPower then hum.JumpPower = _G.JumpPower end
        end
    end
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
setupKeybindFunctions()
startKeybindListener()
enableTeleportCursor()
setupAutoRejoin()
setupAntiScreenshot()
setupPanicKey()
