require "oop"
require "physics"

LivingEntity = subclass(physics.Entity) do

	local base = LivingEntity

	base.lastdamagetime = 0

	base.health = 1
	base.damageradius = 1/2 --hitbox radius

	function base:init(w, h)
		base.super.init(self, w, h)
	end

	function base:takedamage(damage)
		damage = damage or 1
		if not self.dead then
			local time = love.timer.getTime()
			if not self.damagecooldown or time - self.lastdamagetime >= self.damagecooldown then
				self.lastdamagetime = time;
				self.health = self.health - damage
				if self.health <= 0 then
					self:die()
				end
				return true
			end
		end
	end

	function base:die()
		self:removefromdomain()
		self.dead = true
	end


end
