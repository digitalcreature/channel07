require "color"
require "physics"
require "camera"
require "vector"

player = {
	x = 0,
	y = 0,
	w = 3/4,
	h = 3/4,
	nontile = true,
}

function player.key(x, y)
	player.x = x - (player.w / 2) + .5
	player.y = y - (player.h / 2) + .5
	return player
end

local spdx, spdy = 3, 3
function player:update(dt)
	local dx, dy = 0, 0
	if love.keyboard.isDown("w", "up") then dy = dy - spdy * dt end
	if love.keyboard.isDown("s", "down") then dy = dy + spdy * dt end
	if love.keyboard.isDown("a", "left") then dx = dx - spdx * dt end
	if love.keyboard.isDown("d", "right") then dx = dx + spdx * dt end
	physics.moveentity(self, dx, dy, level.current)
	vector.copy(camera.pos, self:center())
	camera:setangle(-love.mouse.getX() / (12 * math.pi))
end

function player:draw()
	love.graphics.push()
		love.graphics.translate(self.x, self.y)
		love.graphics.setColor(color.blue)
		love.graphics.rectangle("fill", 0, 0, self.w, self.h)
	love.graphics.pop()
end

function player:center()
	return self.x + self.w / 2, self.y + self.h / 2
end
