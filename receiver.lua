rednet.open("back")

while true do
  local from, msg = rednet.receive("stock")
  if type(msg) == "table" and msg.cmd == "start" and type(msg.program) == "string" then
    shell.run(msg.program)
  end
end
