require "oop"

Pool = class() do

	local base = Pool

	function base:init(objclass, count)
		self.objclass = objclass
		for i = 1, count do
			self[i] = self.objclass()
		end
	end

	function base:checkout(...)
		if #self > 0 then
			local obj = self[#self]
			self[#self] = nil
			if obj.init then obj:init(...) end
			return obj
		else
			print("new")
			return self.objclass(...)
		end
	end

	function base:checkin(obj)
		if obj.class == self.objclass then
			self[#self + 1] = obj
		end
	end

end
