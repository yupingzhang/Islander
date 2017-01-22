-- Meta class
-- can have add-on
-- can be step on by character
-- fixed location, cannot move
require 'math'
require 'Utility'

-- Meta class
Island = {}
Island.__index = Island

function Island.create(i, x, y)
   local o = {}             -- our new object
   setmetatable(o, Island)  
   o.idx = i
   -- o.posx = math.random(600) + 100 
   -- o.posy = math.random(400) + 100
   o.posx = x
   o.posy = y
   o.img = love.graphics.newImage("/Assets/Island_Smaller.png")
   o.addon = nil
   o.visible = true
   return o
end

function Island:getPosition()
	return {self.posx, self. posy}
end

function Island:addon(obj)
	self.addon = obj
end

function Island:ripple(strength)
	-- if self.addon == nil then
	-- 	return
	-- end
	local rad_base = 50
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(14, 63, 111)
	for i=1,strength do
		-- love.graphics.circle( "line", self.posx+100, self.posy+100, rad_base)
		love.graphics.ellipse( "line", self.posx+65, self.posy+70, rad_base + math.random(10), rad_base/2 + math.random(5))
		rad_base = rad_base + 10
	end
	love.graphics.setColor(r, g, b, a);
end

function Island:draw()
	-- if self.visible == true then
	    love.graphics.draw(self.img, self.posx - 25, self.posy - 30, 0, 0.1, 0.1, 0, 0)
	-- end
end
