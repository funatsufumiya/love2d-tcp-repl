local socket = require("socket")
-- local repl = require("repl")

if not love then
    lovr = require("lovr")
    lovr.filesystem = require("lovr.filesystem")
    lovr.thread = require("lovr.thread")
    lovr.timer = require("lovr.timer")
else
    love.timer = require("love.timer")
end

function sleep(t)
    if lovr then
        return lovr.timer.sleep(t)
    else
        return love.timer.sleep(t)
    end
end

function get_channel(s)
    if lovr then
        return lovr.thread.getChannel(s)
    else
        return love.thread.getChannel(s)
    end
end

function wait_eval(s)
    get_channel("netrepl_input"):push(s)

    local ch = get_channel("netrepl_result")
    while true do
        local res = ch:pop()
        if res ~= nil then
            return res
        end

        sleep(0)
    end
end

function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local g

local server = assert(socket.bind("*", 0))
-- find out which port the OS chose for us
local ip, port = server:getsockname()


print("TCP (telnet) REPL is listening localhost:" .. port .. " ...")
print("--- Please telnet to localhost on port " .. port)
print("--- After connecting, type 'exit' when you want to exit.")

while true do

    local client = server:accept()
    -- print("New client connected")

    client:send("\rtype 'exit' to close connection\n")

    while true do
        client:send("\r> ")

        local line, err = client:receive()
        
        if not err then
            if trim(line) == "exit" then
                break
            else
                -- local res = repl.eval(g, line)
                local res = wait_eval(line)
                client:send(res .. "\n")
            end
        else
            break
        end
    end

    client:send("Session closed.")
    client:close()
    -- print("Closed. Waiting next client.")
end