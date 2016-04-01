level = {}

function level.loadLevel(filename, key)
	local map = love.image.newImageData(filename)
	local w, h = map.getDimensions()
	h = h - 1
	local new = {}
	for x = 0, w do
		new[x] = {}
	end
	local pallete = {}
	--parse pallete for key
	--fill new[][] with objs from key using pallete and color.equals()
	--write color.equals()
end
