
color = {}

color.black = {0, 0, 0}
color.white = {255, 255, 255}

color.red = {255, 0, 0}
color.green = {0, 255, 0}
color.blue = {0, 0, 255}

function color.random(min, max)
	min = min or 0
	max = max or 255
	return math.random(min, max), math.random(min, max), math.random(min, max)
end

local function args(r, g, b, a)
	if type(r) == "table" then
		return unpack(r)
	else
		return r, g, b, a
	end
end

function color.equals(a, b, ignorealpha)
	local max = ignorealpha and 3 or 4
	for i = 1, max do
		if a[i] ~= b[i] then
			return false
		end
	end
	return true
end
