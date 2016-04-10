require "oop"

data = {}

data.List = class() do

	local base = data.List

	function base:init()
	end

	base.add = table.insert
	base.removeat = table.remove

	function base:remove(a)
		local index = self:indexof(a)
		if index then
			self:removeat(index)
			return true
		end
	end

	function base:indexof(a)
		for i = 1, #self do
			if self[i] == a then
				return i
			end
		end
	end

	base.contains = base.indexof

end
