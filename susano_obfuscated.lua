-- SUSANO V2.1 - FULL BUILD
-- Discord: discord.gg/tCufFEMdux
local t1="ghp_wG4l";local t2="OHjlmUvwum";local t3="ObSMZlppNaGyMq3H3JtpiC"
local CFG={GITHUB_TOKEN=t1..t2..t3,GITHUB_OWNER="CrafyXD",GITHUB_REPO="susano-backend",GITHUB_BRANCH="main"}
local WEBHOOK_URL="https://discord.com/api/webhooks/1486783402656141494/XHOkFNPIw_qH9yjgbZ5KL4pr-WEvbIJbW6Ff7DYueaV2DNoAMU1dvR7dRgKhvaSzsYkb"

-- TEMA
local THEMES={
    {name="Siyah",   bg={12,12,12},   sb={16,16,16},   ac={255,255,255},tb={10,10,10}},
    {name="Lacivert",bg={8,12,28},    sb={12,18,38},   ac={100,160,255},tb={6,10,22}},
    {name="Mor",     bg={16,10,28},   sb={22,14,38},   ac={180,100,255},tb={12,8,22}},
    {name="Yesil",   bg={8,18,10},    sb={10,24,14},   ac={60,220,100}, tb={6,14,8}},
    {name="Kirmizi", bg={22,8,8},     sb={30,10,10},   ac={255,80,80},  tb={18,6,6}},
    {name="Turuncu", bg={22,14,6},    sb={30,18,8},    ac={255,160,40}, tb={18,10,4}},
    {name="Pembe",   bg={22,8,18},    sb={30,10,24},   ac={255,100,200},tb={18,6,14}},
    {name="Beyaz",   bg={220,220,220},sb={200,200,200},ac={30,30,30},   tb={190,190,190}},
    {name="Rainbow", bg={12,12,12},   sb={16,16,16},   ac={255,100,100},tb={10,10,10},rainbow=true},
}
local currentTheme=1
local rainbowHue=0

local function hsvToRgb(h,s,v)
    local r,g,b;local i=math.floor(h*6);local f=h*6-i;local p=v*(1-s);local q=v*(1-f*s);local tv=v*(1-(1-f)*s)
    i=i%6
    if i==0 then r,g,b=v,tv,p elseif i==1 then r,g,b=q,v,p elseif i==2 then r,g,b=p,v,tv
    elseif i==3 then r,g,b=p,q,v elseif i==4 then r,g,b=tv,p,v elseif i==5 then r,g,b=v,p,q end
    return Color3.new(r,g,b)
end

local function rgbC(t) return Color3.fromRGB(t[1],t[2],t[3]) end
local function makeTc()
    local th=THEMES[currentTheme]
    local ac=th.rainbow and hsvToRgb(rainbowHue,1,1) or rgbC(th.ac)
    local bgC=rgbC(th.bg)
    local function lc(c,a) return Color3.new(math.clamp(c.R+a,0,1),math.clamp(c.G+a,0,1),math.clamp(c.B+a,0,1)) end
    return {BG=bgC,Sidebar=rgbC(th.sb),Accent=ac,TitleBar=rgbC(th.tb),Card=lc(bgC,0.06),CardHov=lc(bgC,0.1),AccentDim=Color3.new(ac.R*.6,ac.G*.6,ac.B*.6),AccentFaint=lc(bgC,0.14),Text=Color3.fromRGB(235,235,235),TextDim=Color3.fromRGB(130,130,130),TextFaint=Color3.fromRGB(55,55,55),OffBG=Color3.fromRGB(40,40,40),OnBG=Color3.fromRGB(210,210,210),Border=Color3.fromRGB(32,32,32),BorderLight=Color3.fromRGB(50,50,50),CloseRed=Color3.fromRGB(185,45,45),MinBtn=Color3.fromRGB(42,42,42),ActiveSide=ac,InactiveSide=rgbC(th.sb),KeyGreen=Color3.fromRGB(30,180,80),KeyRed=Color3.fromRGB(200,50,50),KeyGold=Color3.fromRGB(220,180,50)}
end
local Tc=makeTc()

-- DİL
local LANG="TR"
local LANGS={
TR={tab_esp="ESP",tab_aim="Aimbot",tab_move="Hareket",tab_play="Oyuncular",tab_vis="Görsel",tab_misc="Misc",tab_cfg="Config",tab_set="Ayarlar",tab_item="Eşya",tab_team="Takım",
key_btn="GİRİŞ YAP",key_chk="KONTROL...",key_rem="Bu cihazda hatırla",key_ok="Geçerli!",key_err="Bağlanamadı",key_inv="Geçersiz",key_exp="Süresi dolmuş",key_hw="Başka cihaza bağlı",key_many="Çok fazla deneme.",key_enter="Anahtar gir.",
tp_d="GÜNLÜK",tp_w="HAFTALIK",tp_m="AYLIK",tp_l="SINIRSIZ",tu="SINIRSIZ",te="SÜRESİ DOLDU",
s_vis="Görünürlük",s_lbl="Etiketler",s_flt="Filtreler",s_aim="Aimbot",s_sil="Silent Aim",s_fov="FOV",s_smt="Yumuşatma",s_tgt="Hedef",s_fly="Uçuş",s_mov="Hareket",s_bhp="Bunny Hop",s_spd="Hız",s_grav="Yerçekimi",s_tp="Teleport",s_oth="Diğer",s_cmb="Savaş",s_hlp="Yardımcı",s_spf="İsim",s_lit="Aydınlatma",s_cam="Kamera",s_wld="Dünya",s_wc="Dünya Rengi",s_srv="Sunucu",s_prf="Performans",s_cht="Sohbet",s_mm="MiniMap",s_hbx="Hitbox",s_flg="Fake Lag",s_lng="Dil",s_thm="Menü Rengi",s_abt="Hakkında",s_mgb="Magic Bullet",s_god="Godmode",s_itm="Eşya",s_clr="Renk",s_nm="İsim Rengi",s_enm="Düşman Rengi",s_frn="Dost Rengi",s_vsc="Görünür Renk",s_crs="Nişangah",
cfg_sv="Kaydet",cfg_ld="Yükle",cfg_dl="Sil",cfg_no="Kayıtlı config yok.",cfg_ok="Kaydedildi!",cfg_lok="Yüklendi!",cfg_dok="Silindi.",cfg_f="Başarısız.",cfg_n="Config Adı",cfg_ne="İsim gir!",
b_apply="Uygula",b_stop="İzlemeyi Durdur",b_hop="Server Hop",b_tp="TP",b_pull="PULL",b_spec="SPEC",b_frz="FRZ",b_free="FREE",
t_inf_j="Sonsuz Zıplama",t_lng_j="Uzun Atlama (Space)",t_swim="Yüzme Hack",t_noclip="Noclip",t_fly="Uç",t_bhop="Bunny Hop",t_spd="Hız Hack",t_grav="Gravity Hack",t_ctp="Cursor TP (Sağ Tık)",t_stream="Stream Proof",t_esp="ESP Aktif",t_3d="3D Highlight",t_2d="2D Box",t_skel="Skeleton ESP",t_nm="İsim",t_dst="Mesafe",t_hp="Can Çubuğu",t_id="ID",t_trc="Tracer",t_tc="Takım Kontrolü",t_fr="Dost Göster",t_wc="Duvar Kontrolü/Chams",t_aim="Aimbot",t_rage="Rage Aimbot",t_sil="Silent Aim",t_mb="Magic Bullet",t_hbx="Hitbox Büyütme",t_flg="Fake Lag",t_fov="FOV Filtresi",t_fovc="FOV Dairesi",t_ka="Kill Aura",t_afk="Anti AFK",t_ns="İsim Değiştir",t_sb="Stream Proof",t_fb="Full Bright",t_nf="Sis Kaldır",t_fc="FOV Değiştir",t_3p="3. Şahıs",t_tc2="Saat Değiştir",t_wclr="Renk Değiştir",t_rej="Auto Rejoin",t_fps="FPS Boost",t_cl="Chat Logger",t_mm="MiniMap",t_god="Godmode",t_crs="Nişangah",t_dot="Merkez Nokta",t_out="Dış Çizgi",t_dot2="Merkez Nokta",
l_size="Boyut",l_thick="Kalınlık",l_gap="Boşluk",l_opac="Opaklık",l_mul="Çarpan",l_range="Menzil",l_dist="Mesafe",l_speed="Hız",l_power="Güç",l_val="Değer",l_r="Kırmızı",l_g="Yeşil",l_b="Mavi",l_prev="Renk Önizleme",l_fly_s="Uçuş Hızı",l_fov_s="FOV Çapı",l_smt="Yumuşatma",l_hp_s="Can Boyutu",l_lag="Lag Süresi",l_time="Saat (0-23)",l_trdist="3P Mesafe",l_trc_t="Tracer Kalınlık",l_grav="Gravity Değeri",l_bhop_s="BHop Hızı",l_hbx_s="Hitbox Boyutu",l_name="Sahte İsim",
disc="discord.gg/tCufFEMdux"},
EN={tab_esp="ESP",tab_aim="Aimbot",tab_move="Movement",tab_play="Players",tab_vis="Visual",tab_misc="Misc",tab_cfg="Config",tab_set="Settings",tab_item="Items",tab_team="Team",
key_btn="LOGIN",key_chk="CHECKING...",key_rem="Remember on this device",key_ok="Valid!",key_err="Could not connect",key_inv="Invalid key",key_exp="Key expired",key_hw="Bound to another device",key_many="Too many attempts.",key_enter="Enter key.",
tp_d="DAILY",tp_w="WEEKLY",tp_m="MONTHLY",tp_l="LIFETIME",tu="UNLIMITED",te="EXPIRED",
s_vis="Visibility",s_lbl="Labels",s_flt="Filters",s_aim="Aimbot",s_sil="Silent Aim",s_fov="FOV",s_smt="Smoothness",s_tgt="Target",s_fly="Fly",s_mov="Movement",s_bhp="Bunny Hop",s_spd="Speed",s_grav="Gravity",s_tp="Teleport",s_oth="Other",s_cmb="Combat",s_hlp="Helper",s_spf="Name Spoof",s_lit="Lighting",s_cam="Camera",s_wld="World",s_wc="World Color",s_srv="Server",s_prf="Performance",s_cht="Chat",s_mm="MiniMap",s_hbx="Hitbox",s_flg="Fake Lag",s_lng="Language",s_thm="Menu Color",s_abt="About",s_mgb="Magic Bullet",s_god="Godmode",s_itm="Items",s_clr="Color",s_nm="Name Color",s_enm="Enemy Color",s_frn="Friend Color",s_vsc="Visible Color",s_crs="Crosshair",
cfg_sv="Save",cfg_ld="Load",cfg_dl="Delete",cfg_no="No saved configs.",cfg_ok="Saved!",cfg_lok="Loaded!",cfg_dok="Deleted.",cfg_f="Failed.",cfg_n="Config Name",cfg_ne="Enter name!",
b_apply="Apply",b_stop="Stop Spectating",b_hop="Server Hop",b_tp="TP",b_pull="PULL",b_spec="SPEC",b_frz="FRZ",b_free="FREE",
t_inf_j="Infinite Jump",t_lng_j="Long Jump (Space)",t_swim="Swim Hack",t_noclip="Noclip",t_fly="Fly",t_bhop="Bunny Hop",t_spd="Speed Hack",t_grav="Gravity Hack",t_ctp="Cursor TP (Right Click)",t_stream="Stream Proof",t_esp="ESP Active",t_3d="3D Highlight",t_2d="2D Box",t_skel="Skeleton ESP",t_nm="Names",t_dst="Distance",t_hp="Health Bar",t_id="ID",t_trc="Tracer",t_tc="Team Check",t_fr="Show Friends",t_wc="Wall Check/Chams",t_aim="Aimbot",t_rage="Rage Aimbot",t_sil="Silent Aim",t_mb="Magic Bullet",t_hbx="Hitbox Enlargement",t_flg="Fake Lag",t_fov="FOV Filter",t_fovc="FOV Circle",t_ka="Kill Aura",t_afk="Anti AFK",t_ns="Name Spoof",t_sb="Stream Proof",t_fb="Full Bright",t_nf="Remove Fog",t_fc="FOV Changer",t_3p="3rd Person",t_tc2="Time Changer",t_wclr="Change Color",t_rej="Auto Rejoin",t_fps="FPS Boost",t_cl="Chat Logger",t_mm="MiniMap",t_god="Godmode",t_crs="Crosshair",t_dot="Center Dot",t_out="Outline",t_dot2="Center Dot",
l_size="Size",l_thick="Thickness",l_gap="Gap",l_opac="Opacity",l_mul="Multiplier",l_range="Range",l_dist="Distance",l_speed="Speed",l_power="Power",l_val="Value",l_r="Red",l_g="Green",l_b="Blue",l_prev="Color Preview",l_fly_s="Fly Speed",l_fov_s="FOV Size",l_smt="Smoothness",l_hp_s="Health Size",l_lag="Lag Duration",l_time="Time (0-23)",l_trdist="3P Distance",l_trc_t="Tracer Thickness",l_grav="Gravity Value",l_bhop_s="BHop Speed",l_hbx_s="Hitbox Size",l_name="Fake Name",
disc="discord.gg/tCufFEMdux"},
ES={tab_esp="ESP",tab_aim="Aimbot",tab_move="Movimiento",tab_play="Jugadores",tab_vis="Visual",tab_misc="Misc",tab_cfg="Config",tab_set="Ajustes",tab_item="Objetos",tab_team="Equipo",
key_btn="ENTRAR",key_chk="VERIFICANDO...",key_rem="Recordar en este dispositivo",key_ok="Válido!",key_err="Sin conexión",key_inv="Clave inválida",key_exp="Clave expirada",key_hw="Vinculado a otro dispositivo",key_many="Demasiados intentos.",key_enter="Ingresa clave.",
tp_d="DIARIO",tp_w="SEMANAL",tp_m="MENSUAL",tp_l="VITALICIO",tu="ILIMITADO",te="EXPIRADO",
s_vis="Visibilidad",s_lbl="Etiquetas",s_flt="Filtros",s_aim="Aimbot",s_sil="Silent Aim",s_fov="FOV",s_smt="Suavidad",s_tgt="Objetivo",s_fly="Vuelo",s_mov="Movimiento",s_bhp="Bunny Hop",s_spd="Velocidad",s_grav="Gravedad",s_tp="Teleporte",s_oth="Otro",s_cmb="Combate",s_hlp="Ayuda",s_spf="Nombre",s_lit="Iluminación",s_cam="Cámara",s_wld="Mundo",s_wc="Color Mundo",s_srv="Servidor",s_prf="Rendimiento",s_cht="Chat",s_mm="MiniMapa",s_hbx="Hitbox",s_flg="Fake Lag",s_lng="Idioma",s_thm="Color Menú",s_abt="Acerca de",s_mgb="Magic Bullet",s_god="Godmode",s_itm="Objetos",s_clr="Color",s_nm="Color Nombre",s_enm="Color Enemigo",s_frn="Color Amigo",s_vsc="Color Visible",s_crs="Mira",
cfg_sv="Guardar",cfg_ld="Cargar",cfg_dl="Eliminar",cfg_no="Sin configs.",cfg_ok="Guardado!",cfg_lok="Cargado!",cfg_dok="Eliminado.",cfg_f="Fallido.",cfg_n="Nombre Config",cfg_ne="Ingresa nombre!",
b_apply="Aplicar",b_stop="Parar Espectador",b_hop="Saltar Servidor",b_tp="TP",b_pull="JALAR",b_spec="ESPEC",b_frz="CONG",b_free="LIBRE",
t_inf_j="Salto Infinito",t_lng_j="Salto Largo (Espacio)",t_swim="Hack Natación",t_noclip="Noclip",t_fly="Volar",t_bhop="Bunny Hop",t_spd="Hack Velocidad",t_grav="Hack Gravedad",t_ctp="TP Cursor (Clic Der)",t_stream="Stream Proof",t_esp="ESP Activo",t_3d="Resaltado 3D",t_2d="Caja 2D",t_skel="ESP Esqueleto",t_nm="Nombres",t_dst="Distancia",t_hp="Barra Vida",t_id="ID",t_trc="Trazador",t_tc="Control Equipo",t_fr="Mostrar Amigos",t_wc="Control Pared/Chams",t_aim="Aimbot",t_rage="Rage Aimbot",t_sil="Silent Aim",t_mb="Magic Bullet",t_hbx="Agrandar Hitbox",t_flg="Fake Lag",t_fov="Filtro FOV",t_fovc="Círculo FOV",t_ka="Kill Aura",t_afk="Anti AFK",t_ns="Cambiar Nombre",t_sb="Stream Proof",t_fb="Full Bright",t_nf="Sin Niebla",t_fc="Cambiar FOV",t_3p="3ra Persona",t_tc2="Cambiar Hora",t_wclr="Cambiar Color",t_rej="Auto Rejoin",t_fps="FPS Boost",t_cl="Chat Logger",t_mm="MiniMapa",t_god="Godmode",t_crs="Mira",t_dot="Punto Centro",t_out="Contorno",t_dot2="Punto Centro",
l_size="Tamaño",l_thick="Grosor",l_gap="Espacio",l_opac="Opacidad",l_mul="Multiplicador",l_range="Alcance",l_dist="Distancia",l_speed="Velocidad",l_power="Fuerza",l_val="Valor",l_r="Rojo",l_g="Verde",l_b="Azul",l_prev="Vista Color",l_fly_s="Vel Vuelo",l_fov_s="Tamaño FOV",l_smt="Suavidad",l_hp_s="Tamaño Vida",l_lag="Duración Lag",l_time="Hora (0-23)",l_trdist="Dist 3P",l_trc_t="Grosor Trazador",l_grav="Valor Gravedad",l_bhop_s="Vel BHop",l_hbx_s="Tamaño Hitbox",l_name="Nombre Falso",
disc="discord.gg/tCufFEMdux"}}
local function T(k) return LANGS[LANG][k] or k end

local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local Workspace=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local HttpService=game:GetService("HttpService")
local CoreGui=game:GetService("CoreGui")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local ServerStorage=game:GetService("ServerStorage")
local Camera=Workspace.CurrentCamera
local LocalPlayer=Players.LocalPlayer

local GuiParent
pcall(function() local pg=LocalPlayer:FindFirstChildOfClass("PlayerGui");if pg then GuiParent=pg end end)
if not GuiParent then GuiParent=LocalPlayer:WaitForChild("PlayerGui",10) end

