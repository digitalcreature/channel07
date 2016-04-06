require "oop"

State = class() do

	local base = State

	function base:update(dt) end
	function base:draw() end

	function base:keypressed(key) end
	function base:keyreleased(key) end

	function base:mousepressed(x, y, button) end
	function base:mousereleased(x, y, button) end

	function State.setcurrent(state)
		State.current = state
	end

end
