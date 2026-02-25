local export = {}
local stringify = require('stringify')
local array = require('array')

local is_lovr = _G.lovr
if is_lovr then
  love = lovr
end

export.input = {}
export.buffer = {}

local dp = print
function export.out(xs)
  local t = {}
  for _, x in ipairs(xs) do
    for line in x:gmatch("([^\n]+)") do
      table.insert(t, line)
    end
  end
  export.buffer = array.concat(t, export.buffer)
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

function export.eval_impl(inCodeStr)
    if inCodeStr:find("=") then
        ___fn = load(inCodeStr)
    else
        ___fn = load("return (" .. inCodeStr .. ")")
    end

    if ___fn then
      return ___fn()
    else
      -- WORKAROUND
      -- export.err(nil, debug.traceback)
      return nil
      -- return export.err(nil, )
    end

    -- local r,s=fn(inCodeStr)
    -- if r~=nil then
    --     return r()
    -- else
    --     export.err(s)
    -- end
end

-- local repl = coroutine.create(function ()
--   while true
--   do
--     export.out(export.eval(coroutine.yield))
--   end
-- end)

-- coroutine.resume(repl)

function export.eval(s)
  -- dp(s)
  -- coroutine.resume(repl, s)
  export.out({stringify(export.eval_impl(s))})

  local t = {}
  table.insert(t, "> " .. s)
  export.buffer = array.concat(t, export.buffer)
  
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