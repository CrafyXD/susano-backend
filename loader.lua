local t1="ghp_wG4l"
local t2="OHjlmUvwum"
local t3="ObSMZlppNaGyMq3H3JtpiC"
local token=t1..t2..t3

local ok, result = pcall(function()
    local resp = game:GetService("HttpService"):RequestAsync({
        Url = "https://raw.githubusercontent.com/CrafyXD/susano-backend/main/susano_obfuscated.lua",
        Method = "GET",
        Headers = {
            ["Authorization"] = "token " .. token,
            ["Accept"] = "application/vnd.github.v3.raw",
        }
    })
    if not resp.Success then
        error("HTTP " .. resp.StatusCode .. ": " .. resp.Body)
    end
    loadstring(resp.Body)()
end)

if not ok then
    warn("Susano yuklenemedi: " .. tostring(result))
end
