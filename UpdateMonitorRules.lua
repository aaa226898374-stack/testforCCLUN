local base = "https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/"

if fs.exists("MonitorRules.lua") then fs.delete("MonitorRules.lua") end
shell.run("wget", base .. "Monitor/MonitorRules.lua", "MonitorRules.lua")

print("MonitorRules updated")
print("Restart MonitorMain to apply")
