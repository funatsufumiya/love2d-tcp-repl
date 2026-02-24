local fennel = require("fennel")

local is_lovr = _G.lovr
if is_lovr then
  love = lovr
end

local input = {}
local buffer = {}
local incomplete_3f = false
local function out(xs)
  local tbl_24_ = buffer
  for _, x in ipairs(xs) do
    local val_25_ = x
    table.insert(tbl_24_, val_25_)
  end
  return tbl_24_
end
local dp = print
_G.g_print = function(...)
  out({...})
  return nil
end
local function err(_errtype, msg)
  for line in msg:gmatch("([^\n]+)") do
    table.insert(buffer, {{0.9, 0.4, 0.5}, line})
  end
  return nil
end
local repl = coroutine.create(function (opt)
  fennel.repl(opt)
end)
coroutine.resume(repl, {readChunk = coroutine.yield, onValues = out, onError = err})

if is_lovr then
  lovr.conf = function(t)
    w = t.window.width
    h = t.window.height

    g_print(width .. " x " .. height)
  end
  lovr.resize = function(width, height)
    g_print(width .. " x " .. height)
  end
end

local function enter()
  do
    local input_text
    local function _1_()
      table.insert(input, "\n")
      return input
    end
    input_text = table.concat(_1_())
    local _, _let_2_ = coroutine.resume(repl, input_text)
    local _let_3_ = _let_2_
    local stack_size = _let_3_["stack-size"]
    incomplete_3f = (0 < stack_size)
  end
  while next(input) do
    table.remove(input)
  end
  return nil
end
love.keypressed = function(key)
  if (key == "return") then
    return enter()
  elseif (key == "backspace") then
    return table.remove(input)
  elseif (key == "escape") then
    return love.event.quit()
  else
    return nil
  end
end
love.textinput = function(text)
  return table.insert(input, text)
end

local function getFont()
  if is_lovr then
    return lovr.graphics.getDefaultFont()
  else
    return love.graphics.getFont()
  end
end
local function getWindowSize()
  if is_lovr then
    pass = lovr.graphics.getWindowPass()
    return pass:getWidth(), pass:getHeight()
  else
    return love.window.getMode()
  end
end
local function line(...)
  if is_lovr then
    local x1, y1, x2, y2 = ... 
    pass = lovr.graphics.getWindowPass()
    pass:line(x1, y1, 0, x2, y2, 0)
  else
    love.graphics.line(...)
  end
end

local function graphcis_print(...)
  if is_lovr then
    local s, x, y = ...
    pass = lovr.graphics.getWindowPass()
    pass:text(s, x, y, 0)
  else
    love.graphics.print(...)
  end
end

local dp = _G.print

local draw_fn = function()
  local w, h = getWindowSize()
  local fh = getFont():getHeight()
  for i = #buffer, 1, -1 do
    local case_5_ = buffer[i]
    if (nil ~= case_5_) then
      local line = case_5_
      graphcis_print(line, 2, (i * (fh + 2)))
    else
    end
  end
  line(0, (h - fh - 4), w, (h - fh - 4))
  if incomplete_3f then
    graphcis_print("- ", 2, (h - fh - 2))
  else
    graphcis_print("> ", 2, (h - fh - 2))
  end
  return graphcis_print(table.concat(input), 15, (h - fh - 2))
end

if is_lovr then
  lovr.draw = function(pass)
    draw_fn()
  end
else
  love.draw = draw_fn
end

return love.draw
