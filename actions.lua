actions = {}

function actions.startRemote(targetId, program)
  return function()
    rednet.send(targetId, { cmd = "start", program = program }, "stock")
  end
end
