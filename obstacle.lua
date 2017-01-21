-- Meta class
-- can have add-on
-- can be step on by character
-- fixed location, cannot move

local obstacle = {}
setmetatable(obstacle, {__mode = "k"})

-- Base class method new
function Obstacle:new (o, position)
	-- body
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   self.pos = postion
   return o
end

