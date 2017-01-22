-- Meta class
-- Meta class
Addon = {}
Addon.__index = Addon

-- Base class method new
function Addon:new (position)
	local a = {}             -- our new object
    setmetatable(a, Addon)  
    a.idx = 1  -- random choose from the library
    a.posx = position[1]      
    a.posy = position[2] 
    --a.img = love.graphics.newImage("/Assets/Island_Small.png")
    return a
end