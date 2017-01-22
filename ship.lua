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
   s.sinkst = 0.0            -- sinking timer
   s.posx = math.random(800)      
   s.posy = math.random(600) 
   s.img = love.graphics.newImage("/Assets/ShellShip.png")
   s.img2 = love.graphics.newImage("/Assets/ShellShip_sink.png")
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
   local ratio = self.sinkst / sink_limit
   if ratio > 0.5 then
      return true
   else 
      return false
   end
end


function Ship:draw()
   if self.active and Ship:sinking() then
      love.graphics.draw(self.img2, self.posx, self.posy, 0, 0.1, 0.1, 0, 0)
   else
   	love.graphics.draw(self.img, self.posx, self.posy, 0, 0.1, 0.1, 0, 0)
   end
end

