require "screen"
require "level"

function love.load(arg)
	screen.load()
	level.current = require "level.0"
end

function love.update(dt)

end

function screen.draw()
	for x = 0, level.current.width - 1 do
		for y = 0, level.current.height - 1 do
			local obj = level.current[x][y]
			if obj then
				love.graphics.push()
					love.graphics.translate(x, y)
					obj:draw()
				love.graphics.pop()
			else
				love.graphics.setColor(16, 16, 16)
				love.graphics.rectangle("fill", x, y, 1, 1)
			end
		end
	end
end

function love.keypressed(key)
	screen.keypressed(key)
end
