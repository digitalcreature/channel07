
color = {}

color.black = {0, 0, 0}
color.white = {255, 255, 255}

function color.random(min, max)
	min = min or 0
	max = max or 255
	return math.random(min, max), math.random(min, max), math.random(min, max)
end
