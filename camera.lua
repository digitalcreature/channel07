require "physics"
require "render"

require "Pool"
require "Vector"

camera = {
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

local temp = Vector()
function camera:getscreenpoint(x, y, z)
	local dist = temp:set(x, y, z):sub(self.pos):projectscalar(self.dir)
	local scanx = temp:set(x, y, z):sub(self.pos):projectscalar(self.plane)
	scanx = ((scanx / (dist * self.plane:len()) + 1) / 2) * screen.width
	local screeny = self.pos.z - z
	return dist, scanx, screeny
end

function camera.visiblepredicate(obj)
	return type(obj) == "table" and not obj.invisible
end

function camera.transparentpredicate(obj)
	return type(obj) == "table" and obj.transparent
end

local function drawraycasthit(start, dir, pos, dist, obj, hitindex, axis, sign, i, j, scanx, distfactor)
	dist = dist * distfactor
	local info = tablepool:checkout()
	info.x, info.y, info.z = pos.x, pos.y, 0
	info.dist = dist
	info.scanx = scanx
	info.i, info.j = i, j
	info.axis = axis
	info.sign = sign
	render.render(obj, info)
end

local dir, pos = Vector(), Vector()
function camera:render()
	local inc = 2 / screen.width
	local i = -1
	local scanx = 0
	-- self.pos.z = math.cos(love.timer.getTime() * 8) / 8 + .6
	pos:set(self.pos)
	pos.z = 0
	while i < 1 do
		dir:set(self.plane):scale(i):add(self.dir):norm()
		local distfactor = dir:projectscalar(self.dir)
		physics.Domain.current:raycast(pos, dir, render.maxdist + 1, drawraycasthit, self.visiblepredicate, self.transparentpredicate, scanx, distfactor)
		i = i + inc
		scanx = scanx + 1
	end
end
