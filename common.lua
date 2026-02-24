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
    for line in x:gmatch("([^\n]+)") do
      table.insert(export.buffer, line)
    end
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

function export.warn(_errtype, msg)
  for line in msg:gmatch("([^\n]+)") do
    table.insert(export.buffer, "[warn] " .. line)
  end
  return nil
end
_G.error = function(...)
  export.err({...})
  return nil
end
_G.warn = function(...)
  export.warn({...})
  return nil
end

function export.eval(inCodeStr)
    if inCodeStr:find("=") then
        fn = load(inCodeStr)
    else
        fn = load("return export.out(" .. inCodeStr .. ")")
    end

    return fn()()

    -- local r,s=fn(inCodeStr)
    -- if r~=nil then
    --     return r()
    -- else
    --     export.err(s)
    -- end
end

local repl = coroutine.create(function ()
  while true
  do
    export.eval(coroutine.yield)
  end
end)

coroutine.resume(repl)

function export.eval(s)
  -- dp(s)
  table.insert(export.buffer, "> " .. s)
  coroutine.resume(repl, s)
  -- dp(#export.buffer)
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