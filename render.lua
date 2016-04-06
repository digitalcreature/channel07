require "oop"
require "color"
require "screen"

require "Pool"

render = {}

render.mindist = 0
render.maxdist = 8

render.RenderCall = class() do

	local base = render.RenderCall

	function base:init(obj, pos, dist, scanx, i, j, axis)
		self.obj = obj
		if not self.pos then self.pos = Vector() end
		self.pos:set(pos)
		self.i = i
		self.j = j
		self.dist = dist		--distance of object from camera
		self.scanx = scanx	--horizontal scanline index, 0 <= scanx < screen.width
		self.axis = axis		--x or y axis of hit
	end

	function base:__call()
		self.obj:draw(self.pos, self.dist, self.scanx, self.i, self.j, self.axis)
	end

	function render.RenderCall.bydist(a, b)
		return a.dist > b.dist
	end

end

render.callpool = Pool(render.RenderCall, screen.width * 10)
render.calls = {}

--log a render call
function render.render(obj, pos, dist, scanx, i, j, axis)
	local call = render.callpool:checkout(obj, pos, dist, scanx, i, j, axis)
	table.insert(render.calls, call)
end

--execute render calls
function render.draw()
	table.sort(render.calls, render.RenderCall.bydist)	--depth sort; further away objects are rendered first
	for i = 1, #render.calls do
		local call = render.calls[i]
		if call.dist > render.mindist and call.dist < render.maxdist then
			love.graphics.setColor(color.lerp(color.white, color.black, (call.dist - render.mindist) / (render.maxdist - render.mindist)))
			call()
		end
		render.callpool:checkin(call)
		render.calls[i] = nil
	end
end