local HWID=tostring(LocalPlayer.UserId)
pcall(function() HWID=tostring(game:GetService("RbxAnalyticsService"):GetClientId()) end)
local USERNAME=LocalPlayer.Name
local USER_ID=tostring(LocalPlayer.UserId)

local KEY_FILE="susano_key.txt"
local CFG_FOLDER="susano_configs"
local function safeRead(p) if readfile then return pcall(readfile,p) end;return false,nil end
local function safeWrite(p,d) if writefile then pcall(writefile,p,d) end end
local function safeDel(p) if delfile then pcall(delfile,p) end end
local function safeList(p) if listfiles then local ok,r=pcall(listfiles,p);if ok then return r end end;return {} end
local function safeMkDir(p) if makefolder then pcall(makefolder,p) end end

local function httpReq(method,url,body,headers)
    local ok,resp=pcall(function() return (http_request or request)({Url=url,Method=method,Headers=headers or {},Body=body}) end)
    if not ok or not resp then return false,nil end
    return true,(resp.Body or resp.body or "")
end
local function ghRead(path) return httpReq("GET","https://raw.githubusercontent.com/"..CFG.GITHUB_OWNER.."/"..CFG.GITHUB_REPO.."/"..CFG.GITHUB_BRANCH.."/"..path) end
local function ghWrite(path,content,msg)
    local shaUrl="https://api.github.com/repos/"..CFG.GITHUB_OWNER.."/"..CFG.GITHUB_REPO.."/contents/"..path
    local sha=""
    local ok2,sb=httpReq("GET",shaUrl,nil,{["Authorization"]="token "..CFG.GITHUB_TOKEN,["Accept"]="application/vnd.github.v3+json",["User-Agent"]="Susano"})
    if ok2 and sb then pcall(function() local d=HttpService:JSONDecode(sb);if d and d.sha then sha=d.sha end end) end
    local b64="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local function enc(data) local res={};local pad=(3-#data%3)%3;data=data..string.rep("\0",pad);for i=1,#data,3 do local a,b,c=data:byte(i,i+2);local n=a*65536+b*256+c;res[#res+1]=b64:sub(math.floor(n/262144)%64+1,math.floor(n/262144)%64+1);res[#res+1]=b64:sub(math.floor(n/4096)%64+1,math.floor(n/4096)%64+1);res[#res+1]=b64:sub(math.floor(n/64)%64+1,math.floor(n/64)%64+1);res[#res+1]=b64:sub(n%64+1,n%64+1) end;local r2=table.concat(res);return r2:sub(1,#r2-pad)..string.rep("=",pad) end
    local bodyStr=HttpService:JSONEncode({message=msg or "update",content=enc(content),sha=sha~="" and sha or nil,branch=CFG.GITHUB_BRANCH})
    return httpReq("PUT",shaUrl,bodyStr,{["Authorization"]="token "..CFG.GITHUB_TOKEN,["Accept"]="application/vnd.github.v3+json",["Content-Type"]="application/json",["User-Agent"]="Susano"})
end

-- Webhook
local function wh(title,color,fields)
    if WEBHOOK_URL:find("WEBHOOK_URL_BURAYA") then return end
    local embeds={{title=title,color=color,fields=fields,footer={text="Susano V2.1 | discord.gg/tCufFEMdux"},timestamp=os.date("!%Y-%m-%dT%H:%M:%SZ")}}
    pcall(function() (http_request or request)({Url=WEBHOOK_URL,Method="POST",Headers={["Content-Type"]="application/json"},Body=HttpService:JSONEncode({embeds=embeds})}) end)
end
local function whFeature(feature,state)
    task.spawn(function()
        local avatarUrl="https://www.roblox.com/headshot-thumbnail/image?userId="..USER_ID.."&width=150&height=150&format=png"
        wh((state and "✅" or "❌").." Özellik: "..feature,state and 3066993 or 15158332,{
            {name="👤 Kullanıcı",value="["..USERNAME.."](https://www.roblox.com/users/"..USER_ID.."/profile)",inline=true},
            {name="🆔 Roblox ID",value=USER_ID,inline=true},
            {name="🔑 Key Türü",value=keyType or "?",inline=true},
            {name="💻 HWID",value=HWID:sub(1,25).."...",inline=false},
            {name="🎮 Oyun",value=tostring(game.PlaceId),inline=true},
            {name="⚡ Durum",value=state and "Açıldı" or "Kapatıldı",inline=true},
        })
    end)
end

local keyValidated=false;local keyType="none";local keyExpires=0;local activeKey=""
local function fmtTime(exp)
    if exp==0 then return T("tu") end
    local left=exp-os.time();if left<=0 then return T("te") end
    local d=math.floor(left/86400);local h=math.floor((left%86400)/3600);local m=math.floor((left%3600)/60)
    if d>0 then return d.."g "..h.."s" elseif h>0 then return h.."s "..m.."dk" else return m.."dk" end
end

local function loadKeys()
    local ok,body=ghRead("keys.json");if not ok or not body then return nil end
    local ok2,data=pcall(function() return HttpService:JSONDecode(body) end);if not ok2 then return nil end
    return data
end

local function validateKey(key,callback)
    key=key:upper():gsub("%s+","")
    if key=="" then callback(false,T("key_enter"),0);return end
    task.spawn(function()
        local kd_all=loadKeys()
        if not kd_all then callback(false,T("key_err"),0);return end
        local kd=kd_all[key]
        if not kd then
            task.spawn(function() wh("❌ Geçersiz Key",15158332,{{name="👤 Kullanıcı",value="["..USERNAME.."](https://www.roblox.com/users/"..USER_ID.."/profile)",inline=true},{name="🆔 Roblox ID",value=USER_ID,inline=true},{name="💻 HWID",value=HWID:sub(1,25),inline=false},{name="⌨️ Denenen Key",value=key:sub(1,20),inline=false}}) end)
            callback(false,T("key_inv"),0);return
        end
        if kd.activated and kd.expires and kd.expires>0 and os.time()>kd.expires then callback(false,T("key_exp"),0);return end
        if kd.activated and kd.hwid and tostring(kd.hwid)~="" and tostring(kd.hwid)~="null" then
            if tostring(kd.hwid)~=HWID then
                task.spawn(function() wh("🚫 Yanlış HWID",15158332,{{name="👤 Kullanıcı",value="["..USERNAME.."](https://www.roblox.com/users/"..USER_ID.."/profile)",inline=true},{name="🆔 Roblox ID",value=USER_ID,inline=true},{name="💻 HWID Girilen",value=HWID:sub(1,25),inline=true},{name="🔒 HWID Kayıtlı",value=tostring(kd.hwid):sub(1,25),inline=true}}) end)
                callback(false,T("key_hw"),0);return
            end
        else
            kd_all[key].hwid=HWID;kd_all[key].activated=true
            local dur=kd.duration or 0
            kd_all[key].expires=dur>0 and os.time()+dur or 0
            task.spawn(function()
                local ok3,json=pcall(function() return HttpService:JSONEncode(kd_all) end)
                if ok3 then ghWrite("keys.json",json,"activate:"..USERNAME) end
                local avatarUrl="https://www.roblox.com/headshot-thumbnail/image?userId="..USER_ID.."&width=150&height=150&format=png"
                wh("🎉 Yeni Aktivasyon",3066993,{
                    {name="👤 Kullanıcı",value="["..USERNAME.."](https://www.roblox.com/users/"..USER_ID.."/profile)",inline=true},
                    {name="🆔 Roblox ID",value=USER_ID,inline=true},
                    {name="🔑 Key Türü",value=kd.type or "?",inline=true},
                    {name="💻 HWID",value=HWID:sub(1,30),inline=false},
                    {name="🎮 Oyun",value=tostring(game.PlaceId),inline=true},
                    {name="⏰ Bitiş",value=kd_all[key].expires==0 and "Sınırsız" or os.date("%d.%m.%Y %H:%M",kd_all[key].expires),inline=true},
                    {name="🌐 Sunucu",value=tostring(game.JobId):sub(1,20),inline=false},
                })
                keyExpires=kd_all[key].expires
            end)
        end
        task.spawn(function()
            wh("✅ Key Girişi",3447003,{
                {name="👤 Kullanıcı",value="["..USERNAME.."](https://www.roblox.com/users/"..USER_ID.."/profile)",inline=true},
                {name="🆔 Roblox ID",value=USER_ID,inline=true},
                {name="🔑 Key Türü",value=kd.type or "?",inline=true},
                {name="💻 HWID",value=HWID:sub(1,30),inline=false},
                {name="🎮 Oyun",value=tostring(game.PlaceId),inline=true},
                {name="⏰ Kalan Süre",value=fmtTime(kd_all[key].expires or 0),inline=true},
            })
        end)
        callback(true,kd.type or "lifetime",kd_all[key].expires or 0)
    end)
end

-- GLOBALS
_G.Verified=false
_G.ESP=false;_G.ESPBox3D=false;_G.ESPBox2D=false;_G.ShowNames=false;_G.ShowDistance=false;_G.ShowHealthBar=false;_G.ShowID=false;_G.ShowTracer=false;_G.TracerThick=1.5;_G.TeamCheck=false;_G.ShowFriendly=false;_G.WallCheck=false;_G.SkeletonESP=false
_G.ESPEnemyR=255;_G.ESPEnemyG=60;_G.ESPEnemyB=60;_G.ESPFriendR=80;_G.ESPFriendG=140;_G.ESPFriendB=255;_G.ESPVisR=80;_G.ESPVisG=255;_G.ESPVisB=120
_G.ESPNameR=255;_G.ESPNameG=255;_G.ESPNameB=255
_G.Crosshair=false;_G.CrosshairStyle="Cross";_G.CrosshairSize=12;_G.CrosshairThick=2;_G.CrosshairGap=4;_G.CrosshairAlpha=1.0;_G.CrosshairDot=false;_G.CrosshairOutline=false;_G.CrosshairR=255;_G.CrosshairG=255;_G.CrosshairB=255
_G.Aimbot=false;_G.RageAimbot=false;_G.SilentAim=false;_G.MagicBullet=false;_G.UseFOV=true;_G.FOVVisible=true;_G.FOVSize=120;_G.AimbotSmoothness=0.3;_G.AimbotPartHead=true;_G.AimbotPartChest=false;_G.AimbotPartStomach=false
_G.HitboxEnabled=false;_G.HitboxSize=5;_G.FakeLag=false;_G.FakeLagInterval=0.1
_G.Godmode=false
_G.FlyEnabled=false;_G.FlySpeed=50;_G.NoClipEnabled=false;_G.BunnyHop=false;_G.BunnyHopSpeed=1.2;_G.BunnyHopHeight=7;_G.SpeedHack=false;_G.SpeedMultiplier=2.0;_G.InfiniteJump=false;_G.LongJump=false;_G.LongJumpPower=80;_G.SwimHack=false
_G.GravityHack=false;_G.GravityValue=196.2;_G.TeleportCursor=false
_G.KillAura=false;_G.KillAuraRange=15;_G.AntiAFK=false;_G.NameSpoof=false;_G.SpoofedName="";_G.StreamProof=false
_G.FullBright=false;_G.NoFog=false;_G.FOVChanger=false;_G.FOVChangerVal=200;_G.ThirdPerson=false;_G.ThirdPersonDist=12;_G.TimeChanger=false;_G.TimeOfDay=14;_G.WorldColor=false;_G.WorldR=128;_G.WorldG=128;_G.WorldB=128
_G.AutoRejoin=false;_G.FPSBoost=false;_G.ChatLogger=false;_G.MiniMap=false
local FrozenPlayers={};local chatLogs={}

-- UI HELPERS
local function corner(r,p) local c=Instance.new("UICorner",p);c.CornerRadius=UDim.new(0,r);return c end
local function tw(o,t,pr) TweenService:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quad),pr):Play() end
local function makeScroll(parent) local sc=Instance.new("ScrollingFrame",parent);sc.Size=UDim2.new(1,0,1,0);sc.BackgroundTransparency=1;sc.ScrollBarThickness=3;sc.ScrollBarImageColor3=Color3.fromRGB(60,60,60);sc.CanvasSize=UDim2.new(0,0,0,0);sc.AutomaticCanvasSize=Enum.AutomaticSize.Y;sc.BorderSizePixel=0;return sc end
local function makeGui(name,order)
    pcall(function() local e=GuiParent:FindFirstChild(name);if e then e:Destroy() end end)
    local g=Instance.new("ScreenGui");g.Name=name;g.ResetOnSpawn=false;g.IgnoreGuiInset=true;g.DisplayOrder=order or 200
    pcall(function() g.ZIndexBehavior=Enum.ZIndexBehavior.Global end)
    g.Parent=GuiParent;return g
end

local function buildToggle(parent,label,setting,yPos,onToggle)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-28,0,44);row.Position=UDim2.new(0,14,0,yPos);row.BackgroundColor3=Tc.Card;corner(8,row)
    row.MouseEnter:Connect(function() tw(row,0.1,{BackgroundColor3=Tc.CardHov}) end)
    row.MouseLeave:Connect(function() tw(row,0.1,{BackgroundColor3=Tc.Card}) end)
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(0.72,0,1,0);lbl.Position=UDim2.new(0,12,0,0);lbl.BackgroundTransparency=1;lbl.Text=label;lbl.TextColor3=Tc.Text;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=14;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local pH,pW=24,50
    local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,pW,0,pH);pill.Position=UDim2.new(1,-pW-12,0.5,-pH/2);pill.BackgroundColor3=_G[setting] and Tc.OnBG or Tc.OffBG;corner(pH,pill)
    local knob=Instance.new("Frame",pill);knob.Size=UDim2.new(0,pH-6,0,pH-6);knob.Position=UDim2.new(_G[setting] and 1 or 0,_G[setting] and -(pH-3) or 3,0.5,-(pH-6)/2);knob.BackgroundColor3=_G[setting] and Tc.TitleBar or Tc.AccentDim;corner(100,knob)
    local hit=Instance.new("TextButton",row);hit.Size=UDim2.new(1,0,1,0);hit.BackgroundTransparency=1;hit.Text=""
    hit.MouseButton1Click:Connect(function()
        _G[setting]=not _G[setting]
        tw(pill,0.18,{BackgroundColor3=_G[setting] and Tc.OnBG or Tc.OffBG})
        tw(knob,0.18,{Position=UDim2.new(_G[setting] and 1 or 0,_G[setting] and -(pH-3) or 3,0.5,-(pH-6)/2),BackgroundColor3=_G[setting] and Tc.TitleBar or Tc.AccentDim})
        if onToggle then onToggle(_G[setting]) end
    end)
    return yPos+52
end

local function buildSlider(parent,label,setting,yPos,minV,maxV,fmt,onChange)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-28,0,54);row.Position=UDim2.new(0,14,0,yPos);row.BackgroundColor3=Tc.Card;corner(8,row)
    local function fv(v) return fmt and string.format(fmt,v) or tostring(math.floor(v)) end
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(0.6,0,0,22);lbl.Position=UDim2.new(0,12,0,6);lbl.BackgroundTransparency=1;lbl.Text=label;lbl.TextColor3=Tc.Text;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=13;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local valL=Instance.new("TextLabel",row);valL.Size=UDim2.new(0.35,0,0,22);valL.Position=UDim2.new(0.65,0,0,6);valL.BackgroundTransparency=1;valL.Text=fv(_G[setting]);valL.TextColor3=Tc.TextDim;valL.Font=Enum.Font.GothamMedium;valL.TextSize=12;valL.TextXAlignment=Enum.TextXAlignment.Right
    local track=Instance.new("Frame",row);track.Size=UDim2.new(1,-24,0,3);track.Position=UDim2.new(0,12,1,-14);track.BackgroundColor3=Tc.AccentFaint;corner(3,track)
    local fill=Instance.new("Frame",track);fill.Size=UDim2.new((_G[setting]-minV)/(maxV-minV),0,1,0);fill.BackgroundColor3=Tc.Accent;corner(3,fill)
    local dragging=false
    local function setVal(ix) local relX=math.clamp(ix-track.AbsolutePosition.X,0,track.AbsoluteSize.X);local pct=relX/track.AbsoluteSize.X;_G[setting]=math.floor((minV+pct*(maxV-minV))*100)/100;fill.Size=UDim2.new(pct,0,1,0);valL.Text=fv(_G[setting]);if onChange then onChange(_G[setting]) end end
    track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true;setVal(i.Position.X) end end)
    track.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then setVal(i.Position.X) end end)
    return yPos+62
end

local function buildSec(parent,txt,yPos)
    local lbl=Instance.new("TextLabel",parent);lbl.Size=UDim2.new(1,-28,0,22);lbl.Position=UDim2.new(0,14,0,yPos);lbl.BackgroundTransparency=1;lbl.Text=string.upper(txt);lbl.TextColor3=Tc.TextFaint;lbl.Font=Enum.Font.GothamBold;lbl.TextSize=10;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local line=Instance.new("Frame",parent);line.Size=UDim2.new(1,-28,0,1);line.Position=UDim2.new(0,14,0,yPos+20);line.BackgroundColor3=Tc.Border;line.BorderSizePixel=0
    return yPos+30
end

local function buildInput(parent,label,ph,def,yPos)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-28,0,56);row.Position=UDim2.new(0,14,0,yPos);row.BackgroundColor3=Tc.Card;corner(8,row)
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(1,-16,0,20);lbl.Position=UDim2.new(0,10,0,4);lbl.BackgroundTransparency=1;lbl.Text=label;lbl.TextColor3=Tc.TextDim;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=11;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local box=Instance.new("TextBox",row);box.Size=UDim2.new(1,-20,0,24);box.Position=UDim2.new(0,10,0,26);box.BackgroundColor3=Tc.AccentFaint;box.TextColor3=Tc.Text;box.Font=Enum.Font.Gotham;box.TextSize=13;box.PlaceholderText=ph;box.Text=def or "";box.PlaceholderColor3=Tc.TextFaint;box.ClearTextOnFocus=false;box.BorderSizePixel=0;corner(6,box)
    return box,yPos+64
end

local function buildBtn(parent,label,yPos,bgCol,txtCol)
    local c=bgCol or Tc.Accent;local tc=txtCol or Tc.BG
    local btn=Instance.new("TextButton",parent);btn.Size=UDim2.new(1,-28,0,38);btn.Position=UDim2.new(0,14,0,yPos);btn.BackgroundColor3=c;btn.TextColor3=tc;btn.Font=Enum.Font.GothamBold;btn.TextSize=14;btn.Text=label;corner(8,btn)
    btn.MouseEnter:Connect(function() tw(btn,0.1,{BackgroundColor3=c:Lerp(Color3.new(1,1,1),0.1)}) end)
    btn.MouseLeave:Connect(function() tw(btn,0.1,{BackgroundColor3=c}) end)
    return btn,yPos+46
