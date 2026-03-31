-- SUSANO V2.2 | FIXED & STABLE
-- discord.gg/tCufFEMdux

local t1="ghp_wG4l";local t2="OHjlmUvwum";local t3="ObSMZlppNaGyMq3H3JtpiC"
local CFG={GT=t1..t2..t3,GO="CrafyXD",GR="susano-backend",GB="main"}
local WH_URL="https://discord.com/api/webhooks/WEBHOOK_URL_BURAYA"

-- TEMA
local THEMES={
    {n="Siyah",   bg={12,12,12},   sb={16,16,16},   ac={255,255,255},tb={10,10,10}},
    {n="Lacivert",bg={8,12,28},    sb={12,18,38},   ac={100,160,255},tb={6,10,22}},
    {n="Mor",     bg={16,10,28},   sb={22,14,38},   ac={180,100,255},tb={12,8,22}},
    {n="Yesil",   bg={8,18,10},    sb={10,24,14},   ac={60,220,100}, tb={6,14,8}},
    {n="Kirmizi", bg={22,8,8},     sb={30,10,10},   ac={255,80,80},  tb={18,6,6}},
    {n="Turuncu", bg={22,14,6},    sb={30,18,8},    ac={255,160,40}, tb={18,10,4}},
    {n="Pembe",   bg={22,8,18},    sb={30,10,24},   ac={255,100,200},tb={18,6,14}},
    {n="Beyaz",   bg={220,220,220},sb={200,200,200},ac={30,30,30},   tb={190,190,190}},
    {n="Rainbow", bg={12,12,12},   sb={16,16,16},   ac={255,100,100},tb={10,10,10},rb=true},
}
local cTheme=1
local rbHue=0
local function hsv(h,s,v)
    local r,g,b;local i=math.floor(h*6);local f=h*6-i;local p=v*(1-s);local q=v*(1-f*s);local tv=v*(1-(1-f)*s)
    i=i%6
    if i==0 then r,g,b=v,tv,p elseif i==1 then r,g,b=q,v,p elseif i==2 then r,g,b=p,v,tv
    elseif i==3 then r,g,b=p,q,v elseif i==4 then r,g,b=tv,p,v elseif i==5 then r,g,b=v,p,q end
    return Color3.new(r,g,b)
end
local function rgbC(t) return Color3.fromRGB(t[1],t[2],t[3]) end
local function makeTc()
    local th=THEMES[cTheme]
    local ac=th.rb and hsv(rbHue,1,1) or rgbC(th.ac)
    local bgC=rgbC(th.bg)
    local function lc(c,a) return Color3.new(math.clamp(c.R+a,0,1),math.clamp(c.G+a,0,1),math.clamp(c.B+a,0,1)) end
    return {
        BG=bgC,SB=rgbC(th.sb),AC=ac,TB=rgbC(th.tb),
        Card=lc(bgC,0.06),CardH=lc(bgC,0.1),
        AcD=Color3.new(ac.R*0.6,ac.G*0.6,ac.B*0.6),AcF=lc(bgC,0.14),
        Txt=Color3.fromRGB(235,235,235),TxtD=Color3.fromRGB(130,130,130),
        TxtF=Color3.fromRGB(55,55,55),OffBG=Color3.fromRGB(40,40,40),
        OnBG=Color3.fromRGB(210,210,210),Border=Color3.fromRGB(32,32,32),
        BordL=Color3.fromRGB(50,50,50),ClsR=Color3.fromRGB(185,45,45),
        MinB=Color3.fromRGB(42,42,42),ActS=ac,InS=rgbC(th.sb),
        KG=Color3.fromRGB(30,180,80),KR=Color3.fromRGB(200,50,50),KGo=Color3.fromRGB(220,180,50)
    }
end
local Tc=makeTc()

-- DİL
local LANG="TR"
local LD={
TR={
te="ESP",ta="Aimbot",tm="Hareket",tp="Oyuncular",tv="Gorsel",tu="Misc",tc="Config",ts="Ayarlar",ti="Esya",tt="Takim",tac="AntiCheat",
kb="GIRIS YAP",kc="KONTROL...",kr="Hatirla",ko="Gecerli!",ke="Baglanamadi",ki="Gecersiz",kx="Suresi dolmus",kh="Baska cihaza bagli",km="Cok fazla deneme.",kn="Anahtar gir.",
tpd="GUNLUK",tpw="HAFTALIK",tpm="AYLIK",tpl="SINIRSIZ",tu2="SINIRSIZ",tx="SURESI DOLDU",
sv="Gorunurluk",sl="Etiketler",sf="Filtreler",sa="Aimbot",ss="Silent Aim",so="FOV",smt="Yumusatma",stg="Hedef",sfly="Ucus",smv="Hareket",sbh="Bunny Hop",spd="Hiz",sgr="Yercekimi",stp="Teleport",sot="Diger",scm="Savas",shl="Yardimci",snm="Isim",slt="Aydinlatma",scm2="Kamera",swd="Dunya",swc="Dunya Rengi",ssrv="Sunucu",spr="Performans",sch="Sohbet",smm="MiniMap",shb="Hitbox",sfl="Fake Lag",sln="Dil",sth="Menu Rengi",sabt="Hakkinda",smb="Magic Bullet",sgd="Godmode",sit="Esya",scl="Renk",snmc="Isim Rengi",senm="Dusman Rengi",sfr="Dost Rengi",svc="Gorunur Renk",scrs="Nisangah",stb="Trigger Bot",sac="AntiCheat Bypass",
t_esp="ESP Aktif",t_3d="3D Highlight",t_2d="2D Kutu",t_sk="Skeleton ESP",t_nm="Isim",t_ds="Mesafe",t_hp="Can Cubugu",t_id="ID",t_tr="Tracer",t_tc="Takim Kontrolu",t_fr="Dostlari Goster",t_wc="Duvar Kontrolu/Chams",t_ab="Aimbot",t_ra="Rage Aimbot",t_sa="Silent Aim",t_mb="Magic Bullet",t_tb="Trigger Bot",t_hb="Hitbox Buyutme",t_fl="Fake Lag",t_ff="FOV Filtresi",t_fc="FOV Dairesi",t_fly="Uc",t_nc="Noclip",t_ij="Sonsuz Zipplama",t_lj="Uzun Atlama",t_sw="Yuzme Hack",t_bh="Bunny Hop",t_sh="Hiz Hack",t_gh="Gravity Hack",t_ct="Cursor TP",t_st="Stream Proof",t_ka="Kill Aura",t_gd="Godmode",t_af="Anti AFK",t_ns="Isim Degistir",t_fb="Full Bright",t_nf="Sis Kaldir",t_fv="FOV Degistir",t_3p="3. Sahis",t_tc2="Saat Degistir",t_wc2="Renk Degistir",t_rj="Auto Rejoin",t_fp="FPS Boost",t_cl="Chat Logger",t_mm="MiniMap",t_crs="Nisangah",t_dot="Merkez Nokta",t_out="Dis Cizgi",
t_acfl="Fly Bypass",t_acnc="Noclip Bypass",t_acsp="Hiz Bypass",t_actp="TP Bypass",t_acre="Remote Gizle",t_acam="Aimbot Bypass",
lr="Kirmizi",lg="Yesil",lb="Mavi",lsz="Boyut",lth="Kalinlik",lgp="Bosluk",lop="Opaklik",lmul="Carpan",lrng="Menzil",ldst="Mesafe",lspd="Hiz",lpow="Guc",lval="Deger",lprev="Renk Onizleme",lfls="Ucus Hizi",lfov="FOV Capi",lsm="Yumusatma",llag="Lag Suresi",ltm="Saat",ltrd="3P Mesafe",ltt="Tracer Kalinlik",lgv="Gravity",lbhs="BHop Hizi",lhbs="Hitbox Boyutu",lnm="Sahte Isim",ltbs="Trigger Gecikme",
bap="Uygula",bst="Izlemeyi Durdur",bhp="Server Hop",btp="TP",bpl="PULL",bsp="SPEC",bfz="FRZ",bfr="FREE",
csn="Config Adi",csv="Kaydet",cld="Yukle",cdl="Sil",cno="Kayitli config yok.",cok="Kaydedildi!",clk="Yuklendi!",cdk="Silindi.",cfl="Basarisiz.",cne="Isim gir!",
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
}}
local function T(k) return (LD[LANG] and LD[LANG][k]) or k end

