require "math2"

color = {}

color.clear = {0, 0, 0, 0,}

color.black = {0, 0, 0}
color.white = {255, 255, 255}

color.red = {255, 0, 0}
color.green = {0, 255, 0}
color.blue = {0, 0, 255}

color.yellow = {255, 255, 0}

function color.random(min, max)
	min = min or 0
	max = max or 255
	return math.random(min, max), math.random(min, max), math.random(min, max)
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

function color.lerp(a, b, t)
	return
		math.lerp(a[1], b[1], t),
		math.lerp(a[2], b[2], t),
		math.lerp(a[3], b[3], t),
		math.lerp(a[4] or 255, b[4] or 255, t)
end
