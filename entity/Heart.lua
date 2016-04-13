require "oop"
require "player"

require "Billboard"
require "entity.Item"

Heart = subclass(Item) do

	local base = Heart

	base.sound = love.audio.newSource("sound/heart-pickup.wav", "static")

	base.billboard = Billboard("sprite/heart.png", 1, 1/2, 1/2, 1/4, 1/4)

	function base:canbetaken()
		return player.health < player.maxhealth
	end

	function base:ontaken()
		player.health = player.health + 1
	end

end
