local Cfg = dofile("MonitorRules.lua")
rednet.open(Cfg.Self.ModemSide)

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
    for _, it in pairs(inv.list()) do
      if it.name == resource then total = total + it.count end
    end
  end
  return total
end

local function sendRequest(targetHost, op, resource)
  local id = rednet.lookup(Cfg.Net.Protocol, targetHost)
  if id then
    rednet.send(id, { Op = op, Resource = resource }, Cfg.Net.Protocol)
  end
end

while true do
  for _, r in ipairs(Cfg.GetRules) do
    local n = countResource(r.Resource)
    local key = r.Resource .. "@" .. r.TargetHost

    if n < r.Low then
      if not Active[key] then
        sendRequest(r.TargetHost, "GET", r.Resource)
        Active[key] = true
        print("START: " .. r.Resource .. " -> " .. r.TargetHost)
      end
    else
      if Active[key] then
        sendRequest(r.TargetHost, "PUT", r.Resource)
        Active[key] = false
        print("STOP: " .. r.Resource)
      end
    end
  end

  sleep(Cfg.Scan.Interval or 1)
end

