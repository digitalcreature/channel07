require "oop"

Pool = class() do

	local base = Pool

	function base:init(objclass, count)
		self.objclass = objclass
		for i = 1, count or 0 do
			self[i] = self.objclass and self.objclass() or {}
		end
	end

	function base:checkout(...)
		if #self > 0 then
			local obj = self[#self]
			self[#self] = nil
			if obj.init then obj:init(...) end
			return obj
		else
			return self.objclass and self.objclass(...) or {}
		end
	end

	function base:checkin(obj)
		if not self.objclass or instanceof(obj, objclass) then
			self[#self + 1] = obj
		end
	end

end

tablepool = Pool()