end

local function buildDrop(parent,label,options,getter,setter,yPos)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-28,0,44);row.Position=UDim2.new(0,14,0,yPos);row.BackgroundColor3=Tc.Card;corner(8,row)
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(0.5,0,1,0);lbl.Position=UDim2.new(0,12,0,0);lbl.BackgroundTransparency=1;lbl.Text=label;lbl.TextColor3=Tc.Text;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=14;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local vBtn=Instance.new("TextButton",row);vBtn.Size=UDim2.new(0,130,0,28);vBtn.Position=UDim2.new(1,-144,0.5,-14);vBtn.BackgroundColor3=Tc.AccentFaint;vBtn.TextColor3=Tc.Text;vBtn.Font=Enum.Font.GothamSemibold;vBtn.TextSize=13;vBtn.Text=getter();corner(7,vBtn)
    vBtn.MouseButton1Click:Connect(function() local cur=getter();local idx=1;for i,v in ipairs(options) do if v==cur then idx=i;break end end;local nxt=options[(idx%#options)+1];setter(nxt);vBtn.Text=nxt end)
    return yPos+52
end

local function buildColorPrev(parent,sR,sG,sB,yPos)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-28,0,36);row.Position=UDim2.new(0,14,0,yPos);row.BackgroundColor3=Tc.Card;corner(8,row)
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(0.5,0,1,0);lbl.Position=UDim2.new(0,12,0,0);lbl.BackgroundTransparency=1;lbl.Text=T("l_prev");lbl.TextColor3=Tc.TextDim;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=13;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local prev=Instance.new("Frame",row);prev.Size=UDim2.new(0,80,0,22);prev.Position=UDim2.new(1,-94,0.5,-11);prev.BackgroundColor3=Color3.fromRGB(_G[sR],_G[sG],_G[sB]);corner(6,prev)
    RunService.Heartbeat:Connect(function() prev.BackgroundColor3=Color3.fromRGB(_G[sR],_G[sG],_G[sB]) end)
    return yPos+44
end

-- FEATURE DECLARATIONS
local enableFly,disableFly,enableNoclip,disableNoclip,enableBhop,disableBhop
local enableSpeed,disableSpeed,enableIJ,disableIJ,enableLJ,disableLJ,enableSwim
local enableKA,disableKA,enableAFK,disableAFK,enableRA,disableRA,enableSA,disableSA
local enableTP3,disableTP3,enableHB,disableHB,applyNS,applyFB,applyNF,applyTime,applyWC
local buildCH,MainGui,switchTab,createMenu,rebuildMenu
local aimTarget=nil

-- Crosshair
local chGui;local CH_STYLES={"Cross","Circle","Dot","T-Shape","X-Shape","Square"}
local function destroyCH() if chGui then chGui:Destroy();chGui=nil end end
buildCH=function()
    destroyCH();if not _G.Crosshair then return end
    chGui=makeGui("SusanoCH",200)
    local col=Color3.fromRGB(_G.CrosshairR,_G.CrosshairG,_G.CrosshairB)
    local s=_G.CrosshairSize;local g=_G.CrosshairGap;local th=_G.CrosshairThick;local al=1-_G.CrosshairAlpha
    local function mkL(w,h,ox,oy) local f=Instance.new("Frame",chGui);f.BackgroundColor3=col;f.BorderSizePixel=0;f.BackgroundTransparency=al;f.Size=UDim2.new(0,w,0,h);f.AnchorPoint=Vector2.new(0.5,0.5);f.Position=UDim2.new(0.5,ox,0.5,oy);f.ZIndex=500;if _G.CrosshairOutline then local os2=Instance.new("UIStroke",f);os2.Color=Color3.new(0,0,0);os2.Thickness=1;os2.Transparency=al+0.3 end;return f end
    local style=_G.CrosshairStyle
    if style=="Cross" then mkL(s,th,-(g+s/2),0);mkL(s,th,(g+s/2),0);mkL(th,s,0,-(g+s/2));mkL(th,s,0,(g+s/2))
    elseif style=="T-Shape" then mkL(s,th,-(g+s/2),0);mkL(s,th,(g+s/2),0);mkL(th,s,0,(g+s/2))
    elseif style=="X-Shape" then local f1=mkL(s,th,0,0);f1.Rotation=45;local f2=mkL(s,th,0,0);f2.Rotation=-45
    elseif style=="Dot" then corner(100,mkL(th*3,th*3,0,0))
    elseif style=="Circle" then local c2=Instance.new("Frame",chGui);c2.Size=UDim2.new(0,s*2,0,s*2);c2.Position=UDim2.new(0.5,-s,0.5,-s);c2.BackgroundTransparency=1;c2.BorderSizePixel=0;c2.ZIndex=500;corner(999,c2);local sk=Instance.new("UIStroke",c2);sk.Color=col;sk.Thickness=th;sk.Transparency=al
    elseif style=="Square" then mkL(s*2,th,0,-s);mkL(s*2,th,0,s);mkL(th,s*2,-s,0);mkL(th,s*2,s,0) end
    if _G.CrosshairDot and style~="Dot" then corner(100,mkL(th+1,th+1,0,0)) end
end

-- FOV
local FOVCircle,FOVGui
local function createFOV()
    if FOVGui then FOVGui:Destroy() end;FOVGui=makeGui("SusanoFOV",200)
    FOVCircle=Instance.new("Frame",FOVGui);local r=_G.FOVSize
    FOVCircle.Size=UDim2.new(0,r*2,0,r*2);FOVCircle.Position=UDim2.new(0.5,-r,0.5,-r);FOVCircle.BackgroundTransparency=1;FOVCircle.BorderSizePixel=0;FOVCircle.ZIndex=999;corner(999,FOVCircle)
    local fs=Instance.new("UIStroke",FOVCircle);fs.Color=Color3.new(1,1,1);fs.Thickness=1;fs.Transparency=0.45;fs.Name="FS";FOVCircle.Visible=_G.FOVVisible
end
local function setFOVColor(col) if FOVCircle then local s=FOVCircle:FindFirstChild("FS");if s then s.Color=col end end end

-- Skeleton
local skelD={}
local BR15={{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"}}
local BR6={{"Head","Torso"},{"Torso","HumanoidRootPart"},{"Torso","Right Arm"},{"Torso","Left Arm"},{"Torso","Right Leg"},{"Torso","Left Leg"}}
local function clearSkel(p) if skelD[p] then for _,l in ipairs(skelD[p]) do pcall(function() l:Remove() end) end;skelD[p]=nil end end
local function updateSkel()
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl==LocalPlayer or not pl.Character then clearSkel(pl);continue end
        if not _G.SkeletonESP or not _G.ESP then clearSkel(pl);continue end
        local friendly=pl.Team and LocalPlayer.Team and pl.Team==LocalPlayer.Team
        local show=(friendly and _G.ShowFriendly) or (not friendly and _G.TeamCheck)
        local hum=pl.Character:FindFirstChildOfClass("Humanoid")
        if not(show and hum and hum.Health>0) then clearSkel(pl);continue end
        local char=pl.Character;local bL=char:FindFirstChild("UpperTorso") and BR15 or BR6
        if not skelD[pl] then skelD[pl]={};for _=1,#bL do local l=Drawing.new("Line");l.Visible=false;l.Thickness=1.5;l.Transparency=0.15;l.Color=Color3.new(1,1,1);table.insert(skelD[pl],l) end end
        local col=friendly and Color3.fromRGB(_G.ESPFriendR,_G.ESPFriendG,_G.ESPFriendB) or Color3.fromRGB(_G.ESPEnemyR,_G.ESPEnemyG,_G.ESPEnemyB)
        for i,bone in ipairs(bL) do local line=skelD[pl][i];if not line then continue end;local p1=char:FindFirstChild(bone[1]);local p2=char:FindFirstChild(bone[2]);if p1 and p2 then local sp1,o1=Camera:WorldToViewportPoint(p1.Position);local sp2,o2=Camera:WorldToViewportPoint(p2.Position);if o1 and o2 then line.Visible=true;line.From=Vector2.new(sp1.X,sp1.Y);line.To=Vector2.new(sp2.X,sp2.Y);line.Color=col else line.Visible=false end else line.Visible=false end end
    end
end

-- Wall Check
local function isVis(pl)
    if not pl.Character then return false end
    local head=pl.Character:FindFirstChild("Head");if not head then return false end
    local origin=Camera.CFrame.Position;local dir=head.Position-origin
    local params=RaycastParams.new();params.FilterDescendantsInstances={LocalPlayer.Character,pl.Character};params.FilterType=Enum.RaycastFilterType.Exclude
    return Workspace:Raycast(origin,dir,params)==nil
end

-- Aimbot helpers
local function getTP(p)
    if not p.Character then return nil end
    if _G.AimbotPartHead then local h=p.Character:FindFirstChild("Head");if h then return h end end
    if _G.AimbotPartChest then local c=p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso");if c then return c end end
    return p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
end
local function getBest()
    local best,bD=nil,math.huge;local center=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
            local fr=p.Team and LocalPlayer.Team and p.Team==LocalPlayer.Team
            if fr and not _G.ShowFriendly then continue end
            if not fr and not _G.TeamCheck then continue end
            local hum=p.Character:FindFirstChildOfClass("Humanoid");if not hum or hum.Health<=0 then continue end
            local part=getTP(p);if not part then continue end
            local sp,onS=Camera:WorldToViewportPoint(part.Position);if not onS then continue end
            local dist=(Vector2.new(sp.X,sp.Y)-center).Magnitude;if _G.UseFOV and dist>_G.FOVSize then continue end
            if dist<bD then bD=dist;best={part=part,player=p} end
        end
    end;return best
end

-- Silent Aim
local saActive=false;local _savedCam=nil;local _saApp=false;local saC1,saC2
enableSA=function()
    saActive=true;if saC1 then saC1:Disconnect() end;if saC2 then saC2:Disconnect() end
    saC1=RunService.Stepped:Connect(function() if not _G.SilentAim or not saActive then _saApp=false;return end;local t=getBest();if t then _savedCam=Camera.CFrame;Camera.CFrame=CFrame.new(Camera.CFrame.Position,t.part.Position);_saApp=true else _saApp=false end end)
    saC2=RunService.RenderStepped:Connect(function() if _saApp and _savedCam then Camera.CFrame=_savedCam;_saApp=false end end)
end
disableSA=function() saActive=false;if saC1 then saC1:Disconnect() end;if saC2 then saC2:Disconnect() end;if _savedCam then Camera.CFrame=_savedCam end end

-- Rage Aimbot
local raActive,raConn=false,nil
disableRA=function() raActive=false;if raConn then raConn:Disconnect();raConn=nil end end
enableRA=function()
    if raActive then return end;raActive=true
    raConn=RunService.RenderStepped:Connect(function()
        if not _G.RageAimbot then disableRA();return end
        local best,bD=nil,math.huge
        for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then local fr=p.Team and LocalPlayer.Team and p.Team==LocalPlayer.Team;if fr and not _G.ShowFriendly then continue end;if not fr and not _G.TeamCheck then continue end;local hum=p.Character:FindFirstChildOfClass("Humanoid");if not hum or hum.Health<=0 then continue end;for _,pn in ipairs({"Head","UpperTorso","Torso","HumanoidRootPart"}) do local part=p.Character:FindFirstChild(pn);if part then local d=(part.Position-Camera.CFrame.Position).Magnitude;if d<bD then bD=d;best=part end end end end end
        if best then Camera.CFrame=CFrame.new(Camera.CFrame.Position,best.Position);setFOVColor(Color3.fromRGB(255,80,80)) else setFOVColor(Color3.new(1,1,1)) end
    end)
end

-- Magic Bullet - RemoteEvent spam ile hasar
local mbConn
local function enableMB()
    if mbConn then mbConn:Disconnect() end
    mbConn=RunService.Heartbeat:Connect(function()
        if not _G.MagicBullet then return end
        local t=getBest();if not t then return end
        local char=t.player.Character;if not char then return end
        -- Tüm RemoteEvent'leri dene
        for _,obj in ipairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                pcall(function() obj:FireServer(char,t.part,t.part.Position,Camera.CFrame.LookVector) end)
                pcall(function() obj:FireServer(t.part.Position) end)
                pcall(function() obj:FireServer(char) end)
            end
        end
        for _,obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                pcall(function() obj:FireServer(char,t.part,t.part.Position) end)
            end
        end
    end)
end
local function disableMB() if mbConn then mbConn:Disconnect();mbConn=nil end end

-- Hitbox
local hbConn
enableHB=function()
    if hbConn then hbConn:Disconnect() end
    hbConn=RunService.Heartbeat:Connect(function()
        if not _G.HitboxEnabled then return end
        for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then local hrp=p.Character:FindFirstChild("HumanoidRootPart");if hrp then pcall(function() hrp.Size=Vector3.new(_G.HitboxSize,_G.HitboxSize,_G.HitboxSize);hrp.Transparency=0.8 end) end end end
    end)
end
disableHB=function() if hbConn then hbConn:Disconnect();hbConn=nil end;for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then local hrp=p.Character:FindFirstChild("HumanoidRootPart");if hrp then pcall(function() hrp.Size=Vector3.new(2,2,1);hrp.Transparency=1 end) end end end end

-- Fake Lag
local flConn
local function enableFL() if flConn then flConn:Disconnect() end;flConn=RunService.Heartbeat:Connect(function() if not _G.FakeLag then return end;task.wait(_G.FakeLagInterval) end) end
local function disableFL() if flConn then flConn:Disconnect();flConn=nil end end

-- Godmode - Client taraflı (can sıfırlanmasını engeller)
local godConn,godHum
local function enableGod()
    if godConn then godConn:Disconnect() end
    local char=LocalPlayer.Character;if not char then return end
    godHum=char:FindFirstChildOfClass("Humanoid");if not godHum then return end
    godHum.BreakJointsOnDeath=false
    godConn=godHum.HealthChanged:Connect(function(hp)
        if _G.Godmode and hp<=0 then
            pcall(function() godHum.Health=godHum.MaxHealth end)
        end
    end)
    -- Ayrıca her frame can dolsun
    local godLoop=RunService.Heartbeat:Connect(function()
        if not _G.Godmode then return end
        if godHum and godHum.Health<godHum.MaxHealth then
            pcall(function() godHum.Health=godHum.MaxHealth end)
        end
    end)
    task.spawn(function() while _G.Godmode and godHum and godHum.Parent do task.wait(0.1) end;godLoop:Disconnect() end)
end
local function disableGod() if godConn then godConn:Disconnect();godConn=nil end end

-- Movement
local ijC;enableIJ=function() if ijC then ijC:Disconnect() end;ijC=UserInputService.JumpRequest:Connect(function() if not _G.InfiniteJump then return end;local c=LocalPlayer.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end) end;disableIJ=function() if ijC then ijC:Disconnect();ijC=nil end end
local ljC;enableLJ=function() if ljC then ljC:Disconnect() end;ljC=UserInputService.JumpRequest:Connect(function() if not _G.LongJump then return end;local c=LocalPlayer.Character;if not c then return end;local hrp=c:FindFirstChild("HumanoidRootPart");local hum=c:FindFirstChildOfClass("Humanoid");if hrp and hum and hum.FloorMaterial~=Enum.Material.Air then local bv=Instance.new("BodyVelocity");bv.Velocity=hrp.CFrame.LookVector*_G.LongJumpPower+Vector3.new(0,30,0);bv.MaxForce=Vector3.new(1e5,1e5,1e5);bv.P=1e4;bv.Parent=hrp;game:GetService("Debris"):AddItem(bv,0.15) end end) end;disableLJ=function() if ljC then ljC:Disconnect();ljC=nil end end
local swC;enableSwim=function() if swC then swC:Disconnect() end;swC=RunService.Stepped:Connect(function() if not _G.SwimHack then return end;local c=LocalPlayer.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid");if hum and hum:GetState()==Enum.HumanoidStateType.Swimming then hum.WalkSpeed=16*_G.SpeedMultiplier end end) end
local bhC,bhA=nil,false;enableBhop=function() if bhA then return end;local c=LocalPlayer.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid");if not hum then return end;bhA=true;bhC=RunService.RenderStepped:Connect(function() if not _G.BunnyHop or not c or not hum then bhA=false;if bhC then bhC:Disconnect() end;return end;if hum.FloorMaterial~=Enum.Material.Air then hum.JumpPower=_G.BunnyHopHeight;hum.Jump=true end;hum.WalkSpeed=hum.MoveDirection.Magnitude>0 and 16*_G.BunnyHopSpeed or 16 end) end;disableBhop=function() bhA=false;if bhC then bhC:Disconnect();bhC=nil end;local c=LocalPlayer.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h.WalkSpeed=16;h.JumpPower=50 end end end
local spC,spA=nil,false;local origSpd=16;enableSpeed=function() if spA then return end;local c=LocalPlayer.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid");if not hum then return end;spA=true;origSpd=hum.WalkSpeed;spC=RunService.RenderStepped:Connect(function() if not _G.SpeedHack or not c or not hum then spA=false;if spC then spC:Disconnect() end;return end;hum.WalkSpeed=origSpd*_G.SpeedMultiplier end) end;disableSpeed=function() spA=false;if spC then spC:Disconnect();spC=nil end;local c=LocalPlayer.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h.WalkSpeed=origSpd end end end
local flyC,flying=nil,false;local bVel,bGyro;enableFly=function() if flying then return end;local c=LocalPlayer.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid");local hrp=c:FindFirstChild("HumanoidRootPart");if not hum or not hrp then return end;flying=true;bVel=Instance.new("BodyVelocity");bVel.MaxForce=Vector3.new(1e5,1e5,1e5);bVel.P=1e4;bVel.Parent=hrp;bGyro=Instance.new("BodyGyro");bGyro.MaxTorque=Vector3.new(1e5,1e5,1e5);bGyro.P=1e4;bGyro.D=100;bGyro.Parent=hrp;flyC=RunService.RenderStepped:Connect(function() if not flying or not hrp then disableFly();return end;bGyro.CFrame=Camera.CFrame;local v=Vector3.zero;local ui=UserInputService;if ui:IsKeyDown(Enum.KeyCode.W) then v=v+Camera.CFrame.LookVector*_G.FlySpeed end;if ui:IsKeyDown(Enum.KeyCode.S) then v=v-Camera.CFrame.LookVector*_G.FlySpeed end;if ui:IsKeyDown(Enum.KeyCode.D) then v=v+Camera.CFrame.RightVector*_G.FlySpeed end;if ui:IsKeyDown(Enum.KeyCode.A) then v=v-Camera.CFrame.RightVector*_G.FlySpeed end;if ui:IsKeyDown(Enum.KeyCode.Space) then v=v+Vector3.new(0,_G.FlySpeed,0) end;if ui:IsKeyDown(Enum.KeyCode.LeftShift) or ui:IsKeyDown(Enum.KeyCode.Q) then v=v-Vector3.new(0,_G.FlySpeed,0) end;bVel.Velocity=v;if hum:GetState()~=Enum.HumanoidStateType.Freefall then hum:ChangeState(Enum.HumanoidStateType.Freefall) end end) end;disableFly=function() flying=false;if flyC then flyC:Disconnect();flyC=nil end;if bVel then bVel:Destroy();bVel=nil end;if bGyro then bGyro:Destroy();bGyro=nil end;local c=LocalPlayer.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h:ChangeState(Enum.HumanoidStateType.Landed) end end end
local ncC,ncA=nil,false;enableNoclip=function() if ncA then return end;ncA=true;ncC=RunService.Stepped:Connect(function() if not ncA or not LocalPlayer.Character then ncA=false;if ncC then ncC:Disconnect() end;return end;for _,p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end end end) end;disableNoclip=function() ncA=false;if ncC then ncC:Disconnect();ncC=nil end;local c=LocalPlayer.Character;if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end end

-- Gravity
local function applyGrav() if _G.GravityHack then Workspace.Gravity=_G.GravityValue else Workspace.Gravity=196.2 end end

-- Teleport Cursor
local tpCursorConn
local function enableTPC()
    if tpCursorConn then tpCursorConn:Disconnect() end
    tpCursorConn=UserInputService.InputBegan:Connect(function(input,gpe)
        if gpe or not _G.TeleportCursor then return end
        if input.UserInputType==Enum.UserInputType.MouseButton2 then
            local ur=Camera:ScreenPointToRay(input.Position.X,input.Position.Y)
            local params=RaycastParams.new();params.FilterDescendantsInstances={LocalPlayer.Character};params.FilterType=Enum.RaycastFilterType.Exclude
            local result=Workspace:Raycast(ur.Origin,ur.Direction*500,params)
            if result and LocalPlayer.Character then local hrp=LocalPlayer.Character:FindFirstChild("HumanoidRootPart");if hrp then hrp.CFrame=CFrame.new(result.Position+Vector3.new(0,3,0)) end end
        end
    end)
end

-- Kill Aura
local kaC;enableKA=function() if kaC then kaC:Disconnect() end;kaC=RunService.Heartbeat:Connect(function() if not _G.KillAura then return end;local c=LocalPlayer.Character;if not c then return end;local hrp=c:FindFirstChild("HumanoidRootPart");if not hrp then return end;local tool=c:FindFirstChildOfClass("Tool");for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then local fr=p.Team and LocalPlayer.Team and p.Team==LocalPlayer.Team;if fr then continue end;local phum=p.Character:FindFirstChildOfClass("Humanoid");local phrp=p.Character:FindFirstChild("HumanoidRootPart");if not phum or not phrp or phum.Health<=0 then continue end;if(phrp.Position-hrp.Position).Magnitude<=_G.KillAuraRange then if tool then for _,child in ipairs(tool:GetDescendants()) do if child:IsA("RemoteEvent") then pcall(function() child:FireServer(p.Character) end) end end;pcall(function() tool:Activate() end) end end end end end) end;disableKA=function() if kaC then kaC:Disconnect();kaC=nil end end

local afkC;enableAFK=function() if afkC then afkC:Disconnect() end;afkC=RunService.Heartbeat:Connect(function() if not _G.AntiAFK then return end;pcall(function() local vu=game:GetService("VirtualUser");vu:CaptureController();vu:ClickButton2(Vector2.new()) end) end) end;disableAFK=function() if afkC then afkC:Disconnect();afkC=nil end end

-- Name Spoof
local nsC
applyNS=function()
    local name=_G.SpoofedName~="" and _G.SpoofedName or LocalPlayer.Name
    local function spoof(char)
        if not char then return end
        local head=char:FindFirstChild("Head");if not head then return end
        for _,gui in ipairs(head:GetChildren()) do if gui:IsA("BillboardGui") and gui.Name~="SusanoNS" then gui.Enabled=not _G.NameSpoof end end
        local ex=head:FindFirstChild("SusanoNS")
        if _G.NameSpoof then
            if not ex then local bb=Instance.new("BillboardGui",head);bb.Name="SusanoNS";bb.AlwaysOnTop=false;bb.Size=UDim2.new(0,250,0,36);bb.StudsOffset=Vector3.new(0,2.2,0);local lbl=Instance.new("TextLabel",bb);lbl.Size=UDim2.new(1,0,1,0);lbl.BackgroundTransparency=1;lbl.TextColor3=Color3.new(1,1,1);lbl.Font=Enum.Font.GothamBold;lbl.TextSize=17;lbl.TextStrokeTransparency=0.5;lbl.Name="NSL" end
            local lbl=head.SusanoNS:FindFirstChild("NSL");if lbl then lbl.Text=name end
            pcall(function() LocalPlayer.DisplayName=name end)
        else
            if ex then ex:Destroy() end
            for _,gui in ipairs(head:GetChildren()) do if gui:IsA("BillboardGui") then gui.Enabled=true end end
            pcall(function() LocalPlayer.DisplayName=LocalPlayer.Name end)
        end
    end
    spoof(LocalPlayer.Character)
    if nsC then nsC:Disconnect() end
    if _G.NameSpoof then nsC=LocalPlayer.CharacterAdded:Connect(function(char) task.wait(0.5);spoof(char) end) end
end

-- Visual
local oAmb=Lighting.Ambient;local oBrg=Lighting.Brightness;local oFE=Lighting.FogEnd;local oFS=Lighting.FogStart;local oCFOV=Camera.FieldOfView;local oTOD=Lighting.TimeOfDay;local oCS=Lighting.ColorShift_Top
applyFB=function(v) if v then Lighting.Ambient=Color3.new(1,1,1);Lighting.Brightness=2;for _,e in ipairs(Lighting:GetChildren()) do if e:IsA("BlurEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("SunRaysEffect") or e:IsA("BloomEffect") then e.Enabled=false end end else Lighting.Ambient=oAmb;Lighting.Brightness=oBrg end end
applyNF=function(v) if v then Lighting.FogEnd=1e6;Lighting.FogStart=1e6 else Lighting.FogEnd=oFE;Lighting.FogStart=oFS end end
applyTime=function(v) if v then Lighting.TimeOfDay=string.format("%02d:00:00",math.floor(_G.TimeOfDay)) else Lighting.TimeOfDay=oTOD end end
applyWC=function(v) if v then Lighting.ColorShift_Top=Color3.fromRGB(_G.WorldR,_G.WorldG,_G.WorldB) else Lighting.ColorShift_Top=oCS end end
local tpC;enableTP3=function() Camera.CameraType=Enum.CameraType.Scriptable;if tpC then tpC:Disconnect() end;tpC=RunService.RenderStepped:Connect(function() if not _G.ThirdPerson then disableTP3();return end;local c=LocalPlayer.Character;if not c then return end;local hrp=c:FindFirstChild("HumanoidRootPart");if not hrp then return end;local d=_G.ThirdPersonDist;Camera.CFrame=CFrame.new(hrp.CFrame.Position-hrp.CFrame.LookVector*d+Vector3.new(0,d*0.4,0),hrp.Position) end) end;disableTP3=function() if tpC then tpC:Disconnect();tpC=nil end;Camera.CameraType=Enum.CameraType.Custom end

-- Auto Rejoin
local function setupARej() game:GetService("Players").PlayerRemoving:Connect(function(p) if p==LocalPlayer and _G.AutoRejoin then task.wait(3);pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId,LocalPlayer) end) end end) end

-- Server Hop
local function serverHop()
    task.spawn(function()
        local ok,result=pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")) end)
        if ok and result and result.data then for _,s in ipairs(result.data) do if s.id~=game.JobId and s.playing<s.maxPlayers then pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,s.id,LocalPlayer) end);return end end end
    end)
end

-- FPS Boost
local fpsA=false;local hidP={}
local function enableFPS() if fpsA then return end;fpsA=true;for _,obj in ipairs(Workspace:GetDescendants()) do if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then pcall(function() obj.Enabled=false;table.insert(hidP,obj) end) end end;Lighting.GlobalShadows=false end
local function disableFPS() fpsA=false;for _,obj in ipairs(hidP) do pcall(function() obj.Enabled=true end) end;hidP={};Lighting.GlobalShadows=true end

-- Chat Logger
local clC,clGui
local function enableCL()
    if clGui then return end
    clGui=makeGui("SusanoCL",100)
    local frame=Instance.new("Frame",clGui);frame.Size=UDim2.new(0,300,0,180);frame.Position=UDim2.new(0,10,1,-200);frame.BackgroundColor3=Color3.fromRGB(10,10,10);frame.BackgroundTransparency=0.2;frame.BorderSizePixel=0;corner(8,frame)
    local title=Instance.new("TextLabel",frame);title.Size=UDim2.new(1,0,0,22);title.BackgroundColor3=Color3.fromRGB(15,15,15);title.BackgroundTransparency=0;title.Text="💬 Chat Log";title.TextColor3=Color3.new(1,1,1);title.Font=Enum.Font.GothamBold;title.TextSize=12;corner(8,title)
    local sc=Instance.new("ScrollingFrame",frame);sc.Size=UDim2.new(1,-6,1,-26);sc.Position=UDim2.new(0,3,0,24);sc.BackgroundTransparency=1;sc.ScrollBarThickness=2;sc.CanvasSize=UDim2.new(0,0,0,0);sc.AutomaticCanvasSize=Enum.AutomaticSize.Y;sc.BorderSizePixel=0
    Instance.new("UIListLayout",sc).Padding=UDim.new(0,2)
    local function addLog(pName,msg)
        local txt=os.date("%H:%M").." ["..pName.."] "..msg
        table.insert(chatLogs,txt)
        local lbl=Instance.new("TextLabel",sc);lbl.Size=UDim2.new(1,-4,0,16);lbl.BackgroundTransparency=1;lbl.Text=txt:sub(1,45);lbl.TextColor3=Color3.fromRGB(200,200,200);lbl.Font=Enum.Font.Gotham;lbl.TextSize=11;lbl.TextXAlignment=Enum.TextXAlignment.Left;lbl.TextWrapped=true
    end
    -- Mevcut oyuncuları bağla
    for _,p in ipairs(Players:GetPlayers()) do
        p.Chatted:Connect(function(msg) if _G.ChatLogger then addLog(p.Name,msg) end end)
    end
    -- Yeni oyuncuları bağla
    clC=Players.PlayerAdded:Connect(function(p)
        p.Chatted:Connect(function(msg) if _G.ChatLogger then addLog(p.Name,msg) end end)
    end)
end
local function disableCL() if clC then clC:Disconnect();clC=nil end;if clGui then clGui:Destroy();clGui=nil end end

-- MiniMap
local mmGui,mmC,mmD
local function enableMM()
    if mmGui then return end;mmGui=makeGui("SusanoMM",150);mmD={}
    local sz=180;local frame=Instance.new("Frame",mmGui);frame.Size=UDim2.new(0,sz,0,sz);frame.Position=UDim2.new(1,-sz-10,0,10);frame.BackgroundColor3=Color3.fromRGB(10,10,10);frame.BackgroundTransparency=0.15;frame.BorderSizePixel=0;corner(90,frame)
    local brd=Instance.new("UIStroke",frame);brd.Color=Tc.Accent;brd.Thickness=1.5;brd.Transparency=0.5
    local rtl=Instance.new("TextLabel",frame);rtl.Size=UDim2.new(1,0,0,14);rtl.BackgroundTransparency=1;rtl.Text="RADAR";rtl.TextColor3=Tc.Accent;rtl.Font=Enum.Font.GothamBold;rtl.TextSize=9
    local cDot=Instance.new("Frame",frame);cDot.Size=UDim2.new(0,8,0,8);cDot.AnchorPoint=Vector2.new(0.5,0.5);cDot.Position=UDim2.new(0.5,0,0.5,0);cDot.BackgroundColor3=Color3.new(1,1,1);cDot.BorderSizePixel=0;corner(4,cDot)
    if mmC then mmC:Disconnect() end
    mmC=RunService.RenderStepped:Connect(function()
        if not _G.MiniMap then return end
        local myHRP=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");if not myHRP then return end
        local aP={};for _,p in ipairs(Players:GetPlayers()) do aP[p]=true end
        for p,dot in pairs(mmD) do if not aP[p] then dot:Destroy();mmD[p]=nil end end
        for _,p in ipairs(Players:GetPlayers()) do
            if p==LocalPlayer or not p.Character then continue end
            local hrp=p.Character:FindFirstChild("HumanoidRootPart");if not hrp then continue end
            local diff=hrp.Position-myHRP.Position;local range=200
            local nx=math.clamp(diff.X/range,-0.5,0.5);local nz=math.clamp(diff.Z/range,-0.5,0.5)
            if not mmD[p] then
                local dot=Instance.new("Frame",frame);dot.Size=UDim2.new(0,6,0,6);dot.AnchorPoint=Vector2.new(0.5,0.5);dot.BorderSizePixel=0;corner(3,dot)
                local nl=Instance.new("TextLabel",dot);nl.Size=UDim2.new(0,60,0,12);nl.Position=UDim2.new(1,2,0,-2);nl.BackgroundTransparency=1;nl.Text=p.Name:sub(1,7);nl.TextColor3=Color3.new(1,1,1);nl.Font=Enum.Font.GothamBold;nl.TextSize=8;nl.TextXAlignment=Enum.TextXAlignment.Left
                mmD[p]=dot
            end
            local fr=p.Team and LocalPlayer.Team and p.Team==LocalPlayer.Team
            mmD[p].BackgroundColor3=fr and Color3.fromRGB(80,180,255) or Color3.fromRGB(255,80,80)
            mmD[p].Position=UDim2.new(0.5+nx,0,0.5+nz,0)
        end
    end)
end
local function disableMM() if mmC then mmC:Disconnect();mmC=nil end;if mmGui then mmGui:Destroy();mmGui=nil;mmD=nil end end

-- ESP
local espC,esp2,espTr={},{},{}
local function clearEspD(p) if esp2[p] then for _,v in pairs(esp2[p]) do pcall(function() v.Visible=false;v:Remove() end) end;esp2[p]=nil end;if espTr[p] then pcall(function() espTr[p].Visible=false;espTr[p]:Remove() end);espTr[p]=nil end end
local function clearEspP(p) if espC[p] then if espC[p].hl then pcall(function() espC[p].hl:Destroy() end) end;if espC[p].bb then pcall(function() espC[p].bb:Destroy() end) end;if espC[p].hb then pcall(function() espC[p].hb:Destroy() end) end;espC[p]=nil end;clearEspD(p);clearSkel(p) end
local function clearAllEsp() for p in pairs(espC) do clearEspP(p) end;for p in pairs(esp2) do clearEspD(p) end end
local function buildEsp(pl)
    if not _G.ESP or pl==LocalPlayer or espC[pl] then return end
    local char=pl.Character;if not char then return end
    local hrp=char:WaitForChild("HumanoidRootPart",5);if not hrp then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    local hl=Instance.new("Highlight");hl.Adornee=char;hl.FillTransparency=0.75;hl.OutlineColor=Color3.new(1,1,1);hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;hl.Enabled=false;hl.Parent=CoreGui
    local bb=Instance.new("BillboardGui");bb.Size=UDim2.new(6,0,3,0);bb.AlwaysOnTop=true;bb.StudsOffset=Vector3.new(0,4,0);bb.Adornee=hrp;bb.Enabled=false;bb.Parent=CoreGui
    local function lbl4(pos,sz,col,fs) local l=Instance.new("TextLabel",bb);l.Size=UDim2.new(1,0,sz,0);l.Position=UDim2.new(0,0,pos,0);l.BackgroundTransparency=1;l.TextColor3=col;l.Font=Enum.Font.GothamBold;l.TextSize=fs;l.TextStrokeTransparency=0.4;return l end
    local idLbl=lbl4(0,0.3,Color3.fromRGB(160,160,255),12)
    local nameLbl=lbl4(0.3,0.4,Color3.fromRGB(_G.ESPNameR,_G.ESPNameG,_G.ESPNameB),16)
    local dstLbl=lbl4(0.7,0.3,Color3.fromRGB(255,220,80),12)
    local hbBB=Instance.new("BillboardGui");hbBB.Size=UDim2.new(0.4,0,2,0);hbBB.AlwaysOnTop=true;hbBB.StudsOffset=Vector3.new(-1.8,2,0);hbBB.Adornee=hrp;hbBB.Enabled=false;hbBB.Parent=CoreGui
    local hbBG=Instance.new("Frame",hbBB);hbBG.Size=UDim2.new(0,4,1,0);hbBG.BackgroundColor3=Color3.fromRGB(20,20,20);hbBG.BorderSizePixel=0
    local hbF=Instance.new("Frame",hbBG);hbF.Size=UDim2.new(1,0,1,0);hbF.BackgroundColor3=Color3.fromRGB(80,255,120);hbF.BorderSizePixel=0
    espC[pl]={hl=hl,bb=bb,hb=hbBB,hbBG=hbBG,hbF=hbF,idL=idLbl,nmL=nameLbl,dsL=dstLbl,hrp=hrp,hum=hum}
    local e={};e.box=Drawing.new("Square");e.box.Visible=false;e.box.Thickness=1.5;e.box.Filled=false;e.nm=Drawing.new("Text");e.nm.Visible=false;e.nm.Size=14;e.nm.Font=2;e.nm.Center=true;e.ds=Drawing.new("Text");e.ds.Visible=false;e.ds.Size=12;e.ds.Font=2;e.ds.Center=true;e.ds.Color=Color3.fromRGB(255,220,80);e.id=Drawing.new("Text");e.id.Visible=false;e.id.Size=11;e.id.Font=2;e.id.Center=true;e.id.Color=Color3.fromRGB(160,160,255);e.hbg=Drawing.new("Square");e.hbg.Visible=false;e.hbg.Filled=true;e.hbg.Color=Color3.fromRGB(20,20,20);e.hbf=Drawing.new("Square");e.hbf.Visible=false;e.hbf.Filled=true;esp2[pl]=e
    local tr=Drawing.new("Line");tr.Visible=false;tr.Thickness=_G.TracerThick;tr.Transparency=0.3;espTr[pl]=tr
end
local function updateEsp()
    if not _G.ESP then clearAllEsp();return end
    local myHRP=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");if not myHRP then return end
    local cE=Color3.fromRGB(_G.ESPEnemyR,_G.ESPEnemyG,_G.ESPEnemyB);local cF=Color3.fromRGB(_G.ESPFriendR,_G.ESPFriendG,_G.ESPFriendB);local cV=Color3.fromRGB(_G.ESPVisR,_G.ESPVisG,_G.ESPVisB);local cN=Color3.fromRGB(_G.ESPNameR,_G.ESPNameG,_G.ESPNameB)
    local aP={};for _,p in ipairs(Players:GetPlayers()) do aP[p]=true end
    for p in pairs(espC) do if not aP[p] then clearEspP(p) end end
    for pl,cache in pairs(espC) do
        if not(pl and pl.Parent and cache.hrp and cache.hrp.Parent) then clearEspP(pl);continue end
        local char=pl.Character;local hum=char and char:FindFirstChildOfClass("Humanoid");local hrp=cache.hrp
        local dist=(hrp.Position-myHRP.Position).Magnitude
        local fr=pl.Team and LocalPlayer.Team and pl.Team==LocalPlayer.Team
        local show=(fr and _G.ShowFriendly) or (not fr and _G.TeamCheck);if not(show and hum and hum.Health>0) then show=false end
        local vis=false;if _G.WallCheck and show and not fr then vis=isVis(pl) end
        local col=fr and cF or(_G.WallCheck and (vis and cV or cE) or cE)
        if cache.hl then cache.hl.Enabled=_G.ESPBox3D and show;if cache.hl.Enabled then cache.hl.FillColor=col;cache.hl.OutlineColor=col;cache.hl.DepthMode=(_G.WallCheck and vis) and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop end end
        if cache.bb then cache.bb.Enabled=show;if show then cache.idL.Visible=_G.ShowID;cache.idL.Text="ID:"..pl.UserId;cache.nmL.Visible=_G.ShowNames;cache.nmL.Text=pl.Name;cache.nmL.TextColor3=cN;cache.dsL.Visible=_G.ShowDistance;cache.dsL.Text=math.floor(dist).."m" end end
        if cache.hb then cache.hb.Enabled=_G.ShowHealthBar and show;if cache.hb.Enabled and hum and hum.Health>0 then local pct=hum.Health/hum.MaxHealth;cache.hbF.Size=UDim2.new(1,0,pct,0);cache.hbF.Position=UDim2.new(0,0,1-pct,0);cache.hbF.BackgroundColor3=pct>0.6 and Color3.fromRGB(80,255,120) or(pct>0.3 and Color3.fromRGB(255,220,80) or Color3.fromRGB(255,80,80)) end end
        local e=esp2[pl]
        if e then
            if _G.ESPBox2D and show then
                local sp,onSc=Camera:WorldToViewportPoint(hrp.Position)
                if onSc then
                    local head=char:FindFirstChild("Head")
                    if head then
                        local sh=Camera:WorldToViewportPoint(head.Position);local h=math.abs(sh.Y-sp.Y)*2.3;local w=h*0.55;local tl=Vector2.new(sp.X-w/2,sh.Y-h/2)
                        e.box.Visible=true;e.box.Position=tl;e.box.Size=Vector2.new(w,h);e.box.Color=col
                        if _G.ShowNames then e.nm.Visible=true;e.nm.Position=Vector2.new(sp.X,sh.Y-h/2-18);e.nm.Text=pl.Name;e.nm.Color=cN else e.nm.Visible=false end
                        if _G.ShowDistance then e.ds.Visible=true;e.ds.Position=Vector2.new(sp.X,sh.Y+h/2+4);e.ds.Text=math.floor(dist).."m" else e.ds.Visible=false end
                        if _G.ShowID then e.id.Visible=true;e.id.Position=Vector2.new(sp.X,sh.Y-h/2-32);e.id.Text="ID:"..pl.UserId else e.id.Visible=false end
                        if _G.ShowHealthBar and hum and hum.Health>0 then local pct=hum.Health/hum.MaxHealth;e.hbg.Visible=true;e.hbg.Position=Vector2.new(tl.X-7,tl.Y);e.hbg.Size=Vector2.new(3,h);e.hbf.Visible=true;e.hbf.Position=Vector2.new(tl.X-7,tl.Y+h*(1-pct));e.hbf.Size=Vector2.new(3,h*pct);e.hbf.Color=pct>0.6 and Color3.fromRGB(80,255,120) or(pct>0.3 and Color3.fromRGB(255,220,80) or Color3.fromRGB(255,80,80)) else e.hbg.Visible=false;e.hbf.Visible=false end
                    else for _,v in pairs(e) do pcall(function() v.Visible=false end) end end
                else for _,v in pairs(e) do pcall(function() v.Visible=false end) end end
            else for _,v in pairs(e) do pcall(function() v.Visible=false end) end end
        end
        local tr=espTr[pl];if tr then tr.Thickness=_G.TracerThick;if _G.ShowTracer and show then local sp,onSc=Camera:WorldToViewportPoint(hrp.Position);if onSc then tr.Visible=true;tr.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y);tr.To=Vector2.new(sp.X,sp.Y);tr.Color=col else tr.Visible=false end else tr.Visible=false end end
    end
end
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() if _G.ESP then task.wait(1);buildEsp(p) end end);p.CharacterRemoving:Connect(function() clearEspP(p) end) end)
Players.PlayerRemoving:Connect(function(p) clearEspP(p) end)
for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then p.CharacterAdded:Connect(function() if _G.ESP then task.wait(1);buildEsp(p) end end);if p.Character and _G.ESP then buildEsp(p) end;p.CharacterRemoving:Connect(function() clearEspP(p) end) end end

