local base = "https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/"

if not fs.exists("Rules") then fs.makeDir("Rules") end

shell.run("wget", base .. "Monitor/MonitorMain.lua", "MonitorMain.lua")

shell.run("wget", base .. "Rules/RuleMonitor.lua", "Rules/RuleMonitor.lua")

print("Monitor Installed.")
print("Config: Rules/RuleMonitor.lua")
print("Run: MonitorMain")
