local fennel = require("fennel")

local export = {}

local is_lovr = _G.lovr
if is_lovr then
  love = lovr
end

export.input = {}
export.buffer = {}

local dp = print
function export.out(xs)
  for _, x in ipairs(xs) do
    table.insert(export.buffer, x)
  end
  return export.buffer
end
_G.print = function(...)
  export.out({...})
  return nil
end
function export.err(_errtype, msg)
  for line in msg:gmatch("([^\n]+)") do
    table.insert(export.buffer, "[err] " .. line)
  end
  return nil
end
local repl = coroutine.create(function (opt)
  fennel.repl(opt)
end)
coroutine.resume(repl, {readChunk = coroutine.yield, onValues = export.out, onError = export.err})

function export.eval(s)
  dp(s)
  table.insert(export.buffer, "> " .. s)
  coroutine.resume(repl, s .. "\n")
  dp(#export.buffer)
end

function export.setInput(s)
  export.input = s
end

function export.getInput()
  return export.input
end

function export.getBuffer()
  return export.buffer
end

function export.getBufferLen()
  return #export.buffer
end

return export