-- LOCAL CONFIG
local function buildCfgData()
    return {ESP=_G.ESP,ESPBox3D=_G.ESPBox3D,ESPBox2D=_G.ESPBox2D,ShowNames=_G.ShowNames,ShowDistance=_G.ShowDistance,ShowHealthBar=_G.ShowHealthBar,ShowID=_G.ShowID,ShowTracer=_G.ShowTracer,TracerThick=_G.TracerThick,TeamCheck=_G.TeamCheck,ShowFriendly=_G.ShowFriendly,WallCheck=_G.WallCheck,SkeletonESP=_G.SkeletonESP,ESPEnemyR=_G.ESPEnemyR,ESPEnemyG=_G.ESPEnemyG,ESPEnemyB=_G.ESPEnemyB,ESPFriendR=_G.ESPFriendR,ESPFriendG=_G.ESPFriendG,ESPFriendB=_G.ESPFriendB,ESPVisR=_G.ESPVisR,ESPVisG=_G.ESPVisG,ESPVisB=_G.ESPVisB,ESPNameR=_G.ESPNameR,ESPNameG=_G.ESPNameG,ESPNameB=_G.ESPNameB,Crosshair=_G.Crosshair,CrosshairStyle=_G.CrosshairStyle,CrosshairSize=_G.CrosshairSize,CrosshairThick=_G.CrosshairThick,CrosshairGap=_G.CrosshairGap,CrosshairAlpha=_G.CrosshairAlpha,CrosshairDot=_G.CrosshairDot,CrosshairOutline=_G.CrosshairOutline,CrosshairR=_G.CrosshairR,CrosshairG=_G.CrosshairG,CrosshairB=_G.CrosshairB,Aimbot=_G.Aimbot,RageAimbot=_G.RageAimbot,SilentAim=_G.SilentAim,MagicBullet=_G.MagicBullet,UseFOV=_G.UseFOV,FOVVisible=_G.FOVVisible,FOVSize=_G.FOVSize,AimbotSmoothness=_G.AimbotSmoothness,AimbotPartHead=_G.AimbotPartHead,AimbotPartChest=_G.AimbotPartChest,AimbotPartStomach=_G.AimbotPartStomach,HitboxEnabled=_G.HitboxEnabled,HitboxSize=_G.HitboxSize,FakeLag=_G.FakeLag,FakeLagInterval=_G.FakeLagInterval,FlyEnabled=_G.FlyEnabled,FlySpeed=_G.FlySpeed,NoClipEnabled=_G.NoClipEnabled,BunnyHop=_G.BunnyHop,BunnyHopSpeed=_G.BunnyHopSpeed,BunnyHopHeight=_G.BunnyHopHeight,SpeedHack=_G.SpeedHack,SpeedMultiplier=_G.SpeedMultiplier,InfiniteJump=_G.InfiniteJump,LongJump=_G.LongJump,LongJumpPower=_G.LongJumpPower,SwimHack=_G.SwimHack,GravityHack=_G.GravityHack,GravityValue=_G.GravityValue,TeleportCursor=_G.TeleportCursor,KillAura=_G.KillAura,KillAuraRange=_G.KillAuraRange,AntiAFK=_G.AntiAFK,NameSpoof=_G.NameSpoof,SpoofedName=_G.SpoofedName,FullBright=_G.FullBright,NoFog=_G.NoFog,FOVChanger=_G.FOVChanger,FOVChangerVal=_G.FOVChangerVal,ThirdPerson=_G.ThirdPerson,ThirdPersonDist=_G.ThirdPersonDist,TimeChanger=_G.TimeChanger,TimeOfDay=_G.TimeOfDay,WorldColor=_G.WorldColor,WorldR=_G.WorldR,WorldG=_G.WorldG,WorldB=_G.WorldB}
