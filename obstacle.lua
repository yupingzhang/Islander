-- Meta class
-- can have add-on
-- can be step on by character
-- fixed location, cannot move
require 'math'

-- Meta class
Obstacle = {}
Obstacle.__index = Obstacle

function Obstacle.create(i)
   local o = {}             -- our new object
   setmetatable(o, Obstacle)  
   o.idx = i
   o.posx = math.random(800)      
   o.posy = math.random(600) 
   o.img = love.graphics.newImage("/Assets/Island_Small.png")
   return o
end

function Obstacle:addon()
end

function ripple(center, strength)
	-- body
end

function Obstacle:draw()
	love.graphics.draw(self.img, self.posx, self.posy, 0, 0.1, 0.1, 0, 0)
end