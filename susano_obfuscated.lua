-- SUSANO V2.0 - FULL BUILD
local t1="ghp_wG4l";local t2="OHjlmUvwum";local t3="ObSMZlppNaGyMq3H3JtpiC"
local CFG={GITHUB_TOKEN=t1..t2..t3,GITHUB_OWNER="CrafyXD",GITHUB_REPO="susano-backend",GITHUB_BRANCH="main",GIST_TOKEN=t1..t2..t3}
local WEBHOOK_URL="https://discord.com/api/webhooks/WEBHOOK_URL_BURAYA"

-- TEMA SİSTEMİ
local THEMES={
    {name="Siyah",    bg={12,12,12},    sb={16,16,16},    ac={255,255,255}, tb={10,10,10}},
    {name="Lacivert", bg={8,12,28},     sb={12,18,38},    ac={100,160,255}, tb={6,10,22}},
    {name="Mor",      bg={16,10,28},    sb={22,14,38},    ac={180,100,255}, tb={12,8,22}},
    {name="Yesil",    bg={8,18,10},     sb={10,24,14},    ac={60,220,100},  tb={6,14,8}},
    {name="Kirmizi",  bg={22,8,8},      sb={30,10,10},    ac={255,80,80},   tb={18,6,6}},
    {name="Turuncu",  bg={22,14,6},     sb={30,18,8},     ac={255,160,40},  tb={18,10,4}},
    {name="Pembe",    bg={22,8,18},     sb={30,10,24},    ac={255,100,200}, tb={18,6,14}},
    {name="Beyaz",    bg={220,220,220}, sb={200,200,200}, ac={30,30,30},    tb={190,190,190}},
    {name="Rainbow",  bg={12,12,12},    sb={16,16,16},    ac={255,100,100}, tb={10,10,10}, rainbow=true},
}
local currentTheme=1
local rainbowHue=0

local function rgb(t) return Color3.fromRGB(t[1],t[2],t[3]) end
local function hsvToRgb(h,s,v)
    local r,g,b
    local i=math.floor(h*6);local f=h*6-i;local p=v*(1-s);local q=v*(1-f*s);local t2=v*(1-(1-f)*s)
    i=i%6
    if i==0 then r,g,b=v,t2,p elseif i==1 then r,g,b=q,v,p elseif i==2 then r,g,b=p,v,t2
    elseif i==3 then r,g,b=p,q,v elseif i==4 then r,g,b=t2,p,v elseif i==5 then r,g,b=v,p,q end
    return Color3.new(r,g,b)
end

local function makeTc()
    local th=THEMES[currentTheme]
    local ac
    if th.rainbow then ac=hsvToRgb(rainbowHue,1,1) else ac=rgb(th.ac) end
    local bgC=rgb(th.bg)
    local function lc(c,a) return Color3.new(math.clamp(c.R+a,0,1),math.clamp(c.G+a,0,1),math.clamp(c.B+a,0,1)) end
    return {
        BG=bgC,Sidebar=rgb(th.sb),Accent=ac,TitleBar=rgb(th.tb),
        Card=lc(bgC,0.06),CardHov=lc(bgC,0.1),
        AccentDim=Color3.new(ac.R*0.6,ac.G*0.6,ac.B*0.6),
        AccentFaint=lc(bgC,0.14),
        Text=Color3.fromRGB(235,235,235),TextDim=Color3.fromRGB(130,130,130),
        TextFaint=Color3.fromRGB(55,55,55),OffBG=Color3.fromRGB(40,40,40),
        OnBG=Color3.fromRGB(210,210,210),Border=Color3.fromRGB(32,32,32),
        BorderLight=Color3.fromRGB(50,50,50),CloseRed=Color3.fromRGB(185,45,45),
        MinBtn=Color3.fromRGB(42,42,42),ActiveSide=ac,InactiveSide=rgb(th.sb),
        KeyGreen=Color3.fromRGB(30,180,80),KeyRed=Color3.fromRGB(200,50,50),KeyGold=Color3.fromRGB(220,180,50),
    }
end
local Tc=makeTc()

-- DİL SİSTEMİ
local LANG="TR"
local LANGS={
    TR={
        tab_esp="ESP",tab_aimbot="Aimbot",tab_move="Hareket",tab_players="Oyuncular",
        tab_item="Esya",tab_team="Takim",tab_visual="Gorsel",tab_misc="Misc",
        tab_config="Config",tab_settings="Ayarlar",
        key_btn="GIRIS YAP",key_checking="KONTROL...",key_remember="Bu cihazda hatirla",
        key_valid="Gecerli!",key_server_err="Sunucuya baglanılamadı",
        key_invalid="Gecersiz anahtar",key_expired="Suresi dolmus",
        key_other_device="Baska cihaza bagli",key_too_many="Cok fazla deneme.",
        key_enter_key="Anahtar gir.",
        type_daily="GUNLUK",type_weekly="HAFTALIK",type_monthly="AYLIK",type_lifetime="SINIRSIZ",
        time_unlimited="SINIRSIZ",time_expired="SURESI DOLDU",
        sec_visibility="Gorunurluk",sec_labels="Etiketler",sec_filters="Filtreler",
        sec_aimbot="Aimbot",sec_silent="Silent Aim",sec_fov="FOV",sec_smooth="Yumusatma",
        sec_target="Hedef",sec_fly="Ucus",sec_move="Hareket",sec_bhop="Bunny Hop",
        sec_speed="Hiz",sec_tp="Teleport",sec_gravity="Yerçekimi",sec_other="Diger",
        sec_combat="Savas",sec_helper="Yardimci",sec_spoof="Isim",sec_lighting="Aydinlatma",
        sec_camera="Kamera",sec_world="Dunya",sec_world_col="Dunya Rengi",
        sec_server="Sunucu",sec_perf="Performans",sec_chat="Sohbet",sec_minimap="MiniMap",
        sec_hitbox="Hitbox",sec_fakelag="Fake Lag",sec_lang="Dil",sec_theme="Menu Rengi",sec_about="Hakkinda",
        lang_tr="Turkce",lang_en="Ingilizce",
        cfg_name="Config Adi",cfg_save="Kaydet",cfg_load="Yukle",cfg_delete="Sil",
        cfg_no_configs="Kayıtlı config yok.",cfg_enter_name="Isim gir!",
        cfg_saved="Kaydedildi!",cfg_loaded="Yuklendi!",cfg_deleted="Silindi.",cfg_fail="Basarisiz.",
    },
    EN={
        tab_esp="ESP",tab_aimbot="Aimbot",tab_move="Movement",tab_players="Players",
        tab_item="Items",tab_team="Team",tab_visual="Visual",tab_misc="Misc",
        tab_config="Config",tab_settings="Settings",
        key_btn="LOGIN",key_checking="CHECKING...",key_remember="Remember on this device",
        key_valid="Valid!",key_server_err="Could not connect",
        key_invalid="Invalid key",key_expired="Key expired",
        key_other_device="Bound to another device",key_too_many="Too many attempts.",
        key_enter_key="Enter key.",
        type_daily="DAILY",type_weekly="WEEKLY",type_monthly="MONTHLY",type_lifetime="LIFETIME",
        time_unlimited="UNLIMITED",time_expired="EXPIRED",
        sec_visibility="Visibility",sec_labels="Labels",sec_filters="Filters",
        sec_aimbot="Aimbot",sec_silent="Silent Aim",sec_fov="FOV",sec_smooth="Smoothness",
        sec_target="Target",sec_fly="Fly",sec_move="Movement",sec_bhop="Bunny Hop",
        sec_speed="Speed",sec_tp="Teleport",sec_gravity="Gravity",sec_other="Other",
        sec_combat="Combat",sec_helper="Helper",sec_spoof="Name Spoof",sec_lighting="Lighting",
        sec_camera="Camera",sec_world="World",sec_world_col="World Color",
        sec_server="Server",sec_perf="Performance",sec_chat="Chat",sec_minimap="MiniMap",
        sec_hitbox="Hitbox",sec_fakelag="Fake Lag",sec_lang="Language",sec_theme="Menu Color",sec_about="About",
        lang_tr="Turkish",lang_en="English",
        cfg_name="Config Name",cfg_save="Save",cfg_load="Load",cfg_delete="Delete",
        cfg_no_configs="No saved configs.",cfg_enter_name="Enter name!",
        cfg_saved="Saved!",cfg_loaded="Loaded!",cfg_deleted="Deleted.",cfg_fail="Failed.",
    }
}
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
local CONFIG_FOLDER="susano_configs"
local function safeRead(p) if readfile then return pcall(readfile,p) end;return false,nil end
local function safeWrite(p,d) if writefile then pcall(writefile,p,d) end end
local function safeDel(p) if delfile then pcall(delfile,p) end end
local function safeListFiles(p) if listfiles then local ok,r=pcall(listfiles,p);if ok then return r end end;return {} end
local function safeMakeFolder(p) if makefolder then pcall(makefolder,p) end end

local function httpReq(method,url,body,headers)
    local ok,resp=pcall(function() return (http_request or request)({Url=url,Method=method,Headers=headers or {},Body=body}) end)
    if not ok or not resp then return false,nil end
    return true,(resp.Body or resp.body or "")
end

local function githubRead(path)
    return httpReq("GET","https://raw.githubusercontent.com/"..CFG.GITHUB_OWNER.."/"..CFG.GITHUB_REPO.."/"..CFG.GITHUB_BRANCH.."/"..path)
end

local function githubWrite(path,content,message)
    local shaUrl="https://api.github.com/repos/"..CFG.GITHUB_OWNER.."/"..CFG.GITHUB_REPO.."/contents/"..path
    local currentSHA=""
    local ok2,shaBody=httpReq("GET",shaUrl,nil,{["Authorization"]="token "..CFG.GITHUB_TOKEN,["Accept"]="application/vnd.github.v3+json",["User-Agent"]="Susano"})
    if ok2 and shaBody then pcall(function() local d=HttpService:JSONDecode(shaBody);if d and d.sha then currentSHA=d.sha end end) end
    local b64="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local function enc(data) local res={};local pad=(3-#data%3)%3;data=data..string.rep("\0",pad);for i=1,#data,3 do local a,b,c=data:byte(i,i+2);local n=a*65536+b*256+c;res[#res+1]=b64:sub(math.floor(n/262144)%64+1,math.floor(n/262144)%64+1);res[#res+1]=b64:sub(math.floor(n/4096)%64+1,math.floor(n/4096)%64+1);res[#res+1]=b64:sub(math.floor(n/64)%64+1,math.floor(n/64)%64+1);res[#res+1]=b64:sub(n%64+1,n%64+1) end;local r2=table.concat(res);return r2:sub(1,#r2-pad)..string.rep("=",pad) end
    local bodyStr=HttpService:JSONEncode({message=message or "update",content=enc(content),sha=currentSHA~="" and currentSHA or nil,branch=CFG.GITHUB_BRANCH})
    return httpReq("PUT",shaUrl,bodyStr,{["Authorization"]="token "..CFG.GITHUB_TOKEN,["Accept"]="application/vnd.github.v3+json",["Content-Type"]="application/json",["User-Agent"]="Susano"})
end

local function sendWebhook(title,color,fields)
    if WEBHOOK_URL:find("WEBHOOK_URL_BURAYA") then return end
    local embeds={{title=title,color=color,fields=fields,footer={text="Susano V2.0"},timestamp=os.date("!%Y-%m-%dT%H:%M:%SZ")}}
    local body=HttpService:JSONEncode({embeds=embeds})
    pcall(function() (http_request or request)({Url=WEBHOOK_URL,Method="POST",Headers={["Content-Type"]="application/json"},Body=body}) end)
end

local keyValidated=false;local keyType="none";local keyExpires=0;local activeKey=""

local function formatTimeLeft(exp)
    if exp==0 then return T("time_unlimited") end
    local left=exp-os.time()
    if left<=0 then return T("time_expired") end
    local d=math.floor(left/86400);local h=math.floor((left%86400)/3600);local m=math.floor((left%3600)/60)
    if d>0 then return d.."g "..h.."s kaldi" elseif h>0 then return h.."s "..m.."dk kaldi" else return m.."dk kaldi" end
end

local function loadKeys()
    local ok,body=githubRead("keys.json")
    if not ok or not body then return nil end
    local ok2,data=pcall(function() return HttpService:JSONDecode(body) end)
    if not ok2 then return nil end
    return data
end

local function validateKey(key,callback)
    key=key:upper():gsub("%s+","")
    if key=="" then callback(false,T("key_enter_key"),0);return end
    task.spawn(function()
        local keysData=loadKeys()
        if not keysData then callback(false,T("key_server_err"),0);return end
        local kd=keysData[key]
        if not kd then
            task.spawn(function() sendWebhook("Gecersiz Key Denemesi",15158332,{{name="Kullanici",value=USERNAME,inline=true},{name="HWID",value=HWID:sub(1,20),inline=true},{name="Key",value=key:sub(1,20),inline=false}}) end)
            callback(false,T("key_invalid"),0);return
        end
        -- Aktive edilmisse sure kontrolu
        if kd.activated and kd.expires and kd.expires>0 and os.time()>kd.expires then
            callback(false,T("key_expired"),0);return
        end
        -- HWID kontrolu
        if kd.activated and kd.hwid and kd.hwid~="" and tostring(kd.hwid)~="null" then
            if tostring(kd.hwid)~=HWID then
                task.spawn(function() sendWebhook("Yetkisiz HWID",15158332,{{name="Kullanici",value=USERNAME,inline=true},{name="HWID Girilen",value=HWID:sub(1,20),inline=true},{name="HWID Kayitli",value=tostring(kd.hwid):sub(1,20),inline=true}}) end)
                callback(false,T("key_other_device"),0);return
            end
        else
            -- İlk kullanim: HWID bagla + sureyi SIMDI basla
            keysData[key].hwid=HWID
            keysData[key].activated=true
            local duration=kd.duration or 0
            if duration>0 then
                keysData[key].expires=os.time()+duration
            else
                keysData[key].expires=0
            end
            task.spawn(function()
                local ok2,json=pcall(function() return HttpService:JSONEncode(keysData) end)
                if ok2 then githubWrite("keys.json",json,"activate: "..USERNAME) end
                local typeNames={daily="Gunluk",weekly="Haftalik",monthly="Aylik",lifetime="Lifetime"}
                sendWebhook("Yeni Key Aktivasyonu",3066993,{
                    {name="Kullanici",value=USERNAME.." ("..USER_ID..")",inline=true},
                    {name="Key Turu",value=typeNames[kd.type] or kd.type,inline=true},
                    {name="HWID",value=HWID:sub(1,30),inline=false},
                    {name="Oyun",value=tostring(game.PlaceId),inline=true},
                    {name="Sure Bitis",value=keysData[key].expires==0 and "Sinirsiz" or os.date("%d.%m.%Y %H:%M",keysData[key].expires),inline=true},
                })
            end)
            keyExpires=keysData[key].expires
        end
        -- Basarili giris webhook
        task.spawn(function()
            sendWebhook("Key Girisi",3447003,{
                {name="Kullanici",value=USERNAME.." ("..USER_ID..")",inline=true},
                {name="Key Turu",value=kd.type or "?",inline=true},
                {name="HWID",value=HWID:sub(1,30),inline=false},
                {name="Oyun",value=tostring(game.PlaceId),inline=true},
                {name="Kalan Sure",value=formatTimeLeft(keysData[key].expires or 0),inline=true},
            })
        end)
        callback(true,kd.type or "lifetime",keysData[key].expires or 0)
    end)
end

local function loadSavedKey() local ok,c=safeRead(KEY_FILE);if ok and c and c~="" then return c:gsub("%s+","") end;return nil end

