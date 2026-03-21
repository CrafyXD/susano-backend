local t1="ghp_wG4l"
local t2="OHjlmUvwum"
local t3="ObSMZlppNaGyMq3H3JtpiC"

local CFG={
    GITHUB_TOKEN=t1..t2..t3,
    GITHUB_OWNER="CrafyXD",
    GITHUB_REPO="susano-backend",
    GITHUB_BRANCH="main",
    GIST_TOKEN=t1..t2..t3,
}

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

-- GUI Parent - her executor'da çalışır
local GuiParent
pcall(function()
    local pg=LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pg then GuiParent=pg end
end)
if not GuiParent then
    GuiParent=LocalPlayer:WaitForChild("PlayerGui",10)
end

local sethiddenproperty=sethiddenproperty or function()end
local setnetworkowner=setnetworkowner or function(p,pl) pcall(function() sethiddenproperty(p,"NetworkOwnership",pl==LocalPlayer and 0 or 1) end) end

-- HWID
local HWID=tostring(LocalPlayer.UserId)
pcall(function() HWID=tostring(game:GetService("RbxAnalyticsService"):GetClientId()) end)
local USERNAME=LocalPlayer.Name
local USER_ID=tostring(LocalPlayer.UserId)

-- File helpers
local KEY_FILE="susano_key.txt"
local function safeRead(path) if readfile then return pcall(readfile,path) end;return false,nil end
local function safeWrite(path,d) if writefile then pcall(writefile,path,d) end end
local function safeDel(path) if delfile then pcall(delfile,path) end end

-- GitHub API
local function githubRead(path)
    local url=string.format("https://raw.githubusercontent.com/%s/%s/%s/%s",CFG.GITHUB_OWNER,CFG.GITHUB_REPO,CFG.GITHUB_BRANCH,path)
    local ok,resp=pcall(function()
        return (http_request or request)({Url=url,Method="GET"})
    end)
    if not ok or not resp or not resp.Success then return false,nil end
    return true,resp.Body
end

local function githubWrite(path,content,message)
    local shaUrl=string.format("https://api.github.com/repos/%s/%s/contents/%s",CFG.GITHUB_OWNER,CFG.GITHUB_REPO,path)
    local currentSHA=""
    pcall(function()
        local r=(http_request or request)({Url=shaUrl,Method="GET",Headers={["Authorization"]="token "..CFG.GITHUB_TOKEN,["Accept"]="application/vnd.github.v3+json",["User-Agent"]="Susano"}})
        if r.Success then
            local d=HttpService:JSONDecode(r.Body)
            if d and d.sha then currentSHA=d.sha end
        end
    end)
    local b64="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local function encode(data)
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
    local body=HttpService:JSONEncode({message=message or "update",content=encode(content),sha=currentSHA~="" and currentSHA or nil,branch=CFG.GITHUB_BRANCH})
    local ok,resp=pcall(function()
        return (http_request or request)({Url=shaUrl,Method="PUT",Headers={["Authorization"]="token "..CFG.GITHUB_TOKEN,["Accept"]="application/vnd.github.v3+json",["Content-Type"]="application/json",["User-Agent"]="Susano"},Body=body})
    end)
    return ok and resp and resp.Success
end

-- Gist
local function gistCreate(name,content)
    local body=HttpService:JSONEncode({description="Susano: "..name,public=false,files={[name..".json"]={content=content}}})
    local ok,resp=pcall(function() return (http_request or request)({Url="https://api.github.com/gists",Method="POST",Headers={["Authorization"]="token "..CFG.GIST_TOKEN,["Accept"]="application/vnd.github.v3+json",["Content-Type"]="application/json",["User-Agent"]="Susano"},Body=body}) end)
    if not ok or not resp or not resp.Success then return false,nil end
    local ok2,data=pcall(function() return HttpService:JSONDecode(resp.Body) end)
    if not ok2 or not data or not data.id then return false,nil end
    return true,data.id
end
local function gistRead(id)
    local ok,resp=pcall(function() return (http_request or request)({Url="https://api.github.com/gists/"..id,Method="GET",Headers={["Authorization"]="token "..CFG.GIST_TOKEN,["Accept"]="application/vnd.github.v3+json",["User-Agent"]="Susano"}}) end)
    if not ok or not resp or not resp.Success then return false,nil end
    local ok2,data=pcall(function() return HttpService:JSONDecode(resp.Body) end)
    if not ok2 or not data or not data.files then return false,nil end
    for _,f in pairs(data.files) do if f.content then local ok3,cfg=pcall(function() return HttpService:JSONDecode(f.content) end);if ok3 and cfg then return true,cfg end end end
    return false,nil
end
local function gistDelete(id)
    local ok,resp=pcall(function() return (http_request or request)({Url="https://api.github.com/gists/"..id,Method="DELETE",Headers={["Authorization"]="token "..CFG.GIST_TOKEN,["User-Agent"]="Susano"}}) end)
    return ok and resp and resp.StatusCode==204
end

-- Key system
local keyValidated=false;local keyType="none";local keyExpires=0;local activeKey=""

local function formatTimeLeft(exp)
    if exp==0 then return "SINIRSIZ" end
    local left=exp-os.time()
    if left<=0 then return "SÜRESİ DOLDU" end
    local d=math.floor(left/86400);local h=math.floor((left%86400)/3600);local m=math.floor((left%3600)/60)
    if d>0 then return d.."g "..h.."s kaldı" elseif h>0 then return h.."s "..m.."dk kaldı" else return m.."dk kaldı" end
end

local function loadKeys()
    local ok,body=githubRead("keys.json")
    if not ok or not body then return nil end
    local ok2,data=pcall(function() return HttpService:JSONDecode(body) end)
    if not ok2 then return nil end
    return data
end
local function saveKeys(data)
    local ok,json=pcall(function() return HttpService:JSONEncode(data) end)
    if not ok then return false end
    return githubWrite("keys.json",json,"hwid bind")
end

local function validateKey(key,callback)
    key=key:upper():gsub("%s+","")
    if key=="" then callback(false,"Anahtar gir",0);return end
    task.spawn(function()
        local keysData=loadKeys()
        if not keysData then callback(false,"Sunucuya bağlanılamadı",0);return end
        local kd=keysData[key]
        if not kd then callback(false,"Geçersiz anahtar",0);return end
        if kd.expires and kd.expires>0 and os.time()>kd.expires then callback(false,"Süresi dolmuş",0);return end
        if kd.hwid and kd.hwid~="" and kd.hwid~="null" then
            if kd.hwid~=HWID then callback(false,"Başka cihaza bağlı",0);return end
        else
            keysData[key].hwid=HWID
            task.spawn(function() saveKeys(keysData) end)
        end
        callback(true,kd.type or "lifetime",kd.expires or 0)
    end)
end

local function loadSavedKey()
    local ok,c=safeRead(KEY_FILE)
    if ok and c and c~="" then return c:gsub("%s+","") end
    return nil
end

-- Globals
_G.Verified=false
_G.ESP=false;_G.ESPBox3D=false;_G.ESPBox2D=false;_G.ShowNames=false;_G.ShowDistance=false;_G.ShowHealthBar=false;_G.ShowID=false;_G.ShowTracer=false;_G.TracerThick=1.5;_G.TeamCheck=false;_G.ShowFriendly=false;_G.WallCheck=false;_G.SkeletonESP=false
_G.ESPEnemyR=255;_G.ESPEnemyG=60;_G.ESPEnemyB=60;_G.ESPFriendR=80;_G.ESPFriendG=140;_G.ESPFriendB=255;_G.ESPVisR=80;_G.ESPVisG=255;_G.ESPVisB=120
_G.Crosshair=false;_G.CrosshairStyle="Cross";_G.CrosshairSize=12;_G.CrosshairThick=2;_G.CrosshairGap=4;_G.CrosshairAlpha=1.0;_G.CrosshairDot=false;_G.CrosshairOutline=false;_G.CrosshairR=255;_G.CrosshairG=255;_G.CrosshairB=255
_G.Aimbot=false;_G.RageAimbot=false;_G.SilentAim=false;_G.AutoShoot=false;_G.UseFOV=true;_G.FOVVisible=true;_G.FOVSize=120;_G.AimbotSmoothness=0.3;_G.AimbotPartHead=true;_G.AimbotPartChest=false;_G.AimbotPartStomach=false
_G.FlyEnabled=false;_G.FlySpeed=50;_G.NoClipEnabled=false;_G.BunnyHop=false;_G.BunnyHopSpeed=1.2;_G.BunnyHopHeight=7;_G.SpeedHack=false;_G.SpeedMultiplier=2.0;_G.InfiniteJump=false;_G.LongJump=false;_G.LongJumpPower=80;_G.SwimHack=false
_G.KillAura=false;_G.KillAuraRange=15;_G.AntiAFK=false;_G.NameSpoof=false;_G.SpoofedName="";_G.StreamProof=false
_G.FullBright=false;_G.NoFog=false;_G.FOVChanger=false;_G.FOVChangerVal=200;_G.ThirdPerson=false;_G.ThirdPersonDist=12;_G.TimeChanger=false;_G.TimeOfDay=14;_G.WorldColor=false;_G.WorldR=128;_G.WorldG=128;_G.WorldB=128
_G.TeamChangePlayerName="";_G.TeamChangeTeamName=""
local FrozenPlayers={}

-- Theme
local T={BG=Color3.fromRGB(12,12,12),Sidebar=Color3.fromRGB(16,16,16),Card=Color3.fromRGB(26,26,26),CardHov=Color3.fromRGB(34,34,34),Accent=Color3.fromRGB(255,255,255),AccentDim=Color3.fromRGB(180,180,180),AccentFaint=Color3.fromRGB(48,48,48),TitleBar=Color3.fromRGB(10,10,10),Text=Color3.fromRGB(235,235,235),TextDim=Color3.fromRGB(130,130,130),TextFaint=Color3.fromRGB(55,55,55),OffBG=Color3.fromRGB(40,40,40),OnBG=Color3.fromRGB(210,210,210),Border=Color3.fromRGB(32,32,32),BorderLight=Color3.fromRGB(50,50,50),CloseRed=Color3.fromRGB(185,45,45),MinBtn=Color3.fromRGB(42,42,42),ActiveSide=Color3.fromRGB(245,245,245),InactiveSide=Color3.fromRGB(26,26,26),KeyGreen=Color3.fromRGB(30,180,80),KeyRed=Color3.fromRGB(200,50,50),KeyGold=Color3.fromRGB(220,180,50)}

-- UI helpers
local function corner(r,p) local c=Instance.new("UICorner",p);c.CornerRadius=UDim.new(0,r);return c end
local function tw(o,t,pr) TweenService:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quad),pr):Play() end
local function pad(p,x,y) local u=Instance.new("UIPadding",p);u.PaddingLeft=UDim.new(0,x);u.PaddingRight=UDim.new(0,x);u.PaddingTop=UDim.new(0,y);u.PaddingBottom=UDim.new(0,y) end
local function makeScroll(parent)
    local sc=Instance.new("ScrollingFrame",parent);sc.Size=UDim2.new(1,0,1,0);sc.BackgroundTransparency=1;sc.ScrollBarThickness=3;sc.ScrollBarImageColor3=T.BorderLight;sc.CanvasSize=UDim2.new(0,0,0,0);sc.AutomaticCanvasSize=Enum.AutomaticSize.Y;sc.BorderSizePixel=0;return sc
end
local function makeGui(name,order)
    pcall(function() local e=GuiParent:FindFirstChild(name);if e then e:Destroy() end end)
    local g=Instance.new("ScreenGui");g.Name=name;g.ResetOnSpawn=false;g.IgnoreGuiInset=true;g.DisplayOrder=order or 200
    pcall(function() g.ZIndexBehavior=Enum.ZIndexBehavior.Global end)
    g.Parent=GuiParent;return g
end

-- Key Menu
local keyMenuGui=makeGui("SusanoKeyMenu",999)

