require 'math'
require 'Player'
require "Island"
require "Addon"
require 'Ship'
require 'Wind'
require 'Camera'

local util = require "Utility"

-- debug
local debug = false
local debug_msg = ""

-- const
local isalive = true
local wind_dir = {0, 0}
local wind_dir_scale = 0.005
local wind_tlimit = 15         -- time in seconds generating wind per stroke
local ocean_waves_dir = {1, 0}
local ocean_waves_speed = 1
local num_ships = 25
local num_islands = 10
local map_display_h = 3
local map_display_w = 4
local map_size = { 800, 2000 }
local window_size = { love.graphics.getWidth(), love.graphics.getHeight() } -- 800, 600

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
  -- camera
  cam = Camera.new ()

	-- character
  player = Player.new ()

	-- create an array of islands
  islands = {}
  random_pos = util.randomControl(map_size[1], map_size[2], num_islands)
  -- create the start point
  islands[1] = Island.create(1, 200, 1900)
	for i=2,num_islands do
		islands[i] = Island.create(i, random_pos[i][1], random_pos[i][2]) 
	end
  -- create the end destination
  islands[num_islands + 1] = Island.create(num_islands + 1, map_size[1] - 300, map_size[2] - 300)
  islands[num_islands + 1]:initTemple()

  player:setPosition( {islands[1].posx, islands[1].posy} ) 
  cam:setPosition(0, 0)  -- {islands[1].posx, islands[1].posy} 
   
  -- array of ships 
  random_pos = util.randomControl(map_size[1], map_size[2], num_ships)
  ships = {}
  for i=1,num_ships do
	 	ships[i] = Ship.create(i, random_pos[i][1], random_pos[i][2]) 
	end

end


function love.load()
   -- random new seeds
   math.randomseed( os.time() )
   has_wind = false
   wind_st = {0, 0}
   start = love.timer.getTime()
   wind = {}

   -- create scene
   createScene() 

   -- audio
   sound = love.audio.newSource("/Sound/Fearless.mp3", "static")
   -- sound:play()
end

-- when the jump gets triggered
-- check the type of object that the character allows to jump to
function findnearestshipisland(pos, type)
    local island_threshold = 600.0   -- threshold
    local ship_threshold = 500.0   -- threshold
    local index = 0;
    if type == "island" then
      for i=1,num_islands do
        island_pos = islands[i]:getPosition()
        dist = (pos[1] - island_pos[1]) * (pos[1] - island_pos[1]) + (pos[2] - island_pos[2]) * (pos[2] - island_pos[2]) 
        if dist < island_threshold then
          distance = dist
          index = i
        end
      end
    end

    if type == "ship" then
      for i=1, num_ships do
        ship_pos = ships[i]:getPosition()
        dist = (pos[1]-ship_pos[1])*(pos[1]-ship_pos[1]) + (pos[2]-ship_pos[2])*(pos[2]-ship_pos[2]) 
        if dist < ship_threshold then
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
    if has_wind and next(wind) ~= nil then
       for i=1,10 do
         wind[i]:update()
       end
       if (curr - start) > wind_tlimit then
          has_wind = false
       end
    end

    for i=1,num_ships do
        ships[i]:move(ocean_waves_dir, wind_dir, ocean_waves_speed)
        if player.onShip == i then
          local shipPosition = ships[i]:getPosition()
          local offset_shipPosition = {shipPosition[1] - 5, shipPosition[2] - 20} 
          player:setPosition( offset_shipPosition )
        end
    end

    -- isalive check
    if player.onShip > 0 then
       isalive = not ships[player.onShip].sank
    elseif player.onIsland > 0 then
       isalive = player:aliveCheck(islands[player.onIsland]:getPosition())
    end
    if isalive == false then
       player:die()
       return
    end

    -- update camera
    local p = player:getPosition()
    cam:setPosition( (p[1] - 400)/10, p[2] - 400 )

end

function love.keypressed(key)
   if key == "escape" then
      love.event.quit()
   end
   if key == "space" then
      local type = player:jumpCheck()
      local player_pos = player:getPosition()
      local idx = findnearestshipisland(player_pos, type)
      if idx ~= 0 then
         if type == "ship" then
            ships[idx].active = true  -- active sinking
         elseif type  == "island" then
            ships[player.onShip].active = false
         end
         player:jumpTo(type, idx)
         
      end
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

      for i=1,10 do
        wind[i] = Wind.create( player:getPosition(), wind_dir )
      end
   end
end


function love.draw()
    -- ocean map
    draw_map( player:getPosition() )
    local x, y = cam:getPosition()
    debug_msg = "camera info: " .. string.format("%s", cam.x)
     
    cam:set()
    -- draw stuff

    -- islands
    for i=1, num_islands do
      islands[i]:ripple(5)
      islands[i]:draw()
    end

    for i=1,num_ships do
      ships[i]:draw()
    end

    if has_wind and next(wind) ~= nil then
      for i=1,10 do
        wind[i]:draw()
      end 
    end

    if isalive == true then
       player:draw()
    else 
       player:draw()
       _img = love.graphics.newImage("/Assets/gameover.png")
       love.graphics.draw( _img, cam.x, cam.y, 0, 0.5, 0.5, 0, 0 )
       -- local r, g, b, a = love.graphics.getColor()
       -- love.graphics.setColor(0, 0, 0, 255)
       -- love.graphics.printf("Game over!!!", 200, 250, 400, "left", 0, 5, 5, 0, 0, 0, 0)
       -- love.graphics.setColor(r, g, b, a)
    end

    cam:unset()

    -- draw debug info
    if debug == true then
      local r, g, b, a = love.graphics.getColor()
      love.graphics.setColor(0, 0, 0, 255)
      -- debug_msg = "Player status: onShip? onIsland? " .. string.format("%f", player.onShip) .. string.format("%f", player.onIsland) .. "Isalive: " .. string.format("%s", isalive)
      -- debug_msg = "Island: " .. string.format("%f %f", islands[2].posx, islands[2].posy)
      love.graphics.printf(debug_msg, 200, 200, 400, "left")
      love.graphics.setColor(r, g, b, a)
    end

end

