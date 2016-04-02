level = {}

function level.loadLevel(map, key)
	if type(map) == "string" then
		map = love.image.newImageData(map)
	end
	local w, h = map:getDimensions()
	local new = {}
	for x = 0, w - 1 do
		new[x] = {}
	end
	local pallete = {}
	for i, obj in ipairs(key) do
		local pixel = {map:getPixel(i - 1, 0)}
		pallete[pixel] = obj
	end
	local yoffset = math.floor(#key / w) + 1
	h = h - yoffset
	for x = 0, w - 1 do
		for y = 0, h - 1 do
			local pixel = {map:getPixel(x, y + yoffset)}
			local obj = nil
			for c, o in pairs(pallete) do
				if color.equals(pixel, c, true) then
					obj = o
					break
				end
			end
			if type(obj) == "function" then
				obj = obj(x, y)
			end
			if type(obj) == "table" then
				if not obj.nontile then
					new[x][y] = obj
				end
			else
				new[x][y] = obj
			end
			print(obj)
		end
	end
	new.width = w
	new.height = h
	return new
end