local function buildKeyMenu(onSuccess)
    local overlay=Instance.new("Frame",keyMenuGui);overlay.Size=UDim2.new(1,0,1,0);overlay.BackgroundColor3=Color3.fromRGB(5,5,5);overlay.BackgroundTransparency=0;overlay.BorderSizePixel=0
    local card=Instance.new("Frame",keyMenuGui);card.Size=UDim2.new(0,460,0,520);card.Position=UDim2.new(0.5,-230,0.5,-260);card.BackgroundColor3=T.BG;card.BorderSizePixel=0;corner(12,card)
    Instance.new("UIStroke",card).Color=T.BorderLight

    local topBar=Instance.new("Frame",card);topBar.Size=UDim2.new(1,0,0,52);topBar.BackgroundColor3=T.TitleBar;topBar.BorderSizePixel=0;topBar.ClipsDescendants=true;corner(12,topBar)
    local tL=Instance.new("TextLabel",topBar);tL.Size=UDim2.new(1,0,0.6,0);tL.BackgroundTransparency=1;tL.Text="SUSANO";tL.TextColor3=T.Accent;tL.Font=Enum.Font.GothamBlack;tL.TextSize=24
    local sL=Instance.new("TextLabel",topBar);sL.Size=UDim2.new(1,0,0.4,0);sL.Position=UDim2.new(0,0,0.6,0);sL.BackgroundTransparency=1;sL.Text="v1.0  —  Anahtarını gir";sL.TextColor3=T.TextFaint;sL.Font=Enum.Font.GothamMedium;sL.TextSize=11

    local profBg=Instance.new("Frame",card);profBg.Size=UDim2.new(1,-32,0,70);profBg.Position=UDim2.new(0,16,0,60);profBg.BackgroundColor3=T.Card;corner(10,profBg)
    local avF=Instance.new("Frame",profBg);avF.Size=UDim2.new(0,48,0,48);avF.Position=UDim2.new(0,10,0.5,-24);avF.BackgroundColor3=T.AccentFaint;corner(24,avF)
    pcall(function() local img=Instance.new("ImageLabel",avF);img.Size=UDim2.new(1,0,1,0);img.BackgroundTransparency=1;corner(24,img);img.Image=Players:GetUserThumbnailAsync(LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150) end)
    local info=Instance.new("Frame",profBg);info.Size=UDim2.new(1,-68,1,0);info.Position=UDim2.new(0,64,0,0);info.BackgroundTransparency=1
    local function iL(y,t,c,s) local l=Instance.new("TextLabel",info);l.Size=UDim2.new(1,0,0,18);l.Position=UDim2.new(0,0,0,y);l.BackgroundTransparency=1;l.Text=t;l.TextColor3=c;l.Font=Enum.Font.GothamMedium;l.TextSize=s;l.TextXAlignment=Enum.TextXAlignment.Left end
    iL(8,"@"..USERNAME,T.Text,15);iL(28,"HWID: "..HWID:sub(1,20).."…",T.TextFaint,11);iL(44,"UID: "..USER_ID,T.TextFaint,10)

    local badgeRow=Instance.new("Frame",card);badgeRow.Size=UDim2.new(1,-32,0,28);badgeRow.Position=UDim2.new(0,16,0,140);badgeRow.BackgroundTransparency=1
    local bL=Instance.new("UIListLayout",badgeRow);bL.FillDirection=Enum.FillDirection.Horizontal;bL.Padding=UDim.new(0,6);bL.VerticalAlignment=Enum.VerticalAlignment.Center
    for _,bd in ipairs({{l="GÜNLÜK",c=T.TextDim},{l="HAFTALIK",c=Color3.fromRGB(80,180,255)},{l="AYLIK",c=Color3.fromRGB(180,120,255)},{l="SINIRSIZ",c=T.KeyGold}}) do
        local b=Instance.new("Frame",badgeRow);b.Size=UDim2.new(0,82,1,0);b.BackgroundColor3=T.Card;corner(5,b)
        local bl=Instance.new("TextLabel",b);bl.Size=UDim2.new(1,0,1,0);bl.BackgroundTransparency=1;bl.Text=bd.l;bl.TextColor3=bd.c;bl.Font=Enum.Font.GothamBold;bl.TextSize=10
    end

    local inLbl=Instance.new("TextLabel",card);inLbl.Size=UDim2.new(1,-32,0,18);inLbl.Position=UDim2.new(0,16,0,180);inLbl.BackgroundTransparency=1;inLbl.Text="ANAHTAR";inLbl.TextColor3=T.TextFaint;inLbl.Font=Enum.Font.GothamBold;inLbl.TextSize=10;inLbl.TextXAlignment=Enum.TextXAlignment.Left
    local inputBox=Instance.new("TextBox",card);inputBox.Size=UDim2.new(1,-32,0,46);inputBox.Position=UDim2.new(0,16,0,200);inputBox.BackgroundColor3=T.Card;inputBox.TextColor3=T.Text;inputBox.Font=Enum.Font.GothamMedium;inputBox.TextSize=15;inputBox.PlaceholderText="SUSANO-XXXX-XXXXXXXX";inputBox.PlaceholderColor3=T.TextFaint;inputBox.Text="";inputBox.ClearTextOnFocus=false;inputBox.BorderSizePixel=0;corner(8,inputBox);pad(inputBox,14,0)
    local ibStroke=Instance.new("UIStroke",inputBox);ibStroke.Color=T.BorderLight;ibStroke.Thickness=1
    local statusLbl=Instance.new("TextLabel",card);statusLbl.Size=UDim2.new(1,-32,0,20);statusLbl.Position=UDim2.new(0,16,0,252);statusLbl.BackgroundTransparency=1;statusLbl.Text="";statusLbl.Font=Enum.Font.GothamMedium;statusLbl.TextSize=13;statusLbl.TextXAlignment=Enum.TextXAlignment.Left

    -- Key bilgi kartı
    local keyInfoCard=Instance.new("Frame",card);keyInfoCard.Size=UDim2.new(1,-32,0,36);keyInfoCard.Position=UDim2.new(0,16,0,278);keyInfoCard.BackgroundColor3=T.Card;keyInfoCard.Visible=false;corner(8,keyInfoCard)
    local keyTypeLbl=Instance.new("TextLabel",keyInfoCard);keyTypeLbl.Size=UDim2.new(0.55,0,1,0);keyTypeLbl.Position=UDim2.new(0,10,0,0);keyTypeLbl.BackgroundTransparency=1;keyTypeLbl.Font=Enum.Font.GothamBold;keyTypeLbl.TextSize=13;keyTypeLbl.TextXAlignment=Enum.TextXAlignment.Left
    local keyTimeLbl=Instance.new("TextLabel",keyInfoCard);keyTimeLbl.Size=UDim2.new(0.45,0,1,0);keyTimeLbl.Position=UDim2.new(0.55,0,0,0);keyTimeLbl.BackgroundTransparency=1;keyTimeLbl.Font=Enum.Font.GothamMedium;keyTimeLbl.TextSize=12;keyTimeLbl.TextXAlignment=Enum.TextXAlignment.Right;local ktp=Instance.new("UIPadding",keyTimeLbl);ktp.PaddingRight=UDim.new(0,10)

    local remRow=Instance.new("Frame",card);remRow.Size=UDim2.new(1,-32,0,28);remRow.Position=UDim2.new(0,16,0,322);remRow.BackgroundTransparency=1
    local remLbl=Instance.new("TextLabel",remRow);remLbl.Size=UDim2.new(0.78,0,1,0);remLbl.BackgroundTransparency=1;remLbl.Text="Bu cihazda anahtarı hatırla";remLbl.TextColor3=T.TextDim;remLbl.Font=Enum.Font.GothamMedium;remLbl.TextSize=13;remLbl.TextXAlignment=Enum.TextXAlignment.Left
    local remOn=true
    local remPill=Instance.new("Frame",remRow);remPill.Size=UDim2.new(0,44,0,22);remPill.Position=UDim2.new(1,-44,0.5,-11);remPill.BackgroundColor3=T.OnBG;corner(22,remPill)
    local remKnob=Instance.new("Frame",remPill);remKnob.Size=UDim2.new(0,16,0,16);remKnob.Position=UDim2.new(1,-19,0.5,-8);remKnob.BackgroundColor3=T.TitleBar;corner(100,remKnob)
    local remBtn=Instance.new("TextButton",remRow);remBtn.Size=UDim2.new(1,0,1,0);remBtn.BackgroundTransparency=1;remBtn.Text=""
    remBtn.MouseButton1Click:Connect(function() remOn=not remOn;tw(remPill,0.18,{BackgroundColor3=remOn and T.OnBG or T.OffBG});tw(remKnob,0.18,{Position=UDim2.new(remOn and 1 or 0,remOn and -19 or 3,0.5,-8),BackgroundColor3=remOn and T.TitleBar or T.AccentDim}) end)

    local activateBtn=Instance.new("TextButton",card);activateBtn.Size=UDim2.new(1,-32,0,46);activateBtn.Position=UDim2.new(0,16,0,358);activateBtn.BackgroundColor3=T.Accent;activateBtn.TextColor3=T.BG;activateBtn.Font=Enum.Font.GothamBold;activateBtn.TextSize=16;activateBtn.Text="GİRİŞ YAP";corner(8,activateBtn)
    activateBtn.MouseEnter:Connect(function() tw(activateBtn,0.1,{BackgroundColor3=Color3.fromRGB(215,215,215)}) end)
    activateBtn.MouseLeave:Connect(function() tw(activateBtn,0.1,{BackgroundColor3=T.Accent}) end)
    local footLbl=Instance.new("TextLabel",card);footLbl.Size=UDim2.new(1,-32,0,20);footLbl.Position=UDim2.new(0,16,0,412);footLbl.BackgroundTransparency=1;footLbl.Text="Susano V1.0  |  Discord'dan key al";footLbl.TextColor3=T.TextFaint;footLbl.Font=Enum.Font.GothamMedium;footLbl.TextSize=11

    local attempts=0;local busy=false
    local function tryActivate()
        if busy then return end
        local key=inputBox.Text:upper():gsub("%s+","")
        if key=="" then statusLbl.Text="Anahtar gir.";statusLbl.TextColor3=T.KeyRed;return end
        busy=true;statusLbl.Text="Doğrulanıyor…";statusLbl.TextColor3=T.TextDim;activateBtn.Text="KONTROL EDİLİYOR…";activateBtn.BackgroundColor3=T.AccentFaint
        validateKey(key,function(ok,result,expires)
            busy=false;activateBtn.Text="GİRİŞ YAP";activateBtn.BackgroundColor3=T.Accent
            if ok then
                if remOn then safeWrite(KEY_FILE,key) end
                activeKey=key;keyExpires=expires
                keyInfoCard.Visible=true
                local tn={daily="GÜNLÜK",weekly="HAFTALIK",monthly="AYLIK",lifetime="SINIRSIZ"}
                local tc={daily=T.TextDim,weekly=Color3.fromRGB(80,180,255),monthly=Color3.fromRGB(180,120,255),lifetime=T.KeyGold}
                keyTypeLbl.Text=tn[result] or result:upper();keyTypeLbl.TextColor3=tc[result] or T.Text
                keyTimeLbl.Text=formatTimeLeft(expires);keyTimeLbl.TextColor3=expires==0 and T.KeyGold or T.KeyGreen
                statusLbl.Text="Geçerli anahtar!";statusLbl.TextColor3=T.KeyGreen
                tw(activateBtn,0.2,{BackgroundColor3=T.KeyGreen});tw(ibStroke,0.2,{Color=T.KeyGreen})
                task.wait(0.8);tw(card,0.25,{BackgroundTransparency=1});tw(overlay,0.25,{BackgroundTransparency=1})
                task.wait(0.3);keyMenuGui:Destroy();keyValidated=true;keyType=result;_G.Verified=true;onSuccess(result)
            else
                attempts=attempts+1;statusLbl.Text=tostring(result).."  ("..attempts.." deneme)";statusLbl.TextColor3=T.KeyRed
                tw(ibStroke,0.1,{Color=T.KeyRed});tw(inputBox,0.08,{BackgroundColor3=Color3.fromRGB(55,18,18)})
                task.wait(0.25);tw(inputBox,0.2,{BackgroundColor3=T.Card});tw(ibStroke,0.3,{Color=T.BorderLight})
                if attempts>=5 then statusLbl.Text="Çok fazla yanlış deneme.";task.wait(1.5);keyMenuGui:Destroy() end
            end
        end)
    end
    activateBtn.MouseButton1Click:Connect(tryActivate)
    inputBox.FocusLost:Connect(function(enter) if enter then tryActivate() end end)
    task.spawn(function() task.wait(0.1);pcall(function() inputBox:CaptureFocus() end) end)
    card.BackgroundTransparency=1;card.Position=UDim2.new(0.5,-230,0.5,-250)
    tw(card,0.18,{BackgroundTransparency=0,Position=UDim2.new(0.5,-230,0.5,-260)})
end

-- Forward declarations
local enableFly,disableFly,enableNoclip,disableNoclip,enableBhop,disableBhop,enableSpeed,disableSpeed
local enableInfiniteJump,disableInfiniteJump,enableLongJump,disableLongJump,enableSwimHack
local enableKillAura,disableKillAura,enableAntiAFK,disableAntiAFK,enableRageAimbot,disableRageAimbot
local enableSilentAim,disableSilentAim,enableThirdPerson,disableThirdPerson
local applyNameSpoof,applyFullBright,applyNoFog,applyTime,applyWorldColor
local buildCrosshair,MainGui,switchTab

-- FOV
local FOVCircle,FOVGui
local function createFOVCircle()
    if FOVGui then FOVGui:Destroy() end;FOVGui=makeGui("SusanoFOV",200)
    FOVCircle=Instance.new("Frame",FOVGui);FOVCircle.Name="FOVCircle"
    local r=_G.FOVSize;FOVCircle.Size=UDim2.new(0,r*2,0,r*2);FOVCircle.Position=UDim2.new(0.5,-r,0.5,-r);FOVCircle.BackgroundTransparency=1;FOVCircle.BorderSizePixel=0;FOVCircle.ZIndex=999;corner(999,FOVCircle)
    local s=Instance.new("UIStroke",FOVCircle);s.Color=Color3.new(1,1,1);s.Thickness=1;s.Transparency=0.45;s.Name="FOVStroke";FOVCircle.Visible=_G.FOVVisible
end
local function updateFOVColor(col) if FOVCircle then local s=FOVCircle:FindFirstChild("FOVStroke");if s then s.Color=col end end end

