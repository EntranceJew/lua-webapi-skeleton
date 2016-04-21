local math_random = math.random
if love and love.math and love.math.random then
	math_random = love.math.random
end

local SimpleClass = {
	default = 'property'
}
SimpleClass.__index = SimpleClass
setmetatable(SimpleClass, {
	__call = function (class, ...)
		return class.new(...)
	end,
})

---
-- Create a new SimpleClass.
-- @name SimpleClass.new
-- @param ... Whatever
-- @return A new instance of SimpleClass
function SimpleClass.new(...)
	local self = setmetatable({}, SimpleClass)
	
	-- set properties on self here
	
	return self
end

---
-- Do an instance method.
-- @name SimpleClass.instanceMethod
-- @param arg Do a thing.
-- @return Whatever I want.
function SimpleClass:instanceMethod(arg)
	-- do a thing
	return true
end

return SimpleClass