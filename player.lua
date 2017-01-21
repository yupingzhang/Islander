-- Meta module
local Player = {}

-- Derived class method new
function Player.loadImages()
	p_img = love.graphics.newImage("a.png")
end

function Player.new ()
    posx = 50
    posy = 50
    -- p_img = love.graphics.newImage("a.png")
    Player.loadImages()
    return o
end

function Player.handleUpdate()
	local dt = 0.01
	local speed = 300
	if love.keyboard.isDown("right") then
	  posx = posx + (speed * dt)
	end
	if love.keyboard.isDown("left") then
	  posx = posx - (speed * dt)
	end
	if love.keyboard.isDown("down") then
	  posy = posy + (speed * dt)
	end
	if love.keyboard.isDown("up") then
	  posy = posy - (speed * dt)
	end
end

function Player.draw()
    --love.graphics.print("Islander", 400, 300)
    love.graphics.draw(p_img, posx, posy, 0, 0.5, 0.5, 0, 0)
end


return Player