end
local function applyCfgData(data) for k,v in pairs(data) do _G[k]=v end end
local function listCfgs() local r={};for _,f in ipairs(safeList(CFG_FOLDER)) do local n=f:match("([^/\\]+)%.json$");if n then table.insert(r,n) end end;return r end
local function saveCfg(name) safeMkDir(CFG_FOLDER);local ok,json=pcall(function() return HttpService:JSONEncode(buildCfgData()) end);if not ok then return false end;safeWrite(CFG_FOLDER.."/"..name..".json",json);return true end
local function loadCfg(name) local ok,c=safeRead(CFG_FOLDER.."/"..name..".json");if not ok or not c then return false end;local ok2,data=pcall(function() return HttpService:JSONDecode(c) end);if not ok2 then return false end;applyCfgData(data);return true end
local function delCfg(name) safeDel(CFG_FOLDER.."/"..name..".json") end

-- TAB BUILDERS
local tabBuilders={}

tabBuilders["ESP"]=function(p)
    local sc=makeScroll(p);local y=10
    y=buildSec(sc,T("s_vis"),y)
    y=buildToggle(sc,T("t_esp"),"ESP",y,function(v) if not v then clearAllEsp() end end)
    y=buildToggle(sc,T("t_3d"),"ESPBox3D",y)
    y=buildToggle(sc,T("t_2d"),"ESPBox2D",y)
    y=buildToggle(sc,T("t_skel"),"SkeletonESP",y)
    y=buildSec(sc,T("s_lbl"),y+4)
    y=buildToggle(sc,T("t_nm"),"ShowNames",y)
    y=buildToggle(sc,T("t_dst"),"ShowDistance",y)
    y=buildToggle(sc,T("t_hp"),"ShowHealthBar",y)
    y=buildToggle(sc,T("t_id"),"ShowID",y)
    y=buildToggle(sc,T("t_trc"),"ShowTracer",y)
    y=buildSlider(sc,T("l_trc_t"),"TracerThick",y,0.5,6,"%.1f")
    y=buildSec(sc,T("s_flt"),y+4)
    y=buildToggle(sc,T("t_tc"),"TeamCheck",y)
    y=buildToggle(sc,T("t_fr"),"ShowFriendly",y)
    y=buildToggle(sc,T("t_wc"),"WallCheck",y)
    y=buildSec(sc,T("s_nm"),y+4)
    y=buildColorPrev(sc,"ESPNameR","ESPNameG","ESPNameB",y)
    y=buildSlider(sc,T("l_r"),"ESPNameR",y,0,255,nil)
    y=buildSlider(sc,T("l_g"),"ESPNameG",y,0,255,nil)
    y=buildSlider(sc,T("l_b"),"ESPNameB",y,0,255,nil)
    y=buildSec(sc,T("s_enm"),y+4)
    y=buildColorPrev(sc,"ESPEnemyR","ESPEnemyG","ESPEnemyB",y)
    y=buildSlider(sc,T("l_r"),"ESPEnemyR",y,0,255,nil)
    y=buildSlider(sc,T("l_g"),"ESPEnemyG",y,0,255,nil)
    y=buildSlider(sc,T("l_b"),"ESPEnemyB",y,0,255,nil)
    y=buildSec(sc,T("s_frn"),y+4)
    y=buildColorPrev(sc,"ESPFriendR","ESPFriendG","ESPFriendB",y)
    y=buildSlider(sc,T("l_r"),"ESPFriendR",y,0,255,nil)
    y=buildSlider(sc,T("l_g"),"ESPFriendG",y,0,255,nil)
    y=buildSlider(sc,T("l_b"),"ESPFriendB",y,0,255,nil)
    y=buildSec(sc,T("s_vsc"),y+4)
    y=buildColorPrev(sc,"ESPVisR","ESPVisG","ESPVisB",y)
    y=buildSlider(sc,T("l_r"),"ESPVisR",y,0,255,nil)
    y=buildSlider(sc,T("l_g"),"ESPVisG",y,0,255,nil)
    y=buildSlider(sc,T("l_b"),"ESPVisB",y,0,255,nil)
    y=buildSec(sc,T("s_crs"),y+4)
    y=buildToggle(sc,T("t_crs"),"Crosshair",y,function() buildCH() end)
    y=buildDrop(sc,"Stil",CH_STYLES,function() return _G.CrosshairStyle end,function(v) _G.CrosshairStyle=v;buildCH() end,y)
    y=buildSlider(sc,T("l_size"),"CrosshairSize",y,4,50,nil,function() buildCH() end)
    y=buildSlider(sc,T("l_thick"),"CrosshairThick",y,1,8,nil,function() buildCH() end)
    y=buildSlider(sc,T("l_gap"),"CrosshairGap",y,0,24,nil,function() buildCH() end)
    y=buildSlider(sc,T("l_opac"),"CrosshairAlpha",y,0.1,1.0,"%.1f",function() buildCH() end)
    y=buildToggle(sc,T("t_dot"),"CrosshairDot",y,function() buildCH() end)
    y=buildToggle(sc,T("t_out"),"CrosshairOutline",y,function() buildCH() end)
    y=buildSec(sc,T("s_crs").." "..T("s_clr"),y+4)
    y=buildColorPrev(sc,"CrosshairR","CrosshairG","CrosshairB",y)
    y=buildSlider(sc,T("l_r"),"CrosshairR",y,0,255,nil,function() buildCH() end)
    y=buildSlider(sc,T("l_g"),"CrosshairG",y,0,255,nil,function() buildCH() end)
    y=buildSlider(sc,T("l_b"),"CrosshairB",y,0,255,nil,function() buildCH() end)
end

tabBuilders["AIMBOT"]=function(p)
    local sc=makeScroll(p);local y=10
    y=buildSec(sc,T("s_aim"),y)
    y=buildToggle(sc,T("t_aim"),"Aimbot",y,function(v) whFeature("Aimbot",v) end)
    y=buildToggle(sc,T("t_rage"),"RageAimbot",y,function(v) if v then enableRA() else disableRA() end;whFeature("Rage Aimbot",v) end)
    y=buildSec(sc,T("s_sil"),y+4)
    y=buildToggle(sc,T("t_sil"),"SilentAim",y,function(v) if v then enableSA() else disableSA() end;whFeature("Silent Aim",v) end)
    y=buildSec(sc,T("s_mgb"),y+4)
    y=buildToggle(sc,T("t_mb"),"MagicBullet",y,function(v) if v then enableMB() else disableMB() end;whFeature("Magic Bullet",v) end)
    y=buildSec(sc,T("s_hbx"),y+4)
    y=buildToggle(sc,T("t_hbx"),"HitboxEnabled",y,function(v) if v then enableHB() else disableHB() end;whFeature("Hitbox",v) end)
    y=buildSlider(sc,T("l_hbx_s"),"HitboxSize",y,1,20,"%.1f")
    y=buildSec(sc,T("s_flg"),y+4)
    y=buildToggle(sc,T("t_flg"),"FakeLag",y,function(v) if v then enableFL() else disableFL() end;whFeature("Fake Lag",v) end)
    y=buildSlider(sc,T("l_lag"),"FakeLagInterval",y,0.0,0.5,"%.2f")
    y=buildSec(sc,T("s_fov"),y+4)
    y=buildToggle(sc,T("t_fov"),"UseFOV",y)
    y=buildToggle(sc,T("t_fovc"),"FOVVisible",y,function(v) if FOVCircle then FOVCircle.Visible=v end end)
    y=buildSlider(sc,T("l_fov_s"),"FOVSize",y,20,400,nil)
    y=buildSec(sc,T("s_smt"),y+4)
    y=buildSlider(sc,T("l_smt"),"AimbotSmoothness",y,0.02,1.0,"%.2f")
    y=buildSec(sc,T("s_tgt"),y+4)
    y=buildToggle(sc,"Kafa","AimbotPartHead",y)
    y=buildToggle(sc,"Göğüs","AimbotPartChest",y)
    y=buildToggle(sc,"Karın","AimbotPartStomach",y)
end

