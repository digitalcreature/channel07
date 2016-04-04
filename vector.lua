
--simple vector lib
vector = {}

local function args(x, y, z)
	if type(x) == "table" then
		return x.x, x.y, x.z
	else
		return x, y, z
	end
end

function vector.add(v, x, y, z)
	x, y, z = args(x, y, z)
	return v.x + x, v.y + y, (v.z and z) and v.z + z
end

function vector.scale(v, s)
	return v.x * s, v.y * s, v.z and v.z * s
end

function vector.dot(v, x, y, z)
	x, y, z = args(x, y, z)
	return (v.x * x) + (v.y * y) + ((v.z or 0) * (z or 0))
end

function vector.cross(v, x, y, z)
	x, y, z = args(x, y, z)
	local x = v.y * (z or 0) - (v.z or 0) * y
	local y = (v.z or 0) * x - v.x * (z or 0)
	local z = v.x * y - v.y * x
	return x, y, z
end

function vector.len2(x, y, z)
	x, y, z = args(x, y, z)
	return x * x + y * y + (z and z * z or 0)
end

function vector.len(x, y, z)
	x, y, z = args(x, y, z)
	return math.sqrt(vector.len2(x, y, z))
end

function vector.tostring(x, y, z)
	x, y, z = args(x, y, z)
	return z and "<"..x..", "..y..", "..z..">" or "<"..x..", "..y..">"
end

function vector.equals(v, x, y, z)
	x, y, z = args(x, y, z)
	return v.x == x and v.y == y and (v.z or 0) == (z or 0)
end

local sin, cos = math.sin, math.cos

function vector.rotate(v, r)
	return
		v.x * cos(- r) - v.y * sin(- r),
		v.x * sin(- r) + v.y * cos(- r)
end

function vector.angle(x, y)
	x, y = args(x, y)
	return - math.atan2(y, x)
end

function vector.copy(v, x, y, z)
	x, y, z = args(x, y, z)
	v.x, v.y, v.z = x or v.x, y or v.y, z or v.z
end

function vector.norm(x, y, z)
	x, y, z = args(x, y, z)
	local len = vector.len(x, y, z)
	return x / len, y / len, z and z / len
end

function vector.projectscalar(a, x, y, z)
	x, y, z = args(x, y, z)
	return vector.dot(a, x, y, z) / vector.len(x, y, z)
end

vector.zero = {x = 0, y = 0, z = 0}
vector.one = {x = 1, y = 1, y = 1}
vector.north = {x = 0, y = -1, z = 0}
vector.south = {x = 0, y = 1, z = 0}
vector.east = {x = 1, y = 0, z = 0}
vector.west = {x = -1, y = 0, z = 0}
