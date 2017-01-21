local Player = require "Player"
-- require "Obstacle"
-- require "Addon"
-- require "Ship"

function createScene()
	-- body
	Player.new ()     
	-- player_env = 

	-- create an array of obstacles
	-- obs = {}
	-- for i=1,10 do
	-- 	obs[i] = Obstacle:new(i) 
	-- end

	-- ships = {}
 --    for i=1,10 do
	-- 	ships[i] = Ship:new(i) 
	-- end


end

function love.load()
   -- local f = love.graphics.newFont(12)
   -- love.graphics.setFont(f)
   -- love.graphics.setColor(0,0,0,255)
   -- love.graphics.setBackgroundColor(255,255,255)

   createScene() 
end


-- key control

function love.update(dt)
    Player.handleUpdate()

end

function love.keypressed(key)
   if key == "escape" then
      love.event.quit()
   end
end

-- mouse control

function love.mousepressed(x, y, button, istouch)
   if button == 1 then
      imgx = x -- get the position
      imgy = y
   end
end

function love.mousereleased(x, y, button, istouch)
   if button == 1 then
      -- get the new position and compute the wind direction 
   end
end


function love.draw()
    --love.graphics.print("Islander", 400, 300)
    --love.graphics.draw(image, x, y, 0, 0.5, 0.5, 0, 0)
    --Player.draw()
    Player.draw()
end