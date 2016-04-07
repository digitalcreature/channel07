require "oop"
require "color"
require "screen"

require "Pool"

render = {}

render.mindist = 0
render.maxdist = 8

render.DrawCall = class() do

	local base = render.DrawCall

	function base:init(obj, info)
		self.obj = obj
		self.info = info
	end

	function base:__call()
		self.obj:draw(self.info)
	end

	function render.DrawCall.bydist(a, b)
		return a.info.dist > b.info.dist
	end

end

render.callpool = Pool(render.DrawCall, screen.width * 10)
render.calls = {}

--log a render call
function render.render(obj, info)
	local call = render.callpool:checkout(obj, info)
	table.insert(render.calls, call)
end

--execute render calls
function render.draw()
	love.graphics.clear(color.black)
	table.sort(render.calls, render.DrawCall.bydist)	--depth sort; further away objects are rendered first
	for i = 1, #render.calls do
		local call = render.calls[i]
		if call.info.dist > render.mindist and call.info.dist < render.maxdist then
			love.graphics.setColor(color.lerp(color.white, color.black, (call.info.dist - render.mindist) / (render.maxdist - render.mindist)))
			call()
		end
		tablepool:checkin(call.info)
		render.callpool:checkin(call)
		render.calls[i] = nil
	end
end
