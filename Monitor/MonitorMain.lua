local rulePath = "Rules/RuleMonitor.lua"
if not fs.exists(rulePath) then
    error("Config not found: " .. rulePath)
end
local Cfg = dofile(rulePath)

local modem = peripheral.find("modem")
if not modem then
  print("Error: No modem found.")
  return
else
  rednet.open(peripheral.getName(modem))
  print("Monitor Network: " .. peripheral.getName(modem))
end

local function getInventories()
  local invs = {}
  for _, name in ipairs(peripheral.getNames()) do
    if string.find(name, Cfg.Scan.Prefix) then
      local inv = peripheral.wrap(name)
      if inv and inv.list then invs[#invs+1] = inv end
    end
  end
  return invs
end

local Inventories = getInventories()
print("Monitoring " .. #Inventories .. " inventories")

local Active = {}

local function countResource(resource)
  local total = 0
  for _, inv in ipairs(Inventories) do
    if inv.list then
        local success, list = pcall(inv.list)
        if success and list then
            for _, it in pairs(list) do
              if it.name == resource then total = total + it.count end
            end
        end
    end
  end
  return total
end

while true do
  if #Inventories == 0 then Inventories = getInventories() end

  for _, r in ipairs(Cfg.GetRules) do
    local n = countResource(r.Resource)
    local key = r.Resource .. "@" .. r.TargetID

    if n < r.Low then
      if not Active[key] then
        print("\n[LOW] " .. r.Resource .. " (" .. n .. " < " .. r.Low .. ")")
        print("SEND -> ID:" .. r.TargetID .. " [GET]")
        rednet.send(r.TargetID, { Op = "GET", Resource = r.Resource }, Cfg.Net.Protocol)
        Active[key] = true
      end
    else
      if Active[key] then
        print("\n[OK] " .. r.Resource .. " Replenished.")
        print("SEND -> ID:" .. r.TargetID .. " [PUT]")
        rednet.send(r.TargetID, { Op = "PUT", Resource = r.Resource }, Cfg.Net.Protocol)
        Active[key] = false
      end
    end
  end

  sleep(Cfg.Scan.Interval or 2)
end
