local rulePath = "Rules/RuleMonitor.lua"
if not fs.exists(rulePath) then error("Config not found") end
local Cfg = dofile(rulePath)

local modem = peripheral.find("modem")
if modem then rednet.open(peripheral.getName(modem)) end

print("Initializing inventories...")
local Inventories = {}
for _, name in ipairs(peripheral.getNames()) do
  if string.find(name, Cfg.Scan.Prefix) then
    table.insert(Inventories, peripheral.wrap(name))
  end
end
print("Monitoring " .. #Inventories .. " inventories.")

local Active = {}

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

  local startY = 3 
  for i, r in ipairs(Cfg.GetRules) do
    local currentAmount = counts[r.Resource] or 0
    local key = r.Resource .. "@" .. r.TargetID

    term.setCursorPos(1, startY + i)
    term.clearLine()
    term.write(r.Resource .. ": " .. currentAmount .. " / " .. r.Low)

    if currentAmount < r.Low then
      if not Active[key] then
        local x, y = term.getCursorPos()
        term.setCursorPos(1, 15) 
        print("[LOW] " .. r.Resource .. " -> ID:" .. r.TargetID)
        rednet.send(r.TargetID, { Op = "GET", Resource = r.Resource }, Cfg.Net.Protocol)
        Active[key] = true
        term.setCursorPos(x, y)
      end
    else
      if Active[key] then
        local x, y = term.getCursorPos()
        term.setCursorPos(1, 15)
        print("[OK] " .. r.Resource .. " Replenished.")
        rednet.send(r.TargetID, { Op = "PUT", Resource = r.Resource }, Cfg.Net.Protocol)
        Active[key] = false
        term.setCursorPos(x, y)
      end
    end
  end
  
  sleep(Cfg.Scan.Interval or 0.5)
end
