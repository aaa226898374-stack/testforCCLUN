-- invscan.lua: 掃描容器與計數物品
invscan = {}

function invscan.getInventories()
  local invs = {}
  for _, name in ipairs(peripheral.getNames()) do
    if string.find(name, "functionalstorage:") then
      local inv = peripheral.wrap(name)
      if inv and inv.list then 
        invs[#invs+1] = inv 
      end
    end
  end
  return invs
end

function invscan.countItem(invs, itemName)
  local total = 0
  for _, inv in ipairs(invs) do
    for _, it in pairs(inv.list()) do
      if it.name == itemName then 
        total = total + it.count 
      end
    end
  end
  return total
end
