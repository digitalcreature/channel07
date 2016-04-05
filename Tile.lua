require "oop"
require "color"

Tile = class() do

	local base = Tile

	function base:init(material)
		self.material = material or Tile.Material()
	end

	function base:render(i, j, pos, dist, axis)
		self.material:shader(self, i, j, pos, dist, axis)
	end

	Tile.Material = class() do

		local base = Tile.Material

		function base:init()
		end

		function base:shader(tile, i, j, pos, dist, axis)
			love.graphics.rectangle("fill", 0, 0, 1, 1)
		end

		Tile.Material.Color = subclass(Tile.Material) do

			local base = Tile.Material.Color

			function base:init(color)
				base.super.init(self)
				self.color = color or color.white
			end

			function base:shader(tile, i, j, pos, dist, axis)
				love.graphics.setColor(self.color)
				love.graphics.rectangle("fill", 0, 0, 1, 1)
			end

		end

		Tile.Material.Texture = subclass(Tile.Material) do

			local base = Tile.Material.Texture

			function base:init(texture)
				if type(texture) == "string" then
					texture = love.graphics.newImage(texture)
				end
				local w = texture:getWidth()
				self.quadcount = w
				self.quads = {}
				self.texture = texture
				for i = 0, w - 1 do
					self.quads[i] = love.graphics.newQuad(i, 0, 1, 1, w, 1)
				end
			end

			function base:shader(tile, i, j, pos, dist, axis)
				local u
				if axis == "x" then
					u = pos.y - j
				else
					u = pos.x - i
				end
				local quad = self.quads[math.floor(u * self.quadcount)]
				love.graphics.draw(self.texture, quad)
			end

		end

	end

end
