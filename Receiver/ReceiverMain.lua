local cfg = dofile("ReceiverConfig.lua")

if not fs.exists("ReceiverRules") then fs.makeDir("ReceiverRules") end

local rulePath = fs.combine("ReceiverRules", cfg.RuleProfile .. ".lua")
if not fs.exists(rulePath) then
  print("Rule not found: " .. rulePath)
  print("Run: UpdateReceiverRule")
  return
end

local rules = dofile(rulePath)

rednet.open(cfg.Self.ModemSide)
rednet.host(cfg.Net.Protocol, cfg.Self.HostName)

local function applyOutputs(outputs, on)
  for _, o in ipairs(outputs or {}) do
    redstone.setOutput(o.Side, on and true or false)
  end
end

print("Receiver: " .. cfg.Self.HostName)

while true do
  local from, msg = rednet.receive(cfg.Net.Protocol)
  if type(msg) == "table" and type(msg.Op) == "string" and type(msg.Resource) == "string" then
    local rule = rules.PutRules[msg.Resource]
    if rule then
      if msg.Op == "GET" then
        applyOutputs(rule.Outputs, true)
        print("ON: " .. msg.Resource)
      elseif msg.Op == "PUT" then
        applyOutputs(rule.Outputs, false)
        print("OFF: " .. msg.Resource)
      end
    end
  end
end

