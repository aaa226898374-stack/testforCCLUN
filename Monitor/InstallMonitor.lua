local base = "https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/"

local files = {
  "Monitor/MonitorMain.lua",
  "Monitor/MonitorRules.lua",
  "Monitor/UpdateMonitorRules.lua",
  "Tools/scan.lua",
  "Tools/scanall.lua",
}

for _, f in ipairs(files) do
  local target = fs.getName(f)
  if fs.exists(target) then fs.delete(target) end
  shell.run("wget", base .. f, target)
end

print("Monitor installed")
print("Run: MonitorMain")

