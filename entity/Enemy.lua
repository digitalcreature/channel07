require "physics"
require "data"

require "LivingEntity"

Enemy = subclass(LivingEntity) do

	local base = Enemy

	Enemy.all = data.List()

	function base:init(w, h)
		base.super.init(self, w, h)
		Enemy.all:add(self)
	end

	function base:die()
		base.super.die(self)
		self:removefromdomain()
		Enemy.all:remove(self)
	end

end
