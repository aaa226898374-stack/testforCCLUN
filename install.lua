local base = "https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/"
local files = {
  "main.lua",
  "rules.lua",
  "invscan.lua",
  "actions.lua",
  "receiver.lua",
  "startup.lua",
  "scan.lua",
  "scanall.lua",
}

for _, f in ipairs(files) do
  if fs.exists(f) then fs.delete(f) end
  shell.run("wget", base .. f, f)
end

print("OK")
