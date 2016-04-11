require "oop"
require "physics"
require "math2"

require "Billboard"

ParticleExplosion = class(physics.Entity) do

	local base = ParticleExplosion

	function base:init(billboard, count, velmin, velmax, lifetimemin, lifetimemax, gravity)
		base.super.init(self, 0, 0, 1, 1)
		self.billboard = billboard
		self.particles = {}
		for i = 1, count do
			particle = Vector()
			particle.lifetime = math.random(lifetimemin, lifetimemax)
			particle.vel = Vector(Vector.random()):norm():scale(math.random(velmin, velmax))
			self.particles[i] = particle
		end
		self.lifetime = lifetimemax
		self.gravity = gravity or -10
	end

	local dvel, dpos = Vector(), Vector()
	function base:update(dt)
		self.lifetime = self.lifetime - dt
		if self.lifetime <= 0 then
			self:removefromdomain()
		else
			for i = 1, #self.particles do
				local particle = self.particles[i]
				particle.lifetime = particle.lifetime - dt
				if particle.lifetime <= 0 then
					particle.dead = true
				end
				if not particle.dead then
					particle.vel:add(0, 0, self.gravity * dt)
					dpos:set(particle.vel):scale(dt)
					particle:add(dpos)
				end
			end
		end
	end

	local pos = Vector()
	function base:render()
		for i = 1, #self.particles do
			local particle = self.particles[i]
			if not particle.dead then
				pos:set(self:center()):add(particle)
				self.billboard:render(pos:xyz())
			end
		end
	end

end
