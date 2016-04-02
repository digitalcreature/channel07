
--simple vector lib
vector = {}

function vector.add(v1, v2)
	return v1.x + v2.x, v1.y + v2.y, (v1.z and v2.z) and v1.z + v2.z
end

function vector.scale(v, s)
	return v.x * s, v.y * s, v.z and v.z * s
end

function vector.dot(v1, v2)
	return (v1.x * v2.x) + (v1.y * v2.y) + ((v1.z or 0) * (v2.z or 0))
end

function vector.cross(v1, v2)
	local x = v1.y * (v2.z or 0) - (v1.z or 0) * v2.y
	local y = (v1.z or 0) * v2.x - v1.x * (v2.z or 0)
	local z = v1.x * v2.y - v1.y * v2.x
	return x, y, z
end

function vector.len2(v)
	return vector.dot(v, v)
end

function vector.len(v)
	math.sqrt(vector.len2(v))
end

function vector.tostring(v)
	return "<"..v.x..", "..v.y..">"
end

function vector.equals(v1, v2)
	return v1.x == v2.x and v1.y == v2.y and (v1.z or 0) == (v2.z or 0)
end

local sin, cos = math.sin, math.cos

function vector.rotate(v, r)
	return
		v.x * cos(- r) - v.y * sin(- r),
		v.x * sin(- r) + v.y * cos(- r)
end

function vector.angle(v)
	return - math.atan2(v.y, v.x)
end

vector.zero = {x = 0, y = 0, z = 0}
vector.one = {x = 1, y = 1, y = 1}
vector.north = {x = 0, y = -1, z = 0}
vector.south = {x = 0, y = 1, z = 0}
vector.east = {x = 1, y = 0, z = 0}
vector.west = {x = -1, y = 0, z = 0}
