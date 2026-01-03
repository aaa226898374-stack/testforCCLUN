for _, name in ipairs(peripheral.getNames()) do
  if string.find(name, "functionalstorage:") then
    local inv = peripheral.wrap(name)
    if inv and inv.list then
      for _, item in pairs(inv.list()) do
        print(item.name .. " x" .. item.count .. " (" .. name .. ")")
      end
    end
  end
end
