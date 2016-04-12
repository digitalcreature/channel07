require "oop"
require "Billboard"

require "entity.Item"

Key = subclass(Item) do

	local base = Key

	function base:ontaken()
		player[self.name] = true
	end

end

Key.Red = subclass(Key) do

	local base = Key.Red

	base.name = "red key"
	base.billboard = Billboard("sprite/key-red.png", 1, 1/2, 2/3, 1/3, 1/3)

end

Key.Green = subclass(Key) do

	local base = Key.Green

	base.name = "green key"
	base.billboard = Billboard("sprite/key-green.png", 1, 1/2, 2/3, 1/3, 1/3)

end

Key.Blue = subclass(Key) do

	local base = Key.Blue

	base.name = "blue key"
	base.billboard = Billboard("sprite/key-blue.png", 1, 1/2, 2/3, 1/3, 1/3)

end
