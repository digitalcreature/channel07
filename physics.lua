require "oop"
require "Vector"
require "math2"
require "data"

physics = {}

physics.Domain = class() do

	local base = physics.Domain;

	function base:init(width, height)
		self.width = width or 0
		self.height = height or 0
		for i = 0, width - 1 do
			self[i] = {}
		end
		self.entities = data:List()
		self.inactive = data:List()
	end

	function physics.Domain.setcurrent(domain)
		physics.Domain.current = domain
	end

	function base:inbounds(i, j)
		return
			i >= 0 and j >= 0 and
			i < self.width and
			j < self.height
	end

	function base:addentity(entity)
		self.entities:add(entity)
	end

	function base:removeentity(entity)
		self.inactive:add(entity)
	end

	function base:update(dt)
		for i = 1, #self.entities do
			local entity = self.entities[i]
			if not entity:isinactive() and entity.update then entity:update(dt) end
		end
		for i = 1, #self.inactive do
			local entity = self.inactive[i]
			self.entities:remove(entity)
			self.inactive[i] = nil
		end
	end

	function base:get(i, j, tile)
		if self:inbounds(i, j) then
			return self[i][j]
		end
	end

	function base:set(i, j, tile)
		if self:inbounds(i, j) then
			self[i][j] = tile
		end
	end

	--callback for processing raycast hits. use ... for userdata
	local function raycasthitprocessor(startpos, dir, pos, dist, obj, hitindex, axis, sign, i, j, ...) end

	local hitpos = Vector()
	local dir = Vector()
	function base:raycast(pos, startdir, maxdist, hitprocessor, solidpredicate, passablepredicate, ...)
		solidpredicate = solidpredicate or physics.solidpredicate
		if physics.Domain.current and hitprocessor then
			local hitindex = 0
			dir:set(startdir)
			local dist = 0
			local hitindex = 0
			local i, j = math.floor(pos.x), math.floor(pos.y)
			local di, dj
			local dxdist = math.sqrt(1 + (dir.y * dir.y) / (dir.x * dir.x))
			local dydist = math.sqrt(1 + (dir.x * dir.x) / (dir.y * dir.y))
			local sidex
			local sidey
			local axis
			if (dir.x < 0) then
				di = -1
				sidex = (pos.x - i) * dxdist
			else
				di = 1
				sidex = (i + 1 - pos.x) * dxdist
			end
			if (dir.y < 0) then
				dj = -1
				sidey = (pos.y - j) * dydist
			else
				dj = 1
				sidey = (j + 1 - pos.y) * dydist
			end
			while (not maxdist or dist < maxdist) do--dist < maxdist) do
				if (sidex < sidey) then
					sidex = sidex + dxdist
					i = i + di
					axis = "x"
				else
					sidey = sidey + dydist
					j = j + dj
					axis = "y"
				end
				if (axis == "x") then
					dist = (i - pos.x + (1 - di) / 2) / dir.x
				else
					dist = (j - pos.y + (1 - dj) / 2) / dir.y
				end
				local obj = physics.Domain.current:get(i, j)
				if not self:inbounds(i, j) then break end
				if solidpredicate(obj) then
					hitpos:set(dir):scale(dist):add(pos)
					local sign
					if axis == "x" then
						sign = di
					else
						sign = dj
					end
					hitprocessor(pos, dir, hitpos, dist, obj, hitindex, axis, sign, i, j, ...)
					hitindex = hitindex + 1
					if passablepredicate and not passablepredicate(obj) then break end
				end
			end
		end
	end

end

physics.Entity = class() do

	local base = physics.Entity

	function base:init(w, h)
		self.x = 0
		self.y = 0
		self.w = w or 0
		self.h = h or 0
	end

	function base:isinactive(domain)
		domain = domain or physics.Domain.current
		return domain and domain.inactive:contains(self)
	end

	function base:addtodomain(domain)
		domain = domain or physics.Domain.current
		if domain then
			domain:addentity(self)
		end
		return self
	end

	function base:removefromdomain(domain)
		domain = domain or physics.Domain.current
		if domain then
			domain:removeentity(self)
		end
		return self
	end

	function base:move(dx, dy, solidpredicate)
		solidpredicate = solidpredicate or physics.solidpredicate
		local inc
		while dx ~= 0 or dy ~= 0 do
			if dx ~= 0 then
				inc = math.abs(dx) < 1 and dx or math.sign(dx)
				self.x = self.x + inc
				if (self:checkrect(solidpredicate)) then
					local x
					if dx > 0 then
						x = math.ceil(self.x + self.w) - 1 - self.w
					else
						x = math.floor(self.x) + 1
					end
					dx = dx - (self.x - x)
					self.x = x
				else
					dx = dx - inc
				end
			end
			if dy ~= 0 then
				inc = math.abs(dy) < 1 and dy or math.sign(dy)
				self.y = self.y + inc
				if (self:checkrect(solidpredicate)) then
					local y
					if dy > 0 then
						y = math.ceil(self.y + self.h) - 1 - self.h
					else
						y = math.floor(self.y) + 1
					end
					dy = dy - (self.y - y)
					self.y = y
				else
					dy = dy - inc
				end
			end
		end
	end

	function base:checkrect(predicate)
		if physics.Domain.current and predicate then
			local x, y, w, h = self:rect()
			local collision = false
			for i = math.floor(x), math.ceil(x + w) - 1 do
				for j = math.floor(y), math.ceil(y + h) - 1 do
					if predicate(physics.Domain.current:get(i, j), i, j) then
						return true
					end
				end
			end
		end
	end

	function base:rect()
		return
			self.x or 0,
			self.y or 0,
			self.w or 0,
			self.h or 0
	end

	function base:center(x, y)
		if x and y then
			self.x = x - (self.w / 2)
			self.y = y - (self.h / 2)
			return self
		else
			return self.x + self.w / 2, self.y + self.h / 2, self.z or 0
		end
	end

	function physics.Entity:getkey()
		return function (i, j)
			return self():center(i + .5, j + .5)
		end
	end

end

function physics.solidpredicate(obj, x, y)
	if obj == nil then return false end
	if type(obj) == "table" then
		return not obj.nonsolid
	else
		return true
	end
end
