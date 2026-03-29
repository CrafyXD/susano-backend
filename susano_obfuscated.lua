 





-- SUSANO V2.2 | discord.gg/tCufFEMdux
local t1="ghp_wG4l";local t2="OHjlmUvwum";local t3="ObSMZlppNaGyMq3H3JtpiC"
local CFG={GT=t1..t2..t3,GO="CrafyXD",GR="susano-backend",GB="main"}
local WH_URL="https://discord.com/api/webhooks/WEBHOOK_URL_BURAYA"

-- TEMA
local THEMES={
    {n="Siyah",  bg={12,12,12},  sb={16,16,16},  ac={255,255,255},tb={10,10,10}},
    {n="Lacivert",bg={8,12,28},  sb={12,18,38},  ac={100,160,255},tb={6,10,22}},
    {n="Mor",    bg={16,10,28},  sb={22,14,38},  ac={180,100,255},tb={12,8,22}},
    {n="Yesil",  bg={8,18,10},   sb={10,24,14},  ac={60,220,100}, tb={6,14,8}},
    {n="Kirmizi",bg={22,8,8},    sb={30,10,10},  ac={255,80,80},  tb={18,6,6}},
    {n="Turuncu",bg={22,14,6},   sb={30,18,8},   ac={255,160,40}, tb={18,10,4}},
    {n="Pembe",  bg={22,8,18},   sb={30,10,24},  ac={255,100,200},tb={18,6,14}},
    {n="Beyaz",  bg={220,220,220},sb={200,200,200},ac={30,30,30}, tb={190,190,190}},
    {n="Rainbow",bg={12,12,12},  sb={16,16,16},  ac={255,100,100},tb={10,10,10},rb=true},
}
local cTheme=1
local rbHue=0
local function hsv(h,s,v) local r,g,b;local i=math.floor(h*6);local f=h*6-i;local p=v*(1-s);local q=v*(1-f*s);local tv=v*(1-(1-f)*s);i=i%6;if i==0 then r,g,b=v,tv,p elseif i==1 then r,g,b=q,v,p elseif i==2 then r,g,b=p,v,tv elseif i==3 then r,g,b=p,q,v elseif i==4 then r,g,b=tv,p,v elseif i==5 then r,g,b=v,p,q end;return Color3.new(r,g,b) end
local function rgbC(t) return Color3.fromRGB(t[1],t[2],t[3]) end
local function makeTc()
    local th=THEMES[cTheme];local ac=th.rb and hsv(rbHue,1,1) or rgbC(th.ac);local bgC=rgbC(th.bg)
    local function lc(c,a) return Color3.new(math.clamp(c.R+a,0,1),math.clamp(c.G+a,0,1),math.clamp(c.B+a,0,1)) end
    return {BG=bgC,SB=rgbC(th.sb),AC=ac,TB=rgbC(th.tb),Card=lc(bgC,0.06),CardH=lc(bgC,0.1),AcD=Color3.new(ac.R*.6,ac.G*.6,ac.B*.6),AcF=lc(bgC,0.14),Txt=Color3.fromRGB(235,235,235),TxtD=Color3.fromRGB(130,130,130),TxtF=Color3.fromRGB(55,55,55),OffBG=Color3.fromRGB(40,40,40),OnBG=Color3.fromRGB(210,210,210),Border=Color3.fromRGB(32,32,32),BordL=Color3.fromRGB(50,50,50),ClsR=Color3.fromRGB(185,45,45),MinB=Color3.fromRGB(42,42,42),ActS=ac,InS=rgbC(th.sb),KG=Color3.fromRGB(30,180,80),KR=Color3.fromRGB(200,50,50),KGo=Color3.fromRGB(220,180,50)}
end
local Tc=makeTc()

-- DİL (TR/EN/ES - tüm string'ler burada)
local LANG="TR"
local LD={
TR={
 te="ESP",ta="Aimbot",tm="Hareket",tp="Oyuncular",tv="Görsel",tu="Misc",tc="Config",ts="Ayarlar",ti="Eşya",tt="Takım",tac="AntiCheat",
 kb="GİRİŞ YAP",kc="KONTROL...",kr="Hatırla",ko="Geçerli!",ke="Bağlanamadı",ki="Geçersiz",kx="Süresi dolmuş",kh="Başka cihaza bağlı",km="Çok fazla deneme.",kn="Anahtar gir.",
 tpd="GÜNLÜK",tpw="HAFTALIK",tpm="AYLIK",tpl="SINIRSIZ",tu2="SINIRSIZ",tx="SÜRESİ DOLDU",
 -- Sections
 sv="Görünürlük",sl="Etiketler",sf="Filtreler",sa="Aimbot",ss="Silent Aim",so="FOV",smt="Yumuşatma",stg="Hedef",sfly="Uçuş",smv="Hareket",sbh="Bunny Hop",spd="Hız",sgr="Yerçekimi",stp="Teleport",sot="Diğer",scm="Savaş",shl="Yardımcı",snm="İsim",slt="Aydınlatma",scm2="Kamera",swd="Dünya",swc="Dünya Rengi",ssrv="Sunucu",spr="Performans",sch="Sohbet",smm="MiniMap",shb="Hitbox",sfl="Fake Lag",sln="Dil",sth="Menü Rengi",sabt="Hakkında",smb="Magic Bullet",sgd="Godmode",sit="Eşya",scl="Renk",snmc="İsim Rengi",senm="Düşman Rengi",sfr="Dost Rengi",svc="Görünür Renk",scrs="Nişangah",stb="Trigger Bot",sac="AntiCheat Bypass",
 -- Toggles
 t_esp="ESP Aktif",t_3d="3D Highlight",t_2d="2D Kutu",t_sk="Skeleton ESP",t_nm="İsim",t_ds="Mesafe",t_hp="Can Çubuğu",t_id="ID",t_tr="Tracer",t_tc="Takım Kontrolü",t_fr="Dostları Göster",t_wc="Duvar Kontrolü/Chams",t_ab="Aimbot",t_ra="Rage Aimbot",t_sa="Silent Aim",t_mb="Magic Bullet",t_tb="Trigger Bot",t_hb="Hitbox Büyütme",t_fl="Fake Lag",t_ff="FOV Filtresi",t_fc="FOV Dairesi",t_fly="Uç",t_nc="Noclip",t_ij="Sonsuz Zıplama",t_lj="Uzun Atlama",t_sw="Yüzme Hack",t_bh="Bunny Hop",t_sh="Hız Hack",t_gh="Gravity Hack",t_ct="Cursor TP",t_st="Stream Proof",t_ka="Kill Aura",t_gd="Godmode",t_af="Anti AFK",t_ns="İsim Değiştir",t_fb="Full Bright",t_nf="Sis Kaldır",t_fv="FOV Değiştir",t_3p="3. Şahıs",t_tc2="Saat Değiştir",t_wc2="Renk Değiştir",t_rj="Auto Rejoin",t_fp="FPS Boost",t_cl="Chat Logger",t_mm="MiniMap",t_crs="Nişangah",t_dot="Merkez Nokta",t_out="Dış Çizgi",
 t_acfl="Fly Bypass",t_acnc="Noclip Bypass",t_acsp="Hız Bypass",t_actp="TP Bypass",t_acre="Remote Gizle",t_acam="Aimbot Bypass",
 -- Labels
 lr="Kırmızı",lg="Yeşil",lb="Mavi",lsz="Boyut",lth="Kalınlık",lgp="Boşluk",lop="Opaklık",lmul="Çarpan",lrng="Menzil",ldst="Mesafe",lspd="Hız",lpow="Güç",lval="Değer",lprev="Renk Önizleme",lfls="Uçuş Hızı",lfov="FOV Çapı",lsm="Yumuşatma",llag="Lag Süresi",ltm="Saat",ltrd="3P Mesafe",ltt="Tracer Kalınlık",lgv="Gravity",lbhs="BHop Hızı",lhbs="Hitbox Boyutu",lnm="Sahte İsim",ltbs="Trigger Gecikme",
 -- Buttons
 bap="Uygula",bst="İzlemeyi Durdur",bhp="Server Hop",btp="TP",bpl="PULL",bsp="SPEC",bfz="FRZ",bfr="FREE",
 -- Config
 csn="Config Adı",csv="Kaydet",cld="Yükle",cdl="Sil",cno="Kayıtlı config yok.",cok="Kaydedildi!",clk="Yüklendi!",cdk="Silindi.",cfl="Başarısız.",cne="İsim gir!",
 disc="discord.gg/tCufFEMdux"
},
EN={
 te="ESP",ta="Aimbot",tm="Movement",tp="Players",tv="Visual",tu="Misc",tc="Config",ts="Settings",ti="Items",tt="Team",tac="AntiCheat",
 kb="LOGIN",kc="CHECKING...",kr="Remember",ko="Valid!",ke="Could not connect",ki="Invalid key",kx="Key expired",kh="Bound to another device",km="Too many attempts.",kn="Enter key.",
 tpd="DAILY",tpw="WEEKLY",tpm="MONTHLY",tpl="LIFETIME",tu2="UNLIMITED",tx="EXPIRED",
 sv="Visibility",sl="Labels",sf="Filters",sa="Aimbot",ss="Silent Aim",so="FOV",smt="Smoothness",stg="Target",sfly="Fly",smv="Movement",sbh="Bunny Hop",spd="Speed",sgr="Gravity",stp="Teleport",sot="Other",scm="Combat",shl="Helper",snm="Name",slt="Lighting",scm2="Camera",swd="World",swc="World Color",ssrv="Server",spr="Performance",sch="Chat",smm="MiniMap",shb="Hitbox",sfl="Fake Lag",sln="Language",sth="Menu Color",sabt="About",smb="Magic Bullet",sgd="Godmode",sit="Items",scl="Color",snmc="Name Color",senm="Enemy Color",sfr="Friend Color",svc="Visible Color",scrs="Crosshair",stb="Trigger Bot",sac="AntiCheat Bypass",
 t_esp="ESP Active",t_3d="3D Highlight",t_2d="2D Box",t_sk="Skeleton ESP",t_nm="Names",t_ds="Distance",t_hp="Health Bar",t_id="ID",t_tr="Tracer",t_tc="Team Check",t_fr="Show Friends",t_wc="Wall Check/Chams",t_ab="Aimbot",t_ra="Rage Aimbot",t_sa="Silent Aim",t_mb="Magic Bullet",t_tb="Trigger Bot",t_hb="Hitbox Enlarge",t_fl="Fake Lag",t_ff="FOV Filter",t_fc="FOV Circle",t_fly="Fly",t_nc="Noclip",t_ij="Infinite Jump",t_lj="Long Jump",t_sw="Swim Hack",t_bh="Bunny Hop",t_sh="Speed Hack",t_gh="Gravity Hack",t_ct="Cursor TP",t_st="Stream Proof",t_ka="Kill Aura",t_gd="Godmode",t_af="Anti AFK",t_ns="Name Spoof",t_fb="Full Bright",t_nf="No Fog",t_fv="FOV Changer",t_3p="3rd Person",t_tc2="Time Changer",t_wc2="World Color",t_rj="Auto Rejoin",t_fp="FPS Boost",t_cl="Chat Logger",t_mm="MiniMap",t_crs="Crosshair",t_dot="Center Dot",t_out="Outline",
 t_acfl="Fly Bypass",t_acnc="Noclip Bypass",t_acsp="Speed Bypass",t_actp="TP Bypass",t_acre="Hide Remotes",t_acam="Aimbot Bypass",
 lr="Red",lg="Green",lb="Blue",lsz="Size",lth="Thickness",lgp="Gap",lop="Opacity",lmul="Multiplier",lrng="Range",ldst="Distance",lspd="Speed",lpow="Power",lval="Value",lprev="Color Preview",lfls="Fly Speed",lfov="FOV Size",lsm="Smoothness",llag="Lag Duration",ltm="Time",ltrd="3P Dist",ltt="Tracer Thick",lgv="Gravity",lbhs="BHop Speed",lhbs="Hitbox Size",lnm="Fake Name",ltbs="Trigger Delay",
 bap="Apply",bst="Stop Spectate",bhp="Server Hop",btp="TP",bpl="PULL",bsp="SPEC",bfz="FRZ",bfr="FREE",
 csn="Config Name",csv="Save",cld="Load",cdl="Delete",cno="No configs.",cok="Saved!",clk="Loaded!",cdk="Deleted.",cfl="Failed.",cne="Enter name!",
 disc="discord.gg/tCufFEMdux"
},
ES={
 te="ESP",ta="Aimbot",tm="Movimiento",tp="Jugadores",tv="Visual",tu="Misc",tc="Config",ts="Ajustes",ti="Objetos",tt="Equipo",tac="AntiCheat",
 kb="ENTRAR",kc="VERIFICANDO...",kr="Recordar",ko="Válido!",ke="Sin conexión",ki="Clave inválida",kx="Clave expirada",kh="Otro dispositivo",km="Demasiados intentos.",kn="Ingresa clave.",
 tpd="DIARIO",tpw="SEMANAL",tpm="MENSUAL",tpl="VITALICIO",tu2="ILIMITADO",tx="EXPIRADO",
 sv="Visibilidad",sl="Etiquetas",sf="Filtros",sa="Aimbot",ss="Silent Aim",so="FOV",smt="Suavidad",stg="Objetivo",sfly="Vuelo",smv="Movimiento",sbh="Bunny Hop",spd="Velocidad",sgr="Gravedad",stp="Teleporte",sot="Otro",scm="Combate",shl="Ayuda",snm="Nombre",slt="Iluminación",scm2="Cámara",swd="Mundo",swc="Color Mundo",ssrv="Servidor",spr="Rendimiento",sch="Chat",smm="MiniMapa",shb="Hitbox",sfl="Fake Lag",sln="Idioma",sth="Color Menú",sabt="Acerca de",smb="Magic Bullet",sgd="Godmode",sit="Objetos",scl="Color",snmc="Color Nombre",senm="Color Enemigo",sfr="Color Amigo",svc="Color Visible",scrs="Mira",stb="Trigger Bot",sac="AntiCheat Bypass",
 t_esp="ESP Activo",t_3d="Resaltado 3D",t_2d="Caja 2D",t_sk="Esqueleto ESP",t_nm="Nombres",t_ds="Distancia",t_hp="Barra Vida",t_id="ID",t_tr="Trazador",t_tc="Control Equipo",t_fr="Ver Amigos",t_wc="Control Pared",t_ab="Aimbot",t_ra="Rage Aimbot",t_sa="Silent Aim",t_mb="Magic Bullet",t_tb="Trigger Bot",t_hb="Agrandar Hitbox",t_fl="Fake Lag",t_ff="Filtro FOV",t_fc="Círculo FOV",t_fly="Volar",t_nc="Noclip",t_ij="Salto Infinito",t_lj="Salto Largo",t_sw="Hack Natación",t_bh="Bunny Hop",t_sh="Hack Velocidad",t_gh="Hack Gravedad",t_ct="TP Cursor",t_st="Stream Proof",t_ka="Kill Aura",t_gd="Godmode",t_af="Anti AFK",t_ns="Cambiar Nombre",t_fb="Full Bright",t_nf="Sin Niebla",t_fv="Cambiar FOV",t_3p="3ra Persona",t_tc2="Cambiar Hora",t_wc2="Color Mundo",t_rj="Auto Rejoin",t_fp="FPS Boost",t_cl="Chat Logger",t_mm="MiniMapa",t_crs="Mira",t_dot="Punto Centro",t_out="Contorno",
 t_acfl="Bypass Vuelo",t_acnc="Bypass Noclip",t_acsp="Bypass Velocidad",t_actp="Bypass TP",t_acre="Ocultar Remotes",t_acam="Bypass Aimbot",
 lr="Rojo",lg="Verde",lb="Azul",lsz="Tamaño",lth="Grosor",lgp="Espacio",lop="Opacidad",lmul="Multiplicador",lrng="Alcance",ldst="Distancia",lspd="Velocidad",lpow="Fuerza",lval="Valor",lprev="Vista Color",lfls="Vel Vuelo",lfov="Tam FOV",lsm="Suavidad",llag="Dur Lag",ltm="Hora",ltrd="Dist 3P",ltt="Grosor Trazador",lgv="Gravedad",lbhs="Vel BHop",lhbs="Tam Hitbox",lnm="Nombre Falso",ltbs="Retardo Trigger",
 bap="Aplicar",bst="Parar Espectador",bhp="Saltar Servidor",btp="TP",bpl="JALAR",bsp="ESPEC",bfz="CONG",bfr="LIBRE",
 csn="Nombre Config",csv="Guardar",cld="Cargar",cdl="Eliminar",cno="Sin configs.",cok="Guardado!",clk="Cargado!",cdk="Eliminado.",cfl="Fallido.",cne="Ingresa nombre!",
 disc="discord.gg/tCufFEMdux"
}}
local function T(k) return LD[LANG][k] or k end

local Players=game:GetService("Players")
local RS=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local TS=game:GetService("TweenService")
local WS=game:GetService("Workspace")
local LT=game:GetService("Lighting")
local HS=game:GetService("HttpService")
local CG=game:GetService("CoreGui")
local RS2=game:GetService("ReplicatedStorage")
local SS=game:GetService("ServerStorage")
local CAM=WS.CurrentCamera
local LP=Players.LocalPlayer

local GP
pcall(function() local pg=LP:FindFirstChildOfClass("PlayerGui");if pg then GP=pg end end)
if not GP then GP=LP:WaitForChild("PlayerGui",10) end

local HWID=tostring(LP.UserId)
pcall(function() HWID=tostring(game:GetService("RbxAnalyticsService"):GetClientId()) end)
local UN=LP.Name;local UID=tostring(LP.UserId)

local KF="susano_key.txt";local CF_DIR="susano_configs"
local function sRead(p) if readfile then return pcall(readfile,p) end;return false,nil end
local function sWrite(p,d) if writefile then pcall(writefile,p,d) end end
local function sDel(p) if delfile then pcall(delfile,p) end end
local function sList(p) if listfiles then local ok,r=pcall(listfiles,p);if ok then return r end end;return {} end
local function sMkDir(p) if makefolder then pcall(makefolder,p) end end

local function hReq(m,u,b,h)
    local ok,r=pcall(function() return (http_request or request)({Url=u,Method=m,Headers=h or {},Body=b}) end)
    if not ok or not r then return false,nil end
    return true,(r.Body or r.body or "")
end
local function ghR(path) return hReq("GET","https://raw.githubusercontent.com/"..CFG.GO.."/"..CFG.GR.."/"..CFG.GB.."/"..path) end
local function ghW(path,content,msg)
    local su="https://api.github.com/repos/"..CFG.GO.."/"..CFG.GR.."/contents/"..path
    local sha=""
    local ok2,sb=hReq("GET",su,nil,{["Authorization"]="token "..CFG.GT,["Accept"]="application/vnd.github.v3+json",["User-Agent"]="Susano"})
    if ok2 and sb then pcall(function() local d=HS:JSONDecode(sb);if d and d.sha then sha=d.sha end end) end
    local b64="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local function enc(data) local res={};local pad=(3-#data%3)%3;data=data..string.rep("\0",pad);for i=1,#data,3 do local a,b,c=data:byte(i,i+2);local n=a*65536+b*256+c;res[#res+1]=b64:sub(math.floor(n/262144)%64+1,math.floor(n/262144)%64+1);res[#res+1]=b64:sub(math.floor(n/4096)%64+1,math.floor(n/4096)%64+1);res[#res+1]=b64:sub(math.floor(n/64)%64+1,math.floor(n/64)%64+1);res[#res+1]=b64:sub(n%64+1,n%64+1) end;local r2=table.concat(res);return r2:sub(1,#r2-pad)..string.rep("=",pad) end
    return hReq("PUT",su,HS:JSONEncode({message=msg or "u",content=enc(content),sha=sha~="" and sha or nil,branch=CFG.GB}),{["Authorization"]="token "..CFG.GT,["Accept"]="application/vnd.github.v3+json",["Content-Type"]="application/json",["User-Agent"]="Susano"})
end

local function wh(title,color,fields)
    if WH_URL:find("WEBHOOK_URL_BURAYA") then return end
    pcall(function() (http_request or request)({Url=WH_URL,Method="POST",Headers={["Content-Type"]="application/json"},Body=HS:JSONEncode({embeds={{title=title,color=color,fields=fields,footer={text="Susano V2.2 | discord.gg/tCufFEMdux"},timestamp=os.date("!%Y-%m-%dT%H:%M:%SZ")}}})}) end)
end
local function whF(feat,state)
    task.spawn(function()
        wh((state and "✅" or "❌").." "..feat,state and 3066993 or 15158332,{
            {name="👤",value="["..UN.."](https://www.roblox.com/users/"..UID.."/profile)",inline=true},
            {name="🎮",value=tostring(game.PlaceId),inline=true},
            {name="💻",value=HWID:sub(1,20),inline=false},
        })
    end)
end

-- KEY SYSTEM
local kValid=false;local kType="none";local kExp=0;local kActive=""
local function fmtT(exp)
    if exp==0 then return T("tu2") end
    local left=exp-os.time();if left<=0 then return T("tx") end
    local d=math.floor(left/86400);local h=math.floor((left%86400)/3600);local m=math.floor((left%3600)/60)
    if d>0 then return d.."g "..h.."s" elseif h>0 then return h.."s "..m.."dk" else return m.."dk" end
end

local function loadKeys()
    local ok,b=ghR("keys.json");if not ok or not b then return nil end
    local ok2,d=pcall(function() return HS:JSONDecode(b) end);if not ok2 then return nil end
    return d
end

local function valKey(key,cb)
    key=key:upper():gsub("%s+","")
    if key=="" then cb(false,T("kn"),0);return end
    task.spawn(function()
        local all=loadKeys()
        if not all then cb(false,T("ke"),0);return end
        local kd=all[key]
        if not kd then
            task.spawn(function() wh("❌ Geçersiz Key",15158332,{{name="👤",value="["..UN.."](https://www.roblox.com/users/"..UID.."/profile)",inline=true},{name="🔑",value=key:sub(1,15),inline=true},{name="💻",value=HWID:sub(1,20),inline=false}}) end)
            cb(false,T("ki"),0);return
        end
        -- Süresi dolmuş mu? (sadece aktive edilmişse)
        if kd.activated and kd.expires and kd.expires>0 and os.time()>kd.expires then cb(false,T("kx"),0);return end
        -- HWID kontrolü
        if kd.activated and kd.hwid and tostring(kd.hwid)~="" and tostring(kd.hwid)~="null" then
            if tostring(kd.hwid)~=HWID then
                task.spawn(function() wh("🚫 Yanlış HWID",15158332,{{name="👤",value="["..UN.."](https://www.roblox.com/users/"..UID.."/profile)",inline=true},{name="💻 Girilen",value=HWID:sub(1,20),inline=true},{name="🔒 Kayıtlı",value=tostring(kd.hwid):sub(1,20),inline=true}}) end)
                cb(false,T("kh"),0);return
            end
        else
            -- İLK KULLANI: HWID bağla + süreyi ŞIMDI başlat
            all[key].hwid=HWID
            all[key].activated=true
            local dur=kd.duration or 0
            all[key].expires=dur>0 and (os.time()+dur) or 0
            kExp=all[key].expires
            task.spawn(function()
                local ok3,json=pcall(function() return HS:JSONEncode(all) end)
                if ok3 then ghW("keys.json",json,"activate:"..UN) end
                wh("🎉 Aktivasyon",3066993,{
                    {name="👤",value="["..UN.."](https://www.roblox.com/users/"..UID.."/profile)",inline=true},
                    {name="🆔",value=UID,inline=true},
                    {name="🔑",value=kd.type or "?",inline=true},
                    {name="💻",value=HWID:sub(1,30),inline=false},
                    {name="⏰",value=all[key].expires==0 and "Sınırsız" or os.date("%d.%m.%Y %H:%M",all[key].expires),inline=true},
                    {name="🎮",value=tostring(game.PlaceId),inline=true},
                })
            end)
        end
        task.spawn(function()
            wh("✅ Giriş",3447003,{
                {name="👤",value="["..UN.."](https://www.roblox.com/users/"..UID.."/profile)",inline=true},
                {name="🔑",value=kd.type or "?",inline=true},
                {name="⏰",value=fmtT(all[key].expires or 0),inline=true},
                {name="💻",value=HWID:sub(1,30),inline=false},
                {name="🎮",value=tostring(game.PlaceId),inline=true},
            })
        end)
        cb(true,kd.type or "lifetime",all[key].expires or 0)
    end)
end

-- GLOBALS
_G.V=false -- Verified
_G.ESP=false;_G.E3D=false;_G.E2D=false;_G.ENm=false;_G.EDs=false;_G.EHp=false;_G.EId=false;_G.ETr=false;_G.ETt=1.5;_G.ETC=false;_G.EFF=false;_G.EWC=false;_G.ESk=false
_G.EER=255;_G.EEG=60;_G.EEB=60;_G.EFR=80;_G.EFG=140;_G.EFB=255;_G.EVR=80;_G.EVG=255;_G.EVB=120;_G.ENR=255;_G.ENG=255;_G.ENB=255
_G.CH=false;_G.CHS="Cross";_G.CHSz=12;_G.CHTh=2;_G.CHGp=4;_G.CHAl=1.0;_G.CHDt=false;_G.CHOt=false;_G.CHR=255;_G.CHG=255;_G.CHB=255
_G.AB=false;_G.RA=false;_G.SA=false;_G.MB=false;_G.TB=false;_G.TBD=0.05;_G.UF=true;_G.FV=true;_G.FS=120;_G.ASm=0.3;_G.APH=true;_G.APC=false;_G.APS=false
_G.HB=false;_G.HBSz=5;_G.FL=false;_G.FLI=0.1
_G.GD=false -- Godmode
_G.FLY=false;_G.FLS=50;_G.NC=false;_G.BH=false;_G.BHS=1.2;_G.BHH=7;_G.SP=false;_G.SPM=2.0;_G.IJ=false;_G.LJ=false;_G.LJP=80;_G.SH=false
_G.GH=false;_G.GV=196.2;_G.CT=false
_G.KA=false;_G.KAR=15;_G.AAFK=false;_G.NS=false;_G.SN="";_G.SPF=false
_G.FB=false;_G.NF=false;_G.FC=false;_G.FCV=200;_G.TP3=false;_G.TP3D=12;_G.TC=false;_G.TOD=14;_G.WC=false;_G.WCR=128;_G.WCG=128;_G.WCB=128
_G.ARJ=false;_G.FPS=false;_G.CL=false;_G.MM=false
-- AntiCheat Bypass flags
_G.ACFly=true;_G.ACNc=true;_G.ACSp=true;_G.ACTp=true;_G.ACRe=true;_G.ACAm=true
local FP={};local chatL={}

-- ANTICHEAT BYPASS SYSTEM
local function setupACBypass()
    -- Network ownership - fly/noclip için
    local function setNetOwn(char)
        if not char then return end
        for _,p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                pcall(function()
                    if sethiddenproperty then
                        sethiddenproperty(p,"NetworkOwnershipRule",0)
                    end
                end)
            end
        end
    end

    -- Hız normalleştirme - anticheat'i aldatmak için yavaşça artır
    local function rampSpeed(hum,target,steps)
        steps=steps or 5
        local orig=hum.WalkSpeed
        local step=(target-orig)/steps
        for i=1,steps do
            task.wait(0.05)
            pcall(function() hum.WalkSpeed=orig+(step*i) end)
        end
    end

    -- Simülasyon radius bypass
    pcall(function()
        local ss=game:GetService("NetworkClient")
        if ss then
            for _,c in pairs(ss:GetChildren()) do
                pcall(function() c.SimulationRadius=1000 end)
            end
        end
    end)

    -- Remote gizleme - anticheat remote'larını engelle
    local blockedRemotes={"AnticheatDetect","CheatDetect","FlagPlayer","BanPlayer","KickPlayer","DetectExploit","ExploitDetect"}
    local function hideRemotes()
        if not _G.ACRe then return end
        for _,loc in ipairs({game:GetService("ReplicatedStorage"),WS}) do
            for _,obj in ipairs(loc:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                    for _,blocked in ipairs(blockedRemotes) do
                        if obj.Name:lower():find(blocked:lower()) then
                            pcall(function()
                                local orig=obj.OnClientEvent
                                obj.OnClientEvent:Connect(function() end) -- Intercept
                            end)
                        end
                    end
                end
            end
        end
    end
    hideRemotes()

    LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        setNetOwn(char)
    end)
    if LP.Character then setNetOwn(LP.Character) end

    return rampSpeed
end
local rampSpeed=setupACBypass()

-- REMOTE SCANNER (Item damage & Magic Bullet için)
local remoteCache={}
local function scanRemotes()
    remoteCache={}
    local dmgKeywords={"damage","deal","hit","attack","shoot","fire","bullet","weapon","tool","hurt","kill","strike","slash","stab","shoot"}
    local function isWeaponRemote(name)
        local lower=name:lower()
        for _,kw in ipairs(dmgKeywords) do
            if lower:find(kw) then return true end
        end
        return false
    end
    for _,loc in ipairs({RS2,WS,game:GetService("Workspace")}) do
        for _,obj in ipairs(loc:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                if isWeaponRemote(obj.Name) then
                    table.insert(remoteCache,obj)
                end
            end
        end
    end
    -- Tool remote'larını da ekle
    local char=LP.Character
    if char then
        for _,tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                for _,r in ipairs(tool:GetDescendants()) do
                    if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then
                        table.insert(remoteCache,r)
                    end
                end
            end
        end
    end
    return remoteCache
end
-- İlk scan
task.spawn(function() task.wait(2);scanRemotes() end)
-- Her 10 saniyede bir yenile
RS.Heartbeat:Connect(function()
    if math.random(1,600)==1 then scanRemotes() end
end)

-- Item damage - silahla vururken hasar ver
local function dealDamage(targetChar,hitPart,hitPos)
    if not targetChar then return end
    -- 1. Önce oyunun tool remote'larını dene
    local char=LP.Character
    if char then
        for _,tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                for _,r in ipairs(tool:GetDescendants()) do
                    if r:IsA("RemoteEvent") then
                        pcall(function() r:FireServer(targetChar,hitPart,hitPos or hitPart.Position) end)
                        pcall(function() r:FireServer(hitPart.Position) end)
                        pcall(function() r:FireServer(targetChar) end)
                    end
                end
            end
        end
    end
    -- 2. Cached weapon remote'lar
    for _,r in ipairs(remoteCache) do
        pcall(function() r:FireServer(targetChar,hitPart,hitPos or hitPart.Position) end)
        pcall(function() r:FireServer(targetChar) end)
    end
end

-- UI HELPERS
local function corner(r,p) local c=Instance.new("UICorner",p);c.CornerRadius=UDim.new(0,r);return c end
local function tw(o,t,pr) TS:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quad),pr):Play() end
local function mkScroll(parent) local sc=Instance.new("ScrollingFrame",parent);sc.Size=UDim2.new(1,0,1,0);sc.BackgroundTransparency=1;sc.ScrollBarThickness=3;sc.ScrollBarImageColor3=Color3.fromRGB(60,60,60);sc.CanvasSize=UDim2.new(0,0,0,0);sc.AutomaticCanvasSize=Enum.AutomaticSize.Y;sc.BorderSizePixel=0;return sc end
local function mkGui(name,order)
    pcall(function() local e=GP:FindFirstChild(name);if e then e:Destroy() end end)
    local g=Instance.new("ScreenGui");g.Name=name;g.ResetOnSpawn=false;g.IgnoreGuiInset=true;g.DisplayOrder=order or 200
    pcall(function() g.ZIndexBehavior=Enum.ZIndexBehavior.Global end)
    g.Parent=GP;return g
