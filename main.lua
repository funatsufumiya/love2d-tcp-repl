local fennel = require("fennel")
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
_G.print = function(...)
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
love.draw = function()
  local w, h = love.window.getMode()
  local fh = love.graphics.getFont():getHeight()
  for i = #buffer, 1, -1 do
    local case_5_ = buffer[i]
    if (nil ~= case_5_) then
      local line = case_5_
      love.graphics.print(line, 2, (i * (fh + 2)))
    else
    end
  end
  love.graphics.line(0, (h - fh - 4), w, (h - fh - 4))
  if incomplete_3f then
    love.graphics.print("- ", 2, (h - fh - 2))
  else
    love.graphics.print("> ", 2, (h - fh - 2))
  end
  return love.graphics.print(table.concat(input), 15, (h - fh - 2))
end
return love.draw
