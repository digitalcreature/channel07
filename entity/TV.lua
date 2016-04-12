require "physics"
require "camera"
require "player"
require "data"
require "util"

require "entity.Enemy"
require "Vector"
require "ParticleExplosion"

TV = subclass(Enemy) do

	local base = TV

	base.neighborradius = 3
	base.avoidfactor = 5
	base.damageradius = 1/4

	base.smileradius = 2
	base.attackradius = 1

	TV.all = data.List()

	local h = 1
	base.framesprite = Billboard("sprite/tv-frame.png", 1, 2/3, 2/3, 1/3, 1/3)
	base.staticsprite = Billboard("sprite/tv-static.png", 8, 2/3, 2/3, 1/3, 1/3, {nofog = true})
	base.smilesprite = Billboard("sprite/tv-smile.png", 8, 2/3, 2/3, 1/3, 1/3, {nofog = true})
	base.screensprite = base.staticsprite

	base.speed = 1
	base.health = 1

	function base:init()
		base.super.init(self, 1/4, 1/4)
		TV.all:add(self)
		self.z = 0.6
	end

	local avoid, dpos, temp = util.calln(3, Vector)
	function base:update(dt)
		local neighborcount = 0
		avoid:set(Vector:zero())
		for i = 1, #TV.all do
			local tv = TV.all[i]
			if not tv.dead then
				local dist = temp:set(self:center()):sub(tv:center()):len()
				if dist < self.neighborradius then
					neighborcount = neighborcount + 1
					temp:scale(self.avoidfactor * (1 - (dist / self.neighborradius)))
					avoid:add(temp)
				end
			end
		end
		avoid:scale(1 / neighborcount)
		dpos:set(player:center()):sub(self:center()):norm():add(avoid):scale(self.speed * dt)
		self:move(dpos:xy())
		local dist2 = temp:set(self:center()):dist2(player:center())
		if dist2 <= (self.smileradius * self.smileradius) then
			self.screensprite = self.smilesprite
			if dist2 <= (self.attackradius * self.attackradius) then
				player:takedamage()
			end
		else
			self.screensprite = self.staticsprite
		end
	end

	function base:render()
		self.framesprite:render(self:center())
		self.screensprite:render(self:center())
	end

	local deathparticle = Billboard("sprite/statichit.png", 16, 1/3, 1/3, nil, nil, {nofog = true})

	function base:die()
		base.super.die(self)
		TV.all:remove(self)
		local effect = ParticleExplosion(deathparticle, 25, 1/2, 1, 1, 3, 1, 3, -5):center(self:center()):addtodomain()
		effect.speed = 2
	end

end
