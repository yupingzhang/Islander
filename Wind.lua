--require 'timer'
require 'math'

-- Meta class
Wind = {}
Wind.__index = Wind


function Wind.create(pos, dir)
   local w = {}             -- our new object
   setmetatable(w, Wind)  
   w.posx = pos[1] + math.random(300)      
   w.posy = pos[2] + math.random(200) 
   w.dir = dir
   w.img = love.graphics.newImage("/Assets/Wind.png")
   return w
end


function Wind:update()
	-- update pos
   local speed = 1
	self.posx = self.posx + ( self.dir[1] * speed )
	self.posy = self.posy + ( self.dir[2] * speed )
end


function Wind:draw()
   	love.graphics.draw(self.img, self.posx, self.posy, 0, 0.1, 0.1, 0, 0)
end

