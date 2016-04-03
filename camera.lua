require "physics"
require "vector"

local vec = vector

local temp = {}
camera = {}
camera.pos = {x = 0, y = 0}
camera.dir = {x = 1, y = 0}
camera.plane = {x = 0, y = 1}

function camera:setangle(r)
	vec.copy(temp, 1, 0)
	vec.copy(self.dir, vec.rotate(temp, r))
	vec.copy(temp, 0, .5)
	vec.copy(self.plane, vec.rotate(temp, r))
end

function camera:getangle()
	return vec.angle(self.dir)
end

function camera.visiblepredicate(obj, x, y)
	return type(obj) == "table" and not obj.invisible
end

local maxdist = 8

local wallcolor = {128, 64, 255}
local function drawraycasthit(start, dir, hit, dist, obj, hitindex, scanx, distfactor)
	love.graphics.setColor(color.lerp(wallcolor, color.black, dist / maxdist))
	dist = dist * distfactor
	local maxdist = maxdist * distfactor
	if hitindex == 0 then
		love.graphics.push()
			love.graphics.translate(scanx, screen.height / 2)
			love.graphics.scale(1, screen.height * (1 - (dist / maxdist)))
			-- love.graphics.rectangle("fill", 0, -.5, 1, 1)
		love.graphics.pop()
	end
	if (dist > 3 and dist < 3.5) then
		love.graphics.setColor(color.white)
	end
	love.graphics.circle("fill", hit.x, hit.y, .15)
end

local dir = {}
function camera:draw()
	local inc = 2 / screen.width
	local i = -1
	local scanx = 0
	while i < 1 do
		vec.copy(dir, vec.norm(vec.add(self.dir, vec.scale(self.plane, i))))
		local distfactor = vec.projectscalar(dir, self.dir)
		physics.raycast(self.pos, dir, maxdist, level.current, drawraycasthit, self.visiblepredicate, scanx, distfactor)
		i = i + inc
		scanx = scanx + 1
	end
end