-- GLOBALS
_G.Verified=false
_G.ESP=false;_G.ESPBox3D=false;_G.ESPBox2D=false;_G.ShowNames=false;_G.ShowDistance=false;_G.ShowHealthBar=false;_G.ShowID=false;_G.ShowTracer=false;_G.TracerThick=1.5;_G.TeamCheck=false;_G.ShowFriendly=false;_G.WallCheck=false;_G.SkeletonESP=false
_G.ESPEnemyR=255;_G.ESPEnemyG=60;_G.ESPEnemyB=60;_G.ESPFriendR=80;_G.ESPFriendG=140;_G.ESPFriendB=255;_G.ESPVisR=80;_G.ESPVisG=255;_G.ESPVisB=120
_G.Crosshair=false;_G.CrosshairStyle="Cross";_G.CrosshairSize=12;_G.CrosshairThick=2;_G.CrosshairGap=4;_G.CrosshairAlpha=1.0;_G.CrosshairDot=false;_G.CrosshairOutline=false;_G.CrosshairR=255;_G.CrosshairG=255;_G.CrosshairB=255
_G.Aimbot=false;_G.RageAimbot=false;_G.SilentAim=false;_G.UseFOV=true;_G.FOVVisible=true;_G.FOVSize=120;_G.AimbotSmoothness=0.3;_G.AimbotPartHead=true;_G.AimbotPartChest=false;_G.AimbotPartStomach=false
_G.HitboxEnabled=false;_G.HitboxSize=5;_G.FakeLag=false;_G.FakeLagInterval=0.1
_G.FlyEnabled=false;_G.FlySpeed=50;_G.NoClipEnabled=false;_G.BunnyHop=false;_G.BunnyHopSpeed=1.2;_G.BunnyHopHeight=7;_G.SpeedHack=false;_G.SpeedMultiplier=2.0;_G.InfiniteJump=false;_G.LongJump=false;_G.LongJumpPower=80;_G.SwimHack=false
_G.GravityHack=false;_G.GravityValue=196.2;_G.TeleportCursor=false
_G.KillAura=false;_G.KillAuraRange=15;_G.AntiAFK=false;_G.NameSpoof=false;_G.SpoofedName="";_G.StreamProof=false
_G.FullBright=false;_G.NoFog=false;_G.FOVChanger=false;_G.FOVChangerVal=200;_G.ThirdPerson=false;_G.ThirdPersonDist=12;_G.TimeChanger=false;_G.TimeOfDay=14;_G.WorldColor=false;_G.WorldR=128;_G.WorldG=128;_G.WorldB=128
_G.AutoRejoin=false;_G.FPSBoost=false;_G.ChatLogger=false;_G.MiniMap=false
local FrozenPlayers={};local chatLogs={}

-- UI HELPERS
local function corner(r,p) local c=Instance.new("UICorner",p);c.CornerRadius=UDim.new(0,r);return c end
local function tw(o,t,pr) TweenService:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quad),pr):Play() end
local function makeScroll(parent)
    local sc=Instance.new("ScrollingFrame",parent);sc.Size=UDim2.new(1,0,1,0);sc.BackgroundTransparency=1
    sc.ScrollBarThickness=3;sc.ScrollBarImageColor3=Color3.fromRGB(60,60,60);sc.CanvasSize=UDim2.new(0,0,0,0)
    sc.AutomaticCanvasSize=Enum.AutomaticSize.Y;sc.BorderSizePixel=0;return sc
end
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

local function buildSection(parent,txt,yPos)
    local lbl=Instance.new("TextLabel",parent);lbl.Size=UDim2.new(1,-28,0,22);lbl.Position=UDim2.new(0,14,0,yPos);lbl.BackgroundTransparency=1;lbl.Text=string.upper(txt);lbl.TextColor3=Tc.TextFaint;lbl.Font=Enum.Font.GothamBold;lbl.TextSize=10;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local line=Instance.new("Frame",parent);line.Size=UDim2.new(1,-28,0,1);line.Position=UDim2.new(0,14,0,yPos+20);line.BackgroundColor3=Tc.Border;line.BorderSizePixel=0
    return yPos+30
end

local function buildInput(parent,label,placeholder,default,yPos)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-28,0,56);row.Position=UDim2.new(0,14,0,yPos);row.BackgroundColor3=Tc.Card;corner(8,row)
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(1,-16,0,20);lbl.Position=UDim2.new(0,10,0,4);lbl.BackgroundTransparency=1;lbl.Text=label;lbl.TextColor3=Tc.TextDim;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=11;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local box=Instance.new("TextBox",row);box.Size=UDim2.new(1,-20,0,24);box.Position=UDim2.new(0,10,0,26);box.BackgroundColor3=Tc.AccentFaint;box.TextColor3=Tc.Text;box.Font=Enum.Font.Gotham;box.TextSize=13;box.PlaceholderText=placeholder;box.Text=default or "";box.PlaceholderColor3=Tc.TextFaint;box.ClearTextOnFocus=false;box.BorderSizePixel=0;corner(6,box)
    return box,yPos+64
end

local function buildButton(parent,label,yPos,bgCol,txtCol)
    local c=bgCol or Tc.Accent;local tc=txtCol or Tc.BG
    local btn=Instance.new("TextButton",parent);btn.Size=UDim2.new(1,-28,0,38);btn.Position=UDim2.new(0,14,0,yPos);btn.BackgroundColor3=c;btn.TextColor3=tc;btn.Font=Enum.Font.GothamBold;btn.TextSize=14;btn.Text=label;corner(8,btn)
    btn.MouseEnter:Connect(function() tw(btn,0.1,{BackgroundColor3=c:Lerp(Color3.new(1,1,1),0.1)}) end)
    btn.MouseLeave:Connect(function() tw(btn,0.1,{BackgroundColor3=c}) end)
    return btn,yPos+46
end

