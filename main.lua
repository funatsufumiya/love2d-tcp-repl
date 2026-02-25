local sep = package.config:sub(1,1)
function join_path(a, b)
	return a .. sep .. b
end

local base_path
if lovr then
	base_path = lovr.filesystem.getSource()
else
	base_path = love.filesystem.getSource()
end

print(base_path)
local f = io.open(join_path(base_path, "server.lua"))
local s = f:read '*a'
f:close()
print(s)