require "physics"
require "vector"

local vec = vector

local temp = {}
camera = {
	viewdist = 8,
	pos = {x = 0, y = 0, z = .6},
	dir = {},
	plane = {},
}

function camera:setangle(r)
	vec.copy(temp, 1, 0)
	vec.copy(self.dir, vec.rotate(temp, r))
	vec.copy(temp, 0, 1)
	vec.copy(self.plane, vec.rotate(temp, r))
end
camera:setangle(0)

function camera:getangle()
	return vec.angle(self.dir)
end

function camera.visiblepredicate(obj, x, y)
	return type(obj) == "table" and not obj.invisible
end

local function colorize(t, obj)
	return color.lerp(obj.color, color.black, t)
end

local function drawraycasthit(start, dir, hit, dist, obj, hitindex, axis, scanx, distfactor)
	dist = dist * distfactor
	love.graphics.setColor(colorize(dist / camera.viewdist, obj))
	if hitindex == 0 and type(obj) == "table" then
		love.graphics.push()
			love.graphics.translate(scanx, screen.height / 2)
			love.graphics.scale(1, screen.height / dist)
			love.graphics.rectangle("fill", 0, camera.pos.z - 1, 1, 1)
		love.graphics.pop()
	end
end

local dir = {}
function camera:draw()
	local inc = 2 / screen.width
	local i = -1
	local scanx = 0
	while i < 1 do
		vec.copy(dir, vec.norm(vec.add(self.dir, vec.scale(self.plane, i))))
		local distfactor = vec.projectscalar(dir, self.dir)
		physics.raycast(self.pos, dir, self.viewdist, level.current, drawraycasthit, self.visiblepredicate, scanx, distfactor)
		i = i + inc
		scanx = scanx + 1
	end
end
