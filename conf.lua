require "screen"

function love.conf(t)
	t.console = true
	t.window.width = screen.width * screen.scale
	t.window.height = screen.height * screen.scale
	t.window.resizable = true
	t.window.minwidth = screen.width
	t.window.minheight = screen.height
	t.window.vsync = false
end
