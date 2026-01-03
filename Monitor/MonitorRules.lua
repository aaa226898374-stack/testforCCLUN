return {
  Net = { Protocol = "stock" },
  Scan = { Prefix = "functionalstorage:", Interval = 2 },

  GetRules = {
    {
      Resource = "ftbmaterials:copper_plate",
      Low = 256,
      TargetID = 8,
    },
    {
      Resource = "minecraft:coal",
      Low = 128,
      TargetID = 16,
    },
  }
}
