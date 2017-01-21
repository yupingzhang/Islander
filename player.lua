Player = {}
Player.__index = Player

-- Derived class method new
function Player.loadImages()
	return love.graphics.newImage("/Assets/Idle/Islander_Idle_Up.png")
end

function Player.new ()
	local player = {}
	setmetatable(player, Player) 
    player.posx = 50
    player.posy = 50
    -- p_img = love.graphics.newImage("a.png")
    player.img = Player.loadImages()
    return player
end

function Player:handleUpdate()
	local dt = 0.01
	local speed = 300
	if love.keyboard.isDown("right") then
	  self.posx = self.posx + (speed * dt)
	end
	if love.keyboard.isDown("left") then
	  self.posx = self.posx - (speed * dt)
	end
	if love.keyboard.isDown("down") then
	  self.posy = self.posy + (speed * dt)
	end
	if love.keyboard.isDown("up") then
	  self.posy = self.posy - (speed * dt)
	end
end

function Player:getPosition()
	local pos = { self.posx, self.posy }
	return pos
end

-- check if the character is on anything and not falling into the ocean
function alivechecking()
	-- body
end

function Player:draw()
    --love.graphics.print("Islander", 400, 300)
    love.graphics.draw(self.img, self.posx, self.posy, 0, 0.1, 0.1, 0, 0)
    -- for animation, use an array for img, update the current active img index
end
