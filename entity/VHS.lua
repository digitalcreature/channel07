require "oop"

require "Billboard"
require "entity.Item"

VHS = subclass(Item) do

	local base = VHS

	base.billboard = Billboard("sprite/vhs.png", 1, 2/3, 2/3, 1/3, 1/3)

	function base:ontaken()
		player.won = true
	end

end