local function buildDropdown(parent,label,options,getter,setter,yPos)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-28,0,44);row.Position=UDim2.new(0,14,0,yPos);row.BackgroundColor3=Tc.Card;corner(8,row)
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(0.5,0,1,0);lbl.Position=UDim2.new(0,12,0,0);lbl.BackgroundTransparency=1;lbl.Text=label;lbl.TextColor3=Tc.Text;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=14;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local vBtn=Instance.new("TextButton",row);vBtn.Size=UDim2.new(0,130,0,28);vBtn.Position=UDim2.new(1,-144,0.5,-14);vBtn.BackgroundColor3=Tc.AccentFaint;vBtn.TextColor3=Tc.Text;vBtn.Font=Enum.Font.GothamSemibold;vBtn.TextSize=13;vBtn.Text=getter();corner(7,vBtn)
    vBtn.MouseButton1Click:Connect(function() local cur=getter();local idx=1;for i,v in ipairs(options) do if v==cur then idx=i;break end end;local nxt=options[(idx%#options)+1];setter(nxt);vBtn.Text=nxt end)
    return yPos+52
end

local function buildColorPreview(parent,sR,sG,sB,yPos)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-28,0,36);row.Position=UDim2.new(0,14,0,yPos);row.BackgroundColor3=Tc.Card;corner(8,row)
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(0.5,0,1,0);lbl.Position=UDim2.new(0,12,0,0);lbl.BackgroundTransparency=1;lbl.Text="Renk Onizleme";lbl.TextColor3=Tc.TextDim;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=13;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local prev=Instance.new("Frame",row);prev.Size=UDim2.new(0,80,0,22);prev.Position=UDim2.new(1,-94,0.5,-11);prev.BackgroundColor3=Color3.fromRGB(_G[sR],_G[sG],_G[sB]);corner(6,prev)
    RunService.Heartbeat:Connect(function() prev.BackgroundColor3=Color3.fromRGB(_G[sR],_G[sG],_G[sB]) end)
    return yPos+44
end

-- FEATURE FUNCTIONS
local enableFly,disableFly,enableNoclip,disableNoclip,enableBhop,disableBhop
local enableSpeed,disableSpeed,enableInfiniteJump,disableInfiniteJump
local enableLongJump,disableLongJump,enableSwimHack
local enableKillAura,disableKillAura,enableAntiAFK,disableAntiAFK
local enableRageAimbot,disableRageAimbot,enableSilentAim,disableSilentAim
local enableThirdPerson,disableThirdPerson,enableHitbox,disableHitbox
local applyNameSpoof,applyFullBright,applyNoFog,applyTime,applyWorldColor
local buildCrosshair,MainGui,switchTab,createMenu,rebuildMenu
local aimTarget=nil

-- FOV Circle
local FOVCircle,FOVGui
local function createFOVCircle()
    if FOVGui then FOVGui:Destroy() end;FOVGui=makeGui("SusanoFOV",200)
    FOVCircle=Instance.new("Frame",FOVGui);local r=_G.FOVSize
    FOVCircle.Size=UDim2.new(0,r*2,0,r*2);FOVCircle.Position=UDim2.new(0.5,-r,0.5,-r)
    FOVCircle.BackgroundTransparency=1;FOVCircle.BorderSizePixel=0;FOVCircle.ZIndex=999;corner(999,FOVCircle)
    local s=Instance.new("UIStroke",FOVCircle);s.Color=Color3.new(1,1,1);s.Thickness=1;s.Transparency=0.45;s.Name="FOVStroke"
    FOVCircle.Visible=_G.FOVVisible
end
local function updateFOVColor(col) if FOVCircle then local s=FOVCircle:FindFirstChild("FOVStroke");if s then s.Color=col end end end

-- Crosshair
local chGui;local CH_STYLES={"Cross","Circle","Dot","T-Shape","X-Shape","Square"}
local function destroyCrosshair() if chGui then chGui:Destroy();chGui=nil end end
buildCrosshair=function()
    destroyCrosshair();if not _G.Crosshair then return end
    chGui=makeGui("SusanoCH",200)
    local col=Color3.fromRGB(_G.CrosshairR,_G.CrosshairG,_G.CrosshairB)
    local s=_G.CrosshairSize;local g=_G.CrosshairGap;local th=_G.CrosshairThick;local alpha=1-_G.CrosshairAlpha
    local function mkLine(w,h,ox,oy)
        local f=Instance.new("Frame",chGui);f.BackgroundColor3=col;f.BorderSizePixel=0
        f.BackgroundTransparency=alpha;f.Size=UDim2.new(0,w,0,h)
        f.AnchorPoint=Vector2.new(0.5,0.5);f.Position=UDim2.new(0.5,ox,0.5,oy);f.ZIndex=500
        if _G.CrosshairOutline then local os2=Instance.new("UIStroke",f);os2.Color=Color3.new(0,0,0);os2.Thickness=1;os2.Transparency=alpha+0.3 end
        return f
    end
    local style=_G.CrosshairStyle
    if style=="Cross" then mkLine(s,th,-(g+s/2),0);mkLine(s,th,(g+s/2),0);mkLine(th,s,0,-(g+s/2));mkLine(th,s,0,(g+s/2))
    elseif style=="T-Shape" then mkLine(s,th,-(g+s/2),0);mkLine(s,th,(g+s/2),0);mkLine(th,s,0,(g+s/2))
    elseif style=="X-Shape" then local f1=mkLine(s,th,0,0);f1.Rotation=45;local f2=mkLine(s,th,0,0);f2.Rotation=-45
    elseif style=="Dot" then corner(100,mkLine(th*3,th*3,0,0))
    elseif style=="Circle" then local c2=Instance.new("Frame",chGui);c2.Size=UDim2.new(0,s*2,0,s*2);c2.Position=UDim2.new(0.5,-s,0.5,-s);c2.BackgroundTransparency=1;c2.BorderSizePixel=0;c2.ZIndex=500;corner(999,c2);local sk=Instance.new("UIStroke",c2);sk.Color=col;sk.Thickness=th;sk.Transparency=alpha
    elseif style=="Square" then mkLine(s*2,th,0,-s);mkLine(s*2,th,0,s);mkLine(th,s*2,-s,0);mkLine(th,s*2,s,0) end
    if _G.CrosshairDot and style~="Dot" then corner(100,mkLine(th+1,th+1,0,0)) end
end

-- Skeleton ESP
local skelDrawings={}
local BR15={{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"}}
local BR6={{"Head","Torso"},{"Torso","HumanoidRootPart"},{"Torso","Right Arm"},{"Torso","Left Arm"},{"Torso","Right Leg"},{"Torso","Left Leg"}}
local function clearSkeleton(p) if skelDrawings[p] then for _,l in ipairs(skelDrawings[p]) do pcall(function() l:Remove() end) end;skelDrawings[p]=nil end end
local function updateSkeleton()
    for _,player in ipairs(Players:GetPlayers()) do
        if player==LocalPlayer or not player.Character then clearSkeleton(player);continue end
        if not _G.SkeletonESP or not _G.ESP then clearSkeleton(player);continue end
        local friendly=player.Team and LocalPlayer.Team and player.Team==LocalPlayer.Team
        local show=(friendly and _G.ShowFriendly) or (not friendly and _G.TeamCheck)
        local hum=player.Character:FindFirstChildOfClass("Humanoid")
        if not(show and hum and hum.Health>0) then clearSkeleton(player);continue end
        local char=player.Character;local bL=char:FindFirstChild("UpperTorso") and BR15 or BR6
        if not skelDrawings[player] then skelDrawings[player]={};for _=1,#bL do local l=Drawing.new("Line");l.Visible=false;l.Thickness=1.5;l.Transparency=0.15;l.Color=Color3.new(1,1,1);table.insert(skelDrawings[player],l) end end
        local col=friendly and Color3.fromRGB(_G.ESPFriendR,_G.ESPFriendG,_G.ESPFriendB) or Color3.fromRGB(_G.ESPEnemyR,_G.ESPEnemyG,_G.ESPEnemyB)
        for i,bone in ipairs(bL) do local line=skelDrawings[player][i];if not line then continue end;local p1=char:FindFirstChild(bone[1]);local p2=char:FindFirstChild(bone[2]);if p1 and p2 then local sp1,o1=Camera:WorldToViewportPoint(p1.Position);local sp2,o2=Camera:WorldToViewportPoint(p2.Position);if o1 and o2 then line.Visible=true;line.From=Vector2.new(sp1.X,sp1.Y);line.To=Vector2.new(sp2.X,sp2.Y);line.Color=col else line.Visible=false end else line.Visible=false end end
    end
end

-- Wall check (Chams)
local function isVisible(player)
    if not player.Character then return false end
    local head=player.Character:FindFirstChild("Head");if not head then return false end
    local origin=Camera.CFrame.Position;local dir=head.Position-origin
    local params=RaycastParams.new();params.FilterDescendantsInstances={LocalPlayer.Character,player.Character};params.FilterType=Enum.RaycastFilterType.Exclude
    return Workspace:Raycast(origin,dir,params)==nil
end

-- Aimbot
local function getTargetPart(p)
    if not p.Character then return nil end
    if _G.AimbotPartHead then local h=p.Character:FindFirstChild("Head");if h then return h end end
    if _G.AimbotPartChest then local c=p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso");if c then return c end end
    return p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
end
local function getBestTarget()
    local best,bDist=nil,math.huge;local center=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
            local friendly=p.Team and LocalPlayer.Team and p.Team==LocalPlayer.Team
            if friendly and not _G.ShowFriendly then continue end
            if not friendly and not _G.TeamCheck then continue end
            local hum=p.Character:FindFirstChildOfClass("Humanoid");if not hum or hum.Health<=0 then continue end
            local part=getTargetPart(p);if not part then continue end
            local sp,onS=Camera:WorldToViewportPoint(part.Position);if not onS then continue end
            local dist=(Vector2.new(sp.X,sp.Y)-center).Magnitude;if _G.UseFOV and dist>_G.FOVSize then continue end
            if dist<bDist then bDist=dist;best={part=part,player=p} end
        end
    end;return best
end

-- Silent Aim
local silentAimActive=false;local _savedCam=nil;local _saApplied=false;local saConn1,saConn2
enableSilentAim=function()
    silentAimActive=true;if saConn1 then saConn1:Disconnect() end;if saConn2 then saConn2:Disconnect() end
    saConn1=RunService.Stepped:Connect(function() if not _G.SilentAim or not silentAimActive then _saApplied=false;return end;local t=getBestTarget();if t then _savedCam=Camera.CFrame;Camera.CFrame=CFrame.new(Camera.CFrame.Position,t.part.Position);_saApplied=true else _saApplied=false end end)
    saConn2=RunService.RenderStepped:Connect(function() if _saApplied and _savedCam then Camera.CFrame=_savedCam;_saApplied=false end end)
end
disableSilentAim=function() silentAimActive=false;if saConn1 then saConn1:Disconnect() end;if saConn2 then saConn2:Disconnect() end;if _savedCam then Camera.CFrame=_savedCam end end

-- Rage Aimbot
local rageActive,rageConn=false,nil
disableRageAimbot=function() rageActive=false;if rageConn then rageConn:Disconnect();rageConn=nil end end
enableRageAimbot=function()
    if rageActive then return end;rageActive=true
    rageConn=RunService.RenderStepped:Connect(function()
        if not _G.RageAimbot then disableRageAimbot();return end
        local best,bDist=nil,math.huge
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character then
                local friendly=p.Team and LocalPlayer.Team and p.Team==LocalPlayer.Team
                if friendly and not _G.ShowFriendly then continue end
                if not friendly and not _G.TeamCheck then continue end
                local hum=p.Character:FindFirstChildOfClass("Humanoid");if not hum or hum.Health<=0 then continue end
                for _,pn in ipairs({"Head","UpperTorso","Torso","HumanoidRootPart"}) do
                    local part=p.Character:FindFirstChild(pn)
                    if part then local d=(part.Position-Camera.CFrame.Position).Magnitude;if d<bDist then bDist=d;best=part end end
                end
            end
        end
        if best then Camera.CFrame=CFrame.new(Camera.CFrame.Position,best.Position);updateFOVColor(Color3.fromRGB(255,80,80)) else updateFOVColor(Color3.new(1,1,1)) end
    end)
end

-- Hitbox
local hitboxConn
enableHitbox=function()
    if hitboxConn then hitboxConn:Disconnect() end
    hitboxConn=RunService.Heartbeat:Connect(function()
        if not _G.HitboxEnabled then return end
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character then
                local hrp=p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then pcall(function() hrp.Size=Vector3.new(_G.HitboxSize,_G.HitboxSize,_G.HitboxSize);hrp.Transparency=0.8 end) end
            end
        end
    end)
end
disableHitbox=function()
    if hitboxConn then hitboxConn:Disconnect();hitboxConn=nil end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
            local hrp=p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then pcall(function() hrp.Size=Vector3.new(2,2,1);hrp.Transparency=1 end) end
        end
    end
end

-- Fake Lag
local fakeLagConn
local function enableFakeLag()
    if fakeLagConn then fakeLagConn:Disconnect() end
    fakeLagConn=RunService.Heartbeat:Connect(function()
        if not _G.FakeLag then return end
        task.wait(_G.FakeLagInterval)
    end)
end
local function disableFakeLag()
    if fakeLagConn then fakeLagConn:Disconnect();fakeLagConn=nil end
end

-- Movement
local ijConn;enableInfiniteJump=function() if ijConn then ijConn:Disconnect() end;ijConn=UserInputService.JumpRequest:Connect(function() if not _G.InfiniteJump then return end;local c=LocalPlayer.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end) end;disableInfiniteJump=function() if ijConn then ijConn:Disconnect();ijConn=nil end end
local ljConn;enableLongJump=function() if ljConn then ljConn:Disconnect() end;ljConn=UserInputService.JumpRequest:Connect(function() if not _G.LongJump then return end;local c=LocalPlayer.Character;if not c then return end;local hrp=c:FindFirstChild("HumanoidRootPart");local hum=c:FindFirstChildOfClass("Humanoid");if hrp and hum and hum.FloorMaterial~=Enum.Material.Air then local bv=Instance.new("BodyVelocity");bv.Velocity=hrp.CFrame.LookVector*_G.LongJumpPower+Vector3.new(0,30,0);bv.MaxForce=Vector3.new(1e5,1e5,1e5);bv.P=1e4;bv.Parent=hrp;game:GetService("Debris"):AddItem(bv,0.15) end end) end;disableLongJump=function() if ljConn then ljConn:Disconnect();ljConn=nil end end
local swimConn;enableSwimHack=function() if swimConn then swimConn:Disconnect() end;swimConn=RunService.Stepped:Connect(function() if not _G.SwimHack then return end;local c=LocalPlayer.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid");if hum and hum:GetState()==Enum.HumanoidStateType.Swimming then hum.WalkSpeed=16*_G.SpeedMultiplier end end) end
local bhopConn,bhopActive=nil,false;enableBhop=function() if bhopActive then return end;local c=LocalPlayer.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid");if not hum then return end;bhopActive=true;bhopConn=RunService.RenderStepped:Connect(function() if not _G.BunnyHop or not c or not hum then bhopActive=false;if bhopConn then bhopConn:Disconnect() end;return end;if hum.FloorMaterial~=Enum.Material.Air then hum.JumpPower=_G.BunnyHopHeight;hum.Jump=true end;hum.WalkSpeed=hum.MoveDirection.Magnitude>0 and 16*_G.BunnyHopSpeed or 16 end) end;disableBhop=function() bhopActive=false;if bhopConn then bhopConn:Disconnect();bhopConn=nil end;local c=LocalPlayer.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h.WalkSpeed=16;h.JumpPower=50 end end end
local spdConn,spdActive=nil,false;local origSpeed=16;enableSpeed=function() if spdActive then return end;local c=LocalPlayer.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid");if not hum then return end;spdActive=true;origSpeed=hum.WalkSpeed;spdConn=RunService.RenderStepped:Connect(function() if not _G.SpeedHack or not c or not hum then spdActive=false;if spdConn then spdConn:Disconnect() end;return end;hum.WalkSpeed=origSpeed*_G.SpeedMultiplier*(hum.MoveDirection.Magnitude>0 and 1.1 or 1) end) end;disableSpeed=function() spdActive=false;if spdConn then spdConn:Disconnect();spdConn=nil end;local c=LocalPlayer.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h.WalkSpeed=origSpeed end end end
local flyConn,flying=nil,false;local bVel,bGyro;enableFly=function() if flying then return end;local c=LocalPlayer.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid");local hrp=c:FindFirstChild("HumanoidRootPart");if not hum or not hrp then return end;flying=true;bVel=Instance.new("BodyVelocity");bVel.MaxForce=Vector3.new(1e5,1e5,1e5);bVel.P=1e4;bVel.Parent=hrp;bGyro=Instance.new("BodyGyro");bGyro.MaxTorque=Vector3.new(1e5,1e5,1e5);bGyro.P=1e4;bGyro.D=100;bGyro.Parent=hrp;flyConn=RunService.RenderStepped:Connect(function() if not flying or not hrp then disableFly();return end;bGyro.CFrame=Camera.CFrame;local v=Vector3.zero;local ui=UserInputService;if ui:IsKeyDown(Enum.KeyCode.W) then v=v+Camera.CFrame.LookVector*_G.FlySpeed end;if ui:IsKeyDown(Enum.KeyCode.S) then v=v-Camera.CFrame.LookVector*_G.FlySpeed end;if ui:IsKeyDown(Enum.KeyCode.D) then v=v+Camera.CFrame.RightVector*_G.FlySpeed end;if ui:IsKeyDown(Enum.KeyCode.A) then v=v-Camera.CFrame.RightVector*_G.FlySpeed end;if ui:IsKeyDown(Enum.KeyCode.Space) then v=v+Vector3.new(0,_G.FlySpeed,0) end;if ui:IsKeyDown(Enum.KeyCode.LeftShift) or ui:IsKeyDown(Enum.KeyCode.Q) then v=v-Vector3.new(0,_G.FlySpeed,0) end;bVel.Velocity=v;if hum:GetState()~=Enum.HumanoidStateType.Freefall then hum:ChangeState(Enum.HumanoidStateType.Freefall) end end) end;disableFly=function() flying=false;if flyConn then flyConn:Disconnect();flyConn=nil end;if bVel then bVel:Destroy();bVel=nil end;if bGyro then bGyro:Destroy();bGyro=nil end;local c=LocalPlayer.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h:ChangeState(Enum.HumanoidStateType.Landed) end end end
local ncConn,ncActive=nil,false;enableNoclip=function() if ncActive then return end;ncActive=true;ncConn=RunService.Stepped:Connect(function() if not ncActive or not LocalPlayer.Character then ncActive=false;if ncConn then ncConn:Disconnect() end;return end;for _,p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end end end) end;disableNoclip=function() ncActive=false;if ncConn then ncConn:Disconnect();ncConn=nil end;local c=LocalPlayer.Character;if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end end

-- Gravity Hack
local function applyGravity() if _G.GravityHack then Workspace.Gravity=_G.GravityValue else Workspace.Gravity=196.2 end end

-- Teleport to Cursor
local tpCursorConn
local function enableTeleportCursor()
    if tpCursorConn then tpCursorConn:Disconnect() end
    tpCursorConn=UserInputService.InputBegan:Connect(function(input,gpe)
        if gpe or not _G.TeleportCursor then return end
        if input.UserInputType==Enum.UserInputType.MouseButton2 then
            local unitRay=Camera:ScreenPointToRay(input.Position.X,input.Position.Y)
            local params=RaycastParams.new();params.FilterDescendantsInstances={LocalPlayer.Character};params.FilterType=Enum.RaycastFilterType.Exclude
            local result=Workspace:Raycast(unitRay.Origin,unitRay.Direction*500,params)
            if result and LocalPlayer.Character then
                local hrp=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame=CFrame.new(result.Position+Vector3.new(0,3,0)) end
            end
        end
    end)
end

-- Kill Aura
local killAuraConn;enableKillAura=function() if killAuraConn then killAuraConn:Disconnect() end;killAuraConn=RunService.Heartbeat:Connect(function() if not _G.KillAura then return end;local c=LocalPlayer.Character;if not c then return end;local hrp=c:FindFirstChild("HumanoidRootPart");if not hrp then return end;local tool=c:FindFirstChildOfClass("Tool");for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then local friendly=p.Team and LocalPlayer.Team and p.Team==LocalPlayer.Team;if friendly then continue end;local phum=p.Character:FindFirstChildOfClass("Humanoid");local phrp=p.Character:FindFirstChild("HumanoidRootPart");if not phum or not phrp or phum.Health<=0 then continue end;if(phrp.Position-hrp.Position).Magnitude<=_G.KillAuraRange then if tool then for _,child in ipairs(tool:GetDescendants()) do if child:IsA("RemoteEvent") then pcall(function() child:FireServer(p.Character) end) end end;pcall(function() tool:Activate() end) end end end end end) end;disableKillAura=function() if killAuraConn then killAuraConn:Disconnect();killAuraConn=nil end end
local afkConn;enableAntiAFK=function() if afkConn then afkConn:Disconnect() end;afkConn=RunService.Heartbeat:Connect(function() if not _G.AntiAFK then return end;pcall(function() local vu=game:GetService("VirtualUser");vu:CaptureController();vu:ClickButton2(Vector2.new()) end) end) end;disableAntiAFK=function() if afkConn then afkConn:Disconnect();afkConn=nil end end

-- Name Spoof
local nameSpoofConn
applyNameSpoof=function()
    local name=_G.SpoofedName~="" and _G.SpoofedName or LocalPlayer.Name
    local function spoofChar(char)
        if not char then return end
        local head=char:FindFirstChild("Head");if not head then return end
        for _,gui in ipairs(head:GetChildren()) do if gui:IsA("BillboardGui") and gui.Name~="SusanoSpoofTag" then gui.Enabled=not _G.NameSpoof end end
        local existing=head:FindFirstChild("SusanoSpoofTag")
        if _G.NameSpoof then
            if not existing then
                local bb=Instance.new("BillboardGui",head);bb.Name="SusanoSpoofTag";bb.AlwaysOnTop=false;bb.Size=UDim2.new(0,250,0,36);bb.StudsOffset=Vector3.new(0,2.2,0)
                local lbl2=Instance.new("TextLabel",bb);lbl2.Size=UDim2.new(1,0,1,0);lbl2.BackgroundTransparency=1;lbl2.TextColor3=Color3.new(1,1,1);lbl2.Font=Enum.Font.GothamBold;lbl2.TextSize=17;lbl2.TextStrokeTransparency=0.5;lbl2.Name="SpoofLbl"
            end
            local lbl2=head.SusanoSpoofTag:FindFirstChild("SpoofLbl");if lbl2 then lbl2.Text=name end
            pcall(function() LocalPlayer.DisplayName=name end)
        else
            if existing then existing:Destroy() end
            for _,gui in ipairs(head:GetChildren()) do if gui:IsA("BillboardGui") then gui.Enabled=true end end
            pcall(function() LocalPlayer.DisplayName=LocalPlayer.Name end)
        end
    end
    spoofChar(LocalPlayer.Character)
    if nameSpoofConn then nameSpoofConn:Disconnect() end
    if _G.NameSpoof then nameSpoofConn=LocalPlayer.CharacterAdded:Connect(function(char) task.wait(0.5);spoofChar(char) end) end
end

-- Visual
local origAmbient=Lighting.Ambient;local origBrightness=Lighting.Brightness;local origFogEnd=Lighting.FogEnd;local origFogStart=Lighting.FogStart;local origCamFOV=Camera.FieldOfView;local origTimeOfDay=Lighting.TimeOfDay;local origColorShift=Lighting.ColorShift_Top
applyFullBright=function(v) if v then Lighting.Ambient=Color3.new(1,1,1);Lighting.Brightness=2;for _,e in ipairs(Lighting:GetChildren()) do if e:IsA("BlurEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("SunRaysEffect") or e:IsA("BloomEffect") then e.Enabled=false end end else Lighting.Ambient=origAmbient;Lighting.Brightness=origBrightness end end
applyNoFog=function(v) if v then Lighting.FogEnd=1e6;Lighting.FogStart=1e6 else Lighting.FogEnd=origFogEnd;Lighting.FogStart=origFogStart end end
applyTime=function(v) if v then Lighting.TimeOfDay=string.format("%02d:00:00",math.floor(_G.TimeOfDay)) else Lighting.TimeOfDay=origTimeOfDay end end
applyWorldColor=function(v) if v then Lighting.ColorShift_Top=Color3.fromRGB(_G.WorldR,_G.WorldG,_G.WorldB) else Lighting.ColorShift_Top=origColorShift end end
local tpConn;enableThirdPerson=function() Camera.CameraType=Enum.CameraType.Scriptable;if tpConn then tpConn:Disconnect() end;tpConn=RunService.RenderStepped:Connect(function() if not _G.ThirdPerson then disableThirdPerson();return end;local c=LocalPlayer.Character;if not c then return end;local hrp=c:FindFirstChild("HumanoidRootPart");if not hrp then return end;local d=_G.ThirdPersonDist;Camera.CFrame=CFrame.new(hrp.CFrame.Position-hrp.CFrame.LookVector*d+Vector3.new(0,d*0.4,0),hrp.Position) end) end;disableThirdPerson=function() if tpConn then tpConn:Disconnect();tpConn=nil end;Camera.CameraType=Enum.CameraType.Custom end

-- Auto Rejoin
local function enableAutoRejoin()
    game:GetService("Players").PlayerRemoving:Connect(function(p)
        if p==LocalPlayer and _G.AutoRejoin then
            task.wait(3)
            pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId,LocalPlayer) end)
        end
    end)
end

-- Server Hop
local function serverHop()
    task.spawn(function()
        local ts=game:GetService("TeleportService")
        local ok,result=pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        end)
        if ok and result and result.data then
            for _,s in ipairs(result.data) do
                if s.id~=game.JobId and s.playing<s.maxPlayers then
                    pcall(function() ts:TeleportToPlaceInstance(game.PlaceId,s.id,LocalPlayer) end)
                    return
                end
            end
        end
    end)
end

-- FPS Boost
local fpsBoostActive=false;local hiddenParts={}
local function enableFPSBoost()
    if fpsBoostActive then return end;fpsBoostActive=true
    for _,obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            pcall(function() obj.Enabled=false;table.insert(hiddenParts,obj) end)
        end
    end
    Lighting.GlobalShadows=false
end
local function disableFPSBoost()
    fpsBoostActive=false
    for _,obj in ipairs(hiddenParts) do pcall(function() obj.Enabled=true end) end
    hiddenParts={}
    Lighting.GlobalShadows=true
end

-- Chat Logger
local chatLogConn;local chatLogGui
local function enableChatLogger()
    if chatLogGui then return end
    chatLogGui=makeGui("SusanoChatLog",100)
    local frame=Instance.new("Frame",chatLogGui);frame.Size=UDim2.new(0,300,0,180);frame.Position=UDim2.new(0,10,1,-200);frame.BackgroundColor3=Color3.fromRGB(10,10,10);frame.BackgroundTransparency=0.2;frame.BorderSizePixel=0;corner(8,frame)
    local title=Instance.new("TextLabel",frame);title.Size=UDim2.new(1,0,0,22);title.BackgroundColor3=Color3.fromRGB(15,15,15);title.BackgroundTransparency=0;title.Text="Chat Log";title.TextColor3=Color3.new(1,1,1);title.Font=Enum.Font.GothamBold;title.TextSize=12;corner(8,title)
    local sc=Instance.new("ScrollingFrame",frame);sc.Size=UDim2.new(1,-6,1,-26);sc.Position=UDim2.new(0,3,0,24);sc.BackgroundTransparency=1;sc.ScrollBarThickness=2;sc.CanvasSize=UDim2.new(0,0,0,0);sc.AutomaticCanvasSize=Enum.AutomaticSize.Y;sc.BorderSizePixel=0
    Instance.new("UIListLayout",sc).Padding=UDim.new(0,2)
    local function addLog(pName,msg)
        table.insert(chatLogs,os.date("%H:%M").." ["..pName.."] "..msg)
        local lbl3=Instance.new("TextLabel",sc);lbl3.Size=UDim2.new(1,-4,0,16);lbl3.BackgroundTransparency=1;lbl3.Text=os.date("%H:%M").." "..pName..": "..msg:sub(1,40);lbl3.TextColor3=Color3.fromRGB(200,200,200);lbl3.Font=Enum.Font.Gotham;lbl3.TextSize=11;lbl3.TextXAlignment=Enum.TextXAlignment.Left;lbl3.TextWrapped=true
    end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer then p.Chatted:Connect(function(msg) if _G.ChatLogger then addLog(p.Name,msg) end end) end
    end
    chatLogConn=Players.PlayerAdded:Connect(function(p)
        p.Chatted:Connect(function(msg) if _G.ChatLogger then addLog(p.Name,msg) end end)
    end)
end
local function disableChatLogger()
    if chatLogConn then chatLogConn:Disconnect();chatLogConn=nil end
    if chatLogGui then chatLogGui:Destroy();chatLogGui=nil end
end

-- MiniMap
local mmGui,mmConn,mmDots
local function enableMiniMap()
    if mmGui then return end
    mmGui=makeGui("SusanoMiniMap",150);mmDots={}
    local sz=180
    local frame=Instance.new("Frame",mmGui);frame.Size=UDim2.new(0,sz,0,sz);frame.Position=UDim2.new(1,-sz-10,0,10);frame.BackgroundColor3=Color3.fromRGB(10,10,10);frame.BackgroundTransparency=0.15;frame.BorderSizePixel=0;corner(90,frame)
    local brd=Instance.new("UIStroke",frame);brd.Color=Tc.Accent;brd.Thickness=1.5;brd.Transparency=0.5
    Instance.new("TextLabel",frame).Size=UDim2.new(1,0,0,14);local rtl=frame:FindFirstChildOfClass("TextLabel");rtl.BackgroundTransparency=1;rtl.Text="RADAR";rtl.TextColor3=Tc.Accent;rtl.Font=Enum.Font.GothamBold;rtl.TextSize=9
    local centerDot=Instance.new("Frame",frame);centerDot.Size=UDim2.new(0,8,0,8);centerDot.AnchorPoint=Vector2.new(0.5,0.5);centerDot.Position=UDim2.new(0.5,0,0.5,0);centerDot.BackgroundColor3=Color3.new(1,1,1);centerDot.BorderSizePixel=0;corner(4,centerDot)
    if mmConn then mmConn:Disconnect() end
    mmConn=RunService.RenderStepped:Connect(function()
        if not _G.MiniMap then return end
        local myHRP=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local activePL={}
        for _,p in ipairs(Players:GetPlayers()) do activePL[p]=true end
        for p,dot in pairs(mmDots) do if not activePL[p] then dot:Destroy();mmDots[p]=nil end end
        for _,p in ipairs(Players:GetPlayers()) do
            if p==LocalPlayer or not p.Character then continue end
            local hrp=p.Character:FindFirstChild("HumanoidRootPart");if not hrp then continue end
            local diff=hrp.Position-myHRP.Position
            local range=200;local nx=math.clamp(diff.X/range,-0.5,0.5);local nz=math.clamp(diff.Z/range,-0.5,0.5)
            if not mmDots[p] then
                local dot=Instance.new("Frame",frame);dot.Size=UDim2.new(0,6,0,6);dot.AnchorPoint=Vector2.new(0.5,0.5);dot.BorderSizePixel=0;corner(3,dot)
                local nl=Instance.new("TextLabel",dot);nl.Size=UDim2.new(0,60,0,12);nl.Position=UDim2.new(1,2,0,-2);nl.BackgroundTransparency=1;nl.Text=p.Name:sub(1,7);nl.TextColor3=Color3.new(1,1,1);nl.Font=Enum.Font.GothamBold;nl.TextSize=8;nl.TextXAlignment=Enum.TextXAlignment.Left
                mmDots[p]=dot
            end
            local friendly=p.Team and LocalPlayer.Team and p.Team==LocalPlayer.Team
            mmDots[p].BackgroundColor3=friendly and Color3.fromRGB(80,180,255) or Color3.fromRGB(255,80,80)
            mmDots[p].Position=UDim2.new(0.5+nx,0,0.5+nz,0)
        end
    end)
end
local function disableMiniMap()
    if mmConn then mmConn:Disconnect();mmConn=nil end
    if mmGui then mmGui:Destroy();mmGui=nil;mmDots=nil end
end

-- ESP SİSTEMİ
local espCache,esp2D,espTracers={},{},{}
local function clearESPDrawings(p)
    if esp2D[p] then for _,v in pairs(esp2D[p]) do pcall(function() v.Visible=false;v:Remove() end) end;esp2D[p]=nil end
    if espTracers[p] then pcall(function() espTracers[p].Visible=false;espTracers[p]:Remove() end);espTracers[p]=nil end
end
local function clearESPPlayer(p)
    if espCache[p] then
        if espCache[p].hl then pcall(function() espCache[p].hl:Destroy() end) end
        if espCache[p].bb then pcall(function() espCache[p].bb:Destroy() end) end
        if espCache[p].hbBB then pcall(function() espCache[p].hbBB:Destroy() end) end
        espCache[p]=nil
    end
    clearESPDrawings(p);clearSkeleton(p)
end
local function clearAllESP()
    for p in pairs(espCache) do clearESPPlayer(p) end
    for p in pairs(esp2D) do clearESPDrawings(p) end
end
local function buildESP(player)
    if not _G.ESP or player==LocalPlayer or espCache[player] then return end
    local char=player.Character;if not char then return end
    local hrp=char:WaitForChild("HumanoidRootPart",5);if not hrp then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    local hl=Instance.new("Highlight");hl.Adornee=char;hl.FillTransparency=0.75;hl.OutlineColor=Color3.new(1,1,1);hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;hl.Enabled=false;hl.Parent=CoreGui
    local bb=Instance.new("BillboardGui");bb.Size=UDim2.new(6,0,3,0);bb.AlwaysOnTop=true;bb.StudsOffset=Vector3.new(0,4,0);bb.Adornee=hrp;bb.Enabled=false;bb.Parent=CoreGui
    local function lbl4(pos,sz,col,fs) local l=Instance.new("TextLabel",bb);l.Size=UDim2.new(1,0,sz,0);l.Position=UDim2.new(0,0,pos,0);l.BackgroundTransparency=1;l.TextColor3=col;l.Font=Enum.Font.GothamBold;l.TextSize=fs;l.TextStrokeTransparency=0.4;return l end
    local idLbl=lbl4(0,0.3,Color3.fromRGB(160,160,255),12);local nameLbl=lbl4(0.3,0.4,Color3.new(1,1,1),16);local dstLbl=lbl4(0.7,0.3,Color3.fromRGB(255,220,80),12)
    local hbBB=Instance.new("BillboardGui");hbBB.Size=UDim2.new(0.4,0,2,0);hbBB.AlwaysOnTop=true;hbBB.StudsOffset=Vector3.new(-1.8,2,0);hbBB.Adornee=hrp;hbBB.Enabled=false;hbBB.Parent=CoreGui
    local hbBG=Instance.new("Frame",hbBB);hbBG.Size=UDim2.new(0,4,1,0);hbBG.BackgroundColor3=Color3.fromRGB(20,20,20);hbBG.BorderSizePixel=0
    local hbFill=Instance.new("Frame",hbBG);hbFill.Size=UDim2.new(1,0,1,0);hbFill.BackgroundColor3=Color3.fromRGB(80,255,120);hbFill.BorderSizePixel=0
    espCache[player]={hl=hl,bb=bb,hbBB=hbBB,hbBG=hbBG,hbFill=hbFill,idLbl=idLbl,nameLbl=nameLbl,dstLbl=dstLbl,hrp=hrp,hum=hum}
    local e={}
    e.box=Drawing.new("Square");e.box.Visible=false;e.box.Thickness=1.5;e.box.Filled=false
    e.name=Drawing.new("Text");e.name.Visible=false;e.name.Size=14;e.name.Font=2;e.name.Center=true
    e.dist=Drawing.new("Text");e.dist.Visible=false;e.dist.Size=12;e.dist.Font=2;e.dist.Center=true;e.dist.Color=Color3.fromRGB(255,220,80)
    e.id=Drawing.new("Text");e.id.Visible=false;e.id.Size=11;e.id.Font=2;e.id.Center=true;e.id.Color=Color3.fromRGB(160,160,255)
    e.hbg=Drawing.new("Square");e.hbg.Visible=false;e.hbg.Filled=true;e.hbg.Color=Color3.fromRGB(20,20,20)
    e.hfill=Drawing.new("Square");e.hfill.Visible=false;e.hfill.Filled=true
    esp2D[player]=e
    local tr=Drawing.new("Line");tr.Visible=false;tr.Thickness=_G.TracerThick;tr.Transparency=0.3
    espTracers[player]=tr
end

local function updateESP()
    if not _G.ESP then clearAllESP();return end
    local myHRP=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");if not myHRP then return end
    local cEnemy=Color3.fromRGB(_G.ESPEnemyR,_G.ESPEnemyG,_G.ESPEnemyB)
    local cFriend=Color3.fromRGB(_G.ESPFriendR,_G.ESPFriendG,_G.ESPFriendB)
    local cVis=Color3.fromRGB(_G.ESPVisR,_G.ESPVisG,_G.ESPVisB)
    local activePL={};for _,p in ipairs(Players:GetPlayers()) do activePL[p]=true end
    for p in pairs(espCache) do if not activePL[p] then clearESPPlayer(p) end end
    for player,cache in pairs(espCache) do
        if not(player and player.Parent and cache.hrp and cache.hrp.Parent) then clearESPPlayer(player);continue end
        local char=player.Character;local hum=char and char:FindFirstChildOfClass("Humanoid");local hrp=cache.hrp
        local dist=(hrp.Position-myHRP.Position).Magnitude
        local friendly=player.Team and LocalPlayer.Team and player.Team==LocalPlayer.Team
        local show=(friendly and _G.ShowFriendly) or (not friendly and _G.TeamCheck)
        if not(show and hum and hum.Health>0) then show=false end
        local vis=false;if _G.WallCheck and show and not friendly then vis=isVisible(player) end
        local col=friendly and cFriend or(_G.WallCheck and (vis and cVis or cEnemy) or cEnemy)
        if cache.hl then cache.hl.Enabled=_G.ESPBox3D and show;if cache.hl.Enabled then cache.hl.FillColor=col;cache.hl.OutlineColor=col;cache.hl.DepthMode=(_G.WallCheck and vis) and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop end end
        if cache.bb then cache.bb.Enabled=show;if show then cache.idLbl.Visible=_G.ShowID;cache.idLbl.Text="ID: "..player.UserId;cache.nameLbl.Visible=_G.ShowNames;cache.nameLbl.Text=player.Name;cache.nameLbl.TextColor3=col;cache.dstLbl.Visible=_G.ShowDistance;cache.dstLbl.Text=math.floor(dist).."m" end end
        if cache.hbBB then cache.hbBB.Enabled=_G.ShowHealthBar and show;if cache.hbBB.Enabled and hum and hum.Health>0 then local pct=hum.Health/hum.MaxHealth;cache.hbFill.Size=UDim2.new(1,0,pct,0);cache.hbFill.Position=UDim2.new(0,0,1-pct,0);cache.hbFill.BackgroundColor3=pct>0.6 and Color3.fromRGB(80,255,120) or(pct>0.3 and Color3.fromRGB(255,220,80) or Color3.fromRGB(255,80,80)) end end
        local e=esp2D[player]
        if e then
            if _G.ESPBox2D and show then
                local sp,onSc=Camera:WorldToViewportPoint(hrp.Position)
                if onSc then
                    local head=char:FindFirstChild("Head")
                    if head then
                        local sh=Camera:WorldToViewportPoint(head.Position)
                        local h=math.abs(sh.Y-sp.Y)*2.3;local w=h*0.55;local tl=Vector2.new(sp.X-w/2,sh.Y-h/2)
                        e.box.Visible=true;e.box.Position=tl;e.box.Size=Vector2.new(w,h);e.box.Color=col
                        if _G.ShowNames then e.name.Visible=true;e.name.Position=Vector2.new(sp.X,sh.Y-h/2-18);e.name.Text=player.Name;e.name.Color=col else e.name.Visible=false end
                        if _G.ShowDistance then e.dist.Visible=true;e.dist.Position=Vector2.new(sp.X,sh.Y+h/2+4);e.dist.Text=math.floor(dist).."m" else e.dist.Visible=false end
                        if _G.ShowID then e.id.Visible=true;e.id.Position=Vector2.new(sp.X,sh.Y-h/2-32);e.id.Text="ID: "..player.UserId else e.id.Visible=false end
                        if _G.ShowHealthBar and hum and hum.Health>0 then
                            local pct=hum.Health/hum.MaxHealth
                            e.hbg.Visible=true;e.hbg.Position=Vector2.new(tl.X-7,tl.Y);e.hbg.Size=Vector2.new(3,h)
                            e.hfill.Visible=true;e.hfill.Position=Vector2.new(tl.X-7,tl.Y+h*(1-pct));e.hfill.Size=Vector2.new(3,h*pct)
                            e.hfill.Color=pct>0.6 and Color3.fromRGB(80,255,120) or(pct>0.3 and Color3.fromRGB(255,220,80) or Color3.fromRGB(255,80,80))
                        else e.hbg.Visible=false;e.hfill.Visible=false end
                    else for _,v in pairs(e) do pcall(function() v.Visible=false end) end end
                else for _,v in pairs(e) do pcall(function() v.Visible=false end) end end
            else for _,v in pairs(e) do pcall(function() v.Visible=false end) end end
        end
        local tr=espTracers[player]
        if tr then
            tr.Thickness=_G.TracerThick
            if _G.ShowTracer and show then
                local sp,onSc=Camera:WorldToViewportPoint(hrp.Position)
                if onSc then tr.Visible=true;tr.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y);tr.To=Vector2.new(sp.X,sp.Y);tr.Color=col else tr.Visible=false end
            else tr.Visible=false end
        end
    end
end

Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() if _G.ESP then task.wait(1);buildESP(p) end end);if p.Character and _G.ESP then task.wait(1);buildESP(p) end;p.CharacterRemoving:Connect(function() clearESPPlayer(p) end) end)
Players.PlayerRemoving:Connect(function(p) clearESPPlayer(p) end)
for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then p.CharacterAdded:Connect(function() if _G.ESP then task.wait(1);buildESP(p) end end);if p.Character and _G.ESP then task.wait(1);buildESP(p) end;p.CharacterRemoving:Connect(function() clearESPPlayer(p) end) end end

