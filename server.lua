local export = {}
local socket = require("socket")
local copas = require("copas")

function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function server_handler()
end

function export.server_loop(repl_eval_fn)
    local server = assert(socket.bind("*", 0))
    -- find out which port the OS chose for us
    local ip, port = server:getsockname()

    copas.addserver(server, server_handler)


    print("TCP (telnet) REPL is listening localhost:" .. port .. " ...")
    print("--- Please telnet to localhost on port " .. port)
    print("--- After connecting, type 'exit' when you want to exit.")

    -- local client_list = {}

    while true do

        -- local ready_socks, _, err = socket.select(client_list, nil, 0)

        -- if err and err ~= "timeout" then
        --     print(err)
        -- end

        -- for _, sock in ipairs(ready_socks) do
        --     if sock == server then
        --         print("New client " .. client)
        --         local client = server:accept()
        --         table.insert(client_list, client)
            
        --         client:settimeout(0)
        --         client:send("\rWelcome. Please type 'exit' when you want to exit.")
        --         client:send("\r> ")
        --     else
        --         print("Existing client")
        --         local client = sock
        --         -- treating existing client
        --         local line, err = client:receive()
                
        --         if not err then
        --             if trim(line) == "exit" then
        --                 client:send("Session closed.")
        --                 client:close()
        --                 print("Closed " .. client)
        --             else
        --                 local res = repl_eval_fn(line)
        --                 client:send(res .. "\n")
        --             end
        --         end
        --     end

        --     -- client:send("Session closed.")
        --     -- client:close()
        --     -- print("Closed. Waiting next client.")

        copas.step()
        coroutine.yield()
        -- end
    end
end

function export.start(repl_eval_fn)
    -- if lovr then
	-- 	server_thread = lovr.thread.newThread("server.lua")
	-- else
	-- 	server_thread = love.thread.newThread("server.lua")
	-- end
	-- server_thread:start()

    co = coroutine.create(export.server_loop)
    coroutine.resume(co, repl_eval_fn)
    return co
end

return export