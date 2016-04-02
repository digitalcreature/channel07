require "color"

screen = {}

screen.width = 64
screen.height = 36
screen.scale = 12	--default window scaling

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

function screen.draw() end

function love.draw()
	love.graphics.clear(color.black)
	love.graphics.setCanvas(screen.canvas)
	screen.draw()
	love.graphics.setCanvas()
	love.graphics.setColor(color.white)
	local w, h = love.window.getMode()
	love.graphics.draw(screen.canvas, 0, 0, 0, w / screen.width, h / screen.height)
	if (debugdraw) then debugdraw() end
end

local keyevent = {}
function keyevent.f4()
	local _, _, flags = love.window.getMode()
	if flags.fullscreen then
		love.window.setMode(screen.width * screen.scale, screen.height * screen.scale, screen.windowflags)
	else
		love.window.setMode(0, 0, screen.fullscreenflags)
	end
end

function screen.keypressed(key)
	if keyevent[key] then keyevent[key]() end
end
