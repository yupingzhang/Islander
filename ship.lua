require 'math'

-- Meta class
Ship = {}
Ship.__index = Ship

function Ship.create(i)
   local s = {}             -- our new object
   setmetatable(s, Ship)  
   s.idx = i
   s.posx = math.random(800)      
   s.posy = math.random(600) 
   s.img = love.graphics.newImage("a.png")
   return s
end

function Ship:move(dir, speed)
	-- update pos
	self.posx = self.posx + ( dir[1] * speed );
	self.posy = self.posy + ( dir[2] * speed );

   if self.posx > 800 then
      self.posx = 0  
      self.posy = math.random(600) 
   end
end


function Ship:draw()
	love.graphics.draw(self.img, self.posx, self.posy, 0, 0.2, 0.2, 0, 0)
end