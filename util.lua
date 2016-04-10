util = {}

--call a function n times with ... args
function util.calln(n, f, ...)
	if n == 1 then
		return f(...)
	else
		return f(...), util.calln(n - 1, f, ...)
	end
end
