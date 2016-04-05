require "color"
require "debug2"

screen = {}

screen.width = 64
screen.height = 64
screen.scale = 12	--default window scaling
screen.ratio = 16 / 9

screen.windowflags = {
	fullscreen = false,
	vsync = false,
	resizable = true,
	centered = true,
	minwidth = screen.width,
	minheight = screen.height,
}

screen.fullscreenflags = {
	fullscreen = true,
	fullscreentype = desktop,
	vsync = true,
}

function screen.load()
	screen.canvas = love.graphics.newCanvas(screen.width, screen.height);
	screen.canvas:setFilter("nearest", "nearest")
end

function screen.getwindowwidth()
	return screen.width * screen.scale
end

function screen.getwindowheight()
	return (screen.height * screen.scale) / screen.ratio
end

function screen.draw() end

function love.draw()
	love.graphics.clear(color.black)
	love.graphics.setCanvas(screen.canvas)
	screen.draw()
	love.graphics.setCanvas()
	love.graphics.setColor(color.white)
	local w, h = love.window.getMode()
	love.graphics.draw(screen.canvas, 0, 0, 0, w / screen.width, h / screen.height)
	if (debug.draw) then debug.draw() end
	if debug.showfps then
		love.graphics.setColor(color.white)
		love.graphics.print(math.floor(1 / love.timer.getDelta()).."FPS", 0, 0)
	end
end

local keyevent = {}
function keyevent.f4()
	local _, _, flags = love.window.getMode()
	if flags.fullscreen then
		love.window.setMode(screen.getwindowwidth(), screen.getwindowheight(), screen.windowflags)
	else
		love.window.setMode(0, 0, screen.fullscreenflags)
	end
	return true
end

function screen.keypressed(key)
	return keyevent[key] and keyevent[key]()
end

function screen.centercursor()
	local w, h = love.window.getMode()
	love.mouse.setPosition(w / 2, h / 2)
end
