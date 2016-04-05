require "physics"
require "render"

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

function camera.visiblepredicate(obj)
	return type(obj) == "table" and not obj.invisible
end

function camera.transparentpredicate(obj)
	return type(obj) == "table" and obj.transparent
end

local function drawraycasthit(start, dir, pos, dist, obj, hitindex, axis, i, j, scanx, distfactor)
	dist = dist * distfactor
	pos.z = 0
	render.render(obj, pos, dist, scanx, i, j, axis)
end

local dir = Vector()
function camera:draw()
	local inc = 2 / screen.width
	local i = -1
	local scanx = 0
	while i < 1 do
		dir:set(self.plane):scale(i):add(self.dir):norm()
		local distfactor = dir:projectscalar(self.dir)
		physics.Domain.current:raycast(self.pos, dir, render.maxdist + 1, drawraycasthit, self.visiblepredicate, self.transparentpredicate, scanx, distfactor)
		i = i + inc
		scanx = scanx + 1
	end
	render.draw()
end