-- Crosshair
local chGui;local CH_STYLES={"Cross","Circle","Dot","T-Shape","X-Shape","Square"}
local function destroyCrosshair() if chGui then chGui:Destroy();chGui=nil end end
buildCrosshair=function()
    destroyCrosshair();if not _G.Crosshair then return end
    chGui=makeGui("SusanoCH",200)
    local col=Color3.fromRGB(_G.CrosshairR,_G.CrosshairG,_G.CrosshairB);local s=_G.CrosshairSize;local g=_G.CrosshairGap;local th=_G.CrosshairThick;local alpha=1-_G.CrosshairAlpha
    local function mkLine(w,h,ox,oy) local f=Instance.new("Frame",chGui);f.BackgroundColor3=col;f.BorderSizePixel=0;f.BackgroundTransparency=alpha;f.Size=UDim2.new(0,w,0,h);f.AnchorPoint=Vector2.new(0.5,0.5);f.Position=UDim2.new(0.5,ox,0.5,oy);f.ZIndex=500;if _G.CrosshairOutline then local os=Instance.new("UIStroke",f);os.Color=Color3.new(0,0,0);os.Thickness=1;os.Transparency=alpha+0.3 end;return f end
    local style=_G.CrosshairStyle
    if style=="Cross" then mkLine(s,th,-(g+s/2),0);mkLine(s,th,(g+s/2),0);mkLine(th,s,0,-(g+s/2));mkLine(th,s,0,(g+s/2))
    elseif style=="T-Shape" then mkLine(s,th,-(g+s/2),0);mkLine(s,th,(g+s/2),0);mkLine(th,s,0,(g+s/2))
    elseif style=="X-Shape" then local f1=mkLine(s,th,0,0);f1.Rotation=45;local f2=mkLine(s,th,0,0);f2.Rotation=-45
    elseif style=="Dot" then corner(100,mkLine(th*3,th*3,0,0))
    elseif style=="Circle" then local c2=Instance.new("Frame",chGui);c2.Size=UDim2.new(0,s*2,0,s*2);c2.Position=UDim2.new(0.5,-s,0.5,-s);c2.BackgroundTransparency=1;c2.BorderSizePixel=0;c2.ZIndex=500;corner(999,c2);local sk=Instance.new("UIStroke",c2);sk.Color=col;sk.Thickness=th;sk.Transparency=alpha
    elseif style=="Square" then mkLine(s*2,th,0,-s);mkLine(s*2,th,0,s);mkLine(th,s*2,-s,0);mkLine(th,s*2,s,0) end
    if _G.CrosshairDot and style~="Dot" then corner(100,mkLine(th+1,th+1,0,0)) end
end

-- Skeleton
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

-- Aimbot
local function getTargetPart(p) if not p.Character then return nil end;if _G.AimbotPartHead then local h=p.Character:FindFirstChild("Head");if h then return h end end;if _G.AimbotPartChest then local c=p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso");if c then return c end end;if _G.AimbotPartStomach then local s=p.Character:FindFirstChild("LowerTorso") or p.Character:FindFirstChild("HumanoidRootPart");if s then return s end end;return p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart") end
local function getBestTarget()
    local best,bDist=nil,math.huge;local center=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
            local friendly=p.Team and LocalPlayer.Team and p.Team==LocalPlayer.Team
            if friendly and not _G.ShowFriendly then continue end;if not friendly and not _G.TeamCheck then continue end
            local hum=p.Character:FindFirstChildOfClass("Humanoid");if not hum or hum.Health<=0 then continue end
            local part=getTargetPart(p);if not part then continue end
            local sp,onS=Camera:WorldToViewportPoint(part.Position);if not onS then continue end
            local dist=(Vector2.new(sp.X,sp.Y)-center).Magnitude;if _G.UseFOV and dist>_G.FOVSize then continue end
            if dist<bDist then bDist=dist;best={part=part,player=p} end
        end
    end;return best
end

if not mouse1press then mouse1press=function() pcall(function() UserInputService:SendInput(Enum.UserInputType.MouseButton1,true) end) end end
if not mouse1release then mouse1release=function() pcall(function() UserInputService:SendInput(Enum.UserInputType.MouseButton1,false) end) end end
local autoShootConn
local function startAutoShoot()
    if autoShootConn then autoShootConn:Disconnect() end
    autoShootConn=RunService.Heartbeat:Connect(function() if not _G.AutoShoot then return end;local t=getBestTarget();if t then pcall(mouse1press);task.wait(0.04);pcall(mouse1release) end end)
end

local silentAimActive=false;local _savedCam=nil;local _saApplied=false;local saConn1,saConn2
enableSilentAim=function()
    silentAimActive=true;if saConn1 then saConn1:Disconnect() end;if saConn2 then saConn2:Disconnect() end
    saConn1=RunService.Stepped:Connect(function() if not _G.SilentAim or not silentAimActive then _saApplied=false;return end;local t=getBestTarget();if t then _savedCam=Camera.CFrame;Camera.CFrame=CFrame.new(Camera.CFrame.Position,t.part.Position);_saApplied=true else _saApplied=false end end)
    saConn2=RunService.RenderStepped:Connect(function() if _saApplied and _savedCam then Camera.CFrame=_savedCam;_saApplied=false end end)
end
disableSilentAim=function() silentAimActive=false;if saConn1 then saConn1:Disconnect() end;if saConn2 then saConn2:Disconnect() end;if _savedCam then Camera.CFrame=_savedCam end end

local rageActive,rageConn=false,nil
disableRageAimbot=function() rageActive=false;if rageConn then rageConn:Disconnect();rageConn=nil end end
enableRageAimbot=function()
    if rageActive then return end;rageActive=true
    rageConn=RunService.RenderStepped:Connect(function()
        if not _G.RageAimbot then disableRageAimbot();return end
        local best,bDist=nil,math.huge
        for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then local friendly=p.Team and LocalPlayer.Team and p.Team==LocalPlayer.Team;if friendly and not _G.ShowFriendly then continue end;if not friendly and not _G.TeamCheck then continue end;local hum=p.Character:FindFirstChildOfClass("Humanoid");if not hum or hum.Health<=0 then continue end;for _,pn in ipairs({"Head","UpperTorso","Torso","HumanoidRootPart"}) do local part=p.Character:FindFirstChild(pn);if part then local d=(part.Position-Camera.CFrame.Position).Magnitude;if d<bDist then bDist=d;best=part end end end end end
        if best then Camera.CFrame=CFrame.new(Camera.CFrame.Position,best.Position);updateFOVColor(Color3.fromRGB(255,80,80)) else updateFOVColor(Color3.new(1,1,1)) end
    end)
end

