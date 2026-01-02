dofile("actions.lua")
rules = {
  {
    item = "minecraft:iron_ingot",
    low  = 256,
    act  = actions.pulse("right", 0.2),
  },
}
