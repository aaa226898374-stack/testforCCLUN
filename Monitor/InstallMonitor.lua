local base = "https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/"

if not fs.exists("Rules") then fs.makeDir("Rules") end
if not fs.exists("Tools") then fs.makeDir("Tools") end

shell.run("wget", base .. "Monitor/MonitorMain.lua", "MonitorMain.lua")
shell.run("wget", base .. "Rules/RuleMonitor.lua", "Rules/RuleMonitor.lua")

local tools = {"reset.lua", "scan.lua", "id.lua", "scanall.lua"}
for _, t in ipairs(tools) do
    shell.run("wget", base .. "Tools/" .. t, "Tools/" .. t)
end
fs.copy("Tools/reset.lua", "reset")

print("Monitor Installed.")
print("Run: MonitorMain")
