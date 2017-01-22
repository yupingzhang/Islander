--require 'timer'
require 'math'

-- Meta class
Wind = {}
Wind.__index = Wind


function Wind.create(i)
   local w = {}             -- our new object
   setmetatable(w, Wind)  
   w.posx = math.random(800)      
   w.posy = math.random(600) 
   w.img = love.graphics.newImage("/Assets/ShellShip.png")
   return w
end

function Wind:move(dir, speed, active)
	-- update pos
	self.posx = self.posx + ( dir[1] * speed );
	self.posy = self.posy + ( dir[2] * speed );

   -- if still active, generate new wind
   if active and self.posx > 800 then
      self.posx = 0  
      self.posy = math.random(600) 
   end
end


function Wind:draw()
   	love.graphics.draw(self.img, self.posx, self.posy, 0, 0.1, 0.1, 0, 0)
end

