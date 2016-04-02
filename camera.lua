require "physics"
require "vector"

local vec = vector

camera = {}
camera.pos = {x = 0, y = 0}
camera.dir = {x = 1, y = 0}
camera.plane = {x = 0, y = 1}

function camera:setangle(r)
	self.dir.x, self.dir.y = vec.rotate(vec.east, r)
	self.plane.x, self.plane.y = vec.rotate(vec.south, r)
end

function camera:getangle()
	return vec.angle(self.dir)
end

function camera.visiblepredicate(obj, x, y)
	if obj == nil then return false end
	if type(obj) == "table" then
		return not obj.invisible
	else
		return true
	end
end

local maxdist = 10

local function drawraycasthit(pos, obj, dist, hitindex)
	if hitindex then-- == 0 then
		local r = .15
		love.graphics.setColor(color.lerp(color.red, color.blue, dist / maxdist))
		love.graphics.circle("line", pos.x, pos.y, r, 24)
	end
end

function camera:draw()
	physics.raycast(self.pos, self.dir, maxdist, level.current, drawraycasthit, self.visiblepredicate)
end
