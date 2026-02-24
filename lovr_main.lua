UI2D = require "ui2d..ui2d"

lovr.graphics.setBackgroundColor( 0.2, 0.2, 0.7 )
local txt1 = ""

function lovr.load()
	-- Initialize the library. You can optionally pass a font size. Default is 14.
	UI2D.Init( "lovr" )
end

function lovr.keypressed( key, scancode, repeating )
	UI2D.KeyPressed( key, repeating )
end

function lovr.textinput( text, code )
	UI2D.TextInput( text )
end

function lovr.keyreleased( key, scancode )
	UI2D.KeyReleased()
end

function lovr.wheelmoved( deltaX, deltaY )
	UI2D.WheelMoved( deltaX, deltaY )
end

function lovr.update( dt )
	-- This gets input information for the library.
	UI2D.InputInfo()
end

function lovr.update( dt )
	-- This gets input information for the library.
	UI2D.InputInfo()
end

function lovr.draw( pass )
	pass:setProjection( 1, mat4():orthographic( pass:getDimensions() ) )

	UI2D.Begin( "window", 0, 0 )
	txt1, finished_editing = UI2D.TextBox( "", 40, txt1 )
	if UI2D.Button( "submit" ) then
		txt1 = ""
	end
	UI2D.SameLine()
	if finished_editing then
	end
	UI2D.End()
	
	local ui_passes = UI2D.RenderFrame( pass )
	table.insert( ui_passes, pass )
	return lovr.graphics.submit( ui_passes )
end
