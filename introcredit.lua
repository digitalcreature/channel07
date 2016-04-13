require "color"

require "State"

local state = State()

local t = 0
local tend = 8

function state:onenter()
	t = 0
end

local imgs = {
	love.graphics.newImage("ui/intro-credit.png"),
	love.graphics.newImage("ui/intro-jam.png"),
	love.graphics.newImage("ui/intro-title.png"),
}

function state:update(dt)
	t = t + dt
	if t >= tend then
		loadlevel()
	end
end

function state:draw()
	local t = t / tend
	love.graphics.clear()
	love.graphics.setColor(color.lerp(color.black, color.white, 1.5 * math.abs(math.sin(t * math.pi * #imgs))))
	local img = imgs[math.floor(t * #imgs) + 1]
	if img then
		love.graphics.draw(img, 0, 0)
	end
end

function state:keypressed()
	loadlevel()
end

function state:mousepressed()
	loadlevel()
end

return state
