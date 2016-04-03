require "color"
require "physics"
require "camera"
require "vector"

player = {
	x = 0,
	y = 0,
	w = 1/3,
	h = 1/3,
	nontile = true,
	--facing direction
	dir = math.pi,
	--move speed
	spdx = 2,
	spdy = 2,
	--keyboard look speed (rad/s)
	lookspd = 1.5,
	--mouselook sensitivity
	sensitivity = .01,
}

local function centercursor()
	local w, h = love.window.getMode()
	love.mouse.setPosition(w / 2, h / 2)
end

function player:load()
	centercursor()
end

function player.key(x, y)
	player.x = x - (player.w / 2) + .5
	player.y = y - (player.h / 2) + .5
	return player
end

local dpos = {}
function player:update(dt)
	local ddir = 0
	if love.keyboard.isDown("left") then ddir = ddir + self.lookspd * dt end
	if love.keyboard.isDown("right") then ddir = ddir - self.lookspd * dt end
	local mousex = love.mouse.getX()
	local center = love.window.getMode() / 2
	ddir = ddir - (mousex - center) * self.sensitivity
	love.mouse.setVisible(false)
	centercursor()
	self.dir = self.dir + ddir
	camera:setangle(self.dir)
	vector.copy(dpos, 0, 0)
	if love.keyboard.isDown("w", "up") then dpos.y = dpos.y - self.spdy * dt end
	if love.keyboard.isDown("s", "down") then dpos.y = dpos.y + self.spdy * dt end
	if love.keyboard.isDown("a") then dpos.x = dpos.x - self.spdx * dt end
	if love.keyboard.isDown("d") then dpos.x = dpos.x + self.spdx * dt end
	vector.copy(dpos, vector.rotate(dpos, self.dir - (math.pi / 2)))
	physics.moveentity(self, dpos.x, dpos.y, level.current)
	vector.copy(camera.pos, self:center())
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
