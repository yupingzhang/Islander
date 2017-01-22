--require 'timer'
require 'math'

-- Meta class
Ship = {}
Ship.__index = Ship

local sink_limit = 20  -- seconds

function Ship.create(i)
   local s = {}              -- our new object
   setmetatable(s, Ship)  
   s.idx = i
   s.active = false          -- flag whether character is on the ship
   s.sank = false
   s.sinkst = 0.0            -- sinking timer
   s.posx = math.random(800)      
   s.posy = math.random(600) 
   s.img = love.graphics.newImage("/Assets/ShellShip-unsank.png")
   s.img2 = love.graphics.newImage("/Assets/ShellShip-sank.png")
   s.img3 = love.graphics.newImage("/Assets/ShellShip-sankest.png")
   return s
end

function Ship:move(wave_dir, wind_dir, speed)
   local dir = { wave_dir[1] + wind_dir[1], wave_dir[2] + wind_dir[2] }
	-- update pos
	self.posx = self.posx + ( dir[1] * speed );
	self.posy = self.posy + ( dir[2] * speed );

   if self.posx > 800 then
      self.posx = 0  
      self.posy = math.random(600) 
   end
end


function Ship:getPosition()
   return { self.posx, self.posy }
end


function  Ship:sinking()
   if self.sinkst == nil then 
      self.sinkst = 0.0 
   else
      self.sinkst = self.sinkst + love.timer.getDelta()
   end
   return (self.sinkst / sink_limit)
end


function Ship:draw()
   if self.active then
      if Ship:sinking() > 0.99 then
         self.sank = true               -- update if the ship sank
         return
      end
      if Ship:sinking() > 0.8 then
         love.graphics.draw(self.img3, self.posx, self.posy, 0, 0.1, 0.1, 0, 0) 
      elseif Ship:sinking() > 0.4 then
         love.graphics.draw(self.img2, self.posx, self.posy, 0, 0.1, 0.1, 0, 0)
      end
   else
   	love.graphics.draw(self.img, self.posx, self.posy, 0, 0.1, 0.1, 0, 0)
   end
end

