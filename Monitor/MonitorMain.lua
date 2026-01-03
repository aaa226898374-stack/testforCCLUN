local rulePath = "Rules/RuleMonitor.lua"
if not fs.exists(rulePath) then error("Config not found") end
local Cfg = dofile(rulePath)

local modem = peripheral.find("modem")
if modem then rednet.open(peripheral.getName(modem)) end

local output = term
if Cfg.DisplayMonitorID then
    for _, name in ipairs(peripheral.getNames()) do
        if peripheral.getType(name) == "monitor" then
            if name == Cfg.DisplayMonitorID then
                output = peripheral.wrap(name)
                output.setTextScale(0.5)
                break
            end
        end
    end
end

output.clear()
output.setCursorPos(1,1)
output.write("Init inventories...")

local Inventories = {}
for _, name in ipairs(peripheral.getNames()) do
  if string.find(name, Cfg.Scan.Prefix) then
    table.insert(Inventories, peripheral.wrap(name))
  end
end
output.setCursorPos(1,2)
output.write("Monitoring " .. #Inventories .. " invs.")

local Active = {}
local logHistory = {} 

local function addLog(msg)
    table.insert(logHistory, 1, os.time() .. " " .. msg)
    if #logHistory > 10 then table.remove(logHistory) end
end

while true do
  local counts = {}
  
  for _, inv in ipairs(Inventories) do
    local success, list = pcall(inv.list)
    if success and list then
      for _, item in pairs(list) do
        counts[item.name] = (counts[item.name] or 0) + item.count
      end
    end
  end

  for i, r in ipairs(Cfg.GetRules) do
    local current = counts[r.Resource] or 0
    local key = r.Resource .. "@" .. r.TargetID
    
    output.setCursorPos(1, 3 + i)
    output.clearLine()
    local status = Active[key] and "[ON ]" or "[OFF]"
    output.write(status .. " " .. r.Resource .. ": " .. current .. "/" .. r.Low)

    if current < r.Low then
      if not Active[key] then
        addLog("[LOW] " .. r.Resource)
        rednet.send(r.TargetID, { Op = "GET", Resource = r.Resource }, Cfg.Net.Protocol)
        Active[key] = true
      end
    else
      if Active[key] then
        addLog("[OK ] " .. r.Resource)
        rednet.send(r.TargetID, { Op = "PUT", Resource = r.Resource }, Cfg.Net.Protocol)
        Active[key] = false
      end
    end
  end

  local logStart = 5 + #Cfg.GetRules
  output.setCursorPos(1, logStart)
  output.write("--- Event Log ---")
  for i, msg in ipairs(logHistory) do
      output.setCursorPos(1, logStart + i)
      output.clearLine()
      output.write(msg)
  end
  
  sleep(Cfg.Scan.Interval or 0.5)
end
