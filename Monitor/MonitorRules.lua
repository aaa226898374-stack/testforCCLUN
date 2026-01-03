return {
  Net = { Protocol = "stock" },
  Self = { ModemSide = "back" },
  Scan = { Prefix = "functionalstorage:", Interval = 1 },

  GetRules = {
    {
      Resource = "ftbmaterials:copper_plate",
      Low = 256,
      TargetHost = "press1",
    },
    {
      Resource = "ftbmaterials:iron_plate",
      Low = 256,
      TargetHost = "press1",
    },
    {
      Resource = "minecraft:coal",
      Low = 128,
      TargetHost = "furnace1",
    },
  }
}

