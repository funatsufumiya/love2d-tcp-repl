local export = {}
local stringify = require('stringify')
local array = require('array')
require "table.clear"

local sep = package.config:sub(1,1)

local is_lovr = _G.lovr
if is_lovr then
  love = lovr
end

local server_thread

function export.server_start(port)
	if lovr then
		server_thread = lovr.thread.newThread("server.lua")
	else
		server_thread = love.thread.newThread("server.lua")
	end
	server_thread:start(port)
end

function get_channel(s)
    if lovr then
        return lovr.thread.getChannel(s)
    else
        return love.thread.getChannel(s)
    end
end

function export.server_update()
  local input = get_channel("netrepl_input"):pop()
  if input ~= nil then
    local res = export.eval(input)
    get_channel("netrepl_result"):push(res)
  end
end

export.input = {}
export.buffer = {}

local dp = print
local de = error
local dw = warn

function export.out(xs)
  local t = {}
  for _, x in ipairs(xs) do
    for line in x:gmatch("([^\n]+)") do
      table.insert(export.buffer, line)
    end
  end
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
end

function export.eval(s)
  -- dp(s)

  _G.print = function(...)
    export.out({...})
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
  
  export.out({stringify(export.eval_impl(s))})
  
  -- dp(#export.buffer)

  _G.print = dp
  _G.error = de
  _G.warn = dw

  local newline = "\n"
  if sep == "\\" then
    -- windows workaround
    newline = "\r\n"
  end
  local buf = table.concat(export.buffer, newline)
  table.clear(export.buffer)

  return buf
end

return export