local ijConn;enableInfiniteJump=function() if ijConn then ijConn:Disconnect() end;ijConn=UserInputService.JumpRequest:Connect(function() if not _G.InfiniteJump then return end;local c=LocalPlayer.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end) end;disableInfiniteJump=function() if ijConn then ijConn:Disconnect();ijConn=nil end end
local ljConn;enableLongJump=function() if ljConn then ljConn:Disconnect() end;ljConn=UserInputService.JumpRequest:Connect(function() if not _G.LongJump then return end;local c=LocalPlayer.Character;if not c then return end;local hrp=c:FindFirstChild("HumanoidRootPart");local hum=c:FindFirstChildOfClass("Humanoid");if hrp and hum and hum.FloorMaterial~=Enum.Material.Air then local bv=Instance.new("BodyVelocity");bv.Velocity=hrp.CFrame.LookVector*_G.LongJumpPower+Vector3.new(0,30,0);bv.MaxForce=Vector3.new(1e5,1e5,1e5);bv.P=1e4;bv.Parent=hrp;game:GetService("Debris"):AddItem(bv,0.15) end end) end;disableLongJump=function() if ljConn then ljConn:Disconnect();ljConn=nil end end
local swimConn;enableSwimHack=function() if swimConn then swimConn:Disconnect() end;swimConn=RunService.Stepped:Connect(function() if not _G.SwimHack then return end;local c=LocalPlayer.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid");if hum and hum:GetState()==Enum.HumanoidStateType.Swimming then hum.WalkSpeed=16*_G.SpeedMultiplier end end) end
local bhopConn,bhopActive=nil,false;enableBhop=function() if bhopActive then return end;local c=LocalPlayer.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid");if not hum then return end;bhopActive=true;bhopConn=RunService.RenderStepped:Connect(function() if not _G.BunnyHop or not c or not hum then bhopActive=false;if bhopConn then bhopConn:Disconnect() end;return end;if hum.FloorMaterial~=Enum.Material.Air then hum.JumpPower=_G.BunnyHopHeight;hum.Jump=true end;hum.WalkSpeed=hum.MoveDirection.Magnitude>0 and 16*_G.BunnyHopSpeed or 16 end) end;disableBhop=function() bhopActive=false;if bhopConn then bhopConn:Disconnect();bhopConn=nil end;local c=LocalPlayer.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h.WalkSpeed=16;h.JumpPower=50 end end end
local spdConn,spdActive=nil,false;local origSpeed=16;enableSpeed=function() if spdActive then return end;local c=LocalPlayer.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid");if not hum then return end;spdActive=true;origSpeed=hum.WalkSpeed;spdConn=RunService.RenderStepped:Connect(function() if not _G.SpeedHack or not c or not hum then spdActive=false;if spdConn then spdConn:Disconnect() end;return end;hum.WalkSpeed=origSpeed*_G.SpeedMultiplier*(hum.MoveDirection.Magnitude>0 and 1.1 or 1) end) end;disableSpeed=function() spdActive=false;if spdConn then spdConn:Disconnect();spdConn=nil end;local c=LocalPlayer.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h.WalkSpeed=origSpeed end end end
local flyConn,flying=nil,false;local bVel,bGyro;enableFly=function() if flying then return end;local c=LocalPlayer.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid");local hrp=c:FindFirstChild("HumanoidRootPart");if not hum or not hrp then return end;flying=true;bVel=Instance.new("BodyVelocity");bVel.MaxForce=Vector3.new(1e5,1e5,1e5);bVel.P=1e4;bVel.Parent=hrp;bGyro=Instance.new("BodyGyro");bGyro.MaxTorque=Vector3.new(1e5,1e5,1e5);bGyro.P=1e4;bGyro.D=100;bGyro.Parent=hrp;flyConn=RunService.RenderStepped:Connect(function() if not flying or not hrp then disableFly();return end;bGyro.CFrame=Camera.CFrame;local v=Vector3.zero;local ui=UserInputService;if ui:IsKeyDown(Enum.KeyCode.W) then v=v+Camera.CFrame.LookVector*_G.FlySpeed end;if ui:IsKeyDown(Enum.KeyCode.S) then v=v-Camera.CFrame.LookVector*_G.FlySpeed end;if ui:IsKeyDown(Enum.KeyCode.D) then v=v+Camera.CFrame.RightVector*_G.FlySpeed end;if ui:IsKeyDown(Enum.KeyCode.A) then v=v-Camera.CFrame.RightVector*_G.FlySpeed end;if ui:IsKeyDown(Enum.KeyCode.Space) then v=v+Vector3.new(0,_G.FlySpeed,0) end;if ui:IsKeyDown(Enum.KeyCode.LeftShift) or ui:IsKeyDown(Enum.KeyCode.Q) then v=v-Vector3.new(0,_G.FlySpeed,0) end;bVel.Velocity=v;if hum:GetState()~=Enum.HumanoidStateType.Freefall then hum:ChangeState(Enum.HumanoidStateType.Freefall) end end) end;disableFly=function() flying=false;if flyConn then flyConn:Disconnect();flyConn=nil end;if bVel then bVel:Destroy();bVel=nil end;if bGyro then bGyro:Destroy();bGyro=nil end;local c=LocalPlayer.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h:ChangeState(Enum.HumanoidStateType.Landed) end end end
local ncConn,ncActive=nil,false;enableNoclip=function() if ncActive then return end;ncActive=true;ncConn=RunService.Stepped:Connect(function() if not ncActive or not LocalPlayer.Character then ncActive=false;if ncConn then ncConn:Disconnect() end;return end;for _,p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false;setnetworkowner(p,LocalPlayer) end end end) end;disableNoclip=function() ncActive=false;if ncConn then ncConn:Disconnect();ncConn=nil end;local c=LocalPlayer.Character;if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end end
local killAuraConn;enableKillAura=function() if killAuraConn then killAuraConn:Disconnect() end;killAuraConn=RunService.Heartbeat:Connect(function() if not _G.KillAura then return end;local c=LocalPlayer.Character;if not c then return end;local hrp=c:FindFirstChild("HumanoidRootPart");if not hrp then return end;local tool=c:FindFirstChildOfClass("Tool");for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then local friendly=p.Team and LocalPlayer.Team and p.Team==LocalPlayer.Team;if friendly then continue end;local phum=p.Character:FindFirstChildOfClass("Humanoid");local phrp=p.Character:FindFirstChild("HumanoidRootPart");if not phum or not phrp or phum.Health<=0 then continue end;if(phrp.Position-hrp.Position).Magnitude<=_G.KillAuraRange then if tool then for _,child in ipairs(tool:GetDescendants()) do if child:IsA("RemoteEvent") then pcall(function() child:FireServer(p.Character) end) end end;pcall(function() tool:Activate() end) end end end end end) end;disableKillAura=function() if killAuraConn then killAuraConn:Disconnect();killAuraConn=nil end end
local afkConn;enableAntiAFK=function() if afkConn then afkConn:Disconnect() end;afkConn=RunService.Heartbeat:Connect(function() if not _G.AntiAFK then return end;pcall(function() local vu=game:GetService("VirtualUser");vu:CaptureController();vu:ClickButton2(Vector2.new()) end) end) end;disableAntiAFK=function() if afkConn then afkConn:Disconnect();afkConn=nil end end
local nameSpoofConn;applyNameSpoof=function() local name=_G.SpoofedName~="" and _G.SpoofedName or LocalPlayer.Name;local function spoofChar(char) if not char then return end;local head=char:FindFirstChild("Head");if not head then return end;for _,gui in ipairs(head:GetChildren()) do if gui:IsA("BillboardGui") then gui.Enabled=not _G.NameSpoof end end;local existing=head:FindFirstChild("SusanoSpoofTag");if _G.NameSpoof then if not existing then local bb=Instance.new("BillboardGui",head);bb.Name="SusanoSpoofTag";bb.AlwaysOnTop=false;bb.Size=UDim2.new(0,250,0,36);bb.StudsOffset=Vector3.new(0,2.2,0);local lbl=Instance.new("TextLabel",bb);lbl.Size=UDim2.new(1,0,1,0);lbl.BackgroundTransparency=1;lbl.TextColor3=Color3.new(1,1,1);lbl.Font=Enum.Font.GothamBold;lbl.TextSize=17;lbl.TextStrokeTransparency=0.5;lbl.Name="SpoofLbl" end;local lbl=head.SusanoSpoofTag:FindFirstChild("SpoofLbl");if lbl then lbl.Text=name end else if existing then existing:Destroy() end;for _,gui in ipairs(head:GetChildren()) do if gui:IsA("BillboardGui") then gui.Enabled=true end end end end;spoofChar(LocalPlayer.Character);if nameSpoofConn then nameSpoofConn:Disconnect() end;if _G.NameSpoof then nameSpoofConn=LocalPlayer.CharacterAdded:Connect(function(char) task.wait(0.5);spoofChar(char) end) end end

local origAmbient=Lighting.Ambient;local origBrightness=Lighting.Brightness;local origFogEnd=Lighting.FogEnd;local origFogStart=Lighting.FogStart;local origCamFOV=Camera.FieldOfView;local origTimeOfDay=Lighting.TimeOfDay;local origColorShift=Lighting.ColorShift_Top
applyFullBright=function(v) if v then Lighting.Ambient=Color3.new(1,1,1);Lighting.Brightness=2;for _,e in ipairs(Lighting:GetChildren()) do if e:IsA("BlurEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("SunRaysEffect") or e:IsA("BloomEffect") then e.Enabled=false end end else Lighting.Ambient=origAmbient;Lighting.Brightness=origBrightness end end
applyNoFog=function(v) if v then Lighting.FogEnd=1e6;Lighting.FogStart=1e6 else Lighting.FogEnd=origFogEnd;Lighting.FogStart=origFogStart end end
applyTime=function(v) if v then Lighting.TimeOfDay=string.format("%02d:00:00",math.floor(_G.TimeOfDay)) else Lighting.TimeOfDay=origTimeOfDay end end
applyWorldColor=function(v) if v then Lighting.ColorShift_Top=Color3.fromRGB(_G.WorldR,_G.WorldG,_G.WorldB) else Lighting.ColorShift_Top=origColorShift end end
local tpConn;enableThirdPerson=function() Camera.CameraType=Enum.CameraType.Scriptable;if tpConn then tpConn:Disconnect() end;tpConn=RunService.RenderStepped:Connect(function() if not _G.ThirdPerson then disableThirdPerson();return end;local c=LocalPlayer.Character;if not c then return end;local hrp=c:FindFirstChild("HumanoidRootPart");if not hrp then return end;local d=_G.ThirdPersonDist;Camera.CFrame=CFrame.new(hrp.CFrame.Position-hrp.CFrame.LookVector*d+Vector3.new(0,d*0.4,0),hrp.Position) end) end;disableThirdPerson=function() if tpConn then tpConn:Disconnect();tpConn=nil end;Camera.CameraType=Enum.CameraType.Custom end

-- ESP
local espCache,esp2D,espTracers={},{},{}
local function getESPColors() return Color3.fromRGB(_G.ESPEnemyR,_G.ESPEnemyG,_G.ESPEnemyB),Color3.fromRGB(_G.ESPFriendR,_G.ESPFriendG,_G.ESPFriendB),Color3.fromRGB(_G.ESPVisR,_G.ESPVisG,_G.ESPVisB) end
local function isVisible(player) if not player.Character then return false end;local head=player.Character:FindFirstChild("Head");if not head then return false end;local origin=Camera.CFrame.Position;local ray=Ray.new(origin,(head.Position-origin).Unit*1000);local hit=Workspace:FindPartOnRayWithIgnoreList(ray,{LocalPlayer.Character,player.Character});return hit==nil end
local function clearESPPlayer(p) if espCache[p] then if espCache[p].hl then espCache[p].hl:Destroy() end;if espCache[p].bb then espCache[p].bb:Destroy() end;if espCache[p].hbBB then espCache[p].hbBB:Destroy() end;espCache[p]=nil end;if esp2D[p] then for _,v in pairs(esp2D[p]) do pcall(function() v:Remove() end) end;esp2D[p]=nil end;if espTracers[p] then pcall(function() espTracers[p]:Remove() end);espTracers[p]=nil end;clearSkeleton(p) end
local function clearAllESP() for p in pairs(espCache) do clearESPPlayer(p) end end
local function buildESP(player)
    if not _G.ESP or player==LocalPlayer then return end;local char=player.Character;if not char then return end
    local hrp=char:WaitForChild("HumanoidRootPart",5);if not hrp then return end;local hum=char:FindFirstChildOfClass("Humanoid")
    local hl=Instance.new("Highlight");hl.Adornee=char;hl.FillTransparency=0.75;hl.OutlineColor=Color3.new(1,1,1);hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;hl.Enabled=false;hl.Parent=CoreGui
    local bb=Instance.new("BillboardGui");bb.Size=UDim2.new(6,0,3,0);bb.AlwaysOnTop=true;bb.StudsOffset=Vector3.new(0,4,0);bb.Adornee=hrp;bb.Enabled=false;bb.Parent=CoreGui
    local function lbl(pos,sz,col,fs) local l=Instance.new("TextLabel",bb);l.Size=UDim2.new(1,0,sz,0);l.Position=UDim2.new(0,0,pos,0);l.BackgroundTransparency=1;l.TextColor3=col;l.Font=Enum.Font.GothamBold;l.TextSize=fs;l.TextStrokeTransparency=0.4;return l end
    local idLbl=lbl(0,0.3,Color3.fromRGB(160,160,255),12);local nameLbl=lbl(0.3,0.4,Color3.new(1,1,1),16);local dstLbl=lbl(0.7,0.3,Color3.fromRGB(255,220,80),12)
    local hbBB=Instance.new("BillboardGui");hbBB.Size=UDim2.new(0.4,0,2,0);hbBB.AlwaysOnTop=true;hbBB.StudsOffset=Vector3.new(-1.8,2,0);hbBB.Adornee=hrp;hbBB.Enabled=false;hbBB.Parent=CoreGui
    local hbBG=Instance.new("Frame",hbBB);hbBG.Size=UDim2.new(0,4,1,0);hbBG.BackgroundColor3=Color3.fromRGB(20,20,20);hbBG.BorderSizePixel=0
    local hbFill=Instance.new("Frame",hbBG);hbFill.Size=UDim2.new(1,0,1,0);hbFill.BackgroundColor3=Color3.fromRGB(80,255,120);hbFill.BorderSizePixel=0
    espCache[player]={hl=hl,bb=bb,hbBB=hbBB,hbBG=hbBG,hbFill=hbFill,idLbl=idLbl,nameLbl=nameLbl,dstLbl=dstLbl,hrp=hrp,hum=hum}
    local e={};e.box=Drawing.new("Square");e.box.Visible=false;e.box.Thickness=1.5;e.box.Filled=false;e.name=Drawing.new("Text");e.name.Visible=false;e.name.Size=14;e.name.Font=2;e.name.Center=true;e.dist=Drawing.new("Text");e.dist.Visible=false;e.dist.Size=12;e.dist.Font=2;e.dist.Center=true;e.dist.Color=Color3.fromRGB(255,220,80);e.id=Drawing.new("Text");e.id.Visible=false;e.id.Size=11;e.id.Font=2;e.id.Center=true;e.id.Color=Color3.fromRGB(160,160,255);e.hbg=Drawing.new("Square");e.hbg.Visible=false;e.hbg.Filled=true;e.hbg.Color=Color3.fromRGB(20,20,20);e.hfill=Drawing.new("Square");e.hfill.Visible=false;e.hfill.Filled=true;esp2D[player]=e
    local tr=Drawing.new("Line");tr.Visible=false;tr.Thickness=_G.TracerThick;tr.Transparency=0.3;espTracers[player]=tr
end
local function updateESP()
    if not _G.ESP then clearAllESP();return end;local myHRP=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");if not myHRP then return end;local cEnemy,cFriend,cVis=getESPColors()
    for player,cache in pairs(espCache) do
        if not(player and player.Parent and cache.hrp and cache.hrp.Parent) then clearESPPlayer(player);continue end
        local char=player.Character;local hum=char and char:FindFirstChildOfClass("Humanoid");local hrp=cache.hrp;local dist=(hrp.Position-myHRP.Position).Magnitude;local friendly=player.Team and LocalPlayer.Team and player.Team==LocalPlayer.Team;local show=(friendly and _G.ShowFriendly) or (not friendly and _G.TeamCheck);if not(show and hum and hum.Health>0) then show=false end;local vis=(_G.WallCheck and not friendly) and isVisible(player) or false;local col=friendly and cFriend or((_G.WallCheck and vis) and cVis or cEnemy)
        if cache.hl then cache.hl.Enabled=_G.ESPBox3D and show;if cache.hl.Enabled then cache.hl.FillColor=col end end
        if cache.bb then cache.bb.Enabled=show;if show then cache.idLbl.Visible=_G.ShowID;cache.idLbl.Text="ID: "..player.UserId;cache.nameLbl.Visible=_G.ShowNames;cache.nameLbl.Text=player.Name;cache.dstLbl.Visible=_G.ShowDistance;cache.dstLbl.Text=math.floor(dist).."m" end end
        if cache.hbBB then cache.hbBB.Enabled=_G.ShowHealthBar and show;if cache.hbBB.Enabled and hum and hum.Health>0 then local pct=hum.Health/hum.MaxHealth;cache.hbFill.Size=UDim2.new(1,0,pct,0);cache.hbFill.Position=UDim2.new(0,0,1-pct,0);cache.hbFill.BackgroundColor3=pct>0.6 and Color3.fromRGB(80,255,120) or(pct>0.3 and Color3.fromRGB(255,220,80) or Color3.fromRGB(255,80,80)) end end
        local e=esp2D[player];if e then if _G.ESPBox2D and show then local sp,onSc=Camera:WorldToViewportPoint(hrp.Position);if onSc then local head=char:FindFirstChild("Head");if head then local sh=Camera:WorldToViewportPoint(head.Position);local h=math.abs(sh.Y-sp.Y)*2.3;local w=h*0.55;local tl=Vector2.new(sp.X-w/2,sh.Y-h/2);e.box.Visible=true;e.box.Position=tl;e.box.Size=Vector2.new(w,h);e.box.Color=col;if _G.ShowNames then e.name.Visible=true;e.name.Position=Vector2.new(sp.X,sh.Y-h/2-18);e.name.Text=player.Name;e.name.Color=Color3.new(1,1,1) else e.name.Visible=false end;if _G.ShowDistance then e.dist.Visible=true;e.dist.Position=Vector2.new(sp.X,sh.Y+h/2+4);e.dist.Text=math.floor(dist).."m" else e.dist.Visible=false end;if _G.ShowID then e.id.Visible=true;e.id.Position=Vector2.new(sp.X,sh.Y-h/2-32);e.id.Text="ID: "..player.UserId else e.id.Visible=false end;if _G.ShowHealthBar and hum and hum.Health>0 then local pct=hum.Health/hum.MaxHealth;e.hbg.Visible=true;e.hbg.Position=Vector2.new(tl.X-7,tl.Y);e.hbg.Size=Vector2.new(3,h);e.hfill.Visible=true;e.hfill.Position=Vector2.new(tl.X-7,tl.Y+h*(1-pct));e.hfill.Size=Vector2.new(3,h*pct);e.hfill.Color=pct>0.6 and Color3.fromRGB(80,255,120) or(pct>0.3 and Color3.fromRGB(255,220,80) or Color3.fromRGB(255,80,80)) else e.hbg.Visible=false;e.hfill.Visible=false end else e.box.Visible=false;e.name.Visible=false;e.dist.Visible=false;e.id.Visible=false;e.hbg.Visible=false;e.hfill.Visible=false end else e.box.Visible=false;e.name.Visible=false;e.dist.Visible=false;e.id.Visible=false;e.hbg.Visible=false;e.hfill.Visible=false end else e.box.Visible=false;e.name.Visible=false;e.dist.Visible=false;e.id.Visible=false;e.hbg.Visible=false;e.hfill.Visible=false end end
        local tr=espTracers[player];if tr then tr.Thickness=_G.TracerThick;if _G.ShowTracer and show then local sp,onSc=Camera:WorldToViewportPoint(hrp.Position);if onSc then tr.Visible=true;tr.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y);tr.To=Vector2.new(sp.X,sp.Y);tr.Color=col else tr.Visible=false end else tr.Visible=false end end
    end
end
local function onChar(p) if _G.ESP then task.wait(1);buildESP(p) end end
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() onChar(p) end);if p.Character then onChar(p) end;p.CharacterRemoving:Connect(function() clearESPPlayer(p) end) end)
for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then p.CharacterAdded:Connect(function() onChar(p) end);if p.Character then onChar(p) end;p.CharacterRemoving:Connect(function() clearESPPlayer(p) end) end end

