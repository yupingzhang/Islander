-- Credit: http://nova-fusion.com/2011/04/19/cameras-in-love2d-part-1-the-basics/

Camera = {}
Camera.__index = Camera

function Camera.new ()
    local c = {}
    setmetatable(c, Camera) 
    c.x = 0
    c.y = 0
    c.scaleX = 1
    c.scaleY = 1
    c.rotation = 0
    return c
end

function Camera:set()
  love.graphics.push()
  love.graphics.rotate( -self.rotation )
  love.graphics.scale( 1 / self.scaleX, 1 / self.scaleY )
  love.graphics.translate( -self.x, -self.y )
end

function Camera:unset()
  love.graphics.pop()
end

function Camera:move(dx, dy)
  self.x = self.x + (dx or 0)
  self.y = self.y + (dy or 0)
end

function Camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function Camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function Camera:getPosition()
  return self.x, self.y 
end 

function Camera:setPosition(x, y)
  self.x = x or self.x
  self.y = y or self.y
end

function Camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end