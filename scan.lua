local name = ...
if not name then
  print("Usage: scan <peripheral_name>")
  print("Example: scan functionalstorage:acacia_1_0")
  return
end

local inv = peripheral.wrap(name)
if not inv then
  print("Peripheral not found: " .. name)
  return
end

if not inv.list then
  print("This peripheral has no inventory")
  return
end

local items = inv.list()
local count = 0
for slot, item in pairs(items) do
  print(slot .. ": " .. item.name .. " x" .. item.count)
  count = count + 1
end

if count == 0 then
  print("Container is empty")
else
  print("Total slots used: " .. count)
end