-- CONFIG - SADECE LOCAL KAYIT
local function buildConfigData()
    return {
        ESP=_G.ESP,ESPBox3D=_G.ESPBox3D,ESPBox2D=_G.ESPBox2D,ShowNames=_G.ShowNames,ShowDistance=_G.ShowDistance,ShowHealthBar=_G.ShowHealthBar,ShowID=_G.ShowID,ShowTracer=_G.ShowTracer,TracerThick=_G.TracerThick,TeamCheck=_G.TeamCheck,ShowFriendly=_G.ShowFriendly,WallCheck=_G.WallCheck,SkeletonESP=_G.SkeletonESP,
        ESPEnemyR=_G.ESPEnemyR,ESPEnemyG=_G.ESPEnemyG,ESPEnemyB=_G.ESPEnemyB,ESPFriendR=_G.ESPFriendR,ESPFriendG=_G.ESPFriendG,ESPFriendB=_G.ESPFriendB,ESPVisR=_G.ESPVisR,ESPVisG=_G.ESPVisG,ESPVisB=_G.ESPVisB,
        Crosshair=_G.Crosshair,CrosshairStyle=_G.CrosshairStyle,CrosshairSize=_G.CrosshairSize,CrosshairThick=_G.CrosshairThick,CrosshairGap=_G.CrosshairGap,CrosshairAlpha=_G.CrosshairAlpha,CrosshairDot=_G.CrosshairDot,CrosshairOutline=_G.CrosshairOutline,CrosshairR=_G.CrosshairR,CrosshairG=_G.CrosshairG,CrosshairB=_G.CrosshairB,
        Aimbot=_G.Aimbot,RageAimbot=_G.RageAimbot,SilentAim=_G.SilentAim,UseFOV=_G.UseFOV,FOVVisible=_G.FOVVisible,FOVSize=_G.FOVSize,AimbotSmoothness=_G.AimbotSmoothness,AimbotPartHead=_G.AimbotPartHead,AimbotPartChest=_G.AimbotPartChest,AimbotPartStomach=_G.AimbotPartStomach,
        HitboxEnabled=_G.HitboxEnabled,HitboxSize=_G.HitboxSize,FakeLag=_G.FakeLag,FakeLagInterval=_G.FakeLagInterval,
        FlyEnabled=_G.FlyEnabled,FlySpeed=_G.FlySpeed,NoClipEnabled=_G.NoClipEnabled,BunnyHop=_G.BunnyHop,BunnyHopSpeed=_G.BunnyHopSpeed,BunnyHopHeight=_G.BunnyHopHeight,SpeedHack=_G.SpeedHack,SpeedMultiplier=_G.SpeedMultiplier,InfiniteJump=_G.InfiniteJump,LongJump=_G.LongJump,LongJumpPower=_G.LongJumpPower,SwimHack=_G.SwimHack,GravityHack=_G.GravityHack,GravityValue=_G.GravityValue,TeleportCursor=_G.TeleportCursor,
        KillAura=_G.KillAura,KillAuraRange=_G.KillAuraRange,AntiAFK=_G.AntiAFK,NameSpoof=_G.NameSpoof,SpoofedName=_G.SpoofedName,
        FullBright=_G.FullBright,NoFog=_G.NoFog,FOVChanger=_G.FOVChanger,FOVChangerVal=_G.FOVChangerVal,ThirdPerson=_G.ThirdPerson,ThirdPersonDist=_G.ThirdPersonDist,TimeChanger=_G.TimeChanger,TimeOfDay=_G.TimeOfDay,WorldColor=_G.WorldColor,WorldR=_G.WorldR,WorldG=_G.WorldG,WorldB=_G.WorldB,
    }
