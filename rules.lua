-- rules.lua (監控電腦)
dofile("actions.lua")

rules = {
  {
    item = "minecraft:iron_ingot",
    low  = 256,
    act  = actions.startRemote(12, "main"),
  },
  {
    item = "minecraft:coal",
    low  = 128,
    act  = actions.startRemote(23, "main"),
  },
}
