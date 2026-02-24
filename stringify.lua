--[[

https://github.com/kitsunies/stringify.lua

MIT License

Copyright (c) 2026 Fumiya Funatsu
Copyright (c) 2020 Kitsun

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

]]

local table_to_str

local function val_to_str(v)
    if "string" == type(v) then
        v = string.gsub(v, "\n", "\\n")
        if string.match(string.gsub(v, '[^\'"]', ""), '^"+$') then
            return "'" .. v .. "'"
        end
        return '"' .. string.gsub(v, '"', '\\"') .. '"'
    else
        -- return "table" == type(v) and table_to_str(v) or tostring(v)
        return tostring(v)
    end
end

local function key_to_str(k)
    if "string" == type(k) and string.match(k, "^[_%a][_%a%d]*$") then
        -- return "[\"" .. k .. "\"]"
        return k
    else
        -- return "[" .. val_to_str(k) .. "]"
        return val_to_str(k)
    end
end

table_to_str = function(tbl)
    local ret, done = {}, {}
    for i, v in ipairs(tbl) do
        table.insert(ret, val_to_str(v))
        done[i] = true
    end
    for k, v in pairs(tbl) do
        if not done[k] then
            table.insert(ret, "  " .. key_to_str(k) .. " = " .. val_to_str(v))
        end
    end
    return "{\n" .. table.concat(ret, ",\n") .. "\n}"
end

return function(v)
    if type(v) == "table" then
        return table_to_str(v)
    else 
        return val_to_str(v)
    end
end