end
local function applyConfigData(data) for k,v in pairs(data) do _G[k]=v end end

local function listLocalConfigs()
    local configs={}
    local files=safeListFiles(CONFIG_FOLDER)
    for _,f in ipairs(files) do
        local name=f:match("([^/\\]+)%.json$") or f:match("([^/\\]+)%.txt$")
        if name then table.insert(configs,name) end
    end
    return configs
end

local function saveLocalConfig(name)
    safeMakeFolder(CONFIG_FOLDER)
    local ok,json=pcall(function() return HttpService:JSONEncode(buildConfigData()) end)
    if not ok then return false end
    safeWrite(CONFIG_FOLDER.."/"..name..".json",json)
    return true
end

local function loadLocalConfig(name)
    local ok,content=safeRead(CONFIG_FOLDER.."/"..name..".json")
    if not ok or not content then return false end
    local ok2,data=pcall(function() return HttpService:JSONDecode(content) end)
    if not ok2 or not data then return false end
    applyConfigData(data)
    return true
end

local function deleteLocalConfig(name)
    safeDel(CONFIG_FOLDER.."/"..name..".json")
end

-- TAB BUILDERS
local tabBuilders={}

tabBuilders["ESP"]=function(p)
    local sc=makeScroll(p);local y=10
    y=buildSection(sc,T("sec_visibility"),y)
    y=buildToggle(sc,"ESP Aktif","ESP",y,function(v) if not v then clearAllESP() end end)
    y=buildToggle(sc,"3D Highlight","ESPBox3D",y)
    y=buildToggle(sc,"2D Box","ESPBox2D",y)
    y=buildToggle(sc,"Skeleton ESP","SkeletonESP",y)
    y=buildSection(sc,T("sec_labels"),y+4)
    y=buildToggle(sc,"Isim","ShowNames",y)
    y=buildToggle(sc,"Mesafe","ShowDistance",y)
    y=buildToggle(sc,"Can Cubugu","ShowHealthBar",y)
    y=buildToggle(sc,"ID","ShowID",y)
    y=buildToggle(sc,"Tracer","ShowTracer",y)
    y=buildSlider(sc,"Tracer Kalinlık","TracerThick",y,0.5,6,"%.1f")
    y=buildSection(sc,T("sec_filters"),y+4)
    y=buildToggle(sc,"Dusmanlari Goster","TeamCheck",y)
    y=buildToggle(sc,"Takim Arkadaslari","ShowFriendly",y)
    y=buildToggle(sc,"Duvar Kontrolu / Chams","WallCheck",y)
    y=buildSection(sc,"Dusman Rengi",y+4)
    y=buildColorPreview(sc,"ESPEnemyR","ESPEnemyG","ESPEnemyB",y)
    y=buildSlider(sc,"Kirmizi","ESPEnemyR",y,0,255,nil)
    y=buildSlider(sc,"Yesil","ESPEnemyG",y,0,255,nil)
    y=buildSlider(sc,"Mavi","ESPEnemyB",y,0,255,nil)
    y=buildSection(sc,"Dost Rengi",y+4)
    y=buildColorPreview(sc,"ESPFriendR","ESPFriendG","ESPFriendB",y)
    y=buildSlider(sc,"Kirmizi","ESPFriendR",y,0,255,nil)
    y=buildSlider(sc,"Yesil","ESPFriendG",y,0,255,nil)
    y=buildSlider(sc,"Mavi","ESPFriendB",y,0,255,nil)
    y=buildSection(sc,"Gorunur Renk (Chams)",y+4)
    y=buildColorPreview(sc,"ESPVisR","ESPVisG","ESPVisB",y)
    y=buildSlider(sc,"Kirmizi","ESPVisR",y,0,255,nil)
    y=buildSlider(sc,"Yesil","ESPVisG",y,0,255,nil)
    y=buildSlider(sc,"Mavi","ESPVisB",y,0,255,nil)
    y=buildSection(sc,"Nisangah",y+4)
    y=buildToggle(sc,"Nisangah","Crosshair",y,function() buildCrosshair() end)
    y=buildDropdown(sc,"Stil",CH_STYLES,function() return _G.CrosshairStyle end,function(v) _G.CrosshairStyle=v;buildCrosshair() end,y)
    y=buildSlider(sc,"Boyut","CrosshairSize",y,4,50,nil,function() buildCrosshair() end)
    y=buildSlider(sc,"Kalinlik","CrosshairThick",y,1,8,nil,function() buildCrosshair() end)
    y=buildSlider(sc,"Bosluk","CrosshairGap",y,0,24,nil,function() buildCrosshair() end)
    y=buildSlider(sc,"Opaklık","CrosshairAlpha",y,0.1,1.0,"%.1f",function() buildCrosshair() end)
    y=buildToggle(sc,"Merkez Nokta","CrosshairDot",y,function() buildCrosshair() end)
    y=buildToggle(sc,"Dis Cizgi","CrosshairOutline",y,function() buildCrosshair() end)
    y=buildSection(sc,"Nisangah Rengi",y+4)
    y=buildColorPreview(sc,"CrosshairR","CrosshairG","CrosshairB",y)
    y=buildSlider(sc,"Kirmizi","CrosshairR",y,0,255,nil,function() buildCrosshair() end)
    y=buildSlider(sc,"Yesil","CrosshairG",y,0,255,nil,function() buildCrosshair() end)
    y=buildSlider(sc,"Mavi","CrosshairB",y,0,255,nil,function() buildCrosshair() end)
end

tabBuilders["AIMBOT"]=function(p)
    local sc=makeScroll(p);local y=10
    y=buildSection(sc,T("sec_aimbot"),y)
    y=buildToggle(sc,"Aimbot","Aimbot",y)
    y=buildToggle(sc,"Rage Aimbot","RageAimbot",y,function(v) if v then enableRageAimbot() else disableRageAimbot() end end)
    y=buildSection(sc,T("sec_silent"),y+4)
    y=buildToggle(sc,"Silent Aim","SilentAim",y,function(v) if v then enableSilentAim() else disableSilentAim() end end)
    y=buildSection(sc,T("sec_hitbox"),y+4)
    y=buildToggle(sc,"Hitbox Buyutme","HitboxEnabled",y,function(v) if v then enableHitbox() else disableHitbox() end end)
    y=buildSlider(sc,"Hitbox Boyutu","HitboxSize",y,1,20,"%.1f")
    y=buildSection(sc,T("sec_fakelag"),y+4)
    y=buildToggle(sc,"Fake Lag","FakeLag",y,function(v) if v then enableFakeLag() else disableFakeLag() end end)
    y=buildSlider(sc,"Lag Suresi","FakeLagInterval",y,0.0,0.5,"%.2f")
    y=buildSection(sc,T("sec_fov"),y+4)
    y=buildToggle(sc,"FOV Filtresi","UseFOV",y)
    y=buildToggle(sc,"FOV Dairesi","FOVVisible",y,function(v) if FOVCircle then FOVCircle.Visible=v end end)
    y=buildSlider(sc,"FOV Capin","FOVSize",y,20,400,nil)
    y=buildSection(sc,T("sec_smooth"),y+4)
    y=buildSlider(sc,"Yumusatma (dusuk=hizli)","AimbotSmoothness",y,0.02,1.0,"%.2f")
    y=buildSection(sc,T("sec_target"),y+4)
    y=buildToggle(sc,"Kafa","AimbotPartHead",y)
    y=buildToggle(sc,"Gogus","AimbotPartChest",y)
    y=buildToggle(sc,"Karin","AimbotPartStomach",y)
end

tabBuilders["MOVEMENT"]=function(p)
    local sc=makeScroll(p);local y=10
    y=buildSection(sc,T("sec_fly"),y)
    y=buildToggle(sc,"Uc","FlyEnabled",y,function(v) if v then enableFly() else disableFly() end end)
    y=buildSlider(sc,"Ucus Hizi","FlySpeed",y,10,300,nil)
    y=buildSection(sc,T("sec_move"),y+4)
    y=buildToggle(sc,"Noclip","NoClipEnabled",y,function(v) if v then enableNoclip() else disableNoclip() end end)
    y=buildToggle(sc,"Sonsuz Zipplama","InfiniteJump",y,function(v) if v then enableInfiniteJump() else disableInfiniteJump() end end)
    y=buildToggle(sc,"Uzun Atlama (Space)","LongJump",y,function(v) if v then enableLongJump() else disableLongJump() end end)
    y=buildSlider(sc,"Atlama Gucu","LongJumpPower",y,20,200,nil)
    y=buildToggle(sc,"Yuzme Hack","SwimHack",y)
    y=buildSection(sc,T("sec_bhop"),y+4)
    y=buildToggle(sc,"Bunny Hop","BunnyHop",y,function(v) if v then enableBhop() else disableBhop() end end)
    y=buildSlider(sc,"Hiz","BunnyHopSpeed",y,1.0,3.0,"%.1f")
    y=buildSection(sc,T("sec_speed"),y+4)
    y=buildToggle(sc,"Hiz Hack","SpeedHack",y,function(v) if v then enableSpeed() else disableSpeed() end end)
    y=buildSlider(sc,"Carpan","SpeedMultiplier",y,1.0,10.0,"%.1f")
    y=buildSection(sc,T("sec_gravity"),y+4)
    y=buildToggle(sc,"Gravity Hack","GravityHack",y,function(v) applyGravity() end)
    y=buildSlider(sc,"Gravity Degeri","GravityValue",y,0,500,"%.1f",function(v) if _G.GravityHack then Workspace.Gravity=v end end)
    y=buildSection(sc,T("sec_tp"),y+4)
    y=buildToggle(sc,"Cursor TP (Sag Tik)","TeleportCursor",y)
    y=buildSection(sc,T("sec_other"),y+4)
    y=buildToggle(sc,"Stream Proof","StreamProof",y,function(v) if MainGui then MainGui.DisplayOrder=v and 200 or 10 end end)
end

