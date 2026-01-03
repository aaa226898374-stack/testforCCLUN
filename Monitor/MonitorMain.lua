local Cfg = dofile("MonitorRules.lua")

if not peripheral.find("modem", rednet.open) then
  print("Error: No modem found on side: " .. (Cfg.Self.ModemSide or "any"))
  return
end

print("Monitor started on protocol: " .. Cfg.Net.Protocol)

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

local function sendRequest(targetHost, op, resource)
  local id = rednet.lookup(Cfg.Net.Protocol, targetHost)
  
  if id then
    print("SEND -> " .. targetHost .. " (ID:" .. id .. "): " .. op)
    rednet.send(id, { Op = op, Resource = resource }, Cfg.Net.Protocol)
  else
    local numId = tonumber(targetHost)
    if numId then
        print("SEND -> ID:" .. numId .. " (Direct): " .. op)
        rednet.send(numId, { Op = op, Resource = resource }, Cfg.Net.Protocol)
    else
        print("WARN: Host '" .. targetHost .. "' not found. Broadcasting...")
        rednet.broadcast({ Op = op, Resource = resource, TargetName = targetHost }, Cfg.Net.Protocol)
    end
  end
end

while true do
  if #Inventories == 0 then
      Inventories = getInventories()
  end

  for _, r in ipairs(Cfg.GetRules) do
    local n = countResource(r.Resource)
    local key = r.Resource .. "@" .. r.TargetHost

    if n < r.Low then
      if not Active[key] then
        print("\n[LOW] " .. r.Resource .. " (" .. n .. " < " .. r.Low .. ")")
        sendRequest(r.TargetHost, "GET", r.Resource)
        Active[key] = true
      end
    else
      if Active[key] then
        print("\n[OK] " .. r.Resource .. " Replenished.")
        sendRequest(r.TargetHost, "PUT", r.Resource)
        Active[key] = false
      end
    end
  end

  sleep(Cfg.Scan.Interval or 2)
end