-- Utils
local function changeTeam(pN,tN) local tp;for _,p in ipairs(Players:GetPlayers()) do if p.Name:lower()==pN:lower() then tp=p;break end end;if not tp then return false,"Oyuncu bulunamadı" end;local tt;for _,t in ipairs(game:GetService("Teams"):GetChildren()) do if t.Name:lower()==tN:lower() then tt=t;break end end;if not tt then return false,"Takım bulunamadı" end;tp.Team=tt;return true,tp.Name.." → "..tt.Name end
local function freezePlayer(p,freeze) if not p.Character then return end;local root=p.Character:FindFirstChild("HumanoidRootPart");if not root then return end;if freeze then if FrozenPlayers[p] then return end;local bp=Instance.new("BodyPosition");bp.MaxForce=Vector3.new(4e4,4e4,4e4);bp.P=2000;bp.D=100;bp.Position=root.Position;bp.Parent=root;FrozenPlayers[p]=bp;setnetworkowner(root,LocalPlayer) else if FrozenPlayers[p] then FrozenPlayers[p]:Destroy();FrozenPlayers[p]=nil end end end
local function stopSpectating() local c=LocalPlayer.Character;Camera.CameraSubject=(c and c:FindFirstChildOfClass("Humanoid")) or LocalPlayer end
local function giveItem(pN,tN,count) count=count or 1;local tp;for _,p in ipairs(Players:GetPlayers()) do if p.Name:lower():find(pN:lower()) then tp=p;break end end;if not tp then return false,"Oyuncu bulunamadı" end;local found;for _,loc in ipairs({ServerStorage,ReplicatedStorage,Workspace}) do local t=loc:FindFirstChild(tN,true);if t and t:IsA("Tool") then found=t:Clone();break end end;if not found then return false,"Eşya bulunamadı" end;for i=1,count do local cl=found:Clone();local bp=tp:FindFirstChild("Backpack");if bp then cl.Parent=bp elseif tp.Character then cl.Parent=tp.Character end;task.wait(0.1) end;return true,count.."x "..tN.." → "..tp.Name end

-- Config
local function buildConfigData() return {ESP=_G.ESP,ESPBox3D=_G.ESPBox3D,ESPBox2D=_G.ESPBox2D,ShowNames=_G.ShowNames,ShowDistance=_G.ShowDistance,ShowHealthBar=_G.ShowHealthBar,ShowID=_G.ShowID,ShowTracer=_G.ShowTracer,TracerThick=_G.TracerThick,TeamCheck=_G.TeamCheck,ShowFriendly=_G.ShowFriendly,WallCheck=_G.WallCheck,SkeletonESP=_G.SkeletonESP,ESPEnemyR=_G.ESPEnemyR,ESPEnemyG=_G.ESPEnemyG,ESPEnemyB=_G.ESPEnemyB,ESPFriendR=_G.ESPFriendR,ESPFriendG=_G.ESPFriendG,ESPFriendB=_G.ESPFriendB,ESPVisR=_G.ESPVisR,ESPVisG=_G.ESPVisG,ESPVisB=_G.ESPVisB,Crosshair=_G.Crosshair,CrosshairStyle=_G.CrosshairStyle,CrosshairSize=_G.CrosshairSize,CrosshairThick=_G.CrosshairThick,CrosshairGap=_G.CrosshairGap,CrosshairAlpha=_G.CrosshairAlpha,CrosshairDot=_G.CrosshairDot,CrosshairOutline=_G.CrosshairOutline,CrosshairR=_G.CrosshairR,CrosshairG=_G.CrosshairG,CrosshairB=_G.CrosshairB,Aimbot=_G.Aimbot,RageAimbot=_G.RageAimbot,SilentAim=_G.SilentAim,AutoShoot=_G.AutoShoot,UseFOV=_G.UseFOV,FOVVisible=_G.FOVVisible,FOVSize=_G.FOVSize,AimbotSmoothness=_G.AimbotSmoothness,AimbotPartHead=_G.AimbotPartHead,AimbotPartChest=_G.AimbotPartChest,AimbotPartStomach=_G.AimbotPartStomach,FlyEnabled=_G.FlyEnabled,FlySpeed=_G.FlySpeed,NoClipEnabled=_G.NoClipEnabled,BunnyHop=_G.BunnyHop,BunnyHopSpeed=_G.BunnyHopSpeed,BunnyHopHeight=_G.BunnyHopHeight,SpeedHack=_G.SpeedHack,SpeedMultiplier=_G.SpeedMultiplier,InfiniteJump=_G.InfiniteJump,LongJump=_G.LongJump,LongJumpPower=_G.LongJumpPower,SwimHack=_G.SwimHack,KillAura=_G.KillAura,KillAuraRange=_G.KillAuraRange,AntiAFK=_G.AntiAFK,NameSpoof=_G.NameSpoof,SpoofedName=_G.SpoofedName,FullBright=_G.FullBright,NoFog=_G.NoFog,FOVChanger=_G.FOVChanger,FOVChangerVal=_G.FOVChangerVal,ThirdPerson=_G.ThirdPerson,ThirdPersonDist=_G.ThirdPersonDist,TimeChanger=_G.TimeChanger,TimeOfDay=_G.TimeOfDay,WorldColor=_G.WorldColor,WorldR=_G.WorldR,WorldG=_G.WorldG,WorldB=_G.WorldB,savedBy=USERNAME,savedAt=os.time()} end
local function applyConfigData(data) for k,v in pairs(data) do if k~="savedBy" and k~="savedAt" then _G[k]=v end end end
local GIST_MAP_FILE="susano_gists.json"
local function loadGistMap() local ok,c=safeRead(GIST_MAP_FILE);if ok and c and c~="" then local ok2,d=pcall(function() return HttpService:JSONDecode(c) end);if ok2 and d then return d end end;return {} end
local function saveGistMap(map) local ok,j=pcall(function() return HttpService:JSONEncode(map) end);if ok then safeWrite(GIST_MAP_FILE,j) end end

-- UI Builders
local function buildToggle(parent,label,setting,yPos,onToggle)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-28,0,44);row.Position=UDim2.new(0,14,0,yPos);row.BackgroundColor3=T.Card;corner(8,row)
    row.MouseEnter:Connect(function() tw(row,0.1,{BackgroundColor3=T.CardHov}) end);row.MouseLeave:Connect(function() tw(row,0.1,{BackgroundColor3=T.Card}) end)
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(0.72,0,1,0);lbl.Position=UDim2.new(0,12,0,0);lbl.BackgroundTransparency=1;lbl.Text=label;lbl.TextColor3=T.Text;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=14;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local pH,pW=24,50;local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,pW,0,pH);pill.Position=UDim2.new(1,-pW-12,0.5,-pH/2);pill.BackgroundColor3=_G[setting] and T.OnBG or T.OffBG;corner(pH,pill)
    local knob=Instance.new("Frame",pill);knob.Size=UDim2.new(0,pH-6,0,pH-6);knob.Position=UDim2.new(_G[setting] and 1 or 0,_G[setting] and -(pH-3) or 3,0.5,-(pH-6)/2);knob.BackgroundColor3=_G[setting] and T.TitleBar or T.AccentDim;corner(100,knob)
    local hit=Instance.new("TextButton",row);hit.Size=UDim2.new(1,0,1,0);hit.BackgroundTransparency=1;hit.Text=""
    hit.MouseButton1Click:Connect(function() _G[setting]=not _G[setting];tw(pill,0.18,{BackgroundColor3=_G[setting] and T.OnBG or T.OffBG});tw(knob,0.18,{Position=UDim2.new(_G[setting] and 1 or 0,_G[setting] and -(pH-3) or 3,0.5,-(pH-6)/2),BackgroundColor3=_G[setting] and T.TitleBar or T.AccentDim});if onToggle then onToggle(_G[setting]) end end)
    return yPos+52
end
local function buildSlider(parent,label,setting,yPos,minV,maxV,fmt,onChange)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-28,0,54);row.Position=UDim2.new(0,14,0,yPos);row.BackgroundColor3=T.Card;corner(8,row)
    local function fv(v) return fmt and string.format(fmt,v) or tostring(math.floor(v)) end
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(0.6,0,0,22);lbl.Position=UDim2.new(0,12,0,6);lbl.BackgroundTransparency=1;lbl.Text=label;lbl.TextColor3=T.Text;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=13;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local valL=Instance.new("TextLabel",row);valL.Size=UDim2.new(0.35,0,0,22);valL.Position=UDim2.new(0.65,0,0,6);valL.BackgroundTransparency=1;valL.Text=fv(_G[setting]);valL.TextColor3=T.TextDim;valL.Font=Enum.Font.GothamMedium;valL.TextSize=12;valL.TextXAlignment=Enum.TextXAlignment.Right
    local track=Instance.new("Frame",row);track.Size=UDim2.new(1,-24,0,3);track.Position=UDim2.new(0,12,1,-14);track.BackgroundColor3=T.AccentFaint;corner(3,track)
    local fill=Instance.new("Frame",track);fill.Size=UDim2.new((_G[setting]-minV)/(maxV-minV),0,1,0);fill.BackgroundColor3=T.Accent;corner(3,fill)
    local dragging=false;local function setVal(ix) local relX=math.clamp(ix-track.AbsolutePosition.X,0,track.AbsoluteSize.X);local pct=relX/track.AbsoluteSize.X;_G[setting]=math.floor((minV+pct*(maxV-minV))*100)/100;fill.Size=UDim2.new(pct,0,1,0);valL.Text=fv(_G[setting]);if onChange then onChange(_G[setting]) end end
    track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true;setVal(i.Position.X) end end);track.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end);UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then setVal(i.Position.X) end end)
    return yPos+62
end
local function buildSection(parent,txt,yPos)
    local lbl=Instance.new("TextLabel",parent);lbl.Size=UDim2.new(1,-28,0,22);lbl.Position=UDim2.new(0,14,0,yPos);lbl.BackgroundTransparency=1;lbl.Text=string.upper(txt);lbl.TextColor3=T.TextFaint;lbl.Font=Enum.Font.GothamBold;lbl.TextSize=10;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local line=Instance.new("Frame",parent);line.Size=UDim2.new(1,-28,0,1);line.Position=UDim2.new(0,14,0,yPos+20);line.BackgroundColor3=T.Border;line.BorderSizePixel=0;return yPos+30
end
local function buildInput(parent,label,placeholder,default,yPos)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-28,0,56);row.Position=UDim2.new(0,14,0,yPos);row.BackgroundColor3=T.Card;corner(8,row)
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(1,-16,0,20);lbl.Position=UDim2.new(0,10,0,4);lbl.BackgroundTransparency=1;lbl.Text=label;lbl.TextColor3=T.TextDim;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=11;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local box=Instance.new("TextBox",row);box.Size=UDim2.new(1,-20,0,24);box.Position=UDim2.new(0,10,0,26);box.BackgroundColor3=T.AccentFaint;box.TextColor3=T.Text;box.Font=Enum.Font.Gotham;box.TextSize=13;box.PlaceholderText=placeholder;box.Text=default or "";box.PlaceholderColor3=T.TextFaint;box.ClearTextOnFocus=false;box.BorderSizePixel=0;corner(6,box)
    return box,yPos+64
end
local function buildButton(parent,label,yPos,bgCol,txtCol)
    local c=bgCol or T.Accent;local tc=txtCol or T.BG
    local btn=Instance.new("TextButton",parent);btn.Size=UDim2.new(1,-28,0,38);btn.Position=UDim2.new(0,14,0,yPos);btn.BackgroundColor3=c;btn.TextColor3=tc;btn.Font=Enum.Font.GothamBold;btn.TextSize=14;btn.Text=label;corner(8,btn)
    btn.MouseEnter:Connect(function() tw(btn,0.1,{BackgroundColor3=c:Lerp(Color3.new(1,1,1),0.1)}) end);btn.MouseLeave:Connect(function() tw(btn,0.1,{BackgroundColor3=c}) end)
    return btn,yPos+46
