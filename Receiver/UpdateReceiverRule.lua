local base = "https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/"
local profile = ...

if not profile then
  local cfg = dofile("ReceiverConfig.lua")
  profile = cfg.RuleProfile
end

if not fs.exists("ReceiverRules") then fs.makeDir("ReceiverRules") end

local target = fs.combine("ReceiverRules", profile .. ".lua")
if fs.exists(target) then fs.delete(target) end

shell.run("wget", base .. "ReceiverRules/" .. profile .. ".lua", target)

print("Rule updated: " .. profile)
print("Restart to apply")
