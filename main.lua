local repl = require("repl")

----

local t = 0
test_val = "hello!!!!"

-- load
if lovr then
	function lovr.load()
		repl.server_start()
	end
else
	function love.load()
		repl.server_start()
	end
end

-- update
if lovr then
	function lovr.update(dt)
		t = t + dt
		repl.server_update()
	end
else
	function love.update(dt)
		t = t + dt
		repl.server_update()
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