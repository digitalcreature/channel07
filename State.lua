require "oop"

State = class() do

	local base = State

	function base:onenter() end
	function base:onexit() end

	function base:update(dt) end
	function base:draw() end

	function base:keypressed(key) end
	function base:keyreleased(key) end

	function base:mousepressed(x, y, button) end
	function base:mousereleased(x, y, button) end

	function State.setcurrent(state)
		if State.current then
			State.current:onexit()
		end
		State.current = state
		state:onenter()
	end

end
