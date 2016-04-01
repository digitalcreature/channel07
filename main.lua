require "screen"

function love.load(arg)
	screen.load()
end

function love.update(dt)

end

function screen.draw()
	for x = 0, screen.width do
		for y = 0, screen.height do
			love.graphics.setColor(color.random())
			love.graphics.rectangle("fill", x, y, 1, 1)
		end
	end
end

function love.keypressed(key)
	screen.keypressed(key)
end
