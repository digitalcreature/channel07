require "physics"

require "LivingEntity"

Enemy = subclass(LivingEntity) do

	local base = Enemy

	function base:init(w, h)
		base.super.init(self, w, h)
	end

	function base:die()
		base.super.die(self)
	end

end
