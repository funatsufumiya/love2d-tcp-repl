local server_thread

function server_start()
	if lovr then
		server_thread = lovr.thread.newThread("server.lua")
	else
		server_thread = love.thread.newThread("server.lua")
	end
	server_thread:start()
end

----

local t = 0

-- load
if lovr then
	function lovr.load()
		server_start()
	end
else
	function love.load()
		server_start()
	end
end

-- update
if lovr then
	function lovr.update(dt)
		t = t + dt
	end
else
	function love.update(dt)
		t = t + dt
	end
end

-- draw
if lovr then
	function lovr.draw(pass)
		pass:text('hello world', 0, 1.7, -5, 1, t)
	end
else
	function love.draw()
		x = math.sin(t) * 100 + 100
		y = math.cos(t) * 100 + 100
		love.graphics.rectangle("fill", x, y, 30, 30)
	end
end