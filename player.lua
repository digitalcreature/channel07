require "color"
require "physics"
require "camera"
require "screen"

require "Vector"

player = physics.Entity(0, 0, 1/3, 1/3)

player.nontile = true
--facing direction
player.dir = math.pi
--move speed
player.spdx = 2
player.spdy = 2
--keyboard look speed (rad/s)
player.lookspd = 1.5
--mouselook sensitivity
player.sensitivity = .003

function player:load()
	screen.centercursor()
end

function player.key(x, y)
	player.x = x - (player.w / 2) + .5
	player.y = y - (player.h / 2) + .5
	return player
end

local dpos = Vector()
function player:update(dt)
	local ddir = 0
	if love.keyboard.isDown("left") then ddir = ddir + self.lookspd * dt end
	if love.keyboard.isDown("right") then ddir = ddir - self.lookspd * dt end
	if love.window.hasFocus() then
		local mousex = love.mouse.getX()
		local center = love.window.getMode() / 2
		ddir = ddir - (mousex - center) * self.sensitivity
		love.mouse.setVisible(false)
		screen.centercursor()
	end
	self.dir = self.dir + ddir
	camera:setangle(self.dir)
	dpos:set(0, 0)
	if love.keyboard.isDown("w", "up") then dpos.y = dpos.y - self.spdy end
	if love.keyboard.isDown("s", "down") then dpos.y = dpos.y + self.spdy end
	if love.keyboard.isDown("a") then dpos.x = dpos.x - self.spdx end
	if love.keyboard.isDown("d") then dpos.x = dpos.x + self.spdx end
	dpos:rotate2d(self.dir - (math.pi / 2))
	dpos:scale(dt)
	self:move(dpos:xy())
	camera.pos:set(self:center())
end

function player:render()
end
