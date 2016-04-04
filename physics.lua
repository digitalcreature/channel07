require "level"
require "vector"
require "math2"

local vec = vector

physics = {}

local abs = math.abs
local floor = math.floor
local ceil = math.ceil
local sqrt = math.sqrt

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

local function inbounds(grid, x, y)
	return
		x >= 0 and y >= 0 and
		x < grid.width and y < grid.height
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
				if inbounds(grid, i, j) and predicate(grid[i][j], i, j) then
					return true
				end
			end
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

--callback for processing raycast hits. use ... for userdata
local function raycasthitprocessor(startpos, dir, pos, dist, obj, hitindex, axis, ...) end

local hitpos = {}
local dir = {}
function physics.raycast(pos, startdir, maxdist, grid, hitprocessor, solidpredicate, ...)
	solidpredicate = solidpredicate or physics.solidpredicate
	if grid and hitprocessor then
		--TODO: finish raycast overhaul
		local hitindex = 0
		vec.copy(dir, startdir)
		local dist = 0
		local hitindex = 0
		local i, j = floor(pos.x), floor(pos.y)
		local di, dj
      local dxdist = sqrt(1 + (dir.y * dir.y) / (dir.x * dir.x))
      local dydist = sqrt(1 + (dir.x * dir.x) / (dir.y * dir.y))
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
      while (dist < maxdist) do
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
			if inbounds(grid, i, j) then
				local obj = grid[i][j]
				if solidpredicate(obj) then
					vec.copy(hitpos, vec.add(pos, vec.scale(dir, dist)))
					hitprocessor(pos, dir, hitpos, dist, obj, hitindex, axis, ...)
					hitindex = hitindex + 1
				end
			else
				break
			end
		end


		-- local inc = .1
		-- local dist = 0
		-- local hits = 0
		-- while dist < maxdist do
		-- 	local i = floor(hit.x)
		-- 	local j = floor(hit.y)
		-- 	if inbounds(grid, i, j) and solidpredicate(grid[i][j], i, j) then
		-- 		hitprocesser(start, dir, hit, dist, grid[i][j], hits, ...)
		-- 		hits = hits + 1
		-- 	end
		-- 	vec.copy(hit, vec.add(hit, vec.scale(dir, inc)))
		-- 	dist = dist + inc
		-- end
	end
end