end
local function buildDropdown(parent,label,options,getter,setter,yPos)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-28,0,44);row.Position=UDim2.new(0,14,0,yPos);row.BackgroundColor3=T.Card;corner(8,row)
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(0.5,0,1,0);lbl.Position=UDim2.new(0,12,0,0);lbl.BackgroundTransparency=1;lbl.Text=label;lbl.TextColor3=T.Text;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=14;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local vBtn=Instance.new("TextButton",row);vBtn.Size=UDim2.new(0,130,0,28);vBtn.Position=UDim2.new(1,-144,0.5,-14);vBtn.BackgroundColor3=T.AccentFaint;vBtn.TextColor3=T.Text;vBtn.Font=Enum.Font.GothamSemibold;vBtn.TextSize=13;vBtn.Text=getter();corner(7,vBtn)
    vBtn.MouseButton1Click:Connect(function() local cur=getter();local idx=1;for i,v in ipairs(options) do if v==cur then idx=i;break end end;local nxt=options[(idx%#options)+1];setter(nxt);vBtn.Text=nxt end)
    return yPos+52
end
local function buildColorPreview(parent,sR,sG,sB,yPos)
    local row=Instance.new("Frame",parent);row.Size=UDim2.new(1,-28,0,36);row.Position=UDim2.new(0,14,0,yPos);row.BackgroundColor3=T.Card;corner(8,row)
    local lbl=Instance.new("TextLabel",row);lbl.Size=UDim2.new(0.5,0,1,0);lbl.Position=UDim2.new(0,12,0,0);lbl.BackgroundTransparency=1;lbl.Text="Renk Önizleme";lbl.TextColor3=T.TextDim;lbl.Font=Enum.Font.GothamMedium;lbl.TextSize=13;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local prev=Instance.new("Frame",row);prev.Size=UDim2.new(0,80,0,22);prev.Position=UDim2.new(1,-94,0.5,-11);prev.BackgroundColor3=Color3.fromRGB(_G[sR],_G[sG],_G[sB]);corner(6,prev)
    RunService.Heartbeat:Connect(function() prev.BackgroundColor3=Color3.fromRGB(_G[sR],_G[sG],_G[sB]) end)
    return yPos+44
end

-- Tabs
local tabBuilders={}

tabBuilders["ESP"]=function(p)
    local sc=makeScroll(p);local y=10
    y=buildSection(sc,"Görünürlük",y);y=buildToggle(sc,"ESP Aktif","ESP",y,function(v) if not v then clearAllESP() end end);y=buildToggle(sc,"3D Vurgu","ESPBox3D",y);y=buildToggle(sc,"2D Kutu","ESPBox2D",y);y=buildToggle(sc,"İskelet ESP","SkeletonESP",y)
    y=buildSection(sc,"Etiketler",y+4);y=buildToggle(sc,"İsim","ShowNames",y);y=buildToggle(sc,"Mesafe","ShowDistance",y);y=buildToggle(sc,"Can Çubuğu","ShowHealthBar",y);y=buildToggle(sc,"ID","ShowID",y);y=buildToggle(sc,"Tracer","ShowTracer",y);y=buildSlider(sc,"Tracer Kalınlık","TracerThick",y,0.5,6,"%.1f")
    y=buildSection(sc,"Filtreler",y+4);y=buildToggle(sc,"Düşmanları Göster","TeamCheck",y);y=buildToggle(sc,"Takım Arkadaşları","ShowFriendly",y);y=buildToggle(sc,"Duvar Kontrolü","WallCheck",y)
    y=buildSection(sc,"Düşman Rengi",y+4);y=buildColorPreview(sc,"ESPEnemyR","ESPEnemyG","ESPEnemyB",y);y=buildSlider(sc,"Kırmızı","ESPEnemyR",y,0,255,nil);y=buildSlider(sc,"Yeşil","ESPEnemyG",y,0,255,nil);y=buildSlider(sc,"Mavi","ESPEnemyB",y,0,255,nil)
    y=buildSection(sc,"Dost Rengi",y+4);y=buildColorPreview(sc,"ESPFriendR","ESPFriendG","ESPFriendB",y);y=buildSlider(sc,"Kırmızı","ESPFriendR",y,0,255,nil);y=buildSlider(sc,"Yeşil","ESPFriendG",y,0,255,nil);y=buildSlider(sc,"Mavi","ESPFriendB",y,0,255,nil)
    y=buildSection(sc,"Görünür Renk",y+4);y=buildColorPreview(sc,"ESPVisR","ESPVisG","ESPVisB",y);y=buildSlider(sc,"Kırmızı","ESPVisR",y,0,255,nil);y=buildSlider(sc,"Yeşil","ESPVisG",y,0,255,nil);y=buildSlider(sc,"Mavi","ESPVisB",y,0,255,nil)
    y=buildSection(sc,"Nişangah",y+4);y=buildToggle(sc,"Nişangah","Crosshair",y,function() buildCrosshair() end)
    y=buildDropdown(sc,"Stil",CH_STYLES,function() return _G.CrosshairStyle end,function(v) _G.CrosshairStyle=v;buildCrosshair() end,y)
    y=buildSlider(sc,"Boyut","CrosshairSize",y,4,50,nil,function() buildCrosshair() end);y=buildSlider(sc,"Kalınlık","CrosshairThick",y,1,8,nil,function() buildCrosshair() end);y=buildSlider(sc,"Boşluk","CrosshairGap",y,0,24,nil,function() buildCrosshair() end);y=buildSlider(sc,"Opaklık","CrosshairAlpha",y,0.1,1.0,"%.1f",function() buildCrosshair() end)
    y=buildToggle(sc,"Merkez Nokta","CrosshairDot",y,function() buildCrosshair() end);y=buildToggle(sc,"Dış Çizgi","CrosshairOutline",y,function() buildCrosshair() end)
    y=buildSection(sc,"Nişangah Rengi",y+4);y=buildColorPreview(sc,"CrosshairR","CrosshairG","CrosshairB",y);y=buildSlider(sc,"Kırmızı","CrosshairR",y,0,255,nil,function() buildCrosshair() end);y=buildSlider(sc,"Yeşil","CrosshairG",y,0,255,nil,function() buildCrosshair() end);y=buildSlider(sc,"Mavi","CrosshairB",y,0,255,nil,function() buildCrosshair() end)
end
tabBuilders["AIMBOT"]=function(p)
    local sc=makeScroll(p);local y=10
    y=buildSection(sc,"Aimbot",y);y=buildToggle(sc,"Aimbot","Aimbot",y);y=buildToggle(sc,"Rage Aimbot","RageAimbot",y,function(v) if v then enableRageAimbot() else disableRageAimbot() end end)
    y=buildSection(sc,"Silent Aim",y+4);y=buildToggle(sc,"Silent Aim","SilentAim",y,function(v) if v then enableSilentAim() else disableSilentAim() end end)
    y=buildSection(sc,"Otomatik Ateş",y+4);y=buildToggle(sc,"Auto Shoot","AutoShoot",y)
    y=buildSection(sc,"FOV",y+4);y=buildToggle(sc,"FOV Filtresi","UseFOV",y);y=buildToggle(sc,"FOV Dairesi","FOVVisible",y,function(v) if FOVCircle then FOVCircle.Visible=v end end);y=buildSlider(sc,"FOV Çapı","FOVSize",y,20,400,nil)
    y=buildSection(sc,"Yumuşaklık",y+4);y=buildSlider(sc,"Yumuşaklık","AimbotSmoothness",y,0.02,1.0,"%.2f")
    y=buildSection(sc,"Hedef",y+4);y=buildToggle(sc,"Kafa","AimbotPartHead",y);y=buildToggle(sc,"Göğüs","AimbotPartChest",y);y=buildToggle(sc,"Karın","AimbotPartStomach",y)
end
tabBuilders["OTHER"]=function(p)
    local sc=makeScroll(p);local y=10
    y=buildSection(sc,"Uçuş",y);y=buildToggle(sc,"Uç","FlyEnabled",y,function(v) if v then enableFly() else disableFly() end end);y=buildSlider(sc,"Uçuş Hızı","FlySpeed",y,10,300,nil)
    y=buildSection(sc,"Hareket",y+4);y=buildToggle(sc,"Noclip","NoClipEnabled",y,function(v) if v then enableNoclip() else disableNoclip() end end);y=buildToggle(sc,"Sonsuz Zıplama","InfiniteJump",y,function(v) if v then enableInfiniteJump() else disableInfiniteJump() end end);y=buildToggle(sc,"Uzun Atlama","LongJump",y,function(v) if v then enableLongJump() else disableLongJump() end end);y=buildSlider(sc,"Atlama Gücü","LongJumpPower",y,20,200,nil);y=buildToggle(sc,"Yüzme Hack","SwimHack",y)
    y=buildSection(sc,"Bunny Hop",y+4);y=buildToggle(sc,"Bunny Hop","BunnyHop",y,function(v) if v then enableBhop() else disableBhop() end end);y=buildSlider(sc,"Hız","BunnyHopSpeed",y,1.0,3.0,"%.1f")
    y=buildSection(sc,"Hız",y+4);y=buildToggle(sc,"Hız Hack","SpeedHack",y,function(v) if v then enableSpeed() else disableSpeed() end end);y=buildSlider(sc,"Çarpan","SpeedMultiplier",y,1.0,10.0,"%.1f")
    y=buildSection(sc,"Diğer",y+4);y=buildToggle(sc,"Stream Proof","StreamProof",y,function(v) if MainGui then MainGui.DisplayOrder=v and 200 or 10 end end)
end
tabBuilders["PLAYERS"]=function(p)
    local sc=makeScroll(p);local y=10
    y=buildSection(sc,"Savaş",y);y=buildToggle(sc,"Kill Aura","KillAura",y,function(v) if v then enableKillAura() else disableKillAura() end end);y=buildSlider(sc,"Menzil","KillAuraRange",y,5,50,nil)
    y=buildSection(sc,"Yardımcı",y+4);y=buildToggle(sc,"Anti AFK","AntiAFK",y,function(v) if v then enableAntiAFK() else disableAntiAFK() end end)
    y=buildSection(sc,"İsim Spoofing",y+4);y=buildToggle(sc,"İsim Değiştir","NameSpoof",y,function() applyNameSpoof() end)
    local nameBox;nameBox,y=buildInput(sc,"Sahte İsim","İsim gir","",y);local applyBtn;applyBtn,y=buildButton(sc,"Uygula",y);applyBtn.MouseButton1Click:Connect(function() _G.SpoofedName=nameBox.Text;applyNameSpoof() end)
    y=buildSection(sc,"Oyuncu Listesi",y+4);local stopBtn,_=buildButton(sc,"İzlemeyi Durdur",y,T.AccentFaint,T.Text);y=y+46;stopBtn.MouseButton1Click:Connect(stopSpectating)
    local plist=Instance.new("ScrollingFrame",sc);plist.Size=UDim2.new(1,-28,0,260);plist.Position=UDim2.new(0,14,0,y);plist.BackgroundColor3=T.Card;corner(8,plist);plist.ScrollBarThickness=3;plist.ScrollBarImageColor3=T.BorderLight;plist.CanvasSize=UDim2.new(0,0,0,0);plist.AutomaticCanvasSize=Enum.AutomaticSize.Y;plist.BorderSizePixel=0
    Instance.new("UIListLayout",plist).Padding=UDim.new(0,4);local pp=Instance.new("UIPadding",plist);pp.PaddingTop=UDim.new(0,6);pp.PaddingLeft=UDim.new(0,6);pp.PaddingRight=UDim.new(0,6)
    local function refreshPL()
        for _,c in ipairs(plist:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr==LocalPlayer then continue end
            local row=Instance.new("Frame",plist);row.Size=UDim2.new(1,0,0,40);row.BackgroundColor3=T.CardHov;corner(6,row)
            local nl=Instance.new("TextLabel",row);nl.Size=UDim2.new(0.42,0,1,0);nl.Position=UDim2.new(0,8,0,0);nl.BackgroundTransparency=1;nl.Text=plr.Name;nl.TextColor3=T.Text;nl.Font=Enum.Font.GothamSemibold;nl.TextSize=13;nl.TextXAlignment=Enum.TextXAlignment.Left
            local defs={{l="TP",c=Color3.fromRGB(55,55,180),x=0.43},{l="PULL",c=Color3.fromRGB(160,90,0),x=0.57},{l="SPEC",c=Color3.fromRGB(75,75,160),x=0.72},{l="FRZ",c=Color3.fromRGB(0,130,130),x=0.87}}
            local btns={};for _,bd in ipairs(defs) do local b=Instance.new("TextButton",row);b.Size=UDim2.new(0,42,0,28);b.Position=UDim2.new(bd.x,0,0.5,-14);b.BackgroundColor3=bd.c;b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextSize=11;b.Text=bd.l;corner(5,b);btns[bd.l]=b end
            btns["TP"].MouseButton1Click:Connect(function() if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame=plr.Character.HumanoidRootPart.CFrame+Vector3.new(0,3,0) end end)
            btns["PULL"].MouseButton1Click:Connect(function() if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then plr.Character.HumanoidRootPart.CFrame=LocalPlayer.Character.HumanoidRootPart.CFrame+Vector3.new(0,3,0) end end)
            btns["SPEC"].MouseButton1Click:Connect(function() if plr.Character and plr.Character:FindFirstChild("Humanoid") then Camera.CameraSubject=plr.Character.Humanoid end end)
            local frozen=false;btns["FRZ"].MouseButton1Click:Connect(function() frozen=not frozen;freezePlayer(plr,frozen);btns["FRZ"].Text=frozen and "FREE" or "FRZ";btns["FRZ"].BackgroundColor3=frozen and Color3.fromRGB(0,180,90) or Color3.fromRGB(0,130,130) end)
        end
    end
    refreshPL();Players.PlayerAdded:Connect(refreshPL);Players.PlayerRemoving:Connect(function() task.wait(0.2);refreshPL() end)
end
tabBuilders["ITEM"]=function(p)
    local sc=makeScroll(p);local y=10;y=buildSection(sc,"Eşya Ver",y);local pBox;pBox,y=buildInput(sc,"Kullanıcı","İsim","",y);local tBox;tBox,y=buildInput(sc,"Eşya","Sword","",y);local cBox;cBox,y=buildInput(sc,"Adet","1","1",y);local gBtn;gBtn,y=buildButton(sc,"Ver",y);local sBtn;sBtn,y=buildButton(sc,"Ara",y,T.AccentFaint,T.Text)
    local res=Instance.new("TextLabel",sc);res.Size=UDim2.new(1,-28,0,28);res.Position=UDim2.new(0,14,0,y);res.BackgroundTransparency=1;res.TextColor3=T.TextDim;res.Font=Enum.Font.GothamMedium;res.TextSize=13;res.TextWrapped=true;res.TextXAlignment=Enum.TextXAlignment.Left;y=y+34
    local toolsF=Instance.new("Frame",sc);toolsF.Size=UDim2.new(1,-28,0,180);toolsF.Position=UDim2.new(0,14,0,y);toolsF.BackgroundColor3=T.Card;corner(8,toolsF);local tlbl=Instance.new("TextLabel",toolsF);tlbl.Size=UDim2.new(1,0,0,26);tlbl.BackgroundTransparency=1;tlbl.Text="Eşya Listesi";tlbl.TextColor3=T.TextDim;tlbl.Font=Enum.Font.GothamBold;tlbl.TextSize=11;local tsc=Instance.new("ScrollingFrame",toolsF);tsc.Size=UDim2.new(1,-8,1,-30);tsc.Position=UDim2.new(0,4,0,28);tsc.BackgroundTransparency=1;tsc.ScrollBarThickness=3;tsc.CanvasSize=UDim2.new(0,0,0,0);tsc.AutomaticCanvasSize=Enum.AutomaticSize.Y;tsc.BorderSizePixel=0;Instance.new("UIListLayout",tsc).Padding=UDim.new(0,3)
    local function rfr() for _,c in ipairs(tsc:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end;task.spawn(function() local found={};for _,loc in ipairs({ServerStorage,ReplicatedStorage,Workspace}) do for _,item in ipairs(loc:GetDescendants()) do if item:IsA("Tool") then found[item.Name]=true end end end;local cnt=0;for name in pairs(found) do local btn=Instance.new("TextButton",tsc);btn.Size=UDim2.new(1,0,0,26);btn.Text=name;btn.TextColor3=T.Text;btn.Font=Enum.Font.Gotham;btn.TextSize=13;btn.BackgroundColor3=T.CardHov;corner(5,btn);btn.MouseButton1Click:Connect(function() tBox.Text=name end);cnt=cnt+1 end;res.Text=cnt>0 and(cnt.." bulundu") or "Bulunamadı";res.TextColor3=cnt>0 and T.KeyGreen or T.KeyRed end) end
    gBtn.MouseButton1Click:Connect(function() local ok,msg=giveItem(pBox.Text,tBox.Text,math.clamp(tonumber(cBox.Text) or 1,1,20));res.Text=msg;res.TextColor3=ok and T.KeyGreen or T.KeyRed end);sBtn.MouseButton1Click:Connect(rfr);rfr()
end
tabBuilders["TEAM CHANGE"]=function(p)
    local sc=makeScroll(p);local y=10;y=buildSection(sc,"Takım Değiştir",y);local uBox;uBox,y=buildInput(sc,"Kullanıcı","İsim",_G.TeamChangePlayerName,y);local tBox;tBox,y=buildInput(sc,"Takım","Takım adı",_G.TeamChangeTeamName,y);local cBtn;cBtn,y=buildButton(sc,"Değiştir",y)
    local res=Instance.new("TextLabel",sc);res.Size=UDim2.new(1,-28,0,28);res.Position=UDim2.new(0,14,0,y);res.BackgroundTransparency=1;res.TextColor3=T.TextDim;res.Font=Enum.Font.GothamMedium;res.TextSize=13;res.TextXAlignment=Enum.TextXAlignment.Left
    cBtn.MouseButton1Click:Connect(function() if uBox.Text=="" or tBox.Text=="" then res.Text="Doldur!";res.TextColor3=T.KeyRed;return end;local ok,msg=changeTeam(uBox.Text,tBox.Text);res.Text=msg;res.TextColor3=ok and T.KeyGreen or T.KeyRed;_G.TeamChangePlayerName=uBox.Text;_G.TeamChangeTeamName=tBox.Text end)
end
tabBuilders["VISUAL"]=function(p)
    local sc=makeScroll(p);local y=10;y=buildSection(sc,"Aydınlatma",y);y=buildToggle(sc,"Full Bright","FullBright",y,function(v) applyFullBright(v) end);y=buildToggle(sc,"Sis Kaldır","NoFog",y,function(v) applyNoFog(v) end)
    y=buildSection(sc,"Kamera",y+4);y=buildToggle(sc,"FOV Değiştir","FOVChanger",y,function(v) if not v then Camera.FieldOfView=origCamFOV end end);y=buildSlider(sc,"FOV Değeri","FOVChangerVal",y,50,200,nil,function(v) if _G.FOVChanger then Camera.FieldOfView=v end end)
    y=buildToggle(sc,"3. Şahıs","ThirdPerson",y,function(v) if v then enableThirdPerson() else disableThirdPerson() end end);y=buildSlider(sc,"Mesafe","ThirdPersonDist",y,4,30,nil)
    y=buildSection(sc,"Dünya",y+4);y=buildToggle(sc,"Saat Değiştir","TimeChanger",y,function(v) applyTime(v) end);y=buildSlider(sc,"Saat (0-23)","TimeOfDay",y,0,23,nil,function(v) if _G.TimeChanger then applyTime(true) end end)
    y=buildSection(sc,"Dünya Rengi",y+4);y=buildToggle(sc,"Renk Değiştir","WorldColor",y,function(v) applyWorldColor(v) end);y=buildColorPreview(sc,"WorldR","WorldG","WorldB",y);y=buildSlider(sc,"Kırmızı","WorldR",y,0,255,nil,function() if _G.WorldColor then applyWorldColor(true) end end);y=buildSlider(sc,"Yeşil","WorldG",y,0,255,nil,function() if _G.WorldColor then applyWorldColor(true) end end);y=buildSlider(sc,"Mavi","WorldB",y,0,255,nil,function() if _G.WorldColor then applyWorldColor(true) end end)
end
tabBuilders["CONFIG"]=function(p)
    local sc=makeScroll(p);local y=10
    local ic=Instance.new("Frame",sc);ic.Size=UDim2.new(1,-28,0,40);ic.Position=UDim2.new(0,14,0,y);ic.BackgroundColor3=T.AccentFaint;corner(8,ic);local il=Instance.new("TextLabel",ic);il.Size=UDim2.new(1,-16,1,0);il.Position=UDim2.new(0,8,0,0);il.BackgroundTransparency=1;il.Text="Config kaydet → Gist ID al → Paylaş";il.TextColor3=T.TextDim;il.Font=Enum.Font.Gotham;il.TextSize=12;il.TextWrapped=true;il.TextXAlignment=Enum.TextXAlignment.Left;y=y+48
    y=buildSection(sc,"Config Kaydet",y);local nameBox;nameBox,y=buildInput(sc,"Config Adı","benim-config","",y);local saveBtn;saveBtn,y=buildButton(sc,"Gist'e Kaydet",y,T.KeyGreen,Color3.new(1,1,1))
    local res=Instance.new("TextLabel",sc);res.Size=UDim2.new(1,-28,0,36);res.Position=UDim2.new(0,14,0,y);res.BackgroundTransparency=1;res.Font=Enum.Font.GothamMedium;res.TextSize=12;res.TextXAlignment=Enum.TextXAlignment.Left;res.TextWrapped=true;y=y+44
    saveBtn.MouseButton1Click:Connect(function()
        local n=nameBox.Text:gsub("[^%w%-_]",""):lower();if n=="" then res.Text="Ad gir!";res.TextColor3=T.KeyRed;return end
        saveBtn.Text="Kaydediliyor...";res.Text="Yükleniyor…";res.TextColor3=T.TextDim
        local ok2,json=pcall(function() return HttpService:JSONEncode(buildConfigData()) end)
        if not ok2 then res.Text="JSON hatası";res.TextColor3=T.KeyRed;saveBtn.Text="Kaydet";return end
        local ok,gistId=gistCreate(n,json);saveBtn.Text="Gist'e Kaydet"
        if ok then local gmap=loadGistMap();gmap[n]=gistId;saveGistMap(gmap);res.Text="Kaydedildi!\nKod: "..gistId;res.TextColor3=T.KeyGreen
        else res.Text="Başarısız.";res.TextColor3=T.KeyRed end
    end)
    y=buildSection(sc,"Config Yükle",y+4);local codeBox;codeBox,y=buildInput(sc,"Gist ID","abc123...","",y);local loadBtn;loadBtn,y=buildButton(sc,"Yükle",y,Color3.fromRGB(40,100,200),Color3.new(1,1,1))
    local loadRes=Instance.new("TextLabel",sc);loadRes.Size=UDim2.new(1,-28,0,28);loadRes.Position=UDim2.new(0,14,0,y);loadRes.BackgroundTransparency=1;loadRes.Font=Enum.Font.GothamMedium;loadRes.TextSize=13;loadRes.TextXAlignment=Enum.TextXAlignment.Left;y=y+36
    loadBtn.MouseButton1Click:Connect(function()
        local gistId=codeBox.Text:gsub("%s+","");if gistId=="" then loadRes.Text="ID gir!";loadRes.TextColor3=T.KeyRed;return end
        loadBtn.Text="Yükleniyor...";loadRes.Text="Çekiliyor…";loadRes.TextColor3=T.TextDim
        local ok,data=gistRead(gistId);loadBtn.Text="Yükle"
        if ok and data then applyConfigData(data);buildCrosshair();loadRes.Text="Yüklendi!"..(data.savedBy and(" ("..data.savedBy..")") or "");loadRes.TextColor3=T.KeyGreen
        else loadRes.Text="Başarısız.";loadRes.TextColor3=T.KeyRed end
    end)
    y=buildSection(sc,"Kayıtlılar",y+4);local gmap=loadGistMap();local has=false
    for cfgName,gistId in pairs(gmap) do
        has=true;local row=Instance.new("Frame",sc);row.Size=UDim2.new(1,-28,0,48);row.Position=UDim2.new(0,14,0,y);row.BackgroundColor3=T.Card;corner(8,row)
        local nl=Instance.new("TextLabel",row);nl.Size=UDim2.new(1,-200,1,0);nl.Position=UDim2.new(0,12,0,0);nl.BackgroundTransparency=1;nl.Text=cfgName;nl.TextColor3=T.Text;nl.Font=Enum.Font.GothamSemibold;nl.TextSize=13;nl.TextXAlignment=Enum.TextXAlignment.Left
        local function mkB(txt,col,xOff) local b=Instance.new("TextButton",row);b.Size=UDim2.new(0,54,0,28);b.Position=UDim2.new(1,xOff,0.5,-14);b.BackgroundColor3=col;b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextSize=11;b.Text=txt;corner(6,b);return b end
        local lb=mkB("Yükle",T.KeyGreen,-176);local cb=mkB("Kod",T.AccentFaint,-114);local db=mkB("Sil",T.KeyRed,-52)
        lb.MouseButton1Click:Connect(function() lb.Text="…";local ok,data=gistRead(gistId);lb.Text="Yükle";if ok and data then applyConfigData(data);buildCrosshair();res.Text="Yüklendi";res.TextColor3=T.KeyGreen else res.Text="Hata";res.TextColor3=T.KeyRed end end)
        cb.MouseButton1Click:Connect(function() res.Text="ID: "..gistId;res.TextColor3=T.TextDim end)
        db.MouseButton1Click:Connect(function() task.spawn(function() gistDelete(gistId) end);gmap[cfgName]=nil;saveGistMap(gmap);task.wait(0.3);switchTab("CONFIG") end)
        y=y+56
    end
    if not has then local el=Instance.new("TextLabel",sc);el.Size=UDim2.new(1,-28,0,28);el.Position=UDim2.new(0,14,0,y);el.BackgroundTransparency=1;el.Text="Henüz config yok.";el.TextColor3=T.TextFaint;el.Font=Enum.Font.GothamMedium;el.TextSize=13;el.TextXAlignment=Enum.TextXAlignment.Left end
end
tabBuilders["ABOUT"]=function(p)
    local sc=makeScroll(p);local lF=Instance.new("Frame",sc);lF.Size=UDim2.new(1,-28,0,80);lF.Position=UDim2.new(0,14,0,10);lF.BackgroundColor3=T.Card;corner(10,lF)
    local ll=Instance.new("TextLabel",lF);ll.Size=UDim2.new(1,0,0.6,0);ll.BackgroundTransparency=1;ll.Text="SUSANO";ll.TextColor3=T.Text;ll.Font=Enum.Font.GothamBlack;ll.TextSize=38
    local vl=Instance.new("TextLabel",lF);vl.Size=UDim2.new(1,0,0.4,0);vl.Position=UDim2.new(0,0,0.6,0);vl.BackgroundTransparency=1;vl.Text="v1.0  |  "..keyType:upper().."  |  "..USERNAME.."  |  "..formatTimeLeft(keyExpires);vl.TextColor3=T.TextDim;vl.Font=Enum.Font.GothamMedium;vl.TextSize=12
    local y=104
    for _,row in ipairs({{"Kısayol","F5 — Menü Aç/Kapat"},{"Key","GitHub Private Repo. HWID kilitleme."},{"Config","Gist ID paylaş."},{"GUI","PlayerGui — Xeno uyumlu."}}) do
        local card=Instance.new("Frame",sc);card.Size=UDim2.new(1,-28,0,0);card.AutomaticSize=Enum.AutomaticSize.Y;card.Position=UDim2.new(0,14,0,y);card.BackgroundColor3=T.Card;corner(8,card)
        local tl=Instance.new("TextLabel",card);tl.Size=UDim2.new(1,0,0,20);tl.Position=UDim2.new(0,12,0,8);tl.BackgroundTransparency=1;tl.Text=string.upper(row[1]);tl.TextColor3=T.TextFaint;tl.Font=Enum.Font.GothamBold;tl.TextSize=10;tl.TextXAlignment=Enum.TextXAlignment.Left
        local bl=Instance.new("TextLabel",card);bl.Size=UDim2.new(1,-24,0,0);bl.Position=UDim2.new(0,12,0,26);bl.AutomaticSize=Enum.AutomaticSize.Y;bl.BackgroundTransparency=1;bl.Text=row[2];bl.TextColor3=T.Text;bl.Font=Enum.Font.Gotham;bl.TextSize=13;bl.TextWrapped=true;bl.TextXAlignment=Enum.TextXAlignment.Left
        Instance.new("UIPadding",card).PaddingBottom=UDim.new(0,10);y=y+78
    end
end

-- Main Menu
local MainFrame,SideBar,Content
local currentTab="ESP";local menuBuilt=false;local minimized=false
local MENU_FULL=UDim2.new(0,870,0,640);local MENU_MINI=UDim2.new(0,870,0,46)
local TABS={{id="ESP",icon="[E]",label="ESP"},{id="AIMBOT",icon="[A]",label="Aimbot"},{id="OTHER",icon="[M]",label="Hareket"},{id="PLAYERS",icon="[P]",label="Oyuncular"},{id="ITEM",icon="[I]",label="Eşya"},{id="TEAM CHANGE",icon="[T]",label="Takım"},{id="VISUAL",icon="[V]",label="Görsel"},{id="CONFIG",icon="[C]",label="Config"},{id="ABOUT",icon="[?]",label="Hakkında"}}
local sideButtons={}

switchTab=function(id)
    currentTab=id
    for _,btn in ipairs(sideButtons) do
        local active=btn:GetAttribute("tabId")==id;tw(btn,0.15,{BackgroundColor3=active and T.ActiveSide or T.InactiveSide})
        local il=btn:FindFirstChild("IconLbl");local nl=btn:FindFirstChild("NameLbl")
        if il then tw(il,0.15,{TextColor3=active and T.BG or T.TextFaint}) end;if nl then tw(nl,0.15,{TextColor3=active and T.BG or T.TextDim}) end
    end
    for _,c in ipairs(Content:GetChildren()) do c:Destroy() end
    Content.BackgroundTransparency=0.15;tw(Content,0.12,{BackgroundTransparency=1})
    local builder=tabBuilders[id];if builder then builder(Content) end
end

local function createMenu()
    MainGui=makeGui("SusanoUI",200);MainGui.Enabled=true
    MainFrame=Instance.new("Frame",MainGui);MainFrame.Size=MENU_FULL;MainFrame.Position=UDim2.new(0.5,-435,0.5,-320);MainFrame.BackgroundColor3=T.BG;MainFrame.Active=true;MainFrame.ClipsDescendants=false;corner(10,MainFrame)
    for _,sd in ipairs({{4,3,0.82},{12,6,0.88},{22,10,0.94}}) do local s=Instance.new("Frame",MainFrame);s.Size=UDim2.new(1,sd[1],1,sd[1]);s.Position=UDim2.new(0,-sd[1]/2,0,sd[2]);s.BackgroundColor3=Color3.new(0,0,0);s.BackgroundTransparency=sd[3];s.ZIndex=MainFrame.ZIndex-1;s.BorderSizePixel=0;corner(15,s) end
    Instance.new("UIStroke",MainFrame).Color=T.BorderLight
    local tb=Instance.new("Frame",MainFrame);tb.Size=UDim2.new(1,0,0,46);tb.BackgroundColor3=T.TitleBar;tb.BorderSizePixel=0;tb.ClipsDescendants=true;corner(10,tb)
    local tbF=Instance.new("Frame",tb);tbF.Size=UDim2.new(1,0,0.5,0);tbF.Position=UDim2.new(0,0,0.5,0);tbF.BackgroundColor3=T.TitleBar;tbF.BorderSizePixel=0
    local titleLine=Instance.new("Frame",tb);titleLine.Size=UDim2.new(1,0,0,1);titleLine.Position=UDim2.new(0,0,1,-1);titleLine.BackgroundColor3=T.BorderLight;titleLine.BorderSizePixel=0;titleLine.BackgroundTransparency=0.5
    local logoTxt=Instance.new("TextLabel",tb);logoTxt.Size=UDim2.new(0,100,1,0);logoTxt.Position=UDim2.new(0,16,0,0);logoTxt.BackgroundTransparency=1;logoTxt.Text="SUSANO";logoTxt.TextColor3=T.Accent;logoTxt.Font=Enum.Font.GothamBlack;logoTxt.TextSize=18;logoTxt.TextXAlignment=Enum.TextXAlignment.Left
    local verTxt=Instance.new("TextLabel",tb);verTxt.Size=UDim2.new(0,40,1,0);verTxt.Position=UDim2.new(0,105,0,0);verTxt.BackgroundTransparency=1;verTxt.Text="v1.0";verTxt.TextColor3=T.TextFaint;verTxt.Font=Enum.Font.GothamMedium;verTxt.TextSize=11;verTxt.TextXAlignment=Enum.TextXAlignment.Left
    local kBadge=Instance.new("Frame",tb);kBadge.Size=UDim2.new(0,76,0,22);kBadge.Position=UDim2.new(0,156,0.5,-11);kBadge.BackgroundColor3=keyType=="lifetime" and T.KeyGold or(keyType=="monthly" and Color3.fromRGB(180,120,255) or(keyType=="weekly" and Color3.fromRGB(80,180,255) or T.AccentFaint));corner(5,kBadge)
    local kBL=Instance.new("TextLabel",kBadge);kBL.Size=UDim2.new(1,0,1,0);kBL.BackgroundTransparency=1;kBL.TextColor3=Color3.new(1,1,1);kBL.Font=Enum.Font.GothamBold;kBL.TextSize=11;local kn={daily="GÜNLÜK",weekly="HAFTALIK",monthly="AYLIK",lifetime="SINIRSIZ"};kBL.Text=kn[keyType] or keyType:upper()
    local timeLbl=Instance.new("TextLabel",tb);timeLbl.Size=UDim2.new(0,110,1,0);timeLbl.Position=UDim2.new(0,240,0,0);timeLbl.BackgroundTransparency=1;timeLbl.TextColor3=T.TextFaint;timeLbl.Font=Enum.Font.GothamMedium;timeLbl.TextSize=10;timeLbl.TextXAlignment=Enum.TextXAlignment.Left;timeLbl.Text=formatTimeLeft(keyExpires)
    task.spawn(function() while MainGui and MainGui.Parent do timeLbl.Text=formatTimeLeft(keyExpires);task.wait(60) end end)
    local hotkeyTxt=Instance.new("TextLabel",tb);hotkeyTxt.Size=UDim2.new(0,80,1,0);hotkeyTxt.Position=UDim2.new(0.5,-40,0,0);hotkeyTxt.BackgroundTransparency=1;hotkeyTxt.Text="F5 aç/kapat";hotkeyTxt.TextColor3=T.TextFaint;hotkeyTxt.Font=Enum.Font.GothamMedium;hotkeyTxt.TextSize=11
    local function mkTBtn(text,bgCol,xOff) local btn=Instance.new("TextButton",tb);btn.Size=UDim2.new(0,28,0,28);btn.Position=UDim2.new(1,xOff,0.5,-14);btn.BackgroundColor3=bgCol;btn.TextColor3=Color3.new(1,1,1);btn.Font=Enum.Font.GothamBold;btn.TextSize=15;btn.Text=text;corner(6,btn);return btn end
    local closeBtn=mkTBtn("x",T.CloseRed,-36);closeBtn.MouseEnter:Connect(function() tw(closeBtn,0.1,{BackgroundColor3=Color3.fromRGB(220,70,70)}) end);closeBtn.MouseLeave:Connect(function() tw(closeBtn,0.1,{BackgroundColor3=T.CloseRed}) end);closeBtn.MouseButton1Click:Connect(function() tw(MainFrame,0.18,{BackgroundTransparency=1});task.wait(0.2);MainGui.Enabled=false;MainFrame.BackgroundTransparency=0 end)
    local minBtn=mkTBtn("-",T.MinBtn,-70);minBtn.MouseButton1Click:Connect(function() minimized=not minimized;tw(MainFrame,0.2,{Size=minimized and MENU_MINI or MENU_FULL});task.wait(0.05);SideBar.Visible=not minimized;Content.Visible=not minimized end)
    SideBar=Instance.new("Frame",MainFrame);SideBar.Size=UDim2.new(0,170,1,-46);SideBar.Position=UDim2.new(0,0,0,46);SideBar.BackgroundColor3=T.Sidebar;SideBar.BorderSizePixel=0;corner(10,SideBar)
    local sbF=Instance.new("Frame",SideBar);sbF.Size=UDim2.new(1,0,0.5,0);sbF.BackgroundColor3=T.Sidebar;sbF.BorderSizePixel=0
    local sideDiv=Instance.new("Frame",MainFrame);sideDiv.Size=UDim2.new(0,1,1,-46);sideDiv.Position=UDim2.new(0,170,0,46);sideDiv.BackgroundColor3=T.BorderLight;sideDiv.BorderSizePixel=0;sideDiv.BackgroundTransparency=0.5
    sideButtons={}
    for i,tab in ipairs(TABS) do
        local btn=Instance.new("TextButton",SideBar);btn.Size=UDim2.new(1,-14,0,34);btn.Position=UDim2.new(0,7,0,5+(i-1)*37);btn.BackgroundColor3=tab.id==currentTab and T.ActiveSide or T.InactiveSide;btn.AutoButtonColor=false;btn.BorderSizePixel=0;btn.Text="";corner(7,btn);btn:SetAttribute("tabId",tab.id)
        local iL=Instance.new("TextLabel",btn);iL.Name="IconLbl";iL.Size=UDim2.new(0,30,1,0);iL.Position=UDim2.new(0,6,0,0);iL.BackgroundTransparency=1;iL.Text=tab.icon;iL.TextColor3=tab.id==currentTab and T.BG or T.TextFaint;iL.Font=Enum.Font.GothamBold;iL.TextSize=10
        local nL=Instance.new("TextLabel",btn);nL.Name="NameLbl";nL.Size=UDim2.new(1,-38,1,0);nL.Position=UDim2.new(0,34,0,0);nL.BackgroundTransparency=1;nL.Text=tab.label;nL.TextColor3=tab.id==currentTab and T.BG or T.TextDim;nL.Font=Enum.Font.GothamSemibold;nL.TextSize=13;nL.TextXAlignment=Enum.TextXAlignment.Left
        btn.MouseEnter:Connect(function() if btn:GetAttribute("tabId")~=currentTab then tw(btn,0.1,{BackgroundColor3=T.CardHov}) end end);btn.MouseLeave:Connect(function() if btn:GetAttribute("tabId")~=currentTab then tw(btn,0.1,{BackgroundColor3=T.InactiveSide}) end end);btn.MouseButton1Click:Connect(function() switchTab(tab.id) end);table.insert(sideButtons,btn)
    end
    Content=Instance.new("Frame",MainFrame);Content.Size=UDim2.new(1,-171,1,-46);Content.Position=UDim2.new(0,171,0,46);Content.BackgroundTransparency=1;Content.ClipsDescendants=true
    local dragging,dragStart,startPos=false;tb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true;dragStart=i.Position;startPos=MainFrame.Position;i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end) end end);local dragInput;tb.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then dragInput=i end end);UserInputService.InputChanged:Connect(function(i) if dragging and i==dragInput then local d=i.Position-dragStart;MainFrame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)
    local rH=Instance.new("Frame",MainFrame);rH.Size=UDim2.new(0,12,0,12);rH.Position=UDim2.new(1,-12,1,-12);rH.BackgroundTransparency=1;local rD=Instance.new("Frame",rH);rD.Size=UDim2.new(0,4,0,4);rD.Position=UDim2.new(1,-4,1,-4);rD.BackgroundColor3=T.BorderLight;rD.BackgroundTransparency=0.3;corner(2,rD)
    local resizing,resStart,resStartSz=false;rH.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then resizing=true;resStart=i.Position;resStartSz=Vector2.new(MainFrame.AbsoluteSize.X,MainFrame.AbsoluteSize.Y);i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then resizing=false end end) end end);local resInput;rH.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then resInput=i end end);UserInputService.InputChanged:Connect(function(i) if resizing and i==resInput then local d=i.Position-resStart;MainFrame.Size=UDim2.new(0,math.clamp(resStartSz.X+d.X,560,1300),0,math.clamp(resStartSz.Y+d.Y,400,900));SideBar.Size=UDim2.new(0,170,1,-46);Content.Size=UDim2.new(1,-171,1,-46) end end)
    menuBuilt=true;local ep=MainFrame.Position;MainFrame.Position=ep+UDim2.new(0,0,0,14);MainFrame.BackgroundTransparency=1;tw(MainFrame,0.22,{BackgroundTransparency=0,Position=ep});switchTab(currentTab)
