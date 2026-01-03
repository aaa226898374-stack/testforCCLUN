local base = "https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/"
local profile = ...

if not profile then
  print("Usage: InstallReceiver <RuleName>")
  print("Example: InstallReceiver RuleForPress1")
  return
end

local files = {
  "Receiver/ReceiverMain.lua",
  "Receiver/UpdateReceiverRule.lua",
  "Receiver/startup.lua",
}

for _, f in ipairs(files) do
  local target = fs.getName(f)
  if fs.exists(target) then fs.delete(target) end
  shell.run("wget", base .. f, target)
end

local hostname = profile:gsub("RuleFor", ""):lower()

local cfgContent = string.format([[
return {
  RuleProfile = "%s",
  Net = { Protocol = "stock" },
  Self = { ModemSide = "back", HostName = "%s" },
}
]], profile, hostname)

local h = fs.open("ReceiverConfig.lua", "w")
h.write(cfgContent)
h.close()

if not fs.exists("ReceiverRules") then fs.makeDir("ReceiverRules") end

local target = fs.combine("ReceiverRules", profile .. ".lua")
shell.run("wget", base .. "ReceiverRules/" .. profile .. ".lua", target)

print("Receiver installed: " .. profile)
print("HostName: " .. hostname)
print("Reboot to start")

