UI2D = require "ui2d..ui2d"
common = require("common")

local export = {}
local txt1 = ""

function export.draw()
	UI2D.Begin( "input", 0, 0 )
	txt1, finished_editing = UI2D.TextBox( "", 40, txt1 )
	if UI2D.Button( "submit" ) then
		common.eval(txt1)
		txt1 = ""
	end
	UI2D.SameLine()
	if finished_editing then
	end
	UI2D.End()

    local lst = {}
    if common.getBufferLen() > 0 then
        lst = common.getBuffer()
    end

	UI2D.Begin( "output", 0, 130 )
	-- UI2D.Label("                     ")
	-- UI2D.Label("a b\nc d\ne f")
	local clicked, idx = UI2D.ListBox( "", 20, 40, lst )
	-- if clicked then
	-- 	-- print( "selected item: " .. idx .. " - " .. some_list[ idx ] )
	-- end
	UI2D.End()

end

return export