tabBuilders["PLAYERS"]=function(p)
    local sc=makeScroll(p);local y=10
    y=buildSection(sc,T("sec_combat"),y)
    y=buildToggle(sc,"Kill Aura","KillAura",y,function(v) if v then enableKillAura() else disableKillAura() end end)
    y=buildSlider(sc,"Menzil","KillAuraRange",y,5,50,nil)
    y=buildSection(sc,T("sec_helper"),y+4)
    y=buildToggle(sc,"Anti AFK","AntiAFK",y,function(v) if v then enableAntiAFK() else disableAntiAFK() end end)
    y=buildSection(sc,T("sec_spoof"),y+4)
    y=buildToggle(sc,"Isim Degistir","NameSpoof",y,function() applyNameSpoof() end)
    local nameBox;nameBox,y=buildInput(sc,"Sahte Isim","Isim gir","",y)
    local applyBtn;applyBtn,y=buildButton(sc,"Uygula",y)
    applyBtn.MouseButton1Click:Connect(function() _G.SpoofedName=nameBox.Text;applyNameSpoof() end)
    y=buildSection(sc,"Oyuncu Listesi",y+4)
    local stopBtn;stopBtn,y=buildButton(sc,"Izlemeyi Durdur",y,Tc.AccentFaint,Tc.Text)
    stopBtn.MouseButton1Click:Connect(function() local c=LocalPlayer.Character;Camera.CameraSubject=(c and c:FindFirstChildOfClass("Humanoid")) or LocalPlayer end)
    local plist=Instance.new("ScrollingFrame",sc);plist.Size=UDim2.new(1,-28,0,240);plist.Position=UDim2.new(0,14,0,y);plist.BackgroundColor3=Tc.Card;corner(8,plist);plist.ScrollBarThickness=3;plist.CanvasSize=UDim2.new(0,0,0,0);plist.AutomaticCanvasSize=Enum.AutomaticSize.Y;plist.BorderSizePixel=0
    Instance.new("UIListLayout",plist).Padding=UDim.new(0,4)
    local pp=Instance.new("UIPadding",plist);pp.PaddingTop=UDim.new(0,6);pp.PaddingLeft=UDim.new(0,6);pp.PaddingRight=UDim.new(0,6)
    local function refreshPL()
        for _,c in ipairs(plist:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr==LocalPlayer then continue end
            local row=Instance.new("Frame",plist);row.Size=UDim2.new(1,0,0,40);row.BackgroundColor3=Tc.CardHov;corner(6,row)
            local nl=Instance.new("TextLabel",row);nl.Size=UDim2.new(0.42,0,1,0);nl.Position=UDim2.new(0,8,0,0);nl.BackgroundTransparency=1;nl.Text=plr.Name;nl.TextColor3=Tc.Text;nl.Font=Enum.Font.GothamSemibold;nl.TextSize=13;nl.TextXAlignment=Enum.TextXAlignment.Left
            local defs={{l="TP",c=Color3.fromRGB(55,55,180),x=0.43},{l="PULL",c=Color3.fromRGB(160,90,0),x=0.57},{l="SPEC",c=Color3.fromRGB(75,75,160),x=0.72},{l="FRZ",c=Color3.fromRGB(0,130,130),x=0.87}}
            local btns2={};for _,bd in ipairs(defs) do local b=Instance.new("TextButton",row);b.Size=UDim2.new(0,42,0,28);b.Position=UDim2.new(bd.x,0,0.5,-14);b.BackgroundColor3=bd.c;b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextSize=11;b.Text=bd.l;corner(5,b);btns2[bd.l]=b end
            btns2["TP"].MouseButton1Click:Connect(function() if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame=plr.Character.HumanoidRootPart.CFrame+Vector3.new(0,3,0) end end)
            btns2["PULL"].MouseButton1Click:Connect(function() if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then plr.Character.HumanoidRootPart.CFrame=LocalPlayer.Character.HumanoidRootPart.CFrame+Vector3.new(0,3,0) end end)
            btns2["SPEC"].MouseButton1Click:Connect(function() if plr.Character and plr.Character:FindFirstChild("Humanoid") then Camera.CameraSubject=plr.Character.Humanoid end end)
            local frozen=false;btns2["FRZ"].MouseButton1Click:Connect(function() frozen=not frozen;if plr.Character then local root=plr.Character:FindFirstChild("HumanoidRootPart");if root then if frozen then if FrozenPlayers[plr] then return end;local bp=Instance.new("BodyPosition");bp.MaxForce=Vector3.new(4e4,4e4,4e4);bp.P=2000;bp.D=100;bp.Position=root.Position;bp.Parent=root;FrozenPlayers[plr]=bp else if FrozenPlayers[plr] then FrozenPlayers[plr]:Destroy();FrozenPlayers[plr]=nil end end end end;btns2["FRZ"].Text=frozen and "FREE" or "FRZ";btns2["FRZ"].BackgroundColor3=frozen and Color3.fromRGB(0,180,90) or Color3.fromRGB(0,130,130) end)
        end
    end
    refreshPL();Players.PlayerAdded:Connect(refreshPL);Players.PlayerRemoving:Connect(function() task.wait(0.2);refreshPL() end)
end

tabBuilders["VISUAL"]=function(p)
    local sc=makeScroll(p);local y=10
    y=buildSection(sc,T("sec_lighting"),y)
    y=buildToggle(sc,"Full Bright","FullBright",y,function(v) applyFullBright(v) end)
    y=buildToggle(sc,"Sis Kaldir","NoFog",y,function(v) applyNoFog(v) end)
    y=buildSection(sc,T("sec_camera"),y+4)
    y=buildToggle(sc,"FOV Degistir","FOVChanger",y,function(v) if not v then Camera.FieldOfView=origCamFOV end end)
    y=buildSlider(sc,"FOV Degeri","FOVChangerVal",y,50,200,nil,function(v) if _G.FOVChanger then Camera.FieldOfView=v end end)
    y=buildToggle(sc,"3. Sahis Kamera","ThirdPerson",y,function(v) if v then enableThirdPerson() else disableThirdPerson() end end)
    y=buildSlider(sc,"Mesafe","ThirdPersonDist",y,4,30,nil)
    y=buildSection(sc,T("sec_world"),y+4)
    y=buildToggle(sc,"Saat Degistir","TimeChanger",y,function(v) applyTime(v) end)
    y=buildSlider(sc,"Saat (0-23)","TimeOfDay",y,0,23,nil,function(v) if _G.TimeChanger then applyTime(true) end end)
    y=buildSection(sc,T("sec_world_col"),y+4)
    y=buildToggle(sc,"Renk Degistir","WorldColor",y,function(v) applyWorldColor(v) end)
    y=buildColorPreview(sc,"WorldR","WorldG","WorldB",y)
    y=buildSlider(sc,"Kirmizi","WorldR",y,0,255,nil,function() if _G.WorldColor then applyWorldColor(true) end end)
    y=buildSlider(sc,"Yesil","WorldG",y,0,255,nil,function() if _G.WorldColor then applyWorldColor(true) end end)
    y=buildSlider(sc,"Mavi","WorldB",y,0,255,nil,function() if _G.WorldColor then applyWorldColor(true) end end)
end

tabBuilders["MISC"]=function(p)
    local sc=makeScroll(p);local y=10
    y=buildSection(sc,T("sec_server"),y)
    local hopBtn;hopBtn,y=buildButton(sc,"Server Hop (Baska Sunucu)",y,Color3.fromRGB(40,100,180),Color3.new(1,1,1))
    hopBtn.MouseButton1Click:Connect(function() hopBtn.Text="Geciliyor...";task.spawn(function() serverHop();task.wait(2);hopBtn.Text="Server Hop (Baska Sunucu)" end) end)
    y=buildToggle(sc,"Auto Rejoin (Kick olunca geri gel)","AutoRejoin",y)
    y=buildSection(sc,T("sec_perf"),y+4)
    y=buildToggle(sc,"FPS Boost","FPSBoost",y,function(v) if v then enableFPSBoost() else disableFPSBoost() end end)
    y=buildSection(sc,T("sec_chat"),y+4)
    y=buildToggle(sc,"Chat Logger","ChatLogger",y,function(v) if v then enableChatLogger() else disableChatLogger() end end)
    -- Chat log listesi
    if #chatLogs>0 then
        local chatFrame=Instance.new("Frame",sc);chatFrame.Size=UDim2.new(1,-28,0,160);chatFrame.Position=UDim2.new(0,14,0,y);chatFrame.BackgroundColor3=Tc.Card;corner(8,chatFrame)
        local chatSc=Instance.new("ScrollingFrame",chatFrame);chatSc.Size=UDim2.new(1,-8,1,-8);chatSc.Position=UDim2.new(0,4,0,4);chatSc.BackgroundTransparency=1;chatSc.ScrollBarThickness=2;chatSc.CanvasSize=UDim2.new(0,0,0,0);chatSc.AutomaticCanvasSize=Enum.AutomaticSize.Y;chatSc.BorderSizePixel=0
        Instance.new("UIListLayout",chatSc).Padding=UDim.new(0,2)
        for _,log in ipairs(chatLogs) do
            local lbl5=Instance.new("TextLabel",chatSc);lbl5.Size=UDim2.new(1,-4,0,14);lbl5.BackgroundTransparency=1;lbl5.Text=log:sub(1,50);lbl5.TextColor3=Tc.TextDim;lbl5.Font=Enum.Font.Gotham;lbl5.TextSize=10;lbl5.TextXAlignment=Enum.TextXAlignment.Left;lbl5.TextWrapped=true
        end
        y=y+168
    end
    y=buildSection(sc,T("sec_minimap"),y+4)
    y=buildToggle(sc,"MiniMap / Radar","MiniMap",y,function(v) if v then enableMiniMap() else disableMiniMap() end end)
end

tabBuilders["CONFIG"]=function(p)
    local sc=makeScroll(p);local y=10
    local infoCard=Instance.new("Frame",sc);infoCard.Size=UDim2.new(1,-28,0,36);infoCard.Position=UDim2.new(0,14,0,y);infoCard.BackgroundColor3=Tc.AccentFaint;corner(8,infoCard)
    local infoLbl=Instance.new("TextLabel",infoCard);infoLbl.Size=UDim2.new(1,-16,1,0);infoLbl.Position=UDim2.new(0,8,0,0);infoLbl.BackgroundTransparency=1;infoLbl.Text="Configler sadece bu cihaza kaydedilir.";infoLbl.TextColor3=Tc.TextDim;infoLbl.Font=Enum.Font.Gotham;infoLbl.TextSize=12;infoLbl.TextXAlignment=Enum.TextXAlignment.Left
    y=y+44
    y=buildSection(sc,T("cfg_save"),y)
    local nameBox;nameBox,y=buildInput(sc,T("cfg_name"),"benim-config","",y)
    local saveBtn;saveBtn,y=buildButton(sc,T("cfg_save"),y,Tc.KeyGreen,Color3.new(1,1,1))
    local res=Instance.new("TextLabel",sc);res.Size=UDim2.new(1,-28,0,28);res.Position=UDim2.new(0,14,0,y);res.BackgroundTransparency=1;res.Font=Enum.Font.GothamMedium;res.TextSize=13;res.TextXAlignment=Enum.TextXAlignment.Left;res.TextWrapped=true;y=y+36
    saveBtn.MouseButton1Click:Connect(function()
        local n=nameBox.Text:gsub("[^%w%-_]",""):lower()
        if n=="" then res.Text=T("cfg_enter_name");res.TextColor3=Tc.KeyRed;return end
        if saveLocalConfig(n) then res.Text=T("cfg_saved").." ("..n..")";res.TextColor3=Tc.KeyGreen;task.wait(0.5);switchTab("CONFIG")
        else res.Text=T("cfg_fail");res.TextColor3=Tc.KeyRed end
    end)
    y=buildSection(sc,"Kayıtlı Configler",y+4)
    local configs=listLocalConfigs()
    if #configs==0 then
        local el=Instance.new("TextLabel",sc);el.Size=UDim2.new(1,-28,0,28);el.Position=UDim2.new(0,14,0,y);el.BackgroundTransparency=1;el.Text=T("cfg_no_configs");el.TextColor3=Tc.TextFaint;el.Font=Enum.Font.GothamMedium;el.TextSize=13;el.TextXAlignment=Enum.TextXAlignment.Left
    else
        for _,cfgName in ipairs(configs) do
            local row=Instance.new("Frame",sc);row.Size=UDim2.new(1,-28,0,44);row.Position=UDim2.new(0,14,0,y);row.BackgroundColor3=Tc.Card;corner(8,row)
            local nl=Instance.new("TextLabel",row);nl.Size=UDim2.new(1,-160,1,0);nl.Position=UDim2.new(0,12,0,0);nl.BackgroundTransparency=1;nl.Text=cfgName;nl.TextColor3=Tc.Text;nl.Font=Enum.Font.GothamSemibold;nl.TextSize=13;nl.TextXAlignment=Enum.TextXAlignment.Left
            local function mkB(txt,col,xOff) local b=Instance.new("TextButton",row);b.Size=UDim2.new(0,46,0,28);b.Position=UDim2.new(1,xOff,0.5,-14);b.BackgroundColor3=col;b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextSize=11;b.Text=txt;corner(6,b);return b end
            local lb=mkB(T("cfg_load"),Tc.KeyGreen,-152)
            local db=mkB(T("cfg_delete"),Tc.KeyRed,-98)
            lb.MouseButton1Click:Connect(function()
                if loadLocalConfig(cfgName) then buildCrosshair();res.Text=T("cfg_loaded").." ("..cfgName..")";res.TextColor3=Tc.KeyGreen
                else res.Text=T("cfg_fail");res.TextColor3=Tc.KeyRed end
            end)
            db.MouseButton1Click:Connect(function() deleteLocalConfig(cfgName);res.Text=T("cfg_deleted");res.TextColor3=Tc.TextDim;task.wait(0.3);switchTab("CONFIG") end)
            y=y+52
        end
    end
end

tabBuilders["SETTINGS"]=function(p)
    local sc=makeScroll(p);local y=10
    -- Dil
    y=buildSection(sc,T("sec_lang"),y)
    local langRow=Instance.new("Frame",sc);langRow.Size=UDim2.new(1,-28,0,44);langRow.Position=UDim2.new(0,14,0,y);langRow.BackgroundColor3=Tc.Card;corner(8,langRow)
    local langLbl=Instance.new("TextLabel",langRow);langLbl.Size=UDim2.new(0.5,0,1,0);langLbl.Position=UDim2.new(0,12,0,0);langLbl.BackgroundTransparency=1;langLbl.Text="Language / Dil";langLbl.TextColor3=Tc.Text;langLbl.Font=Enum.Font.GothamMedium;langLbl.TextSize=14;langLbl.TextXAlignment=Enum.TextXAlignment.Left
    local langBtn=Instance.new("TextButton",langRow);langBtn.Size=UDim2.new(0,110,0,30);langBtn.Position=UDim2.new(1,-124,0.5,-15);langBtn.BackgroundColor3=Tc.AccentFaint;langBtn.TextColor3=Tc.Text;langBtn.Font=Enum.Font.GothamBold;langBtn.TextSize=13;langBtn.Text=LANG=="TR" and "TR Turkce" or "EN English";corner(6,langBtn)
    langBtn.MouseButton1Click:Connect(function()
        LANG=LANG=="TR" and "EN" or "TR"
        langBtn.Text=LANG=="TR" and "TR Turkce" or "EN English"
        task.wait(0.2);rebuildMenu()
    end)
    y=y+52
    -- Tema
    y=buildSection(sc,T("sec_theme"),y)
    local themeGrid=Instance.new("Frame",sc);themeGrid.Size=UDim2.new(1,-28,0,0);themeGrid.AutomaticSize=Enum.AutomaticSize.Y;themeGrid.Position=UDim2.new(0,14,0,y);themeGrid.BackgroundTransparency=1
    local tgLayout=Instance.new("UIGridLayout",themeGrid);tgLayout.CellSize=UDim2.new(0,100,0,56);tgLayout.CellPadding=UDim2.new(0,6,0,6);tgLayout.SortOrder=Enum.SortOrder.LayoutOrder
    for i,theme in ipairs(THEMES) do
        local acCol=theme.rainbow and Color3.fromRGB(255,100,100) or Color3.fromRGB(theme.ac[1],theme.ac[2],theme.ac[3])
        local bgCol=Color3.fromRGB(theme.bg[1],theme.bg[2],theme.bg[3])
        local btn=Instance.new("TextButton",themeGrid);btn.BackgroundColor3=bgCol;btn.BorderSizePixel=0;btn.Text="";btn.LayoutOrder=i;corner(8,btn)
        local accentBar=Instance.new("Frame",btn);accentBar.Size=UDim2.new(1,0,0,4);accentBar.BackgroundColor3=acCol;accentBar.BorderSizePixel=0
        local corner3=Instance.new("UICorner",accentBar);corner3.CornerRadius=UDim.new(0,4)
        local nameLbl2=Instance.new("TextLabel",btn);nameLbl2.Size=UDim2.new(1,0,1,-4);nameLbl2.Position=UDim2.new(0,0,0,4);nameLbl2.BackgroundTransparency=1;nameLbl2.Text=theme.name;nameLbl2.TextColor3=acCol;nameLbl2.Font=Enum.Font.GothamBold;nameLbl2.TextSize=12
        if i==currentTheme then
            local sel=Instance.new("UIStroke",btn);sel.Color=acCol;sel.Thickness=2
        end
        if theme.rainbow then
            task.spawn(function()
                while btn and btn.Parent do
                    local rb=hsvToRgb(rainbowHue,1,1)
                    accentBar.BackgroundColor3=rb;nameLbl2.TextColor3=rb
                    task.wait(0.05)
                end
            end)
        end
        btn.MouseButton1Click:Connect(function()
            currentTheme=i
            Tc=makeTc()
            task.wait(0.1);rebuildMenu()
        end)
    end
    y=y+200
    -- Hakkinda
    y=buildSection(sc,T("sec_about"),y)
    local aboutCard=Instance.new("Frame",sc);aboutCard.Size=UDim2.new(1,-28,0,0);aboutCard.AutomaticSize=Enum.AutomaticSize.Y;aboutCard.Position=UDim2.new(0,14,0,y);aboutCard.BackgroundColor3=Tc.Card;corner(8,aboutCard)
    local aLbl2=Instance.new("TextLabel",aboutCard);aLbl2.Size=UDim2.new(1,-16,0,0);aLbl2.AutomaticSize=Enum.AutomaticSize.Y;aLbl2.Position=UDim2.new(0,8,0,8);aLbl2.BackgroundTransparency=1
    aLbl2.Text="SUSANO V2.0\n\nESP (2D/3D/Skeleton/Chams), Aimbot, Rage Aimbot, Silent Aim, Hitbox, Fake Lag, Fly, Noclip, Speed, BunnyHop, LongJump, Gravity Hack, Cursor TP, Kill Aura, Anti AFK, Name Spoof, Full Bright, No Fog, FOV Changer, 3rd Person, Time Changer, World Color, Server Hop, Auto Rejoin, FPS Boost, Chat Logger, MiniMap, Config (Local), 9 Tema, TR/EN Dil, Webhook\n\nF5 - Menu Ac/Kapat | Sag Tik - Cursor TP"
    aLbl2.TextColor3=Tc.TextDim;aLbl2.Font=Enum.Font.Gotham;aLbl2.TextSize=12;aLbl2.TextWrapped=true;aLbl2.TextXAlignment=Enum.TextXAlignment.Left
    local aPad=Instance.new("UIPadding",aboutCard);aPad.PaddingBottom=UDim.new(0,10)
end

-- MAIN MENU
local MainFrame,SideBar,Content
local currentTab="ESP";local menuBuilt=false;local minimized=false
local MENU_FULL=UDim2.new(0,920,0,660);local MENU_MINI=UDim2.new(0,920,0,46)
local sideButtons={}

local function getTabs()
    return {
        {id="ESP",       icon="E", label=T("tab_esp")},
        {id="AIMBOT",    icon="A", label=T("tab_aimbot")},
        {id="MOVEMENT",  icon="M", label=T("tab_move")},
        {id="PLAYERS",   icon="P", label=T("tab_players")},
        {id="VISUAL",    icon="V", label=T("tab_visual")},
        {id="MISC",      icon="U", label=T("tab_misc")},
        {id="CONFIG",    icon="C", label=T("tab_config")},
        {id="SETTINGS",  icon="S", label=T("tab_settings")},
    }
end

switchTab=function(id)
    currentTab=id
    for _,btn in ipairs(sideButtons) do
        local active=btn:GetAttribute("tabId")==id
        tw(btn,0.15,{BackgroundColor3=active and Tc.ActiveSide or Tc.InactiveSide})
        local il=btn:FindFirstChild("IL");local nl=btn:FindFirstChild("NL")
        if il then tw(il,0.15,{TextColor3=active and Tc.BG or Tc.TextFaint}) end
        if nl then tw(nl,0.15,{TextColor3=active and Tc.BG or Tc.TextDim}) end
    end
    for _,c in ipairs(Content:GetChildren()) do c:Destroy() end
    Content.BackgroundTransparency=0.15;tw(Content,0.12,{BackgroundTransparency=1})
    local builder=tabBuilders[id];if builder then builder(Content) end
end

createMenu=function()
    if MainGui then pcall(function() MainGui:Destroy() end) end
    MainGui=makeGui("SusanoUI",200);MainGui.Enabled=true
    Tc=makeTc()

    MainFrame=Instance.new("Frame",MainGui);MainFrame.Size=MENU_FULL;MainFrame.Position=UDim2.new(0.5,-460,0.5,-330);MainFrame.BackgroundColor3=Tc.BG;MainFrame.Active=true;corner(10,MainFrame)
    local iBorder=Instance.new("UIStroke",MainFrame);iBorder.Color=Tc.Accent;iBorder.Thickness=1;iBorder.Transparency=0.6
    for _,sd in ipairs({{4,3,0.82},{12,6,0.88},{22,10,0.94}}) do local s=Instance.new("Frame",MainFrame);s.Size=UDim2.new(1,sd[1],1,sd[1]);s.Position=UDim2.new(0,-sd[1]/2,0,sd[2]);s.BackgroundColor3=Color3.new(0,0,0);s.BackgroundTransparency=sd[3];s.ZIndex=MainFrame.ZIndex-1;s.BorderSizePixel=0;corner(15,s) end

    -- Title bar
    local tb=Instance.new("Frame",MainFrame);tb.Size=UDim2.new(1,0,0,46);tb.BackgroundColor3=Tc.TitleBar;tb.BorderSizePixel=0;tb.ClipsDescendants=true;corner(10,tb)
    local tbFix=Instance.new("Frame",tb);tbFix.Size=UDim2.new(1,0,0.5,0);tbFix.Position=UDim2.new(0,0,0.5,0);tbFix.BackgroundColor3=Tc.TitleBar;tbFix.BorderSizePixel=0
    local titleLine=Instance.new("Frame",tb);titleLine.Size=UDim2.new(1,0,0,1);titleLine.Position=UDim2.new(0,0,1,-1);titleLine.BackgroundColor3=Tc.Accent;titleLine.BorderSizePixel=0;titleLine.BackgroundTransparency=0.7
    local logoTxt=Instance.new("TextLabel",tb);logoTxt.Size=UDim2.new(0,110,1,0);logoTxt.Position=UDim2.new(0,16,0,0);logoTxt.BackgroundTransparency=1;logoTxt.Text="SUSANO";logoTxt.TextColor3=Tc.Accent;logoTxt.Font=Enum.Font.GothamBlack;logoTxt.TextSize=20;logoTxt.TextXAlignment=Enum.TextXAlignment.Left
    local verTxt=Instance.new("TextLabel",tb);verTxt.Size=UDim2.new(0,40,1,0);verTxt.Position=UDim2.new(0,120,0,0);verTxt.BackgroundTransparency=1;verTxt.Text="v2.0";verTxt.TextColor3=Tc.TextFaint;verTxt.Font=Enum.Font.GothamMedium;verTxt.TextSize=11;verTxt.TextXAlignment=Enum.TextXAlignment.Left
    local kBadge=Instance.new("Frame",tb);kBadge.Size=UDim2.new(0,80,0,22);kBadge.Position=UDim2.new(0,168,0.5,-11);kBadge.BackgroundColor3=keyType=="lifetime" and Tc.KeyGold or(keyType=="monthly" and Color3.fromRGB(180,120,255) or(keyType=="weekly" and Color3.fromRGB(80,180,255) or Tc.AccentFaint));corner(5,kBadge)
    local kBL=Instance.new("TextLabel",kBadge);kBL.Size=UDim2.new(1,0,1,0);kBL.BackgroundTransparency=1;kBL.TextColor3=Color3.new(1,1,1);kBL.Font=Enum.Font.GothamBold;kBL.TextSize=11;local kn={daily=T("type_daily"),weekly=T("type_weekly"),monthly=T("type_monthly"),lifetime=T("type_lifetime")};kBL.Text=kn[keyType] or keyType:upper()
    local timeLbl=Instance.new("TextLabel",tb);timeLbl.Size=UDim2.new(0,120,1,0);timeLbl.Position=UDim2.new(0,256,0,0);timeLbl.BackgroundTransparency=1;timeLbl.TextColor3=Tc.TextFaint;timeLbl.Font=Enum.Font.GothamMedium;timeLbl.TextSize=10;timeLbl.TextXAlignment=Enum.TextXAlignment.Left;timeLbl.Text=formatTimeLeft(keyExpires)
    task.spawn(function() while MainGui and MainGui.Parent do timeLbl.Text=formatTimeLeft(keyExpires);task.wait(60) end end)
    local hotkeyTxt=Instance.new("TextLabel",tb);hotkeyTxt.Size=UDim2.new(0,80,1,0);hotkeyTxt.Position=UDim2.new(0.5,-40,0,0);hotkeyTxt.BackgroundTransparency=1;hotkeyTxt.Text="F5";hotkeyTxt.TextColor3=Tc.TextFaint;hotkeyTxt.Font=Enum.Font.GothamMedium;hotkeyTxt.TextSize=11

    -- Rainbow accent animation
    if THEMES[currentTheme].rainbow then
        task.spawn(function()
            while MainGui and MainGui.Parent and THEMES[currentTheme].rainbow do
                rainbowHue=(rainbowHue+0.002)%1
                local rb=hsvToRgb(rainbowHue,1,1)
                Tc.Accent=rb;Tc.ActiveSide=rb
                pcall(function() logoTxt.TextColor3=rb end)
                pcall(function() titleLine.BackgroundColor3=rb end)
                pcall(function() iBorder.Color=rb end)
                pcall(function() kBadge.BackgroundColor3=rb end)
                task.wait(0.05)
            end
        end)
    end

    local function mkTBtn(text,bgCol,xOff) local btn=Instance.new("TextButton",tb);btn.Size=UDim2.new(0,28,0,28);btn.Position=UDim2.new(1,xOff,0.5,-14);btn.BackgroundColor3=bgCol;btn.TextColor3=Color3.new(1,1,1);btn.Font=Enum.Font.GothamBold;btn.TextSize=15;btn.Text=text;corner(6,btn);return btn end
    local closeBtn=mkTBtn("x",Tc.CloseRed,-36)
    closeBtn.MouseEnter:Connect(function() tw(closeBtn,0.1,{BackgroundColor3=Color3.fromRGB(220,70,70)}) end)
    closeBtn.MouseLeave:Connect(function() tw(closeBtn,0.1,{BackgroundColor3=Tc.CloseRed}) end)
    closeBtn.MouseButton1Click:Connect(function() tw(MainFrame,0.18,{BackgroundTransparency=1});task.wait(0.2);MainGui.Enabled=false;MainFrame.BackgroundTransparency=0 end)
    local minBtn=mkTBtn("-",Tc.MinBtn,-70)
    minBtn.MouseButton1Click:Connect(function() minimized=not minimized;tw(MainFrame,0.2,{Size=minimized and MENU_MINI or MENU_FULL});task.wait(0.05);SideBar.Visible=not minimized;Content.Visible=not minimized end)

    -- Sidebar
    SideBar=Instance.new("Frame",MainFrame);SideBar.Size=UDim2.new(0,180,1,-46);SideBar.Position=UDim2.new(0,0,0,46);SideBar.BackgroundColor3=Tc.Sidebar;SideBar.BorderSizePixel=0;corner(10,SideBar)
    local sbFix=Instance.new("Frame",SideBar);sbFix.Size=UDim2.new(1,0,0.5,0);sbFix.BackgroundColor3=Tc.Sidebar;sbFix.BorderSizePixel=0
    local sideDiv=Instance.new("Frame",MainFrame);sideDiv.Size=UDim2.new(0,1,1,-46);sideDiv.Position=UDim2.new(0,180,0,46);sideDiv.BackgroundColor3=Tc.Accent;sideDiv.BorderSizePixel=0;sideDiv.BackgroundTransparency=0.8

    sideButtons={}
    local TABS=getTabs()
    for i,tab in ipairs(TABS) do
        local isActive=tab.id==currentTab
        local btn=Instance.new("TextButton",SideBar);btn.Size=UDim2.new(1,-14,0,36);btn.Position=UDim2.new(0,7,0,4+(i-1)*40);btn.BackgroundColor3=isActive and Tc.ActiveSide or Tc.InactiveSide;btn.AutoButtonColor=false;btn.BorderSizePixel=0;btn.Text="";corner(7,btn);btn:SetAttribute("tabId",tab.id)
        if isActive then
            local al=Instance.new("Frame",btn);al.Size=UDim2.new(0,3,1,-8);al.Position=UDim2.new(0,2,0,4);al.BackgroundColor3=Tc.BG;al.BorderSizePixel=0;corner(2,al)
        end
        local iL=Instance.new("TextLabel",btn);iL.Name="IL";iL.Size=UDim2.new(0,28,1,0);iL.Position=UDim2.new(0,8,0,0);iL.BackgroundTransparency=1;iL.Text=tab.icon;iL.TextColor3=isActive and Tc.BG or Tc.TextFaint;iL.Font=Enum.Font.GothamBold;iL.TextSize=12
        local nL=Instance.new("TextLabel",btn);nL.Name="NL";nL.Size=UDim2.new(1,-40,1,0);nL.Position=UDim2.new(0,38,0,0);nL.BackgroundTransparency=1;nL.Text=tab.label;nL.TextColor3=isActive and Tc.BG or Tc.TextDim;nL.Font=Enum.Font.GothamSemibold;nL.TextSize=13;nL.TextXAlignment=Enum.TextXAlignment.Left
        btn.MouseEnter:Connect(function() if btn:GetAttribute("tabId")~=currentTab then tw(btn,0.1,{BackgroundColor3=Tc.CardHov}) end end)
        btn.MouseLeave:Connect(function() if btn:GetAttribute("tabId")~=currentTab then tw(btn,0.1,{BackgroundColor3=Tc.InactiveSide}) end end)
        btn.MouseButton1Click:Connect(function() switchTab(tab.id) end)
        table.insert(sideButtons,btn)
    end

    Content=Instance.new("Frame",MainFrame);Content.Size=UDim2.new(1,-181,1,-46);Content.Position=UDim2.new(0,181,0,46);Content.BackgroundTransparency=1;Content.ClipsDescendants=true

    -- Drag
    local dragging,dragStart,startPos=false;tb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true;dragStart=i.Position;startPos=MainFrame.Position;i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end) end end);local dragInput;tb.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then dragInput=i end end);UserInputService.InputChanged:Connect(function(i) if dragging and i==dragInput then local d=i.Position-dragStart;MainFrame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)

    -- Resize
    local rH=Instance.new("Frame",MainFrame);rH.Size=UDim2.new(0,12,0,12);rH.Position=UDim2.new(1,-12,1,-12);rH.BackgroundTransparency=1
    local rD=Instance.new("Frame",rH);rD.Size=UDim2.new(0,4,0,4);rD.Position=UDim2.new(1,-4,1,-4);rD.BackgroundColor3=Tc.Accent;rD.BackgroundTransparency=0.5;corner(2,rD)
    local resizing,resStart,resStartSz=false;rH.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then resizing=true;resStart=i.Position;resStartSz=Vector2.new(MainFrame.AbsoluteSize.X,MainFrame.AbsoluteSize.Y);i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then resizing=false end end) end end);local resInput;rH.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then resInput=i end end);UserInputService.InputChanged:Connect(function(i) if resizing and i==resInput then local d=i.Position-resStart;MainFrame.Size=UDim2.new(0,math.clamp(resStartSz.X+d.X,600,1400),0,math.clamp(resStartSz.Y+d.Y,400,900));SideBar.Size=UDim2.new(0,180,1,-46);Content.Size=UDim2.new(1,-181,1,-46) end end)

    menuBuilt=true;local ep=MainFrame.Position;MainFrame.Position=ep+UDim2.new(0,0,0,14);MainFrame.BackgroundTransparency=1;tw(MainFrame,0.22,{BackgroundTransparency=0,Position=ep});switchTab(currentTab)
