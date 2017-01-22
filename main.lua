require 'math'
require 'Player'
require "Island"
require "Addon"
require 'Ship'
require 'wind'

-- debug
local debug_msg = ""

-- const
local wind_dir = {0, 0}
local wind_dir_scale = 0.005
local wind_tlimit = 1         -- time in seconds generating wind per stroke
local ocean_waves_dir = {1, 0}
local ocean_waves_speed = 1
local num_ships = 5
local num_islands = 10
local map_display_h = 3
local map_display_w = 4
local window_size = { love.graphics.getWidth(), love.graphics.getHeight() }

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
  player = Player.new ()

	-- create an array of islands
	islands = {}
	for i=1,num_islands do
		islands[i] = Island.create(i) 
	end

  player:setPosition( {islands[2].posx + 25, islands[2].posy + 30} )
   
  -- array of ships 
  ships = {}
  for i=1,num_ships do
	 	ships[i] = Ship.create(i) 
	end

end


function love.load()
   -- random new seeds
   math.randomseed( os.time() )
   has_wind = false
   wind_st = {0, 0}
   start = love.timer.getTime()

   createScene() 
end

-- when the jump gets triggered
-- check the type of object that the character allows to jump to
function findnearestshipisland(pos, type)
    local distance = 100.0   -- threshold
    local index = 0;

    if type == "island" then
      for i=1,num_islands do
        --dist = (pos[1] - [1]) * (pos[1] - islands[i][1]) + (pos[2] - islands[i][2]) * (pos[2] - islands[i][2]) 
        -- if dist < distance then
        --   distance = dist
        --   index = i
        -- end
      end
    end

    if type == "ship" then
      for i=1, num_ships do
        ship_pos = ships[i]:getPosition()
        dist = (pos[1]-ship_pos[1])*(pos[1]-ship_pos[1]) + (pos[2]-ship_pos[2])*(pos[2]-ship_pos[2]) 
        if dist < distance then
          distance = dist
          index = i
        end
      end
    end

    return index
end


function love.update(dt)
    player:handleUpdate()
    
    -- wind control reset
    curr = love.timer.getTime()
    if has_wind then
       if (curr - start) > wind_tlimit then
          has_wind = false
       end
    end

    for i=1,num_ships do
        ships[i]:move(ocean_waves_dir, wind_dir, ocean_waves_speed)
        if player.onShip == i then
          player.move( ships[i].getPosition() )
        end
    end

end

function love.keypressed(key)
   if key == "escape" then
      love.event.quit()
   end
   if key == "space" then
      local type = player:jumpCheck()
      local player_pos = player:getPosition()
      local idx = findnearestshipisland(player_pos, type)
      player:jumpTo(idx)
   end
end

-- mouse control

function love.mousepressed(x, y, button, istouch)
   if button == 1 then
      wind_st[1] = x -- get the position
      wind_st[2] = y
   end
end

function love.mousereleased(x, y, button, istouch)
   if button == 1 then
      -- get the new position and compute the wind direction 
      wind_dir[1] = ( x - wind_st[1] ) * wind_dir_scale 
      wind_dir[2] = ( y - wind_st[2] ) * wind_dir_scale 
      has_wind = true
      start = love.timer.getTime()
   end
end


function love.draw()
    -- ocean map
    draw_map( player:getPosition() )

    -- islands
    for i=1, num_islands do
      islands[i]:ripple(5)
      islands[i]:draw()
    end

    for i=1,num_ships do
      ships[i]:draw()
    end

    player:draw()

    -- draw debug info
    -- love.graphics.setColor(0, 0, 255, 255)
    debug_msg = "Player status: onShip? %f" .. string.format("%f", player.onShip)
    -- love.graphics.printf(debug_msg, 78, 100, 100)
end

