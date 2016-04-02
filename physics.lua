require "level"

physics = {}

local abs = math.abs
local floor = math.floor
local ceil = math.ceil

function physics.moveentity(entity, dx, dy, grid, solidpredicate)
	solidpredicate = solidpredicate or physics.solidpredicate
	local inc
	while dx ~= 0 or dy ~= 0 do
		if dx ~= 0 then
			inc = abs(dx) < 1 and dx or sign(dx)
			entity.x = entity.x + inc
			if (physics.checkrect(entity, grid, solidpredicate)) then
				local x
				if dx > 0 then
					x = ceil(entity.x + entity.w) - 1 - entity.w
				else
					x = floor(entity.x) + 1
				end
				dx = dx - (entity.x - x)
				entity.x = x
			else
				dx = dx - inc
			end
		end
		if dy ~= 0 then
			inc = abs(dy) < 1 and dy or sign(dy)
			entity.y = entity.y + inc
			if (physics.checkrect(entity, grid, solidpredicate)) then
				local y
				if dy > 0 then
					y = ceil(entity.y + entity.h) - 1 - entity.h
				else
					y = floor(entity.y) + 1
				end
				dy = dy - (entity.y - y)
				entity.y = y
			else
				dy = dy - inc
			end
		end
	end
end

function physics.checkrect(rect, grid, predicate)
	if grid and predicate then
		x = rect.x or 0
		y = rect.y or 0
		w = rect.w or 0
		h = rect.h or 0
		local collision = false
		for i = floor(x), ceil(x + w) - 1 do
			for j = floor(y), ceil(y + h) - 1 do
				if i >= 0 and j >= 0 and
						i < grid.width and j < grid.height and
						predicate(grid[i][j]) then
					return true
				end
			end
		end
	end
end

function physics.solidpredicate(obj)
	if obj == nil then return false end
	if type(obj) == "table" then
		return not obj.nonsolid
	else
		return true
	end
end
