local socket = require("socket")
local repl = require("repl")

function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local server = assert(socket.bind("*", 0))
-- find out which port the OS chose for us
local ip, port = server:getsockname()


print("Listening tcp://localhost:" .. port .. " ...")
print("--- Please telnet to localhost on port " .. port)
print("--- After connecting, type 'exit' when you want to exit.")

while true do

    local client = server:accept()
    -- print("New client connected")

    client:settimeout(10)
    while true do
        client:send("\r> ")

        local line, err = client:receive()
        
        if not err then
            if trim(line) == "exit" then
                break
            else
                local res = repl.eval(line)
                client:send(res .. "\n")
            end
        end
    end

    client:send("Session closed.")
    client:close()
    -- print("Closed. Waiting next client.")
end