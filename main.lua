if lovr then
	server_th = lovr.thread.newThread("server.lua")
else
	server_th = love.thread.newThread("server.lua")
end

server_th:start()