pico-8 cartridge // http://www.pico-8.com
version 35
__lua__

-- Global variables
MAP_X = 128
MAP_Y = 128
actors = {}

-- From zep
function make_actor(x, y)
  a={}
  a.x = x
  a.y = y
  a.dx = 0
  a.dy = 0
  a.spr = 0
  a.frame = 0
  a.t = 0
  a.inertia = 0.6
  a.bounce  = 1
  
  -- half-width and half-height
  -- slightly less than 0.5 so
  -- that will fit through 1-wide
  -- holes.
  a.w = 0.4
  a.h = 0.4
  
  add(actors,a)
  
  return a
 end

 -- from zep
 function solid(x, y)
  -- grab the cell value
  val = mget(x, y)
  -- check if flag 1 is set
  return fget(val, 1)
  end
 
 -- from zep
 function solid_area(x,y,w,h)
  return 
    solid(x-w,y-h) or
    solid(x+w,y-h) or
    solid(x-w,y+h) or
    solid(x+w,y+h)
  end

 -- from zep
 function move_actor(a)
  -- only move actor along x
  -- if the resulting position
  -- will not overlap with a wall
  if not solid_area(a.x + a.dx, a.y, a.w, a.h) then
    a.x += a.dx
  else   
    -- otherwise bounce
    a.dx *= -a.bounce
  end

  -- ditto for y
  if not solid_area(a.x, a.y + a.dy, a.w, a.h) then
    a.y += a.dy
  else
    a.dy *= -a.bounce
  end

  a.dx *= a.inertia
  a.dy *= a.inertia
 
 -- advance one frame every
 -- time actor moves 1/4 of
 -- a tile
 
  a.frame += abs(a.dx) * 4
  a.frame += abs(a.dy) * 4
  a.frame %= 2 -- always 2 frames

  a.t += 1
end

function control_player(pl)
  -- how fast to accelerate
  accel = 0.1
  if (btn(0)) then pl.dx -= accel end
  if (btn(1)) then pl.dx += accel end
  if (btn(2)) then pl.dy -= accel end
  if (btn(3)) then pl.dy += accel end

end

function setup_map()
  wall = 0
end

function is_tile(tile_type, x, y)
  tile_x = x // 8
  tile_y = y // 8
  tile = mget(tile_x, tile_y)
  has_flag = fget(tile, tile_type)
  return has_flag
end

function can_move(x,y)
  return not is_tile(wall, x, y)
end

function update_pl()
  if (btn(0)) then pl.x -= 2 end
  if (btn(1)) then pl.x += 2 end
  if (btn(2)) then pl.y -= 2 end
  if (btn(3)) then pl.y += 2 end
end

function init_actors()
  pl = make_actor(2, 2)
  pl.spr = 0
end

function draw_actor(a)
  local sx = (a.x * 8) - 4
  local sy = (a.y * 8) - 4
  spr(a.spr + a.frame, sx, sy)
end

function _init()
  pl = make_actor(2, 2)
  pl.spr = 0
end

function _update()
  control_player(pl)
  foreach(actors, move_actor)
end

function _draw()
  cls()
  map(0,0,0,0,16,16)
  foreach(actors, draw_actor)
end