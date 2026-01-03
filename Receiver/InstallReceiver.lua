local base = "https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/"
local profile = ...

if not profile then
  print("Usage: InstallReceiver <RuleName>")
  print("Example: InstallReceiver RuleForPress1")
  return
end

local files = { "Receiver/ReceiverMain.lua", "Receiver/UpdateReceiverRule.lua", "Receiver/startup.lua" }
for _, f in ipairs(files) do
  shell.run("wget", base .. f, fs.getName(f))
end

local cfgContent = string.format([[
return {
  RuleProfile = "%s",
  Net = { Protocol = "stock" },
  Self = { ModemSide = "top" },
}
]], profile)

local h = fs.open("ReceiverConfig.lua", "w")
h.write(cfgContent)
h.close()


if not fs.exists("ReceiverRules") then fs.makeDir("ReceiverRules") end
shell.run("wget", base .. "ReceiverRules/" .. profile .. ".lua", "ReceiverRules/" .. profile .. ".lua")


print("--------------------------------")
print("Install Complete!")
print("THIS COMPUTER ID: " .. os.getComputerID()) 
print("--------------------------------")
print("Please update MonitorRules.lua with ID: " .. os.getComputerID())
print("Reboot to start.")
