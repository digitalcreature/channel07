require "screen"

pause = {}

pause.paused = false

function pause.focus(focused)
	pause.setpaused(not focused)
end

function pause.setpaused(paused)
	if paused ~= pause.paused and not paused then
		screen.centercursor()
	end
	pause.paused = paused
end

local keyevent = {}

function keyevent.escape()
	pause.setpaused(true)
	love.mouse.setVisible(true)
	return true
end

function pause.keypressed(key)
	return keyevent[key] and keyevent[key]()
end

local mouseevent = {}

mouseevent[1] =  function(x, y)
	if pause.paused then
		pause.setpaused(false)
		screen.centercursor()
		return true
	end
end

function pause.mousepressed(x, y, button)
	return mouseevent[button] and mouseevent[button](x, y)
end