end

rebuildMenu=function()
    menuBuilt=false;createMenu()
end

-- KEY MENU
local keyMenuGui=makeGui("SusanoKeyMenu",999)
local function buildKeyMenu(onSuccess)
    local overlay=Instance.new("Frame",keyMenuGui);overlay.Size=UDim2.new(1,0,1,0);overlay.BackgroundColor3=Color3.fromRGB(5,5,5);overlay.BackgroundTransparency=0;overlay.BorderSizePixel=0
    local card=Instance.new("Frame",keyMenuGui);card.Size=UDim2.new(0,460,0,480);card.Position=UDim2.new(0.5,-230,0.5,-240);card.BackgroundColor3=Tc.BG;card.BorderSizePixel=0;corner(12,card)
    Instance.new("UIStroke",card).Color=Tc.BorderLight
    local topBar=Instance.new("Frame",card);topBar.Size=UDim2.new(1,0,0,52);topBar.BackgroundColor3=Tc.TitleBar;topBar.BorderSizePixel=0;topBar.ClipsDescendants=true;corner(12,topBar)
    local tbFix2=Instance.new("Frame",topBar);tbFix2.Size=UDim2.new(1,0,0.5,0);tbFix2.Position=UDim2.new(0,0,0.5,0);tbFix2.BackgroundColor3=Tc.TitleBar;tbFix2.BorderSizePixel=0
    local tL=Instance.new("TextLabel",topBar);tL.Size=UDim2.new(1,0,0.6,0);tL.BackgroundTransparency=1;tL.Text="SUSANO";tL.TextColor3=Tc.Accent;tL.Font=Enum.Font.GothamBlack;tL.TextSize=24
    local sL=Instance.new("TextLabel",topBar);sL.Size=UDim2.new(1,0,0.4,0);sL.Position=UDim2.new(0,0,0.6,0);sL.BackgroundTransparency=1;sL.Text="v2.0  -  Anahtarini gir";sL.TextColor3=Tc.TextFaint;sL.Font=Enum.Font.GothamMedium;sL.TextSize=11
    local profBg=Instance.new("Frame",card);profBg.Size=UDim2.new(1,-32,0,68);profBg.Position=UDim2.new(0,16,0,60);profBg.BackgroundColor3=Tc.Card;corner(10,profBg)
    local avF=Instance.new("Frame",profBg);avF.Size=UDim2.new(0,46,0,46);avF.Position=UDim2.new(0,10,0.5,-23);avF.BackgroundColor3=Tc.AccentFaint;corner(23,avF)
    pcall(function() local img=Instance.new("ImageLabel",avF);img.Size=UDim2.new(1,0,1,0);img.BackgroundTransparency=1;corner(23,img);img.Image=Players:GetUserThumbnailAsync(LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150) end)
    local info=Instance.new("Frame",profBg);info.Size=UDim2.new(1,-66,1,0);info.Position=UDim2.new(0,62,0,0);info.BackgroundTransparency=1
    local function iLk(y,t,c,s) local l=Instance.new("TextLabel",info);l.Size=UDim2.new(1,0,0,17);l.Position=UDim2.new(0,0,0,y);l.BackgroundTransparency=1;l.Text=t;l.TextColor3=c;l.Font=Enum.Font.GothamMedium;l.TextSize=s;l.TextXAlignment=Enum.TextXAlignment.Left end
    iLk(6,"@"..USERNAME,Tc.Text,14);iLk(24,"HWID: "..HWID:sub(1,22).."...",Tc.TextFaint,10);iLk(40,"UID: "..USER_ID,Tc.TextFaint,10)
    local inLbl=Instance.new("TextLabel",card);inLbl.Size=UDim2.new(1,-32,0,16);inLbl.Position=UDim2.new(0,16,0,140);inLbl.BackgroundTransparency=1;inLbl.Text="ANAHTAR";inLbl.TextColor3=Tc.TextFaint;inLbl.Font=Enum.Font.GothamBold;inLbl.TextSize=10;inLbl.TextXAlignment=Enum.TextXAlignment.Left
    local inputBox=Instance.new("TextBox",card);inputBox.Size=UDim2.new(1,-32,0,44);inputBox.Position=UDim2.new(0,16,0,158);inputBox.BackgroundColor3=Tc.Card;inputBox.TextColor3=Tc.Text;inputBox.Font=Enum.Font.GothamMedium;inputBox.TextSize=15;inputBox.PlaceholderText="SUSANO-XXXX-XXXX-XXXX";inputBox.PlaceholderColor3=Tc.TextFaint;inputBox.Text="";inputBox.ClearTextOnFocus=false;inputBox.BorderSizePixel=0;corner(8,inputBox)
    local ibStroke=Instance.new("UIStroke",inputBox);ibStroke.Color=Tc.BorderLight;ibStroke.Thickness=1
    local statusLbl=Instance.new("TextLabel",card);statusLbl.Size=UDim2.new(1,-32,0,20);statusLbl.Position=UDim2.new(0,16,0,208);statusLbl.BackgroundTransparency=1;statusLbl.Text="";statusLbl.Font=Enum.Font.GothamMedium;statusLbl.TextSize=13;statusLbl.TextXAlignment=Enum.TextXAlignment.Left
    local remRow=Instance.new("Frame",card);remRow.Size=UDim2.new(1,-32,0,28);remRow.Position=UDim2.new(0,16,0,234);remRow.BackgroundTransparency=1
    local remLbl2=Instance.new("TextLabel",remRow);remLbl2.Size=UDim2.new(0.78,0,1,0);remLbl2.BackgroundTransparency=1;remLbl2.Text=T("key_remember");remLbl2.TextColor3=Tc.TextDim;remLbl2.Font=Enum.Font.GothamMedium;remLbl2.TextSize=13;remLbl2.TextXAlignment=Enum.TextXAlignment.Left
    local remOn=true;local remPill=Instance.new("Frame",remRow);remPill.Size=UDim2.new(0,44,0,22);remPill.Position=UDim2.new(1,-44,0.5,-11);remPill.BackgroundColor3=Tc.OnBG;corner(22,remPill)
    local remKnob=Instance.new("Frame",remPill);remKnob.Size=UDim2.new(0,16,0,16);remKnob.Position=UDim2.new(1,-19,0.5,-8);remKnob.BackgroundColor3=Tc.TitleBar;corner(100,remKnob)
    local remBtn=Instance.new("TextButton",remRow);remBtn.Size=UDim2.new(1,0,1,0);remBtn.BackgroundTransparency=1;remBtn.Text=""
    remBtn.MouseButton1Click:Connect(function() remOn=not remOn;tw(remPill,0.18,{BackgroundColor3=remOn and Tc.OnBG or Tc.OffBG});tw(remKnob,0.18,{Position=UDim2.new(remOn and 1 or 0,remOn and -19 or 3,0.5,-8)}) end)
    local activateBtn=Instance.new("TextButton",card);activateBtn.Size=UDim2.new(1,-32,0,44);activateBtn.Position=UDim2.new(0,16,0,270);activateBtn.BackgroundColor3=Tc.Accent;activateBtn.TextColor3=Tc.BG;activateBtn.Font=Enum.Font.GothamBold;activateBtn.TextSize=16;activateBtn.Text=T("key_btn");corner(8,activateBtn)
    local footLbl2=Instance.new("TextLabel",card);footLbl2.Size=UDim2.new(1,-32,0,18);footLbl2.Position=UDim2.new(0,16,0,322);footLbl2.BackgroundTransparency=1;footLbl2.Text="Susano V2.0  |  Discord";footLbl2.TextColor3=Tc.TextFaint;footLbl2.Font=Enum.Font.GothamMedium;footLbl2.TextSize=11
    local attempts=0;local busy=false
    local function tryActivate()
        if busy then return end
        local key=inputBox.Text:upper():gsub("%s+","")
        if key=="" then statusLbl.Text=T("key_enter_key");statusLbl.TextColor3=Tc.KeyRed;return end
        busy=true;statusLbl.Text="Dogrulanıyor...";statusLbl.TextColor3=Tc.TextDim;activateBtn.Text=T("key_checking");activateBtn.BackgroundColor3=Tc.AccentFaint
        validateKey(key,function(ok,result,expires)
            busy=false;activateBtn.Text=T("key_btn");activateBtn.BackgroundColor3=Tc.Accent
            if ok then
                if remOn then safeWrite(KEY_FILE,key) end
                activeKey=key;keyExpires=expires
                statusLbl.Text=T("key_valid");statusLbl.TextColor3=Tc.KeyGreen
                tw(activateBtn,0.2,{BackgroundColor3=Tc.KeyGreen});tw(ibStroke,0.2,{Color=Tc.KeyGreen})
                task.wait(0.8);tw(card,0.25,{BackgroundTransparency=1});tw(overlay,0.25,{BackgroundTransparency=1})
                task.wait(0.3);keyMenuGui:Destroy();keyValidated=true;keyType=result;_G.Verified=true;onSuccess(result)
            else
                attempts=attempts+1;statusLbl.Text=tostring(result).." ("..attempts..")";statusLbl.TextColor3=Tc.KeyRed
                tw(ibStroke,0.1,{Color=Tc.KeyRed});task.wait(0.25);tw(ibStroke,0.3,{Color=Tc.BorderLight})
                if attempts>=5 then statusLbl.Text=T("key_too_many");task.wait(1.5);keyMenuGui:Destroy() end
            end
        end)
    end
    activateBtn.MouseButton1Click:Connect(tryActivate)
    inputBox.FocusLost:Connect(function(enter) if enter then tryActivate() end end)
    task.spawn(function() task.wait(0.1);pcall(function() inputBox:CaptureFocus() end) end)
    card.BackgroundTransparency=1;card.Position=UDim2.new(0.5,-230,0.5,-230)
    tw(card,0.18,{BackgroundTransparency=0,Position=UDim2.new(0.5,-230,0.5,-240)})