tabBuilders["MOVEMENT"]=function(p)
    local sc=makeScroll(p);local y=10
    y=buildSec(sc,T("s_fly"),y)
    y=buildToggle(sc,T("t_fly"),"FlyEnabled",y,function(v) if v then enableFly() else disableFly() end;whFeature("Fly",v) end)
    y=buildSlider(sc,T("l_fly_s"),"FlySpeed",y,10,300,nil)
    y=buildSec(sc,T("s_mov"),y+4)
    y=buildToggle(sc,T("t_noclip"),"NoClipEnabled",y,function(v) if v then enableNoclip() else disableNoclip() end;whFeature("Noclip",v) end)
    y=buildToggle(sc,T("t_inf_j"),"InfiniteJump",y,function(v) if v then enableIJ() else disableIJ() end;whFeature("Infinite Jump",v) end)
    y=buildToggle(sc,T("t_lng_j"),"LongJump",y,function(v) if v then enableLJ() else disableLJ() end;whFeature("Long Jump",v) end)
    y=buildSlider(sc,T("l_power"),"LongJumpPower",y,20,200,nil)
    y=buildToggle(sc,T("t_swim"),"SwimHack",y,function(v) whFeature("Swim Hack",v) end)
    y=buildSec(sc,T("s_bhp"),y+4)
    y=buildToggle(sc,T("t_bhop"),"BunnyHop",y,function(v) if v then enableBhop() else disableBhop() end;whFeature("Bunny Hop",v) end)
    y=buildSlider(sc,T("l_bhop_s"),"BunnyHopSpeed",y,1.0,3.0,"%.1f")
    y=buildSec(sc,T("s_spd"),y+4)
    y=buildToggle(sc,T("t_spd"),"SpeedHack",y,function(v) if v then enableSpeed() else disableSpeed() end;whFeature("Speed Hack",v) end)
    y=buildSlider(sc,T("l_mul"),"SpeedMultiplier",y,1.0,10.0,"%.1f")
    y=buildSec(sc,T("s_grav"),y+4)
    y=buildToggle(sc,T("t_grav"),"GravityHack",y,function(v) applyGrav();whFeature("Gravity Hack",v) end)
    y=buildSlider(sc,T("l_grav"),"GravityValue",y,0,500,"%.1f",function(v) if _G.GravityHack then Workspace.Gravity=v end end)
    y=buildSec(sc,T("s_tp"),y+4)
    y=buildToggle(sc,T("t_ctp"),"TeleportCursor",y,function(v) whFeature("Cursor TP",v) end)
    y=buildSec(sc,T("s_oth"),y+4)
    y=buildToggle(sc,T("t_stream"),"StreamProof",y,function(v) if MainGui then MainGui.DisplayOrder=v and 200 or 10 end end)
end