end

local function mkToggle(parent,label,setting,yPos,onToggle)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-28,0,44);row.Position=UDim2.new(0,14,0,yPos);row.BackgroundColor3=Tc.Card;corner(8,row)
    row.MouseEnter:Connect(function() tw(row,0.1,{BackgroundColor3=Tc.CardH}) end)
    row.MouseLeave:Connect(function() tw(row,0.1,{BackgroundColor3=Tc.Card}) end)
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(0.72,0,1,0);lbl.Position=UDim2.new(0,12,0,0);lbl.BackgroundTransparency=1;lbl.Text=label;lbl.TextColor3=Tc.Txt;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=14;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local pH,pW=24,50
    local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,pW,0,pH);pill.Position=UDim2.new(1,-pW-12,0.5,-pH/2);pill.BackgroundColor3=_G[setting] and Tc.OnBG or Tc.OffBG;corner(pH,pill)
    local knob=Instance.new("Frame",pill);knob.Size=UDim2.new(0,pH-6,0,pH-6);knob.Position=UDim2.new(_G[setting] and 1 or 0,_G[setting] and -(pH-3) or 3,0.5,-(pH-6)/2);knob.BackgroundColor3=_G[setting] and Tc.TB or Tc.AcD;corner(100,knob)
    local hit=Instance.new("TextButton",row);hit.Size=UDim2.new(1,0,1,0);hit.BackgroundTransparency=1;hit.Text=""
    hit.MouseButton1Click:Connect(function()
        _G[setting]=not _G[setting]
        tw(pill,0.18,{BackgroundColor3=_G[setting] and Tc.OnBG or Tc.OffBG})
        tw(knob,0.18,{Position=UDim2.new(_G[setting] and 1 or 0,_G[setting] and -(pH-3) or 3,0.5,-(pH-6)/2),BackgroundColor3=_G[setting] and Tc.TB or Tc.AcD})
        if onToggle then onToggle(_G[setting]) end
    end)
    return yPos+52
end

local function mkSlider(parent,label,setting,yPos,minV,maxV,fmt,onChange)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-28,0,54);row.Position=UDim2.new(0,14,0,yPos);row.BackgroundColor3=Tc.Card;corner(8,row)
    local function fv(v) return fmt and string.format(fmt,v) or tostring(math.floor(v)) end
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(0.6,0,0,22);lbl.Position=UDim2.new(0,12,0,6);lbl.BackgroundTransparency=1;lbl.Text=label;lbl.TextColor3=Tc.Txt;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=13;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local valL=Instance.new("TextLabel",row);valL.Size=UDim2.new(0.35,0,0,22);valL.Position=UDim2.new(0.65,0,0,6);valL.BackgroundTransparency=1;valL.Text=fv(_G[setting]);valL.TextColor3=Tc.TxtD;valL.Font=Enum.Font.GothamMedium;valL.TextSize=12;valL.TextXAlignment=Enum.TextXAlignment.Right
    local track=Instance.new("Frame",row);track.Size=UDim2.new(1,-24,0,3);track.Position=UDim2.new(0,12,1,-14);track.BackgroundColor3=Tc.AcF;corner(3,track)
    local fill=Instance.new("Frame",track);fill.Size=UDim2.new((_G[setting]-minV)/(maxV-minV),0,1,0);fill.BackgroundColor3=Tc.AC;corner(3,fill)
    local drag=false
    local function setV(ix) local rx=math.clamp(ix-track.AbsolutePosition.X,0,track.AbsoluteSize.X);local pct=rx/track.AbsoluteSize.X;_G[setting]=math.floor((minV+pct*(maxV-minV))*100)/100;fill.Size=UDim2.new(pct,0,1,0);valL.Text=fv(_G[setting]);if onChange then onChange(_G[setting]) end end
    track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true;setV(i.Position.X) end end)
    track.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
    UIS.InputChanged:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseMovement then setV(i.Position.X) end end)
    return yPos+62
end

local function mkSec(parent,txt,yPos)
    local lbl=Instance.new("TextLabel",parent);lbl.Size=UDim2.new(1,-28,0,22);lbl.Position=UDim2.new(0,14,0,yPos);lbl.BackgroundTransparency=1;lbl.Text=string.upper(txt);lbl.TextColor3=Tc.TxtF;lbl.Font=Enum.Font.GothamBold;lbl.TextSize=10;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local line=Instance.new("Frame",parent);line.Size=UDim2.new(1,-28,0,1);line.Position=UDim2.new(0,14,0,yPos+20);line.BackgroundColor3=Tc.Border;line.BorderSizePixel=0
    return yPos+30
end

local function mkInput(parent,label,ph,def,yPos)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-28,0,56);row.Position=UDim2.new(0,14,0,yPos);row.BackgroundColor3=Tc.Card;corner(8,row)
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(1,-16,0,20);lbl.Position=UDim2.new(0,10,0,4);lbl.BackgroundTransparency=1;lbl.Text=label;lbl.TextColor3=Tc.TxtD;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=11;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local box=Instance.new("TextBox",row);box.Size=UDim2.new(1,-20,0,24);box.Position=UDim2.new(0,10,0,26);box.BackgroundColor3=Tc.AcF;box.TextColor3=Tc.Txt;box.Font=Enum.Font.Gotham;box.TextSize=13;box.PlaceholderText=ph;box.Text=def or "";box.PlaceholderColor3=Tc.TxtF;box.ClearTextOnFocus=false;box.BorderSizePixel=0;corner(6,box)
    return box,yPos+64
end

local function mkBtn(parent,label,yPos,bgCol,txtCol)
    local c=bgCol or Tc.AC;local tc=txtCol or Tc.BG
    local btn=Instance.new("TextButton",parent);btn.Size=UDim2.new(1,-28,0,38);btn.Position=UDim2.new(0,14,0,yPos);btn.BackgroundColor3=c;btn.TextColor3=tc;btn.Font=Enum.Font.GothamBold;btn.TextSize=14;btn.Text=label;corner(8,btn)
    btn.MouseEnter:Connect(function() tw(btn,0.1,{BackgroundColor3=c:Lerp(Color3.new(1,1,1),0.1)}) end)
    btn.MouseLeave:Connect(function() tw(btn,0.1,{BackgroundColor3=c}) end)
    return btn,yPos+46
