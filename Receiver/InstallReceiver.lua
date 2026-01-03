local base = "https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/"
local profile = ...

if not profile then
  print("Usage: InstallReceiver <RuleName>")
  return
end

if not fs.exists("Rules") then fs.makeDir("Rules") end
if not fs.exists("Tools") then fs.makeDir("Tools") end

shell.run("wget", base .. "Receiver/ReceiverMain.lua", "ReceiverMain.lua")
shell.run("wget", base .. "Receiver/startup.lua", "startup.lua")
shell.run("wget", base .. "Rules/" .. profile .. ".lua", "Rules/" .. profile .. ".lua")

local tools = {"reset.lua", "id.lua"}
for _, t in ipairs(tools) do
    shell.run("wget", base .. "Tools/" .. t, "Tools/" .. t)
end
fs.copy("Tools/reset.lua", "reset")

local cfgContent = string.format([[
return {
  RuleProfile = "%s",
  Net = { Protocol = "stock" },
}
]], profile)

local h = fs.open("ReceiverConfig.lua", "w")
h.write(cfgContent)
h.close()

print("ID: " .. os.getComputerID())
print("Reboot to start.")
