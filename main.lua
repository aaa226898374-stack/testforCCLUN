dofile("invscan.lua")
dofile("rules.lua")

local invs = invscan.getInventories()
print("Found " .. #invs .. " inventories")

while true do
  for _, r in ipairs(rules) do
    local n = invscan.countItem(invs, r.item)
    print(r.item .. ": " .. n .. " (low=" .. r.low .. ")")
    
    if n < r.low then
      print("TRIGGER!")
      r.act()
    end
  end
  
  sleep(1)
end
