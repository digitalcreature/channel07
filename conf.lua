require "screen"

function love.conf(t)
	t.console = true
	t.window.title = "CHANNEL07"
	t.window.width = screen.getwindowwidth()
	t.window.height = screen.getwindowheight()
	t.window.resizable = true
	t.window.minwidth = screen.width
	t.window.minheight = screen.height
	t.window.vsync = true
end
