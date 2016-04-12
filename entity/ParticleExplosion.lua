require "oop"
require "physics"
require "math2"

require "Billboard"

ParticleExplosion = class(physics.Entity) do

	local base = ParticleExplosion
	base.speed = 1

	function base:init(billboard, count, velmin, velmax, lifetimemin, lifetimemax, zvelmin, zvelmax, gravity)
		base.super.init(self, 0, 0, 1, 1)
		self.billboard = billboard
		self.particles = {}
		self.gravity = gravity or -20
		for i = 1, count do
			particle = Vector()
			particle.lifetime = lifetimemin + (math.random() * (lifetimemax - lifetimemin))
			local spd = velmin + (math.random() * (velmax - velmin))
			particle.vel = Vector(Vector.random()):norm():scale(spd)
			particle.vel.z = zvelmin + (math.random() * (zvelmax - zvelmin))
			self.particles[i] = particle
		end
		self.lifetime = lifetimemax
	end

	local dvel, dpos = Vector(), Vector()
	function base:update(dt)
		dt = dt * self.speed
		self.lifetime = self.lifetime - dt
		if self.lifetime <= 0 then
			self:removefromdomain()
		else
			for i = 1, #self.particles do
				local particle = self.particles[i]
				if not particle.dead then
					particle.lifetime = particle.lifetime - dt
					if particle.lifetime <= 0 then
						particle.dead = true
					else
						particle.vel:add(0, 0, self.gravity * dt)
						dpos:set(particle.vel):scale(dt)
						particle:add(dpos)
					end
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
				pos.z = math.clamp(pos.z, -1, 3)
				self.billboard:render(pos:xyz())
			end
		end
	end

end
