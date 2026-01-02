actions = {}

function actions.pulse(side, sec)
  sec = sec or 0.2
  return function()
    redstone.setOutput(side, true)
    sleep(sec)
    redstone.setOutput(side, false)
  end
end

function actions.set(side, level)
  return function()
    redstone.setOutput(side, level and true or false)
  end
end