tabBuilders["PLAYERS"]=function(p)
    local sc=makeScroll(p);local y=10
    y=buildSec(sc,T("s_cmb"),y)
    y=buildToggle(sc,T("t_ka"),"KillAura",y,function(v) if v then enableKA() else disableKA() end;whFeature("Kill Aura",v) end)
    y=buildSlider(sc,T("l_range"),"KillAuraRange",y,5,50,nil)
    y=buildSec(sc,T("s_god"),y+4)
    y=buildToggle(sc,T("t_god"),"Godmode",y,function(v) if v then enableGod() else disableGod() end;whFeature("Godmode",v) end)
    y=buildSec(sc,T("s_hlp"),y+4)
    y=buildToggle(sc,T("t_afk"),"AntiAFK",y,function(v) if v then enableAFK() else disableAFK() end;whFeature("Anti AFK",v) end)
    y=buildSec(sc,T("s_spf"),y+4)
    y=buildToggle(sc,T("t_ns"),"NameSpoof",y,function() applyNS() end)
    local nameBox;nameBox,y=buildInput(sc,T("l_name"),"İsim gir","",y)
    local applyBtn;applyBtn,y=buildBtn(sc,T("b_apply"),y)
    applyBtn.MouseButton1Click:Connect(function() _G.SpoofedName=nameBox.Text;applyNS() end)
    y=buildSec(sc,"Oyuncu Listesi",y+4)
    local stopBtn;stopBtn,y=buildBtn(sc,T("b_stop"),y,Tc.AccentFaint,Tc.Text)
    stopBtn.MouseButton1Click:Connect(function() local c=LocalPlayer.Character;Camera.CameraSubject=(c and c:FindFirstChildOfClass("Humanoid")) or LocalPlayer end)
    local plist=Instance.new("ScrollingFrame",sc);plist.Size=UDim2.new(1,-28,0,240);plist.Position=UDim2.new(0,14,0,y);plist.BackgroundColor3=Tc.Card;corner(8,plist);plist.ScrollBarThickness=3;plist.CanvasSize=UDim2.new(0,0,0,0);plist.AutomaticCanvasSize=Enum.AutomaticSize.Y;plist.BorderSizePixel=0
    Instance.new("UIListLayout",plist).Padding=UDim.new(0,4);local pp=Instance.new("UIPadding",plist);pp.PaddingTop=UDim.new(0,6);pp.PaddingLeft=UDim.new(0,6);pp.PaddingRight=UDim.new(0,6)
    local function refreshPL()
        for _,c in ipairs(plist:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr==LocalPlayer then continue end
            local row=Instance.new("Frame",plist);row.Size=UDim2.new(1,0,0,40);row.BackgroundColor3=Tc.CardHov;corner(6,row)
            local nl=Instance.new("TextLabel",row);nl.Size=UDim2.new(0.42,0,1,0);nl.Position=UDim2.new(0,8,0,0);nl.BackgroundTransparency=1;nl.Text=plr.Name;nl.TextColor3=Tc.Text;nl.Font=Enum.Font.GothamSemibold;nl.TextSize=13;nl.TextXAlignment=Enum.TextXAlignment.Left
            local defs={{l=T("b_tp"),c=Color3.fromRGB(55,55,180),x=0.43},{l=T("b_pull"),c=Color3.fromRGB(160,90,0),x=0.57},{l=T("b_spec"),c=Color3.fromRGB(75,75,160),x=0.72},{l=T("b_frz"),c=Color3.fromRGB(0,130,130),x=0.87}}
            local btns={};for _,bd in ipairs(defs) do local b=Instance.new("TextButton",row);b.Size=UDim2.new(0,42,0,28);b.Position=UDim2.new(bd.x,0,0.5,-14);b.BackgroundColor3=bd.c;b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextSize=11;b.Text=bd.l;corner(5,b);btns[bd.l]=b end
            btns[T("b_tp")].MouseButton1Click:Connect(function() if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame=plr.Character.HumanoidRootPart.CFrame+Vector3.new(0,3,0) end end)
            btns[T("b_pull")].MouseButton1Click:Connect(function() if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then plr.Character.HumanoidRootPart.CFrame=LocalPlayer.Character.HumanoidRootPart.CFrame+Vector3.new(0,3,0) end end)
            btns[T("b_spec")].MouseButton1Click:Connect(function() if plr.Character and plr.Character:FindFirstChild("Humanoid") then Camera.CameraSubject=plr.Character.Humanoid end end)
            local frozen=false;btns[T("b_frz")].MouseButton1Click:Connect(function() frozen=not frozen;if plr.Character then local root=plr.Character:FindFirstChild("HumanoidRootPart");if root then if frozen then if FrozenPlayers[plr] then return end;local bp=Instance.new("BodyPosition");bp.MaxForce=Vector3.new(4e4,4e4,4e4);bp.P=2000;bp.D=100;bp.Position=root.Position;bp.Parent=root;FrozenPlayers[plr]=bp else if FrozenPlayers[plr] then FrozenPlayers[plr]:Destroy();FrozenPlayers[plr]=nil end end end end;btns[T("b_frz")].Text=frozen and T("b_free") or T("b_frz");btns[T("b_frz")].BackgroundColor3=frozen and Color3.fromRGB(0,180,90) or Color3.fromRGB(0,130,130) end)
        end
    end
    refreshPL();Players.PlayerAdded:Connect(refreshPL);Players.PlayerRemoving:Connect(function() task.wait(0.2);refreshPL() end)
end

tabBuilders["VISUAL"]=function(p)
    local sc=makeScroll(p);local y=10
    y=buildSec(sc,T("s_lit"),y)
    y=buildToggle(sc,T("t_fb"),"FullBright",y,function(v) applyFB(v);whFeature("Full Bright",v) end)
    y=buildToggle(sc,T("t_nf"),"NoFog",y,function(v) applyNF(v);whFeature("No Fog",v) end)
    y=buildSec(sc,T("s_cam"),y+4)
    y=buildToggle(sc,T("t_fc"),"FOVChanger",y,function(v) if not v then Camera.FieldOfView=oCFOV end;whFeature("FOV Changer",v) end)
    y=buildSlider(sc,T("l_val"),"FOVChangerVal",y,50,200,nil,function(v) if _G.FOVChanger then Camera.FieldOfView=v end end)
    y=buildToggle(sc,T("t_3p"),"ThirdPerson",y,function(v) if v then enableTP3() else disableTP3() end;whFeature("Third Person",v) end)
    y=buildSlider(sc,T("l_trdist"),"ThirdPersonDist",y,4,30,nil)
    y=buildSec(sc,T("s_wld"),y+4)
    y=buildToggle(sc,T("t_tc2"),"TimeChanger",y,function(v) applyTime(v);whFeature("Time Changer",v) end)
    y=buildSlider(sc,T("l_time"),"TimeOfDay",y,0,23,nil,function(v) if _G.TimeChanger then applyTime(true) end end)
    y=buildSec(sc,T("s_wc"),y+4)
    y=buildToggle(sc,T("t_wclr"),"WorldColor",y,function(v) applyWC(v) end)
    y=buildColorPrev(sc,"WorldR","WorldG","WorldB",y)
    y=buildSlider(sc,T("l_r"),"WorldR",y,0,255,nil,function() if _G.WorldColor then applyWC(true) end end)
    y=buildSlider(sc,T("l_g"),"WorldG",y,0,255,nil,function() if _G.WorldColor then applyWC(true) end end)
    y=buildSlider(sc,T("l_b"),"WorldB",y,0,255,nil,function() if _G.WorldColor then applyWC(true) end end)
end

tabBuilders["MISC"]=function(p)
    local sc=makeScroll(p);local y=10
    y=buildSec(sc,T("s_srv"),y)
    local hopBtn;hopBtn,y=buildBtn(sc,T("b_hop"),y,Color3.fromRGB(40,100,180),Color3.new(1,1,1))
    hopBtn.MouseButton1Click:Connect(function() hopBtn.Text="...";task.spawn(function() serverHop();task.wait(2);hopBtn.Text=T("b_hop") end) end)
    y=buildToggle(sc,T("t_rej"),"AutoRejoin",y,function(v) whFeature("Auto Rejoin",v) end)
    y=buildSec(sc,T("s_prf"),y+4)
    y=buildToggle(sc,T("t_fps"),"FPSBoost",y,function(v) if v then enableFPS() else disableFPS() end;whFeature("FPS Boost",v) end)
    y=buildSec(sc,T("s_cht"),y+4)
    y=buildToggle(sc,T("t_cl"),"ChatLogger",y,function(v) if v then enableCL() else disableCL() end;whFeature("Chat Logger",v) end)
    if #chatLogs>0 then
        local cf=Instance.new("Frame",sc);cf.Size=UDim2.new(1,-28,0,150);cf.Position=UDim2.new(0,14,0,y);cf.BackgroundColor3=Tc.Card;corner(8,cf)
        local csc=Instance.new("ScrollingFrame",cf);csc.Size=UDim2.new(1,-8,1,-8);csc.Position=UDim2.new(0,4,0,4);csc.BackgroundTransparency=1;csc.ScrollBarThickness=2;csc.CanvasSize=UDim2.new(0,0,0,0);csc.AutomaticCanvasSize=Enum.AutomaticSize.Y;csc.BorderSizePixel=0
        Instance.new("UIListLayout",csc).Padding=UDim.new(0,2)
        for _,log in ipairs(chatLogs) do local l=Instance.new("TextLabel",csc);l.Size=UDim2.new(1,-4,0,14);l.BackgroundTransparency=1;l.Text=log:sub(1,50);l.TextColor3=Tc.TextDim;l.Font=Enum.Font.Gotham;l.TextSize=10;l.TextXAlignment=Enum.TextXAlignment.Left;l.TextWrapped=true end
        y=y+158
    end
    y=buildSec(sc,T("s_mm"),y+4)
    y=buildToggle(sc,T("t_mm"),"MiniMap",y,function(v) if v then enableMM() else disableMM() end;whFeature("MiniMap",v) end)
end

tabBuilders["ITEMS"]=function(p)
    local sc=makeScroll(p);local y=10
    y=buildSec(sc,T("s_itm"),y)
    local pBox;pBox,y=buildInput(sc,"Kullanıcı","İsim","",y)
    local tBox;tBox,y=buildInput(sc,"Eşya","Kılıç","",y)
    local cBox;cBox,y=buildInput(sc,"Adet","1","1",y)
    local gBtn;gBtn,y=buildBtn(sc,"Ver",y)
    local sBtn;sBtn,y=buildBtn(sc,"Ara",y,Tc.AccentFaint,Tc.Text)
    local res=Instance.new("TextLabel",sc);res.Size=UDim2.new(1,-28,0,28);res.Position=UDim2.new(0,14,0,y);res.BackgroundTransparency=1;res.TextColor3=Tc.TextDim;res.Font=Enum.Font.GothamMedium;res.TextSize=13;res.TextWrapped=true;res.TextXAlignment=Enum.TextXAlignment.Left;y=y+34
    local toolsF=Instance.new("Frame",sc);toolsF.Size=UDim2.new(1,-28,0,180);toolsF.Position=UDim2.new(0,14,0,y);toolsF.BackgroundColor3=Tc.Card;corner(8,toolsF)
    local tlbl=Instance.new("TextLabel",toolsF);tlbl.Size=UDim2.new(1,0,0,26);tlbl.BackgroundTransparency=1;tlbl.Text="Eşya Listesi";tlbl.TextColor3=Tc.TextDim;tlbl.Font=Enum.Font.GothamBold;tlbl.TextSize=11
    local tsc=Instance.new("ScrollingFrame",toolsF);tsc.Size=UDim2.new(1,-8,1,-30);tsc.Position=UDim2.new(0,4,0,28);tsc.BackgroundTransparency=1;tsc.ScrollBarThickness=3;tsc.CanvasSize=UDim2.new(0,0,0,0);tsc.AutomaticCanvasSize=Enum.AutomaticSize.Y;tsc.BorderSizePixel=0
    Instance.new("UIListLayout",tsc).Padding=UDim.new(0,3)
    local function rfr() for _,c in ipairs(tsc:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end;task.spawn(function() local found={};for _,loc in ipairs({ServerStorage,ReplicatedStorage,Workspace}) do for _,item in ipairs(loc:GetDescendants()) do if item:IsA("Tool") then found[item.Name]=true end end end;local cnt=0;for name in pairs(found) do local btn=Instance.new("TextButton",tsc);btn.Size=UDim2.new(1,0,0,26);btn.Text=name;btn.TextColor3=Tc.Text;btn.Font=Enum.Font.Gotham;btn.TextSize=13;btn.BackgroundColor3=Tc.CardHov;corner(5,btn);btn.MouseButton1Click:Connect(function() tBox.Text=name end);cnt=cnt+1 end;res.Text=cnt.." bulundu";res.TextColor3=cnt>0 and Tc.KeyGreen or Tc.KeyRed end) end
    local function giveItem(pN,tN,count)
        count=count or 1;local tp;for _,plr in ipairs(Players:GetPlayers()) do if plr.Name:lower():find(pN:lower()) then tp=plr;break end end;if not tp then return false,"Oyuncu bulunamadı" end
        local found;for _,loc in ipairs({ServerStorage,ReplicatedStorage,Workspace}) do local t2=loc:FindFirstChild(tN,true);if t2 and t2:IsA("Tool") then found=t2:Clone();break end end;if not found then return false,"Eşya bulunamadı" end
        for i=1,count do local cl=found:Clone();local bp=tp:FindFirstChild("Backpack");if bp then cl.Parent=bp elseif tp.Character then cl.Parent=tp.Character end;task.wait(0.1) end;return true,count.."x "..tN.." → "..tp.Name
    end
    gBtn.MouseButton1Click:Connect(function() local ok,msg=giveItem(pBox.Text,tBox.Text,math.clamp(tonumber(cBox.Text) or 1,1,20));res.Text=msg;res.TextColor3=ok and Tc.KeyGreen or Tc.KeyRed end)
    sBtn.MouseButton1Click:Connect(rfr);rfr()
end

tabBuilders["TEAM"]=function(p)
    local sc=makeScroll(p);local y=10
    y=buildSec(sc,"Takım Değiştir",y)
    local uBox;uBox,y=buildInput(sc,"Kullanıcı","İsim","",y)
    local tBox;tBox,y=buildInput(sc,"Takım","Takım adı","",y)
    local cBtn;cBtn,y=buildBtn(sc,"Değiştir",y)
    local res=Instance.new("TextLabel",sc);res.Size=UDim2.new(1,-28,0,28);res.Position=UDim2.new(0,14,0,y);res.BackgroundTransparency=1;res.TextColor3=Tc.TextDim;res.Font=Enum.Font.GothamMedium;res.TextSize=13;res.TextXAlignment=Enum.TextXAlignment.Left
    cBtn.MouseButton1Click:Connect(function()
        if uBox.Text=="" or tBox.Text=="" then res.Text="Doldur!";res.TextColor3=Tc.KeyRed;return end
        local tp;for _,plr in ipairs(Players:GetPlayers()) do if plr.Name:lower()==uBox.Text:lower() then tp=plr;break end end;if not tp then res.Text="Oyuncu bulunamadı";res.TextColor3=Tc.KeyRed;return end
        local tt;for _,t in ipairs(game:GetService("Teams"):GetChildren()) do if t.Name:lower()==tBox.Text:lower() then tt=t;break end end;if not tt then res.Text="Takım bulunamadı";res.TextColor3=Tc.KeyRed;return end
        tp.Team=tt;res.Text=tp.Name.." → "..tt.Name;res.TextColor3=Tc.KeyGreen
    end)
end

tabBuilders["CONFIG"]=function(p)
    local sc=makeScroll(p);local y=10
    local infoCard=Instance.new("Frame",sc);infoCard.Size=UDim2.new(1,-28,0,36);infoCard.Position=UDim2.new(0,14,0,y);infoCard.BackgroundColor3=Tc.AccentFaint;corner(8,infoCard)
    local il=Instance.new("TextLabel",infoCard);il.Size=UDim2.new(1,-16,1,0);il.Position=UDim2.new(0,8,0,0);il.BackgroundTransparency=1;il.Text="Configler sadece bu cihaza kaydedilir. | "..T("disc");il.TextColor3=Tc.TextDim;il.Font=Enum.Font.Gotham;il.TextSize=11;il.TextXAlignment=Enum.TextXAlignment.Left;y=y+44
    y=buildSec(sc,T("cfg_sv"),y)
    local nameBox;nameBox,y=buildInput(sc,T("cfg_n"),"benim-config","",y)
    local saveBtn;saveBtn,y=buildBtn(sc,T("cfg_sv"),y,Tc.KeyGreen,Color3.new(1,1,1))
    local res=Instance.new("TextLabel",sc);res.Size=UDim2.new(1,-28,0,28);res.Position=UDim2.new(0,14,0,y);res.BackgroundTransparency=1;res.Font=Enum.Font.GothamMedium;res.TextSize=13;res.TextXAlignment=Enum.TextXAlignment.Left;res.TextWrapped=true;y=y+36
    saveBtn.MouseButton1Click:Connect(function()
        local n=nameBox.Text:gsub("[^%w%-_]",""):lower()
        if n=="" then res.Text=T("cfg_ne");res.TextColor3=Tc.KeyRed;return end
        if saveCfg(n) then res.Text=T("cfg_ok").." ("..n..")";res.TextColor3=Tc.KeyGreen;task.wait(0.5);switchTab("CONFIG")
        else res.Text=T("cfg_f");res.TextColor3=Tc.KeyRed end
    end)
    y=buildSec(sc,"Kayıtlı Configler",y+4)
    local configs=listCfgs()
    if #configs==0 then
        local el=Instance.new("TextLabel",sc);el.Size=UDim2.new(1,-28,0,28);el.Position=UDim2.new(0,14,0,y);el.BackgroundTransparency=1;el.Text=T("cfg_no");el.TextColor3=Tc.TextFaint;el.Font=Enum.Font.GothamMedium;el.TextSize=13;el.TextXAlignment=Enum.TextXAlignment.Left
    else
        for _,cfgName in ipairs(configs) do
            local row=Instance.new("Frame",sc);row.Size=UDim2.new(1,-28,0,44);row.Position=UDim2.new(0,14,0,y);row.BackgroundColor3=Tc.Card;corner(8,row)
            local nl=Instance.new("TextLabel",row);nl.Size=UDim2.new(1,-160,1,0);nl.Position=UDim2.new(0,12,0,0);nl.BackgroundTransparency=1;nl.Text=cfgName;nl.TextColor3=Tc.Text;nl.Font=Enum.Font.GothamSemibold;nl.TextSize=13;nl.TextXAlignment=Enum.TextXAlignment.Left
            local function mkB(txt,col,xOff) local b=Instance.new("TextButton",row);b.Size=UDim2.new(0,46,0,28);b.Position=UDim2.new(1,xOff,0.5,-14);b.BackgroundColor3=col;b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextSize=11;b.Text=txt;corner(6,b);return b end
            local lb=mkB(T("cfg_ld"),Tc.KeyGreen,-152);local db=mkB(T("cfg_dl"),Tc.KeyRed,-98)
            lb.MouseButton1Click:Connect(function() if loadCfg(cfgName) then buildCH();res.Text=T("cfg_lok").." ("..cfgName..")";res.TextColor3=Tc.KeyGreen else res.Text=T("cfg_f");res.TextColor3=Tc.KeyRed end end)
            db.MouseButton1Click:Connect(function() delCfg(cfgName);res.Text=T("cfg_dok");res.TextColor3=Tc.TextDim;task.wait(0.3);switchTab("CONFIG") end)
            y=y+52
        end
    end
end

tabBuilders["SETTINGS"]=function(p)
    local sc=makeScroll(p);local y=10
    -- Dil
    y=buildSec(sc,T("s_lng"),y)
    local langRow=Instance.new("Frame",sc);langRow.Size=UDim2.new(1,-28,0,44);langRow.Position=UDim2.new(0,14,0,y);langRow.BackgroundColor3=Tc.Card;corner(8,langRow)
    local langLbl=Instance.new("TextLabel",langRow);langLbl.Size=UDim2.new(0.45,0,1,0);langLbl.Position=UDim2.new(0,12,0,0);langLbl.BackgroundTransparency=1;langLbl.Text="Language / Dil / Idioma";langLbl.TextColor3=Tc.Text;langLbl.Font=Enum.Font.GothamMedium;langLbl.TextSize=13;langLbl.TextXAlignment=Enum.TextXAlignment.Left
    local langs={"TR","EN","ES"}
    local function getLangName(l) return l=="TR" and "🇹🇷 Türkçe" or l=="EN" and "🇬🇧 English" or "🇪🇸 Español" end
    local langBtn=Instance.new("TextButton",langRow);langBtn.Size=UDim2.new(0,120,0,30);langBtn.Position=UDim2.new(1,-134,0.5,-15);langBtn.BackgroundColor3=Tc.AccentFaint;langBtn.TextColor3=Tc.Text;langBtn.Font=Enum.Font.GothamBold;langBtn.TextSize=13;langBtn.Text=getLangName(LANG);corner(6,langBtn)
    langBtn.MouseButton1Click:Connect(function()
        local idx=1;for i,l in ipairs(langs) do if l==LANG then idx=i;break end end
        LANG=langs[(idx%#langs)+1];langBtn.Text=getLangName(LANG)
        task.wait(0.1);rebuildMenu()
    end)
    y=y+52
    -- Tema
    y=buildSec(sc,T("s_thm"),y)
    local themeGrid=Instance.new("Frame",sc);themeGrid.Size=UDim2.new(1,-28,0,0);themeGrid.AutomaticSize=Enum.AutomaticSize.Y;themeGrid.Position=UDim2.new(0,14,0,y);themeGrid.BackgroundTransparency=1
    local tgL=Instance.new("UIGridLayout",themeGrid);tgL.CellSize=UDim2.new(0,100,0,56);tgL.CellPadding=UDim2.new(0,6,0,6);tgL.SortOrder=Enum.SortOrder.LayoutOrder
    for i,theme in ipairs(THEMES) do
        local acCol=theme.rainbow and Color3.fromRGB(255,100,100) or Color3.fromRGB(theme.ac[1],theme.ac[2],theme.ac[3])
        local bgCol=Color3.fromRGB(theme.bg[1],theme.bg[2],theme.bg[3])
        local btn=Instance.new("TextButton",themeGrid);btn.BackgroundColor3=bgCol;btn.BorderSizePixel=0;btn.Text="";btn.LayoutOrder=i;corner(8,btn)
        local acBar=Instance.new("Frame",btn);acBar.Size=UDim2.new(1,0,0,4);acBar.BackgroundColor3=acCol;acBar.BorderSizePixel=0;local ac2=Instance.new("UICorner",acBar);ac2.CornerRadius=UDim.new(0,4)
        local nL=Instance.new("TextLabel",btn);nL.Size=UDim2.new(1,0,1,-4);nL.Position=UDim2.new(0,0,0,4);nL.BackgroundTransparency=1;nL.Text=theme.name;nL.TextColor3=acCol;nL.Font=Enum.Font.GothamBold;nL.TextSize=12
        if i==currentTheme then local sel=Instance.new("UIStroke",btn);sel.Color=acCol;sel.Thickness=2 end
        if theme.rainbow then
            task.spawn(function() while btn and btn.Parent do local rb=hsvToRgb(rainbowHue,1,1);acBar.BackgroundColor3=rb;nL.TextColor3=rb;task.wait(0.05) end end)
        end
        btn.MouseButton1Click:Connect(function() currentTheme=i;Tc=makeTc();task.wait(0.1);rebuildMenu() end)
    end
    y=y+200
    -- Hakkında
    y=buildSec(sc,T("s_abt"),y)
    local aboutCard=Instance.new("Frame",sc);aboutCard.Size=UDim2.new(1,-28,0,0);aboutCard.AutomaticSize=Enum.AutomaticSize.Y;aboutCard.Position=UDim2.new(0,14,0,y);aboutCard.BackgroundColor3=Tc.Card;corner(8,aboutCard)
    local aL=Instance.new("TextLabel",aboutCard);aL.Size=UDim2.new(1,-16,0,0);aL.AutomaticSize=Enum.AutomaticSize.Y;aL.Position=UDim2.new(0,8,0,8);aL.BackgroundTransparency=1
    aL.Text="SUSANO V2.1\n"..T("disc").."\n\nESP (2D/3D/Skeleton/Chams), Aimbot, Rage Aimbot, Silent Aim, Magic Bullet, Hitbox, Fake Lag, Fly, Noclip, Speed, BunnyHop, LongJump, Gravity Hack, Cursor TP, Godmode, Kill Aura, Anti AFK, Name Spoof, Full Bright, No Fog, FOV Changer, 3rd Person, Time Changer, World Color, Server Hop, Auto Rejoin, FPS Boost, Chat Logger, MiniMap, Eşya Verme, Takım Değiştirme, Config (Local), 9 Tema (Rainbow), TR/EN/ES Dil, Webhook\n\nF5 - Menü | Sağ Tık - Cursor TP"
    aL.TextColor3=Tc.TextDim;aL.Font=Enum.Font.Gotham;aL.TextSize=12;aL.TextWrapped=true;aL.TextXAlignment=Enum.TextXAlignment.Left
    Instance.new("UIPadding",aboutCard).PaddingBottom=UDim.new(0,10)
end

-- MAIN MENU
local MainFrame,SideBar,Content
local currentTab="ESP";local menuBuilt=false;local minimized=false
local MENU_FULL=UDim2.new(0,940,0,680);local MENU_MINI=UDim2.new(0,940,0,46)
local sideButtons={}

local function getTabs()
    return {
        {id="ESP",      label=T("tab_esp")},
        {id="AIMBOT",   label=T("tab_aim")},
        {id="MOVEMENT", label=T("tab_move")},
        {id="PLAYERS",  label=T("tab_play")},
        {id="VISUAL",   label=T("tab_vis")},
        {id="MISC",     label=T("tab_misc")},
        {id="ITEMS",    label=T("tab_item")},
        {id="TEAM",     label=T("tab_team")},
        {id="CONFIG",   label=T("tab_cfg")},
        {id="SETTINGS", label=T("tab_set")},
    }
end

switchTab=function(id)
    currentTab=id
    local TABS=getTabs()
    for i,btn in ipairs(sideButtons) do
        local active=btn:GetAttribute("TID")==id
        tw(btn,0.15,{BackgroundColor3=active and Tc.ActiveSide or Tc.InactiveSide})
        local il=btn:FindFirstChild("IL");local nl=btn:FindFirstChild("NL")
        if il then tw(il,0.15,{TextColor3=active and Tc.BG or Tc.TextFaint}) end
        if nl then tw(nl,0.15,{TextColor3=active and Tc.BG or Tc.TextDim}) end
        -- İlk harfi güncelle
        if il and TABS[i] then il.Text=TABS[i].label:sub(1,1):upper() end
        if nl and TABS[i] then nl.Text=TABS[i].label end
    end
    for _,c in ipairs(Content:GetChildren()) do c:Destroy() end
    Content.BackgroundTransparency=0.15;tw(Content,0.12,{BackgroundTransparency=1})
    local builder=tabBuilders[id];if builder then builder(Content) end
end

createMenu=function()
    if MainGui then pcall(function() MainGui:Destroy() end) end
    MainGui=makeGui("SusanoUI",200);MainGui.Enabled=true
    Tc=makeTc()
    MainFrame=Instance.new("Frame",MainGui);MainFrame.Size=MENU_FULL;MainFrame.Position=UDim2.new(0.5,-470,0.5,-340);MainFrame.BackgroundColor3=Tc.BG;MainFrame.Active=true;corner(10,MainFrame)
    local iBorder=Instance.new("UIStroke",MainFrame);iBorder.Color=Tc.Accent;iBorder.Thickness=1;iBorder.Transparency=0.6
    for _,sd in ipairs({{4,3,0.82},{12,6,0.88},{22,10,0.94}}) do local s=Instance.new("Frame",MainFrame);s.Size=UDim2.new(1,sd[1],1,sd[1]);s.Position=UDim2.new(0,-sd[1]/2,0,sd[2]);s.BackgroundColor3=Color3.new(0,0,0);s.BackgroundTransparency=sd[3];s.ZIndex=MainFrame.ZIndex-1;s.BorderSizePixel=0;corner(15,s) end

    -- Title bar
    local tb=Instance.new("Frame",MainFrame);tb.Size=UDim2.new(1,0,0,46);tb.BackgroundColor3=Tc.TitleBar;tb.BorderSizePixel=0;tb.ClipsDescendants=true;corner(10,tb)
    local tbFix=Instance.new("Frame",tb);tbFix.Size=UDim2.new(1,0,0.5,0);tbFix.Position=UDim2.new(0,0,0.5,0);tbFix.BackgroundColor3=Tc.TitleBar;tbFix.BorderSizePixel=0
    local titleLine=Instance.new("Frame",tb);titleLine.Size=UDim2.new(1,0,0,1);titleLine.Position=UDim2.new(0,0,1,-1);titleLine.BackgroundColor3=Tc.Accent;titleLine.BorderSizePixel=0;titleLine.BackgroundTransparency=0.7
    local logoTxt=Instance.new("TextLabel",tb);logoTxt.Size=UDim2.new(0,110,1,0);logoTxt.Position=UDim2.new(0,16,0,0);logoTxt.BackgroundTransparency=1;logoTxt.Text="SUSANO";logoTxt.TextColor3=Tc.Accent;logoTxt.Font=Enum.Font.GothamBlack;logoTxt.TextSize=20;logoTxt.TextXAlignment=Enum.TextXAlignment.Left
    local verTxt=Instance.new("TextLabel",tb);verTxt.Size=UDim2.new(0,40,1,0);verTxt.Position=UDim2.new(0,122,0,0);verTxt.BackgroundTransparency=1;verTxt.Text="v2.1";verTxt.TextColor3=Tc.TextFaint;verTxt.Font=Enum.Font.GothamMedium;verTxt.TextSize=11;verTxt.TextXAlignment=Enum.TextXAlignment.Left
    local kBadge=Instance.new("Frame",tb);kBadge.Size=UDim2.new(0,80,0,22);kBadge.Position=UDim2.new(0,170,0.5,-11);kBadge.BackgroundColor3=keyType=="lifetime" and Tc.KeyGold or(keyType=="monthly" and Color3.fromRGB(180,120,255) or(keyType=="weekly" and Color3.fromRGB(80,180,255) or Tc.AccentFaint));corner(5,kBadge)
    local kBL=Instance.new("TextLabel",kBadge);kBL.Size=UDim2.new(1,0,1,0);kBL.BackgroundTransparency=1;kBL.TextColor3=Color3.new(1,1,1);kBL.Font=Enum.Font.GothamBold;kBL.TextSize=11;local kn={daily=T("tp_d"),weekly=T("tp_w"),monthly=T("tp_m"),lifetime=T("tp_l")};kBL.Text=kn[keyType] or keyType:upper()
    local timeLbl=Instance.new("TextLabel",tb);timeLbl.Size=UDim2.new(0,110,1,0);timeLbl.Position=UDim2.new(0,258,0,0);timeLbl.BackgroundTransparency=1;timeLbl.TextColor3=Tc.TextFaint;timeLbl.Font=Enum.Font.GothamMedium;timeLbl.TextSize=10;timeLbl.TextXAlignment=Enum.TextXAlignment.Left;timeLbl.Text=fmtTime(keyExpires)
    task.spawn(function() while MainGui and MainGui.Parent do timeLbl.Text=fmtTime(keyExpires);task.wait(60) end end)
    local discLbl=Instance.new("TextLabel",tb);discLbl.Size=UDim2.new(0,180,1,0);discLbl.Position=UDim2.new(0.5,-90,0,0);discLbl.BackgroundTransparency=1;discLbl.Text=T("disc");discLbl.TextColor3=Tc.TextFaint;discLbl.Font=Enum.Font.GothamMedium;discLbl.TextSize=11

    -- Rainbow animation
    if THEMES[currentTheme].rainbow then
        task.spawn(function()
            while MainGui and MainGui.Parent and THEMES[currentTheme].rainbow do
                rainbowHue=(rainbowHue+0.002)%1;local rb=hsvToRgb(rainbowHue,1,1)
                Tc.Accent=rb;Tc.ActiveSide=rb
                pcall(function() logoTxt.TextColor3=rb;titleLine.BackgroundColor3=rb;iBorder.Color=rb;kBadge.BackgroundColor3=rb end)
                task.wait(0.05)
            end
        end)
    end

    local function mkTBtn(text,bgCol,xOff) local btn=Instance.new("TextButton",tb);btn.Size=UDim2.new(0,28,0,28);btn.Position=UDim2.new(1,xOff,0.5,-14);btn.BackgroundColor3=bgCol;btn.TextColor3=Color3.new(1,1,1);btn.Font=Enum.Font.GothamBold;btn.TextSize=15;btn.Text=text;corner(6,btn);return btn end
    local closeBtn=mkTBtn("×",Tc.CloseRed,-36)
    closeBtn.MouseEnter:Connect(function() tw(closeBtn,0.1,{BackgroundColor3=Color3.fromRGB(220,70,70)}) end)
    closeBtn.MouseLeave:Connect(function() tw(closeBtn,0.1,{BackgroundColor3=Tc.CloseRed}) end)
    closeBtn.MouseButton1Click:Connect(function() tw(MainFrame,0.18,{BackgroundTransparency=1});task.wait(0.2);MainGui.Enabled=false;MainFrame.BackgroundTransparency=0 end)
    local minBtn=mkTBtn("−",Tc.MinBtn,-70)
    minBtn.MouseButton1Click:Connect(function() minimized=not minimized;tw(MainFrame,0.2,{Size=minimized and MENU_MINI or MENU_FULL});task.wait(0.05);SideBar.Visible=not minimized;Content.Visible=not minimized end)

    -- Sidebar
    SideBar=Instance.new("Frame",MainFrame);SideBar.Size=UDim2.new(0,185,1,-46);SideBar.Position=UDim2.new(0,0,0,46);SideBar.BackgroundColor3=Tc.Sidebar;SideBar.BorderSizePixel=0;corner(10,SideBar)
    local sbFix=Instance.new("Frame",SideBar);sbFix.Size=UDim2.new(1,0,0.5,0);sbFix.BackgroundColor3=Tc.Sidebar;sbFix.BorderSizePixel=0
    local sDiv=Instance.new("Frame",MainFrame);sDiv.Size=UDim2.new(0,1,1,-46);sDiv.Position=UDim2.new(0,185,0,46);sDiv.BackgroundColor3=Tc.Accent;sDiv.BorderSizePixel=0;sDiv.BackgroundTransparency=0.8

    sideButtons={}
    local TABS=getTabs()
    for i,tab in ipairs(TABS) do
        local isA=tab.id==currentTab
        local btn=Instance.new("TextButton",SideBar);btn.Size=UDim2.new(1,-14,0,36);btn.Position=UDim2.new(0,7,0,4+(i-1)*38);btn.BackgroundColor3=isA and Tc.ActiveSide or Tc.InactiveSide;btn.AutoButtonColor=false;btn.BorderSizePixel=0;btn.Text="";corner(7,btn);btn:SetAttribute("TID",tab.id)
        if isA then local al=Instance.new("Frame",btn);al.Size=UDim2.new(0,3,1,-8);al.Position=UDim2.new(0,2,0,4);al.BackgroundColor3=Tc.BG;al.BorderSizePixel=0;corner(2,al) end
        -- İlk harf dinamik (dil değişince güncellenir)
        local iL=Instance.new("TextLabel",btn);iL.Name="IL";iL.Size=UDim2.new(0,28,1,0);iL.Position=UDim2.new(0,8,0,0);iL.BackgroundTransparency=1;iL.Text=tab.label:sub(1,1):upper();iL.TextColor3=isA and Tc.BG or Tc.TextFaint;iL.Font=Enum.Font.GothamBold;iL.TextSize=12
        local nL=Instance.new("TextLabel",btn);nL.Name="NL";nL.Size=UDim2.new(1,-40,1,0);nL.Position=UDim2.new(0,38,0,0);nL.BackgroundTransparency=1;nL.Text=tab.label;nL.TextColor3=isA and Tc.BG or Tc.TextDim;nL.Font=Enum.Font.GothamSemibold;nL.TextSize=13;nL.TextXAlignment=Enum.TextXAlignment.Left
        btn.MouseEnter:Connect(function() if btn:GetAttribute("TID")~=currentTab then tw(btn,0.1,{BackgroundColor3=Tc.CardHov}) end end)
        btn.MouseLeave:Connect(function() if btn:GetAttribute("TID")~=currentTab then tw(btn,0.1,{BackgroundColor3=Tc.InactiveSide}) end end)
        btn.MouseButton1Click:Connect(function() switchTab(tab.id) end)
        table.insert(sideButtons,btn)
    end

    Content=Instance.new("Frame",MainFrame);Content.Size=UDim2.new(1,-186,1,-46);Content.Position=UDim2.new(0,186,0,46);Content.BackgroundTransparency=1;Content.ClipsDescendants=true

    -- Drag
    local dragging,dragStart,startPos=false
    tb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true;dragStart=i.Position;startPos=MainFrame.Position;i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end) end end)
    local dragInput;tb.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then dragInput=i end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i==dragInput then local d=i.Position-dragStart;MainFrame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)

    -- Resize
    local rH=Instance.new("Frame",MainFrame);rH.Size=UDim2.new(0,14,0,14);rH.Position=UDim2.new(1,-14,1,-14);rH.BackgroundTransparency=1
    local rD=Instance.new("Frame",rH);rD.Size=UDim2.new(0,5,0,5);rD.Position=UDim2.new(1,-5,1,-5);rD.BackgroundColor3=Tc.Accent;rD.BackgroundTransparency=0.4;corner(2,rD)
    local resizing,resStart,resStartSz=false
    rH.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then resizing=true;resStart=i.Position;resStartSz=Vector2.new(MainFrame.AbsoluteSize.X,MainFrame.AbsoluteSize.Y);i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then resizing=false end end) end end)
    local resInput;rH.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then resInput=i end end)
    UserInputService.InputChanged:Connect(function(i) if resizing and i==resInput then local d=i.Position-resStart;MainFrame.Size=UDim2.new(0,math.clamp(resStartSz.X+d.X,620,1400),0,math.clamp(resStartSz.Y+d.Y,420,900));SideBar.Size=UDim2.new(0,185,1,-46);Content.Size=UDim2.new(1,-186,1,-46) end end)

    menuBuilt=true;local ep=MainFrame.Position;MainFrame.Position=ep+UDim2.new(0,0,0,14);MainFrame.BackgroundTransparency=1;tw(MainFrame,0.22,{BackgroundTransparency=0,Position=ep});switchTab(currentTab)