end

-- RESPAWN
LocalPlayer.CharacterAdded:Connect(function()
    task.spawn(function()
        task.wait(0.5)
        if _G.FlyEnabled then enableFly() end
        if _G.NoClipEnabled then enableNoclip() end
        if _G.BunnyHop then enableBhop() end
        if _G.SpeedHack then enableSpeed() end
        if _G.InfiniteJump then enableInfiniteJump() end
        if _G.LongJump then enableLongJump() end
        if _G.SwimHack then enableSwimHack() end
        if _G.NameSpoof then applyNameSpoof() end
        if _G.KillAura then enableKillAura() end
        if _G.HitboxEnabled then enableHitbox() end
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

-- TELEPORT CURSOR BASLAT
enableTeleportCursor()
enableSwimHack()
enableAutoRejoin()

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    if not _G.Verified then return end
    -- Rainbow update
    if THEMES[currentTheme] and THEMES[currentTheme].rainbow then
        rainbowHue=(rainbowHue+0.002)%1
    end
    -- ESP
    if _G.ESP then
        pcall(updateESP)
        for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and not espCache[p] and p.Character then buildESP(p) end end
    else clearAllESP() end
    pcall(updateSkeleton)
    -- Aimbot
    if _G.Aimbot and not _G.RageAimbot then
        local t=getBestTarget()
        if t then local cf=CFrame.new(Camera.CFrame.Position,t.part.Position);Camera.CFrame=Camera.CFrame:Lerp(cf,_G.AimbotSmoothness);aimTarget=t.part;updateFOVColor(Color3.fromRGB(80,255,120))
        else aimTarget=nil;updateFOVColor(Color3.new(1,1,1)) end
    elseif not _G.RageAimbot then aimTarget=nil;updateFOVColor(Color3.new(1,1,1)) end
    -- FOV circle
    if FOVCircle then local r=_G.FOVSize;FOVCircle.Size=UDim2.new(0,r*2,0,r*2);FOVCircle.Position=UDim2.new(0.5,-r,0.5,-r);FOVCircle.Visible=_G.FOVVisible and(_G.Aimbot or _G.RageAimbot or _G.SilentAim) end
    -- Feature toggles
    if _G.FlyEnabled and not flying then enableFly() elseif not _G.FlyEnabled and flying then disableFly() end
    if _G.NoClipEnabled and not ncActive then enableNoclip() elseif not _G.NoClipEnabled and ncActive then disableNoclip() end
    if _G.BunnyHop and not bhopActive then enableBhop() elseif not _G.BunnyHop and bhopActive then disableBhop() end
    if _G.SpeedHack and not spdActive then enableSpeed() elseif not _G.SpeedHack and spdActive then disableSpeed() end
    if _G.RageAimbot and not rageActive then enableRageAimbot() elseif not _G.RageAimbot and rageActive then disableRageAimbot() end
    if _G.SilentAim and not silentAimActive then enableSilentAim() elseif not _G.SilentAim and silentAimActive then disableSilentAim() end
    if _G.InfiniteJump and not ijConn then enableInfiniteJump() elseif not _G.InfiniteJump and ijConn then disableInfiniteJump() end
    if _G.LongJump and not ljConn then enableLongJump() elseif not _G.LongJump and ljConn then disableLongJump() end
    if _G.KillAura and not killAuraConn then enableKillAura() elseif not _G.KillAura and killAuraConn then disableKillAura() end
    if _G.AntiAFK and not afkConn then enableAntiAFK() elseif not _G.AntiAFK and afkConn then disableAntiAFK() end
    if _G.ThirdPerson and not tpConn then enableThirdPerson() elseif not _G.ThirdPerson and tpConn then disableThirdPerson() end
    if _G.HitboxEnabled and not hitboxConn then enableHitbox() elseif not _G.HitboxEnabled and hitboxConn then disableHitbox() end
    if _G.FakeLag and not fakeLagConn then enableFakeLag() elseif not _G.FakeLag and fakeLagConn then disableFakeLag() end
    if _G.GravityHack then Workspace.Gravity=_G.GravityValue else Workspace.Gravity=196.2 end
    if _G.FullBright then applyFullBright(true) end
    if _G.NoFog then applyNoFog(true) end
    if _G.FOVChanger then Camera.FieldOfView=_G.FOVChangerVal end
    if _G.TimeChanger then applyTime(true) end
    if _G.WorldColor then applyWorldColor(true) end
    if _G.MiniMap and not mmGui then enableMiniMap() elseif not _G.MiniMap and mmGui then disableMiniMap() end
    if _G.ChatLogger and not chatLogGui then enableChatLogger() elseif not _G.ChatLogger and chatLogGui then disableChatLogger() end
end)

-- BASLANGIC
safeMakeFolder(CONFIG_FOLDER)
local savedKey=loadSavedKey()
if savedKey then
    validateKey(savedKey,function(ok,result,expires)
        if ok then
            keyValidated=true;keyType=result;keyExpires=expires;_G.Verified=true;activeKey=savedKey
            keyMenuGui:Destroy();createFOVCircle()
            task.spawn(function() task.wait(0.05);createMenu() end)
        else
            safeDel(KEY_FILE)
            buildKeyMenu(function()
                createFOVCircle()
                task.spawn(function() task.wait(0.05);createMenu() end)
            end)
        end
    end)
else
    buildKeyMenu(function()
        createFOVCircle()
        task.spawn(function() task.wait(0.05);createMenu() end)
    end)
end
