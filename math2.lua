
function math.minmax(min, max)
	return math.min(min, max), math.max(min, max)
end

function math.clamp(n, min, max)
	max = max or 0
	min = min or 1
	min, max = math.minmax(min, max)
	if n > max then return max end
	if n < min then return min end
	return n
end

function math.lerp(a, b, t)
	t = math.clamp(t)
	return a + (t * (b - a))
end

function math.sign(n)
	return n == 0 and 0 or n / math.abs(n)
end