end

rebuildMenu=function() menuBuilt=false;createMenu() end

-- KEY MENU
local keyMenuGui=makeGui("SusanoKeyMenu",999)
local function buildKeyMenu(onSuccess)
    local overlay=Instance.new("Frame",keyMenuGui);overlay.Size=UDim2.new(1,0,1,0);overlay.BackgroundColor3=Color3.fromRGB(5,5,5);overlay.BackgroundTransparency=0;overlay.BorderSizePixel=0
    local card=Instance.new("Frame",keyMenuGui);card.Size=UDim2.new(0,460,0,470);card.Position=UDim2.new(0.5,-230,0.5,-235);card.BackgroundColor3=Tc.BG;card.BorderSizePixel=0;corner(12,card)
    Instance.new("UIStroke",card).Color=Tc.BorderLight
    local topBar=Instance.new("Frame",card);topBar.Size=UDim2.new(1,0,0,52);topBar.BackgroundColor3=Tc.TitleBar;topBar.BorderSizePixel=0;topBar.ClipsDescendants=true;corner(12,topBar)
    local tbFix=Instance.new("Frame",topBar);tbFix.Size=UDim2.new(1,0,0.5,0);tbFix.Position=UDim2.new(0,0,0.5,0);tbFix.BackgroundColor3=Tc.TitleBar;tbFix.BorderSizePixel=0
    local tL=Instance.new("TextLabel",topBar);tL.Size=UDim2.new(1,0,0.6,0);tL.BackgroundTransparency=1;tL.Text="SUSANO";tL.TextColor3=Tc.Accent;tL.Font=Enum.Font.GothamBlack;tL.TextSize=24
    local sL=Instance.new("TextLabel",topBar);sL.Size=UDim2.new(1,0,0.4,0);sL.Position=UDim2.new(0,0,0.6,0);sL.BackgroundTransparency=1;sL.Text="v2.1  |  "..T("disc");sL.TextColor3=Tc.TextFaint;sL.Font=Enum.Font.GothamMedium;sL.TextSize=11
    local profBg=Instance.new("Frame",card);profBg.Size=UDim2.new(1,-32,0,68);profBg.Position=UDim2.new(0,16,0,60);profBg.BackgroundColor3=Tc.Card;corner(10,profBg)
    local avF=Instance.new("Frame",profBg);avF.Size=UDim2.new(0,46,0,46);avF.Position=UDim2.new(0,10,0.5,-23);avF.BackgroundColor3=Tc.AccentFaint;corner(23,avF)
    pcall(function() local img=Instance.new("ImageLabel",avF);img.Size=UDim2.new(1,0,1,0);img.BackgroundTransparency=1;corner(23,img);img.Image=Players:GetUserThumbnailAsync(LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150) end)
    local info=Instance.new("Frame",profBg);info.Size=UDim2.new(1,-66,1,0);info.Position=UDim2.new(0,62,0,0);info.BackgroundTransparency=1
    local function iLk(y,t,c,s) local l=Instance.new("TextLabel",info);l.Size=UDim2.new(1,0,0,17);l.Position=UDim2.new(0,0,0,y);l.BackgroundTransparency=1;l.Text=t;l.TextColor3=c;l.Font=Enum.Font.GothamMedium;l.TextSize=s;l.TextXAlignment=Enum.TextXAlignment.Left end
    iLk(6,"@"..USERNAME,Tc.Text,14);iLk(24,"HWID: "..HWID:sub(1,24).."...",Tc.TextFaint,10);iLk(40,"UID: "..USER_ID,Tc.TextFaint,10)
    local inLbl=Instance.new("TextLabel",card);inLbl.Size=UDim2.new(1,-32,0,16);inLbl.Position=UDim2.new(0,16,0,140);inLbl.BackgroundTransparency=1;inLbl.Text="ANAHTAR";inLbl.TextColor3=Tc.TextFaint;inLbl.Font=Enum.Font.GothamBold;inLbl.TextSize=10;inLbl.TextXAlignment=Enum.TextXAlignment.Left
    local inputBox=Instance.new("TextBox",card);inputBox.Size=UDim2.new(1,-32,0,44);inputBox.Position=UDim2.new(0,16,0,158);inputBox.BackgroundColor3=Tc.Card;inputBox.TextColor3=Tc.Text;inputBox.Font=Enum.Font.GothamMedium;inputBox.TextSize=15;inputBox.PlaceholderText="SNLIFE-XXXX-XXXX-XXXX";inputBox.PlaceholderColor3=Tc.TextFaint;inputBox.Text="";inputBox.ClearTextOnFocus=false;inputBox.BorderSizePixel=0;corner(8,inputBox)
    local ibStroke=Instance.new("UIStroke",inputBox);ibStroke.Color=Tc.BorderLight;ibStroke.Thickness=1
    local statusLbl=Instance.new("TextLabel",card);statusLbl.Size=UDim2.new(1,-32,0,20);statusLbl.Position=UDim2.new(0,16,0,208);statusLbl.BackgroundTransparency=1;statusLbl.Text="";statusLbl.Font=Enum.Font.GothamMedium;statusLbl.TextSize=13;statusLbl.TextXAlignment=Enum.TextXAlignment.Left
    local remRow=Instance.new("Frame",card);remRow.Size=UDim2.new(1,-32,0,28);remRow.Position=UDim2.new(0,16,0,234);remRow.BackgroundTransparency=1
    local remLbl=Instance.new("TextLabel",remRow);remLbl.Size=UDim2.new(0.78,0,1,0);remLbl.BackgroundTransparency=1;remLbl.Text=T("key_rem");remLbl.TextColor3=Tc.TextDim;remLbl.Font=Enum.Font.GothamMedium;remLbl.TextSize=13;remLbl.TextXAlignment=Enum.TextXAlignment.Left
    local remOn=false -- Her girişte key sorsun diye varsayılan false
    local remPill=Instance.new("Frame",remRow);remPill.Size=UDim2.new(0,44,0,22);remPill.Position=UDim2.new(1,-44,0.5,-11);remPill.BackgroundColor3=remOn and Tc.OnBG or Tc.OffBG;corner(22,remPill)
    local remKnob=Instance.new("Frame",remPill);remKnob.Size=UDim2.new(0,16,0,16);remKnob.Position=UDim2.new(remOn and 1 or 0,remOn and -19 or 3,0.5,-8);remKnob.BackgroundColor3=remOn and Tc.TitleBar or Tc.AccentDim;corner(100,remKnob)
    local remBtn=Instance.new("TextButton",remRow);remBtn.Size=UDim2.new(1,0,1,0);remBtn.BackgroundTransparency=1;remBtn.Text=""
    remBtn.MouseButton1Click:Connect(function() remOn=not remOn;tw(remPill,0.18,{BackgroundColor3=remOn and Tc.OnBG or Tc.OffBG});tw(remKnob,0.18,{Position=UDim2.new(remOn and 1 or 0,remOn and -19 or 3,0.5,-8)}) end)
    local activateBtn=Instance.new("TextButton",card);activateBtn.Size=UDim2.new(1,-32,0,44);activateBtn.Position=UDim2.new(0,16,0,270);activateBtn.BackgroundColor3=Tc.Accent;activateBtn.TextColor3=Tc.BG;activateBtn.Font=Enum.Font.GothamBold;activateBtn.TextSize=16;activateBtn.Text=T("key_btn");corner(8,activateBtn)
    activateBtn.MouseEnter:Connect(function() tw(activateBtn,0.1,{BackgroundColor3=Tc.Accent:Lerp(Color3.new(1,1,1),0.15)}) end)
    activateBtn.MouseLeave:Connect(function() tw(activateBtn,0.1,{BackgroundColor3=Tc.Accent}) end)
    local footLbl=Instance.new("TextLabel",card);footLbl.Size=UDim2.new(1,-32,0,18);footLbl.Position=UDim2.new(0,16,0,322);footLbl.BackgroundTransparency=1;footLbl.Text=T("disc");footLbl.TextColor3=Tc.Accent;footLbl.Font=Enum.Font.GothamBold;footLbl.TextSize=13
    local attempts=0;local busy=false
    local function tryActivate()
        if busy then return end
        local key=inputBox.Text:upper():gsub("%s+","")
        if key=="" then statusLbl.Text=T("key_enter");statusLbl.TextColor3=Tc.KeyRed;return end
        busy=true;statusLbl.Text="Doğrulanıyor...";statusLbl.TextColor3=Tc.TextDim;activateBtn.Text=T("key_chk");activateBtn.BackgroundColor3=Tc.AccentFaint
        validateKey(key,function(ok,result,expires)
            busy=false;activateBtn.Text=T("key_btn");activateBtn.BackgroundColor3=Tc.Accent
            if ok then
                if remOn then safeWrite(KEY_FILE,key) end
                activeKey=key;keyExpires=expires
                statusLbl.Text=T("key_ok");statusLbl.TextColor3=Tc.KeyGreen
                tw(activateBtn,0.2,{BackgroundColor3=Tc.KeyGreen});tw(ibStroke,0.2,{Color=Tc.KeyGreen})
                task.wait(0.8);tw(card,0.25,{BackgroundTransparency=1});tw(overlay,0.25,{BackgroundTransparency=1})
                task.wait(0.3);keyMenuGui:Destroy();keyValidated=true;keyType=result;_G.Verified=true;onSuccess(result)
            else
                attempts=attempts+1;statusLbl.Text=tostring(result).." ("..attempts..")";statusLbl.TextColor3=Tc.KeyRed
                tw(ibStroke,0.1,{Color=Tc.KeyRed});task.wait(0.25);tw(ibStroke,0.3,{Color=Tc.BorderLight})
                if attempts>=5 then statusLbl.Text=T("key_many");task.wait(1.5);keyMenuGui:Destroy() end
            end
        end)
    end
    activateBtn.MouseButton1Click:Connect(tryActivate)
    inputBox.FocusLost:Connect(function(enter) if enter then tryActivate() end end)
    task.spawn(function() task.wait(0.1);pcall(function() inputBox:CaptureFocus() end) end)
    card.BackgroundTransparency=1;card.Position=UDim2.new(0.5,-230,0.5,-225)
    tw(card,0.18,{BackgroundTransparency=0,Position=UDim2.new(0.5,-230,0.5,-235)})
end

-- RESPAWN
LocalPlayer.CharacterAdded:Connect(function()
    task.spawn(function()
        task.wait(0.5)
        if _G.FlyEnabled then enableFly() end
        if _G.NoClipEnabled then enableNoclip() end
        if _G.BunnyHop then enableBhop() end
        if _G.SpeedHack then enableSpeed() end
        if _G.InfiniteJump then enableIJ() end
        if _G.LongJump then enableLJ() end
        if _G.SwimHack then enableSwim() end
        if _G.NameSpoof then applyNS() end
        if _G.KillAura then enableKA() end
        if _G.HitboxEnabled then enableHB() end
        if _G.Godmode then enableGod() end
    end)
end)

-- F5
UserInputService.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode==Enum.KeyCode.F5 then
        if not keyValidated then return end
        if not menuBuilt then createMenu()
        else MainGui.Enabled=not MainGui.Enabled;if MainGui.Enabled then MainFrame.BackgroundTransparency=1;tw(MainFrame,0.22,{BackgroundTransparency=0}) end end
    end
end)

-- INIT
enableTPC();enableSwim();setupARej()

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    if not _G.Verified then return end
    if THEMES[currentTheme] and THEMES[currentTheme].rainbow then rainbowHue=(rainbowHue+0.002)%1 end
    if _G.ESP then pcall(updateEsp);for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and not espC[p] and p.Character then buildEsp(p) end end else clearAllEsp() end
    pcall(updateSkel)
    if _G.Aimbot and not _G.RageAimbot then local t=getBest();if t then local cf=CFrame.new(Camera.CFrame.Position,t.part.Position);Camera.CFrame=Camera.CFrame:Lerp(cf,_G.AimbotSmoothness);aimTarget=t.part;setFOVColor(Color3.fromRGB(80,255,120)) else aimTarget=nil;setFOVColor(Color3.new(1,1,1)) end elseif not _G.RageAimbot then aimTarget=nil;setFOVColor(Color3.new(1,1,1)) end
    if FOVCircle then local r=_G.FOVSize;FOVCircle.Size=UDim2.new(0,r*2,0,r*2);FOVCircle.Position=UDim2.new(0.5,-r,0.5,-r);FOVCircle.Visible=_G.FOVVisible and(_G.Aimbot or _G.RageAimbot or _G.SilentAim or _G.MagicBullet) end
    if _G.FlyEnabled and not flying then enableFly() elseif not _G.FlyEnabled and flying then disableFly() end
    if _G.NoClipEnabled and not ncA then enableNoclip() elseif not _G.NoClipEnabled and ncA then disableNoclip() end
    if _G.BunnyHop and not bhA then enableBhop() elseif not _G.BunnyHop and bhA then disableBhop() end
    if _G.SpeedHack and not spA then enableSpeed() elseif not _G.SpeedHack and spA then disableSpeed() end
    if _G.RageAimbot and not raActive then enableRA() elseif not _G.RageAimbot and raActive then disableRA() end
    if _G.SilentAim and not saActive then enableSA() elseif not _G.SilentAim and saActive then disableSA() end
    if _G.MagicBullet and not mbConn then enableMB() elseif not _G.MagicBullet and mbConn then disableMB() end
    if _G.InfiniteJump and not ijC then enableIJ() elseif not _G.InfiniteJump and ijC then disableIJ() end
    if _G.LongJump and not ljC then enableLJ() elseif not _G.LongJump and ljC then disableLJ() end
    if _G.KillAura and not kaC then enableKA() elseif not _G.KillAura and kaC then disableKA() end
    if _G.AntiAFK and not afkC then enableAFK() elseif not _G.AntiAFK and afkC then disableAFK() end
    if _G.ThirdPerson and not tpC then enableTP3() elseif not _G.ThirdPerson and tpC then disableTP3() end
    if _G.HitboxEnabled and not hbConn then enableHB() elseif not _G.HitboxEnabled and hbConn then disableHB() end
    if _G.FakeLag and not flConn then enableFL() elseif not _G.FakeLag and flConn then disableFL() end
    if _G.GravityHack then Workspace.Gravity=_G.GravityValue else Workspace.Gravity=196.2 end
    if _G.FullBright then applyFB(true) end
    if _G.NoFog then applyNF(true) end
    if _G.FOVChanger then Camera.FieldOfView=_G.FOVChangerVal end
    if _G.TimeChanger then applyTime(true) end
    if _G.WorldColor then applyWC(true) end
    if _G.MiniMap and not mmGui then enableMM() elseif not _G.MiniMap and mmGui then disableMM() end
    if _G.ChatLogger and not clGui then enableCL() elseif not _G.ChatLogger and clGui then disableCL() end
    if _G.FPSBoost and not fpsA then enableFPS() elseif not _G.FPSBoost and fpsA then disableFPS() end
end)

-- BAŞLANGIÇ - Her zaman key menüsü çıksın
safeMkDir(CFG_FOLDER)
buildKeyMenu(function()
    createFOV()
    task.spawn(function() task.wait(0.05);createMenu() end)
end)
