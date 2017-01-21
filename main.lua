require 'math'
require 'Player'
require "Obstacle"
-- require "Addon"

require 'Ship'

-- const
local ocean_waves_dir = {1, 0}
local ocean_waves_speed = 50
local num_ships = 5
local num_obs = 10
local map_display_h = 4
local map_display_w = 4

-- giving the character position, center the camera and only draw the tiles visiable
function draw_map(pos)
  -- Tile-based Scrolling map
  local tile_w = 200
  local tile_h = 200
  -- window_size = { love.graphics.getWidth(), love.graphics.getHeight() }
  -- num_tiles = window_size / tile_w
  tile = love.graphics.newImage("/Assets/wavesTiled.png")
  for y=1, map_display_h do
      for x=1, map_display_w do                                                         
         love.graphics.draw( tile, ((x-1)*tile_w), ((y-1)*tile_h), 0, 0.1, 0.1, 0, 0)
      end
   end
end

function createScene()
	-- character
  player_main = Player.new ()  


	-- create an array of obstacles
	obs = {}
	for i=1,num_obs do
		obs[i] = Obstacle.create(i) 
	end
   
  -- array of ships 
  ships = {}
  for i=1,num_ships do
	 	ships[i] = Ship.create(i) 
	end


end

function love.load()

   math.randomseed( os.time() )
   -- local f = love.graphics.newFont(12)
   -- love.graphics.setFont(f)
   -- love.graphics.setColor(0,0,0,255)
   -- love.graphics.setBackgroundColor(255,255,255)

   createScene() 
end


-- key control

function love.update(dt)
    player_main:handleUpdate()

    for i=1,num_ships do
      ships[i]:move(ocean_waves_dir, ocean_waves_speed)
    end

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
    -- ocean map
    draw_map( player_main:getPosition() )

    -- obstacles
    for i=1, num_obs do
      obs[i]:draw()
    end

    for i=1,num_ships do
      ships[i]:draw()
    end

    player_main:draw()
end

