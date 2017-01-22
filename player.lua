require 'math'

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
    player.delx = 0
    player.dely = 0
    player.img = Player.loadImages()
    player.onShip = 0      
    player.onIsland = 1
    return player
end

function Player:handleUpdate()
	-- no move when on a ship
	if self.onShip > 0 then
		return
	end

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

function Player:setPosition(pos)
	self.posx = pos[1]
	self.posy = pos[2]
end

-- check if the character is on anything and not falling into the ocean
function Player:aliveCheck(pos)
    -- 1. on a island and fall into ocean
	local threshold = 50
	if	self.onIsland > 0 then
		local a = pos[1] - self.posx
		local b = pos[2] - self.posy
		if math.abs(a) > threshold or math.abs(b) > threshold then
            return false
		end
	end
    -- 2. on a ship and ship sank
    -- handled in the main love.update
	return true -- alive
end

function Player:jumpCheck()
	if self.onShip > 0 then
		return "island"
	else
		return "ship"
	end
end

-- update ship/island index
function Player:jumpTo(type, index)
	if type == "ship" then
	    self.onShip = index
	    self.onIsland = 0
	else
		self.onIsland = index
		self.onShip = 0
	end
end


function Player:draw()
    --love.graphics.print("Islander", 400, 300)
    love.graphics.draw(self.img, self.posx, self.posy, 0, 0.1, 0.1, 0, 0)
    -- for animation, use an array for img, update the current active img index
end
