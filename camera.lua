require "physics"
require "Vector"

camera = {
	viewdist = 8,
	pos = Vector(0, 0, 0.6),
	dir = Vector(),
	plane = Vector(),
}

function camera:setangle(r)
	self.dir:set(1, 0):rotate2d(r)
	self.plane:set(0, 1):rotate2d(r)
end
camera:setangle(0)

function camera:getangle()
	return self.dir:angle2d()
end

function camera.visiblepredicate(obj, x, y)
	return type(obj) == "table" and not obj.invisible
end

local function colorize(t, obj)
	return color.lerp(color.white, color.black, t)
end

local function drawraycasthit(start, dir, hit, dist, obj, hitindex, axis, scanx, distfactor)
	dist = dist * distfactor
	love.graphics.setColor(colorize(dist / camera.viewdist, obj))
	if hitindex == 0 and type(obj) == "table" then
		love.graphics.push()
			love.graphics.translate(scanx, (screen.height / 2) + (camera.pos.z - 1))
			love.graphics.scale(1, screen.height / dist)
			love.graphics.rectangle("fill", 0, 0, 1, 1)
		love.graphics.pop()
	end
end

local dir = Vector()
function camera:draw()
	local inc = 2 / screen.width
	local i = -1
	local scanx = 0
	while i < 1 do
		dir:set(self.plane):scale(i):add(self.dir):norm()
		local distfactor = dir:projectscalar(self.dir)
		physics.Domain.current:raycast(self.pos, dir, self.viewdist, drawraycasthit, self.visiblepredicate, scanx, distfactor)
		i = i + inc
		scanx = scanx + 1
	end
end
