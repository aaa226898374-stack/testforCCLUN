return {
  Net = { Protocol = "stock" },
  Scan = { Prefix = "functionalstorage:", Interval = 0.5 },

  DisplayMonitorID = "monitor_0", 

  GetRules = {
    {
      Resource = "ftbmaterials:copper_plate",
      Low = 256,
      TargetID = 15,
    },
    {
      Resource = "ftbmaterials:iron_plate",
      Low = 256,
      TargetID = 15,
    },
  }
}
