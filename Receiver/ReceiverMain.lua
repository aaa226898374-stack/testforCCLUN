local cfg = dofile("ReceiverConfig.lua")

local modem = peripheral.find("modem")
if not modem then
  print("Error: No modem found.")
  return
else
  rednet.open(peripheral.getName(modem))
  print("Receiver ID: " .. os.getComputerID())
end

if not fs.exists("Rules") then fs.makeDir("Rules") end
local rulePath = "Rules/" .. cfg.RuleProfile .. ".lua"

if not fs.exists(rulePath) then
  print("Rule not found: " .. rulePath)
  return
end

local rules = dofile(rulePath)

local function applyOutputs(outputs, on)
  for _, o in ipairs(outputs or {}) do
    redstone.setOutput(o.Side, on and true or false)
    print((on and "[ON] " or "[OFF] ") .. o.Side)
  end
end

while true do
  local senderId, msg = rednet.receive(cfg.Net.Protocol)
  if type(msg) == "table" and type(msg.Op) == "string" then
    print("CMD from " .. senderId .. ": " .. msg.Op .. " " .. msg.Resource)
    local rule = rules.PutRules[msg.Resource]
    if rule then
      if msg.Op == "GET" then applyOutputs(rule.Outputs, true)
      elseif msg.Op == "PUT" then applyOutputs(rule.Outputs, false)
      end
    else
      print("Unknown resource: " .. msg.Resource)
    end
  end
end