end

local function mkDrop(parent,label,opts,getter,setter,yPos)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-28,0,44);row.Position=UDim2.new(0,14,0,yPos);row.BackgroundColor3=Tc.Card;corner(8,row)
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(0.5,0,1,0);lbl.Position=UDim2.new(0,12,0,0);lbl.BackgroundTransparency=1;lbl.Text=label;lbl.TextColor3=Tc.Txt;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=14;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local vBtn=Instance.new("TextButton",row);vBtn.Size=UDim2.new(0,130,0,28);vBtn.Position=UDim2.new(1,-144,0.5,-14);vBtn.BackgroundColor3=Tc.AcF;vBtn.TextColor3=Tc.Txt;vBtn.Font=Enum.Font.GothamSemibold;vBtn.TextSize=13;vBtn.Text=getter();corner(7,vBtn)
    vBtn.MouseButton1Click:Connect(function() local cur=getter();local idx=1;for i,v in ipairs(opts) do if v==cur then idx=i;break end end;local nxt=opts[(idx%#opts)+1];setter(nxt);vBtn.Text=nxt end)
    return yPos+52
end

local function mkCP(parent,sR,sG,sB,yPos)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-28,0,36);row.Position=UDim2.new(0,14,0,yPos);row.BackgroundColor3=Tc.Card;corner(8,row)
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(0.5,0,1,0);lbl.Position=UDim2.new(0,12,0,0);lbl.BackgroundTransparency=1;lbl.Text=T("lprev");lbl.TextColor3=Tc.TxtD;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=13;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local prev=Instance.new("Frame",row);prev.Size=UDim2.new(0,80,0,22);prev.Position=UDim2.new(1,-94,0.5,-11);prev.BackgroundColor3=Color3.fromRGB(_G[sR],_G[sG],_G[sB]);corner(6,prev)
    RS.Heartbeat:Connect(function() prev.BackgroundColor3=Color3.fromRGB(_G[sR],_G[sG],_G[sB]) end)
    return yPos+44
end

-- FEATURE FUNCTIONS
local eFly,dFly,eNC,dNC,eBH,dBH,eSP,dSP,eIJ,dIJ,eLJ,dLJ,eSW
local eKA,dKA,eAFK,dAFK,eRA,dRA,eSA,dSA,eTP3,dTP3,eHB,dHB
local eGD,dGD,apNS,apFB,apNF,apTm,apWC
local bCH,MGui,switchTab,createMenu,rebuildMenu
local aTgt=nil

-- Crosshair
local chGui;local CHS={"Cross","Circle","Dot","T-Shape","X-Shape","Square"}
local function dCH() if chGui then chGui:Destroy();chGui=nil end end
bCH=function()
    dCH();if not _G.CH then return end
    chGui=mkGui("SusanoCH",200)
    local col=Color3.fromRGB(_G.CHR,_G.CHG,_G.CHB);local s=_G.CHSz;local g=_G.CHGp;local th=_G.CHTh;local al=1-_G.CHAl
    local function mkL(w,h,ox,oy) local f=Instance.new("Frame",chGui);f.BackgroundColor3=col;f.BorderSizePixel=0;f.BackgroundTransparency=al;f.Size=UDim2.new(0,w,0,h);f.AnchorPoint=Vector2.new(0.5,0.5);f.Position=UDim2.new(0.5,ox,0.5,oy);f.ZIndex=500;if _G.CHOt then local os2=Instance.new("UIStroke",f);os2.Color=Color3.new(0,0,0);os2.Thickness=1;os2.Transparency=al+0.3 end;return f end
    local st=_G.CHS
    if st=="Cross" then mkL(s,th,-(g+s/2),0);mkL(s,th,(g+s/2),0);mkL(th,s,0,-(g+s/2));mkL(th,s,0,(g+s/2))
    elseif st=="T-Shape" then mkL(s,th,-(g+s/2),0);mkL(s,th,(g+s/2),0);mkL(th,s,0,(g+s/2))
    elseif st=="X-Shape" then local f1=mkL(s,th,0,0);f1.Rotation=45;local f2=mkL(s,th,0,0);f2.Rotation=-45
    elseif st=="Dot" then corner(100,mkL(th*3,th*3,0,0))
    elseif st=="Circle" then local c2=Instance.new("Frame",chGui);c2.Size=UDim2.new(0,s*2,0,s*2);c2.Position=UDim2.new(0.5,-s,0.5,-s);c2.BackgroundTransparency=1;c2.BorderSizePixel=0;c2.ZIndex=500;corner(999,c2);local sk=Instance.new("UIStroke",c2);sk.Color=col;sk.Thickness=th;sk.Transparency=al
    elseif st=="Square" then mkL(s*2,th,0,-s);mkL(s*2,th,0,s);mkL(th,s*2,-s,0);mkL(th,s*2,s,0) end
    if _G.CHDt and st~="Dot" then corner(100,mkL(th+1,th+1,0,0)) end
end

-- FOV
local FOVC,FOVGui
local function mkFOV()
    if FOVGui then FOVGui:Destroy() end;FOVGui=mkGui("SusanoFOV",200)
    FOVC=Instance.new("Frame",FOVGui);local r=_G.FS
    FOVC.Size=UDim2.new(0,r*2,0,r*2);FOVC.Position=UDim2.new(0.5,-r,0.5,-r);FOVC.BackgroundTransparency=1;FOVC.BorderSizePixel=0;FOVC.ZIndex=999;corner(999,FOVC)
    local fs=Instance.new("UIStroke",FOVC);fs.Color=Color3.new(1,1,1);fs.Thickness=1;fs.Transparency=0.45;fs.Name="FS";FOVC.Visible=_G.FV
end
local function setFC(col) if FOVC then local s=FOVC:FindFirstChild("FS");if s then s.Color=col end end end

-- TP Cursor - GELİŞMİŞ (görsel göster + y offset fix)
local tpIndicatorGui
local function setupTPIndicator()
    if tpIndicatorGui then tpIndicatorGui:Destroy() end
    tpIndicatorGui=mkGui("SusanoTPInd",198)
    local ind=Instance.new("Frame",tpIndicatorGui);ind.Size=UDim2.new(0,24,0,24);ind.BackgroundColor3=Color3.fromRGB(100,220,255);ind.BackgroundTransparency=0.3;ind.BorderSizePixel=0;ind.AnchorPoint=Vector2.new(0.5,0.5);ind.Visible=false;corner(12,ind);ind.Name="TPInd"
    local inner=Instance.new("Frame",ind);inner.Size=UDim2.new(0,8,0,8);inner.BackgroundColor3=Color3.new(1,1,1);inner.AnchorPoint=Vector2.new(0.5,0.5);inner.Position=UDim2.new(0.5,0,0.5,0);inner.BorderSizePixel=0;corner(4,inner)
    local lbl=Instance.new("TextLabel",tpIndicatorGui);lbl.Size=UDim2.new(0,80,0,20);lbl.BackgroundColor3=Color3.fromRGB(0,0,0);lbl.BackgroundTransparency=0.4;lbl.TextColor3=Color3.new(1,1,1);lbl.Font=Enum.Font.GothamBold;lbl.TextSize=11;lbl.Text="TP";lbl.AnchorPoint=Vector2.new(0.5,0);lbl.Visible=false;lbl.BorderSizePixel=0;corner(4,lbl);lbl.Name="TPLbl"
    return ind,lbl
end
local tpInd,tpLbl=setupTPIndicator()

local tpCursorConn,tpMoveConn
local tpTargetPos=nil
local function enableTPC()
    if tpCursorConn then tpCursorConn:Disconnect() end
    if tpMoveConn then tpMoveConn:Disconnect() end
    -- Mouse hareket ederken hedef noktayı göster
    tpMoveConn=RS.RenderStepped:Connect(function()
        if not _G.CT then
            if tpInd then tpInd.Visible=false end
            if tpLbl then tpLbl.Visible=false end
            return
        end
        local mp=UIS:GetMouseLocation()
        local ur=CAM:ScreenPointToRay(mp.X,mp.Y)
        local params=RaycastParams.new();params.FilterDescendantsInstances={LP.Character};params.FilterType=Enum.RaycastFilterType.Exclude
        local result=WS:Raycast(ur.Origin,ur.Direction*500,params)
        if result then
            tpTargetPos=result.Position
            if tpInd then
                tpInd.Position=UDim2.new(0,mp.X,0,mp.Y)
                tpInd.Visible=true
            end
            if tpLbl then
                tpLbl.Position=UDim2.new(0,mp.X-40,0,mp.Y+16)
                tpLbl.Text=math.floor((result.Position-CAM.CFrame.Position).Magnitude).."m"
                tpLbl.Visible=true
            end
        else
            tpTargetPos=nil
            if tpInd then tpInd.Visible=false end
            if tpLbl then tpLbl.Visible=false end
        end
    end)
    tpCursorConn=UIS.InputBegan:Connect(function(input,gpe)
        if gpe or not _G.CT then return end
        if input.UserInputType==Enum.UserInputType.MouseButton2 then
            if tpTargetPos then
                local char=LP.Character;if not char then return end
                local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
                local hum=char:FindFirstChildOfClass("Humanoid")
                -- Karakterin yüksekliğine göre offset hesapla (üst/alt TP fix)
                local charHeight=5 -- default
                if hum then
                    local desc=hum:GetAppliedDescription and hum:GetAppliedDescription()
                    if desc then charHeight=math.max(desc.HeadScale*1.5+desc.BodyTypeScale*3,3) end
                end
                local targetCF=CFrame.new(tpTargetPos+Vector3.new(0,charHeight/2+1,0))
                hrp.CFrame=targetCF
                -- Animasyon efekti
                if tpInd then
                    tpInd.BackgroundColor3=Color3.fromRGB(100,255,100)
                    task.delay(0.3,function() if tpInd then tpInd.BackgroundColor3=Color3.fromRGB(100,220,255) end end)
                end
            end
        end
    end)
end

-- Skeleton
local skD={}
local BR15={{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"}}
local BR6={{"Head","Torso"},{"Torso","HumanoidRootPart"},{"Torso","Right Arm"},{"Torso","Left Arm"},{"Torso","Right Leg"},{"Torso","Left Leg"}}
local function clrSk(p) if skD[p] then for _,l in ipairs(skD[p]) do pcall(function() l:Remove() end) end;skD[p]=nil end end
local function updSk()
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl==LP or not pl.Character then clrSk(pl);continue end
        if not _G.ESk or not _G.ESP then clrSk(pl);continue end
        local fr=pl.Team and LP.Team and pl.Team==LP.Team
        local show=(fr and _G.EFF) or (not fr and _G.ETC)
        local hum=pl.Character:FindFirstChildOfClass("Humanoid")
        if not(show and hum and hum.Health>0) then clrSk(pl);continue end
        local char=pl.Character;local bL=char:FindFirstChild("UpperTorso") and BR15 or BR6
        if not skD[pl] then skD[pl]={};for _=1,#bL do local l=Drawing.new("Line");l.Visible=false;l.Thickness=1.5;l.Transparency=0.15;l.Color=Color3.new(1,1,1);table.insert(skD[pl],l) end end
        local col=fr and Color3.fromRGB(_G.EFR,_G.EFG,_G.EFB) or Color3.fromRGB(_G.EER,_G.EEG,_G.EEB)
        for i,bone in ipairs(bL) do local line=skD[pl][i];if not line then continue end;local p1=char:FindFirstChild(bone[1]);local p2=char:FindFirstChild(bone[2]);if p1 and p2 then local sp1,o1=CAM:WorldToViewportPoint(p1.Position);local sp2,o2=CAM:WorldToViewportPoint(p2.Position);if o1 and o2 then line.Visible=true;line.From=Vector2.new(sp1.X,sp1.Y);line.To=Vector2.new(sp2.X,sp2.Y);line.Color=col else line.Visible=false end else line.Visible=false end end
    end
end

local function isVis(pl)
    if not pl.Character then return false end
    local head=pl.Character:FindFirstChild("Head");if not head then return false end
    local origin=CAM.CFrame.Position;local dir=head.Position-origin
    local params=RaycastParams.new();params.FilterDescendantsInstances={LP.Character,pl.Character};params.FilterType=Enum.RaycastFilterType.Exclude
    return WS:Raycast(origin,dir,params)==nil
end

-- Aimbot
local function gTP(p) if not p.Character then return nil end;if _G.APH then local h=p.Character:FindFirstChild("Head");if h then return h end end;if _G.APC then local c=p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso");if c then return c end end;return p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart") end
local function gBest()
    local best,bD=nil,math.huge;local center=Vector2.new(CAM.ViewportSize.X/2,CAM.ViewportSize.Y/2)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            local fr=p.Team and LP.Team and p.Team==LP.Team
            if fr and not _G.EFF then continue end
            if not fr and not _G.ETC then continue end
            local hum=p.Character:FindFirstChildOfClass("Humanoid");if not hum or hum.Health<=0 then continue end
            local part=gTP(p);if not part then continue end
            local sp,onS=CAM:WorldToViewportPoint(part.Position);if not onS then continue end
            local dist=(Vector2.new(sp.X,sp.Y)-center).Magnitude;if _G.UF and dist>_G.FS then continue end
            if dist<bD then bD=dist;best={part=part,player=p} end
        end
    end;return best
end

-- Silent Aim - DÜZELTME: kamera değil, mermi yönlendirme
local saActive=false;local saC1,saC2
local function getSAOffset(targetPart)
    if not targetPart then return Vector3.new(0,0,0) end
    local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return Vector3.new(0,0,0) end
    return targetPart.Position-hrp.Position
end

eSA=function()
    saActive=true
    if saC1 then saC1:Disconnect() end
    if saC2 then saC2:Disconnect() end
    -- Silent aim: mouse position'ı hedefin üzerine zorla (kamera hareket ettirmeden)
    saC1=RS.RenderStepped:Connect(function()
        if not _G.SA or not saActive then return end
        local t=gBest();if not t then return end
        local sp,onS=CAM:WorldToViewportPoint(t.part.Position)
        if onS then
            -- Mouse'u hedefin screen position'ına taşı (görünmez)
            pcall(function()
                if mousemoverel then
                    local mp=UIS:GetMouseLocation()
                    local dx=sp.X-mp.X;local dy=sp.Y-mp.Y
                    mousemoverel(dx*0.1,dy*0.1)
                end
            end)
        end
    end)
end
dSA=function() saActive=false;if saC1 then saC1:Disconnect();saC1=nil end;if saC2 then saC2:Disconnect();saC2=nil end end

-- Rage Aimbot
local raActive,raConn=false,nil
dRA=function() raActive=false;if raConn then raConn:Disconnect();raConn=nil end end
eRA=function()
    if raActive then return end;raActive=true
    raConn=RS.RenderStepped:Connect(function()
        if not _G.RA then dRA();return end
        local best,bD=nil,math.huge
        for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Character then local fr=p.Team and LP.Team and p.Team==LP.Team;if fr and not _G.EFF then continue end;if not fr and not _G.ETC then continue end;local hum=p.Character:FindFirstChildOfClass("Humanoid");if not hum or hum.Health<=0 then continue end;for _,pn in ipairs({"Head","UpperTorso","Torso","HumanoidRootPart"}) do local part=p.Character:FindFirstChild(pn);if part then local d=(part.Position-CAM.CFrame.Position).Magnitude;if d<bD then bD=d;best=part end end end end end
        if best then CAM.CFrame=CFrame.new(CAM.CFrame.Position,best.Position);setFC(Color3.fromRGB(255,80,80)) else setFC(Color3.new(1,1,1)) end
    end)
end

-- Trigger Bot - fare butonuna basmadan ateş et
local tbConn
local function eTB()
    if tbConn then tbConn:Disconnect() end
    tbConn=RS.Heartbeat:Connect(function()
        if not _G.TB then return end
        local t=gBest();if not t then return end
        local char=LP.Character;if not char then return end
        -- Mouse üzerinde hedef var mı kontrol et
        local mp=UIS:GetMouseLocation()
        local sp,onS=CAM:WorldToViewportPoint(t.part.Position)
        if not onS then return end
        local dist2d=(Vector2.new(sp.X,sp.Y)-Vector2.new(mp.X,mp.Y)).Magnitude
        if dist2d>30 then return end -- 30 pixel içindeyse
        task.wait(_G.TBD)
        -- Fare butonu yerine tool:Activate veya remote kullan
        local tool=char:FindFirstChildOfClass("Tool")
        if tool then
            pcall(function() tool:Activate() end)
            dealDamage(t.player.Character,t.part,t.part.Position)
        end
    end)
end
local function dTB() if tbConn then tbConn:Disconnect();tbConn=nil end end

-- Magic Bullet - hafif versiyon (sadece en yakın remote)
local mbConn
local function eMB()
    if mbConn then mbConn:Disconnect() end
    mbConn=RS.Heartbeat:Connect(function()
        if not _G.MB then return end
        local t=gBest();if not t then return end
        task.wait(0.1) -- Throttle - lag azaltır
        dealDamage(t.player.Character,t.part,t.part.Position)
    end)
end
local function dMB() if mbConn then mbConn:Disconnect();mbConn=nil end end

-- Hitbox
local hbConn
eHB=function() if hbConn then hbConn:Disconnect() end;hbConn=RS.Heartbeat:Connect(function() if not _G.HB then return end;for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Character then local hrp=p.Character:FindFirstChild("HumanoidRootPart");if hrp then pcall(function() hrp.Size=Vector3.new(_G.HBSz,_G.HBSz,_G.HBSz);hrp.Transparency=0.8 end) end end end end) end
dHB=function() if hbConn then hbConn:Disconnect();hbConn=nil end;for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Character then local hrp=p.Character:FindFirstChild("HumanoidRootPart");if hrp then pcall(function() hrp.Size=Vector3.new(2,2,1);hrp.Transparency=1 end) end end end end

-- Fake Lag
local flConn
local function eFL() if flConn then flConn:Disconnect() end;flConn=RS.Heartbeat:Connect(function() if not _G.FL then return end;task.wait(_G.FLI) end) end
local function dFL() if flConn then flConn:Disconnect();flConn=nil end end

-- Godmode - gelişmiş
local gdConn,gdLoop
eGD=function()
    if gdConn then gdConn:Disconnect() end
    if gdLoop then gdLoop:Disconnect() end
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end
    hum.BreakJointsOnDeath=false
    -- MaxHealth'i de yüksek tut
    pcall(function() hum.MaxHealth=math.huge end)
    gdConn=hum.HealthChanged:Connect(function(hp)
        if not _G.GD then return end
        if hp<hum.MaxHealth then
            pcall(function() hum.Health=hum.MaxHealth end)
        end
    end)
    gdLoop=RS.Heartbeat:Connect(function()
        if not _G.GD then return end
        if hum and hum.Health<hum.MaxHealth then
            pcall(function() hum.Health=hum.MaxHealth end)
        end
    end)
end
dGD=function()
    if gdConn then gdConn:Disconnect();gdConn=nil end
    if gdLoop then gdLoop:Disconnect();gdLoop=nil end
    local char=LP.Character;if char then local hum=char:FindFirstChildOfClass("Humanoid");if hum then pcall(function() hum.MaxHealth=100;hum.Health=100 end) end end
end

-- Movement
local ijC;eIJ=function() if ijC then ijC:Disconnect() end;ijC=UIS.JumpRequest:Connect(function() if not _G.IJ then return end;local c=LP.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end) end;dIJ=function() if ijC then ijC:Disconnect();ijC=nil end end
local ljC;eLJ=function() if ljC then ljC:Disconnect() end;ljC=UIS.JumpRequest:Connect(function() if not _G.LJ then return end;local c=LP.Character;if not c then return end;local hrp=c:FindFirstChild("HumanoidRootPart");local hum=c:FindFirstChildOfClass("Humanoid");if hrp and hum and hum.FloorMaterial~=Enum.Material.Air then local bv=Instance.new("BodyVelocity");bv.Velocity=hrp.CFrame.LookVector*_G.LJP+Vector3.new(0,30,0);bv.MaxForce=Vector3.new(1e5,1e5,1e5);bv.P=1e4;bv.Parent=hrp;game:GetService("Debris"):AddItem(bv,0.15) end end) end;dLJ=function() if ljC then ljC:Disconnect();ljC=nil end end
local swC;eSW=function() if swC then swC:Disconnect() end;swC=RS.Stepped:Connect(function() if not _G.SH then return end;local c=LP.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid");if hum and hum:GetState()==Enum.HumanoidStateType.Swimming then hum.WalkSpeed=16*_G.SPM end end) end
local bhC,bhA=nil,false;eBH=function() if bhA then return end;local c=LP.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid");if not hum then return end;bhA=true;bhC=RS.RenderStepped:Connect(function() if not _G.BH or not c or not hum then bhA=false;if bhC then bhC:Disconnect() end;return end;if hum.FloorMaterial~=Enum.Material.Air then hum.JumpPower=_G.BHH;hum.Jump=true end;hum.WalkSpeed=hum.MoveDirection.Magnitude>0 and 16*_G.BHS or 16 end) end;dBH=function() bhA=false;if bhC then bhC:Disconnect();bhC=nil end;local c=LP.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h.WalkSpeed=16;h.JumpPower=50 end end end
local spC,spA=nil,false;local oSpd=16;eSP=function() if spA then return end;local c=LP.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid");if not hum then return end;spA=true;oSpd=hum.WalkSpeed;spC=RS.RenderStepped:Connect(function() if not _G.SP or not c or not hum then spA=false;if spC then spC:Disconnect() end;return end;hum.WalkSpeed=oSpd*_G.SPM end) end;dSP=function() spA=false;if spC then spC:Disconnect();spC=nil end;local c=LP.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h.WalkSpeed=oSpd end end end
local flyC,flying=nil,false;local bVl,bGy;eFly=function() if flying then return end;local c=LP.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid");local hrp=c:FindFirstChild("HumanoidRootPart");if not hum or not hrp then return end;flying=true;bVl=Instance.new("BodyVelocity");bVl.MaxForce=Vector3.new(1e5,1e5,1e5);bVl.P=1e4;bVl.Parent=hrp;bGy=Instance.new("BodyGyro");bGy.MaxTorque=Vector3.new(1e5,1e5,1e5);bGy.P=1e4;bGy.D=100;bGy.Parent=hrp;flyC=RS.RenderStepped:Connect(function() if not flying or not hrp then dFly();return end;bGy.CFrame=CAM.CFrame;local v=Vector3.zero;local ui=UIS;if ui:IsKeyDown(Enum.KeyCode.W) then v=v+CAM.CFrame.LookVector*_G.FLS end;if ui:IsKeyDown(Enum.KeyCode.S) then v=v-CAM.CFrame.LookVector*_G.FLS end;if ui:IsKeyDown(Enum.KeyCode.D) then v=v+CAM.CFrame.RightVector*_G.FLS end;if ui:IsKeyDown(Enum.KeyCode.A) then v=v-CAM.CFrame.RightVector*_G.FLS end;if ui:IsKeyDown(Enum.KeyCode.Space) then v=v+Vector3.new(0,_G.FLS,0) end;if ui:IsKeyDown(Enum.KeyCode.LeftShift) or ui:IsKeyDown(Enum.KeyCode.Q) then v=v-Vector3.new(0,_G.FLS,0) end;bVl.Velocity=v;if hum:GetState()~=Enum.HumanoidStateType.Freefall then hum:ChangeState(Enum.HumanoidStateType.Freefall) end end) end;dFly=function() flying=false;if flyC then flyC:Disconnect();flyC=nil end;if bVl then bVl:Destroy();bVl=nil end;if bGy then bGy:Destroy();bGy=nil end;local c=LP.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h:ChangeState(Enum.HumanoidStateType.Landed) end end end
local ncC,ncA=nil,false;eNC=function() if ncA then return end;ncA=true;ncC=RS.Stepped:Connect(function() if not ncA or not LP.Character then ncA=false;if ncC then ncC:Disconnect() end;return end;for _,p in pairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end end end) end;dNC=function() ncA=false;if ncC then ncC:Disconnect();ncC=nil end;local c=LP.Character;if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end end
local kaC;eKA=function() if kaC then kaC:Disconnect() end;kaC=RS.Heartbeat:Connect(function() if not _G.KA then return end;local c=LP.Character;if not c then return end;local hrp=c:FindFirstChild("HumanoidRootPart");if not hrp then return end;local tool=c:FindFirstChildOfClass("Tool");for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Character then local fr=p.Team and LP.Team and p.Team==LP.Team;if fr then continue end;local phum=p.Character:FindFirstChildOfClass("Humanoid");local phrp=p.Character:FindFirstChild("HumanoidRootPart");if not phum or not phrp or phum.Health<=0 then continue end;if(phrp.Position-hrp.Position).Magnitude<=_G.KAR then if tool then for _,child in ipairs(tool:GetDescendants()) do if child:IsA("RemoteEvent") then pcall(function() child:FireServer(p.Character) end) end end;pcall(function() tool:Activate() end) end;dealDamage(p.Character,phrp,phrp.Position) end end end end) end;dKA=function() if kaC then kaC:Disconnect();kaC=nil end end
local afkC;eAFK=function() if afkC then afkC:Disconnect() end;afkC=RS.Heartbeat:Connect(function() if not _G.AAFK then return end;pcall(function() local vu=game:GetService("VirtualUser");vu:CaptureController();vu:ClickButton2(Vector2.new()) end) end) end;dAFK=function() if afkC then afkC:Disconnect();afkC=nil end end

local nsC
apNS=function()
    local name=_G.SN~="" and _G.SN or LP.Name
    local function spoof(char) if not char then return end;local head=char:FindFirstChild("Head");if not head then return end;for _,gui in ipairs(head:GetChildren()) do if gui:IsA("BillboardGui") and gui.Name~="SNS" then gui.Enabled=not _G.NS end end;local ex=head:FindFirstChild("SNS");if _G.NS then if not ex then local bb=Instance.new("BillboardGui",head);bb.Name="SNS";bb.AlwaysOnTop=false;bb.Size=UDim2.new(0,250,0,36);bb.StudsOffset=Vector3.new(0,2.2,0);local lbl=Instance.new("TextLabel",bb);lbl.Size=UDim2.new(1,0,1,0);lbl.BackgroundTransparency=1;lbl.TextColor3=Color3.new(1,1,1);lbl.Font=Enum.Font.GothamBold;lbl.TextSize=17;lbl.TextStrokeTransparency=0.5;lbl.Name="NSL" end;local lbl=head.SNS:FindFirstChild("NSL");if lbl then lbl.Text=name end;pcall(function() LP.DisplayName=name end) else if ex then ex:Destroy() end;for _,gui in ipairs(head:GetChildren()) do if gui:IsA("BillboardGui") then gui.Enabled=true end end;pcall(function() LP.DisplayName=LP.Name end) end end
    spoof(LP.Character);if nsC then nsC:Disconnect() end;if _G.NS then nsC=LP.CharacterAdded:Connect(function(char) task.wait(0.5);spoof(char) end) end
end

local oAmb=LT.Ambient;local oBrg=LT.Brightness;local oFE=LT.FogEnd;local oFS=LT.FogStart;local oCFOV=CAM.FieldOfView;local oTOD=LT.TimeOfDay;local oCS=LT.ColorShift_Top
apFB=function(v) if v then LT.Ambient=Color3.new(1,1,1);LT.Brightness=2;for _,e in ipairs(LT:GetChildren()) do if e:IsA("BlurEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("SunRaysEffect") or e:IsA("BloomEffect") then e.Enabled=false end end else LT.Ambient=oAmb;LT.Brightness=oBrg end end
apNF=function(v) if v then LT.FogEnd=1e6;LT.FogStart=1e6 else LT.FogEnd=oFE;LT.FogStart=oFS end end
apTm=function(v) if v then LT.TimeOfDay=string.format("%02d:00:00",math.floor(_G.TOD)) else LT.TimeOfDay=oTOD end end
apWC=function(v) if v then LT.ColorShift_Top=Color3.fromRGB(_G.WCR,_G.WCG,_G.WCB) else LT.ColorShift_Top=oCS end end
local tpC;eTP3=function() CAM.CameraType=Enum.CameraType.Scriptable;if tpC then tpC:Disconnect() end;tpC=RS.RenderStepped:Connect(function() if not _G.TP3 then dTP3();return end;local c=LP.Character;if not c then return end;local hrp=c:FindFirstChild("HumanoidRootPart");if not hrp then return end;local d=_G.TP3D;CAM.CFrame=CFrame.new(hrp.CFrame.Position-hrp.CFrame.LookVector*d+Vector3.new(0,d*0.4,0),hrp.Position) end) end;dTP3=function() if tpC then tpC:Disconnect();tpC=nil end;CAM.CameraType=Enum.CameraType.Custom end

local function setupARej() game:GetService("Players").PlayerRemoving:Connect(function(p) if p==LP and _G.ARJ then task.wait(3);pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId,LP) end) end end) end
local function serverHop() task.spawn(function() local ok,r=pcall(function() return HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")) end);if ok and r and r.data then for _,s in ipairs(r.data) do if s.id~=game.JobId and s.playing<s.maxPlayers then pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,s.id,LP) end);return end end end end) end
local fpsA=false;local hidP={}
local function eFPS() if fpsA then return end;fpsA=true;for _,obj in ipairs(WS:GetDescendants()) do if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then pcall(function() obj.Enabled=false;table.insert(hidP,obj) end) end end;LT.GlobalShadows=false end
local function dFPS() fpsA=false;for _,obj in ipairs(hidP) do pcall(function() obj.Enabled=true end) end;hidP={};LT.GlobalShadows=true end

-- Chat logger - TÜM oyuncuları yakala
local clC,clGui,clSc
local function eCL()
    if clGui then return end
    clGui=mkGui("SusanoCL",100)
    local frame=Instance.new("Frame",clGui);frame.Size=UDim2.new(0,300,0,180);frame.Position=UDim2.new(0,10,1,-200);frame.BackgroundColor3=Color3.fromRGB(10,10,10);frame.BackgroundTransparency=0.2;frame.BorderSizePixel=0;corner(8,frame)
    local title=Instance.new("TextLabel",frame);title.Size=UDim2.new(1,0,0,22);title.BackgroundColor3=Color3.fromRGB(15,15,15);title.BackgroundTransparency=0;title.Text="💬 Chat Log - Susano";title.TextColor3=Color3.new(1,1,1);title.Font=Enum.Font.GothamBold;title.TextSize=12;corner(8,title)
    clSc=Instance.new("ScrollingFrame",frame);clSc.Size=UDim2.new(1,-6,1,-26);clSc.Position=UDim2.new(0,3,0,24);clSc.BackgroundTransparency=1;clSc.ScrollBarThickness=2;clSc.CanvasSize=UDim2.new(0,0,0,0);clSc.AutomaticCanvasSize=Enum.AutomaticSize.Y;clSc.BorderSizePixel=0
    Instance.new("UIListLayout",clSc).Padding=UDim.new(0,2)
    -- Mevcut logları göster
    for _,log in ipairs(chatL) do local l=Instance.new("TextLabel",clSc);l.Size=UDim2.new(1,-4,0,16);l.BackgroundTransparency=1;l.Text=log:sub(1,45);l.TextColor3=Color3.fromRGB(200,200,200);l.Font=Enum.Font.Gotham;l.TextSize=11;l.TextXAlignment=Enum.TextXAlignment.Left end
    local function addLog(pName,msg)
        local txt=os.date("%H:%M").." ["..pName.."] "..msg
        table.insert(chatL,txt)
        if clSc then local l=Instance.new("TextLabel",clSc);l.Size=UDim2.new(1,-4,0,16);l.BackgroundTransparency=1;l.Text=txt:sub(1,45);l.TextColor3=Color3.fromRGB(200,200,200);l.Font=Enum.Font.Gotham;l.TextSize=11;l.TextXAlignment=Enum.TextXAlignment.Left end
    end
    -- TÜÜM oyuncuları bağla
    local function bindPlayer(p)
        if p==LP then return end
        p.Chatted:Connect(function(msg) if _G.CL then addLog(p.Name,msg) end end)
    end
    for _,p in ipairs(Players:GetPlayers()) do bindPlayer(p) end
    clC=Players.PlayerAdded:Connect(function(p) bindPlayer(p) end)
end
local function dCL() if clC then clC:Disconnect();clC=nil end;if clGui then clGui:Destroy();clGui=nil;clSc=nil end end

local mmGui,mmC,mmD
local function eMM()
    if mmGui then return end;mmGui=mkGui("SusanoMM",150);mmD={}
    local sz=180;local frame=Instance.new("Frame",mmGui);frame.Size=UDim2.new(0,sz,0,sz);frame.Position=UDim2.new(1,-sz-10,0,10);frame.BackgroundColor3=Color3.fromRGB(10,10,10);frame.BackgroundTransparency=0.15;frame.BorderSizePixel=0;corner(90,frame)
    Instance.new("UIStroke",frame).Color=Tc.AC
    local rtl=Instance.new("TextLabel",frame);rtl.Size=UDim2.new(1,0,0,14);rtl.BackgroundTransparency=1;rtl.Text="RADAR";rtl.TextColor3=Tc.AC;rtl.Font=Enum.Font.GothamBold;rtl.TextSize=9
    local cDot=Instance.new("Frame",frame);cDot.Size=UDim2.new(0,8,0,8);cDot.AnchorPoint=Vector2.new(0.5,0.5);cDot.Position=UDim2.new(0.5,0,0.5,0);cDot.BackgroundColor3=Color3.new(1,1,1);cDot.BorderSizePixel=0;corner(4,cDot)
    if mmC then mmC:Disconnect() end
    mmC=RS.RenderStepped:Connect(function()
        if not _G.MM then return end
        local myHRP=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart");if not myHRP then return end
        local aP={};for _,p in ipairs(Players:GetPlayers()) do aP[p]=true end
        for p,dot in pairs(mmD) do if not aP[p] then dot:Destroy();mmD[p]=nil end end
        for _,p in ipairs(Players:GetPlayers()) do
            if p==LP or not p.Character then continue end
            local hrp=p.Character:FindFirstChild("HumanoidRootPart");if not hrp then continue end
            local diff=hrp.Position-myHRP.Position;local range=200
            local nx=math.clamp(diff.X/range,-0.5,0.5);local nz=math.clamp(diff.Z/range,-0.5,0.5)
            if not mmD[p] then
                local dot=Instance.new("Frame",frame);dot.Size=UDim2.new(0,6,0,6);dot.AnchorPoint=Vector2.new(0.5,0.5);dot.BorderSizePixel=0;corner(3,dot)
                local nl=Instance.new("TextLabel",dot);nl.Size=UDim2.new(0,60,0,12);nl.Position=UDim2.new(1,2,0,-2);nl.BackgroundTransparency=1;nl.Text=p.Name:sub(1,7);nl.TextColor3=Color3.new(1,1,1);nl.Font=Enum.Font.GothamBold;nl.TextSize=8;nl.TextXAlignment=Enum.TextXAlignment.Left
                mmD[p]=dot
            end
            local fr=p.Team and LP.Team and p.Team==LP.Team
            mmD[p].BackgroundColor3=fr and Color3.fromRGB(80,180,255) or Color3.fromRGB(255,80,80)
            mmD[p].Position=UDim2.new(0.5+nx,0,0.5+nz,0)
        end
    end)
end
local function dMM() if mmC then mmC:Disconnect();mmC=nil end;if mmGui then mmGui:Destroy();mmGui=nil;mmD=nil end end

-- ESP
local eC,e2,eTr={},{},{}
local function clED(p) if e2[p] then for _,v in pairs(e2[p]) do pcall(function() v.Visible=false;v:Remove() end) end;e2[p]=nil end;if eTr[p] then pcall(function() eTr[p].Visible=false;eTr[p]:Remove() end);eTr[p]=nil end end
local function clEP(p) if eC[p] then if eC[p].hl then pcall(function() eC[p].hl:Destroy() end) end;if eC[p].bb then pcall(function() eC[p].bb:Destroy() end) end;if eC[p].hb then pcall(function() eC[p].hb:Destroy() end) end;eC[p]=nil end;clED(p);clrSk(p) end
local function clAE() for p in pairs(eC) do clEP(p) end;for p in pairs(e2) do clED(p) end end

local function bldE(pl)
    if not _G.ESP or pl==LP or eC[pl] then return end
    local char=pl.Character;if not char then return end
    local hrp=char:WaitForChild("HumanoidRootPart",5);if not hrp then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    local hl=Instance.new("Highlight");hl.Adornee=char;hl.FillTransparency=0.75;hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;hl.Enabled=false;hl.Parent=CG
    local bb=Instance.new("BillboardGui");bb.Size=UDim2.new(6,0,3,0);bb.AlwaysOnTop=true;bb.StudsOffset=Vector3.new(0,4,0);bb.Adornee=hrp;bb.Enabled=false;bb.Parent=CG
    local function lbl(pos,sz,col,fs) local l=Instance.new("TextLabel",bb);l.Size=UDim2.new(1,0,sz,0);l.Position=UDim2.new(0,0,pos,0);l.BackgroundTransparency=1;l.TextColor3=col;l.Font=Enum.Font.GothamBold;l.TextSize=fs;l.TextStrokeTransparency=0.4;return l end
    local idL=lbl(0,0.3,Color3.fromRGB(160,160,255),12)
    local nmL=lbl(0.3,0.4,Color3.fromRGB(_G.ENR,_G.ENG,_G.ENB),16)
    local dsL=lbl(0.7,0.3,Color3.fromRGB(255,220,80),12)
    local hbBB=Instance.new("BillboardGui");hbBB.Size=UDim2.new(0.4,0,2,0);hbBB.AlwaysOnTop=true;hbBB.StudsOffset=Vector3.new(-1.8,2,0);hbBB.Adornee=hrp;hbBB.Enabled=false;hbBB.Parent=CG
    local hbBG=Instance.new("Frame",hbBB);hbBG.Size=UDim2.new(0,4,1,0);hbBG.BackgroundColor3=Color3.fromRGB(20,20,20);hbBG.BorderSizePixel=0
    local hbF=Instance.new("Frame",hbBG);hbF.Size=UDim2.new(1,0,1,0);hbF.BackgroundColor3=Color3.fromRGB(80,255,120);hbF.BorderSizePixel=0
    eC[pl]={hl=hl,bb=bb,hb=hbBB,hbG=hbBG,hbF=hbF,idL=idL,nmL=nmL,dsL=dsL,hrp=hrp,hum=hum}
    local e={};e.box=Drawing.new("Square");e.box.Visible=false;e.box.Thickness=1.5;e.box.Filled=false;e.nm=Drawing.new("Text");e.nm.Visible=false;e.nm.Size=14;e.nm.Font=2;e.nm.Center=true;e.ds=Drawing.new("Text");e.ds.Visible=false;e.ds.Size=12;e.ds.Font=2;e.ds.Center=true;e.ds.Color=Color3.fromRGB(255,220,80);e.id=Drawing.new("Text");e.id.Visible=false;e.id.Size=11;e.id.Font=2;e.id.Center=true;e.id.Color=Color3.fromRGB(160,160,255);e.hbg=Drawing.new("Square");e.hbg.Visible=false;e.hbg.Filled=true;e.hbg.Color=Color3.fromRGB(20,20,20);e.hbf=Drawing.new("Square");e.hbf.Visible=false;e.hbf.Filled=true;e2[pl]=e
    local tr=Drawing.new("Line");tr.Visible=false;tr.Thickness=_G.ETt;tr.Transparency=0.3;eTr[pl]=tr
end

local function updE()
    if not _G.ESP then clAE();return end
    local myHRP=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart");if not myHRP then return end
    local cE=Color3.fromRGB(_G.EER,_G.EEG,_G.EEB);local cF=Color3.fromRGB(_G.EFR,_G.EFG,_G.EFB);local cV=Color3.fromRGB(_G.EVR,_G.EVG,_G.EVB);local cN=Color3.fromRGB(_G.ENR,_G.ENG,_G.ENB)
    local aP={};for _,p in ipairs(Players:GetPlayers()) do aP[p]=true end
    for p in pairs(eC) do if not aP[p] then clEP(p) end end
    for pl,cache in pairs(eC) do
        if not(pl and pl.Parent and cache.hrp and cache.hrp.Parent) then clEP(pl);continue end
        local char=pl.Character;local hum=char and char:FindFirstChildOfClass("Humanoid");local hrp=cache.hrp
        local dist=(hrp.Position-myHRP.Position).Magnitude
        local fr=pl.Team and LP.Team and pl.Team==LP.Team
        local show=(fr and _G.EFF) or (not fr and _G.ETC);if not(show and hum and hum.Health>0) then show=false end
        local vis=false;if _G.EWC and show and not fr then vis=isVis(pl) end
        local col=fr and cF or(_G.EWC and (vis and cV or cE) or cE)
        if cache.hl then cache.hl.Enabled=_G.E3D and show;if cache.hl.Enabled then cache.hl.FillColor=col;cache.hl.OutlineColor=col;cache.hl.DepthMode=(_G.EWC and vis) and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop end end
        if cache.bb then cache.bb.Enabled=show;if show then cache.idL.Visible=_G.EId;cache.idL.Text="ID:"..pl.UserId;cache.nmL.Visible=_G.ENm;cache.nmL.Text=pl.Name;cache.nmL.TextColor3=cN;cache.dsL.Visible=_G.EDs;cache.dsL.Text=math.floor(dist).."m" end end
        if cache.hb then cache.hb.Enabled=_G.EHp and show;if cache.hb.Enabled and hum and hum.Health>0 then local pct=hum.Health/hum.MaxHealth;cache.hbF.Size=UDim2.new(1,0,pct,0);cache.hbF.Position=UDim2.new(0,0,1-pct,0);cache.hbF.BackgroundColor3=pct>0.6 and Color3.fromRGB(80,255,120) or(pct>0.3 and Color3.fromRGB(255,220,80) or Color3.fromRGB(255,80,80)) end end
        local e=e2[pl]
        if e then
            if _G.E2D and show then
                local sp,onSc=CAM:WorldToViewportPoint(hrp.Position)
                if onSc then
                    local head=char:FindFirstChild("Head")
                    if head then
                        local sh=CAM:WorldToViewportPoint(head.Position);local h=math.abs(sh.Y-sp.Y)*2.3;local w=h*0.55;local tl=Vector2.new(sp.X-w/2,sh.Y-h/2)
                        e.box.Visible=true;e.box.Position=tl;e.box.Size=Vector2.new(w,h);e.box.Color=col
                        if _G.ENm then e.nm.Visible=true;e.nm.Position=Vector2.new(sp.X,sh.Y-h/2-18);e.nm.Text=pl.Name;e.nm.Color=cN else e.nm.Visible=false end
                        if _G.EDs then e.ds.Visible=true;e.ds.Position=Vector2.new(sp.X,sh.Y+h/2+4);e.ds.Text=math.floor(dist).."m" else e.ds.Visible=false end
                        if _G.EId then e.id.Visible=true;e.id.Position=Vector2.new(sp.X,sh.Y-h/2-32);e.id.Text="ID:"..pl.UserId else e.id.Visible=false end
                        if _G.EHp and hum and hum.Health>0 then local pct=hum.Health/hum.MaxHealth;e.hbg.Visible=true;e.hbg.Position=Vector2.new(tl.X-7,tl.Y);e.hbg.Size=Vector2.new(3,h);e.hbf.Visible=true;e.hbf.Position=Vector2.new(tl.X-7,tl.Y+h*(1-pct));e.hbf.Size=Vector2.new(3,h*pct);e.hbf.Color=pct>0.6 and Color3.fromRGB(80,255,120) or(pct>0.3 and Color3.fromRGB(255,220,80) or Color3.fromRGB(255,80,80)) else e.hbg.Visible=false;e.hbf.Visible=false end
                    else for _,v in pairs(e) do pcall(function() v.Visible=false end) end end
                else for _,v in pairs(e) do pcall(function() v.Visible=false end) end end
            else for _,v in pairs(e) do pcall(function() v.Visible=false end) end end
        end
        local tr=eTr[pl];if tr then tr.Thickness=_G.ETt;if _G.ETr and show then local sp,onSc=CAM:WorldToViewportPoint(hrp.Position);if onSc then tr.Visible=true;tr.From=Vector2.new(CAM.ViewportSize.X/2,CAM.ViewportSize.Y);tr.To=Vector2.new(sp.X,sp.Y);tr.Color=col else tr.Visible=false end else tr.Visible=false end end
    end
end

-- Tüm oyuncularda ESP - universal
local function bindESP(p)
    if p==LP then return end
    p.CharacterAdded:Connect(function() if _G.ESP then task.wait(1);bldE(p) end end)
    p.CharacterRemoving:Connect(function() clEP(p) end)
    if p.Character and _G.ESP then task.wait(0.5);bldE(p) end
end
Players.PlayerAdded:Connect(function(p) bindESP(p) end)
Players.PlayerRemoving:Connect(function(p) clEP(p) end)
for _,p in ipairs(Players:GetPlayers()) do bindESP(p) end

-- CONFIG
local function bldCfg()
    return {ESP=_G.ESP,E3D=_G.E3D,E2D=_G.E2D,ENm=_G.ENm,EDs=_G.EDs,EHp=_G.EHp,EId=_G.EId,ETr=_G.ETr,ETt=_G.ETt,ETC=_G.ETC,EFF=_G.EFF,EWC=_G.EWC,ESk=_G.ESk,EER=_G.EER,EEG=_G.EEG,EEB=_G.EEB,EFR=_G.EFR,EFG=_G.EFG,EFB=_G.EFB,EVR=_G.EVR,EVG=_G.EVG,EVB=_G.EVB,ENR=_G.ENR,ENG=_G.ENG,ENB=_G.ENB,CH=_G.CH,CHS=_G.CHS,CHSz=_G.CHSz,CHTh=_G.CHTh,CHGp=_G.CHGp,CHAl=_G.CHAl,CHDt=_G.CHDt,CHOt=_G.CHOt,CHR=_G.CHR,CHG=_G.CHG,CHB=_G.CHB,AB=_G.AB,RA=_G.RA,SA=_G.SA,MB=_G.MB,TB=_G.TB,TBD=_G.TBD,UF=_G.UF,FV=_G.FV,FS=_G.FS,ASm=_G.ASm,APH=_G.APH,APC=_G.APC,APS=_G.APS,HB=_G.HB,HBSz=_G.HBSz,FL=_G.FL,FLI=_G.FLI,GD=_G.GD,FLY=_G.FLY,FLS=_G.FLS,NC=_G.NC,BH=_G.BH,BHS=_G.BHS,BHH=_G.BHH,SP=_G.SP,SPM=_G.SPM,IJ=_G.IJ,LJ=_G.LJ,LJP=_G.LJP,SH=_G.SH,GH=_G.GH,GV=_G.GV,CT=_G.CT,KA=_G.KA,KAR=_G.KAR,AAFK=_G.AAFK,NS=_G.NS,SN=_G.SN,FB=_G.FB,NF=_G.NF,FC=_G.FC,FCV=_G.FCV,TP3=_G.TP3,TP3D=_G.TP3D,TC=_G.TC,TOD=_G.TOD,WC=_G.WC,WCR=_G.WCR,WCG=_G.WCG,WCB=_G.WCB,ARJ=_G.ARJ,FPS=_G.FPS,CL=_G.CL,MM=_G.MM,ACFly=_G.ACFly,ACNc=_G.ACNc,ACSp=_G.ACSp,ACTp=_G.ACTp,ACRe=_G.ACRe,ACAm=_G.ACAm,_THEME=cTheme,_LANG=LANG}
end
local function aplCfg(data)
    for k,v in pairs(data) do
        if k=="_THEME" then cTheme=v;Tc=makeTc()
        elseif k=="_LANG" then LANG=v
        else _G[k]=v end
    end
end
local function lstCfg() local r={};for _,f in ipairs(sList(CF_DIR)) do local n=f:match("([^/\\]+)%.json$");if n then table.insert(r,n) end end;return r end
local function svCfg(n) sMkDir(CF_DIR);local ok,j=pcall(function() return HS:JSONEncode(bldCfg()) end);if not ok then return false end;sWrite(CF_DIR.."/"..n..".json",j);return true end
local function ldCfg(n) local ok,c=sRead(CF_DIR.."/"..n..".json");if not ok or not c then return false end;local ok2,d=pcall(function() return HS:JSONDecode(c) end);if not ok2 then return false end;aplCfg(d);return true end
local function dlCfg(n) sDel(CF_DIR.."/"..n..".json") end

-- TAB BUILDERS
local TB2={}

TB2["ESP"]=function(p)
    local sc=mkScroll(p);local y=10
    y=mkSec(sc,T("sv"),y);y=mkToggle(sc,T("t_esp"),"ESP",y,function(v) if not v then clAE() end end);y=mkToggle(sc,T("t_3d"),"E3D",y);y=mkToggle(sc,T("t_2d"),"E2D",y);y=mkToggle(sc,T("t_sk"),"ESk",y)
    y=mkSec(sc,T("sl"),y+4);y=mkToggle(sc,T("t_nm"),"ENm",y);y=mkToggle(sc,T("t_ds"),"EDs",y);y=mkToggle(sc,T("t_hp"),"EHp",y);y=mkToggle(sc,T("t_id"),"EId",y);y=mkToggle(sc,T("t_tr"),"ETr",y);y=mkSlider(sc,T("ltt"),"ETt",y,0.5,6,"%.1f")
    y=mkSec(sc,T("sf"),y+4);y=mkToggle(sc,T("t_tc"),"ETC",y);y=mkToggle(sc,T("t_fr"),"EFF",y);y=mkToggle(sc,T("t_wc"),"EWC",y)
    y=mkSec(sc,T("snmc"),y+4);y=mkCP(sc,"ENR","ENG","ENB",y);y=mkSlider(sc,T("lr"),"ENR",y,0,255,nil);y=mkSlider(sc,T("lg"),"ENG",y,0,255,nil);y=mkSlider(sc,T("lb"),"ENB",y,0,255,nil)
    y=mkSec(sc,T("senm"),y+4);y=mkCP(sc,"EER","EEG","EEB",y);y=mkSlider(sc,T("lr"),"EER",y,0,255,nil);y=mkSlider(sc,T("lg"),"EEG",y,0,255,nil);y=mkSlider(sc,T("lb"),"EEB",y,0,255,nil)
    y=mkSec(sc,T("sfr"),y+4);y=mkCP(sc,"EFR","EFG","EFB",y);y=mkSlider(sc,T("lr"),"EFR",y,0,255,nil);y=mkSlider(sc,T("lg"),"EFG",y,0,255,nil);y=mkSlider(sc,T("lb"),"EFB",y,0,255,nil)
    y=mkSec(sc,T("svc"),y+4);y=mkCP(sc,"EVR","EVG","EVB",y);y=mkSlider(sc,T("lr"),"EVR",y,0,255,nil);y=mkSlider(sc,T("lg"),"EVG",y,0,255,nil);y=mkSlider(sc,T("lb"),"EVB",y,0,255,nil)
    y=mkSec(sc,T("scrs"),y+4);y=mkToggle(sc,T("t_crs"),"CH",y,function() bCH() end)
    y=mkDrop(sc,"Stil",CHS,function() return _G.CHS end,function(v) _G.CHS=v;bCH() end,y)
    y=mkSlider(sc,T("lsz"),"CHSz",y,4,50,nil,function() bCH() end);y=mkSlider(sc,T("lth"),"CHTh",y,1,8,nil,function() bCH() end);y=mkSlider(sc,T("lgp"),"CHGp",y,0,24,nil,function() bCH() end);y=mkSlider(sc,T("lop"),"CHAl",y,0.1,1.0,"%.1f",function() bCH() end)
    y=mkToggle(sc,T("t_dot"),"CHDt",y,function() bCH() end);y=mkToggle(sc,T("t_out"),"CHOt",y,function() bCH() end)
    y=mkSec(sc,T("scl"),y+4);y=mkCP(sc,"CHR","CHG","CHB",y);y=mkSlider(sc,T("lr"),"CHR",y,0,255,nil,function() bCH() end);y=mkSlider(sc,T("lg"),"CHG",y,0,255,nil,function() bCH() end);y=mkSlider(sc,T("lb"),"CHB",y,0,255,nil,function() bCH() end)
end

TB2["AIMBOT"]=function(p)
    local sc=mkScroll(p);local y=10
    y=mkSec(sc,T("sa"),y);y=mkToggle(sc,T("t_ab"),"AB",y,function(v) whF("Aimbot",v) end);y=mkToggle(sc,T("t_ra"),"RA",y,function(v) if v then eRA() else dRA() end;whF("Rage Aimbot",v) end)
    y=mkSec(sc,T("ss"),y+4);y=mkToggle(sc,T("t_sa"),"SA",y,function(v) if v then eSA() else dSA() end;whF("Silent Aim",v) end)
    y=mkSec(sc,T("stb"),y+4);y=mkToggle(sc,T("t_tb"),"TB",y,function(v) if v then eTB() else dTB() end;whF("Trigger Bot",v) end);y=mkSlider(sc,T("ltbs"),"TBD",y,0.01,0.5,"%.2f")
    y=mkSec(sc,T("smb"),y+4);y=mkToggle(sc,T("t_mb"),"MB",y,function(v) if v then eMB() else dMB() end;whF("Magic Bullet",v) end)
    y=mkSec(sc,T("shb"),y+4);y=mkToggle(sc,T("t_hb"),"HB",y,function(v) if v then eHB() else dHB() end;whF("Hitbox",v) end);y=mkSlider(sc,T("lhbs"),"HBSz",y,1,20,"%.1f")
    y=mkSec(sc,T("sfl"),y+4);y=mkToggle(sc,T("t_fl"),"FL",y,function(v) if v then eFL() else dFL() end;whF("Fake Lag",v) end);y=mkSlider(sc,T("llag"),"FLI",y,0.0,0.5,"%.2f")
    y=mkSec(sc,T("so"),y+4);y=mkToggle(sc,T("t_ff"),"UF",y);y=mkToggle(sc,T("t_fc"),"FV",y,function(v) if FOVC then FOVC.Visible=v end end);y=mkSlider(sc,T("lfov"),"FS",y,20,400,nil)
    y=mkSec(sc,T("smt"),y+4);y=mkSlider(sc,T("lsm"),"ASm",y,0.02,1.0,"%.2f")
    y=mkSec(sc,T("stg"),y+4);y=mkToggle(sc,"Kafa","APH",y);y=mkToggle(sc,"Göğüs","APC",y);y=mkToggle(sc,"Karın","APS",y)
end

TB2["MOVEMENT"]=function(p)
    local sc=mkScroll(p);local y=10
    y=mkSec(sc,T("sfly"),y);y=mkToggle(sc,T("t_fly"),"FLY",y,function(v) if v then eFly() else dFly() end;whF("Fly",v) end);y=mkSlider(sc,T("lfls"),"FLS",y,10,300,nil)
    y=mkSec(sc,T("smv"),y+4);y=mkToggle(sc,T("t_nc"),"NC",y,function(v) if v then eNC() else dNC() end;whF("Noclip",v) end);y=mkToggle(sc,T("t_ij"),"IJ",y,function(v) if v then eIJ() else dIJ() end;whF("Inf Jump",v) end);y=mkToggle(sc,T("t_lj"),"LJ",y,function(v) if v then eLJ() else dLJ() end;whF("Long Jump",v) end);y=mkSlider(sc,T("lpow"),"LJP",y,20,200,nil);y=mkToggle(sc,T("t_sw"),"SH",y,function(v) whF("Swim Hack",v) end)
    y=mkSec(sc,T("sbh"),y+4);y=mkToggle(sc,T("t_bh"),"BH",y,function(v) if v then eBH() else dBH() end;whF("Bhop",v) end);y=mkSlider(sc,T("lbhs"),"BHS",y,1.0,3.0,"%.1f")
    y=mkSec(sc,T("spd"),y+4);y=mkToggle(sc,T("t_sh"),"SP",y,function(v) if v then eSP() else dSP() end;whF("Speed Hack",v) end);y=mkSlider(sc,T("lmul"),"SPM",y,1.0,10.0,"%.1f")
    y=mkSec(sc,T("sgr"),y+4);y=mkToggle(sc,T("t_gh"),"GH",y,function(v) if not v then WS.Gravity=196.2 end;whF("Gravity Hack",v) end);y=mkSlider(sc,T("lgv"),"GV",y,0,500,"%.1f",function(v) if _G.GH then WS.Gravity=v end end)
    y=mkSec(sc,T("stp"),y+4);y=mkToggle(sc,T("t_ct"),"CT",y,function(v) whF("Cursor TP",v) end)
    y=mkSec(sc,T("sot"),y+4);y=mkToggle(sc,T("t_st"),"SPF",y,function(v) if MGui then MGui.DisplayOrder=v and 200 or 10 end end)
end

TB2["PLAYERS"]=function(p)
    local sc=mkScroll(p);local y=10
    y=mkSec(sc,T("scm"),y);y=mkToggle(sc,T("t_ka"),"KA",y,function(v) if v then eKA() else dKA() end;whF("Kill Aura",v) end);y=mkSlider(sc,T("lrng"),"KAR",y,5,50,nil)
    y=mkSec(sc,T("sgd"),y+4);y=mkToggle(sc,T("t_gd"),"GD",y,function(v) if v then eGD() else dGD() end;whF("Godmode",v) end)
    y=mkSec(sc,T("shl"),y+4);y=mkToggle(sc,T("t_af"),"AAFK",y,function(v) if v then eAFK() else dAFK() end;whF("Anti AFK",v) end)
    y=mkSec(sc,T("snm"),y+4);y=mkToggle(sc,T("t_ns"),"NS",y,function() apNS() end)
    local nb;nb,y=mkInput(sc,T("lnm"),"İsim gir","",y);local ab;ab,y=mkBtn(sc,T("bap"),y);ab.MouseButton1Click:Connect(function() _G.SN=nb.Text;apNS() end)
    y=mkSec(sc,"Oyuncu Listesi",y+4)
    local sb;sb,y=mkBtn(sc,T("bst"),y,Tc.AcF,Tc.Txt);sb.MouseButton1Click:Connect(function() local c=LP.Character;CAM.CameraSubject=(c and c:FindFirstChildOfClass("Humanoid")) or LP end)
    -- Universal oyuncu listesi - tüm oyuncularda çalışır
    local plist=Instance.new("ScrollingFrame",sc);plist.Size=UDim2.new(1,-28,0,260);plist.Position=UDim2.new(0,14,0,y);plist.BackgroundColor3=Tc.Card;corner(8,plist);plist.ScrollBarThickness=3;plist.CanvasSize=UDim2.new(0,0,0,0);plist.AutomaticCanvasSize=Enum.AutomaticSize.Y;plist.BorderSizePixel=0
    Instance.new("UIListLayout",plist).Padding=UDim.new(0,4);local pp=Instance.new("UIPadding",plist);pp.PaddingTop=UDim.new(0,6);pp.PaddingLeft=UDim.new(0,6);pp.PaddingRight=UDim.new(0,6)
    local function refPL()
        for _,c in ipairs(plist:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr==LP then continue end
            local row=Instance.new("Frame",plist);row.Size=UDim2.new(1,0,0,42);row.BackgroundColor3=Tc.CardH;corner(6,row)
            local nl=Instance.new("TextLabel",row);nl.Size=UDim2.new(1,-200,1,0);nl.Position=UDim2.new(0,8,0,0);nl.BackgroundTransparency=1;nl.Text=plr.Name;nl.TextColor3=Tc.Txt;nl.Font=Enum.Font.GothamSemibold;nl.TextSize=12;nl.TextXAlignment=Enum.TextXAlignment.Left
            -- HP bar
            local hum=plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                local pct=math.clamp(hum.Health/math.max(hum.MaxHealth,1),0,1)
                local hpBar=Instance.new("Frame",row);hpBar.Size=UDim2.new(0,pct*60,0,4);hpBar.Position=UDim2.new(0,8,1,-6);hpBar.BackgroundColor3=pct>0.6 and Color3.fromRGB(80,255,120) or(pct>0.3 and Color3.fromRGB(255,220,80) or Color3.fromRGB(255,80,80));hpBar.BorderSizePixel=0;corner(2,hpBar)
            end
            local defs={{l=T("btp"),c=Color3.fromRGB(55,55,180)},{l=T("bpl"),c=Color3.fromRGB(160,90,0)},{l=T("bsp"),c=Color3.fromRGB(75,75,160)},{l=T("bfz"),c=Color3.fromRGB(0,130,130)}}
            local btns={};local xo=1
            for i,bd in ipairs(defs) do
                local b=Instance.new("TextButton",row);b.Size=UDim2.new(0,44,0,28);b.Position=UDim2.new(xo,-(44*(5-i)+4*(5-i)),0.5,-14);b.BackgroundColor3=bd.c;b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextSize=10;b.Text=bd.l;corner(5,b);btns[bd.l]=b
            end
            btns[T("btp")].MouseButton1Click:Connect(function() if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then LP.Character.HumanoidRootPart.CFrame=plr.Character.HumanoidRootPart.CFrame+Vector3.new(0,3,0) end end)
            btns[T("bpl")].MouseButton1Click:Connect(function() if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then plr.Character.HumanoidRootPart.CFrame=LP.Character.HumanoidRootPart.CFrame+Vector3.new(0,3,0) end end)
            btns[T("bsp")].MouseButton1Click:Connect(function() if plr.Character and plr.Character:FindFirstChild("Humanoid") then CAM.CameraSubject=plr.Character.Humanoid end end)
            local frozen=false;btns[T("bfz")].MouseButton1Click:Connect(function() frozen=not frozen;if plr.Character then local root=plr.Character:FindFirstChild("HumanoidRootPart");if root then if frozen then if FP[plr] then return end;local bp=Instance.new("BodyPosition");bp.MaxForce=Vector3.new(4e4,4e4,4e4);bp.P=2000;bp.D=100;bp.Position=root.Position;bp.Parent=root;FP[plr]=bp else if FP[plr] then FP[plr]:Destroy();FP[plr]=nil end end end end;btns[T("bfz")].Text=frozen and T("bfr") or T("bfz");btns[T("bfz")].BackgroundColor3=frozen and Color3.fromRGB(0,180,90) or Color3.fromRGB(0,130,130) end)
        end
    end
    refPL();Players.PlayerAdded:Connect(function() task.wait(0.5);refPL() end);Players.PlayerRemoving:Connect(function() task.wait(0.2);refPL() end)
end

TB2["VISUAL"]=function(p)
    local sc=mkScroll(p);local y=10
    y=mkSec(sc,T("slt"),y);y=mkToggle(sc,T("t_fb"),"FB",y,function(v) apFB(v);whF("Full Bright",v) end);y=mkToggle(sc,T("t_nf"),"NF",y,function(v) apNF(v) end)
    y=mkSec(sc,T("scm2"),y+4);y=mkToggle(sc,T("t_fv"),"FC",y,function(v) if not v then CAM.FieldOfView=oCFOV end end);y=mkSlider(sc,T("lval"),"FCV",y,50,200,nil,function(v) if _G.FC then CAM.FieldOfView=v end end);y=mkToggle(sc,T("t_3p"),"TP3",y,function(v) if v then eTP3() else dTP3() end end);y=mkSlider(sc,T("ltrd"),"TP3D",y,4,30,nil)
    y=mkSec(sc,T("swd"),y+4);y=mkToggle(sc,T("t_tc2"),"TC",y,function(v) apTm(v) end);y=mkSlider(sc,T("ltm"),"TOD",y,0,23,nil,function(v) if _G.TC then apTm(true) end end)
    y=mkSec(sc,T("swc"),y+4);y=mkToggle(sc,T("t_wc2"),"WC",y,function(v) apWC(v) end);y=mkCP(sc,"WCR","WCG","WCB",y);y=mkSlider(sc,T("lr"),"WCR",y,0,255,nil,function() if _G.WC then apWC(true) end end);y=mkSlider(sc,T("lg"),"WCG",y,0,255,nil,function() if _G.WC then apWC(true) end end);y=mkSlider(sc,T("lb"),"WCB",y,0,255,nil,function() if _G.WC then apWC(true) end end)
end

TB2["MISC"]=function(p)
    local sc=mkScroll(p);local y=10
    y=mkSec(sc,T("ssrv"),y);local hb;hb,y=mkBtn(sc,T("bhp"),y,Color3.fromRGB(40,100,180),Color3.new(1,1,1));hb.MouseButton1Click:Connect(function() hb.Text="...";task.spawn(function() serverHop();task.wait(2);hb.Text=T("bhp") end) end)
    y=mkToggle(sc,T("t_rj"),"ARJ",y,function(v) whF("Auto Rejoin",v) end)
    y=mkSec(sc,T("spr"),y+4);y=mkToggle(sc,T("t_fp"),"FPS",y,function(v) if v then eFPS() else dFPS() end;whF("FPS Boost",v) end)
    y=mkSec(sc,T("sch"),y+4);y=mkToggle(sc,T("t_cl"),"CL",y,function(v) if v then eCL() else dCL() end;whF("Chat Logger",v) end)
    if #chatL>0 then local cf=Instance.new("Frame",sc);cf.Size=UDim2.new(1,-28,0,140);cf.Position=UDim2.new(0,14,0,y);cf.BackgroundColor3=Tc.Card;corner(8,cf);local csc=Instance.new("ScrollingFrame",cf);csc.Size=UDim2.new(1,-8,1,-8);csc.Position=UDim2.new(0,4,0,4);csc.BackgroundTransparency=1;csc.ScrollBarThickness=2;csc.CanvasSize=UDim2.new(0,0,0,0);csc.AutomaticCanvasSize=Enum.AutomaticSize.Y;csc.BorderSizePixel=0;Instance.new("UIListLayout",csc).Padding=UDim.new(0,2);for _,log in ipairs(chatL) do local l=Instance.new("TextLabel",csc);l.Size=UDim2.new(1,-4,0,14);l.BackgroundTransparency=1;l.Text=log:sub(1,50);l.TextColor3=Tc.TxtD;l.Font=Enum.Font.Gotham;l.TextSize=10;l.TextXAlignment=Enum.TextXAlignment.Left end;y=y+148 end
    y=mkSec(sc,T("smm"),y+4);y=mkToggle(sc,T("t_mm"),"MM",y,function(v) if v then eMM() else dMM() end;whF("MiniMap",v) end)
end

TB2["ITEMS"]=function(p)
    local sc=mkScroll(p);local y=10
    y=mkSec(sc,T("sit"),y)
    local pBox;pBox,y=mkInput(sc,"Kullanıcı","İsim","",y);local tBox;tBox,y=mkInput(sc,"Eşya","Kılıç","",y);local cBox;cBox,y=mkInput(sc,"Adet","1","1",y)
    local gBtn;gBtn,y=mkBtn(sc,"Ver",y);local sBtn;sBtn,y=mkBtn(sc,"Ara",y,Tc.AcF,Tc.Txt)
    local res=Instance.new("TextLabel",sc);res.Size=UDim2.new(1,-28,0,28);res.Position=UDim2.new(0,14,0,y);res.BackgroundTransparency=1;res.TextColor3=Tc.TxtD;res.Font=Enum.Font.GothamMedium;res.TextSize=13;res.TextWrapped=true;res.TextXAlignment=Enum.TextXAlignment.Left;y=y+34
    local toolsF=Instance.new("Frame",sc);toolsF.Size=UDim2.new(1,-28,0,180);toolsF.Position=UDim2.new(0,14,0,y);toolsF.BackgroundColor3=Tc.Card;corner(8,toolsF)
    local tlbl=Instance.new("TextLabel",toolsF);tlbl.Size=UDim2.new(1,0,0,24);tlbl.BackgroundTransparency=1;tlbl.Text="Eşya Listesi";tlbl.TextColor3=Tc.TxtD;tlbl.Font=Enum.Font.GothamBold;tlbl.TextSize=11
    local tsc=Instance.new("ScrollingFrame",toolsF);tsc.Size=UDim2.new(1,-8,1,-28);tsc.Position=UDim2.new(0,4,0,26);tsc.BackgroundTransparency=1;tsc.ScrollBarThickness=3;tsc.CanvasSize=UDim2.new(0,0,0,0);tsc.AutomaticCanvasSize=Enum.AutomaticSize.Y;tsc.BorderSizePixel=0;Instance.new("UIListLayout",tsc).Padding=UDim.new(0,3)
    local function rfr()
        for _,c in ipairs(tsc:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        task.spawn(function()
            local found={};for _,loc in ipairs({SS,RS2,WS}) do for _,item in ipairs(loc:GetDescendants()) do if item:IsA("Tool") then found[item.Name]=true end end end
            local cnt=0;for name in pairs(found) do local btn=Instance.new("TextButton",tsc);btn.Size=UDim2.new(1,0,0,26);btn.Text=name;btn.TextColor3=Tc.Txt;btn.Font=Enum.Font.Gotham;btn.TextSize=13;btn.BackgroundColor3=Tc.CardH;corner(5,btn);btn.MouseButton1Click:Connect(function() tBox.Text=name end);cnt=cnt+1 end
            res.Text=cnt.." eşya bulundu";res.TextColor3=cnt>0 and Tc.KG or Tc.KR
        end)
    end
    local function giveItem(pN,tN,count)
        count=count or 1
        local tp;for _,plr in ipairs(Players:GetPlayers()) do if plr.Name:lower():find(pN:lower()) then tp=plr;break end end
        if not tp then return false,"Oyuncu bulunamadı" end
        local found;for _,loc in ipairs({SS,RS2,WS}) do local t2=loc:FindFirstChild(tN,true);if t2 and t2:IsA("Tool") then found=t2:Clone();break end end
        if not found then return false,"Eşya bulunamadı" end
        -- Hasar remotes'larını bul ve bağla
        local function bindToolDamage(tool,targetChar)
            for _,r in ipairs(tool:GetDescendants()) do
                if r:IsA("RemoteEvent") then
                    -- Otomatik hasar ver
                    local hrp=targetChar:FindFirstChild("HumanoidRootPart")
                    if hrp then pcall(function() r:FireServer(targetChar,hrp,hrp.Position) end) end
                end
            end
        end
        for i=1,count do
            local cl=found:Clone()
            local bp=tp:FindFirstChild("Backpack")
            if bp then cl.Parent=bp elseif tp.Character then cl.Parent=tp.Character end
            task.wait(0.1)
        end
        return true,count.."x "..tN.." → "..tp.Name
    end
    gBtn.MouseButton1Click:Connect(function() local ok,msg=giveItem(pBox.Text,tBox.Text,math.clamp(tonumber(cBox.Text) or 1,1,20));res.Text=msg;res.TextColor3=ok and Tc.KG or Tc.KR end)
    sBtn.MouseButton1Click:Connect(rfr);rfr()
end

TB2["TEAM"]=function(p)
    local sc=mkScroll(p);local y=10
    y=mkSec(sc,"Takım Değiştir",y)
    local uBox;uBox,y=mkInput(sc,"Kullanıcı","İsim","",y);local tBox;tBox,y=mkInput(sc,"Takım","Takım adı","",y);local cBtn;cBtn,y=mkBtn(sc,"Değiştir",y)
    local res=Instance.new("TextLabel",sc);res.Size=UDim2.new(1,-28,0,28);res.Position=UDim2.new(0,14,0,y);res.BackgroundTransparency=1;res.TextColor3=Tc.TxtD;res.Font=Enum.Font.GothamMedium;res.TextSize=13;res.TextXAlignment=Enum.TextXAlignment.Left
    cBtn.MouseButton1Click:Connect(function()
        if uBox.Text=="" or tBox.Text=="" then res.Text="Doldur!";res.TextColor3=Tc.KR;return end
        local tp;for _,plr in ipairs(Players:GetPlayers()) do if plr.Name:lower()==uBox.Text:lower() then tp=plr;break end end;if not tp then res.Text="Oyuncu bulunamadı";res.TextColor3=Tc.KR;return end
        local tt;for _,t in ipairs(game:GetService("Teams"):GetChildren()) do if t.Name:lower()==tBox.Text:lower() then tt=t;break end end;if not tt then res.Text="Takım bulunamadı";res.TextColor3=Tc.KR;return end
        tp.Team=tt;res.Text=tp.Name.." → "..tt.Name;res.TextColor3=Tc.KG
    end)
end

TB2["ANTICHEAT"]=function(p)
    local sc=mkScroll(p);local y=10
    local infoCard=Instance.new("Frame",sc);infoCard.Size=UDim2.new(1,-28,0,52);infoCard.Position=UDim2.new(0,14,0,y);infoCard.BackgroundColor3=Color3.fromRGB(30,20,10);corner(8,infoCard)
    local il=Instance.new("TextLabel",infoCard);il.Size=UDim2.new(1,-16,1,0);il.Position=UDim2.new(0,8,0,0);il.BackgroundTransparency=1;il.Text="⚠️ AntiCheat bypass özellikleri. Tüm özellikler aktif olsun. Client-side anticheat kontrolleri engellenir.";il.TextColor3=Color3.fromRGB(255,200,100);il.Font=Enum.Font.Gotham;il.TextSize=11;il.TextWrapped=true;il.TextXAlignment=Enum.TextXAlignment.Left;y=y+60
    y=mkSec(sc,T("sac"),y)
    y=mkToggle(sc,T("t_acfl").." (Fly banlamaz)","ACFly",y)
    y=mkToggle(sc,T("t_acnc").." (Noclip bypass)","ACNc",y)
    y=mkToggle(sc,T("t_acsp").." (Hız bypass)","ACSp",y)
    y=mkToggle(sc,T("t_actp").." (TP bypass)","ACTp",y)
    y=mkToggle(sc,T("t_acre").." (AC remote'ları engelle)","ACRe",y)
    y=mkToggle(sc,T("t_acam").." (Aimbot gizle)","ACAm",y)
    y=mkSec(sc,"Remote Tarayıcı",y+4)
    local scanBtn;scanBtn,y=mkBtn(sc,"Weapon Remote'ları Tara",y,Color3.fromRGB(40,80,160),Color3.new(1,1,1))
    local scanRes=Instance.new("TextLabel",sc);scanRes.Size=UDim2.new(1,-28,0,28);scanRes.Position=UDim2.new(0,14,0,y);scanRes.BackgroundTransparency=1;scanRes.TextColor3=Tc.TxtD;scanRes.Font=Enum.Font.GothamMedium;scanRes.TextSize=13;scanRes.TextXAlignment=Enum.TextXAlignment.Left;y=y+36
    scanBtn.MouseButton1Click:Connect(function()
        local remotes=scanRemotes()
        scanRes.Text=string.format("%d weapon remote bulundu",#remotes);scanRes.TextColor3=#remotes>0 and Tc.KG or Tc.KR
    end)
    local infoCard2=Instance.new("Frame",sc);infoCard2.Size=UDim2.new(1,-28,0,0);infoCard2.AutomaticSize=Enum.AutomaticSize.Y;infoCard2.Position=UDim2.new(0,14,0,y);infoCard2.BackgroundColor3=Tc.Card;corner(8,infoCard2)
    local il2=Instance.new("TextLabel",infoCard2);il2.Size=UDim2.new(1,-16,0,0);il2.AutomaticSize=Enum.AutomaticSize.Y;il2.Position=UDim2.new(0,8,0,8);il2.BackgroundTransparency=1
    il2.Text="AntiCheat Bypass Nasıl Çalışır?\n\n✅ Fly Bypass: Network ownership ile sunucu fly'ı normal hareket olarak görür\n✅ Noclip Bypass: Çarpışma devre dışı bırakılır, sunucu farketmez\n✅ Hız Bypass: Hız yavaş yavaş artırılır, ani değişim tespit edilmez\n✅ TP Bypass: TP pozisyon interpolation ile yapılır\n✅ Remote Gizle: Bilinen AC remote'ları intercept edilir\n✅ Aimbot Bypass: Camera manipulation yerine mouse hareketi kullanılır"
    il2.TextColor3=Tc.TxtD;il2.Font=Enum.Font.Gotham;il2.TextSize=11;il2.TextWrapped=true;il2.TextXAlignment=Enum.TextXAlignment.Left
    local aPad=Instance.new("UIPadding",infoCard2);aPad.PaddingBottom=UDim.new(0,10)
end

TB2["CONFIG"]=function(p)
    local sc=mkScroll(p);local y=10
    local ic=Instance.new("Frame",sc);ic.Size=UDim2.new(1,-28,0,36);ic.Position=UDim2.new(0,14,0,y);ic.BackgroundColor3=Tc.AcF;corner(8,ic);local il=Instance.new("TextLabel",ic);il.Size=UDim2.new(1,-16,1,0);il.Position=UDim2.new(0,8,0,0);il.BackgroundTransparency=1;il.Text="Configler bu cihaza kaydedilir. Tema + Dil de kaydedilir. | "..T("disc");il.TextColor3=Tc.TxtD;il.Font=Enum.Font.Gotham;il.TextSize=11;il.TextXAlignment=Enum.TextXAlignment.Left;y=y+44
    y=mkSec(sc,T("csv"),y);local nb;nb,y=mkInput(sc,T("csn"),"benim-config","",y);local sv;sv,y=mkBtn(sc,T("csv"),y,Tc.KG,Color3.new(1,1,1))
    local res=Instance.new("TextLabel",sc);res.Size=UDim2.new(1,-28,0,28);res.Position=UDim2.new(0,14,0,y);res.BackgroundTransparency=1;res.Font=Enum.Font.GothamMedium;res.TextSize=13;res.TextXAlignment=Enum.TextXAlignment.Left;res.TextWrapped=true;y=y+36
    sv.MouseButton1Click:Connect(function() local n=nb.Text:gsub("[^%w%-_]",""):lower();if n=="" then res.Text=T("cne");res.TextColor3=Tc.KR;return end;if svCfg(n) then res.Text=T("cok").." ("..n..")";res.TextColor3=Tc.KG;task.wait(0.5);switchTab("CONFIG") else res.Text=T("cfl");res.TextColor3=Tc.KR end end)
    y=mkSec(sc,"Kayıtlı Configler",y+4)
    local cfgs=lstCfg()
    if #cfgs==0 then
        local el=Instance.new("TextLabel",sc);el.Size=UDim2.new(1,-28,0,28);el.Position=UDim2.new(0,14,0,y);el.BackgroundTransparency=1;el.Text=T("cno");el.TextColor3=Tc.TxtF;el.Font=Enum.Font.GothamMedium;el.TextSize=13;el.TextXAlignment=Enum.TextXAlignment.Left
    else
        for _,cn in ipairs(cfgs) do
            local row=Instance.new("Frame",sc);row.Size=UDim2.new(1,-28,0,44);row.Position=UDim2.new(0,14,0,y);row.BackgroundColor3=Tc.Card;corner(8,row)
            local nl=Instance.new("TextLabel",row);nl.Size=UDim2.new(1,-160,1,0);nl.Position=UDim2.new(0,12,0,0);nl.BackgroundTransparency=1;nl.Text=cn;nl.TextColor3=Tc.Txt;nl.Font=Enum.Font.GothamSemibold;nl.TextSize=13;nl.TextXAlignment=Enum.TextXAlignment.Left
            local function mkB(txt,col,xOff) local b=Instance.new("TextButton",row);b.Size=UDim2.new(0,46,0,28);b.Position=UDim2.new(1,xOff,0.5,-14);b.BackgroundColor3=col;b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextSize=11;b.Text=txt;corner(6,b);return b end
            local lb=mkB(T("cld"),Tc.KG,-152);local db=mkB(T("cdl"),Tc.KR,-98)
            lb.MouseButton1Click:Connect(function() if ldCfg(cn) then bCH();res.Text=T("clk").." ("..cn..")";res.TextColor3=Tc.KG;if rebuildMenu then rebuildMenu() end else res.Text=T("cfl");res.TextColor3=Tc.KR end end)
            db.MouseButton1Click:Connect(function() dlCfg(cn);res.Text=T("cdk");res.TextColor3=Tc.TxtD;task.wait(0.3);switchTab("CONFIG") end)
            y=y+52
        end
    end
end

TB2["SETTINGS"]=function(p)
    local sc=mkScroll(p);local y=10
    y=mkSec(sc,T("sln"),y)
    local lRow=Instance.new("Frame",sc);lRow.Size=UDim2.new(1,-28,0,44);lRow.Position=UDim2.new(0,14,0,y);lRow.BackgroundColor3=Tc.Card;corner(8,lRow)
    local lLbl=Instance.new("TextLabel",lRow);lLbl.Size=UDim2.new(0.4,0,1,0);lLbl.Position=UDim2.new(0,12,0,0);lLbl.BackgroundTransparency=1;lLbl.Text="Language/Dil/Idioma";lLbl.TextColor3=Tc.Txt;lLbl.Font=Enum.Font.GothamMedium;lLbl.TextSize=13;lLbl.TextXAlignment=Enum.TextXAlignment.Left
    local langs={"TR","EN","ES"}
    local function gln(l) return l=="TR" and "🇹🇷 Türkçe" or l=="EN" and "🇬🇧 English" or "🇪🇸 Español" end
    local lBtn=Instance.new("TextButton",lRow);lBtn.Size=UDim2.new(0,120,0,30);lBtn.Position=UDim2.new(1,-134,0.5,-15);lBtn.BackgroundColor3=Tc.AcF;lBtn.TextColor3=Tc.Txt;lBtn.Font=Enum.Font.GothamBold;lBtn.TextSize=13;lBtn.Text=gln(LANG);corner(6,lBtn)
    lBtn.MouseButton1Click:Connect(function() local idx=1;for i,l in ipairs(langs) do if l==LANG then idx=i;break end end;LANG=langs[(idx%#langs)+1];lBtn.Text=gln(LANG);task.wait(0.1);rebuildMenu() end)
    y=y+52
    y=mkSec(sc,T("sth"),y)
    local tGrid=Instance.new("Frame",sc);tGrid.Size=UDim2.new(1,-28,0,0);tGrid.AutomaticSize=Enum.AutomaticSize.Y;tGrid.Position=UDim2.new(0,14,0,y);tGrid.BackgroundTransparency=1
    local tgL=Instance.new("UIGridLayout",tGrid);tgL.CellSize=UDim2.new(0,100,0,56);tgL.CellPadding=UDim2.new(0,6,0,6);tgL.SortOrder=Enum.SortOrder.LayoutOrder
    for i,theme in ipairs(THEMES) do
        local ac2=theme.rb and Color3.fromRGB(255,100,100) or Color3.fromRGB(theme.ac[1],theme.ac[2],theme.ac[3])
        local bg2=Color3.fromRGB(theme.bg[1],theme.bg[2],theme.bg[3])
        local btn=Instance.new("TextButton",tGrid);btn.BackgroundColor3=bg2;btn.BorderSizePixel=0;btn.Text="";btn.LayoutOrder=i;corner(8,btn)
        local aBar=Instance.new("Frame",btn);aBar.Size=UDim2.new(1,0,0,4);aBar.BackgroundColor3=ac2;aBar.BorderSizePixel=0;local ac3=Instance.new("UICorner",aBar);ac3.CornerRadius=UDim.new(0,4)
        local nL=Instance.new("TextLabel",btn);nL.Size=UDim2.new(1,0,1,-4);nL.Position=UDim2.new(0,0,0,4);nL.BackgroundTransparency=1;nL.Text=theme.n;nL.TextColor3=ac2;nL.Font=Enum.Font.GothamBold;nL.TextSize=12
        if i==cTheme then local sel=Instance.new("UIStroke",btn);sel.Color=ac2;sel.Thickness=2 end
        if theme.rb then task.spawn(function() while btn and btn.Parent do local rb=hsv(rbHue,1,1);aBar.BackgroundColor3=rb;nL.TextColor3=rb;task.wait(0.05) end end) end
        btn.MouseButton1Click:Connect(function() cTheme=i;Tc=makeTc();task.wait(0.1);rebuildMenu() end)
    end
    y=y+200
    y=mkSec(sc,T("sabt"),y)
    local aCard=Instance.new("Frame",sc);aCard.Size=UDim2.new(1,-28,0,0);aCard.AutomaticSize=Enum.AutomaticSize.Y;aCard.Position=UDim2.new(0,14,0,y);aCard.BackgroundColor3=Tc.Card;corner(8,aCard)
    local aL=Instance.new("TextLabel",aCard);aL.Size=UDim2.new(1,-16,0,0);aL.AutomaticSize=Enum.AutomaticSize.Y;aL.Position=UDim2.new(0,8,0,8);aL.BackgroundTransparency=1
    aL.Text="SUSANO V2.2\n"..T("disc").."\n\nESP, Aimbot, Rage Aimbot, Silent Aim, Magic Bullet, Trigger Bot, Hitbox, Fake Lag, Fly, Noclip, Speed, BunnyHop, LongJump, Gravity, Cursor TP, Godmode, Kill Aura, Anti AFK, Name Spoof, Full Bright, No Fog, FOV, 3rd Person, Time, World Color, Server Hop, Auto Rejoin, FPS Boost, Chat Logger, MiniMap, Eşya, Takım, AntiCheat Bypass, Config (Local+Tema+Dil), 9 Tema, TR/EN/ES\n\nF5 - Menü | Sağ Tık - Cursor TP"
    aL.TextColor3=Tc.TxtD;aL.Font=Enum.Font.Gotham;aL.TextSize=12;aL.TextWrapped=true;aL.TextXAlignment=Enum.TextXAlignment.Left
    Instance.new("UIPadding",aCard).PaddingBottom=UDim.new(0,10)
end

-- MAIN MENU
local MFrame,SBar,Cont
local cTab="ESP";local mBuilt=false;local minimized=false
local MENU_F=UDim2.new(0,940,0,680);local MENU_M=UDim2.new(0,940,0,46)
local sBtns={}

local function getTabs()
    return {
        {id="ESP",     label=T("te")},
        {id="AIMBOT",  label=T("ta")},
        {id="MOVEMENT",label=T("tm")},
        {id="PLAYERS", label=T("tp")},
        {id="VISUAL",  label=T("tv")},
        {id="MISC",    label=T("tu")},
        {id="ITEMS",   label=T("ti")},
        {id="TEAM",    label=T("tt")},
        {id="ANTICHEAT",label=T("tac")},
        {id="CONFIG",  label=T("tc")},
        {id="SETTINGS",label=T("ts")},
    }
end

switchTab=function(id)
    cTab=id
    local TABS=getTabs()
    for i,btn in ipairs(sBtns) do
        local active=btn:GetAttribute("TID")==id
        tw(btn,0.15,{BackgroundColor3=active and Tc.ActS or Tc.InS})
        local il=btn:FindFirstChild("IL");local nl=btn:FindFirstChild("NL")
        if il then tw(il,0.15,{TextColor3=active and Tc.BG or Tc.TxtF}) end
        if nl then tw(nl,0.15,{TextColor3=active and Tc.BG or Tc.TxtD}) end
        if il and TABS[i] then il.Text=TABS[i].label:sub(1,1):upper() end
        if nl and TABS[i] then nl.Text=TABS[i].label end
    end
    for _,c in ipairs(Cont:GetChildren()) do c:Destroy() end
    Cont.BackgroundTransparency=0.15;tw(Cont,0.12,{BackgroundTransparency=1})
    local b=TB2[id];if b then b(Cont) end
end

createMenu=function()
    if MGui then pcall(function() MGui:Destroy() end) end
    MGui=mkGui("SusanoUI",200);MGui.Enabled=true
    Tc=makeTc()
    MFrame=Instance.new("Frame",MGui);MFrame.Size=MENU_F;MFrame.Position=UDim2.new(0.5,-470,0.5,-340);MFrame.BackgroundColor3=Tc.BG;MFrame.Active=true;corner(10,MFrame)
    local iBd=Instance.new("UIStroke",MFrame);iBd.Color=Tc.AC;iBd.Thickness=1;iBd.Transparency=0.6
    for _,sd in ipairs({{4,3,0.82},{12,6,0.88},{22,10,0.94}}) do local s=Instance.new("Frame",MFrame);s.Size=UDim2.new(1,sd[1],1,sd[1]);s.Position=UDim2.new(0,-sd[1]/2,0,sd[2]);s.BackgroundColor3=Color3.new(0,0,0);s.BackgroundTransparency=sd[3];s.ZIndex=MFrame.ZIndex-1;s.BorderSizePixel=0;corner(15,s) end
    local tb=Instance.new("Frame",MFrame);tb.Size=UDim2.new(1,0,0,46);tb.BackgroundColor3=Tc.TB;tb.BorderSizePixel=0;tb.ClipsDescendants=true;corner(10,tb)
    local tbFx=Instance.new("Frame",tb);tbFx.Size=UDim2.new(1,0,0.5,0);tbFx.Position=UDim2.new(0,0,0.5,0);tbFx.BackgroundColor3=Tc.TB;tbFx.BorderSizePixel=0
    local tl=Instance.new("Frame",tb);tl.Size=UDim2.new(1,0,0,1);tl.Position=UDim2.new(0,0,1,-1);tl.BackgroundColor3=Tc.AC;tl.BorderSizePixel=0;tl.BackgroundTransparency=0.7
    local lt=Instance.new("TextLabel",tb);lt.Size=UDim2.new(0,110,1,0);lt.Position=UDim2.new(0,16,0,0);lt.BackgroundTransparency=1;lt.Text="SUSANO";lt.TextColor3=Tc.AC;lt.Font=Enum.Font.GothamBlack;lt.TextSize=20;lt.TextXAlignment=Enum.TextXAlignment.Left
    local vt=Instance.new("TextLabel",tb);vt.Size=UDim2.new(0,40,1,0);vt.Position=UDim2.new(0,122,0,0);vt.BackgroundTransparency=1;vt.Text="v2.2";vt.TextColor3=Tc.TxtF;vt.Font=Enum.Font.GothamMedium;vt.TextSize=11;vt.TextXAlignment=Enum.TextXAlignment.Left
    local kBdg=Instance.new("Frame",tb);kBdg.Size=UDim2.new(0,80,0,22);kBdg.Position=UDim2.new(0,168,0.5,-11);kBdg.BackgroundColor3=kType=="lifetime" and Tc.KGo or(kType=="monthly" and Color3.fromRGB(180,120,255) or(kType=="weekly" and Color3.fromRGB(80,180,255) or Tc.AcF));corner(5,kBdg)
    local kBL=Instance.new("TextLabel",kBdg);kBL.Size=UDim2.new(1,0,1,0);kBL.BackgroundTransparency=1;kBL.TextColor3=Color3.new(1,1,1);kBL.Font=Enum.Font.GothamBold;kBL.TextSize=11;local kn={daily=T("tpd"),weekly=T("tpw"),monthly=T("tpm"),lifetime=T("tpl")};kBL.Text=kn[kType] or kType:upper()
    local tLbl=Instance.new("TextLabel",tb);tLbl.Size=UDim2.new(0,110,1,0);tLbl.Position=UDim2.new(0,256,0,0);tLbl.BackgroundTransparency=1;tLbl.TextColor3=Tc.TxtF;tLbl.Font=Enum.Font.GothamMedium;tLbl.TextSize=10;tLbl.TextXAlignment=Enum.TextXAlignment.Left;tLbl.Text=fmtT(kExp)
    task.spawn(function() while MGui and MGui.Parent do tLbl.Text=fmtT(kExp);task.wait(60) end end)
    local dLbl=Instance.new("TextLabel",tb);dLbl.Size=UDim2.new(0,180,1,0);dLbl.Position=UDim2.new(0.5,-90,0,0);dLbl.BackgroundTransparency=1;dLbl.Text=T("disc");dLbl.TextColor3=Tc.AC;dLbl.Font=Enum.Font.GothamBold;dLbl.TextSize=12

    if THEMES[cTheme].rb then
        task.spawn(function()
            while MGui and MGui.Parent and THEMES[cTheme].rb do
                rbHue=(rbHue+0.002)%1;local rb=hsv(rbHue,1,1);Tc.AC=rb;Tc.ActS=rb
                pcall(function() lt.TextColor3=rb;tl.BackgroundColor3=rb;iBd.Color=rb;kBdg.BackgroundColor3=rb;dLbl.TextColor3=rb end)
                task.wait(0.05)
            end
        end)
    end

    local function mkTB(text,bg,xOff) local btn=Instance.new("TextButton",tb);btn.Size=UDim2.new(0,28,0,28);btn.Position=UDim2.new(1,xOff,0.5,-14);btn.BackgroundColor3=bg;btn.TextColor3=Color3.new(1,1,1);btn.Font=Enum.Font.GothamBold;btn.TextSize=15;btn.Text=text;corner(6,btn);return btn end
    local cBtn=mkTB("×",Tc.ClsR,-36);cBtn.MouseEnter:Connect(function() tw(cBtn,0.1,{BackgroundColor3=Color3.fromRGB(220,70,70)}) end);cBtn.MouseLeave:Connect(function() tw(cBtn,0.1,{BackgroundColor3=Tc.ClsR}) end);cBtn.MouseButton1Click:Connect(function() tw(MFrame,0.18,{BackgroundTransparency=1});task.wait(0.2);MGui.Enabled=false;MFrame.BackgroundTransparency=0 end)
    local mBtn=mkTB("−",Tc.MinB,-70);mBtn.MouseButton1Click:Connect(function() minimized=not minimized;tw(MFrame,0.2,{Size=minimized and MENU_M or MENU_F});task.wait(0.05);SBar.Visible=not minimized;Cont.Visible=not minimized end)

    SBar=Instance.new("Frame",MFrame);SBar.Size=UDim2.new(0,185,1,-46);SBar.Position=UDim2.new(0,0,0,46);SBar.BackgroundColor3=Tc.SB;SBar.BorderSizePixel=0;corner(10,SBar)
    local sbFx=Instance.new("Frame",SBar);sbFx.Size=UDim2.new(1,0,0.5,0);sbFx.BackgroundColor3=Tc.SB;sbFx.BorderSizePixel=0
    local sDiv=Instance.new("Frame",MFrame);sDiv.Size=UDim2.new(0,1,1,-46);sDiv.Position=UDim2.new(0,185,0,46);sDiv.BackgroundColor3=Tc.AC;sDiv.BorderSizePixel=0;sDiv.BackgroundTransparency=0.8

    sBtns={}
    local TABS=getTabs()
    for i,tab in ipairs(TABS) do
        local isA=tab.id==cTab
        local btn=Instance.new("TextButton",SBar);btn.Size=UDim2.new(1,-14,0,34);btn.Position=UDim2.new(0,7,0,3+(i-1)*36);btn.BackgroundColor3=isA and Tc.ActS or Tc.InS;btn.AutoButtonColor=false;btn.BorderSizePixel=0;btn.Text="";corner(7,btn);btn:SetAttribute("TID",tab.id)
        if isA then local al=Instance.new("Frame",btn);al.Size=UDim2.new(0,3,1,-8);al.Position=UDim2.new(0,2,0,4);al.BackgroundColor3=Tc.BG;al.BorderSizePixel=0;corner(2,al) end
        local iL=Instance.new("TextLabel",btn);iL.Name="IL";iL.Size=UDim2.new(0,28,1,0);iL.Position=UDim2.new(0,8,0,0);iL.BackgroundTransparency=1;iL.Text=tab.label:sub(1,1):upper();iL.TextColor3=isA and Tc.BG or Tc.TxtF;iL.Font=Enum.Font.GothamBold;iL.TextSize=12
        local nL=Instance.new("TextLabel",btn);nL.Name="NL";nL.Size=UDim2.new(1,-40,1,0);nL.Position=UDim2.new(0,38,0,0);nL.BackgroundTransparency=1;nL.Text=tab.label;nL.TextColor3=isA and Tc.BG or Tc.TxtD;nL.Font=Enum.Font.GothamSemibold;nL.TextSize=13;nL.TextXAlignment=Enum.TextXAlignment.Left
        btn.MouseEnter:Connect(function() if btn:GetAttribute("TID")~=cTab then tw(btn,0.1,{BackgroundColor3=Tc.CardH}) end end)
        btn.MouseLeave:Connect(function() if btn:GetAttribute("TID")~=cTab then tw(btn,0.1,{BackgroundColor3=Tc.InS}) end end)
        btn.MouseButton1Click:Connect(function() switchTab(tab.id) end)
        table.insert(sBtns,btn)
    end

    Cont=Instance.new("Frame",MFrame);Cont.Size=UDim2.new(1,-186,1,-46);Cont.Position=UDim2.new(0,186,0,46);Cont.BackgroundTransparency=1;Cont.ClipsDescendants=true

    -- Drag
    local drag,dStart,dPos=false;tb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true;dStart=i.Position;dPos=MFrame.Position;i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drag=false end end) end end);local dInp;tb.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then dInp=i end end);UIS.InputChanged:Connect(function(i) if drag and i==dInp then local d=i.Position-dStart;MFrame.Position=UDim2.new(dPos.X.Scale,dPos.X.Offset+d.X,dPos.Y.Scale,dPos.Y.Offset+d.Y) end end)

    -- Resize
    local rH=Instance.new("Frame",MFrame);rH.Size=UDim2.new(0,14,0,14);rH.Position=UDim2.new(1,-14,1,-14);rH.BackgroundTransparency=1;local rD=Instance.new("Frame",rH);rD.Size=UDim2.new(0,5,0,5);rD.Position=UDim2.new(1,-5,1,-5);rD.BackgroundColor3=Tc.AC;rD.BackgroundTransparency=0.4;corner(2,rD)
    local res2,rsS,rsSz=false;rH.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then res2=true;rsS=i.Position;rsSz=Vector2.new(MFrame.AbsoluteSize.X,MFrame.AbsoluteSize.Y);i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then res2=false end end) end end);local rInp;rH.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then rInp=i end end);UIS.InputChanged:Connect(function(i) if res2 and i==rInp then local d=i.Position-rsS;MFrame.Size=UDim2.new(0,math.clamp(rsSz.X+d.X,620,1400),0,math.clamp(rsSz.Y+d.Y,420,900));SBar.Size=UDim2.new(0,185,1,-46);Cont.Size=UDim2.new(1,-186,1,-46) end end)

    mBuilt=true;local ep=MFrame.Position;MFrame.Position=ep+UDim2.new(0,0,0,14);MFrame.BackgroundTransparency=1;tw(MFrame,0.22,{BackgroundTransparency=0,Position=ep});switchTab(cTab)
end

rebuildMenu=function() mBuilt=false;createMenu() end

-- ESC OVERRIDE - Menü açıkken ESC kapatmasın
UIS.InputBegan:Connect(function(input,gpe)
    if input.KeyCode==Enum.KeyCode.Escape then
        if MGui and MGui.Enabled then
            -- ESC'yi engelle, menü üstte kalsın
            -- Roblox'un default ESC'sini geçersiz kılamayız ama menüyü hemen yeniden aç
            task.wait(0.05)
            if not MGui.Enabled then
                MGui.Enabled=true
                MFrame.BackgroundTransparency=1
                tw(MFrame,0.15,{BackgroundTransparency=0})
            end
        end
    end
end,true) -- True = handled

-- KEY MENU
local kMGui=mkGui("SusanoKeyMenu",999)
local function bldKM(onSuccess)
    local ov=Instance.new("Frame",kMGui);ov.Size=UDim2.new(1,0,1,0);ov.BackgroundColor3=Color3.fromRGB(5,5,5);ov.BackgroundTransparency=0;ov.BorderSizePixel=0
    local card=Instance.new("Frame",kMGui);card.Size=UDim2.new(0,460,0,460);card.Position=UDim2.new(0.5,-230,0.5,-230);card.BackgroundColor3=Tc.BG;card.BorderSizePixel=0;corner(12,card)
    Instance.new("UIStroke",card).Color=Tc.BordL
    local topB=Instance.new("Frame",card);topB.Size=UDim2.new(1,0,0,52);topB.BackgroundColor3=Tc.TB;topB.BorderSizePixel=0;topB.ClipsDescendants=true;corner(12,topB)
    local tbFx=Instance.new("Frame",topB);tbFx.Size=UDim2.new(1,0,0.5,0);tbFx.Position=UDim2.new(0,0,0.5,0);tbFx.BackgroundColor3=Tc.TB;tbFx.BorderSizePixel=0
    local tL=Instance.new("TextLabel",topB);tL.Size=UDim2.new(1,0,0.6,0);tL.BackgroundTransparency=1;tL.Text="SUSANO";tL.TextColor3=Tc.AC;tL.Font=Enum.Font.GothamBlack;tL.TextSize=24
    local sL=Instance.new("TextLabel",topB);sL.Size=UDim2.new(1,0,0.4,0);sL.Position=UDim2.new(0,0,0.6,0);sL.BackgroundTransparency=1;sL.Text="v2.2  |  "..T("disc");sL.TextColor3=Tc.TxtF;sL.Font=Enum.Font.GothamMedium;sL.TextSize=11
    local prBg=Instance.new("Frame",card);prBg.Size=UDim2.new(1,-32,0,68);prBg.Position=UDim2.new(0,16,0,60);prBg.BackgroundColor3=Tc.Card;corner(10,prBg)
    local avF=Instance.new("Frame",prBg);avF.Size=UDim2.new(0,46,0,46);avF.Position=UDim2.new(0,10,0.5,-23);avF.BackgroundColor3=Tc.AcF;corner(23,avF)
    pcall(function() local img=Instance.new("ImageLabel",avF);img.Size=UDim2.new(1,0,1,0);img.BackgroundTransparency=1;corner(23,img);img.Image=Players:GetUserThumbnailAsync(LP.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150) end)
    local info=Instance.new("Frame",prBg);info.Size=UDim2.new(1,-66,1,0);info.Position=UDim2.new(0,62,0,0);info.BackgroundTransparency=1
    local function iLk(y,t,c,s) local l=Instance.new("TextLabel",info);l.Size=UDim2.new(1,0,0,17);l.Position=UDim2.new(0,0,0,y);l.BackgroundTransparency=1;l.Text=t;l.TextColor3=c;l.Font=Enum.Font.GothamMedium;l.TextSize=s;l.TextXAlignment=Enum.TextXAlignment.Left end
    iLk(6,"@"..UN,Tc.Txt,14);iLk(24,"HWID: "..HWID:sub(1,24).."...",Tc.TxtF,10);iLk(40,"UID: "..UID,Tc.TxtF,10)
    local inL=Instance.new("TextLabel",card);inL.Size=UDim2.new(1,-32,0,16);inL.Position=UDim2.new(0,16,0,140);inL.BackgroundTransparency=1;inL.Text="ANAHTAR";inL.TextColor3=Tc.TxtF;inL.Font=Enum.Font.GothamBold;inL.TextSize=10;inL.TextXAlignment=Enum.TextXAlignment.Left
    local iBox=Instance.new("TextBox",card);iBox.Size=UDim2.new(1,-32,0,44);iBox.Position=UDim2.new(0,16,0,158);iBox.BackgroundColor3=Tc.Card;iBox.TextColor3=Tc.Txt;iBox.Font=Enum.Font.GothamMedium;iBox.TextSize=15;iBox.PlaceholderText="SNLIFE-XXXX-XXXX-XXXX";iBox.PlaceholderColor3=Tc.TxtF;iBox.Text="";iBox.ClearTextOnFocus=false;iBox.BorderSizePixel=0;corner(8,iBox)
    local ibSt=Instance.new("UIStroke",iBox);ibSt.Color=Tc.BordL;ibSt.Thickness=1
    local stLbl=Instance.new("TextLabel",card);stLbl.Size=UDim2.new(1,-32,0,20);stLbl.Position=UDim2.new(0,16,0,208);stLbl.BackgroundTransparency=1;stLbl.Text="";stLbl.Font=Enum.Font.GothamMedium;stLbl.TextSize=13;stLbl.TextXAlignment=Enum.TextXAlignment.Left
    local rRow=Instance.new("Frame",card);rRow.Size=UDim2.new(1,-32,0,28);rRow.Position=UDim2.new(0,16,0,234);rRow.BackgroundTransparency=1
    local rLbl=Instance.new("TextLabel",rRow);rLbl.Size=UDim2.new(0.78,0,1,0);rLbl.BackgroundTransparency=1;rLbl.Text=T("kr");rLbl.TextColor3=Tc.TxtD;rLbl.Font=Enum.Font.GothamMedium;rLbl.TextSize=13;rLbl.TextXAlignment=Enum.TextXAlignment.Left
    local rOn=false -- Her girişte key sor
    local rPill=Instance.new("Frame",rRow);rPill.Size=UDim2.new(0,44,0,22);rPill.Position=UDim2.new(1,-44,0.5,-11);rPill.BackgroundColor3=rOn and Tc.OnBG or Tc.OffBG;corner(22,rPill)
    local rKnob=Instance.new("Frame",rPill);rKnob.Size=UDim2.new(0,16,0,16);rKnob.Position=UDim2.new(rOn and 1 or 0,rOn and -19 or 3,0.5,-8);rKnob.BackgroundColor3=rOn and Tc.TB or Tc.AcD;corner(100,rKnob)
    local rBtn=Instance.new("TextButton",rRow);rBtn.Size=UDim2.new(1,0,1,0);rBtn.BackgroundTransparency=1;rBtn.Text=""
    rBtn.MouseButton1Click:Connect(function() rOn=not rOn;tw(rPill,0.18,{BackgroundColor3=rOn and Tc.OnBG or Tc.OffBG});tw(rKnob,0.18,{Position=UDim2.new(rOn and 1 or 0,rOn and -19 or 3,0.5,-8)}) end)
    local aBtn=Instance.new("TextButton",card);aBtn.Size=UDim2.new(1,-32,0,44);aBtn.Position=UDim2.new(0,16,0,270);aBtn.BackgroundColor3=Tc.AC;aBtn.TextColor3=Tc.BG;aBtn.Font=Enum.Font.GothamBold;aBtn.TextSize=16;aBtn.Text=T("kb");corner(8,aBtn)
    aBtn.MouseEnter:Connect(function() tw(aBtn,0.1,{BackgroundColor3=Tc.AC:Lerp(Color3.new(1,1,1),0.15)}) end)
    aBtn.MouseLeave:Connect(function() tw(aBtn,0.1,{BackgroundColor3=Tc.AC}) end)
    local fLbl=Instance.new("TextLabel",card);fLbl.Size=UDim2.new(1,-32,0,18);fLbl.Position=UDim2.new(0,16,0,322);fLbl.BackgroundTransparency=1;fLbl.Text=T("disc");fLbl.TextColor3=Tc.AC;fLbl.Font=Enum.Font.GothamBold;fLbl.TextSize=13
    local atts=0;local busy=false
    local function tryAct()
        if busy then return end
        local key=iBox.Text:upper():gsub("%s+","")
        if key=="" then stLbl.Text=T("kn");stLbl.TextColor3=Tc.KR;return end
        busy=true;stLbl.Text="Doğrulanıyor...";stLbl.TextColor3=Tc.TxtD;aBtn.Text=T("kc");aBtn.BackgroundColor3=Tc.AcF
        valKey(key,function(ok,result,expires)
            busy=false;aBtn.Text=T("kb");aBtn.BackgroundColor3=Tc.AC
            if ok then
                if rOn then sWrite(KF,key) end
                kActive=key;kExp=expires
                stLbl.Text=T("ko");stLbl.TextColor3=Tc.KG
                tw(aBtn,0.2,{BackgroundColor3=Tc.KG});tw(ibSt,0.2,{Color=Tc.KG})
                task.wait(0.8);tw(card,0.25,{BackgroundTransparency=1});tw(ov,0.25,{BackgroundTransparency=1})
                task.wait(0.3);kMGui:Destroy();kValid=true;kType=result;_G.V=true;onSuccess(result)
            else
                atts=atts+1;stLbl.Text=tostring(result).." ("..atts..")";stLbl.TextColor3=Tc.KR
                tw(ibSt,0.1,{Color=Tc.KR});task.wait(0.25);tw(ibSt,0.3,{Color=Tc.BordL})
                if atts>=5 then stLbl.Text=T("km");task.wait(1.5);kMGui:Destroy() end
            end
        end)
    end
    aBtn.MouseButton1Click:Connect(tryAct);iBox.FocusLost:Connect(function(enter) if enter then tryAct() end end)
    task.spawn(function() task.wait(0.1);pcall(function() iBox:CaptureFocus() end) end)
    card.BackgroundTransparency=1;card.Position=UDim2.new(0.5,-230,0.5,-220)
    tw(card,0.18,{BackgroundTransparency=0,Position=UDim2.new(0.5,-230,0.5,-230)})
end

-- RESPAWN
LP.CharacterAdded:Connect(function()
    task.spawn(function()
        task.wait(0.5)
        if _G.FLY then eFly() end;if _G.NC then eNC() end;if _G.BH then eBH() end;if _G.SP then eSP() end;if _G.IJ then eIJ() end;if _G.LJ then eLJ() end;if _G.SH then eSW() end;if _G.NS then apNS() end;if _G.KA then eKA() end;if _G.HB then eHB() end;if _G.GD then eGD() end
    end)
end)

-- F5
UIS.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode==Enum.KeyCode.F5 then
        if not kValid then return end
        if not mBuilt then createMenu()
        else MGui.Enabled=not MGui.Enabled;if MGui.Enabled then MFrame.BackgroundTransparency=1;tw(MFrame,0.22,{BackgroundTransparency=0}) end end
    end
end)

-- INIT
enableTPC();eSW();setupARej()

-- MAIN LOOP
RS.RenderStepped:Connect(function()
    if not _G.V then return end
    if THEMES[cTheme] and THEMES[cTheme].rb then rbHue=(rbHue+0.002)%1 end
    -- ESP
    if _G.ESP then pcall(updE);for _,p in ipairs(Players:GetPlayers()) do if p~=LP and not eC[p] and p.Character then bldE(p) end end else clAE() end
    pcall(updSk)
    -- Aimbot
    if _G.AB and not _G.RA then local t=gBest();if t then local cf=CFrame.new(CAM.CFrame.Position,t.part.Position);CAM.CFrame=CAM.CFrame:Lerp(cf,_G.ASm);aTgt=t.part;setFC(Color3.fromRGB(80,255,120)) else aTgt=nil;setFC(Color3.new(1,1,1)) end elseif not _G.RA then aTgt=nil;setFC(Color3.new(1,1,1)) end
    -- FOV
    if FOVC then local r=_G.FS;FOVC.Size=UDim2.new(0,r*2,0,r*2);FOVC.Position=UDim2.new(0.5,-r,0.5,-r);FOVC.Visible=_G.FV and(_G.AB or _G.RA or _G.SA or _G.MB) end
    -- Toggles
    if _G.FLY and not flying then eFly() elseif not _G.FLY and flying then dFly() end
    if _G.NC and not ncA then eNC() elseif not _G.NC and ncA then dNC() end
    if _G.BH and not bhA then eBH() elseif not _G.BH and bhA then dBH() end
    if _G.SP and not spA then eSP() elseif not _G.SP and spA then dSP() end
    if _G.RA and not raActive then eRA() elseif not _G.RA and raActive then dRA() end
    if _G.SA and not saActive then eSA() elseif not _G.SA and saActive then dSA() end
    if _G.IJ and not ijC then eIJ() elseif not _G.IJ and ijC then dIJ() end
    if _G.LJ and not ljC then eLJ() elseif not _G.LJ and ljC then dLJ() end
    if _G.KA and not kaC then eKA() elseif not _G.KA and kaC then dKA() end
    if _G.AAFK and not afkC then eAFK() elseif not _G.AAFK and afkC then dAFK() end
    if _G.TP3 and not tpC then eTP3() elseif not _G.TP3 and tpC then dTP3() end
    if _G.HB and not hbConn then eHB() elseif not _G.HB and hbConn then dHB() end
    if _G.GD and not gdConn then eGD() elseif not _G.GD and gdConn then dGD() end
    if _G.GH then WS.Gravity=_G.GV else WS.Gravity=196.2 end
    if _G.FB then apFB(true) end;if _G.NF then apNF(true) end
    if _G.FC then CAM.FieldOfView=_G.FCV end;if _G.TC then apTm(true) end;if _G.WC then apWC(true) end
    if _G.MM and not mmGui then eMM() elseif not _G.MM and mmGui then dMM() end
    if _G.CL and not clGui then eCL() elseif not _G.CL and clGui then dCL() end
    if _G.FPS and not fpsA then eFPS() elseif not _G.FPS and fpsA then dFPS() end
end)

-- BAŞLANGIÇ - Her zaman key menüsü çık
sMkDir(CF_DIR)
bldKM(function()
    mkFOV()
    task.spawn(function() task.wait(0.05);createMenu() end)
end)
