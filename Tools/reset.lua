local base = "https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/"

print("Press 'y' to RESET and UPDATE Tools...")
local event, char = os.pullEvent("char")
if char ~= "y" then return end

local files = fs.list("")
for _, file in ipairs(files) do
    if file ~= "Tools" and file ~= "rom" then
        fs.delete(file)
    end
end

if not fs.exists("Tools") then fs.makeDir("Tools") end
local tools = {"reset.lua", "scan.lua", "id.lua"}

for _, t in ipairs(tools) do
    local path = "Tools/" .. t
    if fs.exists(path) then fs.delete(path) end
    shell.run("wget", base .. "Tools/" .. t, path)
end

fs.copy("Tools/reset.lua", "reset")
print("Reset Complete.")
