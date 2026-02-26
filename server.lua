local socket = require("socket")
local repl = require("repl")

if not love then
    lovr = require("lovr")
    lovr.filesystem = require("lovr.filesystem")
    lovr.thread = require("lovr.thread")
end

function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function get_global()
    if lovr then
        return lovr.thread.getChannel( 'globals' ):pop()
    else
        return love.thread.getChannel( 'globals' ):pop()
    end
end

local g

-- if lovr then
--     g = lovr.thread.getChannel( 'globals' ):pop()
-- else
--     g = love.thread.getChannel( 'globals' ):pop()
-- end

local server = assert(socket.bind("*", 0))
-- find out which port the OS chose for us
local ip, port = server:getsockname()


print("TCP (telnet) REPL is listening localhost:" .. port .. " ...")
print("--- Please telnet to localhost on port " .. port)
print("--- After connecting, type 'exit' when you want to exit.")

while true do

    local client = server:accept()
    -- print("New client connected")

    -- client:settimeout(1)
    while true do
        local _g = get_global()
        if _g ~= nil then
            g = _g
        end

        client:send("\r> ")

        local line, err = client:receive()
        
        if not err then
            if trim(line) == "exit" then
                break
            else
                local res = repl.eval(g, line)
                client:send(res .. "\n")
            end
        end
    end

    client:send("Session closed.")
    client:close()
    -- print("Closed. Waiting next client.")
end