end

-- Respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.spawn(function()
        task.wait(0.5)
        if _G.FlyEnabled then enableFly() end;if _G.NoClipEnabled then enableNoclip() end;if _G.BunnyHop then enableBhop() end;if _G.SpeedHack then enableSpeed() end;if _G.InfiniteJump then enableInfiniteJump() end;if _G.LongJump then enableLongJump() end;if _G.SwimHack then enableSwimHack() end;if _G.NameSpoof then applyNameSpoof() end;if _G.KillAura then enableKillAura() end
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

-- Main loop
local aimTarget=nil
startAutoShoot();enableSwimHack()

RunService.RenderStepped:Connect(function()
    if not _G.Verified then return end
    if _G.ESP then pcall(updateESP);for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and not espCache[p] and p.Character then buildESP(p) end end else clearAllESP() end
    pcall(updateSkeleton)
    if _G.Aimbot and not _G.RageAimbot then local t=getBestTarget();if t then local cf=CFrame.new(Camera.CFrame.Position,t.part.Position);Camera.CFrame=Camera.CFrame:Lerp(cf,t.part==aimTarget and _G.AimbotSmoothness or _G.AimbotSmoothness*1.5);aimTarget=t.part;updateFOVColor(Color3.fromRGB(80,255,120)) else aimTarget=nil;updateFOVColor(Color3.new(1,1,1)) end elseif not _G.RageAimbot then aimTarget=nil;updateFOVColor(Color3.new(1,1,1)) end
    if FOVCircle then local r=_G.FOVSize;FOVCircle.Size=UDim2.new(0,r*2,0,r*2);FOVCircle.Position=UDim2.new(0.5,-r,0.5,-r);FOVCircle.Visible=_G.FOVVisible and(_G.Aimbot or _G.RageAimbot or _G.SilentAim) end
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
    if _G.FullBright then applyFullBright(true) end;if _G.NoFog then applyNoFog(true) end
    if _G.FOVChanger then Camera.FieldOfView=_G.FOVChangerVal end;if _G.TimeChanger then applyTime(true) end;if _G.WorldColor then applyWorldColor(true) end
end)

-- Başlangıç
local savedKey=loadSavedKey()
if savedKey then
    validateKey(savedKey,function(ok,result,expires)
        if ok then
            keyValidated=true;keyType=result;keyExpires=expires;_G.Verified=true;activeKey=savedKey
            keyMenuGui:Destroy();createFOVCircle();task.spawn(function() task.wait(0.05);createMenu() end)
        else
            safeDel(KEY_FILE)
            buildKeyMenu(function() createFOVCircle();task.spawn(function() task.wait(0.05);createMenu() end) end)
        end
    end)
else
    buildKeyMenu(function() createFOVCircle();task.spawn(function() task.wait(0.05);createMenu() end) end)
end
