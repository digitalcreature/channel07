require "oop"
require "color"
require "screen"

require "Pool"

render = {}

render.fogcolor = color.black
render.fogstart = 0
render.fogend = 8

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
	for i = 0, screen.height -1 do
		if i < screen.height / 2 then
			love.graphics.setColor(color.lerp(Level.current.ceilingcolor, render.fogcolor, i / (screen.height / 2)))
		else
			love.graphics.setColor(color.lerp(render.fogcolor, Level.current.floorcolor, (i - screen.height / 2) / (screen.height / 2)))
		end
		love.graphics.rectangle("fill", 0, i, screen.width, 1)
	end
	table.sort(render.calls, render.DrawCall.bydist)	--depth sort; further away objects are rendered first
	for i = 1, #render.calls do
		local call = render.calls[i]
		if call.info.dist > 0 then
			if not call.info.nofog then
				love.graphics.setColor(color.lerp(color.white, color.black, (call.info.dist - render.fogstart) / (render.fogend - render.fogstart)))
			else
				love.graphics.setColor(color.white)
			end
			love.graphics.push()
				love.graphics.translate(call.info.scanx, screen.height / 2)
				love.graphics.scale((screen.height / call.info.dist), (screen.height / call.info.dist))
				call()
			love.graphics.pop()
		end
		render.callpool:checkin(call)
		render.calls[i] = nil
	end
end