-- SERVISLER
local Players=game:GetService("Players")
local RunSvc=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local TweenSvc=game:GetService("TweenService")
local WS=game:GetService("Workspace")
local LT=game:GetService("Lighting")
local HS=game:GetService("HttpService")
local CG=game:GetService("CoreGui")
local RS2=game:GetService("ReplicatedStorage")
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

-- HTTP REQUEST (Hata düzeltmesi)
local function hReq(m,u,b,h)
    local reqFunc = http_request or request or (syn and syn.request)
    if not reqFunc then return false, nil end
    local ok,r=pcall(function()
        return reqFunc({Url=u,Method=m,Headers=h or {},Body=b})
    end)
    if not ok or not r then return false,nil end
    return true,(r.Body or r.body or "")
end

local function ghR(path)
    return hReq("GET","https://raw.githubusercontent.com/"..CFG.GO.."/"..CFG.GR.."/"..CFG.GB.."/"..path)
end
local function ghW(path,content,msg)
    local su="https://api.github.com/repos/"..CFG.GO.."/"..CFG.GR.."/contents/"..path
    local sha=""
    local ok2,sb=hReq("GET",su,nil,{["Authorization"]="token "..CFG.GT,["Accept"]="application/vnd.github.v3+json",["User-Agent"]="Susano"})
    if ok2 and sb then pcall(function() local d=HS:JSONDecode(sb);if d and d.sha then sha=d.sha end end) end
    local b64="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local function enc(data)
        local res={};local pad=(3-#data%3)%3;data=data..string.rep("\0",pad)
        for i=1,#data,3 do
            local a,b,c=data:byte(i,i+2);local n=a*65536+b*256+c
            res[#res+1]=b64:sub(math.floor(n/262144)%64+1,math.floor(n/262144)%64+1)
            res[#res+1]=b64:sub(math.floor(n/4096)%64+1,math.floor(n/4096)%64+1)
            res[#res+1]=b64:sub(math.floor(n/64)%64+1,math.floor(n/64)%64+1)
            res[#res+1]=b64:sub(n%64+1,n%64+1)
        end
        local r2=table.concat(res);return r2:sub(1,#r2-pad)..string.rep("=",pad)
    end
    return hReq("PUT",su,HS:JSONEncode({message=msg or "u",content=enc(content),sha=sha~="" and sha or nil,branch=CFG.GB}),
        {["Authorization"]="token "..CFG.GT,["Accept"]="application/vnd.github.v3+json",["Content-Type"]="application/json",["User-Agent"]="Susano"})
end

-- WEBHOOK
local function wh(title,color,fields)
    if WH_URL:find("WEBHOOK_URL_BURAYA") then return end
    coroutine.wrap(function()
        pcall(function()
            local body=HS:JSONEncode({embeds={{title=title,color=color,fields=fields,footer={text="Susano V2.2 | "..T("disc")},timestamp=os.date("!%Y-%m-%dT%H:%M:%SZ")}}})
            hReq("POST",WH_URL,body,{["Content-Type"]="application/json"})
        end)
    end)()
end

-- KEY SİSTEM
local kValid=false;local kType="none";local kExp=0;local kActive=""
local function fmtT(exp)
    if exp==0 then return T("tu2") end
    local left=exp-os.time();if left<=0 then return T("tx") end
    local d=math.floor(left/86400);local h=math.floor((left%86400)/3600);local m2=math.floor((left%3600)/60)
    if d>0 then return d.."g "..h.."s" elseif h>0 then return h.."s "..m2.."dk" else return m2.."dk" end
end

local function loadKeys()
    local ok,b=ghR("keys.json");if not ok or not b then return nil end
    local ok2,d=pcall(function() return HS:JSONDecode(b) end);if not ok2 then return nil end
    return d
end

local function valKey(key,cb)
    key=key:upper():gsub("%s+","")
    if key=="" then cb(false,T("kn"),0);return end
    coroutine.wrap(function()
        local all=loadKeys()
        if not all then cb(false,T("ke"),0);return end
        local kd=all[key]
        if not kd then
            wh("❌ Gecersiz Key",15158332,{{name="👤",value="["..UN.."](https://www.roblox.com/users/"..UID.."/profile)",inline=true},{name="🔑",value=key:sub(1,15),inline=true},{name="💻",value=HWID:sub(1,20),inline=false}})
            cb(false,T("ki"),0);return
        end
        if kd.activated and kd.expires and kd.expires>0 and os.time()>kd.expires then cb(false,T("kx"),0);return end
        if kd.activated and kd.hwid and tostring(kd.hwid)~="" and tostring(kd.hwid)~="null" then
            if tostring(kd.hwid)~=HWID then
                wh("🚫 Yanlis HWID",15158332,{{name="👤",value="["..UN.."](https://www.roblox.com/users/"..UID.."/profile)",inline=true},{name="💻 Girilen",value=HWID:sub(1,20),inline=true},{name="🔒 Kayitli",value=tostring(kd.hwid):sub(1,20),inline=true}})
                cb(false,T("kh"),0);return
            end
        else
            all[key].hwid=HWID
            all[key].activated=true
            local dur=kd.duration or 0
            all[key].expires=dur>0 and (os.time()+dur) or 0
            kExp=all[key].expires
            coroutine.wrap(function()
                local ok3,json=pcall(function() return HS:JSONEncode(all) end)
                if ok3 then ghW("keys.json",json,"activate:"..UN) end
                wh("🎉 Aktivasyon",3066993,{
                    {name="👤",value="["..UN.."](https://www.roblox.com/users/"..UID.."/profile)",inline=true},
                    {name="🆔",value=UID,inline=true},
                    {name="🔑",value=kd.type or "?",inline=true},
                    {name="💻",value=HWID:sub(1,30),inline=false},
                    {name="⏰",value=all[key].expires==0 and "Sinirsiz" or os.date("%d.%m.%Y %H:%M",all[key].expires),inline=true},
                    {name="🎮",value=tostring(game.PlaceId),inline=true},
                })
            end)()
        end
        wh("✅ Giris",3447003,{
            {name="👤",value="["..UN.."](https://www.roblox.com/users/"..UID.."/profile)",inline=true},
            {name="🔑",value=kd.type or "?",inline=true},
            {name="⏰",value=fmtT(all[key].expires or 0),inline=true},
            {name="💻",value=HWID:sub(1,30),inline=false},
        })
        cb(true,kd.type or "lifetime",all[key].expires or 0)
    end)()
end

-- GLOBALS
_G.V=false
_G.ESP=false;_G.E3D=false;_G.E2D=false;_G.ENm=false;_G.EDs=false;_G.EHp=false;_G.EId=false;_G.ETr=false;_G.ETt=1.5;_G.ETC=false;_G.EFF=false;_G.EWC=false;_G.ESk=false
_G.EER=255;_G.EEG=60;_G.EEB=60;_G.EFR=80;_G.EFG=140;_G.EFB=255;_G.EVR=80;_G.EVG=255;_G.EVB=120;_G.ENR=255;_G.ENG=255;_G.ENB=255
_G.CH=false;_G.CHS="Cross";_G.CHSz=12;_G.CHTh=2;_G.CHGp=4;_G.CHAl=1.0;_G.CHDt=false;_G.CHOt=false;_G.CHR=255;_G.CHG=255;_G.CHB=255
_G.AB=false;_G.RA=false;_G.SA=false;_G.MB=false;_G.TB=false;_G.TBD=0.05;_G.UF=true;_G.FV=true;_G.FS=120;_G.ASm=0.3;_G.APH=true;_G.APC=false;_G.APS=false
_G.HB=false;_G.HBSz=5;_G.FL=false;_G.FLI=0.1
_G.GD=false
_G.FLY=false;_G.FLS=50;_G.NC=false;_G.BH=false;_G.BHS=1.2;_G.BHH=7;_G.SP=false;_G.SPM=2.0;_G.IJ=false;_G.LJ=false;_G.LJP=80;_G.SH=false
_G.GH=false;_G.GV=196.2;_G.CT=false
_G.KA=false;_G.KAR=15;_G.AAFK=false;_G.NS=false;_G.SN="";_G.SPF=false
_G.FB=false;_G.NF=false;_G.FC=false;_G.FCV=200;_G.TP3=false;_G.TP3D=12;_G.TC=false;_G.TOD=14;_G.WC=false;_G.WCR=128;_G.WCG=128;_G.WCB=128
_G.ARJ=false;_G.FPS=false;_G.CL=false;_G.MM=false
_G.ACFly=true;_G.ACNc=true;_G.ACSp=true;_G.ACRe=true;_G.ACAm=true
local FP={};local chatL={}

-- ANTICHEAT BYPASS CORE
local acBlockedConns={}
local function setupNetOwn(char)
    if not char then return end
    for _,p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            pcall(function()
                if sethiddenproperty then sethiddenproperty(p,"NetworkOwnershipRule",0) end
            end)
        end
    end
end

local function blockACRemotes()
    if not _G.ACRe then return end
    local acKW={"anticheat","detect","cheat","exploit","flag","ban","kick","hack","suspicious"}
    for _,loc in ipairs({RS2,WS}) do
        pcall(function()
            for _,obj in ipairs(loc:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    local lower=obj.Name:lower()
                    for _,kw in ipairs(acKW) do
                        if lower:find(kw) then
                            pcall(function()
                                local conn=obj.OnClientEvent:Connect(function() end)
                                table.insert(acBlockedConns,conn)
                            end)
                            break
                        end
                    end
                end
                if obj:IsA("RemoteFunction") then
                    local lower=obj.Name:lower()
                    for _,kw in ipairs(acKW) do
                        if lower:find(kw) then
                            pcall(function() obj.OnClientInvoke=function() return nil end end)
                            break
                        end
                    end
                end
            end
        end)
    end
end

LP.CharacterAdded:Connect(function(char)
    wait(0.5)
    pcall(function() setupNetOwn(char) end)
    pcall(function() blockACRemotes() end)
end)
if LP.Character then pcall(function() setupNetOwn(LP.Character) end) end
coroutine.wrap(function() wait(3);pcall(blockACRemotes) end)()

local remoteCache={}
local function scanRemotes()
    remoteCache={}
    local dmgKW={"damage","hit","attack","shoot","fire","bullet","weapon","tool","hurt","kill","strike"}
    for _,loc in ipairs({RS2,WS}) do
        pcall(function()
            for _,obj in ipairs(loc:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    local lower=obj.Name:lower()
                    for _,kw in ipairs(dmgKW) do
                        if lower:find(kw) then table.insert(remoteCache,obj);break end
                    end
                end
            end
        end)
    end
    return remoteCache
end
coroutine.wrap(function() wait(3);pcall(scanRemotes) end)()

local function dealDamage(targetChar,hitPart,hitPos)
    if not targetChar then return end
    pcall(function()
        local char=LP.Character
        if char then
            for _,tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    for _,r in ipairs(tool:GetDescendants()) do
                        if r:IsA("RemoteEvent") then
                            pcall(function() r:FireServer(targetChar,hitPart,hitPos or (hitPart and hitPart.Position)) end)
                        end
                    end
                end
            end
        end
        for _,r in ipairs(remoteCache) do
            pcall(function() r:FireServer(targetChar,hitPart,hitPos or (hitPart and hitPart.Position)) end)
        end
    end)
end

-- UI HELPERS
local function corner(r,p) local c=Instance.new("UICorner",p);c.CornerRadius=UDim.new(0,r);return c end
local function tw(o,t,pr) pcall(function() TweenSvc:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quad),pr):Play() end) end
local function mkScroll(parent)
    local sc=Instance.new("ScrollingFrame",parent)
    sc.Size=UDim2.new(1,0,1,0);sc.BackgroundTransparency=1;sc.ScrollBarThickness=3
    sc.ScrollBarImageColor3=Color3.fromRGB(60,60,60);sc.CanvasSize=UDim2.new(0,0,0,0)
    sc.AutomaticCanvasSize=Enum.AutomaticSize.Y;sc.BorderSizePixel=0;return sc
end
local function mkGui(name,order)
    pcall(function() local e=GP:FindFirstChild(name);if e then e:Destroy() end end)
    local g=Instance.new("ScreenGui");g.Name=name;g.ResetOnSpawn=false;g.IgnoreGuiInset=true
    g.DisplayOrder=order or 200;pcall(function() g.ZIndexBehavior=Enum.ZIndexBehavior.Global end)
    g.Parent=GP;return g
end

local function mkToggle(parent,label,setting,yPos,onToggle)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-10,0,44);row.Position=UDim2.new(0,5,0,yPos);row.BackgroundColor3=Tc.Card;corner(8,row)
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
        if onToggle then pcall(function() onToggle(_G[setting]) end) end
    end)
    return yPos+52
end

local function mkSlider(parent,label,setting,yPos,minV,maxV,fmt,onChange)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-10,0,54);row.Position=UDim2.new(0,5,0,yPos);row.BackgroundColor3=Tc.Card;corner(8,row)
    local function fv(v) return fmt and string.format(fmt,v) or tostring(math.floor(v)) end
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(0.6,0,0,22);lbl.Position=UDim2.new(0,12,0,6);lbl.BackgroundTransparency=1;lbl.Text=label;lbl.TextColor3=Tc.Txt;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=13;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local valL=Instance.new("TextLabel",row);valL.Size=UDim2.new(0.35,0,0,22);valL.Position=UDim2.new(0.65,0,0,6);valL.BackgroundTransparency=1;valL.Text=fv(_G[setting]);valL.TextColor3=Tc.TxtD;valL.Font=Enum.Font.GothamMedium;valL.TextSize=12;valL.TextXAlignment=Enum.TextXAlignment.Right
    local track=Instance.new("Frame",row);track.Size=UDim2.new(1,-24,0,3);track.Position=UDim2.new(0,12,1,-14);track.BackgroundColor3=Tc.AcF;corner(3,track)
    local fill=Instance.new("Frame",track);fill.Size=UDim2.new((_G[setting]-minV)/(maxV-minV),0,1,0);fill.BackgroundColor3=Tc.AC;corner(3,fill)
    local drag=false
    local function setV(ix)
        local rx=math.clamp(ix-track.AbsolutePosition.X,0,track.AbsoluteSize.X)
        local pct=rx/track.AbsoluteSize.X
        _G[setting]=math.floor((minV+pct*(maxV-minV))*100)/100
        fill.Size=UDim2.new(pct,0,1,0);valL.Text=fv(_G[setting])
        if onChange then pcall(function() onChange(_G[setting]) end) end
    end
    track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true;setV(i.Position.X) end end)
    track.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
    UIS.InputChanged:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseMovement then setV(i.Position.X) end end)
    return yPos+62
end

local function mkSec(parent,txt,yPos)
    local lbl=Instance.new("TextLabel",parent);lbl.Size=UDim2.new(1,-10,0,22);lbl.Position=UDim2.new(0,5,0,yPos);lbl.BackgroundTransparency=1;lbl.Text=string.upper(txt);lbl.TextColor3=Tc.TxtF;lbl.Font=Enum.Font.GothamBold;lbl.TextSize=10;lbl.TextXAlignment=Enum.TextXAlignment.Left
    return yPos+30
end

local function mkWarn(parent,txt,yPos)
    local warnF=Instance.new("TextLabel",parent)
    warnF.Size=UDim2.new(1,-10,0,25);warnF.Position=UDim2.new(0,5,0,yPos)
    warnF.BackgroundColor3=Color3.fromRGB(60,20,10);warnF.BackgroundTransparency=0
    warnF.Text=txt;warnF.TextColor3=Color3.fromRGB(255,100,80)
    warnF.Font=Enum.Font.GothamBold;warnF.TextSize=11;warnF.TextWrapped=true
    corner(6,warnF);return yPos+33
end

-- FEATURE FONKSIYONLARI
local eFly,dFly,eNC,dNC,eBH,dBH,eSP,dSP,eIJ,dIJ,eLJ,dLJ,eSW
local eKA,dKA,eAFK,dAFK,eRA,dRA,eSA,dSA,eTP3,dTP3,eHB,dHB,eGD,dGD
local apNS,apFB,apNF,apTm,apWC
local bCH,MGui,switchTab,createMenu,rebuildMenu

-- Crosshair
local chGui;local CHSTYLES={"Cross","Circle","Dot","T-Shape","X-Shape","Square"}
local function dCH() if chGui then pcall(function() chGui:Destroy() end);chGui=nil end end
bCH=function()
    dCH();if not _G.CH then return end
    chGui=mkGui("SusanoCH",200)
    local col=Color3.fromRGB(_G.CHR,_G.CHG,_G.CHB)
    local s=_G.CHSz;local g=_G.CHGp;local th=_G.CHTh;local al=1-_G.CHAl
    local function mkL(w,h,ox,oy)
        local f=Instance.new("Frame",chGui);f.BackgroundColor3=col;f.BorderSizePixel=0
        f.BackgroundTransparency=al;f.Size=UDim2.new(0,w,0,h)
        f.AnchorPoint=Vector2.new(0.5,0.5);f.Position=UDim2.new(0.5,ox,0.5,oy);f.ZIndex=500
        if _G.CHOt then local os2=Instance.new("UIStroke",f);os2.Color=Color3.new(0,0,0);os2.Thickness=1;os2.Transparency=al+0.3 end
        return f
    end
    local st=_G.CHS
    if st=="Cross" then mkL(s,th,-(g+s/2),0);mkL(s,th,(g+s/2),0);mkL(th,s,0,-(g+s/2));mkL(th,s,0,(g+s/2))
    elseif st=="T-Shape" then mkL(s,th,-(g+s/2),0);mkL(s,th,(g+s/2),0);mkL(th,s,0,(g+s/2))
    elseif st=="X-Shape" then local f1=mkL(s,th,0,0);f1.Rotation=45;local f2=mkL(s,th,0,0);f2.Rotation=-45
    elseif st=="Dot" then corner(100,mkL(th*3,th*3,0,0))
    elseif st=="Circle" then
        local c2=Instance.new("Frame",chGui);c2.Size=UDim2.new(0,s*2,0,s*2);c2.Position=UDim2.new(0.5,-s,0.5,-s)
        c2.BackgroundTransparency=1;c2.BorderSizePixel=0;c2.ZIndex=500;corner(999,c2)
        local sk=Instance.new("UIStroke",c2);sk.Color=col;sk.Thickness=th;sk.Transparency=al
    elseif st=="Square" then mkL(s*2,th,0,-s);mkL(s*2,th,0,s);mkL(th,s*2,-s,0);mkL(th,s*2,s,0) end
    if _G.CHDt and st~="Dot" then corner(100,mkL(th+1,th+1,0,0)) end
end

-- FOV Circle
local FOVC,FOVGui
local function mkFOV()
    if FOVGui then pcall(function() FOVGui:Destroy() end) end
    FOVGui=mkGui("SusanoFOV",200)
    FOVC=Instance.new("Frame",FOVGui);local r=_G.FS
    FOVC.Size=UDim2.new(0,r*2,0,r*2);FOVC.Position=UDim2.new(0.5,-r,0.5,-r)
    FOVC.BackgroundTransparency=1;FOVC.BorderSizePixel=0;FOVC.ZIndex=999;corner(999,FOVC)
    local fs=Instance.new("UIStroke",FOVC);fs.Color=Color3.new(1,1,1);fs.Thickness=1;fs.Transparency=0.45;fs.Name="FS"
    FOVC.Visible=_G.FV
end
local function setFC(col) if FOVC then pcall(function() local s=FOVC:FindFirstChild("FS");if s then s.Color=col end end) end end

-- TP Cursor
local tpGui,tpInd,tpLbl2
local function setupTP()
    if tpGui then pcall(function() tpGui:Destroy() end) end
    tpGui=mkGui("SusanoTP",198)
    tpInd=Instance.new("Frame",tpGui);tpInd.Size=UDim2.new(0,22,0,22);tpInd.BackgroundColor3=Color3.fromRGB(100,220,255);tpInd.BackgroundTransparency=0.3;tpInd.BorderSizePixel=0;tpInd.AnchorPoint=Vector2.new(0.5,0.5);tpInd.Visible=false;corner(11,tpInd)
    local inner=Instance.new("Frame",tpInd);inner.Size=UDim2.new(0,7,0,7);inner.BackgroundColor3=Color3.new(1,1,1);inner.AnchorPoint=Vector2.new(0.5,0.5);inner.Position=UDim2.new(0.5,0,0.5,0);inner.BorderSizePixel=0;corner(4,inner)
    tpLbl2=Instance.new("TextLabel",tpGui);tpLbl2.Size=UDim2.new(0,70,0,18);tpLbl2.BackgroundColor3=Color3.fromRGB(0,0,0);tpLbl2.BackgroundTransparency=0.4;tpLbl2.TextColor3=Color3.new(1,1,1);tpLbl2.Font=Enum.Font.GothamBold;tpLbl2.TextSize=11;tpLbl2.Text="TP";tpLbl2.AnchorPoint=Vector2.new(0.5,0);tpLbl2.Visible=false;tpLbl2.BorderSizePixel=0;corner(4,tpLbl2)
end
setupTP()

local tpMoveC,tpClickC
local tpPos=nil
local function enableTPC()
    if tpMoveC then tpMoveC:Disconnect() end
    if tpClickC then tpClickC:Disconnect() end
    tpMoveC=RunSvc.RenderStepped:Connect(function()
        if not _G.CT then pcall(function() tpInd.Visible=false;tpLbl2.Visible=false end);return end
        pcall(function()
            local mp=UIS:GetMouseLocation()
            local ur=CAM:ScreenPointToRay(mp.X,mp.Y)
            local params=RaycastParams.new()
            if LP.Character then params.FilterDescendantsInstances={LP.Character} end
            params.FilterType=Enum.RaycastFilterType.Exclude
            local result=WS:Raycast(ur.Origin,ur.Direction*500,params)
            if result then
                tpPos=result.Position
                tpInd.Position=UDim2.new(0,mp.X,0,mp.Y);tpInd.Visible=true
                local dist=math.floor((result.Position-CAM.CFrame.Position).Magnitude)
                tpLbl2.Position=UDim2.new(0,mp.X-35,0,mp.Y+14);tpLbl2.Text=dist.."m";tpLbl2.Visible=true
            else
                tpPos=nil;tpInd.Visible=false;tpLbl2.Visible=false
            end
        end)
    end)
    tpClickC=UIS.InputBegan:Connect(function(input,gpe)
        if gpe or not _G.CT then return end
        if input.UserInputType==Enum.UserInputType.MouseButton2 then
            if tpPos then
                pcall(function()
                    local char=LP.Character;if not char then return end
                    local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
                    local hum=char:FindFirstChildOfClass("Humanoid")
                    local offset=3
                    if hum then pcall(function() local desc=hum:GetAppliedDescription();if desc then offset=math.max(desc.HeadScale*1.5+desc.BodyTypeScale*2.5,2.5) end end) end
                    hrp.CFrame=CFrame.new(tpPos+Vector3.new(0,offset,0))
                    tpInd.BackgroundColor3=Color3.fromRGB(100,255,100)
                    wait(0.3)
                    pcall(function() tpInd.BackgroundColor3=Color3.fromRGB(100,220,255) end)
                end)
            end
        end
    end)
end

-- Skeleton ESP
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
        for i,bone in ipairs(bL) do
            local line=skD[pl][i];if not line then continue end
            local p1=char:FindFirstChild(bone[1]);local p2=char:FindFirstChild(bone[2])
            if p1 and p2 then
                local sp1,o1=CAM:WorldToViewportPoint(p1.Position)
                local sp2,o2=CAM:WorldToViewportPoint(p2.Position)
                if o1 and o2 then line.Visible=true;line.From=Vector2.new(sp1.X,sp1.Y);line.To=Vector2.new(sp2.X,sp2.Y);line.Color=col
                else line.Visible=false end
            else line.Visible=false end
        end
    end
end

local function isVis(pl)
    if not pl.Character then return false end
    local head=pl.Character:FindFirstChild("Head");if not head then return false end
    local origin=CAM.CFrame.Position
    local params=RaycastParams.new()
    if LP.Character then params.FilterDescendantsInstances={LP.Character,pl.Character}
    else params.FilterDescendantsInstances={pl.Character} end
    params.FilterType=Enum.RaycastFilterType.Exclude
    return WS:Raycast(origin,head.Position-origin,params)==nil
end

-- Aimbot
local function gTP(p)
    if not p.Character then return nil end
    if _G.APH then local h=p.Character:FindFirstChild("Head");if h then return h end end
    if _G.APC then local c=p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso");if c then return c end end
    return p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
end
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

-- Silent Aim
local saActive=false;local saC1,saC2
eSA=function()
    saActive=true;if saC1 then saC1:Disconnect() end;if saC2 then saC2:Disconnect() end
    saC1=RunSvc.RenderStepped:Connect(function()
        if not _G.SA or not saActive then return end
        pcall(function()
            local t=gBest();if not t then return end
            local sp,onS=CAM:WorldToViewportPoint(t.part.Position);if not onS then return end
            local mp=UIS:GetMouseLocation()
            local dx=sp.X-mp.X;local dy=sp.Y-mp.Y
            if mousemoverel then mousemoverel(dx*0.15,dy*0.15) end
        end)
    end)
end
dSA=function() saActive=false;if saC1 then saC1:Disconnect();saC1=nil end end

-- Rage Aimbot
local raActive,raConn=false,nil
dRA=function() raActive=false;if raConn then raConn:Disconnect();raConn=nil end end
eRA=function()
    if raActive then return end;raActive=true
    raConn=RunSvc.RenderStepped:Connect(function()
        if not _G.RA then dRA();return end
        pcall(function()
            local best,bD=nil,math.huge
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    local fr=p.Team and LP.Team and p.Team==LP.Team
                    if fr and not _G.EFF then continue end
                    if not fr and not _G.ETC then continue end
                    local hum=p.Character:FindFirstChildOfClass("Humanoid");if not hum or hum.Health<=0 then continue end
                    for _,pn in ipairs({"Head","UpperTorso","Torso","HumanoidRootPart"}) do
                        local part=p.Character:FindFirstChild(pn)
                        if part then local d=(part.Position-CAM.CFrame.Position).Magnitude;if d<bD then bD=d;best=part end end
                    end
                end
            end
            if best then CAM.CFrame=CFrame.new(CAM.CFrame.Position,best.Position);setFC(Color3.fromRGB(255,80,80))
            else setFC(Color3.new(1,1,1)) end
        end)
    end)
end

-- Trigger Bot
local tbConn
local function eTB()
    if tbConn then tbConn:Disconnect() end
    tbConn=RunSvc.Heartbeat:Connect(function()
        if not _G.TB then return end
        pcall(function()
            local t=gBest();if not t then return end
            local sp,onS=CAM:WorldToViewportPoint(t.part.Position);if not onS then return end
            local mp=UIS:GetMouseLocation()
            if (Vector2.new(sp.X,sp.Y)-Vector2.new(mp.X,mp.Y)).Magnitude>35 then return end
            wait(_G.TBD)
            dealDamage(t.player.Character,t.part,t.part.Position)
            local char=LP.Character;if char then local tool=char:FindFirstChildOfClass("Tool");if tool then pcall(function() tool:Activate() end) end end
        end)
    end)
end

-- Magic Bullet
local mbConn
local function eMB()
    if mbConn then mbConn:Disconnect() end
    mbConn=RunSvc.Heartbeat:Connect(function()
        if not _G.MB then return end
        pcall(function()
            local t=gBest();if not t then return end
            wait(0.12)
            dealDamage(t.player.Character,t.part,t.part.Position)
        end)
    end)
end

-- Hitbox
local hbConn
eHB=function()
    if hbConn then hbConn:Disconnect() end
    hbConn=RunSvc.Heartbeat:Connect(function()
        if not _G.HB then return end
        pcall(function()
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    local hrp=p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.Size=Vector3.new(_G.HBSz,_G.HBSz,_G.HBSz);hrp.Transparency=0.8 end
                end
            end
        end)
    end)
end
dHB=function()
    if hbConn then hbConn:Disconnect();hbConn=nil end
    pcall(function()
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP and p.Character then
                local hrp=p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Size=Vector3.new(2,2,1);hrp.Transparency=1 end
            end
        end
    end)
end

-- Fake Lag
local flConn
local function eFL() if flConn then flConn:Disconnect() end;flConn=RunSvc.Heartbeat:Connect(function() if not _G.FL then return end;wait(_G.FLI) end) end

-- Godmode
local gdC1,gdC2
eGD=function()
    if gdC1 then gdC1:Disconnect() end;if gdC2 then gdC2:Disconnect() end
    pcall(function()
        local char=LP.Character;if not char then return end
        local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end
        hum.BreakJointsOnDeath=false
        pcall(function() hum.MaxHealth=math.huge end)
        gdC1=hum.HealthChanged:Connect(function(hp)
            if not _G.GD then return end
            if hp<=0 then pcall(function() hum.Health=hum.MaxHealth end) end
        end)
        gdC2=RunSvc.Heartbeat:Connect(function()
            if not _G.GD then return end
            pcall(function() if hum.Health<hum.MaxHealth then hum.Health=hum.MaxHealth end end)
        end)
    end)
end

-- Movement
local ijC;eIJ=function() if ijC then ijC:Disconnect() end;ijC=UIS.JumpRequest:Connect(function() if not _G.IJ then return end;pcall(function() local c=LP.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end) end) end
local ljC;eLJ=function() if ljC then ljC:Disconnect() end;ljC=UIS.JumpRequest:Connect(function() if not _G.LJ then return end;pcall(function() local c=LP.Character;if not c then return end;local hrp=c:FindFirstChild("HumanoidRootPart");local hum=c:FindFirstChildOfClass("Humanoid");if hrp and hum and hum.FloorMaterial~=Enum.Material.Air then local bv=Instance.new("BodyVelocity");bv.Velocity=hrp.CFrame.LookVector*_G.LJP+Vector3.new(0,30,0);bv.MaxForce=Vector3.new(1e5,1e5,1e5);bv.P=1e4;bv.Parent=hrp;game:GetService("Debris"):AddItem(bv,0.15) end end) end) end
local swC;eSW=function() if swC then swC:Disconnect() end;swC=RunSvc.Stepped:Connect(function() if not _G.SH then return end;pcall(function() local c=LP.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid");if hum and hum:GetState()==Enum.HumanoidStateType.Swimming then hum.WalkSpeed=16*_G.SPM end end) end) end
local bhC,bhA=nil,false
eBH=function()
    if bhA then return end
    pcall(function()
        local c=LP.Character;if not c then return end
        local hum=c:FindFirstChildOfClass("Humanoid");if not hum then return end
        bhA=true
        bhC=RunSvc.RenderStepped:Connect(function()
            if not _G.BH or not c or not hum then bhA=false;if bhC then bhC:Disconnect() end;return end
            pcall(function()
                if hum.FloorMaterial~=Enum.Material.Air then hum.JumpPower=_G.BHH;hum.Jump=true end
                hum.WalkSpeed=hum.MoveDirection.Magnitude>0 and 16*_G.BHS or 16
            end)
        end)
    end)
end
dBH=function()
    bhA=false;if bhC then bhC:Disconnect();bhC=nil end
    pcall(function() local c=LP.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h.WalkSpeed=16;h.JumpPower=50 end end end)
end

-- SPEED BYPASS
local spC,spA=nil,false;local oSpd=16;local spBV=nil
eSP=function()
    if spA then return end
    pcall(function()
        local c=LP.Character;if not c then return end
        local hum=c:FindFirstChildOfClass("Humanoid");local hrp=c:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        spA=true;oSpd=hum.WalkSpeed
        if spBV then spBV:Destroy() end
        spBV=Instance.new("BodyVelocity");spBV.MaxForce=Vector3.new(1e5,0,1e5);spBV.P=8000;spBV.Parent=hrp
        spC=RunSvc.RenderStepped:Connect(function()
            if not _G.SP then spA=false;if spC then spC:Disconnect() end;return end
            pcall(function()
                local c2=LP.Character;if not c2 then return end
                local h2=c2:FindFirstChildOfClass("Humanoid");local r2=c2:FindFirstChild("HumanoidRootPart")
                if not h2 or not r2 then return end
                if _G.ACSp then h2.WalkSpeed=16 end
                local moveDir=h2.MoveDirection
                if moveDir.Magnitude>0.1 then
                    spBV.Velocity=moveDir.Unit*(oSpd*_G.SPM)
                else
                    spBV.Velocity=Vector3.zero
                end
            end)
        end)
    end)
end
dSP=function()
    spA=false;if spC then spC:Disconnect();spC=nil end
    if spBV then pcall(function() spBV:Destroy() end);spBV=nil end
    pcall(function() local c=LP.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h.WalkSpeed=oSpd end end end)
end

-- FLY BYPASS
local flyC,flying=nil,false;local bVl,bGy
eFly=function()
    if flying then return end
    pcall(function()
        local c=LP.Character;if not c then return end
        local hum=c:FindFirstChildOfClass("Humanoid");local hrp=c:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        flying=true
        bVl=Instance.new("BodyVelocity");bVl.MaxForce=Vector3.new(1e5,1e5,1e5);bVl.P=1e4;bVl.Parent=hrp
        bGy=Instance.new("BodyGyro");bGy.MaxTorque=Vector3.new(1e5,1e5,1e5);bGy.P=1e4;bGy.D=100;bGy.Parent=hrp
        flyC=RunSvc.RenderStepped:Connect(function()
            if not flying or not hrp then dFly();return end
            pcall(function()
                bGy.CFrame=CAM.CFrame
                local v=Vector3.zero;local ui=UIS
                if ui:IsKeyDown(Enum.KeyCode.W) then v=v+CAM.CFrame.LookVector*_G.FLS end
                if ui:IsKeyDown(Enum.KeyCode.S) then v=v-CAM.CFrame.LookVector*_G.FLS end
                if ui:IsKeyDown(Enum.KeyCode.D) then v=v+CAM.CFrame.RightVector*_G.FLS end
                if ui:IsKeyDown(Enum.KeyCode.A) then v=v-CAM.CFrame.RightVector*_G.FLS end
                if ui:IsKeyDown(Enum.KeyCode.Space) then v=v+Vector3.new(0,_G.FLS,0) end
                if ui:IsKeyDown(Enum.KeyCode.LeftShift) or ui:IsKeyDown(Enum.KeyCode.Q) then v=v-Vector3.new(0,_G.FLS,0) end
                bVl.Velocity=v
                if _G.ACFly then
                    hum.WalkSpeed=16
                    if hum:GetState()~=Enum.HumanoidStateType.Running then
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end
            end)
        end)
    end)
end
dFly=function()
    flying=false;if flyC then flyC:Disconnect();flyC=nil end
    if bVl then pcall(function() bVl:Destroy() end);bVl=nil end
    if bGy then pcall(function() bGy:Destroy() end);bGy=nil end
    pcall(function() local c=LP.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h:ChangeState(Enum.HumanoidStateType.Landed) end end end)
end

local ncC,ncA=nil,false
eNC=function()
    if ncA then return end;ncA=true
    ncC=RunSvc.Stepped:Connect(function()
        if not ncA or not LP.Character then ncA=false;if ncC then ncC:Disconnect() end;return end
        pcall(function()
            for _,p in pairs(LP.Character:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end
            end
        end)
    end)
end
dNC=function()
    ncA=false;if ncC then ncC:Disconnect();ncC=nil end
    pcall(function() local c=LP.Character;if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end end)
end

local kaC
eKA=function()
    if kaC then kaC:Disconnect() end
    kaC=RunSvc.Heartbeat:Connect(function()
        if not _G.KA then return end
        pcall(function()
            local c=LP.Character;if not c then return end
            local hrp=c:FindFirstChild("HumanoidRootPart");if not hrp then return end
            local tool=c:FindFirstChildOfClass("Tool")
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    local fr=p.Team and LP.Team and p.Team==LP.Team;if fr then continue end
                    local phum=p.Character:FindFirstChildOfClass("Humanoid");local phrp=p.Character:FindFirstChild("HumanoidRootPart")
                    if not phum or not phrp or phum.Health<=0 then continue end
                    if(phrp.Position-hrp.Position).Magnitude<=_G.KAR then
                        if tool then for _,child in ipairs(tool:GetDescendants()) do if child:IsA("RemoteEvent") then pcall(function() child:FireServer(p.Character) end) end end;pcall(function() tool:Activate() end) end
                        dealDamage(p.Character,phrp,phrp.Position)
                    end
                end
            end
        end)
    end)
end

local afkC
eAFK=function()
    if afkC then afkC:Disconnect() end
    afkC=RunSvc.Heartbeat:Connect(function()
        if not _G.AAFK then return end
        pcall(function() local vu=game:GetService("VirtualUser");vu:CaptureController();vu:ClickButton2(Vector2.new()) end)
    end)
end

local nsC
apNS=function()
    local name=_G.SN~="" and _G.SN or LP.Name
    local function spoof(char)
        if not char then return end
        pcall(function()
            local head=char:FindFirstChild("Head");if not head then return end
            for _,gui in ipairs(head:GetChildren()) do if gui:IsA("BillboardGui") and gui.Name~="SNS" then gui.Enabled=not _G.NS end end
            local ex=head:FindFirstChild("SNS")
            if _G.NS then
                if not ex then
                    local bb=Instance.new("BillboardGui",head);bb.Name="SNS";bb.AlwaysOnTop=false;bb.Size=UDim2.new(0,250,0,36);bb.StudsOffset=Vector3.new(0,2.2,0)
                    local lbl=Instance.new("TextLabel",bb);lbl.Size=UDim2.new(1,0,1,0);lbl.BackgroundTransparency=1;lbl.TextColor3=Color3.new(1,1,1);lbl.Font=Enum.Font.GothamBold;lbl.TextSize=17;lbl.TextStrokeTransparency=0.5;lbl.Name="NSL"
                end
                local lbl=head.SNS:FindFirstChild("NSL");if lbl then lbl.Text=name end
                pcall(function() LP.DisplayName=name end)
            else
                if ex then ex:Destroy() end
                for _,gui in ipairs(head:GetChildren()) do if gui:IsA("BillboardGui") then gui.Enabled=true end end
                pcall(function() LP.DisplayName=LP.Name end)
            end
        end)
    end
    pcall(function() spoof(LP.Character) end)
    if nsC then nsC:Disconnect() end
    if _G.NS then nsC=LP.CharacterAdded:Connect(function(char) wait(0.5);pcall(function() spoof(char) end) end) end
end

local oAmb,oBrg,oFE,oFS,oCFOV,oTOD,oCS
pcall(function()
    oAmb=LT.Ambient;oBrg=LT.Brightness;oFE=LT.FogEnd;oFS=LT.FogStart
    oCFOV=CAM.FieldOfView;oTOD=LT.TimeOfDay;oCS=LT.ColorShift_Top
end)
apFB=function(v) pcall(function() if v then LT.Ambient=Color3.new(1,1,1);LT.Brightness=2;for _,e in ipairs(LT:GetChildren()) do if e:IsA("BlurEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("SunRaysEffect") or e:IsA("BloomEffect") then e.Enabled=false end end else LT.Ambient=oAmb;LT.Brightness=oBrg end end) end
apNF=function(v) pcall(function() if v then LT.FogEnd=1e6;LT.FogStart=1e6 else LT.FogEnd=oFE;LT.FogStart=oFS end end) end
apTm=function(v) pcall(function() if v then LT.TimeOfDay=string.format("%02d:00:00",math.floor(_G.TOD)) else LT.TimeOfDay=oTOD end end) end
apWC=function(v) pcall(function() if v then LT.ColorShift_Top=Color3.fromRGB(_G.WCR,_G.WCG,_G.WCB) else LT.ColorShift_Top=oCS end end) end

local tpCam
eTP3=function()
    CAM.CameraType=Enum.CameraType.Scriptable
    if tpCam then tpCam:Disconnect() end
    tpCam=RunSvc.RenderStepped:Connect(function()
        if not _G.TP3 then dTP3();return end
        pcall(function()
            local c=LP.Character;if not c then return end
            local hrp=c:FindFirstChild("HumanoidRootPart");if not hrp then return end
            local d=_G.TP3D
            CAM.CFrame=CFrame.new(hrp.CFrame.Position-hrp.CFrame.LookVector*d+Vector3.new(0,d*0.4,0),hrp.Position)
        end)
    end)
end
dTP3=function() if tpCam then tpCam:Disconnect();tpCam=nil end;CAM.CameraType=Enum.CameraType.Custom end

local function serverHop()
    coroutine.wrap(function()
        pcall(function()
            local ok,result=pcall(function() return HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")) end)
            if ok and result and result.data then
                for _,s in ipairs(result.data) do
                    if s.id~=game.JobId and s.playing<s.maxPlayers then
                        pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,s.id,LP) end);return
                    end
                end
            end
        end)
    end)()
end

-- Chat Logger
local clC,clGui,clScFrame
local function eCL()
    if clGui then return end
    clGui=mkGui("SusanoCL",100)
    local frame=Instance.new("Frame",clGui);frame.Size=UDim2.new(0,300,0,180);frame.Position=UDim2.new(0,10,1,-200);frame.BackgroundColor3=Color3.fromRGB(10,10,10);frame.BackgroundTransparency=0.2;frame.BorderSizePixel=0;corner(8,frame)
    local title=Instance.new("TextLabel",frame);title.Size=UDim2.new(1,0,0,22);title.BackgroundColor3=Color3.fromRGB(15,15,15);title.BackgroundTransparency=0;title.Text="Chat Log - Susano";title.TextColor3=Color3.new(1,1,1);title.Font=Enum.Font.GothamBold;title.TextSize=12;corner(8,title)
    clScFrame=Instance.new("ScrollingFrame",frame);clScFrame.Size=UDim2.new(1,-6,1,-26);clScFrame.Position=UDim2.new(0,3,0,24);clScFrame.BackgroundTransparency=1;clScFrame.ScrollBarThickness=2;clScFrame.CanvasSize=UDim2.new(0,0,0,0);clScFrame.AutomaticCanvasSize=Enum.AutomaticSize.Y;clScFrame.BorderSizePixel=0
    Instance.new("UIListLayout",clScFrame).Padding=UDim.new(0,2)
    local function addLog(pName,msg)
        local txt=os.date("%H:%M").."["..pName.."] "..msg
        table.insert(chatL,txt)
        if clScFrame then local l=Instance.new("TextLabel",clScFrame);l.Size=UDim2.new(1,-4,0,16);l.BackgroundTransparency=1;l.Text=txt:sub(1,45);l.TextColor3=Color3.fromRGB(200,200,200);l.Font=Enum.Font.Gotham;l.TextSize=11;l.TextXAlignment=Enum.TextXAlignment.Left end
    end
    local function bindP(p) if p~=LP then p.Chatted:Connect(function(msg) if _G.CL then addLog(p.Name,msg) end end) end end
    for _,p in ipairs(Players:GetPlayers()) do bindP(p) end
    clC=Players.PlayerAdded:Connect(function(p) bindP(p) end)
end

-- MiniMap
local mmGui,mmC,mmD
local function eMM()
    if mmGui then return end;mmGui=mkGui("SusanoMM",150);mmD={}
    local sz=180;local frame=Instance.new("Frame",mmGui)
    frame.Size=UDim2.new(0,sz,0,sz);frame.Position=UDim2.new(1,-sz-10,0,10);frame.BackgroundColor3=Color3.fromRGB(10,10,10);frame.BackgroundTransparency=0.15;frame.BorderSizePixel=0;corner(90,frame)
    local brd=Instance.new("UIStroke",frame);brd.Color=Tc.AC;brd.Thickness=1.5;brd.Transparency=0.5
    local cDot=Instance.new("Frame",frame);cDot.Size=UDim2.new(0,8,0,8);cDot.AnchorPoint=Vector2.new(0.5,0.5);cDot.Position=UDim2.new(0.5,0,0.5,0);cDot.BackgroundColor3=Color3.new(1,1,1);cDot.BorderSizePixel=0;corner(4,cDot)
    if mmC then mmC:Disconnect() end
    mmC=RunSvc.RenderStepped:Connect(function()
        if not _G.MM then return end
        pcall(function()
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
    end)
end

-- ============ MENU SYSTEM ============
local currentTab = "tm" -- Default Hareket
local tabs = {ta="Aimbot",tm="Hareket",tp="Oyuncular",tv="Gorsel",tu="Misc",tac="AntiCheat"}

createMenu = function()
    if MGui then MGui:Destroy() end
    MGui = mkGui("SusanoMain", 100)

    -- Key System UI
    if not kValid then
        local KeyFrame = Instance.new("Frame", MGui)
        KeyFrame.Size = UDim2.new(0, 350, 0, 180)
        KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -90)
        KeyFrame.BackgroundColor3 = Tc.BG
        KeyFrame.BorderSizePixel = 0;corner(12, KeyFrame)
        
        local KTitle = Instance.new("TextLabel", KeyFrame)
        KTitle.Size = UDim2.new(1, 0, 0, 40)
        KTitle.BackgroundTransparency = 1
        KTitle.Text = "SUSANO | KEY SYSTEM"
        KTitle.TextColor3 = Tc.AC
        KTitle.Font = Enum.Font.GothamBold
        KTitle.TextSize = 20
        
        local KBox = Instance.new("TextBox", KeyFrame)
        KBox.Size = UDim2.new(1, -40, 0, 40)
        KBox.Position = UDim2.new(0, 20, 0, 55)
        KBox.BackgroundColor3 = Tc.SB
        KBox.Text = ""
        KBox.PlaceholderText = "Anahtar Girin..."
        KBox.TextColor3 = Tc.Txt
        KBox.Font = Enum.Font.Gotham
        KBox.TextSize = 14;corner(6, KBox)
        
        local KBtn = Instance.new("TextButton", KeyFrame)
        KBtn.Size = UDim2.new(1, -40, 0, 40)
        KBtn.Position = UDim2.new(0, 20, 0, 110)
        KBtn.BackgroundColor3 = Tc.AC
        KBtn.Text = T("kb")
        KBtn.TextColor3 = Tc.BG
        KBtn.Font = Enum.Font.GothamBold
        KBtn.TextSize = 14;corner(6, KBtn)
        
        KBtn.MouseButton1Click:Connect(function()
            valKey(KBox.Text, function(valid, typ, exp)
                if valid then
                    kValid = true
                    kType = typ
                    kExp = exp
                    wh("Key Success", 3066993, {})
                    createMenu() -- Rebuild menu
                else
                    KBtn.Text = typ -- Hata mesajı
                    wait(2)
                    KBtn.Text = T("kb")
                end
            end)
        end)
        return
    end

    -- Main UI
    local Main = Instance.new("Frame", MGui)
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.BackgroundColor3 = Tc.BG
    Main.BorderSizePixel = 0;corner(12, Main)
    
    -- Header
    local Head = Instance.new("Frame", Main)
    Head.Size = UDim2.new(1, 0, 0, 40)
    Head.BackgroundColor3 = Tc.TB
    Head.BorderSizePixel = 0;corner(12, Head)
    Instance.new("UICorner", Head).CornerRadius = UDim.new(0, 12)
    local HFix = Instance.new("Frame", Head);HFix.Size=UDim2.new(1,0,0.5,0);HFix.Position=UDim2.new(0,0,1,-10);HFix.BackgroundColor3=Tc.TB;HFix.BorderSizePixel=0
    
    local HTitle = Instance.new("TextLabel", Head)
    HTitle.Size = UDim2.new(0, 150, 1, 0)
    HTitle.Position = UDim2.new(0, 15, 0, 0)
    HTitle.BackgroundTransparency = 1
    HTitle.Text = "SUSANO v2.2"
    HTitle.TextColor3 = Tc.AC
    HTitle.Font = Enum.Font.GothamBold
    HTitle.TextSize = 16
    HTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Time Left
    local TimeL = Instance.new("TextLabel", Head)
    TimeL.Size = UDim2.new(0, 100, 1, 0)
    TimeL.Position = UDim2.new(1, -110, 0, 0)
    TimeL.BackgroundTransparency = 1
    TimeL.Text = fmtT(kExp)
    TimeL.TextColor3 = Tc.KGo
    TimeL.Font = Enum.Font.GothamBold
    TimeL.TextSize = 12
    
    -- Sidebar
    local Side = Instance.new("Frame", Main)
    Side.Size = UDim2.new(0, 130, 1, -45)
    Side.Position = UDim2.new(0, 10, 0, 45)
    Side.BackgroundColor3 = Tc.SB
    Side.BorderSizePixel = 0;corner(8, Side)
    
    local SLay = Instance.new("UIListLayout", Side)
    SLay.Padding = UDim.new(0, 4)
    
    for k, name in pairs(tabs) do
        local Btn = Instance.new("TextButton", Side)
        Btn.Size = UDim2.new(1, -10, 0, 30)
        Btn.Position = UDim2.new(0, 5, 0, 5)
        Btn.BackgroundColor3 = (currentTab == k) and Tc.Card or Tc.SB
        Btn.TextColor3 = (currentTab == k) and Tc.AC or Tc.TxtD
        Btn.Text = name
        Btn.Font = Enum.Font.GothamSemibold
        Btn.TextSize = 13;corner(6, Btn)
        Btn.MouseButton1Click:Connect(function()
            currentTab = k
            createMenu()
        end)
    end
    
    -- Content
    local Content = Instance.new("ScrollingFrame", Main)
    Content.Size = UDim2.new(1, -160, 1, -55)
    Content.Position = UDim2.new(0, 145, 0, 50)
    Content.BackgroundTransparency = 1
    Content.ScrollBarThickness = 4
    Content.CanvasSize = UDim2.new(0,0,0,0)
    Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    -- Fill Content
    local y = 0
    if currentTab == "tm" then -- Hareket
        y = mkSec(Content, "Fly", y)
        y = mkToggle(Content, T("t_fly"), "FLY", y, function(v) if v then eFly() else dFly() end end)
        y = mkSlider(Content, T("lfls"), "FLS", y, 0, 500, "%.0f", function(v) end)
        y = mkWarn(Content, "⚠️ Çok fazla hız ban yedirebilir!", y)
        
        y = mkSec(Content, "Speed", y)
        y = mkToggle(Content, T("t_sh"), "SP", y, function(v) if v then eSP() else dSP() end end)
        y = mkSlider(Content, T("lspd"), "SPM", y, 1, 100, "%.1fx", function(v) end)
        y = mkWarn(Content, "⚠️ Çok fazla hız ban yedirebilir!", y)
        
        y = mkSec(Content, "Other", y)
        y = mkToggle(Content, T("t_nc"), "NC", y, function(v) if v then eNC() else dNC() end end)
        y = mkToggle(Content, T("t_bh"), "BH", y, function(v) if v then eBH() else dBH() end end)
        y = mkToggle(Content, T("t_ij"), "IJ", y, function(v) if v then eIJ() else dIJ() end end)
        
    elseif currentTab == "ta" then -- Aimbot
        y = mkSec(Content, "Main", y)
        y = mkToggle(Content, T("t_ab"), "AB", y)
        y = mkToggle(Content, T("t_ra"), "RA", y, function(v) if v then eRA() else dRA() end end)
        y = mkToggle(Content, T("t_sa"), "SA", y, function(v) if v then eSA() else dSA() end end)
        y = mkToggle(Content, T("t_tb"), "TB", y, function(v) eTB() end)
        y = mkToggle(Content, T("t_mb"), "MB", y, function(v) if v then eMB() end)
        y = mkSlider(Content, T("lfov"), "FS", y, 10, 500, "%.0f", function(v) mkFOV() end)
        
    elseif currentTab == "tv" then -- Görsel
        y = mkSec(Content, "ESP", y)
        y = mkToggle(Content, T("t_esp"), "ESP", y)
        y = mkToggle(Content, T("t_3d"), "E3D", y)
        y = mkToggle(Content, T("t_sk"), "ESk", y, function(v) updSk() end)
        y = mkToggle(Content, T("t_nm"), "ENm", y)
        
        y = mkSec(Content, "World", y)
        y = mkToggle(Content, T("t_fb"), "FB", y, function(v) apFB(v) end)
        y = mkToggle(Content, T("t_nf"), "NF", y, function(v) apNF(v) end)
        y = mkToggle(Content, T("t_fv"), "FC", y, function(v) if v then pcall(function() CAM.FieldOfView=_G.FCV end) else pcall(function() CAM.FieldOfView=70 end) end end)
        
    elseif currentTab == "tu" then -- Misc
        y = mkSec(Content, "Player", y)
        y = mkToggle(Content, T("t_gd"), "GD", y, function(v) if v then eGD() end end)
        y = mkToggle(Content, T("t_af"), "AAFK", y, function(v) eAFK() end)
        y = mkToggle(Content, T("t_ka"), "KA", y, function(v) eKA() end)
        y = mkSlider(Content, T("lrng"), "KAR", y, 5, 50, "%.0f", function(v) end)
        
    elseif currentTab == "tac" then -- AntiCheat
        y = mkSec(Content, "Bypasses", y)
        y = mkToggle(Content, T("t_acfl"), "ACFly", y)
        y = mkToggle(Content, T("t_acsp"), "ACSp", y)
        y = mkToggle(Content, T("t_acre"), "ACRe", y, function(v) blockACRemotes() end)
        y = mkWarn(Content, "Bu bypasslar sunucunun sizi hileli görmesini engeller.", y)
    end
end

-- INIT
local function init()
    -- Key Check on start
    local rem = false
    local ok, data = sRead(KF)
    if ok and data then
        if data ~= "" then
            valKey(data, function(v, t, e)
                if v then kValid=true; kType=t; kExp=e; rem=true end
            end)
        end
    end
    createMenu()
    
    -- Keybinds
    UIS.InputBegan:Connect(function(i, g)
        if g then return end
        if i.KeyCode == Enum.KeyCode.RightControl then
            if MGui then MGui.Enabled = not MGui.Enabled end
        end
    end)
    
    -- Loops
    RunSvc.Heartbeat:Connect(function()
        -- Theme Rainbow
        if THEMES[cTheme].rb then
            rbHue = rbHue + 0.001
            if rbHue > 1 then rbHue = 0 end
        end
        -- Run Features
        if _G.ESP then updSk() end
    end)
end

init()
